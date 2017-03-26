class User < ApplicationRecord
  has_many :friendships
  has_many :friends, through: :friendships

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :first_name, :last_name, :website
  validates :website, format: { with: URI::regexp(%w(http https)), message: 'Must start with http/https' }

  after_validation [:fetch_headers, :make_searchable], if: :website_changed?

  def full_name
    "#{first_name} #{last_name}"
  end

  def fetch_headers
    page = Nokogiri::HTML(open(website))
    raw_headers = page.css('h1,h2,h3').sort_by { |h| h.name }
    self.headers = raw_headers.map{ |h| {h.name => h.text} if h.text.present? }.compact
    self.headers.map { |h| h.map{|k,v| self.searchable << v } }
  end

  def befriend(user)
    self.friends << user
    user.friends << self
  end

  def can_befriend?(user)
    !(friends.include?(user) || self == user)
  end

  def self.search(search)
    if search
      where('searchable ilike ?', "%#{search}%")
    else
      all
    end
  end
end
