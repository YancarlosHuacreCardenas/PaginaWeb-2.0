// JS para compartir blog
function compartirBlog(titulo, url) {
  if (navigator.share) {
    navigator.share({ title: titulo, url: url });
  } else {
    prompt('Copia este enlace para compartir:', url);
  }
} 