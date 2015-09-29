//*********************************************************************
// Program 		: Driver.java
// Author  		: Shiv,Chirag,Latish
// Description	: Parse the JSON file and load the data into
//				  MYSQL DB using JDBC.
// Comment      : The JSON files have been harcoded and please verify
//				  the files are present in the root directory of project
//**********************************************************************

/*
	Dependencies
*/
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
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
			//  Read JSON and Insert value into DB
			// Read Business,State ,User,Review Files in order to satisfy the integrity constraints
			Read_state(dbConnection);
			Read_business(dbConnection);			
			read_user_main(dbConnection);
			read_review(dbConnection);

			// Close the conncetion
			dbStatement.close();
			dbConnection.close();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (ParseException e) {
			e.printStackTrace();
		} catch (IOException e) {
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
			HashMap<String, String> businessCategories = new HashMap<String, String>();
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
					try {
						dbPreparedStatement.execute();								
					} catch (SQLException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}	
					/*
					 * Business Time Table Entry
					 */
					dbPreparedStatement =	 (PreparedStatement) dbConnection.prepareStatement("insert into yelp.business_hours"
							+ " values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
					
					JSONObject hours = (JSONObject) bus_unit.get("hours");
					System.out.println(hours);
					// Random text
					// Business ID
					int count_index=1;
					dbPreparedStatement.setString(count_index++,(String) bus_unit.get("business_id"));
					// Monday
					String days[] = {"Monday","Tuesday","Wednesday","Thursday",
							"Friday","Saturday","Sunday"};
					JSONObject day_obj;
					for(String day : days)
					{
						day_obj = (JSONObject) hours.get(day);
						if(day_obj!=null)
						{
							// Monday Time
							dbPreparedStatement.setString(count_index++,(String) day_obj.get("open"));												
							dbPreparedStatement.setString(count_index++,(String) day_obj.get("close"));
						}
						else
						{
							dbPreparedStatement.setNull(count_index++, Types.NULL);										
							dbPreparedStatement.setNull(count_index++, Types.NULL);										
						}											
					}
					try {
						dbPreparedStatement.execute();								
					} catch (SQLException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}	

					/*
					 * Business Categories
					 */
					
					JSONArray bus_cat = (JSONArray) bus_unit.get("categories");
					for(int i=0;i<bus_cat.size();i++)
					{
						/*
						 * If not present add to table and hash map
						 */
						
						if(!businessCategories.containsKey(bus_cat.get(i).toString()))
						{
							// Add to Hash Map
							businessCategories.put(bus_cat.get(i).toString(), bus_cat.get(i).toString());							
							// Add to Table
							dbPreparedStatement = (PreparedStatement) dbConnection.prepareStatement("insert into yelp.categories"
									+ " values (?)");
							dbPreparedStatement.setString(1,bus_cat.get(i).toString());							
							try {
								dbPreparedStatement.execute();								

							
							} catch (SQLException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}	
						}
						/*
						 * Business Category mapping
						 * Determine the unique business categories
						 */
						dbPreparedStatement = (PreparedStatement) dbConnection.prepareStatement("insert into yelp.business_category"
								+ " values (?,?)");
						
						dbPreparedStatement.setString(1,(String) bus_unit.get("business_id"));
						dbPreparedStatement.setString(2,bus_cat.get(i).toString());
						try {
							dbPreparedStatement.execute();								
						
						} catch (SQLException e) {
							e.printStackTrace();
						}	
					}					
				}				
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			} catch (SQLException e) {
				e.printStackTrace();
			}		
	}	
	/*
	 * Read the State Details
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
					/*
					Extract the details from the JSON Object
					*/
					JSONObject votes = (JSONObject) json_unit.get("votes");
					dbPreparedStatement.setLong(6, (long) votes.get("funny"));						
					dbPreparedStatement.setLong(7, (long) votes.get("cool"));						
					dbPreparedStatement.setLong(8, (long) votes.get("useful"));	
					dbPreparedStatement.setString(9, (String) json_unit.get("date"));					
					dbPreparedStatement.executeUpdate();					
				}				
			} catch (FileNotFoundException e) {

				e.printStackTrace();
			} catch (SQLException e) {
				e.printStackTrace();
			}		
	}		
}
