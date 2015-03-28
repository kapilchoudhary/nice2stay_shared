class Category < ActiveRecord::Base
  has_many :accommodations, dependent: :destroy
  after_update { self.accommodations.each(&:touch) }
  translates :name, :h1_text, :p_text, :meta_title, :meta_description
  globalize_accessors

  def self.get_by_name(name)
    self.where(:name => name)
  end
end
