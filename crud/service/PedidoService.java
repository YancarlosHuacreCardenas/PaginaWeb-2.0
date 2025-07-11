package crud.service;

import crud.database.PedidoDAO;
import crud.model.Pedido;
import java.util.List;

public class PedidoService {
    private PedidoDAO pedidoDAO = new PedidoDAO();

    public List<Pedido> obtenerTodos() {
        return pedidoDAO.listarPedidos();
    }
    // Métodos para agregar, editar y eliminar pedidos pueden agregarse aquí
} 