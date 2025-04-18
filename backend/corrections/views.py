from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json
from langchain_ollama import OllamaLLM

llm_model_name = "gemma3"

import re

@csrf_exempt
def correction_view(request):
    data = json.loads(request.body)
    sentence = data.get('sentence', '')
    language = data.get('language', 'italian')
    level = data.get('level', 'A2')

    response_str = correct_sentence(language, sentence, level)
    print("LLM raw response:", repr(response_str))  # Optional debug

    # Clean up markdown-style code fences
    cleaned = re.sub(r"^```(?:json)?\s*|\s*```$", "", response_str.strip(), flags=re.MULTILINE)

    response_json = json.loads(cleaned)
    return JsonResponse(response_json)




def correct_sentence(language, sentence, level):
    model = OllamaLLM(model=llm_model_name)

    prior_prompt = f"""
Sei un esperto linguistico. Il tuo compito è correggere eventuali errori grammaticali, ortografici o di chiarezza in una frase in italiano. Poi, fornisci una breve spiegazione dell'errore **sia in italiano che in inglese**.

Rispondi **solo** nel seguente formato JSON:

{{
  "original_sentence": "...",
  "corrected_sentence": "...",
  "feedback_italian": "...",
  "feedback_english": "..."
}}

Esempio input:
"Lei non sapevo dove andava perché era tardi."

Esempio output:
{{
  "original_sentence": "Lei non sapevo dove andava perché era tardi.",
  "corrected_sentence": "Lei non sapeva dove andava perché era tardi.",
  "feedback_italian": "Corretta la coniugazione del verbo 'sapere' da 'sapevo' a 'sapeva'.",
  "feedback_english": "Corrected the verb conjugation of 'sapere' from 'sapevo' to 'sapeva'."
}}

Ora correggi la seguente frase:
"{sentence}"
"""

    
    if not sentence.strip():  # Add a check to ensure the sentence is not empty
        return {"error": "No sentence provided"}

    print("LLM prompt:", prior_prompt)  # 👈 Debug print

    return model.invoke(prior_prompt)

