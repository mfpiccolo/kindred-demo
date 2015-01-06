class BoxLineItemsController < ActionController::Base

  def destroy
    @box_line_item = BoxLineItem.find(params[:id])
    @box_line_item.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def save_all
    service = BoxLineItem::SaveAll.new(params[:box_line_items], params[:deletable_box_ids])
    status = service.call ? 200 : 422
    render json: service.data, status: status
  end

  private

  def box_li_params
    params.require(:box_line_item).permit(:qty, :color, :description, :box_id, :uuid)
  end
end
