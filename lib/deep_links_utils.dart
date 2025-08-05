class DeepLinkUtils {
  static String generateDeepLink(
    String placeName,
    double latitude,
    double longitude,
  ) {
    return 'openmyapp://place?name=$placeName&lat=$latitude&lng=$longitude';
  }
}
