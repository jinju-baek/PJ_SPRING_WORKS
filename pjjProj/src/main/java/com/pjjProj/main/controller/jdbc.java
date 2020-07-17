package com.pjjProj.main.controller;

import java.sql.*;

public class jdbc {

	public static void main(String[] args) throws ClassNotFoundException{
		try {
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
			String connectionUrl = "jdbc:sqlserver://211.196.231.250:1433;database=NEWCEMS";
			Connection conn = DriverManager.getConnection(connectionUrl, "cemsuser", "vkfksakswkd8");
			Statement stmt = conn.createStatement();
			System.out.println("MS-SQL 서버 접속에 성공하였습니다.");
			ResultSet rs = stmt.executeQuery("SELECT * FROM PJJ_EMPLOYEE");
			while(rs.next()) {
				String field1 = rs.getString("ID");
				String field2 = rs.getString("PW");
				System.out.println(field1 + "\t");
				System.out.println(field2);
			}
			rs.close();
			stmt.close();
			conn.close();
		} catch (SQLException sqle) {
			System.out.println("SQLException : " + sqle);
		}

	}

}
