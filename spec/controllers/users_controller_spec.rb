require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:valid_attributes) {
    {
      first_name: "John",
      last_name: "Doe",
      email: "john.doe@example.com",
      password: "test@123",
      password_confirmation: "test@123"
    }
  }
  user_data = {
    first_name: "John",
    last_name: "Doe",
    email: "john.doe@example.com",
    password: "test@123",
    password_confirmation: "test@123"
  }
  invalid_data = { first_name: nil, email: "invalid_email" }

  describe "POST #create" do
    context "with valid params" do
      it "creates a new User" do
        puts "Valid attributes: #{valid_attributes.inspect}" # Debugging line
        expect {
          post :create, params: { user: user_data }
          puts "Response body: #{response.body}" # Debugging line
          expect(response).to have_http_status(:redirect) # Add this line
        }.to change(User, :count).by(1)
      end

      it "redirects to the created user" do
        post :create, params: { user: user_data }
        expect(response).to redirect_to("new")
      end
    end

    context "with invalid params" do
      it "does not create a new User" do
        expect {
          post :create, params: { user: invalid_data }
        }.to change(User, :count).by(0)
      end

      it "re-renders the 'new' template" do
        post :create, params: { user: invalid_data }
        expect(response).to render_template("new")
      end
    end
  end
end
