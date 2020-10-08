# SHOGun Example App

This is an example project derived from [shogun](https://github.com/terrestris/shogun).  
The same requirements must be considered here.

1. Checkout this repository as your app. Don't forget to rename the app!
The current name is `shogun-example-app`.

   ```bash
   git clone git@github.com:terrestris/shogun-example-app.git
   ```

2. Checkout the `shogun-docker` repository.

   ```bash
   git clone git@github.com:terrestris/shogun-docker.git
   ```

3. Create a new project in IntelliJ by importing the module:

   - `File` -> `Project from Existing Sources…`
   - Navigate to the checkout of the project
   - Select the Project Object Model file (`pom.xml`)

4. Rename all occurrences of `shogun-example-app`.

5. Startup the containers (`shogun-docker`)

   ```bash
   docker-compose up
   ```

6. Navigate to the `ApplicationConfig` in the project tree and run it (open
context menu and select `Run ApplicationConfig.main()`).  
   You may save this `Run/Debug configuration` via the dialog box to restart the
   application easily.

7. The application is now available at the base URL [http://localhost:8080/shogun-example-app](http://localhost:8080/shogun-example-app)

8. Update the Keykloak settings at [http://localhost:8000/auth/](http://localhost:8000/auth/).
Use `admin:shogun` as default credentials. Afterwards it is strongly recommended
changing the login data.
