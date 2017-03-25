class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :first_name, :last_name, :website
  validates :website, format: { with: URI::regexp(%w(http https)), message: 'Must start with http/https' }

  after_validation :fetch_headers, if: :website_changed?

  def full_name
    "#{first_name} #{last_name}"
  end

  def fetch_headers
    raw_headers = Nokogiri::HTML(open(website)).css('h1,h2,h3')
    self.headers = raw_headers.map{ |h| {h.name => h.text} if h.text.present? }.compact
  end
end
