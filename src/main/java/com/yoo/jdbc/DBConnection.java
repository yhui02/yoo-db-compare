package com.yoo.jdbc;

import com.mysql.jdbc.Connection;
import com.mysql.jdbc.ResultSetMetaData;
import com.mysql.jdbc.Statement;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author yohann
 */
public class DBConnection {

    private static final Logger logger = LoggerFactory.getLogger(DBConnection.class);

    public DBConnection() {
    }

    public Connection getConn(String connUrl) {
        Connection conn = null;

        String driver = "com.mysql.jdbc.Driver";
        String url = "jdbc:" + connUrl + "&useUnicode=true&characterEncoding=UTF-8";

        try {
            Class.forName(driver);
            conn = (Connection) DriverManager.getConnection(url);

            if (conn != null && !conn.isClosed()) {
                return conn;
            }

        } catch (ClassNotFoundException e) {
            logger.error("找不到驱动程序类型！");
            e.printStackTrace();
        } catch (SQLException e) {
            logger.error("connection database error: ==" + connUrl + "== at " + new java.util.Date());
            e.printStackTrace();
        }

        return conn;
    }

    public List getAllTables(String connUrl) throws SQLException {
        List list = new ArrayList();

        DBConnection dbconn = new DBConnection();

        Connection conn = dbconn.getConn(connUrl);
        if (conn != null && !conn.isClosed()) {
            Statement stmt = (Statement) conn.createStatement();
            ResultSet result = (ResultSet) stmt.executeQuery("SHOW TABLE STATUS");
//			ResultSetMetaData rsmd = (ResultSetMetaData) result.getMetaData();
//			int numberOfColumns = rsmd.getColumnCount();

            while (result.next()) {
                Map map = new HashMap();
                map.put("tableName", result.getString(1));
                map.put("tableNote", result.getString(18));
                list.add(map);
            }
            conn.close();
        } else {
            return null;
        }

        return list;
    }

    public List getTablecolumn(String connUrl, String tableName) throws SQLException {
        List list = new ArrayList();

        DBConnection dbconn = new DBConnection();

        Connection conn = dbconn.getConn(connUrl);
        if (conn != null && !conn.isClosed()) {
            Statement stmt = (Statement) conn.createStatement();
            ResultSet result = (ResultSet) stmt.executeQuery("describe " + tableName);
            ResultSetMetaData rsmd = (ResultSetMetaData) result.getMetaData();
            int numberOfColumns = rsmd.getColumnCount();
            while (result.next()) {
                String[] columns = new String[numberOfColumns];
                for (int i = 0; i < numberOfColumns; i++) {
                    columns[i] = result.getString(i + 1);
                }

                list.add(columns);
            }
        }

        return list;
    }

    public String[] getShowCreateTable(String connUrl, String tableName) throws SQLException {
        String[] resultArr = null;

        DBConnection dbconn = new DBConnection();
        Connection conn = dbconn.getConn(connUrl);
        if (conn != null && !conn.isClosed()) {
            Statement stmt = (Statement) conn.createStatement();
            ResultSet result = (ResultSet) stmt.executeQuery("show create table " + tableName);
            ResultSetMetaData rsmd = (ResultSetMetaData) result.getMetaData();
            int numberOfColumns = rsmd.getColumnCount();
            resultArr = new String[numberOfColumns];
            while (result.next()) {
                for (int i = 0; i < numberOfColumns; i++) {
                    resultArr[i] = result.getString(i + 1);
                }

            }
        }

        return resultArr;
    }

    public boolean executeSql(String connUrl, String sql) throws SQLException {
        boolean res = true;
        DBConnection dbconn = new DBConnection();
        Connection conn = dbconn.getConn(connUrl);
        if (conn != null && !conn.isClosed()) {
            Statement stmt = (Statement) conn.createStatement();
            res = stmt.execute(sql);
        }

        return res;
    }

}
