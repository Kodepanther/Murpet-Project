document.addEventListener('DOMContentLoaded', () => {
    console.log('Murpet App Loaded');
    
    const btn = document.querySelector('.btn');
    btn.addEventListener('click', (e) => {
        e.preventDefault();
        alert('Welcome to the Murpet V2 Experience!');
    });
});