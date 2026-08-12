# ==============================================
# EJERCICIO 10 - COLAS (QUEUE)
# Gestión de Camiones en Centro Logístico
# ==============================================

# Lista que funcionará como una cola (Queue)
cola_camiones = []

# Función para registrar camión
def registrar_camion():
    camion = input("Ingrese el nombre o placa del camión: ").strip()

    # Validación
    if camion == "":
        print("Error: El nombre o placa no puede estar vacío.")
    else:
        cola_camiones.append(camion)
        print("Camión registrado correctamente.")

# Función para autorizar descarga
def autorizar_descarga():
    # Verificar si existen camiones en espera
    if len(cola_camiones) == 0:
        print("No hay camiones en espera.")
    else:
        autorizado = cola_camiones.pop(0)
        print(f"Camión autorizado para descarga: {autorizado}")


# Función para mostrar siguiente camión
def mostrar_siguiente():
    # Validar si hay camiones pendientes
    if len(cola_camiones) == 0:
        print("No hay camiones pendientes.")
    else:
        print(f"Siguiente camión: {cola_camiones[0]}")

# Función para mostrar lista de espera
def mostrar_lista():
    if len(cola_camiones) == 0:
        print("La lista de espera está vacía.")
    else:
        print("\n===== LISTA DE ESPERA DE CAMIONES =====")

        # Mostrar camiones en orden de llegada
        for camion in cola_camiones:
            print(f"- {camion}")

        print("========================================")

# Menú principal del sistema
while True:
    print("\n===== GESTIÓN DE CAMIONES EN CENTRO LOGÍSTICO =====")
    print("1. Registrar camión")
    print("2. Autorizar descarga")
    print("3. Mostrar siguiente camión")
    print("4. Mostrar lista de espera")
    print("5. Salir")

    opcion = input("Seleccione una opción: ")

    # Validación de opciones
    if opcion == "1":
        registrar_camion()

    elif opcion == "2":
        autorizar_descarga()

    elif opcion == "3":
        mostrar_siguiente()

    elif opcion == "4":
        mostrar_lista()

    elif opcion == "5":
        print("Saliendo del sistema...")
        break

    else:
        print("Opción inválida. Intente nuevamente.")