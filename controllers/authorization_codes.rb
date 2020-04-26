# frozen_string_literal: true

module Controllers
  # Controller used to create authorization codes by which a user gives the
  # right to an application to get access token to its API data in its name.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class AuthorizationCodes < Virtuatable::Controllers::Base
    api_route 'post', '/', options: { authenticated: false, premium: true } do
      authorization = Services::OAuth.instance.create(
        application: application,
        account: account
      )
      api_created authorization
    end

    def account
      check_presence 'account_id'
      acc = Arkaan::Account.find(id: params['account_id'])
      acc.nil? ? api_not_found('account_id.unknown') : acc
    end
  end
end
