import json
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from utils import llm_call_google
import re

@csrf_exempt
def generate_sentences(request):
    data = json.loads(request.body)
    known_words = data.get('known_words', [])
    training_words = data.get('training_words', [])

    result = run_generate_sentences(known_words, training_words)
    return JsonResponse(result, safe=False)


def run_generate_sentences(known_words, training_words):
    prompt = build_prompt(known_words, training_words)
    raw_output = llm_call_google(prompt)

    # Remove markdown code block if present
    cleaned_output = re.sub(r"^```(?:json)?\n|\n```$", "", raw_output.strip())

    try:
        parsed = json.loads(cleaned_output)
        return parsed
    except json.JSONDecodeError:
        return {"error": "Failed to parse cleaned LLM response", "raw_output": cleaned_output}



def build_prompt(known_words, training_words):
    known_str = ", ".join(known_words)
    training_str = "\n".join([f"- {word}" for word in training_words])

    prompt = f"""You are a helpful assistant for a language learning app. The learner speaks English and is learning Italian.

Your task is to generate short English sentences that:
- Use one of the training vocabulary words (in English),
- Include the Italian translation of that word in parentheses directly after the English word,
- Optionally include known English words to make the sentence more natural and useful,
- Are short and beginner-friendly (max 12 words),
- Include a full translation of the entire sentence into Italian.

Known English words (already familiar to the learner): {known_str}

Vocabulary to train (new English words):
{training_str}

Return a JSON array of objects, each with:
- "word": the English vocabulary word being trained,
- "fragment": the English sentence including the inline Italian translation of the word,
- "translation": the full sentence translated into Italian.

Example format:
[
  {{
    "word": "bicycle",
    "fragment": "I go to school by bicycle (bicicletta).",
    "translation": "Vado a scuola in bicicletta."
  }},
  {{
    "word": "to swim",
    "fragment": "I like to swim (nuotare) in the lake.",
    "translation": "Mi piace nuotare nel lago."
  }},
  {{
    "word": "happy",
    "fragment": "I feel happy (felice) at home.",
    "translation": "Mi sento felice a casa."
  }}
]

Now generate one sentence per training word.
"""
    return prompt
