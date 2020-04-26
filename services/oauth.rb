# frozen_string_literal: true

module Services
  # Service used to handle manipulation of oauth tokens.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class OAuth
    include Singleton

    # Creates an authorization code for an application to be able to
    # create an Oauth2.0 token for a user. As a first version, all the
    # informations a user can access are accessible by the app.
    #
    # @todo implement a scopes system to know what an application can access.
    #
    # @param application [Arkaan::OAuth::Application] the application trying to
    #   get the authorization of the user to access its data.
    # @param account [Arkaan::Account] the account of the user trying to use
    #   the application.
    #
    # @return [Arkaan::OAuth::Authorization] an autorization code used later
    #   by the application to get a token to access the user's data.
    def create(application:, account:)
      Arkaan::OAuth::Authorization.create(
        application: application,
        account: account
      )
    end
  end
end
