class Place < ApplicationRecord
  belongs_to :user
  has_many :shareWiths, dependent: :destroy
end
