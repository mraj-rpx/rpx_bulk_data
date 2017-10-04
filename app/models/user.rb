class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  belongs_to :account, foreign_key: :account_id
  has_one :document_location, foreign_key: :account_id, primary_key: :account_id
end
