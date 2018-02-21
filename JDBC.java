import java.sql.*;
import java.util.Scanner;

public class JDBC {
    static void reporting(String username, String password, int num) throws Exception{
        if(num != 1){
            return;
        }
        try {
            Scanner reader = new Scanner(System.in);  // Reading from System.in
            System.out.println("Enter a patient's SSN: ");
            int SSN = reader.nextInt(); // Scans the next token of the input as an int.
            reader.close();
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@oracle.wpi.edu:1521:orcl","dlsong","DLSONG");
            Statement stmt = conn.createStatement();
            String str = "SELECT * FROM Patient WHERE Patient.SSN=" + SSN;
            ResultSet rset = stmt.executeQuery(str);
            while(rset.next()){
                long SSN2 = rset.getLong("SSN");
                long pNum = rset.getLong("phoneNum");
                String fName = rset.getString("firstName");
                String lName = rset.getString("lastName");
                String addr = rset.getString("addr");
                System.out.println("SSN: " + SSN2 + " Phone Number: " + pNum + " First Name: " + fName + " Last Name: " + lName + " Address: " + addr);
            }

        }catch(Exception e){
            throw new Exception(e);
        }
    }

    static void reporting(String username, String password) throws Exception{
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@oracle.wpi.edu:1521:orcl","dlsong","DLSONG");
            Statement stmt = conn.createStatement();
            String str = "SELECT * FROM Patient";
            ResultSet rset = stmt.executeQuery(str);
            while(rset.next()){
                long SSN = rset.getLong("SSN");
                long pNum = rset.getLong("phoneNum");
                String fName = rset.getString("firstName");
                String lName = rset.getString("lastName");
                String addr = rset.getString("addr");
                System.out.println("SSN: " + SSN + " Phone Number: " + pNum + " First Name: " + fName + " Last Name: " + lName + " Address: " + addr);
            }
            str = "SELECT * FROM Doctor";
            rset = stmt.executeQuery(str);
            while(rset.next()){
                long ID = rset.getInt("ID");
                String spec = rset.getString("speciality");
                String gender = rset.getString("gender");
                String fName = rset.getString("firstName");
                String lName = rset.getString("lastName");
                System.out.println("ID: " + ID + " Speciality: " + spec + " First Name: " + fName + " Last Name: " + lName + " Gender: " + gender);
            }
            str = "SELECT * FROM Appointment";
            rset = stmt.executeQuery(str);
            while(rset.next()){
                long ID = rset.getLong("AptID");
                long tPay = rset.getLong("totalPayment");
                long insCov = rset.getLong("insuranceCoverage");
                long SSN = rset.getLong("patientSSN");
                Timestamp admitDate = rset.getTimestamp("admissionDate");
                Timestamp leaveDate = rset.getTimestamp("leaveDate");
                Timestamp faDate = rset.getTimestamp("futureAptDate");
                System.out.println("AptID: " + ID + " Total Payment: " + tPay + " Insurance Coverage: " + insCov + " Patient SSN: " + SSN + " Admit Date: " + admitDate + " Leave Date: " + leaveDate+ " Future Appointment Date: " + faDate);
            }

        }catch(Exception e){
            throw new Exception(e);
        }
    }
    public static void main(String args[]) throws Exception {
        if(args.length == 2)
            reporting(args[0], args[1]);
        else if(args.length == 3 && Integer.parseInt(args[2]) == 1){
            reporting(args[0], args[1], 1);
        }
    }
}
