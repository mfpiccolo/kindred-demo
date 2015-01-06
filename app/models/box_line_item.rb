class BoxLineItem < ActiveRecord::Base
  belongs_to :box
  after_initialize :finalize

  validates :qty, presence: true, numericality: true

  private
  # TODO move this to gem
  def set_uuid
    self.uuid ||= SecureRandom.uuid
  end

  def finalize
    if self.attributes.has_key? "uuid"
      set_uuid
    end
  end
end
