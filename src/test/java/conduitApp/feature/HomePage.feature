
Feature: 3. Obtencion de Articulos y Etiquetas

    Background: Define URL
        Given url apiUrl


    Scenario: CP-08 Consultar articulos creados
        * def timeValidator = read('classpath:helpers/timeValidator.js')

        Given params {limit:10, offset: 0}
        Given path 'articles'
        When method Get
        Then status 200
        And match response == {"articles":"#[10]", "articlesCount": "#number"}
        And match each response.articles == 
        """
            {
                "slug": "#string",
                "title": "#string",
                "description": "##string",
                "body": "#string",
                "tagList": "#array",
                "createdAt": "#? timeValidator(_)",
                "updatedAt": "#? timeValidator(_)",
                "favorited": false,
                "favoritesCount": "#number",
                "author": {
                    "username": "#string",
                    "bio": "##string",
                    "image": "#string",
                    "following": "#boolean"
                }
            }
        """

    Scenario: CP-09 Visualizar etiquetas utilizadas
        # Se consultan las etiquetas mas utilizadas en los articulos, verificando que la respuesta sea un array de cadenas de caracteres
        Given path 'tags'
        When method Get
        Then status 200
        And match response.tags == '#array'
        And match each response.tags == '#string'
