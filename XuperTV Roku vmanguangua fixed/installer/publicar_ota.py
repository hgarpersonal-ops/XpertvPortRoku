"""Herramienta para empacar XuperTV-v3 (ZIP + EXEs) y leer/editar rsc/4d91.dat para GitHub OTA."""
import base64
import hashlib
import json
import os
import shutil
import subprocess
import sys
import zipfile

from cryptography.hazmat.primitives import padding
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
KIT_PATH = os.path.join(ROOT, "rsc", "4d91.dat")
DESKTOP = os.path.join(os.path.expanduser("~"), "Desktop")
CSC = r"C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe"


def kit_key_bytes() -> bytes:
    a = "".join(chr(x - 61) for x in [175,177,107,175,158,166,169,107,159,175,158,171,161,107,118,160,111])
    b = "".join(chr(x - 79) for x in [199,196,124,186,184,195,124,177,187,190,177,124,197,128])
    mid = chr(167 - 43)
    h1 = hashlib.md5((a + mid + b).encode("ascii")).hexdigest()
    h2 = hashlib.md5((b + a).encode("ascii")).hexdigest()
    return bytes.fromhex((h1 + h2)[:48])


def decrypt_kit() -> dict:
    raw_hex = open(KIT_PATH, "rb").read().strip().decode("ascii")
    ct = base64.b64decode(bytes.fromhex(raw_hex).decode("ascii"))
    dec = Cipher(algorithms.TripleDES(kit_key_bytes()), modes.ECB()).decryptor()
    pt = dec.update(ct) + dec.finalize()
    u = padding.PKCS7(64).unpadder()
    return json.loads((u.update(pt) + u.finalize()).decode("utf-8"))


def encrypt_kit(kit: dict) -> None:
    plain = json.dumps(kit, separators=(",", ":"), ensure_ascii=False).encode("utf-8")
    p = padding.PKCS7(64).padder()
    padded = p.update(plain) + p.finalize()
    enc = Cipher(algorithms.TripleDES(kit_key_bytes()), modes.ECB()).encryptor()
    out_hex = base64.b64encode(enc.update(padded) + enc.finalize()).hex()
    with open(KIT_PATH, "wb") as f:
        f.write(out_hex.encode("ascii"))


def build_all(copy_desktop: bool = True) -> None:
    zip_v3 = os.path.join(ROOT, "XuperTV-v3-fixed.zip")
    zip_gh = os.path.join(ROOT, "XuperTV-vManguangua-fixed.zip")
    include_top = {"manifest", "source", "components", "images", "rsc"}
    count = 0
    with zipfile.ZipFile(zip_v3, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=6) as zf:
        for dirpath, dirnames, filenames in os.walk(ROOT):
            rel_dir = os.path.relpath(dirpath, ROOT)
            if rel_dir == ".":
                dirnames[:] = [d for d in dirnames if d in include_top]
                for fn in filenames:
                    if fn in include_top:
                        zf.write(os.path.join(dirpath, fn), fn)
                        count += 1
            else:
                for fn in filenames:
                    rel = os.path.relpath(os.path.join(dirpath, fn), ROOT).replace("\\", "/")
                    zf.write(os.path.join(dirpath, fn), rel)
                    count += 1
    shutil.copy2(zip_v3, zip_gh)
    print(f"ZIP OK: {count} archivos, {os.path.getsize(zip_v3)} bytes")

    bridge_exe = os.path.join(ROOT, "XuperTV-Puente-PC.exe")
    inst_exe = os.path.join(ROOT, "XuperTV-Instalador.exe")
    subprocess.run(
        [CSC, "/nologo", "/target:winexe", "/optimize+", f"/out:{bridge_exe}", "/r:System.Web.Extensions.dll", os.path.join(ROOT, "installer", "XuperTvBridge.cs")],
        check=True,
    )
    subprocess.run(
        [CSC, "/nologo", "/target:winexe", "/optimize+", f"/out:{inst_exe}", f"/resource:{zip_v3},XuperTV-v3-fixed.zip", os.path.join(ROOT, "installer", "XuperTvInstaller.cs")],
        check=True,
    )
    print(f"EXEs OK: Puente={os.path.getsize(bridge_exe)} Instalador={os.path.getsize(inst_exe)}")

    if copy_desktop and os.path.isdir(DESKTOP):
        for fn in ("XuperTV-v3-fixed.zip", "XuperTV-vManguangua-fixed.zip", "XuperTV-Instalador.exe", "XuperTV-Puente-PC.exe"):
            shutil.copy2(os.path.join(ROOT, fn), os.path.join(DESKTOP, fn))
        print("Copiado a Desktop OK.")


if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "dump":
        print(json.dumps(decrypt_kit(), indent=2, ensure_ascii=False))
    else:
        build_all(True)
