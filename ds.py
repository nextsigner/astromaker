import sys
from openai import OpenAI

CONSULTA=sys.argv[1]

try:
    with open('api_key.txt', 'r') as archivo:
        #api_key = archivo.read().strip()
        client = OpenAI(api_key=archivo.read().strip(), base_url="https://api.deepseek.com")

        response = client.chat.completions.create(
            model="deepseek-chat",
            messages=[
                {"role": "system", "content": "En qué puedo ayudarte?"},
                {"role": "user", "content": CONSULTA},
            ],
            stream=False
        )

    #print("La clave API se ha leído correctamente.")
    # Ahora la variable api_key contiene el contenido del archivo como string
    # Puedes usar api_key para lo que necesites
    #print(f"Contenido de la clave API: '{api_key}'")
except FileNotFoundError:
    print("Error: El archivo 'api_key.txt' no se encontró.")
except Exception as e:
    print(f"Ocurrió un error al leer el archivo: {e}")


print(response.choices[0].message.content)
