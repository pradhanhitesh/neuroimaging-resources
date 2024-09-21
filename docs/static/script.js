document.addEventListener("DOMContentLoaded", function () {
    fetch("menu.html")
        .then(response => response.text())
        .then(data => {
            document.getElementById('menu').innerHTML = data;

            // Initialize collapsible functionality after loading menu.html
            var collapsibles = document.querySelectorAll('.collapsible');
            collapsibles.forEach(function (collapsible) {
                collapsible.addEventListener('click', function () {
                    // Close all other collapsible items
                    collapsibles.forEach(function (item) {
                        if (item !== collapsible) {
                            var content = item.nextElementSibling;
                            content.style.display = 'none';
                        }
                    });

                    // Toggle visibility of clicked collapsible item
                    var content = this.nextElementSibling;
                    if (content.style.display === 'block') {
                        content.style.display = 'none';
                    } else {
                        content.style.display = 'block';
                    }
                });
            });
        })
        .catch(error => console.error('Error loading menu:', error));
});
