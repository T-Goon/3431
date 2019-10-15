import java.util.Scanner;
import java.sql.*;

public class pf33 {
    public static void main(String[] args){
        if(args.length < 2) {
            System.out.println("Command line arguments: <username> <password> <menuChoice>");
            return;
        }
        else if (args.length == 2){
            System.out.println("1 – Report Patient Information\n" +
                    "2 – Report Primary Care Physician Information\n" +
                    "3 – Report Operation Information\n" +
                    "4 – Update Patient Blood Type\n" +
                    "5 – Exit Program");
            return;
        }
        else if (args.length > 3){
            System.out.println("Too many command line arguments.");
        }

        Scanner scanner = new Scanner(System.in);

        Connection connection = null;

        try {
            connection = DriverManager.getConnection(
                    "jdbc:oracle:thin:@csorcl.cs.wpi.edu:1521:orcl", args[0], args[1]);
        } catch (SQLException e) {
            System.out.println("Connection Failed! Check output console");
            e.printStackTrace();
            return;
        }

        switch (Integer.parseInt(args[2])){
            case 1:
                System.out.print("Enter Patient’s Healthcare ID: ");
                String healthcareID = scanner.next();
                try{
                    Statement stmt = connection.createStatement();
                    String str = "SELECT * FROM Patient WHERE HEALTHCAREID = " + healthcareID;
                    ResultSet rset = stmt.executeQuery(str);
                    rset.next();
                    System.out.println("Patient Information\n" +
                            "Healthcare ID: " + rset.getString("healthcareID") + "\n" +
                            "First Name: "+ rset.getString("firstName") + "\n" +
                            "Last Name: "+ rset.getString("lastName") + "\n" +
                            "City: "+ rset.getString("city") + "\n" +
                            "State: "+ rset.getString("state") + "\n" +
                            "Birth Date: "+ rset.getString("birthDate") + "\n" +
                            "Blood Type: "+ rset.getString("bloodType"));
                }
                catch(Exception e){
                    System.out.println(e);
                }
                break;
            case 2:
                System.out.print("Enter Primary Care Physician ID: ");
                String PCPID = scanner.next();
                try{
                    Statement stmt = connection.createStatement();
                    String str = "SELECT * FROM " +
                            "PCP JOIN DOCTOR D on PCP.PHYSICIANID = D.PHYSICIANID " +
                            "WHERE PCP.physicianID = " + PCPID;
                    ResultSet rset = stmt.executeQuery(str);
                    rset.next();
                    System.out.println("Primary Care Physician Information\n" +
                            "Full Name: " + rset.getString("firstName") + " " +
                            rset.getString("lastName") + "\n" +
                            "Physician ID: "+ rset.getString("physicianID") + "\n" +
                            "Specialty: "+ rset.getString("specialty") + "\n" +
                            "Medical Facility: "+ rset.getString("medicalFacility"));
                }
                catch(Exception e){
                    System.out.println("May have entered wrong ID: " + PCPID+"\n"+e);
                }
                break;

            case 3:
                System.out.print("Enter Operation Invoice Number: ");
                String invoice = scanner.next();
                try{
                    Statement stmt = connection.createStatement();
                    String str = "SELECT O.invoicenumber, O.operationdate, D.firstname || ' ' || D.lastname " +
                            "AS FullNameS, S.boardcertified, P.firstname || ' ' || P.lastname AS FullNameP, P.city, " +
                            "P.state, P.bloodtype FROM Operation O JOIN DOCTOR D on O.PHYSICIANID = D.PHYSICIANID JOIN " +
                            "Surgeon S ON S.PHYSICIANID = D.PHYSICIANID JOIN Patient P ON O.HEALTHCAREID = P.HEALTHCAREID " +
                            "WHERE O.invoiceNumber = " + invoice;
                    ResultSet rset = stmt.executeQuery(str);
                    rset.next();
                    System.out.println("Operation Information");
                    System.out.println("Invoice Number: " + rset.getString("invoicenumber"));
                    System.out.println("Operation Date: " + rset.getString("operationdate"));
                    System.out.println("Surgeon Full Name: " + rset.getString("FullNameS"));
                    System.out.println("Board Certified?: " + rset.getString("boardcertified"));
                    System.out.println("Patient Full Name: " + rset.getString("FullNameP"));
                    System.out.println("Blood Type: " + rset.getString("bloodtype"));
                    System.out.println("City: " + rset.getString("city"));
                    System.out.println("State: " + rset.getString("state"));
                }
                catch(Exception e){
                    System.out.println("May have entered wrong Operation Invoice Number: " + invoice + "\n" + e);
                }
                break;



            case 4:
                System.out.print("Enter the Patient’s Healthcare ID: ");
                String hid = scanner.next();
                System.out.print("Enter the Updated Blood Type: ");
                String bloodTypeNew = scanner.next();
                try{
                    Statement stmt = connection.createStatement();
                    String str = "UPDATE Patient SET BLOODTYPE = '" + bloodTypeNew + "' WHERE Patient.HEALTHCAREID = " + hid;
                    ResultSet rset = stmt.executeQuery(str);
                    rset.next();
                }
                catch(Exception e){
                    System.out.println("May have entered a Non Existent Patient or Blood Type: " + hid + " " + bloodTypeNew + "\n" + e);
                }
                break;
            default:
                return;
        }

    }
}

