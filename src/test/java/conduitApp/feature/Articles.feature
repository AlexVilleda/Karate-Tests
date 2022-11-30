
Feature: Articles

Background: Define URL
    * url apiUrl
    * def articleRequestBody = read("classpath:conduitApp/json/newArticleRequest.json")
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * set articleRequestBody.article.title = dataGenerator.getRandomArticleValues().title
    * set articleRequestBody.article.description = dataGenerator.getRandomArticleValues().description
    * set articleRequestBody.article.body = dataGenerator.getRandomArticleValues().body
    # * def tokenResponse = callonce read('classpath:helpers/CreateToken.feature')
    # * def token = tokenResponse.AuthToken

# Scenario: Create new article
#     Given path 'articles'
#     And request articleRequestBody
#     When method Post
#     Then status 200
#     And match response.article.title == articleRequestBody.article.title
#     * def slug = response.article.slug

#     Given path 'articles', slug
#     When method Delete
#     Then status 204

Scenario: Create and delete article
    # Given header Authorization = 'Token ' + token
    Given path 'articles'
    And request articleRequestBody
    When method Post
    Then status 200
    * def articleId = response.article.slug

    Given params {limit:10, offset: 0}
    Given path 'articles'
    When method Get
    Then status 200
    # And match response.articles[0].title == 'Delete article'

    # Given header Authorization = 'Token ' + token
    Given path 'articles', articleId
    When method Delete
    Then status 204
    
    Given params {limit:10, offset: 0}
    Given path 'articles'
    When method Get
    Then status 200
    And match response.articles[0].title != 'Delete article'