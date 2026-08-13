# EUDR Issue

Aplikasi pelacak pekebun. Progres **selesai** disimpan di Supabase, jadi tetap ada setelah di-deploy ke Vercel.

## Satu kali: buat tabel + storage

1. Buka [Supabase SQL Editor](https://supabase.com/dashboard/project/ofrjwtrrhfvpmiqegzor/sql/new)
2. Tempel isi `setup.sql` lalu **Run** (termasuk bucket `eudr-files`)
3. Di aplikasi, klik ikon awan → **Tes koneksi**

Setelah itu setiap SH bisa **Upload GeoJSON** dan **Upload Pict** (JPG/PNG). File masuk Supabase Storage.

## Deploy ke Vercel

Upload folder ini (`index.html`, `data.json`, `config.js`).  
Key sudah ada di `config.js`, jadi progres cloud langsung dipakai di URL Vercel.
