class Box < ActiveRecord::Base
  belongs_to :invoice
  has_many :box_line_items
  after_initialize :finalize

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
