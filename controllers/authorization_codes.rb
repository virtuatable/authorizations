# frozen_string_literal: true

module Controllers
  # Controller used to create authorization codes by which a user gives the
  # right to an application to get access token to its API data in its name.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class AuthorizationCodes < Virtuatable::Controllers::Base
    api_route 'post', '/', options: { authenticated: false, premium: true } do
      api_created Services::OAuth.instance.create(
        application: application,
        account: account
      )
    end

    api_route 'get', '/own', options: { premium: true } do
      api_list session.account.authorizations
    end

    api_route 'get', '/:id', options: { authenticated: false } do
      api_item authorization
    end

    def authorization
      auth = Arkaan::OAuth::Authorization.find_by(code: params['id'])
      api_not_found('auth_code.unknown') if auth.nil?
      if auth.application.key != params['app_key']
        api_forbidden 'app_key.forbidden'
      end
      auth
    end

    def account
      check_presence 'account_id'
      acc = Arkaan::Account.find(id: params['account_id'])
      acc.nil? ? api_not_found('account_id.unknown') : acc
    end
  end
end
