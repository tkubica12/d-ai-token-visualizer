// Example usage of runtime configuration in the frontend
// This file shows how to use the environment variables in your React/JavaScript code

// Get runtime configuration
function getConfig() {
  // This will be available after the container starts and env-config.js is generated
  if (typeof window !== 'undefined' && window.ENV) {
    return {
      backendUrl: window.ENV.BACKEND_URL || 'http://localhost:8000',
      apiUrl: window.ENV.API_URL || window.ENV.BACKEND_URL || 'http://localhost:8000'
    };
  }
  
  // Fallback for development
  return {
    backendUrl: 'http://localhost:8000',
    apiUrl: 'http://localhost:8000'
  };
}

// Example API call function
async function callAPI(endpoint, options = {}) {
  const config = getConfig();
  const url = `${config.apiUrl}${endpoint}`;
  
  try {
    const response = await fetch(url, {
      ...options,
      headers: {
        'Content-Type': 'application/json',
        ...options.headers
      }
    });
    
    if (!response.ok) {
      throw new Error(`API call failed: ${response.status}`);
    }
    
    return await response.json();
  } catch (error) {
    console.error('API call error:', error);
    throw error;
  }
}

// Example usage:
// const result = await callAPI('/api/v1/generate', {
//   method: 'POST',
//   body: JSON.stringify({ prompt: 'Hello world' })
// });

export { getConfig, callAPI };
