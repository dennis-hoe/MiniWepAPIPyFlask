from flask import Flask, request, jsonify, abort

app = Flask(__name__)

# "Datenbank" im Speicher
notes = {}
next_id = 1


# ✅ NEU: Fehler als JSON zurückgeben
@app.errorhandler(400)
def bad_request(e):
    return jsonify({"error": 400, "description": str(e.description)}), 400


@app.errorhandler(404)
def not_found(e):
    return jsonify({"error": 404, "description": str(e.description)}), 404


@app.route("/notes", methods=["GET"])
def list_notes():
    """Alle Notizen zurückgeben."""
    return jsonify(list(notes.values()))


@app.route("/notes/<int:note_id>", methods=["GET"])
def get_note(note_id):
    """Eine einzelne Notiz zurückgeben."""
    note = notes.get(note_id)
    if note is None:
        abort(404, description="Note not found")
    return jsonify(note)


@app.route("/notes", methods=["POST"])
def create_note():
    """Neue Notiz anlegen."""
    global next_id

    data = request.get_json()
    if not data or "title" not in data or "content" not in data:
        abort(400, description="Missing 'title' or 'content'")

    note = {
        "id": next_id,
        "title": data["title"],
        "content": data["content"],
    }
    notes[next_id] = note
    next_id += 1

    return jsonify(note), 201


@app.route("/notes/<int:note_id>", methods=["PUT"])
def update_note(note_id):
    """Bestehende Notiz vollständig aktualisieren."""
    note = notes.get(note_id)
    if note is None:
        abort(404, description="Note not found")

    data = request.get_json()
    if not data or "title" not in data or "content" not in data:
        abort(400, description="Missing 'title' or 'content'")

    note["title"] = data["title"]
    note["content"] = data["content"]
    return jsonify(note)


@app.route("/notes/<int:note_id>", methods=["DELETE"])
def delete_note(note_id):
    """Notiz löschen."""
    note = notes.pop(note_id, None)
    if note is None:
        abort(404, description="Note not found")
    return "", 204


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)