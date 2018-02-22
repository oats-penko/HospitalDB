import java.sql.*;
import java.util.Scanner;

/**
 * Created by aliss on 2/22/2018.
 */


public class Reporting {
    public static void main(String[] argv) {


        int argCount = argv.length;
        if (argCount < 2) {
            System.out.println("Invalid arguments entered");
        } else {
            String uname, pw;
            uname = argv[0];
            pw = argv[1];
            try {
                Class.forName("oracle.jdbc.driver.OracleDriver");
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
                System.out.println("JDBC Driver not found.");
                return;
            }
            Connection conn = null;
            try {
                conn = DriverManager.getConnection("jdbc:oracle:thin:@oracle.wpi.edu:1521:orcl", uname, pw);
            } catch (SQLException e) {
                e.printStackTrace();
                System.out.println("Connection unsuccessful.");
            }
            if (conn != null) {
                if (argCount == 2) {
                    String l1, l2, l3, l4;
                    l1 = "1- Report Patients Basic Information";
                    l2 = "2- Report Doctors Basic Information";
                    l3 = "3- Report Admissions Information";
                    l4 = "4- Update Admissions Payment";
                    System.out.println(l1 + "\n" + l2 + "\n" + l3 + "\n" + l4);
                    return;
                } else if (argCount == 3) {
                    try {
                        int option = Integer.parseInt(argv[2]);
                        Scanner reader = new Scanner(System.in);  // Reading from System.in
                        Statement stmt = null;

                        stmt = conn.createStatement();
                        String str;

                        switch (option) {
                            case 1:
                                System.out.println("Enter a patient's SSN: ");
                                int SSN = reader.nextInt(); // Scans the next token of the input as an int
                                str = "SELECT * FROM Patient WHERE Patient.SSN=" + SSN;
                                ResultSet rset1 = stmt.executeQuery(str);
                                while(rset1.next()){
                                    long SSN2 = rset1.getLong("SSN");
                                    long pNum = rset1.getLong("phoneNum");
                                    String fName = rset1.getString("firstName");
                                    String lName = rset1.getString("lastName");
                                    String addr = rset1.getString("addr");
                                    System.out.printf("Patient SSN: %d\n",SSN2);
                                    System.out.printf("Patient First Name: %s\n",fName);
                                    System.out.printf("Patient Last Name: %s\n",lName);
                                    System.out.printf("Patient Address: %s\n",addr);
                                }
                                rset1.close();
                                break;
                            case 2:
                                System.out.println("Enter Doctor ID: ");
                                int dID = reader.nextInt(); // Scans the next token of the input as an int
                                str = "SELECT * FROM Doctor WHERE Doctor.ID = " + dID;
                                ResultSet rset2 = stmt.executeQuery(str);
                                while(rset2.next()){
                                    long ID = rset2.getInt("ID");
                                    //String spec = rset.getString("speciality");
                                    String gender = rset2.getString("gender");
                                    String fName = rset2.getString("firstName");
                                    String lName = rset2.getString("lastName");
                                    System.out.printf("Doctor ID: %d\n",ID);
                                    System.out.printf("Doctor First Name: %s\n",fName);
                                    System.out.printf("Doctor Last Name: %s\n",lName);
                                    System.out.printf("Doctor Gender: %s\n",gender);
                                }
                                rset2.close();
                                break;
                            case 3:
                                System.out.println("Enter Admission (Appointment) Number: ");
                                int aptID = reader.nextInt(); // Scans the next token of the input as an int
                                str = "SELECT * FROM Appointment A WHERE A.AptID = " + aptID ;
                                ResultSet rset3 = stmt.executeQuery(str);
                                while(rset3.next()){
                                    long ID = rset3.getLong("AptID");
                                    long tPay = rset3.getLong("totalPayment");
                                    //long insCov = rset.getLong("insuranceCoverage");
                                    long pSSN = rset3.getLong("patientSSN");
                                    Date admitDate = rset3.getDate("admissionDate");
                                    //Timestamp leaveDate = rset.getTimestamp("leaveDate");
                                    //Date faDate = rset.getDate("futureAptDate");
                                    System.out.printf("Admission Number: %d\n",ID);
                                    System.out.printf("Patient SSN: %s\n",pSSN);
                                    System.out.printf("Admission date (start date): %s\n",admitDate);
                                    System.out.printf("Total Payment: %s\n",tPay);
                                }
                                rset3.close();

                                str = "SELECT R.roomNumber, R.endDate, R.startDate FROM AptRoom R WHERE R.aptID =  " + aptID;
                                ResultSet rooms = stmt.executeQuery(str);
                                while(rooms.next()){
                                    long roomNum = rooms.getInt("roomNumber");
                                    Date admitDate = rooms.getDate("startDate");
                                    Date lvDate = rooms.getDate("endDate");

                                    System.out.println("Room Number: " + roomNum + " FromDate: " + admitDate + " ToDate: " + lvDate + "\n");
                                }
                                rooms.close();

                                str = "SELECT DISTINCT E.docID FROM Examine E WHERE E.aptID =  " + aptID;
                                ResultSet docs = stmt.executeQuery(str);
                                while(docs.next()){
                                    long docID = docs.getInt("docID");
                                    System.out.println("Doctor ID: " + docID + "\n");
                                }
                                docs.close();


                                break;
                            case 4:
                                System.out.println("Enter Admission (Appointment) Number: ");
                                int aID = reader.nextInt(); // Scans the next token of the input as an int
                                System.out.println("Eneter the new total payment: ");
                                int total = reader.nextInt(); // Scans the next token of the input as an int
                                str = "UPDATE Appointment SET totalPayment = " + total + " WHERE AptID = " + aID;
                                stmt.executeUpdate(str);
                                break;
                        }
                        stmt.close();
                        conn.close();
                    } catch (NumberFormatException nfe) {
                        // argument is not a valid integer
                        System.out.println("The third argument must be an integer.");
                        System.exit(1);
                    } catch (SQLException e) {
                        e.printStackTrace();
                        System.out.println("Statement creation unsuccessful.");
                    }
                    catch(Exception e){
                        e.printStackTrace();
                        System.out.println("SQL Exception: Could not query Patient Table");
                    }
                }
            }


        }
        return;
    }
}
