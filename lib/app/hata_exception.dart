class Hatalar{
  static String goster(String hataKodu){
    switch(hataKodu){
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        return "Bu e-posta adresi zaten kullanımda, lütfen farklı bir e-posta adresi kullanınız";
      case 'ERROR_USER_NOT_FOUND' :
        return 'Bu kullanıcı sistemde bulunmamaktadır. Lütfen önce kullanıcı oluşturunuz.';
      default:
        return "Bir hata oluştur";
    }
  }
}