class ResourcesPortfolioEntry < ActiveRecord::Base

  belongs_to :resource
  belongs_to :portfolio_entry

  before_save do |resource_portfolio_entry|
    resource_portfolio_entry.position = (ResourcesPortfolioEntry.maximum(:position) || -1) + 1
  end

end
