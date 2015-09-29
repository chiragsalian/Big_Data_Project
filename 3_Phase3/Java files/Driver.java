//**************************************************************
// Program 		: Driver.java
// Author  		: Shiv,Chirag,Latish
// Description  : The Driver program to parser the JSON files
//  			  and load them in MYSQL DB
//**************************************************************

import org.json.simple.parser.ParseException;


public class Driver {

	public static void main(String[] args) {
		
		Parser run = new Parser();
		run.dbConnect();
//			run.Read();
	}

}
