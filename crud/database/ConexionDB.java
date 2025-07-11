package crud.database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionDB {
    private static final String URL = "jdbc:mysql://pagianweb2.cbddj5emoatz.us-east-1.rds.amazonaws.com:3306/bycint";
    private static final String USER = "admin";
    private static final String PASSWORD = "diego123456";

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
} 