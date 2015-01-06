class BoxLineItem::SaveAll
  attr_reader :line_items, :errors, :result, :data, :deletable_box_ids

  def self.call(line_items, deletable_box_ids, opts={})
    new(line_items, deletable_box_ids, opts).call
  end

  def initialize(line_items, deletable_box_ids, opts={})
    @line_items = HashWithIndifferentAccess.new(line_items)
    @deletable_box_ids = deletable_box_ids.reject { |c| !c.present? }
    @data = {box_line_items: [], removed_box_uuids: []}
    @errors = {}
    @result = true
  end

  def call
    process_lis
    build_data
    delete_boxes if errors.empty?
    result
  end


  private

  attr_writer :result

  def process_lis
    ActiveRecord::Base.transaction do
      line_items.each_pair do |i, attrs|
        next if deletable_box_ids.include?(attrs["box_id"].to_s)
        begin
          if attrs[:delete].to_s == "true"
            handle_deletion(attrs)
          else
            apply_changes(i, attrs)
          end
        rescue ActiveRecord::RecordInvalid
          self.result = false
          next
        end

        raise ActiveRecord::Rollback if result == false
      end
    end
  end

  def build_data
    line_items.each_pair do |i, attrs|
      next if deletable_box_ids.include?(attrs["box_id"].to_s)
      if attrs[:delete] == "true"
        box_line_item = OpenStruct.new(attributes: {uuid: attrs[:uuid], remove: true})
      else
        box_line_item = BoxLineItem.find_or_initialize_by(uuid: attrs[:uuid])
        box_line_item.assign_attributes(sanitized_params(attrs))
      end

      self.data[:box_line_items] << {
        box_line_item: HashWithIndifferentAccess.new(box_line_item.attributes),
        errors: HashWithIndifferentAccess.new(@errors[i])
      }
    end
  end

  def handle_deletion(attrs)
    BoxLineItem.find_by(uuid: attrs[:uuid]).try(:destroy)
  end

  def apply_changes(i, attrs)
    bli = BoxLineItem.find_or_initialize_by(uuid: attrs[:uuid])
    bli.assign_attributes(sanitized_params(attrs))
    bli.save!

  rescue ActiveRecord::RecordInvalid
    self.errors.merge!({i => bli.errors.messages})
    raise ActiveRecord::RecordInvalid.new(BoxLineItem.new)
  end

  def delete_boxes
    deletable_box_ids.each do |id|
      box = Box.find(id)
      self.data[:removed_box_uuids].push box.uuid
      box.destroy
    end
  end

  def sanitized_params(params)
    params.delete(:ignore)
    params.delete(:delete)
    params.delete(:id)
    params
  end

end
