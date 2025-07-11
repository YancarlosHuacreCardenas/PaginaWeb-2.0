package crud.service;

import crud.database.ProductoDAO;
import crud.model.Producto;
import java.util.List;

public class ProductoService {
    private ProductoDAO productoDAO = new ProductoDAO();

    public List<Producto> obtenerTodos() {
        return productoDAO.listarProductos();
    }
    // Métodos para agregar, editar y eliminar productos pueden agregarse aquí
} 