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
You are a professional language expert. Your task is to:
1. Correct any grammatical, spelling, or clarity issues in the following Italian sentence.
2. Provide a brief explanation of the correction in **both Italian and English**.
3. Indicate if the original sentence could be said like that by a native speaker — even if it's not perfect — by answering "yes" or "no".
4. Analyze and describe the general **tone** of the sentence — e.g., formal, casual, friendly, rude, polite, etc.

Respond **only** in the following JSON format:

{{
  "original_sentence": "...",
  "corrected_sentence": "...",
  "feedback_italian": "...",
  "feedback_english": "...",
  "native_like": "yes" or "no",
  "tone": "<brief tone description>"
}}

### Example 1 — incorrect and unnatural
Input:
"Lei non sapevo dove andava perché era tardi."

Output:
{{
  "original_sentence": "Lei non sapevo dove andava perché era tardi.",
  "corrected_sentence": "Lei non sapeva dove andava perché era tardi.",
  "feedback_italian": "Corretta la coniugazione del verbo 'sapere' da 'sapevo' a 'sapeva'.",
  "feedback_english": "Corrected the verb 'sapere' from 'sapevo' to 'sapeva' to match the third-person subject.",
  "native_like": "no",
  "tone": "neutral and narrative"
}}

### Example 2 — correct and common
Input:
"Non so se lui viene domani."

Output:
{{
  "original_sentence": "Non so se lui viene domani.",
  "corrected_sentence": "Non so se verrà domani.",
  "feedback_italian": "La frase è comprensibile e corretta, ma una forma più naturale sarebbe usare il futuro 'verrà'.",
  "feedback_english": "The sentence is understandable and correct, but using 'verrà' in future tense is more natural.",
  "native_like": "yes",
  "tone": "informal and conversational"
}}

Now correct the following sentence:
"{sentence}"
"""

    
    if not sentence.strip():  # Add a check to ensure the sentence is not empty
        return {"error": "No sentence provided"}

    print("LLM prompt:", prior_prompt)  # 👈 Debug print

    return model.invoke(prior_prompt)

