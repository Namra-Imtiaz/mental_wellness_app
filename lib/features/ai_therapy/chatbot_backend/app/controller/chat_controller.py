from flask import Blueprint, request, jsonify
from app.model.chat_model import ChatModel
from app.service.rag_service import RAGService
import datetime

chat_bp = Blueprint("chat", __name__)
rag = RAGService()
db = ChatModel()

@chat_bp.route("/chat", methods=["POST"])
def chat():
    data = request.get_json()
    query = data.get("message", "")
    device = request.headers.get("X-Device-Id", "anonymous")

    if not query:
        return jsonify({"error": "No query provided"}), 400

    if not db.allow_request(device):
        return jsonify({"error": "Rate limit exceeded. Max 8/hour"}), 429

    response = rag.generate_response(query)
    db.save_chat(device, query, response)

    return jsonify({"query": query, "response": response})
