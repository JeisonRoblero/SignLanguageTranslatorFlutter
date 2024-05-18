import subprocess
import sys
import os

# Lista de librerías necesarias
libraries = [
    "cv2",  # OpenCV
    "tkinter",  # Tkinter
    "mediapipe",  # MediaPipe
    "sklearn",  # scikit-learn
    "numpy",  # NumPy
    "pyttsx3",  # pyttsx3
    "threading"  # Threading 
]

# Función para verificar si una librería está instalada
def check_and_install(library):
    try:
        __import__(library)
        print(f"'{library}' está instalada.")
    except ImportError:
        print(f"'{library}' no está instalada. Instalando...")

        try:
            subprocess.check_call([sys.executable, "-m", "pip", "install", library])
        except subprocess.CalledProcessError:
            print(f"No se pudo instalar {library}. Intentando con permisos elevados...")
            if os.name == 'nt':  # Para Windows
                subprocess.check_call(['powershell', '-Command', f"Start-Process python -ArgumentList '-m pip install {library}' -Verb runAs"])
            else:
                subprocess.check_call(['sudo', sys.executable, '-m', 'pip', 'install', library])

# Verifica e instala las librerías necesarias
for library in libraries:
    # La biblioteca 'cv2' se importa como 'cv2' pero se instala como 'opencv-python' al igual que sklearn
    if library == "cv2":
        check_and_install("opencv-python")
    elif library == "sklearn":
        check_and_install("scikit-learn")
    else:
        check_and_install(library)

# Probando librerias
import os
import sys
import cv2
import tkinter as tk
from tkinter import messagebox
import pickle
import mediapipe as mp
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
import numpy as np
import pyttsx3
import threading

print("Todas las librerías necesarias están instaladas y listas para usarse.")