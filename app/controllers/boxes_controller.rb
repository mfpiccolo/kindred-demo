class BoxesController < ActionController::Base

  def create
    @box = Box.new(box_params)

    respond_to do |format|
      if @box.save
        format.json { render json: @box.to_json, status: :created }
      else
        format.json { render json: @box.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @box = Box.find(params[:id])

    respond_to do |format|
      if @box.update_attributes(box_params)
        format.json { render json: @box.to_json, status: :created }
      else
        format.json { render json: @box.errors, status: :unprocessable_entity }
      end
    end
  end

  def index
    @work_order = WorkOrder.find(params[:work_order_id])
    @boxes = @work_order.boxes

    respond_to do |format|
      format.html
      format.pdf {
        pdf = PrawnBox.new(wo: @work_order, boxes: @boxes, view: view_context)
        send_data pdf.render, content_type: "application/pdf",
          filename: "filename.pdf", disposition: "inline"
      }
    end
  end


  private

  def box_params
    params.require(:box).permit(:invoice_id, :uuid)
  end
end
