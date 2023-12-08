class MarketVendor < ApplicationRecord
  belongs_to :market
  belongs_to :vendor

  validate :market_or_vendor_must_be_unique

  private

  def market_or_vendor_must_be_unique
    if MarketVendor.where(market_id: market_id).exists? && MarketVendor.where(vendor_id: vendor_id).exists?
      errors.add(:base, "Validation failed: Market vendor association between market and vendor already exists")
    end
  end
end