# -*- coding: utf-8 -*-
"""turk.m3u'yu 4 esit parcaya boler. Her parca #EXTM3U ile baslar ve
#EXTINF+URL ciftlerini bolmeden korur (kanal cifti yarilmasin diye)."""
import math

SRC = "turk.m3u"
N = 4

with open(SRC, "r", encoding="utf-8", newline="") as f:
    content = f.read()

# Satirlari ayir (CRLF korunur, yeni satir olarak \r\n kullanacagiz)
lines = content.split("\r\n")
# Dosya CRLF ile bitiyorsa son eleman bos string olur
if lines and lines[-1] == "":
    lines.pop()

# Ilk satir #EXTM3U basligi
assert lines[0].strip().upper().startswith("#EXTM3U"), "Ilk satir #EXTM3U degil!"
header = lines[0]
rest = lines[1:]

# Geri kalan satirlar #EXTINF + URL ciftleri olmali
assert len(rest) % 2 == 0, f"Tek sayida #EXTINF/URL satiri var: {len(rest)}"
pairs = [(rest[i], rest[i + 1]) for i in range(0, len(rest), 2)]
total_pairs = len(pairs)

# Esit dagitim: her parca icin kanal sayisi
base = total_pairs // N
extra = total_pairs % N

chunks = []
idx = 0
for i in range(N):
    count = base + (1 if i < extra else 0)
    chunks.append(pairs[idx:idx + count])
    idx += count

for i, chunk in enumerate(chunks, start=1):
    out = [header]
    for inf, url in chunk:
        out.append(inf)
        out.append(url)
    text = "\r\n".join(out) + "\r\n"
    fname = f"turk{i}.m3u"
    with open(fname, "w", encoding="utf-8", newline="") as f:
        f.write(text)
    print(f"{fname}: {len(chunk)} kanal, {len(out)} satir")

print(f"TOPLAM: {total_pairs} kanal -> 4 parcaya bolundu")
