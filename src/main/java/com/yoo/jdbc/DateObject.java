package com.yoo.jdbc;

import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.mysql.jdbc.Connection;
import com.mysql.jdbc.Statement;

/**
 * 基础jdbc
 * @author zelipe
 *
 */
public class DateObject {
	String url =  "jdbc:mysql://localhost:3306/test?user=root&password=yuanyuan&useUnicode=true&characterEncoding=UTF-8";
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	
	public DateObject() throws Exception{
		String driver = "com.mysql.jdbc.Driver";
		Class.forName(driver).newInstance();
		conn = (Connection) DriverManager.getConnection(url);
		stmt = (Statement) conn.createStatement();
	}
	
	/*
	public boolean open(){
		try {
			conn = (Connection) DriverManager.getConnection(url);
			stmt = (Statement) conn.createStatement();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}
		
		return true;
	}
	*/
	
	public boolean close(){
		try {
			conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}
		return true;
	}
	
	public ResultSet query(String sql) throws Exception{
		rs = (ResultSet) stmt.executeQuery(sql);
		return rs;
	}
	
	public boolean execute(String sql) throws SQLException{
		int re = stmt.executeUpdate(sql);
		if(re >= 0){
			this.close();
			return true;
		}
		
		return false;
	}
	
	
	//test
	public static void main(String[] args) throws Exception{
		DateObject conn = new DateObject();
		ResultSet rs = (ResultSet) conn.query("select * from t_user");
		
		while(rs.next()) {
			System.out.println(rs.getString(3));
		}
	}
}
