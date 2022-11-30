
Feature: Tests for the home page

    Background: Define URL
        Given url apiUrl

    Scenario: Get all tags
        Given path 'tags'
        When method Get
        Then status 200
        # And match response.tags contains ['welcome','implementations']
        # And match response.tags !contains 'truck'
        # And match response.tags contains any ['car','hola','introduction']
        And match response.tags == '#array'
        And match each response.tags == '#string'

    Scenario: Get 10 articles from the page
        * def timeValidator = read('classpath:helpers/timeValidator.js')

        Given params {limit:10, offset: 0}
        Given path 'articles'
        When method Get
        Then status 200
        # And match response.articles == '#[3]' //Es un array con longitud = 3. O sea que tiene 3 elementos dentro
        # And match response.articlesCount == 150
        And match response == {"articles":"#[10]", "articlesCount": "#number"} //Verifica el contenido interno de la respuesta 
        # And match response.articles[0].createdAt contains '2022'
        # And match response.articles[*].favoritesCount contains 0    //El asterisco sirve para decir que revise en cada uno favoritesCount de los articulos
        # And match response..bio contains null //Equivales response.articles[*].author.bio, pero mas breve
        # # And match each response..following == false  //Busca que en cada 'following' su valor sea false (Con uno distinto dará error)
        # And match each response..following == '#boolean'
        # And match each response..favoritesCount == '#number'
        # And match each response..bio == '##string'  //Con doble ## se indica que el valor puede ser string, nulo o incluso bio puede no estar y el test fallará
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