document.getElementById('uploadForm').addEventListener('submit', async function(event) {
    event.preventDefault();

    const form = event.target;
    const submitBtn = document.getElementById('submitBtn');
    const statusMessage = document.getElementById('statusMessage');

    // UI zurücksetzen während des Ladens
    submitBtn.disabled = true;
    statusMessage.className = 'hidden';

    // FormData liest automatisch alle Formularfelder aus
    const formData = new FormData(form);

    try {
        const response = await fetch('/api/upload', {
            method: 'POST',
            body: formData
        });

        if (response.ok) {
            statusMessage.textContent = 'Uploaded successfully!';
            statusMessage.className = 'success';
            form.reset(); 
        } else {
            statusMessage.textContent = `Server error: Status ${response.status}`;
            statusMessage.className = 'error';
        }
    } catch (error) {
        console.error('Error during POST request:', error);
        statusMessage.textContent = 'Connection error to the server.';
        statusMessage.className = 'error';
    } finally {
        submitBtn.disabled = false;
    }


    // logik und Struktur hinzufügen für connection 

});
