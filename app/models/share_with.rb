class ShareWith < ApplicationRecord
  belongs_to :place
  # has_many :user
  belongs_to :user
end
