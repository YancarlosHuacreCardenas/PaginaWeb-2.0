package crud.database;

import crud.model.Pedido;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PedidoDAO {
    public List<Pedido> listarPedidos() {
        List<Pedido> pedidos = new ArrayList<>();
        try (Connection conn = ConexionDB.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM pedidos")) {
            while (rs.next()) {
                Pedido p = new Pedido();
                p.setId(rs.getInt("id"));
                p.setUsuarioId(rs.getInt("usuario_id"));
                p.setTotal(rs.getDouble("total"));
                p.setEstado(rs.getString("estado"));
                p.setFecha(rs.getString("fecha"));
                pedidos.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return pedidos;
    }
    // Métodos para agregar, editar y eliminar pedidos pueden agregarse aquí
} 