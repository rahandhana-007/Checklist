# EUDR Issue

Aplikasi pelacak pekebun. Progres **selesai** disimpan di Supabase, jadi tetap ada setelah di-deploy ke Vercel.

## Satu kali: buat tabel + storage

1. Buka [Supabase SQL Editor](https://supabase.com/dashboard/project/ofrjwtrrhfvpmiqegzor/sql/new)
2. Tempel isi `setup.sql` lalu **Run** (termasuk bucket `eudr-files`)
3. Di aplikasi, klik ikon awan → **Tes koneksi**

Setelah itu setiap SH bisa **Upload GeoJSON** dan **Upload Pict** (JPG/PNG). File masuk Supabase Storage.

## Deploy ke Vercel

Upload folder ini (`index.html`, `data.json`, `config.js`, `logo.png`).  
Key sudah ada di `config.js`, jadi progres cloud langsung dipakai di URL Vercel.

## Import pekebun baru

Klik ikon **Import** (panah ke kotak) di header:

1. **File Excel/CSV** — upload `.xlsx` / `.csv` dengan kolom `CG ID, CG Name, SH ID, Password, SH Name, HA`
2. **Link Google Sheets** — tempel link share, aplikasi ambil langsung (file harus bisa dilihat siapa saja)
3. **Tempel data CSV** — salin-tempel baris data langsung

Sebelum di-import, aplikasi menampilkan pratinjau: mana yang **baru**, mana yang **duplikat** (dilewati atau diperbarui kalau dicentang), dan baris rusak. Data hasil import tersimpan di perangkat (localStorage) dan tetap terbawa saat file `data.json` di-deploy ulang. Progres & file cloud otomatis bekerja untuk SH hasil import karena dikunci per SH ID.

