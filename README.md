# TODO-FLUTTER

**TODO-FLUTTER** es una aplicación móvil de administración de tareas desarrollada con Flutter. Este proyecto busca proporcionar una interfaz intuitiva y eficiente para organizar las tareas diarias, con funcionalidades completas de un CRUD (Crear, Leer, Actualizar, Eliminar) sincronizado con una API personalizada. La aplicación incluye características como autenticación de usuarios, creación y gestión de tareas, y un diseño atractivo para mejorar la experiencia del usuario. (Realizado para una prueba técnica de la empresa Siesa)

---

## Características principales

- **Gestión de tareas:** Crear, leer, actualizar y eliminar tareas.
- **Interfaz intuitiva:** Pantallas diseñadas para facilitar la interacción del usuario.
- **Estado de las tareas:** Clasificación por estado (Pendiente, En Progreso, Completada).
- **Autenticación de usuarios:** Registro e inicio de sesión seguro.
- **Persistencia de usuario:** Implementada mediante Shared Preferences para recordar sesiones iniciadas.
- **Sincronización con backend:** Integrado con una API desarrollada con NestJS.

---

## Información para pruebas

Si no deseas crear un usuario para probar la aplicación, puedes utilizar el siguiente usuario de prueba:

- **Correo electrónico:** janayasimanca1@gmail.com
- **Contraseña:** 12345678

---

## Capturas de Pantalla

### Bienvenida
![form-screen-create-update](https://github.com/user-attachments/assets/a6d8e21e-2345-48da-b4c5-51c418a9a195)

### Inicio de Sesión
![login-screen](https://github.com/user-attachments/assets/dee36b88-2187-41ab-bce9-1ddf88367315)

### Registro
![register-screen](https://github.com/user-attachments/assets/ef2b6456-56ee-4493-85b5-3e1c4ab3824b)


### Inicio (Tareas de Hoy)
![home-screen](https://github.com/user-attachments/assets/cd12a349-5bf7-4407-8092-43435ec85745)


### Crear/Editar Tareas - Presiona en cualquier item y se le despliega el otro menú
![home-screen](https://github.com/user-attachments/assets/9d130c8a-4920-4380-ad50-6a7bbeb1fa5c)


---

## Instalación

1. Clona el repositorio:
   ```bash
   git clone https://github.com/JoseFeliciano-spec/todo-flutter.git
   cd todo-flutter
   ```

2. Instala las dependencias:
   ```bash
   flutter pub get
   ```

3. Ejecuta la aplicación:
   ```bash
   flutter run
   ```

---

## Backend

El proyecto utiliza una API personalizada desarrollada con [NestJS](https://github.com/JoseFeliciano-spec/TODO-BACKEND-NEST), que gestiona la lógica del CRUD, la autenticación y el almacenamiento de datos.

### Instalación del backend
1. Clona el repositorio:
   ```bash
   git clone https://github.com/JoseFeliciano-spec/TODO-BACKEND-NEST.git
   cd TODO-BACKEND-NEST
   ```

2. Sigue las instrucciones del README en el repositorio para configurar y ejecutar el servidor.

---

## Inspiración y referencias

TODO-FLUTTER está inspirado en un proyecto previamente desarrollado llamado [TODO-FRONTEND-NEXT](https://github.com/JoseFeliciano-spec/TODO-FRONTEND-NEXT), un CRUD funcional basado en Next.js.

---

## Tecnologías utilizadas

- **Frontend móvil:** Flutter
- **Persistencia de usuario:** Shared Preferences
- **Backend:** NestJS ([TODO-BACKEND-NEST](https://github.com/JoseFeliciano-spec/TODO-BACKEND-NEST))
- **Frontend web relacionado:** Next.js ([TODO-FRONTEND-NEXT](https://github.com/JoseFeliciano-spec/TODO-FRONTEND-NEXT))

---

## Contribuciones

¡Las contribuciones son bienvenidas! Si deseas contribuir a este proyecto, por favor abre un issue o envía un pull request.

---

## Autor

Desarrollado por [Jose Feliciano](https://github.com/JoseFeliciano-spec).

---

## Licencia

Este proyecto está licenciado bajo la licencia MIT. Consulta el archivo `LICENSE` para más información.

---
