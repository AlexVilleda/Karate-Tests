function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    apiUrl: 'http://conduit.productionready.io/api/'
  }

  if (env == 'dev') {
    config.userEmail = 'test@gmailinator.com'
    config.userPassword = 'test1234'
  }
  if (env == 'qa') {
    config.userEmail = 'test2@gmailinator.com'
    config.userPassword = 'test5678'
  }
 
  var accessToken = karate.callSingle('classpath:helpers/CreateToken.feature', config).AuthToken
  karate.configure('headers', {Authorization: 'Token ' + accessToken})

  return config;
}