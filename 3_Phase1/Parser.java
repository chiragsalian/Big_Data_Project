/**
 * 
 * Read the JSON file and load the values in MySQL DB using JDBC Driver
 * 
 */

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Scanner;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import com.mysql.jdbc.Connection;
import com.mysql.jdbc.PreparedStatement;
import com.mysql.jdbc.Statement;

/**
 * JSON Parser to read and load
 * @author sionflash07
 *
 */
public class Parser {
	/*
	 * Attribute
	 */
	JSONObject jsonObj;
	JSONParser jsonParser;
	Connection dbConnection;
	Statement dbStatement;
	PreparedStatement dbPreparedStatement;
	ResultSet dbResultSet;

	/*
	 * Connect to MySQL database using the JDBC Driver
	 * database : yelp
	 * user : sqluser
	 */
	void dbConnect()
	{	
		try {
			// Load MySQL Driver
			Class.forName("com.mysql.jdbc.Driver");			
			// Connect with DB
			dbConnection = (Connection) DriverManager.getConnection("jdbc:mysql://localhost/yelp?"
		              + "user=sqluser&password=sqluserpw");			
			// Init Statement
			dbStatement = (Statement) dbConnection.createStatement();
			// Get Result
//			dbResultSet = dbStatement.executeQuery("select * from yelp.business_main");			
			// Display Table
//			System.out.println(dbResultSet.getMetaData().getTableName(1));
//			while(dbResultSet.next())
//			{	System.out.println(dbResultSet.getString("id"));
//				System.out.println(dbResultSet.getString("fulladdress"));
//			}
			//  Read JSON and Insert value into DB
			Read_business(dbConnection);			
			Read_state(dbConnection);
			read_user_main(dbConnection);
			read_review(dbConnection);
	
			// Close Connection
//			dbResultSet.close();
			dbStatement.close();
			dbConnection.close();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}	
	/*
	 * Constructor
	 */
	Parser()
	{
		jsonObj = new JSONObject();
		jsonParser = new JSONParser();
	}
	
	/*
	 * Read Business JSON file and load into DB
	 */
	void Read_business(Connection dbConnection) throws ParseException, IOException
	{
			Object obj;
			PreparedStatement dbPreparedStatement;
			try {				
				Scanner scn = new Scanner(new File("business.json"));
				ArrayList<JSONObject> bus_array = new ArrayList<JSONObject>();
				/*
				 * Read the JSON Objects into JSON Array
				 */
				while(scn.hasNextLine())
				{
					JSONObject obj1 =(JSONObject) jsonParser.parse(scn.nextLine());					
					bus_array.add(obj1);					
				}								
				/*
				 * Extract data from Each JSON Object into an Object
				 */
				for(JSONObject bus_unit : bus_array)
				{
					System.out.println(bus_unit.get("business_id"));
					System.out.println(bus_unit.get("full_address"));
					System.out.println(bus_unit.get("open"));
					System.out.println(bus_unit.get("city"));
					System.out.println(bus_unit.get("review_count"));
					System.out.println(bus_unit.get("name"));
					System.out.println(bus_unit.get("longitude"));
					System.out.println(bus_unit.get("state"));
					System.out.println(bus_unit.get("stars"));
					System.out.println(bus_unit.get("latitude"));
					/*
					 * Business Main Table Entry
					 */
					dbPreparedStatement = (PreparedStatement) dbConnection.prepareStatement("insert into yelp.business_main"
							+ " values (?,?,?,?,?,?,?,?,?)");
					dbPreparedStatement.setString(1,(String) bus_unit.get("business_id"));
					dbPreparedStatement.setString(2,(String) bus_unit.get("full_address"));
					dbPreparedStatement.setString(3,(String) bus_unit.get("city"));
					dbPreparedStatement.setLong(4, (long) bus_unit.get("review_count"));
					dbPreparedStatement.setString(5,(String) bus_unit.get("state"));
					dbPreparedStatement.setString(6,(String) bus_unit.get("name"));					
					dbPreparedStatement.setDouble(7, (double) bus_unit.get("longitude"));										
					dbPreparedStatement.setDouble(8, (double) bus_unit.get("latitude"));										
					dbPreparedStatement.setDouble(9, (double) bus_unit.get("stars"));										
					dbPreparedStatement.executeUpdate();					

					/*
					 * Business Time Table Entry
					 */
//					dbPreparedStatement = (PreparedStatement) dbConnection.prepareStatement("insert into yelp.business_hours"
//							+ " values (?,?,?,?,?,?,?,?,?)");
//					dbPreparedStatement.setString(1,(String) bus_unit.get("business_id"));
															
					//					// Categories categories
//					JSONArray cat = (JSONArray) bus_unit.get("categories");
//					Iterator<String> iterator = cat.iterator();
//					while(iterator.hasNext())
//					{
//						System.out.println(iterator.next());
//					}										
				}				
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}		
	}	
	/*
	 * Read the State Details
);
	 */
	void Read_state(Connection dbConnection) throws ParseException, IOException, SQLException
	{

			PreparedStatement dbPreparedStatement;
			try {				
				/*
				 * Read the JSON Array
				 */								
				JSONArray json_array1 = (JSONArray) jsonParser.parse(new FileReader("state.json"));
				/*
				 * Extract data from Each JSON Object into an Object
				 */
				Iterator<JSONObject> iterator = json_array1.iterator();
				
				while(iterator.hasNext())
				{
					JSONObject obj_item = iterator.next();
					System.out.println(obj_item.get("abbreviation"));
					System.out.println(obj_item.get("name"));					
					/*
					 * State Main Table Entry
					 */
					dbPreparedStatement = (PreparedStatement) dbConnection.prepareStatement("insert into yelp.state"
							+ " values (?,?)");
					dbPreparedStatement.setString(1,(String) obj_item.get("abbreviation"));
					dbPreparedStatement.setString(2,(String) obj_item.get("name"));
					dbPreparedStatement.executeUpdate();	
				}
			
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}		
	}

/*
 * 	Read User Details 
 */
	void read_user_main(Connection dbConnection) throws ParseException, IOException
	{
			Object obj;
			PreparedStatement dbPreparedStatement1;
			PreparedStatement dbPreparedStatement2;
			try {				
				Scanner scn = new Scanner(new File("user.json"));
				ArrayList<JSONObject> json_array = new ArrayList<JSONObject>();
				/*
				 * Read the JSON Objects into JSON Array
				 */
				while(scn.hasNextLine())
				{
					JSONObject obj1 =(JSONObject) jsonParser.parse(scn.nextLine());					
					json_array.add(obj1);					
				}								
				/*
				 * Extract data from Each JSON Object into an Object
				 */
				for(JSONObject json_unit : json_array)
				{
					/*
					 * User Main Table Entry
					 */
					dbPreparedStatement1 = (PreparedStatement) dbConnection.prepareStatement("insert into yelp.user_main"
							+ " values (?,?,?,?,?,?,?,?)");
					dbPreparedStatement1.setString(1,(String) json_unit.get("user_id"));
					dbPreparedStatement1.setLong(2, (long) json_unit.get("review_count"));
					dbPreparedStatement1.setString(3,(String) json_unit.get("name"));					
					dbPreparedStatement1.setDouble(4, (double) json_unit.get("average_stars"));										
					dbPreparedStatement1.setLong(5, (long) json_unit.get("fans"));
					JSONObject votes = (JSONObject) json_unit.get("votes");
					dbPreparedStatement1.setLong(6, (long) votes.get("funny"));						
					dbPreparedStatement1.setLong(7, (long) votes.get("cool"));						
					dbPreparedStatement1.setLong(8, (long) votes.get("useful"));						
					dbPreparedStatement1.executeUpdate();					
					/*
					 * User detail Table Entry
					 */
					dbPreparedStatement2 = (PreparedStatement) dbConnection.prepareStatement("insert into yelp.user_detail"
							+ " values (?,?,?,?,?,?,?,?,?,?,?)");
					dbPreparedStatement2.setString(1,(String) json_unit.get("user_id"));
					JSONObject compliments = (JSONObject) json_unit.get("compliments");					
					dbPreparedStatement2.setLong(2, (long) compliments.get("profile"));
					dbPreparedStatement2.setLong(3, (long) compliments.get("cute"));
					dbPreparedStatement2.setLong(4, (long) compliments.get("funny"));
					dbPreparedStatement2.setLong(5, (long) compliments.get("plain"));
					dbPreparedStatement2.setLong(6, (long) compliments.get("writer"));
					dbPreparedStatement2.setLong(7, (long) compliments.get("note"));
					dbPreparedStatement2.setLong(8, (long) compliments.get("photos"));
					dbPreparedStatement2.setLong(9, (long) compliments.get("hot"));
					dbPreparedStatement2.setLong(10, (long) compliments.get("cool"));
					dbPreparedStatement2.setLong(11, (long) compliments.get("more"));
					dbPreparedStatement2.executeUpdate();				
				}				
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}		
	}	
/*
 * Read Review	
 */
	void read_review(Connection dbConnection) throws ParseException, IOException
	{
			Object obj;
			PreparedStatement dbPreparedStatement;
			try {				
				Scanner scn = new Scanner(new File("review.json"));
				ArrayList<JSONObject> json_array = new ArrayList<JSONObject>();
				/*
				 * Read the JSON Objects into JSON Array
				 */
				while(scn.hasNextLine())
				{
					JSONObject obj1 =(JSONObject) jsonParser.parse(scn.nextLine());					
					json_array.add(obj1);					
				}								
				/*
				 * Extract data from Each JSON Object into an Object
				 */
				for(JSONObject json_unit : json_array)
				{
					/*
					 * Business Main Table Entry
					 */
					dbPreparedStatement = (PreparedStatement) dbConnection.prepareStatement("insert into yelp.review"
							+ " values (?,?,?,?,?,?,?,?,?)");
					dbPreparedStatement.setString(1,(String) json_unit.get("review_id"));
					dbPreparedStatement.setString(2,(String) json_unit.get("business_id"));
					dbPreparedStatement.setString(3,(String) json_unit.get("user_id"));
					dbPreparedStatement.setLong(4, (long) json_unit.get("stars"));
					dbPreparedStatement.setString(5,(String) json_unit.get("text"));
					JSONObject votes = (JSONObject) json_unit.get("votes");
					dbPreparedStatement.setLong(6, (long) votes.get("funny"));						
					dbPreparedStatement.setLong(7, (long) votes.get("cool"));						
					dbPreparedStatement.setLong(8, (long) votes.get("useful"));	
					dbPreparedStatement.setString(9, (String) json_unit.get("date"));					
					dbPreparedStatement.executeUpdate();					
				}				
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}		
	}		
}
