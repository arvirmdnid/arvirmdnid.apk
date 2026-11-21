# arvirmdnid (Flutter)

Splash: animasi galon menuang air ke botol sampai penuh (0-100%), lalu fade ke Beranda.
Menu masih placeholder (lib/home.dart) - ganti sesuai kebutuhan.

## Build lewat Codemagic
Push folder ini ke GitHub, hubungkan ke Codemagic. `codemagic.yaml` sudah
membuat project Android otomatis (`flutter create`) dan build APK release.

## Build lokal
flutter create . --platforms=android --project-name arvirmdnid
flutter pub get
flutter run
