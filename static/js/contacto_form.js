// JS para validación y feedback del formulario de contacto
document.getElementById('contacto-form').addEventListener('submit', function(e) {
    const submitBtn = document.getElementById('submit-btn');
    const btnText = document.getElementById('btn-text');
    const btnLoading = document.getElementById('btn-loading');
    // Mostrar estado de carga
    submitBtn.disabled = true;
    btnText.classList.add('hidden');
    btnLoading.classList.remove('hidden');
    submitBtn.classList.add('opacity-75');
});
// Validación en tiempo real
document.querySelectorAll('#contacto-form input, #contacto-form textarea').forEach(input => {
    input.addEventListener('blur', function() {
        if (this.hasAttribute('required') && !this.value.trim()) {
            this.classList.add('border-red-500');
            this.classList.remove('border-gray-300');
        } else {
            this.classList.remove('border-red-500');
            this.classList.add('border-gray-300');
        }
    });
    input.addEventListener('input', function() {
        if (this.value.trim()) {
            this.classList.remove('border-red-500');
            this.classList.add('border-gray-300');
        }
    });
}); 