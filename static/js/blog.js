// blog.js - Carrusel y animaciones para la sección de comunidad/blog

document.addEventListener('DOMContentLoaded', function() {
  // Inicializar carrusel de blogs si existe
  if (typeof Swiper !== 'undefined') {
    new Swiper('.blogSwiper', {
      slidesPerView: 1,
      spaceBetween: 32,
      loop: true,
      navigation: {
        nextEl: '.swiper-button-next',
        prevEl: '.swiper-button-prev',
      },
      pagination: {
        el: '.swiper-pagination',
        clickable: true,
      },
      breakpoints: {
        640: { slidesPerView: 1 },
        768: { slidesPerView: 2 },
        1024: { slidesPerView: 4 },
      },
    });
  }
  // Aquí puedes agregar animaciones para las tarjetas de blog
  // AJAX para comentarios de blog
  const form = document.querySelector('form[method="POST"]');
  const comentariosList = document.querySelector('.comentarios-list');
  if (form && comentariosList) {
    const btn = form.querySelector('button[type="submit"]');
    form.addEventListener('submit', function(e) {
      e.preventDefault();
      if (btn) btn.disabled = true;
      const data = new FormData(form);
      data.append('blog_id', window.BLOG_ID || form.dataset.blogId);
      fetch('/api/comentarios_blog', {
        method: 'POST',
        body: data
      })
      .then(res => res.json())
      .then(json => {
        if (btn) btn.disabled = false;
        if (json.success) {
          form.reset();
          // Crear el nuevo comentario y ponerlo arriba
          const c = json.comentario;
          const li = document.createElement('li');
          li.className = 'bg-white rounded shadow p-4 animate-fadein';
          li.innerHTML = `<div class=\"flex items-center gap-2 mb-1\">
            <span class=\"font-semibold text-green-600\">${c.usuario.split('@')[0]}</span>
            <span class=\"text-yellow-400 text-lg\">${'★'.repeat(c.puntuacion)}${'☆'.repeat(5-c.puntuacion)}</span>
          </div>
          <div class=\"text-gray-800\">${c.comentario}</div>`;
          comentariosList.prepend(li);
          mostrarMensaje('¡Comentario enviado!', 'success');
        } else {
          mostrarMensaje(json.message || 'Error al enviar comentario', 'error');
          console.error('Error al enviar comentario:', json);
        }
      })
      .catch(err => {
        if (btn) btn.disabled = false;
        mostrarMensaje('Error de red al enviar comentario', 'error');
        console.error('Error de red:', err);
      });
    });
    function cargarComentarios() {
      const blogId = window.BLOG_ID || form.dataset.blogId;
      fetch(`/api/comentarios_blog?blog_id=${blogId}`)
        .then(res => res.json())
        .then(json => {
          comentariosList.innerHTML = '';
          if (json.comentarios && json.comentarios.length) {
            json.comentarios.forEach(c => {
              const li = document.createElement('li');
              li.className = 'bg-white rounded shadow p-4';
              li.innerHTML = `<div class=\"flex items-center gap-2 mb-1\">
                <span class=\"font-semibold text-green-600\">${c.usuario.split('@')[0]}</span>
                <span class=\"text-yellow-400 text-lg\">${'★'.repeat(c.puntuacion)}${'☆'.repeat(5-c.puntuacion)}</span>
              </div>
              <div class=\"text-gray-800\">${c.comentario}</div>`;
              comentariosList.appendChild(li);
            });
          } else {
            comentariosList.innerHTML = '<div class=\"text-gray-500\">Aún no hay comentarios. ¡Sé la primera en comentar!</div>';
          }
        })
        .catch(err => {
          comentariosList.innerHTML = '<div class=\"text-red-500\">Error al cargar comentarios</div>';
          console.error('Error al cargar comentarios:', err);
        });
    }
    function mostrarMensaje(msg, tipo) {
      let alerta = document.getElementById('alerta-comentario');
      if (!alerta) {
        alerta = document.createElement('div');
        alerta.id = 'alerta-comentario';
        alerta.className = 'fixed top-6 left-1/2 transform -translate-x-1/2 z-50 px-6 py-3 rounded shadow-lg text-white font-bold';
        document.body.appendChild(alerta);
      }
      alerta.textContent = msg;
      alerta.style.background = tipo === 'success' ? '#22c55e' : '#ef4444';
      alerta.style.display = 'block';
      setTimeout(() => { alerta.style.display = 'none'; }, 2500);
    }
    cargarComentarios();
  }
}); 