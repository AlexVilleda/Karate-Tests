
Feature: Sign Up new user

    Background: Preconditions
        * def dataGenerator = Java.type('helpers.DataGenerator')
        Given url apiUrl

    Scenario: New User Sign Up (User and username already taken)
        Given def userData = {email: "user@gmail.com", username: "user"}

        Given path 'users'
        And request
        """
            {
                "user": {
                "email": #(userData.email),
                "password": "12345678",
                "username": #(userData.username)
                }
            }
        """
        When method Post
        Then status 422

    Scenario: New User Sign Up (Password can't be blank)

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


    Scenario: New User Sign Up (Successfull Sign Up)

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


    Scenario Outline: Validate Sign Up error     messages

        * def randomEmail = dataGenerator.getRandomEmail()
        * def randomUsername = dataGenerator.getRandomUsername()
    
        Given path 'users'
        And request
        """
            {
                "user": {
                "email": "<email>",
                "password": "<password>",
                "username": "<username>"
                }
            }
        """
        When method Post
        Then status 422
        And match response == <errorResponse>

        Examples:
            | email                 | password  | username               | errorResponse                                                        |
            | #(randomEmail)        | Karate123 | KarateUser123          | {"errors":{"username":["has already been taken"]}}                   |
            | KarateUser1@test.com  | Karate123 | #(randomUsername)      | {"errors":{"email":["has already been taken"]}}                      |
            |                       | Karate123 | #(randomUsername)      | {"errors":{"email":["can't be blank"]}}                              |
            | #(randomEmail)        |           | #(randomUsername)      | {"errors":{"password":["can't be blank"]}}                           |
            | #(randomEmail)        | Karate123 |                        | {"errors":{"username":["can't be blank"]}}                           |
            # | KarateUser1         | Karate123 | #(randomUsername)      | {"errors":{"email":["is invalid"]}}                                  |  //Test obsoleto, aunque el mail no tenga el formato adecuado, el usuario se creara
            # | #(randomEmail)      | Karate123 | KarateUser123123123123 | {"errors":{"username":["is too long (maximum is 20 characters)"]}}   |  //Test obsoleto, aunque el username sea muy largo (mas de 20 caracteres), el usuario sera creado
            # | #(randomEmail)      | Kar       | #(randomUsername)      | {"errors":{"password":["is too short (minimum is 8 characters)"]}}   | //En este test aunque la contraseña sea corta, la app la aceptará