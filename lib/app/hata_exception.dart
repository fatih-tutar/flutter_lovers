class Hatalar{
  static String goster(String hataKodu){
    switch(hataKodu){
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        return "Bu e-posta adresi zaten kullanımda, lütfen farklı bir e-posta adresi kullanınız";
      default:
        return "Bir hata oluştur";
    }
  }
}