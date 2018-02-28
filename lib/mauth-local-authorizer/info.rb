module MAuthLocalAuthorizer
  module Info
    NAME = 'mauth-local-authorizer'
    SUMMARY = 'Take a private key and generate a json file for mauth running with local storage'
    VERSION = '0.0.1'
    DESCRIPTION = <<DESC
Set up a config file (or provide the option) with the location of your local
mauth server, then run this with the path to an app's private mauth_key. It
will generate a new app id, create the public key, and write a key file to
mauth's local_security_tokens directory for you.
DESC
  end
end
