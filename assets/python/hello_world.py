import sys

# Se obtienen los argumentos pasados al script
args = sys.argv[1:]

# Se inicializa la variable para almacenar los mensajes
mensaje = None

# Iterar los argumentos
i = 0
while i < len(args):
    # Se verifica si es una etiqueta
    if args[i] == "--mensaje" and i + 1 < len(args):
        # Se obtiene el mensaje que sigue de la etiqueta
        mensaje = args[i + 1]
    i += 1

# Verifica si se ha pasado un mensaje
if mensaje is not None:
    print("Mensaje desde flutter:", mensaje)
else:
    print("No se ha pasado ningun mensaje.")