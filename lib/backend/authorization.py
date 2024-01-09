
import tekore as tk

def authorize():
     CLIENT_ID = "b85d98e0bdbb49d7ad76843034f990f0"
     CLIENT_SECRET = "862f8c3e375249f8a6892c5937603e30"
     app_token = tk.request_client_token(CLIENT_ID, CLIENT_SECRET)
     return tk.Spotify(app_token)
