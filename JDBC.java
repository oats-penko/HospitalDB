import java.sql.*;

public class JDBC {
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
        reporting("dlsong", "DLSONG");
    }
}
