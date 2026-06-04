document.addEventListener("DOMContentLoaded", () => {
    const urlParams = new URLSearchParams(window.location.search);
    const type = urlParams.get('type') || 'hpp'; 

    document.getElementById('page-title').textContent = type.toUpperCase() + ' Offsets';

    const filesToLoad = type === 'hpp' 
        ? ['offsets/hpp/client_dll.hpp', 'offsets/hpp/offsets.hpp']
        : ['offsets/json/client_dll.json', 'offsets/json/offsets.json'];

    const container = document.getElementById('code-container');

    async function fetchFiles() {
        try {
            for (const filePath of filesToLoad) {
                const response = await fetch(filePath);
                
                if (!response.ok) {
                    throw new Error(`Nie można załadować: ${filePath}`);
                }
                
                const fileContent = await response.text();
                const fileName = filePath.split('/').pop();

                const section = document.createElement('div');
                section.className = 'file-section';

                const title = document.createElement('h2');
                title.className = 'file-title';
                title.textContent = fileName;

                const pre = document.createElement('pre');
                const code = document.createElement('code');
                
                code.className = type === 'hpp' ? 'language-cpp' : 'language-json';
                code.textContent = fileContent;

                pre.appendChild(code);
                section.appendChild(title);
                section.appendChild(pre);
                container.appendChild(section);
            }

            hljs.highlightAll();

        } catch (error) {
            container.innerHTML = `<div class="error-msg">Error: ${error.message} <br><br> =_= </div>`;
        }
    }

    fetchFiles();
});