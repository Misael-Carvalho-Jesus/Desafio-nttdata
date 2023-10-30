public class Utils {
    public static Boolean ValidaCNPJ(String cnpj) {
        cnpj = cnpj.replaceAll('[^0-9]', '');

        if (cnpj.length() != 14) {
            return false;
        }
        
        return true;
    }

    public static Boolean ValidaCPF(String cpf) {
        cpf = cpf.replaceAll('[^0-9]', '');

        if (cpf.length() != 11) {
            return false;
        }

        return true;
    }
}