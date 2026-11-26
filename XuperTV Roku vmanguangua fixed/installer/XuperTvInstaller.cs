using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Net;
using System.Net.NetworkInformation;
using System.Net.Sockets;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Windows.Forms;
using System.Xml;

namespace XuperTvInstaller
{
    public class RokuDevice
    {
        public string Ip { get; set; }
        public string FriendlyName { get; set; }
        public string ModelName { get; set; }
        public string ModelNumber { get; set; }
        public string OsVersion { get; set; }
        public bool DevEnabled { get; set; }
        public string VideoMode { get; set; }
        public bool SupportsHevcHint { get; set; }

        public override string ToString()
        {
            string dev = DevEnabled ? "Dev ON" : "Dev OFF";
            return string.Format("{0} ({1}) - {2} [{3}]", FriendlyName, ModelName, Ip, dev);
        }
    }

    public class MainForm : Form
    {
        private ComboBox cmbDevices;
        private Button btnScan;
        private TextBox txtIp;
        private TextBox txtUser;
        private TextBox txtPass;
        private CheckBox chkShowPass;
        private Button btnTest;
        private Label lblDeviceStatus;
        private Label lblZipInfo;
        private Button btnBrowseZip;
        private Button btnUseBuiltIn;
        private Button btnInstall;
        private Button btnLaunch;
        private ProgressBar progressBar;
        private TextBox txtLog;

        private string customZipPath = null;
        private const string EmbeddedZipResourceName = "XuperTV-v3-fixed.zip";
        private const int EmbeddedBuildVersion = 47;
        private const string GitHubManifestUrl = "https://raw.githubusercontent.com/hgarpersonal-ops/XpertvPortRoku/main/XuperTV%20Roku%20vmanguangua%20fixed/manifest";
        private static readonly string[] GitHubZipUrls = new[]
        {
            "https://raw.githubusercontent.com/hgarpersonal-ops/XpertvPortRoku/main/XuperTV-vManguangua-fixed.zip",
            "https://raw.githubusercontent.com/hgarpersonal-ops/XpertvPortRoku/main/XuperTV-v3-fixed.zip"
        };
        private Button btnCheckOta;
        private readonly List<RokuDevice> discovered = new List<RokuDevice>();

        private static readonly Color BgDark = Color.FromArgb(8, 14, 30);
        private static readonly Color CardBg = Color.FromArgb(15, 25, 48);
        private static readonly Color InputBg = Color.FromArgb(22, 36, 68);
        private static readonly Color AccentBlue = Color.FromArgb(14, 165, 233);
        private static readonly Color SuccessGreen = Color.FromArgb(52, 211, 153);
        private static readonly Color WarnGold = Color.FromArgb(255, 200, 61);
        private static readonly Color ErrorRed = Color.FromArgb(255, 90, 110);
        private static readonly Color TextLight = Color.FromArgb(248, 250, 252);
        private static readonly Color TextMuted = Color.FromArgb(148, 163, 184);

        public MainForm()
        {
            ServicePointManager.Expect100Continue = false;
            try { ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072 | SecurityProtocolType.Tls; } catch { }
            InitializeUi();
            LoadSavedConfig();
            this.Shown += (s, e) => CheckGitHubUpdate(false);
        }

        private void InitializeUi()
        {
            this.Text = "XuperTV - Compilación v47 Edición Manguangua (by wastrike)";
            this.Size = new Size(740, 720);
            this.MinimumSize = new Size(700, 680);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.BackColor = BgDark;
            this.ForeColor = TextLight;
            this.Font = new Font("Segoe UI", 9.5f);
            this.FormBorderStyle = FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;

            // Header
            Panel header = new Panel { Dock = DockStyle.Top, Height = 76, BackColor = Color.FromArgb(6, 11, 24) };
            Panel accentBar = new Panel { Dock = DockStyle.Bottom, Height = 2, BackColor = AccentBlue };
            header.Controls.Add(accentBar);

            Label lblTitle = new Label
            {
                Text = "XuperTV  ·  Compilación v47",
                Font = new Font("Segoe UI", 15f, FontStyle.Bold),
                ForeColor = TextLight,
                Location = new Point(22, 12),
                AutoSize = true
            };
            Label lblSub = new Label
            {
                Text = "Edición Manguangua (by wastrike)  ·  Instalador con OTA GitHub",
                Font = new Font("Segoe UI", 9.5f),
                ForeColor = AccentBlue,
                Location = new Point(24, 42),
                AutoSize = true
            };
            header.Controls.Add(lblTitle);
            header.Controls.Add(lblSub);
            this.Controls.Add(header);

            int y = 90;

            // Step 1 Card
            Panel card1 = CreateCard(20, y, 684, 108);
            card1.Controls.Add(CreateStepBadge("PASO 1", 14, 12));
            card1.Controls.Add(new Label
            {
                Text = "Activa el Modo Desarrollador en tu Roku (solo la primera vez)",
                Font = new Font("Segoe UI", 10.5f, FontStyle.Bold),
                ForeColor = TextLight,
                Location = new Point(92, 12),
                AutoSize = true
            });
            card1.Controls.Add(new Label
            {
                Text = "En el control remoto (desde Inicio):  Home ×3  →  Arriba ×2  →  Derecha  Izquierda  Derecha  Izquierda  Derecha\n" +
                       "Acepta los términos, pon una contraseña (ej: abcd) y espera a que el Roku se reinicie.",
                ForeColor = TextMuted,
                Location = new Point(14, 44),
                Size = new Size(656, 52)
            });
            this.Controls.Add(card1);
            y += 120;

            // Step 2 Card
            Panel card2 = CreateCard(20, y, 684, 198);
            card2.Controls.Add(CreateStepBadge("PASO 2", 14, 12));
            card2.Controls.Add(new Label
            {
                Text = "Conecta con tu dispositivo Roku",
                Font = new Font("Segoe UI", 10.5f, FontStyle.Bold),
                ForeColor = TextLight,
                Location = new Point(92, 12),
                AutoSize = true
            });

            btnScan = CreateButton("Buscar Roku en la red", 476, 10, 192, 30, InputBg);
            btnScan.Click += BtnScan_Click;
            card2.Controls.Add(btnScan);

            card2.Controls.Add(new Label { Text = "Dispositivos:", ForeColor = TextMuted, Location = new Point(14, 52), AutoSize = true });
            cmbDevices = new ComboBox
            {
                Location = new Point(115, 49),
                Size = new Size(553, 26),
                DropDownStyle = ComboBoxStyle.DropDownList,
                BackColor = InputBg,
                ForeColor = TextLight,
                FlatStyle = FlatStyle.Flat
            };
            cmbDevices.SelectedIndexChanged += (s, e) =>
            {
                RokuDevice dev = cmbDevices.SelectedItem as RokuDevice;
                if (dev != null)
                {
                    txtIp.Text = dev.Ip;
                    ShowDeviceInfo(dev);
                }
            };
            card2.Controls.Add(cmbDevices);

            card2.Controls.Add(new Label { Text = "IP del Roku:", ForeColor = TextMuted, Location = new Point(14, 90), AutoSize = true });
            txtIp = CreateTextBox(115, 87, 170);
            card2.Controls.Add(txtIp);

            card2.Controls.Add(new Label { Text = "Usuario:", ForeColor = TextMuted, Location = new Point(300, 90), AutoSize = true });
            txtUser = CreateTextBox(362, 87, 92);
            txtUser.Text = "rokudev";
            card2.Controls.Add(txtUser);

            card2.Controls.Add(new Label { Text = "Contraseña:", ForeColor = TextMuted, Location = new Point(468, 90), AutoSize = true });
            txtPass = CreateTextBox(552, 87, 116);
            txtPass.UseSystemPasswordChar = true;
            card2.Controls.Add(txtPass);

            chkShowPass = new CheckBox
            {
                Text = "Mostrar clave",
                ForeColor = TextMuted,
                Location = new Point(552, 118),
                AutoSize = true
            };
            chkShowPass.CheckedChanged += (s, e) => { txtPass.UseSystemPasswordChar = !chkShowPass.Checked; };
            card2.Controls.Add(chkShowPass);

            btnTest = CreateButton("Probar conexión y clave", 115, 118, 210, 30, InputBg);
            btnTest.Click += BtnTest_Click;
            card2.Controls.Add(btnTest);

            lblDeviceStatus = new Label
            {
                Text = "Ingresa la IP de tu Roku (Configuración → Red → Acerca de) o pulsa 'Buscar Roku en la red'.",
                ForeColor = TextMuted,
                Location = new Point(14, 156),
                Size = new Size(654, 36)
            };
            card2.Controls.Add(lblDeviceStatus);
            this.Controls.Add(card2);
            y += 210;

            // Step 3 Card
            Panel card3 = CreateCard(20, y, 684, 128);
            card3.Controls.Add(CreateStepBadge("PASO 3", 14, 12));
            card3.Controls.Add(new Label
            {
                Text = "Paquete e Instalación",
                Font = new Font("Segoe UI", 10.5f, FontStyle.Bold),
                ForeColor = TextLight,
                Location = new Point(92, 12),
                AutoSize = true
            });

            lblZipInfo = new Label
            {
                Text = HasEmbeddedZip() ? "Paquete integrado: Compilación v47 · Manguangua" : "Ningún paquete seleccionado",
                ForeColor = SuccessGreen,
                Location = new Point(14, 44),
                Size = new Size(340, 24)
            };
            card3.Controls.Add(lblZipInfo);

            btnCheckOta = CreateButton("GitHub OTA", 360, 40, 102, 28, InputBg);
            btnCheckOta.Click += (s, e) => CheckGitHubUpdate(true);
            card3.Controls.Add(btnCheckOta);

            btnBrowseZip = CreateButton("Otro ZIP...", 468, 40, 96, 28, InputBg);
            btnBrowseZip.Click += BtnBrowseZip_Click;
            card3.Controls.Add(btnBrowseZip);

            btnUseBuiltIn = CreateButton("Usar incluido", 572, 40, 96, 28, InputBg);
            btnUseBuiltIn.Visible = HasEmbeddedZip();
            btnUseBuiltIn.Click += (s, e) =>
            {
                customZipPath = null;
                lblZipInfo.Text = "Paquete integrado: Compilación v47 · Manguangua";
                lblZipInfo.ForeColor = SuccessGreen;
            };
            card3.Controls.Add(btnUseBuiltIn);

            btnInstall = CreateButton("Instalar XuperTV en el Roku", 14, 78, 456, 38, AccentBlue);
            btnInstall.Font = new Font("Segoe UI", 10.5f, FontStyle.Bold);
            btnInstall.Click += BtnInstall_Click;
            card3.Controls.Add(btnInstall);

            btnLaunch = CreateButton("Abrir en TV", 482, 78, 186, 38, InputBg);
            btnLaunch.Click += BtnLaunch_Click;
            card3.Controls.Add(btnLaunch);
            this.Controls.Add(card3);
            y += 138;

            progressBar = new ProgressBar
            {
                Location = new Point(20, y),
                Size = new Size(684, 10),
                Style = ProgressBarStyle.Continuous
            };
            this.Controls.Add(progressBar);
            y += 18;

            txtLog = new TextBox
            {
                Location = new Point(20, y),
                Size = new Size(684, 114),
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

        private Panel CreateCard(int x, int y, int w, int h)
        {
            return new Panel { Location = new Point(x, y), Size = new Size(w, h), BackColor = CardBg };
        }

        private Label CreateStepBadge(string text, int x, int y)
        {
            return new Label
            {
                Text = text,
                BackColor = AccentBlue,
                ForeColor = Color.White,
                Font = new Font("Segoe UI", 8.5f, FontStyle.Bold),
                TextAlign = ContentAlignment.MiddleCenter,
                Location = new Point(x, y),
                Size = new Size(68, 22)
            };
        }

        private TextBox CreateTextBox(int x, int y, int w)
        {
            return new TextBox
            {
                Location = new Point(x, y),
                Size = new Size(w, 25),
                BackColor = InputBg,
                ForeColor = TextLight,
                BorderStyle = BorderStyle.FixedSingle
            };
        }

        private Button CreateButton(string text, int x, int y, int w, int h, Color bg)
        {
            Button b = new Button
            {
                Text = text,
                Location = new Point(x, y),
                Size = new Size(w, h),
                BackColor = bg,
                ForeColor = Color.White,
                FlatStyle = FlatStyle.Flat,
                Cursor = Cursors.Hand
            };
            b.FlatAppearance.BorderSize = 0;
            return b;
        }

        private void Log(string msg)
        {
            if (this.InvokeRequired)
            {
                this.BeginInvoke(new Action<string>(Log), msg);
                return;
            }
            txtLog.AppendText(string.Format("[{0:HH:mm:ss}] {1}{2}", DateTime.Now, msg, Environment.NewLine));
        }

        private void SetBusy(bool busy, int progress = 0)
        {
            if (this.InvokeRequired)
            {
                this.BeginInvoke(new Action<bool, int>(SetBusy), busy, progress);
                return;
            }
            btnScan.Enabled = !busy;
            btnTest.Enabled = !busy;
            btnInstall.Enabled = !busy;
            btnLaunch.Enabled = !busy;
            btnBrowseZip.Enabled = !busy;
            if (btnCheckOta != null) btnCheckOta.Enabled = !busy;
            progressBar.Value = Math.Max(0, Math.Min(100, progress));
        }

        private string ConfigPath()
        {
            string dir = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "XuperTV");
            return Path.Combine(dir, "installer.cfg");
        }

        private void LoadSavedConfig()
        {
            try
            {
                string path = ConfigPath();
                if (File.Exists(path))
                {
                    string[] lines = File.ReadAllLines(path);
                    if (lines.Length >= 1 && !string.IsNullOrWhiteSpace(lines[0])) txtIp.Text = lines[0].Trim();
                    if (lines.Length >= 2 && !string.IsNullOrWhiteSpace(lines[1])) txtUser.Text = lines[1].Trim();
                }
            }
            catch { }
        }

        private void SaveConfig()
        {
            try
            {
                string path = ConfigPath();
                Directory.CreateDirectory(Path.GetDirectoryName(path));
                File.WriteAllLines(path, new[] { txtIp.Text.Trim(), txtUser.Text.Trim() });
            }
            catch { }
        }

        private bool HasEmbeddedZip()
        {
            return Assembly.GetExecutingAssembly().GetManifestResourceInfo(EmbeddedZipResourceName) != null;
        }

        private byte[] GetPackageBytes(out string fileName)
        {
            if (!string.IsNullOrEmpty(customZipPath) && File.Exists(customZipPath))
            {
                fileName = Path.GetFileName(customZipPath);
                return File.ReadAllBytes(customZipPath);
            }
            using (Stream s = Assembly.GetExecutingAssembly().GetManifestResourceStream(EmbeddedZipResourceName))
            {
                if (s != null)
                {
                    fileName = EmbeddedZipResourceName;
                    using (MemoryStream ms = new MemoryStream())
                    {
                        s.CopyTo(ms);
                        return ms.ToArray();
                    }
                }
            }
            string localZip = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, EmbeddedZipResourceName);
            if (File.Exists(localZip))
            {
                fileName = EmbeddedZipResourceName;
                return File.ReadAllBytes(localZip);
            }
            fileName = null;
            return null;
        }

        private void BtnBrowseZip_Click(object sender, EventArgs e)
        {
            using (OpenFileDialog dlg = new OpenFileDialog())
            {
                dlg.Filter = "Paquete Roku (*.zip)|*.zip";
                dlg.Title = "Selecciona el archivo .zip de la aplicación Roku";
                if (dlg.ShowDialog() == DialogResult.OK)
                {
                    customZipPath = dlg.FileName;
                    lblZipInfo.Text = "Paquete externo: " + Path.GetFileName(customZipPath);
                    lblZipInfo.ForeColor = AccentBlue;
                }
            }
        }

        private void CheckGitHubUpdate(bool manual)
        {
            if (manual) Log("Buscando actualización en GitHub (XpertvPortRoku)...");
            ThreadPool.QueueUserWorkItem(_ =>
            {
                try
                {
                    string bust = DateTimeOffset.UtcNow.ToUnixTimeSeconds().ToString();
                    HttpWebRequest req = (HttpWebRequest)WebRequest.Create(GitHubManifestUrl + "?_t=" + bust);
                    req.UserAgent = "XuperTV-Installer-OTA/1.0";
                    req.Timeout = 8000;
                    string man = "";
                    using (HttpWebResponse resp = (HttpWebResponse)req.GetResponse())
                    using (StreamReader sr = new StreamReader(resp.GetResponseStream(), Encoding.UTF8))
                    {
                        man = sr.ReadToEnd();
                    }
                    Match m = Regex.Match(man, @"build_version=(\d+)");
                    int remoteBuild = m.Success ? int.Parse(m.Groups[1].Value) : 0;
                    if (remoteBuild > EmbeddedBuildVersion)
                    {
                        byte[] zipBytes = null;
                        foreach (string zurl in GitHubZipUrls)
                        {
                            try
                            {
                                HttpWebRequest zreq = (HttpWebRequest)WebRequest.Create(zurl + "?_t=" + bust);
                                zreq.UserAgent = "XuperTV-Installer-OTA/1.0";
                                zreq.Timeout = 25000;
                                using (HttpWebResponse zresp = (HttpWebResponse)zreq.GetResponse())
                                using (Stream zs = zresp.GetResponseStream())
                                using (MemoryStream ms = new MemoryStream())
                                {
                                    zs.CopyTo(ms);
                                    byte[] tmp = ms.ToArray();
                                    if (tmp.Length > 100000 && tmp[0] == 0x50 && tmp[1] == 0x4B)
                                    {
                                        zipBytes = tmp;
                                        break;
                                    }
                                }
                            }
                            catch { }
                        }
                        if (zipBytes != null)
                        {
                            string outZip = Path.Combine(Path.GetTempPath(), "XuperTV-GitHub-v" + remoteBuild + ".zip");
                            File.WriteAllBytes(outZip, zipBytes);
                            this.BeginInvoke(new Action(() =>
                            {
                                customZipPath = outZip;
                                lblZipInfo.Text = string.Format("GitHub OTA listo: v{0} (actualizado desde GitHub)", remoteBuild);
                                lblZipInfo.ForeColor = SuccessGreen;
                                Log(string.Format("Actualización v{0} descargada de GitHub ({1:N0} bytes).", remoteBuild, zipBytes.Length));
                            }));
                            return;
                        }
                    }
                    if (manual)
                    {
                        this.BeginInvoke(new Action(() =>
                        {
                            Log(remoteBuild > 0
                                ? string.Format("Tu paquete ya está al día (local v{0}, GitHub v{1}).", EmbeddedBuildVersion, remoteBuild)
                                : "No se pudo leer build_version en GitHub.");
                        }));
                    }
                }
                catch (Exception ex)
                {
                    if (manual)
                    {
                        this.BeginInvoke(new Action(() => Log("Error consultando GitHub OTA: " + ex.Message)));
                    }
                }
            });
        }

        private void BtnScan_Click(object sender, EventArgs e)
        {
            SetBusy(true, 15);
            Log("Buscando dispositivos Roku en tu red local...");
            ThreadPool.QueueUserWorkItem(_ =>
            {
                List<RokuDevice> found = DiscoverRokus();
                this.BeginInvoke(new Action(() =>
                {
                    discovered.Clear();
                    cmbDevices.Items.Clear();
                    foreach (var d in found)
                    {
                        discovered.Add(d);
                        cmbDevices.Items.Add(d);
                    }
                    if (found.Count > 0)
                    {
                        cmbDevices.SelectedIndex = 0;
                        Log(string.Format("Se encontró {0} Roku(s).", found.Count));
                    }
                    else
                    {
                        lblDeviceStatus.Text = "No se detectó automáticamente. Verifica Wi-Fi o escribe la IP manualmente.";
                        lblDeviceStatus.ForeColor = WarnGold;
                        Log("No se detectaron Rokus automáticamente. Ingresa la IP manual.");
                    }
                    SetBusy(false, 0);
                }));
            });
        }

        private List<RokuDevice> DiscoverRokus()
        {
            HashSet<string> ips = new HashSet<string>();
            // 1. Fast SSDP multicast discovery
            try
            {
                using (UdpClient udp = new UdpClient())
                {
                    udp.Client.ReceiveTimeout = 1800;
                    udp.EnableBroadcast = true;
                    byte[] req = Encoding.ASCII.GetBytes(
                        "M-SEARCH * HTTP/1.1\r\n" +
                        "HOST: 239.255.255.250:1900\r\n" +
                        "MAN: \"ssdp:discover\"\r\n" +
                        "ST: roku:ecp\r\n" +
                        "MX: 2\r\n\r\n");
                    IPEndPoint ep = new IPEndPoint(IPAddress.Parse("239.255.255.250"), 1900);
                    udp.Send(req, req.Length, ep);
                    DateTime until = DateTime.UtcNow.AddMilliseconds(2200);
                    while (DateTime.UtcNow < until)
                    {
                        try
                        {
                            IPEndPoint remote = new IPEndPoint(IPAddress.Any, 0);
                            byte[] resp = udp.Receive(ref remote);
                            string txt = Encoding.ASCII.GetString(resp);
                            if (txt.IndexOf("roku", StringComparison.OrdinalIgnoreCase) >= 0)
                            {
                                ips.Add(remote.Address.ToString());
                            }
                        }
                        catch { break; }
                    }
                }
            }
            catch { }

            // 2. Parallel TCP 8060 fallback if SSDP returned nothing
            if (ips.Count == 0)
            {
                foreach (string subnet in GetLocalSubnets())
                {
                    object lockObj = new object();
                    List<ManualResetEvent> handles = new List<ManualResetEvent>();
                    for (int i = 1; i <= 254; i++)
                    {
                        string ip = subnet + "." + i;
                        ManualResetEvent ev = new ManualResetEvent(false);
                        handles.Add(ev);
                        ThreadPool.QueueUserWorkItem(state =>
                        {
                            try
                            {
                                using (TcpClient tcp = new TcpClient())
                                {
                                    IAsyncResult ar = tcp.BeginConnect(ip, 8060, null, null);
                                    if (ar.AsyncWaitHandle.WaitOne(350))
                                    {
                                        tcp.EndConnect(ar);
                                        lock (lockObj) { ips.Add(ip); }
                                    }
                                }
                            }
                            catch { }
                            finally { ((ManualResetEvent)state).Set(); }
                        }, ev);
                        if (handles.Count >= 64)
                        {
                            WaitHandle.WaitAll(handles.ToArray());
                            handles.Clear();
                        }
                    }
                    if (handles.Count > 0) WaitHandle.WaitAll(handles.ToArray());
                }
            }

            List<RokuDevice> list = new List<RokuDevice>();
            foreach (string ip in ips)
            {
                RokuDevice dev = QueryDeviceInfo(ip);
                if (dev != null) list.Add(dev);
            }
            return list;
        }

        private List<string> GetLocalSubnets()
        {
            List<string> res = new List<string>();
            try
            {
                foreach (NetworkInterface ni in NetworkInterface.GetAllNetworkInterfaces())
                {
                    if (ni.OperationalStatus != OperationalStatus.Up) continue;
                    if (ni.NetworkInterfaceType == NetworkInterfaceType.Loopback) continue;
                    foreach (UnicastIPAddressInformation ua in ni.GetIPProperties().UnicastAddresses)
                    {
                        if (ua.Address.AddressFamily == AddressFamily.InterNetwork)
                        {
                            string[] parts = ua.Address.ToString().Split('.');
                            if (parts.Length == 4)
                            {
                                string sub = parts[0] + "." + parts[1] + "." + parts[2];
                                if (!res.Contains(sub)) res.Add(sub);
                            }
                        }
                    }
                }
            }
            catch { }
            return res;
        }

        private RokuDevice QueryDeviceInfo(string ip)
        {
            try
            {
                HttpWebRequest req = (HttpWebRequest)WebRequest.Create(string.Format("http://{0}:8060/query/device-info", ip));
                req.Timeout = 2500;
                using (HttpWebResponse resp = (HttpWebResponse)req.GetResponse())
                using (StreamReader sr = new StreamReader(resp.GetResponseStream(), Encoding.UTF8))
                {
                    string xml = sr.ReadToEnd();
                    XmlDocument doc = new XmlDocument();
                    doc.LoadXml(xml);
                    RokuDevice d = new RokuDevice { Ip = ip };
                    d.FriendlyName = GetXmlTag(doc, "friendly-device-name");
                    if (string.IsNullOrEmpty(d.FriendlyName)) d.FriendlyName = GetXmlTag(doc, "user-device-name");
                    d.ModelName = GetXmlTag(doc, "friendly-model-name");
                    if (string.IsNullOrEmpty(d.ModelName)) d.ModelName = GetXmlTag(doc, "model-name");
                    d.ModelNumber = GetXmlTag(doc, "model-number");
                    d.OsVersion = GetXmlTag(doc, "software-version");
                    d.DevEnabled = GetXmlTag(doc, "developer-enabled").Equals("true", StringComparison.OrdinalIgnoreCase);
                    d.VideoMode = GetXmlTag(doc, "video-mode");
                    d.SupportsHevcHint = d.VideoMode.IndexOf("2160", StringComparison.OrdinalIgnoreCase) >= 0 ||
                                         GetXmlTag(doc, "supports-4k").Equals("true", StringComparison.OrdinalIgnoreCase);
                    return d;
                }
            }
            catch { return null; }
        }

        private string GetXmlTag(XmlDocument doc, string tag)
        {
            XmlNodeList nodes = doc.GetElementsByTagName(tag);
            return (nodes.Count > 0 && nodes[0] != null) ? nodes[0].InnerText.Trim() : "";
        }

        private void ShowDeviceInfo(RokuDevice dev)
        {
            if (dev == null) return;
            if (!dev.DevEnabled)
            {
                lblDeviceStatus.Text = string.Format("Conectado: {0} ({1} · Roku OS {2}) — ⚠ Modo Desarrollador APAGADO (ver Paso 1).",
                    dev.FriendlyName, dev.ModelName, dev.OsVersion);
                lblDeviceStatus.ForeColor = ErrorRed;
            }
            else
            {
                string note = dev.SupportsHevcHint ? "Soporta 4K/HEVC" : "Modelo HD (TV en vivo y H.264)";
                lblDeviceStatus.Text = string.Format("✓ Listo: {0} ({1} · OS {2}) · Dev ON · {3}",
                    dev.FriendlyName, dev.ModelName, dev.OsVersion, note);
                lblDeviceStatus.ForeColor = SuccessGreen;
            }
        }

        private void BtnTest_Click(object sender, EventArgs e)
        {
            string ip = txtIp.Text.Trim();
            string user = txtUser.Text.Trim();
            string pass = txtPass.Text;
            if (string.IsNullOrEmpty(ip))
            {
                MessageBox.Show("Escribe la IP de tu Roku primero.", "Falta IP", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            SetBusy(true, 30);
            Log("Probando conexión con " + ip + "...");
            ThreadPool.QueueUserWorkItem(_ =>
            {
                RokuDevice dev = QueryDeviceInfo(ip);
                string authMsg = null;
                bool authOk = false;
                if (dev != null && dev.DevEnabled)
                {
                    authOk = TestDigestAuth(ip, user, pass, out authMsg);
                }
                this.BeginInvoke(new Action(() =>
                {
                    if (dev == null)
                    {
                        lblDeviceStatus.Text = "✕ No se pudo conectar a " + ip + ". Revisa la IP y que estés en el mismo Wi-Fi.";
                        lblDeviceStatus.ForeColor = ErrorRed;
                        Log("Error: no hay respuesta ECP en " + ip + ":8060");
                    }
                    else
                    {
                        ShowDeviceInfo(dev);
                        Log(string.Format("Roku detectado: {0} ({1}), OS {2}, Dev={3}", dev.FriendlyName, dev.ModelName, dev.OsVersion, dev.DevEnabled));
                        if (dev.DevEnabled)
                        {
                            if (authOk)
                            {
                                SaveConfig();
                                Log("✓ Autenticación correcta (rokudev).");
                            }
                            else
                            {
                                lblDeviceStatus.Text = "⚠ Roku conectado, pero contraseña incorrecta (" + authMsg + ").";
                                lblDeviceStatus.ForeColor = WarnGold;
                                Log("Error de contraseña: " + authMsg);
                            }
                        }
                    }
                    SetBusy(false, 0);
                }));
            });
        }

        private void BtnInstall_Click(object sender, EventArgs e)
        {
            string ip = txtIp.Text.Trim();
            string user = txtUser.Text.Trim();
            string pass = txtPass.Text;
            if (string.IsNullOrEmpty(ip))
            {
                MessageBox.Show("Ingresa la IP de tu Roku en el Paso 2.", "Falta IP", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            if (string.IsNullOrEmpty(pass))
            {
                MessageBox.Show("Ingresa la contraseña de desarrollador del Roku.", "Falta contraseña", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            string pkgName;
            byte[] pkgBytes = GetPackageBytes(out pkgName);
            if (pkgBytes == null)
            {
                MessageBox.Show("No se encontró el archivo ZIP para instalar.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            SaveConfig();
            SetBusy(true, 15);
            Log(string.Format("Iniciando instalación de {0} ({1:N0} bytes) en {2}...", pkgName, pkgBytes.Length, ip));

            ThreadPool.QueueUserWorkItem(_ =>
            {
                try
                {
                    RokuDevice dev = QueryDeviceInfo(ip);
                    if (dev == null)
                    {
                        FinishInstallError("No se encontró ningún Roku en " + ip + ". Verifica la IP y la red Wi-Fi.");
                        return;
                    }
                    if (!dev.DevEnabled)
                    {
                        FinishInstallError("El Modo Desarrollador está apagado en ese Roku. Completa el Paso 1 primero.");
                        return;
                    }

                    this.BeginInvoke(new Action(() => { progressBar.Value = 35; ShowDeviceInfo(dev); }));
                    Log("Solicitando desafío de autenticación (Digest)...");
                    string authChallenge = GetDigestChallenge(ip);
                    if (string.IsNullOrEmpty(authChallenge))
                    {
                        FinishInstallError("El puerto 80 del instalador no respondió. Reinicia el Roku e inténtalo de nuevo.");
                        return;
                    }

                    this.BeginInvoke(new Action(() => { progressBar.Value = 65; }));
                    Log("Subiendo paquete e instalando en el Roku...");
                    string statusLine;
                    string htmlResp = PostPluginInstall(ip, user, pass, authChallenge, pkgName, pkgBytes, out statusLine);

                    this.BeginInvoke(new Action(() => { progressBar.Value = 100; }));

                    if (statusLine.StartsWith("401"))
                    {
                        FinishInstallError("Contraseña incorrecta (HTTP 401). Verifica la clave que pusiste en Modo Desarrollador.");
                        return;
                    }

                    string summary = ExtractRokuInstallResult(htmlResp);
                    bool success = htmlResp.IndexOf("Install Success", StringComparison.OrdinalIgnoreCase) >= 0 ||
                                   htmlResp.IndexOf("Identical to previous", StringComparison.OrdinalIgnoreCase) >= 0;

                    this.BeginInvoke(new Action(() =>
                    {
                        if (success)
                        {
                            Log("✓ " + summary);
                            lblDeviceStatus.Text = "✓ ¡XuperTV instalada con éxito en " + dev.FriendlyName + "!";
                            lblDeviceStatus.ForeColor = SuccessGreen;
                            MessageBox.Show("¡XuperTV se instaló correctamente en tu Roku!\n\n" + summary,
                                "Instalación Exitosa", MessageBoxButtons.OK, MessageBoxIcon.Information);
                        }
                        else
                        {
                            Log("Respuesta del Roku: " + summary);
                            MessageBox.Show("El Roku respondió:\n" + summary, "Resultado de Instalación",
                                MessageBoxButtons.OK, MessageBoxIcon.Warning);
                        }
                        SetBusy(false, 0);
                    }));
                }
                catch (Exception ex)
                {
                    FinishInstallError("Error al instalar: " + ex.Message);
                }
            });
        }

        private void FinishInstallError(string msg)
        {
            this.BeginInvoke(new Action(() =>
            {
                Log("✕ " + msg);
                lblDeviceStatus.Text = "✕ " + msg;
                lblDeviceStatus.ForeColor = ErrorRed;
                SetBusy(false, 0);
                MessageBox.Show(msg, "No se pudo instalar", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }));
        }

        private void BtnLaunch_Click(object sender, EventArgs e)
        {
            string ip = txtIp.Text.Trim();
            if (string.IsNullOrEmpty(ip)) return;
            ThreadPool.QueueUserWorkItem(_ =>
            {
                try
                {
                    HttpWebRequest req = (HttpWebRequest)WebRequest.Create(string.Format("http://{0}:8060/launch/dev", ip));
                    req.Method = "POST";
                    req.ContentLength = 0;
                    req.Timeout = 3000;
                    using (HttpWebResponse resp = (HttpWebResponse)req.GetResponse()) { }
                    Log("Comando 'Abrir XuperTV' enviado al televisor.");
                }
                catch (Exception ex)
                {
                    Log("No se pudo abrir en TV: " + ex.Message);
                }
            });
        }

        private string GetDigestChallenge(string ip)
        {
            try
            {
                HttpWebRequest req = (HttpWebRequest)WebRequest.Create(string.Format("http://{0}/", ip));
                req.Method = "GET";
                req.Timeout = 4000;
                using (HttpWebResponse resp = (HttpWebResponse)req.GetResponse())
                {
                    return null;
                }
            }
            catch (WebException wex)
            {
                HttpWebResponse resp = wex.Response as HttpWebResponse;
                if (resp != null && resp.StatusCode == HttpStatusCode.Unauthorized)
                {
                    return resp.Headers["WWW-Authenticate"];
                }
                return null;
            }
        }

        private bool TestDigestAuth(string ip, string user, string pass, out string msg)
        {
            string challenge = GetDigestChallenge(ip);
            if (string.IsNullOrEmpty(challenge))
            {
                msg = "Sin respuesta del puerto 80";
                return false;
            }
            try
            {
                HttpWebRequest req = (HttpWebRequest)WebRequest.Create(string.Format("http://{0}/", ip));
                req.Method = "GET";
                req.Timeout = 4000;
                req.Headers["Authorization"] = BuildDigestHeader("GET", "/", user, pass, challenge);
                using (HttpWebResponse resp = (HttpWebResponse)req.GetResponse())
                {
                    msg = resp.StatusCode.ToString();
                    return resp.StatusCode == HttpStatusCode.OK;
                }
            }
            catch (WebException wex)
            {
                HttpWebResponse r = wex.Response as HttpWebResponse;
                msg = r != null ? ((int)r.StatusCode + " " + r.StatusDescription) : wex.Message;
                return false;
            }
        }

        private string PostPluginInstall(string ip, string user, string pass, string challenge, string fileName, byte[] fileBytes, out string statusLine)
        {
            string boundary = "----XuperBoundary" + Guid.NewGuid().ToString("N");
            byte[] headerBytes = Encoding.UTF8.GetBytes(
                "--" + boundary + "\r\n" +
                "Content-Disposition: form-data; name=\"mysubmit\"\r\n\r\n" +
                "Install\r\n" +
                "--" + boundary + "\r\n" +
                "Content-Disposition: form-data; name=\"archive\"; filename=\"" + fileName + "\"\r\n" +
                "Content-Type: application/zip\r\n\r\n");
            byte[] footerBytes = Encoding.UTF8.GetBytes("\r\n--" + boundary + "--\r\n");

            HttpWebRequest req = (HttpWebRequest)WebRequest.Create(string.Format("http://{0}/plugin_install", ip));
            req.Method = "POST";
            req.Timeout = 45000;
            req.ContentType = "multipart/form-data; boundary=" + boundary;
            req.ContentLength = headerBytes.Length + fileBytes.Length + footerBytes.Length;
            req.Headers["Authorization"] = BuildDigestHeader("POST", "/plugin_install", user, pass, challenge);

            using (Stream reqStream = req.GetRequestStream())
            {
                reqStream.Write(headerBytes, 0, headerBytes.Length);
                reqStream.Write(fileBytes, 0, fileBytes.Length);
                reqStream.Write(footerBytes, 0, footerBytes.Length);
            }

            try
            {
                using (HttpWebResponse resp = (HttpWebResponse)req.GetResponse())
                using (StreamReader sr = new StreamReader(resp.GetResponseStream(), Encoding.UTF8))
                {
                    statusLine = ((int)resp.StatusCode) + " " + resp.StatusDescription;
                    return sr.ReadToEnd();
                }
            }
            catch (WebException wex)
            {
                HttpWebResponse r = wex.Response as HttpWebResponse;
                if (r != null)
                {
                    statusLine = ((int)r.StatusCode) + " " + r.StatusDescription;
                    using (StreamReader sr = new StreamReader(r.GetResponseStream(), Encoding.UTF8))
                    {
                        return sr.ReadToEnd();
                    }
                }
                throw;
            }
        }

        private string BuildDigestHeader(string method, string uri, string user, string pass, string challenge)
        {
            string realm = ParseDigestParam(challenge, "realm");
            string nonce = ParseDigestParam(challenge, "nonce");
            string qop = ParseDigestParam(challenge, "qop");
            string opaque = ParseDigestParam(challenge, "opaque");
            string nc = "00000001";
            string cnonce = Guid.NewGuid().ToString("N").Substring(0, 16);

            string ha1 = Md5Hex(user + ":" + realm + ":" + pass);
            string ha2 = Md5Hex(method + ":" + uri);
            string response;

            StringBuilder sb = new StringBuilder();
            sb.AppendFormat("Digest username=\"{0}\", realm=\"{1}\", nonce=\"{2}\", uri=\"{3}\"", user, realm, nonce, uri);
            if (!string.IsNullOrEmpty(qop))
            {
                string qopVal = qop.Contains("auth") ? "auth" : qop.Split(',')[0].Trim();
                response = Md5Hex(ha1 + ":" + nonce + ":" + nc + ":" + cnonce + ":" + qopVal + ":" + ha2);
                sb.AppendFormat(", qop={0}, nc={1}, cnonce=\"{2}\"", qopVal, nc, cnonce);
            }
            else
            {
                response = Md5Hex(ha1 + ":" + nonce + ":" + ha2);
            }
            sb.AppendFormat(", response=\"{0}\"", response);
            if (!string.IsNullOrEmpty(opaque))
            {
                sb.AppendFormat(", opaque=\"{0}\"", opaque);
            }
            return sb.ToString();
        }

        private string ParseDigestParam(string challenge, string key)
        {
            Match m = Regex.Match(challenge, key + "=\"([^\"]*)\"");
            if (m.Success) return m.Groups[1].Value;
            Match m2 = Regex.Match(challenge, key + "=([^,\\s]+)");
            return m2.Success ? m2.Groups[1].Value : "";
        }

        private string Md5Hex(string input)
        {
            using (MD5 md5 = MD5.Create())
            {
                byte[] hash = md5.ComputeHash(Encoding.UTF8.GetBytes(input));
                StringBuilder sb = new StringBuilder(hash.Length * 2);
                foreach (byte b in hash) sb.Append(b.ToString("x2"));
                return sb.ToString();
            }
        }

        private string ExtractRokuInstallResult(string html)
        {
            MatchCollection matches = Regex.Matches(html, "<font[^>]*>(.*?)</font>", RegexOptions.IgnoreCase | RegexOptions.Singleline);
            List<string> msgs = new List<string>();
            foreach (Match m in matches)
            {
                string t = Regex.Replace(m.Groups[1].Value, "<[^>]+>", "").Trim();
                if (!string.IsNullOrEmpty(t) && !msgs.Contains(t)) msgs.Add(t);
            }
            if (msgs.Count > 0) return string.Join(" ", msgs.ToArray());
            return html.Length > 250 ? html.Substring(0, 250) : html;
        }

        [STAThread]
        public static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new MainForm());
        }
    }
}
