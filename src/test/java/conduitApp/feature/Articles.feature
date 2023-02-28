
Feature: 2. Creacion y Eliminacion de Articulos

# Se utilizara contenido generado aleatoriamente para el contenido de los articulos de pruebas
Background: Define URL
    * url apiUrl
    * def articleRequestBody = read("classpath:conduitApp/json/newArticleRequest.json")
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * set articleRequestBody.article.title = dataGenerator.getRandomArticleValues().title
    * set articleRequestBody.article.description = dataGenerator.getRandomArticleValues().description
    * set articleRequestBody.article.body = dataGenerator.getRandomArticleValues().body

Scenario: CP-06 Creacion de nuevo articulo de forma exitosa

    Given path 'articles'
    And request articleRequestBody
    When method Post
    Then status 200
    And match response.article.title == articleRequestBody.article.title



Scenario: CP-07 Eliminar articulo de forma exitosa
    # Se creara un nuevo articulo para ser eliminado posteriormente
    Given path 'articles'
    And request articleRequestBody
    When method Post
    Then status 200
    * def articleId = response.article.slug

    Given params {limit:10, offset: 0}
    Given path 'articles'
    When method Get
    Then status 200

    Given path 'articles', articleId
    When method Delete
    Then status 204
    
    Given params {limit:10, offset: 0}
    Given path 'articles'
    When method Get
    Then status 200
    And match response.articles[0].title != articleRequestBody.article.title