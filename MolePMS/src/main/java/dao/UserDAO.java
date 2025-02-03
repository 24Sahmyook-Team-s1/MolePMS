package dao;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;

import javax.naming.NamingException;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import util.ConnectionPool;

public class UserDAO {

	public boolean insert(String id, String mail, String name, String pw) throws NamingException, SQLException {
		Connection conn = null;
		PreparedStatement stmt = null;
		try {
			String sql = "INSERT INTO user(PROJECTUSERID, EMAIL, NAME, PASSWORD, CREATEDAT) "
					+ "VALUES(?, ?, ?, ?, SYSDATE)";

			conn = ConnectionPool.get();
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, id);
			stmt.setString(2, mail);
			stmt.setString(3, name);
			stmt.setString(4, getEncrypt(pw));

			int count = stmt.executeUpdate();
			return (count == 1) ? true : false;

		} finally {
			if (stmt != null)
				stmt.close();
			if (conn != null)
				conn.close();
		}
	}

	public boolean exists(String id) throws NamingException, SQLException {
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		try {
			String sql = "SELECT PROJECTUSERID FROM PROJECTUSERS WHERE PROJECTUSERID = ?";

			conn = ConnectionPool.get();
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, id);

			rs = stmt.executeQuery();
			return rs.next();

		} finally {
			if (rs != null)
				rs.close();
			if (stmt != null)
				stmt.close();
			if (conn != null)
				conn.close();
		}
	}

	public boolean delete(String id) throws NamingException, SQLException {
		Connection conn = null;
		PreparedStatement stmt = null;
		try {
			String sql = "DELETE FROM PROJECTUSERS WHERE PROJECTUSERID = ?";

			conn = ConnectionPool.get();
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, id);

			int count = stmt.executeUpdate();
			return (count == 1) ? true : false;

		} finally {
			if (stmt != null)
				stmt.close();
			if (conn != null)
				conn.close();
		}
	}

	public int login(String id, String pw)
			throws NamingException, SQLException, ParseException, NoSuchAlgorithmException, ClassNotFoundException {
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;

		try {
			String sql = "SELECT PASSWORD FROM user WHERE PROJECTUSERID = ?";

			conn = ConnectionPool.get();
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, id);

			rs = stmt.executeQuery();
			if (!rs.next())
				return 1;

			String spw = rs.getString("PASSWORD");
			if (!getEncrypt(pw).equals(spw))
				return 2;

			return 0;

		} finally {
			if (rs != null)
				rs.close();
			if (stmt != null)
				stmt.close();
			if (conn != null)
				conn.close();
		}
	}

//    public String getList() throws NamingException, SQLException {
//    	Connection conn = ConnectionPool.get();
//    	PreparedStatement stmt = null;
//    	ResultSet rs = null;
//    	try {
//    	
//    		String sql = "SELECT * FROM PROJECTUSERS";
//	    	stmt = conn.prepareStatement(sql);
//	    	rs = stmt.executeQuery();
//    	
//    	String str = "[";
//	    	int cnt = 0;
//	    	while(rs.next()) {
//	    		if (cnt++ > 0) str += ", ";
//	    			str += rs.getString("PASSWORD");
//	    		}
//	    	return str + "]";
//    	} finally {
//            if (rs != null) rs.close(); 
//            if (stmt != null) stmt.close(); 
//            if (conn != null) conn.close();
//        }
//    }

//	public String get(String uid) throws NamingException, SQLException {
//		Connection conn = null;
//		PreparedStatement stmt = null;
//		ResultSet rs = null;
//		try {
//			String sql = "SELECT PASSWORD FROM PROJECTUSERS WHERE PROJECTUSERID = ?";
//
//			conn = ConnectionPool.get();
//			stmt = conn.prepareStatement(sql);
//			stmt.setString(1, uid);
//
//			rs = stmt.executeQuery();
//			return rs.next() ? rs.getString("jsonstr") : "{}";
//
//		} finally {
//			if (rs != null)
//				rs.close();
//			if (stmt != null)
//				stmt.close();
//			if (conn != null)
//				conn.close();
//		}
//	}

	public boolean update(String id, String pw) throws NamingException, SQLException {
		Connection conn = ConnectionPool.get();
		PreparedStatement stmt = null;
		try {
			String sql = "UPDATE PROJECTUSERS SET PASSWORD = ? WHERE PROJECTUSERID =?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, getEncrypt(pw));
			stmt.setString(2, id);

			int count = stmt.executeUpdate();
			return (count == 1) ? true : false;

		} finally {
			if (stmt != null)
				stmt.close();
			if (conn != null)
				conn.close();
		}
	}

	public static String getEncrypt(String pwd) {

		String result = "";
		String salt = "5f385262c1157543bc1fbc8000901019a39784aa";
		System.out.println("salt : " + salt);
		try {
			// 1. SHA256 알고리즘 객체 생성
			MessageDigest md = MessageDigest.getInstance("SHA-256");

			// 2. 비밀번호와 salt 합친 문자열에 SHA 256 적용
			md.update((pwd + salt).getBytes());
			byte[] pwdsalt = md.digest();

			// 3. byte To String (10진수의 문자열로 변경)
			StringBuffer sb = new StringBuffer();
			for (byte b : pwdsalt) {
				sb.append(String.format("%02x", b));
			}

			result = sb.toString();
			// System.out.println("비밀번호 + salt 적용 후 : " + result);

		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}

		return result;
	}

}
