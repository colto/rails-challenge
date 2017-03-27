class User < ApplicationRecord
  has_many :friendships
  has_many :friends, through: :friendships

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :first_name, :last_name, :website

  after_validation :shorten_url, :fetch_headers, if: :website_changed?

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

  def shorten_url
    response = `curl https://www.googleapis.com/urlshortener/v1/url?key=#{ENV['GOOGLE_API_KEY']} \
      -H 'Content-Type: application/json' \
      -d '{"longUrl": "#{website}"}'`
    json = JSON.parse(response)
    self.short_url = json["id"]
    self.website   = json["longUrl"]
  end
end
