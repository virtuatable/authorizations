RSpec.describe Controllers::AuthorizationCodes do
  def app
    Controllers::AuthorizationCodes
  end

  let!(:account) { create(:babausse) }

  describe 'GET /' do
    let!(:application) { create(:application, creator: account, premium: true) }
    let!(:auth) { create(:authorization, application: application, account: account) }
    let!(:session) { create(:session, account: account) }

    it_should_behave_like 'a route', 'get', '/own', {premium: true}

    describe 'Nominal cases' do
      before do
        get '/own', {
          app_key: application.key,
          session_id: session.token
        }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json({
          count: 1,
          items: [
            {
              code: auth.code,
              created_at: auth.created_at.iso8601
            }
          ]
        })
      end
    end
  end

  describe 'GET /:id' do
    let!(:application) { create(:application, creator: account) }
    let!(:authorization) { create(:authorization, account: account, application: application) }

    describe 'Nominal case' do
      before do
        get "/#{authorization.code}", {app_key: application.key}
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          code: authorization.code,
          created_at: authorization.created_at.iso8601
        )
      end
    end
    describe '403 errors' do
      let!(:other_app) { create(:application, creator: account) }

      before do
        get "/#{authorization.code}", {app_key: other_app.key}
      end
      it 'Returns a 403 (Forbidden) status code' do
        expect(last_response.status).to be 403
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          status: 403,
          field: 'app_key',
          error: 'forbidden'
        )
      end
    end
    describe '404 errors' do
      before do
        get '/unknown', {app_key: application.key}
      end
      it 'Returns a 404 (Not Found) status code' do
        expect(last_response.status).to be 404
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          status: 404,
          field: 'auth_code',
          error: 'unknown'
        )
      end
    end
  end
  describe 'POST /' do

    let!(:application) { create(:application, creator: account, premium: true) }

    it_should_behave_like 'a route', 'post', '/', {premium: true}

    describe 'Nominal case' do
      before do
        post '/', {
          app_key: application.key,
          account_id: account.id
        }
      end
      it 'Returns a 201 (Created) status code' do
        expect(last_response.status).to be 201
      end
      it 'Returns the correct body' do
        auth = Arkaan::OAuth::Authorization.first
        expect(last_response.body).to include_json(
          code: auth.code,
          created_at: auth.created_at.iso8601
        )
      end
      it 'Has created the authorization code in the database' do
        expect(Arkaan::OAuth::Authorization.count).to be 1
      end
    end

    describe '400 errors' do
      describe 'When the account ID is not given' do
        before do
          post '/', {app_key: application.key}
        end
        it 'Returns a 400 (Bad Request) status code' do
          expect(last_response.status).to be 400
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            status: 400,
            field: 'account_id',
            error: 'required'
          )
        end
        it 'Has created no authorization code' do
          expect(Arkaan::OAuth::Authorization.count).to be 0
        end
      end
    end

    describe '404 errors' do
      describe 'When the account ID is not found' do
        before do
          post '/', {
            app_key: application.key,
            account_id: 'unknown'
          }
        end
        it 'Returns a 404 (Not Found) status code' do
          expect(last_response.status).to be 404
        end
        it 'Returns the correct body' do
          expect(last_response.body).to include_json(
            status: 404,
            field: 'account_id',
            error: 'unknown'
          )
        end
        it 'Has created no authorization code' do
          expect(Arkaan::OAuth::Authorization.count).to be 0
        end
      end
    end
  end
end