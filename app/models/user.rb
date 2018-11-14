class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable  :registerable
  devise :ldap_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable,
         :authentication_keys => [:username]

  validates_uniqueness_of :username, :allow_nil => true, :allow_blank => true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX }, :allow_nil => true, :allow_blank => true
  validate :some_id_is_blank

  before_save :setup_attr
  before_create :build_personid
  after_create_commit :create_ldap
  after_update_commit :update_ldap
  after_destroy_commit :destroy_ldap

  MIN_PASSWORD_LENGTH_ALLOWED = 8

  def valid_password?(params)
    # TODO: Rails実装のvalidationにする
    if params[:password].blank?
      errors[:base] << "パスワードが空です。"
      return false
    end
    if params[:password].size < MIN_PASSWORD_LENGTH_ALLOWED
      errors[:base] << "パスワードが短いです。８文字以上入力してください。"
      return false
    end
    if params[:password_confirmation].blank?
      errors[:base] << "パスワード(確認)が空です。"
      return false
    end

    unless params[:password] == params[:password_confirmation]
      errors[:base] << "パスワードと確認パスワードが一致しません"
      return false
    end

    true
  end

  def setup_attr
    self.email.strip! if self.email
    if self.email.blank?
      self.email = nil
    end

    self.password.strip! if self.password
    if self.password.blank?
      self.password = nil
    end

    # password
    if self.id.blank? && self.username.present? && self.password.blank?
      # 新規作成時(id空)でログインID(username)記入済みでパスワードが空の場合に自動生成する
      generated_password = Devise.friendly_token.first(8)
      puts "@@@ generated_password:#{generated_password}"
      self.password = generated_password
    end

  end

  def some_id_is_blank
    unless cardid.present? or email.present? or username.present? or full_name.present?
      errors.add(:cardid, "利用者番号、Eメールアドレス、ログインID、フルネーム　のいずれかを入力してください。")
    end
  end

  def build_personid
    self.personid = SecureRandom.uuid
  end

  def update_ldap

  end

  def update_ldap_password
    # TODO: もうちょっとうまい方法は無いのか。
    ldap_config = YAML.load(ERB.new(File.read(::Devise.ldap_config || "#{Rails.root}/config/ldap.yml")).result)[Rails.env]
    base_dn = ldap_config['base']
    # TODO: ログインＩＤに相当する項目は、ldap.ymlのattributeから取得する
    logger.info "@@1 update_ldap_password"
    dn = "uid=#{self.username}, #{base_dn}"
    attr = {
        :userPassword => self.password,
    }
    operation_result = nil
    auth = { :method => :simple,
             :username => ldap_config["admin_user"],
             :password => ldap_config["admin_password"]
    }
    Net::LDAP.open(:host => ldap_config["host"],
                   :port => ldap_config["port"],
                   :auth => auth) do |ldap|

      unless ldap.password_modify(dn: dn,
                                   auth: auth,
                                   new_password: self.password)

        operation_result = ldap.get_operation_result
      end
    end

    if operation_result
      unless operation_result.code == 0
        if operation_result.code == 68
          # Entry Already Exists
        end
        puts "LDAP error."
        pp operation_result
      end
    end

  end

  def destroy_ldap
    # TODO: もうちょっとうまい方法は無いのか。
    ldap_config = YAML.load(ERB.new(File.read(::Devise.ldap_config || "#{Rails.root}/config/ldap.yml")).result)[Rails.env]
    base_dn = ldap_config['base']
    # TODO: ログインＩＤに相当する項目は、ldap.ymlのattributeから取得する
    logger.info "@@1 destroy_ldap"
    dn = "uid=#{self.username}, #{base_dn}"

    operation_result = nil
    auth = { :method => :simple,
             :username => ldap_config["admin_user"],
             :password => ldap_config["admin_password"]
    }
    Net::LDAP.open(:host => ldap_config["host"],
                   :port => ldap_config["port"],
                   :auth => auth) do |ldap|

      unless ldap.delete(dn: dn)
        operation_result = ldap.get_operation_result
      end
    end

    if operation_result
      unless operation_result.code == 0
        if operation_result.code == 68
          # Entry Already Exists
        end
        puts "LDAP error."
        pp operation_result
      end
    end
  end

  def create_ldap
    unless username.present?
      logger.info "username is blank. skip create ldap"
    end

    # TODO: もうちょっとうまい方法は無いのか。
    ldap_config = YAML.load(ERB.new(File.read(::Devise.ldap_config || "#{Rails.root}/config/ldap.yml")).result)[Rails.env]
    base_dn = ldap_config['base']
    # TODO: ログインＩＤに相当する項目は、ldap.ymlのattributeから取得する
    logger.info "@@1 ldap_before_save"
    dn = "uid=#{self.username}, #{base_dn}"
    attr = {
        :cn => "#{self.username}",
        :sn => "#{self.username}",
        :uid => self.username,
        :userPassword => self.password,
        :objectclass => ['inetOrgPerson'],
    }

    operation_result = nil
    auth = { :method => :simple,
             :username => ldap_config["admin_user"],
             :password => ldap_config["admin_password"]
    }
    Net::LDAP.open(:host => ldap_config["host"],
                   :port => ldap_config["port"],
                   :auth => auth) do |ldap|
      unless ldap.add(dn: dn, attributes: attr)
        operation_result = ldap.get_operation_result
      end
    end
    if operation_result
      unless operation_result.code == 0
        if operation_result.code == 68
          # Entry Already Exists
        end
        puts "LDAP error."
        pp operation_result
      end
    end
  end

  def ldap_before_save
    logger.info "@@1 ldap_before_save"
    #name = Devise::LDAP::Adapter.get_ldap_param(self.username, "cn")
    #self.name = name.first
    #self.email = self.name + "@foo.com"
    #self.time_zone = "Tokyo"
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
