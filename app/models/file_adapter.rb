class FileAdapter < ApplicationRecord
  has_one_attached :importfile

  validates :importfile, presence: true
end
