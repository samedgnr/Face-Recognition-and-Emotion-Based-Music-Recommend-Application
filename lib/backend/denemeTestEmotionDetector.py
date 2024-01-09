from base64 import b64decode

import cv2
import numpy as np
from keras.models import model_from_json
from tekore._model import FullTrack, SimpleArtist, FullArtist

import authorization
import time
from flask import Flask, request, jsonify

import getArtist

app = Flask(__name__)

# Load emotion detection model
json_file = open('model/emotion_model.json', 'r')
loaded_model_json = json_file.read()
json_file.close()
emotion_model = model_from_json(loaded_model_json)
emotion_model.load_weights("model/emotion_model.h5")

emotion_dict = {0: "Angry", 1: "Disgusted", 2: "Fearful", 3: "Happy", 4: "Neutral", 5: "Sad", 6: "Surprised"}

sp = authorization.authorize()


def get_top_artists(market, genre):

    # Search for playlists in the specified market and with the given genre
    playlists = sp.search(query=f'{market} ' + genre, types='playlist'.split(','), limit=5)

    print(playlists)
    if playlists[0].items:
        # Get the first playlist found
        playlist_id = playlists[0].items[0].id

        tracks = sp.playlist_items(playlist_id, limit=10)


        artist_ids_set = set()
        result_data = []

        for i in range(len(tracks.items)):
            # Accessing artist information for each track
            current_artist_name = tracks.items[i].track.artists[0].name
            current_artist_id = tracks.items[i].track.artists[0].id

            # Check if the artist has more than 100,000 followers and is not in the set
            if current_artist_id not in artist_ids_set:
                results = sp.artist(current_artist_id)

                if results.followers.total > 10000:
                    # Add the current artist to result_data
                    result_item = {
                        'id': results.id,
                        'name': results.name,
                        'icon': results.images[0].url if results.images else None,
                        'followers': results.followers.total,
                        'genres': results.genres
                    }
                    result_data.append(result_item)

                    # Add the current artist ID to the set
                    artist_ids_set.add(current_artist_id)

                # Check if the result_data has reached the maximum size (9 elements)
                if len(result_data) >= 9:
                    break

        # Sort result_data by followers in descending order
        result_data.sort(key=lambda x: x['followers'], reverse=True)

        # Take the top 50 artists
        top_artists = result_data[:15]

        # Print or return top_artists
        print(top_artists)

        # Printing artist information for the current track
        print(f"Track {i + 1} - Artist ID: {current_artist_id}, Name: {current_artist_name}")

        print("RESULT DATA : \n")
        print(result_data)
        return result_data
    else:
        print(f"No playlists found for genre: {genre} in market: {market}")
        return []

@app.route('/get_top_artists', methods=['POST'])
def get_top_artists_route():
    try:
        data = request.json
        market = data.get('market', '')

        genre = data.get('genre', [])

        result = get_top_artists(market, genre)
        print(type(result))
        print(result)
        return jsonify({'result': result})
    except Exception as e:
        return jsonify({"error": f"An error occurred: {str(e)}"})


@app.route('/search', methods=['GET'])
def search():
    try:

        query = request.args.get('query')


        artist_results = sp.search(query, types='artist'.split(','), limit=1)

        if artist_results:
            artists = artist_results[0].items
            artist_data = []

            for artist in artists:
                if isinstance(artist, FullArtist):

                    artist_item = {}
                    artist_item['type'] = 'artist'
                    artist_item['id'] = artist.id
                    artist_item['name'] = artist.name
                    artist_item['followers'] = artist.followers.total if artist.followers else None
                    artist_item['genres'] = artist.genres
                    artist_item['popularity'] = artist.popularity
                    artist_item['images'] = [image.url for image in artist.images] if artist.images else None

                    top_tracks = sp.artist_top_tracks(artist.id ,market='US,ES,GB,DE,FR,IT,CA,AU,TR,BR'.split(','))

                    print(top_tracks)

                    for track in top_tracks:
                        result_item = {}
                        result_item['type'] = 'track'
                        result_item['id'] = track.id
                        result_item['name'] = track.name
                        result_item['artists'] = [artist.name for artist in track.artists]
                        result_item['icon'] = track.album.images[0].url if track.album.images else None
                        result_item['duration_ms'] = track.duration_ms
                        result_item['duration_min'] = divmod(result_item['duration_ms'] // 1000, 60)

                        artist_data.append(result_item)


        track_results = sp.search(query, types='track'.split(','), limit=5)

        if track_results:
            tracks = track_results[0].items
            result_data = []

            all_song_ids = set()

            all_song_ids.update(item['id'] for item in artist_data)


            for item in tracks:
                if isinstance(item, FullTrack):


                    if item.id not in all_song_ids:

                        result_item = {}
                        result_item['type'] = 'track'
                        result_item['id'] = item.id
                        result_item['name'] = item.name
                        result_item['artists'] = [artist.name for artist in item.artists]
                        result_item['icon'] = item.album.images[0].url if item.album.images else None
                        result_item['duration_ms'] = item.duration_ms
                        result_item['duration_min'] = divmod(result_item['duration_ms'] // 1000, 60)


                        result_data.append(result_item)
            print(artist_data)
            print(result_data)
            print(jsonify(artist_data + result_data))
            return jsonify(artist_data + result_data)
        return jsonify({"error": "No results found"})

    except Exception as e:
        return jsonify({"error": f"An error occurred: {str(e)}"})

@app.route('/search_artist', methods=['POST'])
def search_artist_route():

    try:
        data = request.json

        artist_name = data.get('artist_name', '')

        artist_info = getArtist.get_artist_info(artist_name)


        print(artist_info)

        return jsonify(artist_info)

    except Exception as e:
        return jsonify({'error': str(e)})

def get_artist_info(artist_name):
    try:
        # Search for the artist by name
        results = sp.search(artist_name, types='artist'.split(','))

        print(results)

        # Check if search results are not empty
        if results and results[0].items:
            # Extract relevant information about the artist
            artist_info = {
                'name': results[0].items[0].name,
                'id': results[0].items[0].id,
                'genres': results[0].items[0].genres,
                'followers': results[0].items[0].followers.total,
                'images': [image.url for image in results[0].items[0].images] if results[0].items[0].images else None
            }
            print(artist_info)
            return artist_info
        else:
            print(f"No artist found with the name: {artist_name}")

    except Exception as e:
        print(f"Error: {e}")

    return None

@app.route('/get_artist_info', methods=['POST'])
def get_artist_info_route():
    try:
        data = request.json
        artist_name = data.get('artist_name', '')

        artist_info = get_artist_info(artist_name)

        if artist_info:
            return jsonify(artist_info)
        else:
            return jsonify({'error': f"No artist found with the name: {artist_name}"})

    except Exception as e:
        return jsonify({'error': str(e)})



def process_image(encoded_image):
    # Decode base64 image
    decoded_image = b64decode(encoded_image)
    nparr = np.frombuffer(decoded_image, np.uint8)
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

    # Your emotion detection logic here...
    # For example, assuming you have a function get_emotion(img)
    emotion = analyze_image_and_emotion(img)
    # Get Spotify recommendations based on emotion
    print("Emotion")
    print(emotion)
    return {'emotion': emotion}

@app.route('/process_image', methods=['POST'])
def process_image_route():
    data = request.get_json()
    encoded_image = data.get('image', '')

    result = process_image(encoded_image)
    print("Result:")
    print(result)
    return jsonify(result)



def get_recommendations_based_on_emotion(emotion, artist_names, genres, limit=15, retry_count=3):
    threshold_valence = 0
    threshold_energy = 0
    if emotion == 'Happy':
        threshold_valence = 1
        threshold_energy = 1
        threshold_acousticness = 0.4  # Adjust as needed
        threshold_danceability = 1  # Adjust as needed
        threshold_instrumentalness = 0.3  # Adjust as needed
        threshold_liveness = 0.6  # Adjust as needed
        threshold_loudness = -8.0  # Adjust as needed
        threshold_speechiness = 0.5  # Adjust as needed
        threshold_tempo = 130.0  # Adjust as needed

    elif emotion == 'Sad':
        threshold_valence = 0
        threshold_energy = 0
        threshold_acousticness = 0.6  # Adjust as needed
        threshold_danceability = 0.1  # Adjust as needed
        threshold_instrumentalness = 0.7  # Adjust as needed
        threshold_liveness = 0.3  # Adjust as needed
        threshold_loudness = -15.0  # Adjust as needed
        threshold_speechiness = 0.3  # Adjust as needed
        threshold_tempo = 100.0  # Adjust as needed

    elif emotion == 'Neutral':
        threshold_valence = 0.3
        threshold_energy = 0.3
        threshold_acousticness = 0.5  # Adjust as needed
        threshold_danceability = 0.1  # Adjust as needed
        threshold_instrumentalness = 0.5  # Adjust as needed
        threshold_liveness = 0.2  # Adjust as needed
        threshold_loudness = -10.0  # Adjust as needed
        threshold_speechiness = 0.5  # Adjust as needed
        threshold_tempo = 120.0  # Adjust as needed

    elif emotion == 'Fearful':
        threshold_valence = 0.2 # You can adjust this based on your preference
        threshold_energy = 1  # You can adjust this based on your preference
        threshold_acousticness = 0.7  # Adjust as needed
        threshold_danceability = 0  # Adjust as needed
        threshold_instrumentalness = 0.6  # Adjust as needed
        threshold_liveness = 0.4  # Adjust as needed
        threshold_loudness = -12.0  # Adjust as needed
        threshold_speechiness = 0.4  # Adjust as needed
        threshold_tempo = 110.0  # Adjust as needed

    elif emotion == 'Angry':
        threshold_valence = 0  # You can adjust this based on your preference
        threshold_energy = 1  # You can adjust this based on your preference
        threshold_acousticness = 0.3  # Adjust as needed
        threshold_danceability = 0.8  # Adjust as needed
        threshold_instrumentalness = 0.2  # Adjust as needed
        threshold_liveness = 0.6  # Adjust as needed
        threshold_loudness = -5.0  # Adjust as needed
        threshold_speechiness = 0.6  # Adjust as needed
        threshold_tempo = 140.0  # Adjust as needed

    elif emotion == 'Surprised':
        threshold_valence = 0.7  # You can adjust this based on your preference
        threshold_energy = 0.7  # You can adjust this based on your preference
        threshold_acousticness = 0.5  # Adjust as needed
        threshold_danceability = 0.7  # Adjust as needed
        threshold_instrumentalness = 0.4  # Adjust as needed
        threshold_liveness = 0.5  # Adjust as needed
        threshold_loudness = -7.0  # Adjust as needed
        threshold_speechiness = 0.6  # Adjust as needed
        threshold_tempo = 130.0  # Adjust as needed

    # Rest of your code for recommendation based on these thresholds...

    for _ in range(retry_count):
        try:
            recommendations = sp.recommendations(artist_ids= getArtist.get_artist_ids_by_names(artist_names), genres=genres, limit=limit,
                target_valence=threshold_valence,
                target_energy=threshold_energy,
                target_acousticness=threshold_acousticness,
                target_danceability=threshold_danceability,
                target_instrumentalness=threshold_instrumentalness,
                target_liveness=threshold_liveness,
                target_loudness=threshold_loudness,
                target_speechiness=threshold_speechiness,
                target_tempo=threshold_tempo)
            # print('Recommendations')
            # print(recommendations)
            # print('Recommendations.tracks')
            # print(recommendations.tracks)
            print(recommendations)
            print(getArtist.get_artist_ids_by_names(artist_names))
            print(genres)


            if recommendations.tracks:
                tracks = recommendations.tracks
                #tracks = recommendations[0].items
                result_data = []
                # print(tracks)
                # print(type(tracks))
                # print(tracks.id)

                for item in tracks:

                    #print(item.name)

                    #print(tracks.id)
                    if isinstance(item, FullTrack):
                        print("Oldu mu la")
                        result_item = {}
                        result_item['id'] = item.id
                        result_item['type'] = 'track'
                        result_item['name'] = item.name
                        result_item['artists'] = item.artists[0].name
                        result_item['icon'] = item.album.images[0].url if item.album.images else None
                        result_item['duration_ms'] = item.duration_ms
                        result_item['duration_min'] = divmod(result_item['duration_ms'] // 1000, 60)

                        result_data.append(result_item)

                        print(
                            f"Track ID: {item.id}, Track Image: {item.album.images[0].url}, Track Name: {item.name}, Track Artist: {item.artists[0].name}, Track Duration Ms: {item.duration_ms}")

                print(type(result_data))
                print("Info:")
                print(result_item)
                print(result_data)
                #print(jsonify(result_data))

                return result_data


            else:
                print(f"Unexpected format for recommendations: {recommendations}")
                print(type(recommendations))
                return []
        except Exception as e:
            if '429' in str(e):
                print(f"Rate limit exceeded. Retrying after a delay.")
                time.sleep(2 ** retry_count)  # Exponential backoff
            else:
                print(f"Error fetching Spotify recommendations: {e}")
                return []
    print(f"Max retries reached. Unable to fetch recommendations.")
    return []

def analyze_image_and_emotion(img):
    # Resize the input image
    emotion_detected = ''
    img = cv2.resize(img, (800, 720))

    # Face detection
    face_detector = cv2.CascadeClassifier('haarcascades/haarcascade_frontalface_default.xml')
    gray_frame = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    # Detect faces in the frame
    num_faces = face_detector.detectMultiScale(gray_frame, scaleFactor=1.3, minNeighbors=5)

    # Process each detected face
    for (x, y, w, h) in num_faces:
        cv2.rectangle(img, (x, y - 50), (x + w, y + h + 10), (0, 255, 0), 4)
        roi_gray_frame = gray_frame[y:y + h, x:x + w]
        cropped_img = np.expand_dims(np.expand_dims(cv2.resize(roi_gray_frame, (48, 48)), -1), 0)

        emotion_prediction = emotion_model.predict(cropped_img)
        max_emotion_score = max(emotion_prediction[0]) * 100  # Normalize to 100 scale
        max_emotion_index = np.argmax(emotion_prediction)  # Get the index of the highest emotion score
        emotion_label = emotion_dict[max_emotion_index]  # Get the label of the highest emotion

        total_probability = np.sum(emotion_prediction)
        emotion_percentages = (emotion_prediction / total_probability) * 100

        for i, percentage in enumerate(emotion_percentages[0]):
            formatted_percentage = "{:.2f}".format(percentage)
            print(f"{emotion_dict[i]}: {formatted_percentage}")

        if max_emotion_score > 0.01:  # Check if the highest emotion score is greater than 50
            print("Duygu durumunuz: {} {}".format(emotion_label, max_emotion_score))
            emotion_detected = True

        cv2.putText(img, f"{emotion_label}: {max_emotion_score:.2f}", (x + 5, y - 20), cv2.FONT_HERSHEY_SIMPLEX,
                    1, (255, 0, 0), 2, cv2.LINE_AA)


    if emotion_detected:
        return emotion_label
    else:
        return print("Algılanamadı")



@app.route('/get_market', methods=['POST'])
def get_market_route():
    try:
        data = request.json
        market = data.get('market', [])

        print(f"Selected Market: {market}")
        return jsonify({'market': market})
    except Exception as e:
        return jsonify({'error': str(e)})




@app.route('/get_recommendations', methods=['POST'])
def get_recommendations():
    try:
        data = request.json
        emotion = data['emotion']
        artist_names = data.get('artist_names', [])
        genres = data.get('genres', '')

        recommendations = get_recommendations_based_on_emotion(emotion=emotion, artist_names= artist_names, genres=genres)
        print(recommendations)

        return jsonify({'recommendations': recommendations})

    except Exception as e:
        return jsonify({'error': str(e)})


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)