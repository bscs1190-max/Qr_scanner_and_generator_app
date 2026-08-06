enum QRType {
  website,
  wifi,
  phone,
  sms,
  email,
  location,
  contact,
  text,
}

class QRResult {
  final QRType type;
  final String rawData;

  QRResult({
    required this.type,
    required this.rawData,
  });
}

class QRParser {
  static QRResult parse(String value) {
    final text = value.trim();

    // Website
    if (text.startsWith("http://") ||
        text.startsWith("https://") ||
        text.startsWith("www.")) {
      return QRResult(
        type: QRType.website,
        rawData: text,
      );
    }

    // WiFi
    if (text.startsWith("WIFI:")) {
      return QRResult(
        type: QRType.wifi,
        rawData: text,
      );
    }

    // Phone
    if (text.startsWith("tel:")) {
      return QRResult(
        type: QRType.phone,
        rawData: text,
      );
    }

    // SMS
    if (text.startsWith("SMSTO:") ||
        text.startsWith("sms:")) {
      return QRResult(
        type: QRType.sms,
        rawData: text,
      );
    }

    // Email
    if (text.startsWith("mailto:") ||
        text.startsWith("MATMSG:")) {
      return QRResult(
        type: QRType.email,
        rawData: text,
      );
    }

    // Location
    if (text.startsWith("geo:")) {
      return QRResult(
        type: QRType.location,
        rawData: text,
      );
    }

    // Contact
    if (text.startsWith("BEGIN:VCARD")) {
      return QRResult(
        type: QRType.contact,
        rawData: text,
      );
    }

    // Default Text
    return QRResult(
      type: QRType.text,
      rawData: text,
    );
  }
}