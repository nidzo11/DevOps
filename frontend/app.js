document.getElementById("loadData").addEventListener("click", function () {
    fetch("/api/data")
        .then(response => response.json())
        .then(data => {
            const dataList = document.getElementById("dataList");
            dataList.innerHTML = "";
            data.forEach(item => {
                const li = document.createElement("li");
                li.textContent = `${item.name}: ${item.message}`;
                dataList.appendChild(li);
            });
        });
});

document.getElementById('dataForm').addEventListener('submit', async function (event) {
    event.preventDefault();

    const formData = new FormData(event.target);
    const data = {
        name: formData.get('name'),
        message: formData.get('message')
    };

    try {
        const response = await fetch('/api/data', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
        });
        if (!response.ok) {
            const errorData = await response.json();
            throw new Error(errorData.error || "Unknown error occurred");
        }

        const jsonResponse = await response.json();
        alert(jsonResponse.message);
        document.getElementById("loadData").click();
    } catch (error) {
        console.error("Error submitting data:", error);
        alert("Error submitting data. Please try again.");
    }
});

document.getElementById("testConnection").addEventListener("click", function() {
    fetch("/api/test_mongo_connection")
    .then(response => response.json())
    .then(data => {
        const connectionResult = document.getElementById("connectionResult");
        if (data.status.startsWith('Connected')) {
            connectionResult.textContent = data.status;
            connectionResult.style.color = 'green';
        } else {
            connectionResult.textContent = `Error: ${data.error}`;
            connectionResult.style.color = 'red';
        }
    })
    .catch(error => {
        const connectionResult = document.getElementById("connectionResult");
        connectionResult.textContent = `Error: Failed to fetch from server.`;
        connectionResult.style.color = 'red';
    });
});
