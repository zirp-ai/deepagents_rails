// DeepAgents <%= class_name %> Chat JavaScript

document.addEventListener('DOMContentLoaded', function() {
  // Elements
  const messagesContainer = document.getElementById('messages-container');
  const messageForm = document.getElementById('message-form');
  const messageInput = document.getElementById('message-input');
  const fileUpload = document.getElementById('file-upload');
  const filePreview = document.getElementById('file-preview');
  
  // Auto-resize textarea
  if (messageInput) {
    messageInput.addEventListener('input', function() {
      this.style.height = 'auto';
      this.style.height = (this.scrollHeight) + 'px';
    });
  }
  
  // File upload preview
  if (fileUpload) {
    fileUpload.addEventListener('change', function(e) {
      const file = e.target.files[0];
      if (!file) {
        filePreview.innerHTML = '';
        return;
      }
      
      const reader = new FileReader();
      
      reader.onload = function(e) {
        filePreview.innerHTML = '';
        
        const fileElement = document.createElement('div');
        fileElement.className = 'deepagents-file-item';
        
        // Check if it's an image
        if (file.type.startsWith('image/')) {
          const img = document.createElement('img');
          img.src = e.target.result;
          img.className = 'deepagents-file-thumbnail';
          fileElement.appendChild(img);
        }
        
        const fileInfo = document.createElement('div');
        fileInfo.className = 'deepagents-file-info';
        fileInfo.textContent = file.name;
        
        const removeButton = document.createElement('button');
        removeButton.type = 'button';
        removeButton.className = 'deepagents-file-remove';
        removeButton.innerHTML = '&times;';
        removeButton.addEventListener('click', function() {
          fileUpload.value = '';
          filePreview.innerHTML = '';
        });
        
        fileElement.appendChild(fileInfo);
        fileElement.appendChild(removeButton);
        filePreview.appendChild(fileElement);
      };
      
      reader.readAsDataURL(file);
    });
  }
  
  // Form submission
  if (messageForm) {
    messageForm.addEventListener('submit', function(e) {
      e.preventDefault();
      
      const formData = new FormData(this);
      const conversationId = document.querySelector('.deepagents-container').dataset.conversationId;
      
      // Check if there's a file to upload first
      if (fileUpload && fileUpload.files.length > 0) {
        const fileFormData = new FormData();
        fileFormData.append('file', fileUpload.files[0]);
        
        fetch(`/conversations/${conversationId}/upload`, {
          method: 'POST',
          body: fileFormData,
          headers: {
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
          }
        })
        .then(response => response.json())
        .then(data => {
          // Clear file upload
          fileUpload.value = '';
          filePreview.innerHTML = '';
          
          // Now send the message
          sendMessage(formData, conversationId);
        })
        .catch(error => {
          console.error('Error uploading file:', error);
        });
      } else {
        // Just send the message
        sendMessage(formData, conversationId);
      }
    });
  }
  
  function sendMessage(formData, conversationId) {
    // Add a loading message
    const loadingMessage = document.createElement('div');
    loadingMessage.className = 'deepagents-message assistant loading';
    loadingMessage.innerHTML = `
      <div class="deepagents-message-avatar">
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" viewBox="0 0 16 16">
          <path d="M6 12.5a.5.5 0 0 1 .5-.5h3a.5.5 0 0 1 0 1h-3a.5.5 0 0 1-.5-.5ZM3 8.062C3 6.76 4.235 5.765 5.53 5.886a26.58 26.58 0 0 0 4.94 0C11.765 5.765 13 6.76 13 8.062v1.157a.933.933 0 0 1-.765.935c-.845.147-2.34.346-4.235.346-1.895 0-3.39-.2-4.235-.346A.933.933 0 0 1 3 9.219V8.062Zm4.542-.827a.25.25 0 0 0-.217.068l-.92.9a24.767 24.767 0 0 1-1.871-.183.25.25 0 0 0-.068.495c.55.076 1.232.149 2.02.193a.25.25 0 0 0 .189-.071l.754-.736.847 1.71a.25.25 0 0 0 .404.062l.932-.97a25.286 25.286 0 0 0 1.922-.188.25.25 0 0 0-.068-.495c-.538.074-1.207.145-1.98.189a.25.25 0 0 0-.166.076l-.754.785-.842-1.7a.25.25 0 0 0-.182-.135Z"/>
          <path d="M8.5 1.866a1 1 0 1 0-1 0V3h-2A4.5 4.5 0 0 0 1 7.5V8a1 1 0 0 0-1 1v2a1 1 0 0 0 1 1v1a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2v-1a1 1 0 0 0 1-1V9a1 1 0 0 0-1-1v-.5A4.5 4.5 0 0 0 10.5 3h-2V1.866ZM14 7.5V13a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1V7.5A3.5 3.5 0 0 1 5.5 4h5A3.5 3.5 0 0 1 14 7.5Z"/>
        </svg>
      </div>
      <div class="deepagents-message-content">
        <div class="deepagents-message-header">
          <span class="deepagents-message-role">Assistant</span>
        </div>
        <div class="deepagents-message-body">
          <p>Thinking...</p>
        </div>
      </div>
    `;
    messagesContainer.appendChild(loadingMessage);
    
    // Scroll to bottom
    messagesContainer.scrollTop = messagesContainer.scrollHeight;
    
    // Clear input
    messageInput.value = '';
    messageInput.style.height = 'auto';
    
    // Send the message
    fetch(`/conversations/${conversationId}/run`, {
      method: 'POST',
      body: formData,
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      }
    })
    .then(response => response.json())
    .then(data => {
      // Remove loading message
      messagesContainer.removeChild(loadingMessage);
      
      // Refresh the conversation
      fetch(`/conversations/${conversationId}`, {
        headers: {
          'Accept': 'text/html',
          'X-Requested-With': 'XMLHttpRequest'
        }
      })
      .then(response => response.text())
      .then(html => {
        const parser = new DOMParser();
        const doc = parser.parseFromString(html, 'text/html');
        const newMessages = doc.querySelector('.deepagents-messages');
        
        if (newMessages) {
          messagesContainer.innerHTML = newMessages.innerHTML;
        }
        
        // Scroll to bottom
        messagesContainer.scrollTop = messagesContainer.scrollHeight;
      });
    })
    .catch(error => {
      console.error('Error sending message:', error);
      
      // Remove loading message
      messagesContainer.removeChild(loadingMessage);
      
      // Show error message
      const errorMessage = document.createElement('div');
      errorMessage.className = 'deepagents-message system error';
      errorMessage.innerHTML = `
        <div class="deepagents-message-avatar">
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" viewBox="0 0 16 16">
            <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
            <path d="M7.002 11a1 1 0 1 1 2 0 1 1 0 0 1-2 0zM7.1 4.995a.905.905 0 1 1 1.8 0l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 4.995z"/>
          </svg>
        </div>
        <div class="deepagents-message-content">
          <div class="deepagents-message-header">
            <span class="deepagents-message-role">System</span>
          </div>
          <div class="deepagents-message-body">
            <p>Error: Could not send message. Please try again.</p>
          </div>
        </div>
      `;
      messagesContainer.appendChild(errorMessage);
      
      // Scroll to bottom
      messagesContainer.scrollTop = messagesContainer.scrollHeight;
    });
  }
});
