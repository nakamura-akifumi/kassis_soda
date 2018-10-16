class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable  :registerable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable,
         :authentication_keys => [:username]

  validates_uniqueness_of :username, :allow_nil => true, :allow_blank => true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX }, :allow_nil => true, :allow_blank => true
  validate :some_id_is_blank

  before_create :build_personid

  def some_id_is_blank
    unless cardid.present? or email.present? or username.present? or full_name.present?
      errors.add(:cardid, "利用者番号、Eメールアドレス、ログインID、フルネーム　のいずれかを入力してください。")
    end
  end

  def build_personid
    self.personid = SecureRandom.urlsafe_base64(32, true)
  end

  #usernameを利用してログインするようにオーバーライド
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      #認証の条件式を変更する
      where(conditions).where(["username = :value", { :value => username }]).first
    else
      where(conditions).first
    end
  end

  #登録時にemailを不要とする
  def email_required?
    false
  end

  def email_changed?
    false
  end
end
