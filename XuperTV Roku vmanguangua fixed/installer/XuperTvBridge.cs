using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Net;
using System.Net.NetworkInformation;
using System.Net.Sockets;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Web.Script.Serialization;
using System.Windows.Forms;

namespace XuperTvBridge
{
    internal static class Program
    {
        [STAThread]
        private static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new BridgeForm());
        }
    }

    public class BridgeForm : Form
    {
        private const int DefaultPort = 8787;

        private Label lblStatus;
        private Label lblIpPort;
        private Label lblEncoder;
        private Label lblStream;
        private Button btnToggle;
        private Button btnFirewall;
        private Button btnStopStream;
        private TextBox txtLog;

        private TcpListener listener;
        private volatile bool running = false;
        private Thread acceptThread;

        private string ffmpegPath = null;
        private string encoderName = "libx264";
        private string localIp = "127.0.0.1";

        private readonly object procLock = new object();
        private Process activeFfmpeg = null;
        private string activeSid = null;
        private string activeDir = null;
        private string activeTitle = "";
        private volatile bool activeExited = false;
        private int activeExitCode = 0;

        private static readonly Color BgDark = Color.FromArgb(8, 14, 30);
        private static readonly Color CardBg = Color.FromArgb(15, 25, 48);
        private static readonly Color InputBg = Color.FromArgb(22, 36, 68);
        private static readonly Color AccentBlue = Color.FromArgb(14, 165, 233);
        private static readonly Color SuccessGreen = Color.FromArgb(52, 211, 153);
        private static readonly Color WarnGold = Color.FromArgb(255, 200, 61);
        private static readonly Color ErrorRed = Color.FromArgb(255, 90, 110);
        private static readonly Color TextLight = Color.FromArgb(248, 250, 252);
        private static readonly Color TextMuted = Color.FromArgb(148, 163, 184);

        public BridgeForm()
        {
            InitializeUi();
            this.Load += (s, e) => BeginSetup();
            this.FormClosing += (s, e) => ShutdownAll();
        }

        private void InitializeUi()
        {
            this.Text = "XuperTV · Puente PC (HEVC → H.264) · v47 Edición Manguangua";
            this.Size = new Size(640, 520);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.BackColor = BgDark;
            this.ForeColor = TextLight;
            this.Font = new Font("Segoe UI", 9.5f);
            this.FormBorderStyle = FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;

            Panel header = new Panel { Dock = DockStyle.Top, Height = 72, BackColor = Color.FromArgb(6, 11, 24) };
            header.Controls.Add(new Panel { Dock = DockStyle.Bottom, Height = 2, BackColor = AccentBlue });
            header.Controls.Add(new Label
            {
                Text = "XuperTV  ·  Puente PC para Películas y Series HEVC",
                Font = new Font("Segoe UI", 13.5f, FontStyle.Bold),
                ForeColor = TextLight,
                Location = new Point(20, 11),
                AutoSize = true
            });
            header.Controls.Add(new Label
            {
                Text = "Edición Manguangua (by wastrike)  ·  Convierte H.265 a H.264 al vuelo para tu Roku",
                Font = new Font("Segoe UI", 9.2f),
                ForeColor = AccentBlue,
                Location = new Point(22, 40),
                AutoSize = true
            });
            this.Controls.Add(header);

            Panel card = new Panel { Location = new Point(20, 88), Size = new Size(584, 152), BackColor = CardBg };
            lblStatus = new Label
            {
                Text = "Iniciando puente...",
                Font = new Font("Segoe UI", 11f, FontStyle.Bold),
                ForeColor = WarnGold,
                Location = new Point(16, 14),
                Size = new Size(550, 26)
            };
            lblIpPort = new Label
            {
                Text = "Dirección para el Roku: detectando...",
                ForeColor = TextLight,
                Location = new Point(16, 46),
                Size = new Size(550, 22)
            };
            lblEncoder = new Label
            {
                Text = "Codificador FFmpeg: detectando...",
                ForeColor = TextMuted,
                Location = new Point(16, 72),
                Size = new Size(550, 22)
            };
            lblStream = new Label
            {
                Text = "Transmisión activa: en espera de conexión desde el Roku",
                ForeColor = TextMuted,
                Location = new Point(16, 98),
                Size = new Size(550, 22)
            };
            card.Controls.Add(lblStatus);
            card.Controls.Add(lblIpPort);
            card.Controls.Add(lblEncoder);
            card.Controls.Add(lblStream);
            this.Controls.Add(card);

            btnToggle = MakeBtn("Detener Puente", 20, 252, 165, 36, AccentBlue);
            btnToggle.Click += (s, e) => { if (running) StopServer(); else StartServer(); };
            this.Controls.Add(btnToggle);

            btnStopStream = MakeBtn("Cortar video actual", 196, 252, 165, 36, InputBg);
            btnStopStream.Click += (s, e) => { KillActiveStream(); SetStreamLabel("Transmisión activa: detenida"); };
            this.Controls.Add(btnStopStream);

            btnFirewall = MakeBtn("Abrir puerto 8787 (Firewall)", 372, 252, 232, 36, InputBg);
            btnFirewall.Click += BtnFirewall_Click;
            this.Controls.Add(btnFirewall);

            txtLog = new TextBox
            {
                Location = new Point(20, 300),
                Size = new Size(584, 166),
                Multiline = true,
                ReadOnly = true,
                ScrollBars = ScrollBars.Vertical,
                BackColor = Color.FromArgb(6, 10, 20),
                ForeColor = Color.FromArgb(203, 213, 225),
                BorderStyle = BorderStyle.FixedSingle,
                Font = new Font("Consolas", 8.8f)
            };
            this.Controls.Add(txtLog);
        }

        private Button MakeBtn(string text, int x, int y, int w, int h, Color bg)
        {
            Button b = new Button
            {
                Text = text,
                Location = new Point(x, y),
                Size = new Size(w, h),
                FlatStyle = FlatStyle.Flat,
                BackColor = bg,
                ForeColor = TextLight,
                Font = new Font("Segoe UI", 9.3f, FontStyle.Bold),
                Cursor = Cursors.Hand
            };
            b.FlatAppearance.BorderSize = 0;
            return b;
        }

        private void BeginSetup()
        {
            ThreadPool.QueueUserWorkItem(_ =>
            {
                localIp = DetectLanIp();
                ffmpegPath = FindFfmpeg();
                if (!string.IsNullOrEmpty(ffmpegPath))
                {
                    encoderName = DetectEncoder(ffmpegPath);
                }
                CleanupOldTempDirs();
                BeginInvoke(new Action(() =>
                {
                    lblIpPort.Text = string.Format("Dirección para el Roku:  {0}:{1}", localIp, DefaultPort);
                    if (string.IsNullOrEmpty(ffmpegPath))
                    {
                        lblStatus.Text = "No se encontró ffmpeg.exe";
                        lblStatus.ForeColor = ErrorRed;
                        lblEncoder.Text = "Instala FFmpeg o coloca ffmpeg.exe junto a este programa.";
                        Log("ERROR: ffmpeg.exe no encontrado.");
                        return;
                    }
                    lblEncoder.Text = string.Format("Codificador activo: {0}  ({1})", encoderName, Path.GetFileName(ffmpegPath));
                    lblEncoder.ForeColor = encoderName == "h264_qsv" ? SuccessGreen : TextMuted;
                    StartServer();
                }));
            });
        }

        private void StartServer()
        {
            if (running) return;
            try
            {
                listener = new TcpListener(IPAddress.Any, DefaultPort);
                listener.Start(32);
                running = true;
                acceptThread = new Thread(AcceptLoop) { IsBackground = true };
                acceptThread.Start();
                lblStatus.Text = string.Format("✓ Puente activo en {0}:{1} — Deja esta ventana abierta", localIp, DefaultPort);
                lblStatus.ForeColor = SuccessGreen;
                btnToggle.Text = "Detener Puente";
                btnToggle.BackColor = Color.FromArgb(185, 28, 48);
                Log(string.Format("Servidor listo en http://{0}:{1}/ping (codec: {2})", localIp, DefaultPort, encoderName));
            }
            catch (Exception ex)
            {
                lblStatus.Text = "No se pudo abrir el puerto " + DefaultPort;
                lblStatus.ForeColor = ErrorRed;
                Log("Error iniciando puerto " + DefaultPort + ": " + ex.Message);
            }
        }

        private void StopServer()
        {
            running = false;
            try { if (listener != null) listener.Stop(); } catch { }
            KillActiveStream();
            lblStatus.Text = "Puente detenido";
            lblStatus.ForeColor = WarnGold;
            btnToggle.Text = "Iniciar Puente";
            btnToggle.BackColor = AccentBlue;
            SetStreamLabel("Transmisión activa: detenida");
            Log("Puente detenido.");
        }

        private void ShutdownAll()
        {
            running = false;
            try { if (listener != null) listener.Stop(); } catch { }
            KillActiveStream();
        }

        private void AcceptLoop()
        {
            while (running)
            {
                try
                {
                    TcpClient client = listener.AcceptTcpClient();
                    ThreadPool.QueueUserWorkItem(_ => HandleClient(client));
                }
                catch
                {
                    if (!running) break;
                }
            }
        }

        private void HandleClient(TcpClient client)
        {
            try
            {
                client.ReceiveTimeout = 10000;
                client.SendTimeout = 15000;
                using (client)
                using (NetworkStream ns = client.GetStream())
                {
                    string method;
                    string path;
                    Dictionary<string, string> hdrs;
                    byte[] body;
                    if (!ReadHttpRequest(ns, out method, out path, out hdrs, out body)) return;

                    int qIdx = path.IndexOf('?');
                    if (qIdx >= 0) path = path.Substring(0, qIdx);

                    if (method == "GET" && path == "/ping")
                    {
                        string json = new JavaScriptSerializer().Serialize(new
                        {
                            ok = true,
                            name = "XuperTV-Puente-PC",
                            encoder = encoderName,
                            ip = localIp,
                            port = DefaultPort
                        });
                        SendJson(ns, 200, json);
                        return;
                    }

                    if (method == "POST" && path == "/stop")
                    {
                        KillActiveStream();
                        SetStreamLabel("Transmisión activa: en espera de conexión desde el Roku");
                        SendJson(ns, 200, "{\"ok\":true}");
                        return;
                    }

                    if (method == "POST" && path == "/session")
                    {
                        string rawJson = Encoding.UTF8.GetString(body ?? new byte[0]);
                        string reqHost = hdrs.ContainsKey("Host") ? hdrs["Host"] : (localIp + ":" + DefaultPort);
                        HandleSession(ns, rawJson, reqHost);
                        return;
                    }

                    if (method == "GET" && path.StartsWith("/hls/", StringComparison.OrdinalIgnoreCase))
                    {
                        HandleHlsFile(ns, path);
                        return;
                    }

                    SendText(ns, 404, "text/plain", "Not Found");
                }
            }
            catch { }
        }

        private void HandleSession(NetworkStream ns, string rawJson, string reqHost)
        {
            if (string.IsNullOrEmpty(ffmpegPath))
            {
                SendJson(ns, 500, "{\"ok\":false,\"error\":\"ffmpeg_no_encontrado\"}");
                return;
            }
            JavaScriptSerializer ser = new JavaScriptSerializer();
            Dictionary<string, object> reqObj = ser.Deserialize<Dictionary<string, object>>(rawJson);
            if (reqObj == null)
            {
                SendJson(ns, 400, "{\"ok\":false,\"error\":\"json_invalido\"}");
                return;
            }

            string title = reqObj.ContainsKey("title") && reqObj["title"] != null ? reqObj["title"].ToString() : "Video HEVC";
            int startSec = 0;
            if (reqObj.ContainsKey("startSec") && reqObj["startSec"] != null)
            {
                int.TryParse(reqObj["startSec"].ToString(), out startSec);
            }

            List<string> urls = new List<string>();
            if (reqObj.ContainsKey("urls") && reqObj["urls"] is System.Collections.ArrayList)
            {
                foreach (object u in (System.Collections.ArrayList)reqObj["urls"])
                {
                    if (u != null && !string.IsNullOrWhiteSpace(u.ToString())) urls.Add(u.ToString().Trim());
                }
            }
            if (urls.Count == 0 && reqObj.ContainsKey("url") && reqObj["url"] != null)
            {
                urls.Add(reqObj["url"].ToString().Trim());
            }
            if (urls.Count == 0)
            {
                SendJson(ns, 400, "{\"ok\":false,\"error\":\"sin_url\"}");
                return;
            }

            List<Dictionary<string, string>> headerList = new List<Dictionary<string, string>>();
            if (reqObj.ContainsKey("headerList") && reqObj["headerList"] is System.Collections.ArrayList)
            {
                foreach (object hObj in (System.Collections.ArrayList)reqObj["headerList"])
                {
                    headerList.Add(ToStrDict(hObj));
                }
            }
            Dictionary<string, string> defaultHeaders = reqObj.ContainsKey("headers") ? ToStrDict(reqObj["headers"]) : new Dictionary<string, string>();

            Log(string.Format("Solicitud Roku: {0} ({1} fuentes)", title, urls.Count));
            SetStreamLabel(string.Format("Transmisión activa: preparando {0}...", title));

            string[] encodersToTry = encoderName == "libx264" ? new[] { "libx264" } : new[] { encoderName, "libx264" };
            int maxUrls = Math.Min(urls.Count, 3);

            for (int ui = 0; ui < maxUrls; ui++)
            {
                string srcUrl = urls[ui];
                Dictionary<string, string> hdrs = (ui < headerList.Count && headerList[ui].Count > 0) ? headerList[ui] : defaultHeaders;

                foreach (string enc in encodersToTry)
                {
                    string sid = Guid.NewGuid().ToString("N").Substring(0, 12);
                    string dir = Path.Combine(GetBridgeTempRoot(), sid);
                    Directory.CreateDirectory(dir);

                    if (LaunchTranscode(sid, dir, title, srcUrl, hdrs, enc, startSec))
                    {
                        string hostHeader = !string.IsNullOrWhiteSpace(reqHost) ? reqHost : (localIp + ":" + DefaultPort);
                        string playUrl = "http://" + hostHeader + "/hls/" + sid + "/index.m3u8";
                        Log(string.Format("Listo [{0}] -> {1}", enc, playUrl));
                        SetStreamLabel(string.Format("Transmitiendo ({0}): {1}", enc, title));
                        string okJson = ser.Serialize(new { ok = true, sid = sid, playUrl = playUrl, encoder = enc });
                        SendJson(ns, 200, okJson);
                        return;
                    }
                    else
                    {
                        KillActiveStream();
                    }
                }
            }

            SetStreamLabel("Transmisión activa: error al iniciar fuente");
            SendJson(ns, 502, "{\"ok\":false,\"error\":\"transcode_fallo\"}");
        }

        private bool LaunchTranscode(string sid, string dir, string title, string srcUrl, Dictionary<string, string> hdrs, string enc, int startSec)
        {
            KillActiveStream();

            StringBuilder hdrArg = new StringBuilder();
            foreach (var kv in hdrs)
            {
                hdrArg.Append(kv.Key).Append(": ").Append(kv.Value).Append("\r\n");
            }

            string vEncArgs;
            if (enc == "h264_qsv")
            {
                vEncArgs = "-vf \"scale=-2:min(1080\\,ih),format=nv12\" -c:v h264_qsv -profile:v high -level 4.1 -preset veryfast -b:v 4500k -maxrate 6000k -bufsize 9000k -g 48";
            }
            else if (enc == "h264_nvenc")
            {
                vEncArgs = "-vf \"scale=-2:min(1080\\,ih),format=yuv420p\" -c:v h264_nvenc -profile:v high -level 4.1 -preset p3 -b:v 4500k -maxrate 6000k -bufsize 9000k -g 48";
            }
            else
            {
                vEncArgs = "-vf \"scale=-2:min(1080\\,ih),format=yuv420p\" -c:v libx264 -profile:v high -level 4.1 -preset veryfast -crf 22 -maxrate 5500k -bufsize 9000k -g 48";
            }

            string seekArg = startSec > 0 ? string.Format("-ss {0} ", startSec) : "";
            string segTpl = Path.Combine(dir, "seg_%05d.ts");
            string m3u8Path = Path.Combine(dir, "index.m3u8");
            string escapedHdr = hdrArg.ToString().Replace("\"", "\\\"");

            string args = string.Format(
                "-hide_banner -y -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 2 -headers \"{0}\" {1}-i \"{2}\" " +
                "-map 0:v:0 -map 0:a:0? {3} -c:a aac -ac 2 -b:a 192k " +
                "-f hls -hls_time 2 -hls_list_size 0 -hls_playlist_type event -hls_segment_filename \"{4}\" \"{5}\"",
                escapedHdr, seekArg, srcUrl, vEncArgs, segTpl, m3u8Path);

            ProcessStartInfo psi = new ProcessStartInfo
            {
                FileName = ffmpegPath,
                Arguments = args,
                UseShellExecute = false,
                RedirectStandardError = true,
                RedirectStandardOutput = false,
                CreateNoWindow = true
            };

            Process proc = new Process { StartInfo = psi, EnableRaisingEvents = true };
            lock (procLock)
            {
                activeFfmpeg = proc;
                activeSid = sid;
                activeDir = dir;
                activeTitle = title;
                activeExited = false;
                activeExitCode = 0;
            }

            string ffLogPath = Path.Combine(GetBridgeTempRoot(), "last_ffmpeg.log");
            StreamWriter ffLog = null;
            try { ffLog = new StreamWriter(ffLogPath, false, Encoding.UTF8) { AutoFlush = true }; } catch { }
            if (ffLog != null) { try { ffLog.WriteLine("ARGS: " + args); } catch { } }

            proc.ErrorDataReceived += (s, ev) =>
            {
                if (ev.Data == null) return;
                if (ffLog != null) { try { ffLog.WriteLine(ev.Data); } catch { } }
                if (ev.Data.IndexOf("Error", StringComparison.OrdinalIgnoreCase) >= 0 || ev.Data.IndexOf("Invalid", StringComparison.OrdinalIgnoreCase) >= 0 || ev.Data.IndexOf("failed", StringComparison.OrdinalIgnoreCase) >= 0)
                {
                    Log("[ffmpeg] " + ev.Data);
                }
            };
            proc.Exited += (s, ev) =>
            {
                activeExited = true;
                try { activeExitCode = proc.ExitCode; } catch { }
                if (ffLog != null) { try { ffLog.Dispose(); } catch { } ffLog = null; }
            };

            proc.Start();
            proc.BeginErrorReadLine();

            string firstSegPath = Path.Combine(dir, "seg_00000.ts");
            DateTime deadline = DateTime.UtcNow.AddSeconds(14);
            while (DateTime.UtcNow < deadline && running)
            {
                if (File.Exists(m3u8Path) && File.Exists(firstSegPath))
                {
                    string txt = ReadSharedText(m3u8Path);
                    long segLen = 0;
                    try { segLen = new FileInfo(firstSegPath).Length; } catch { }
                    if (!string.IsNullOrEmpty(txt) && txt.IndexOf(".ts", StringComparison.OrdinalIgnoreCase) >= 0 && segLen > 2048 && txt.IndexOf("#EXTINF:0.000000", StringComparison.OrdinalIgnoreCase) < 0)
                    {
                        return true;
                    }
                }
                if (activeExited)
                {
                    Log(string.Format("ffmpeg salió prematuramente (code={0}, enc={1})", activeExitCode, enc));
                    return false;
                }
                Thread.Sleep(120);
            }

            Log(string.Format("Timeout esperando primer segmento ({0})", enc));
            return false;
        }

        private void HandleHlsFile(NetworkStream ns, string path)
        {
            // /hls/<sid>/<file>
            string[] parts = path.Split(new[] { '/' }, StringSplitOptions.RemoveEmptyEntries);
            if (parts.Length != 3)
            {
                SendText(ns, 404, "text/plain", "Bad path");
                return;
            }
            string sid = parts[1];
            string file = Path.GetFileName(parts[2]);

            string dirNow;
            lock (procLock)
            {
                if (activeSid != sid || string.IsNullOrEmpty(activeDir))
                {
                    SendText(ns, 404, "text/plain", "Session expired");
                    return;
                }
                dirNow = activeDir;
            }

            string full = Path.Combine(dirNow, file);
            DateTime waitUntil = DateTime.UtcNow.AddSeconds(4);
            while (!File.Exists(full) && DateTime.UtcNow < waitUntil && running && !activeExited)
            {
                Thread.Sleep(40);
            }
            if (!File.Exists(full))
            {
                SendText(ns, 404, "text/plain", "File not found");
                return;
            }

            if (file.EndsWith(".m3u8", StringComparison.OrdinalIgnoreCase))
            {
                string body = "";
                for (int k = 0; k < 8; k++)
                {
                    body = ReadSharedText(full);
                    if (!string.IsNullOrEmpty(body)) break;
                    Thread.Sleep(30);
                }
                SendText(ns, 200, "application/vnd.apple.mpegurl", body, "Cache-Control: no-cache\r\n");
            }
            else
            {
                byte[] data = ReadSharedBytes(full);
                if (data == null || data.Length == 0)
                {
                    SendText(ns, 503, "text/plain", "Segment busy");
                    return;
                }
                SendBytes(ns, 200, "video/mp2t", data, "Cache-Control: public, max-age=3600\r\n");
            }
        }

        private void KillActiveStream()
        {
            Process pToKill = null;
            string dirToClean = null;
            lock (procLock)
            {
                pToKill = activeFfmpeg;
                dirToClean = activeDir;
                activeFfmpeg = null;
                activeSid = null;
                activeDir = null;
            }
            if (pToKill != null)
            {
                try { if (!pToKill.HasExited) pToKill.Kill(); } catch { }
                try { pToKill.WaitForExit(1000); } catch { }
                try { pToKill.Dispose(); } catch { }
            }
            if (!string.IsNullOrEmpty(dirToClean))
            {
                ThreadPool.QueueUserWorkItem(_ =>
                {
                    Thread.Sleep(250);
                    try { if (Directory.Exists(dirToClean)) Directory.Delete(dirToClean, true); } catch { }
                });
            }
        }

        private static string GetBridgeTempRoot()
        {
            string root = Path.Combine(Path.GetTempPath(), "XuperTvBridge");
            Directory.CreateDirectory(root);
            return root;
        }

        private static void CleanupOldTempDirs()
        {
            try
            {
                string root = GetBridgeTempRoot();
                foreach (string d in Directory.GetDirectories(root))
                {
                    try { Directory.Delete(d, true); } catch { }
                }
            }
            catch { }
        }

        private static string ReadSharedText(string path)
        {
            try
            {
                using (FileStream fs = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.ReadWrite | FileShare.Delete))
                using (StreamReader sr = new StreamReader(fs, Encoding.UTF8))
                {
                    return sr.ReadToEnd();
                }
            }
            catch { return ""; }
        }

        private static byte[] ReadSharedBytes(string path)
        {
            for (int i = 0; i < 6; i++)
            {
                try
                {
                    using (FileStream fs = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.ReadWrite | FileShare.Delete))
                    using (MemoryStream ms = new MemoryStream())
                    {
                        fs.CopyTo(ms);
                        return ms.ToArray();
                    }
                }
                catch { Thread.Sleep(35); }
            }
            return null;
        }

        private static bool ReadHttpRequest(NetworkStream ns, out string method, out string path, out Dictionary<string, string> headers, out byte[] body)
        {
            method = "";
            path = "";
            headers = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
            body = null;

            List<byte> headerBuf = new List<byte>();
            byte[] one = new byte[1];
            int match = 0;
            while (headerBuf.Count < 32768)
            {
                int r = ns.Read(one, 0, 1);
                if (r <= 0) return false;
                byte b = one[0];
                headerBuf.Add(b);
                if ((match == 0 && b == '\r') || (match == 1 && b == '\n') || (match == 2 && b == '\r') || (match == 3 && b == '\n'))
                {
                    match++;
                    if (match == 4) break;
                }
                else
                {
                    match = (b == '\r') ? 1 : 0;
                }
            }

            string headText = Encoding.ASCII.GetString(headerBuf.ToArray());
            string[] lines = headText.Split(new[] { "\r\n" }, StringSplitOptions.RemoveEmptyEntries);
            if (lines.Length == 0) return false;
            string[] reqLine = lines[0].Split(' ');
            if (reqLine.Length < 2) return false;
            method = reqLine[0].ToUpperInvariant();
            path = reqLine[1];

            int contentLen = 0;
            for (int i = 1; i < lines.Length; i++)
            {
                int colon = lines[i].IndexOf(':');
                if (colon > 0)
                {
                    string k = lines[i].Substring(0, colon).Trim();
                    string v = lines[i].Substring(colon + 1).Trim();
                    headers[k] = v;
                    if (k.Equals("Content-Length", StringComparison.OrdinalIgnoreCase))
                    {
                        int.TryParse(v, out contentLen);
                    }
                }
            }

            if (contentLen > 0 && contentLen < 2097152)
            {
                body = new byte[contentLen];
                int off = 0;
                while (off < contentLen)
                {
                    int n = ns.Read(body, off, contentLen - off);
                    if (n <= 0) break;
                    off += n;
                }
            }
            return true;
        }

        private static void SendJson(NetworkStream ns, int code, string json)
        {
            SendText(ns, code, "application/json; charset=utf-8", json);
        }

        private static void SendText(NetworkStream ns, int code, string contentType, string text, string extraHeaders = "")
        {
            SendBytes(ns, code, contentType, Encoding.UTF8.GetBytes(text ?? ""), extraHeaders);
        }

        private static void SendBytes(NetworkStream ns, int code, string contentType, byte[] data, string extraHeaders = "")
        {
            string statusText = code == 200 ? "OK" : (code == 404 ? "Not Found" : (code == 503 ? "Service Unavailable" : "Error"));
            string head = string.Format(
                "HTTP/1.1 {0} {1}\r\nContent-Type: {2}\r\nContent-Length: {3}\r\n{4}Connection: close\r\n\r\n",
                code, statusText, contentType, data.Length, extraHeaders);
            byte[] hb = Encoding.ASCII.GetBytes(head);
            ns.Write(hb, 0, hb.Length);
            if (data.Length > 0) ns.Write(data, 0, data.Length);
        }

        private static Dictionary<string, string> ToStrDict(object obj)
        {
            Dictionary<string, string> res = new Dictionary<string, string>();
            Dictionary<string, object> d = obj as Dictionary<string, object>;
            if (d == null) return res;
            foreach (var kv in d)
            {
                if (kv.Value != null) res[kv.Key] = kv.Value.ToString();
            }
            return res;
        }

        private void BtnFirewall_Click(object sender, EventArgs e)
        {
            try
            {
                ProcessStartInfo psi = new ProcessStartInfo
                {
                    FileName = "netsh",
                    Arguments = string.Format("advfirewall firewall add rule name=\"XuperTV Puente PC {0}\" dir=in action=allow protocol=TCP localport={0}", DefaultPort),
                    Verb = "runas",
                    UseShellExecute = true,
                    WindowStyle = ProcessWindowStyle.Hidden
                };
                Process p = Process.Start(psi);
                if (p != null) p.WaitForExit();
                Log("Regla de Firewall añadida para TCP " + DefaultPort);
                MessageBox.Show("Puerto " + DefaultPort + " habilitado en el Firewall de Windows.", "Firewall listo", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
            catch (Exception ex)
            {
                Log("Firewall cancelado o falló: " + ex.Message);
            }
        }

        private static string DetectLanIp()
        {
            try
            {
                foreach (NetworkInterface ni in NetworkInterface.GetAllNetworkInterfaces())
                {
                    if (ni.OperationalStatus != OperationalStatus.Up) continue;
                    if (ni.NetworkInterfaceType == NetworkInterfaceType.Loopback) continue;
                    if (ni.Description.IndexOf("Virtual", StringComparison.OrdinalIgnoreCase) >= 0) continue;
                    foreach (UnicastIPAddressInformation ua in ni.GetIPProperties().UnicastAddresses)
                    {
                        if (ua.Address.AddressFamily == AddressFamily.InterNetwork)
                        {
                            string ip = ua.Address.ToString();
                            if (ip.StartsWith("192.168.") || ip.StartsWith("10.") || ip.StartsWith("172."))
                                return ip;
                        }
                    }
                }
            }
            catch { }
            return "127.0.0.1";
        }

        private static string FindFfmpeg()
        {
            string localExe = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "ffmpeg.exe");
            if (File.Exists(localExe)) return localExe;

            string pathEnv = Environment.GetEnvironmentVariable("PATH") ?? "";
            foreach (string dir in pathEnv.Split(';'))
            {
                if (string.IsNullOrWhiteSpace(dir)) continue;
                try
                {
                    string cand = Path.Combine(dir.Trim(), "ffmpeg.exe");
                    if (File.Exists(cand)) return cand;
                }
                catch { }
            }

            try
            {
                string winget = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), @"Microsoft\WinGet\Packages");
                if (Directory.Exists(winget))
                {
                    string[] hits = Directory.GetFiles(winget, "ffmpeg.exe", SearchOption.AllDirectories);
                    if (hits.Length > 0) return hits[0];
                }
            }
            catch { }

            if (File.Exists(@"C:\ffmpeg\bin\ffmpeg.exe")) return @"C:\ffmpeg\bin\ffmpeg.exe";
            return null;
        }

        private static string DetectEncoder(string exe)
        {
            foreach (string cand in new[] { "h264_qsv", "h264_nvenc", "h264_amf" })
            {
                try
                {
                    ProcessStartInfo psi = new ProcessStartInfo
                    {
                        FileName = exe,
                        Arguments = "-hide_banner -y -f lavfi -i color=c=black:s=128x72:r=24:d=0.2 -c:v " + cand + " -f null -",
                        UseShellExecute = false,
                        RedirectStandardError = true,
                        CreateNoWindow = true
                    };
                    using (Process p = Process.Start(psi))
                    {
                        p.WaitForExit(3500);
                        if (p.HasExited && p.ExitCode == 0) return cand;
                    }
                }
                catch { }
            }
            return "libx264";
        }

        private void SetStreamLabel(string text)
        {
            if (InvokeRequired) { BeginInvoke(new Action(() => lblStream.Text = text)); return; }
            lblStream.Text = text;
        }

        private void Log(string msg)
        {
            string line = string.Format("[{0:HH:mm:ss}] {1}", DateTime.Now, msg);
            if (InvokeRequired)
            {
                BeginInvoke(new Action(() => AppendLog(line)));
            }
            else
            {
                AppendLog(line);
            }
        }

        private void AppendLog(string line)
        {
            if (txtLog.TextLength > 0) txtLog.AppendText("\r\n");
            txtLog.AppendText(line);
        }
    }
}
