console.log('[Superpower ChatGPT] loadScript.js starting injection');
function injectScript(scriptUrl) {
  const newScriptElement = document.createElement('script');
  newScriptElement.setAttribute('src', scriptUrl);
  newScriptElement.setAttribute('type', 'text/javascript');

  newScriptElement.onload = function () {
    this.remove();
  };

  document.documentElement.prepend(newScriptElement);
}

const interceptorScriptUrl = chrome.runtime.getURL('scripts/interceptor/interceptor.js');
console.log('[Superpower ChatGPT] injecting interceptor', interceptorScriptUrl);
injectScript(interceptorScriptUrl);
console.log('[Superpower ChatGPT] loadScript.js finished');
