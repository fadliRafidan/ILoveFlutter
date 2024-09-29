import 'package:intl/intl.dart';

String formatRupiah(num price) {
  return NumberFormat.currency(
    locale: 'id_ID', // Format untuk Indonesia
    symbol: 'Rp', // Simbol mata uang Rupiah
    decimalDigits: 0, // Tidak ada desimal
  ).format(price);
}
