from django.http import HttpResponse, JsonResponse
from urllib.parse import unquote
from langchain_ollama import OllamaLLM

# Define a global variable for the LLM model
llm_model_name = "llama3.1"


def correction_view(request):
    if request.method == 'GET':
        # Handle GET request
        sentence = request.GET.get('sentence', '')
        sentence = unquote(sentence)  # Ensure the sentence is URL-decoded
        level = "A2"
        corrected_sentence = correct_sentence(sentence, level)
        return HttpResponse(corrected_sentence, content_type="application/json")
    return HttpResponse("Hello, world. You're at the corrections index.")

def correct_sentence(sentence, level):

    model = OllamaLLM(model=llm_model_name)

    prior_prompt = f"You are a language teacher holding a course for level {level}. A student wrote: "
    latter_prompt = "Provide as answer only a JSON with: correct:yes/no, meaning: how the provided sentence would be understood, corrected_sentence: the corrected sentence."

    return model.invoke(prior_prompt + sentence + latter_prompt)


def correct_sentence_detailed(sentence, level):

    model = OllamaLLM(model=llm_model_name)

    prior_prompt = "Be a language teacher and provide only a JSON as feedback including: correct(yes/no), meaning(how the sentence would be understood), corrected_sentence(a corrected sentence, only changed if necessary). The sentence is: "
    

    return model.invoke(prior_prompt + sentence)
