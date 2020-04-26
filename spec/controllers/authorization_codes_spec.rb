RSpec.describe Controllers::AuthorizationCodes do
  describe 'POST /' do
    def app
      Controllers::AuthorizationCodes
    end

    let!(:account) { create(:babausse) }
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
        expect(last_response.body).to include_json(
          code: Arkaan::OAuth::Authorization.first.code
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