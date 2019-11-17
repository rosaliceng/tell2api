class ShareWith < ApplicationRecord
  belongs_to :place
  has_many :user
end
