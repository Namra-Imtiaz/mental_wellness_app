import faiss
import numpy as np
import pandas as pd
from sentence_transformers import SentenceTransformer
from transformers import pipeline

class RAGService:
    def __init__(self):
        try:
            self.index = faiss.read_index("context_index.faiss")
        except Exception as e:
            raise RuntimeError(f"Error loading FAISS index: {e}")

        try:
            self.context_response = pd.read_csv("context_responses.csv")
        except Exception as e:
            raise RuntimeError(f"Error loading CSV: {e}")

        if 'Response' not in self.context_response.columns:
            raise ValueError("CSV must contain a 'Response' column.")

        self.embedder = SentenceTransformer("all-MiniLM-L6-v2")
        self.generator = pipeline("text2text-generation", model="google/flan-t5-base")

    def generate_response(self, query, top_k=3, history=None):
        try:
            embedding = self.embedder.encode([query])
            _, I = self.index.search(np.array(embedding).astype("float32"), top_k)
        except Exception as e:
            print(f"Embedding or search error: {e}")
            return "Sorry, I'm having trouble processing your request."

        # Collect retrieved real user responses
        retrieved_responses = []
        for i in I[0]:
            try:
                resp = self.context_response.iloc[i]['Response']
                if pd.notna(resp):
                    retrieved_responses.append(str(resp).strip())
            except Exception:
                continue

        if not retrieved_responses:
            return "I'm really sorry, but I couldn't find any helpful experiences to base my response on."

        # Optional chat history
        history_text = ""
        if history:
            history_text = "\n".join(
                f"User: {h['user']}\nAssistant: {h['bot']}" for h in history
            ) + "\n"

        prompt = (
            "You are a helpful and empathetic mental health assistant.\n\n"
            + (f"Conversation so far:\n{history_text}" if history_text else "")
            + "Similar responses from other users:\n"
            + "\n".join(f"- {resp}" for resp in retrieved_responses)
            + f"\n\nUser: {query}\nAssistant:"
        )

        try:
            result = self.generator(
                prompt,
                max_length=150,
                do_sample=True,
                temperature=0.8,
                top_p=0.95,
                num_return_sequences=1
            )
            return result[0]['generated_text'].strip()
        except Exception as e:
            print(f"Error during generation: {e}")
            return "Sorry, I had trouble generating a response. Please try again."
