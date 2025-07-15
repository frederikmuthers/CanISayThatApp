import google.generativeai as genai
from langchain_ollama import OllamaLLM

ollama_model_name = "gemma3"

def llm_call_google(request):
    genai.configure(api_key="AIzaSyBw2hjcksap3dM9rQqpNvblnl6QEXirp6M")
    model = genai.GenerativeModel("gemma-3-27b-it")
    response = model.generate_content(request)
    return response.text

def llm_call_ollama(request):
    model = OllamaLLM(model=ollama_model_name)
    return model.invoke(request)