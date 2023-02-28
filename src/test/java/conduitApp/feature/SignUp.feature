
Feature: 1. Registro de usuarios

    Background: Preconditions
        * def dataGenerator = Java.type('helpers.DataGenerator')
        Given url apiUrl


    Scenario: CP-01 Registro de un nuevo usuario de manera exitosa

        * def randomEmail = dataGenerator.getRandomEmail()
        * def randomUsername = dataGenerator.getRandomUsername()
    
        Given path 'users'
        And request
        """
            {
                "user": {
                "email": #(randomEmail),
                "password": "12345678",
                "username": #(randomUsername)
                }
            }
        """
        When method Post
        Then status 200
        And match response ==
        """
            {
                "user": {
                    "email": #(randomEmail),
                    "username": #(randomUsername),
                    "bio": "##string",
                    "image": "##string",
                    "token": "#string"
                }
            }
        """


    Scenario: CP-02 Registro de un nuevo usuario fallido con datos erroneos (Nombre de usuario ya existente)

        * def randomEmail = dataGenerator.getRandomEmail()

        Given path 'users'
        And request
        """
            {
                "user": {
                "email": #(randomEmail),
                "password": "test123",
                "username": "test123"
                }
            }
        """
        When method Post
        Then status 422



    Scenario: CP-03 Registro de nuevo usuario fallido con campos vacios (Campo de email vacio)

    * def randomUsername = dataGenerator.getRandomUsername()

    Given path 'users'
    And request
    """
        {
            "user": {
            "email": "",
            "password": "test123",
            "username": #(randomUsername)
            }
        }
    """
    When method Post
    Then status 422


    Scenario: CP-04 Registro de nuevo usuario fallido con campos vacios (Campo de contraseña vacio)

    * def randomEmail = dataGenerator.getRandomEmail()
    * def randomUsername = dataGenerator.getRandomUsername()

    Given path 'users'
    And request
    """
        {
            "user": {
            "email": #(randomEmail),
            "password": "",
            "username": #(randomUsername)
            }
        }
    """
    When method Post
    Then status 422

Scenario: CP-05 Registro de nuevo usuario fallido con campos vacios (Campo de nombre de usuario vacio)

    * def randomEmail = dataGenerator.getRandomEmail()
    * def randomUsername = dataGenerator.getRandomUsername()

    Given path 'users'
    And request
    """
        {
            "user": {
            "email": #(randomEmail),
            "password": "test123",
            "username": ""
            }
        }
    """
    When method Post
    Then status 422

