class @NestedInvoicesController

  @edit: ->
    jQuery ->
      App.BoxListeners.set()

      # setup for boxes
      box_template_info = App.Template.template_info["box"]
      App.Box.set_template box_template_info.template

      # append box collection
      $(box_template_info.collection).each (i, model_attrs) ->
        $.extend(model_attrs, {target_uuid: box_template_info.target_uuid})
        box = new App.Box(model_attrs)

        box.append_to_page()

      #setup for box_line_items
      box_line_item_template_info = App.Template.template_info["box_line_item"]
      App.BoxLineItem.set_template box_line_item_template_info.template

      $(box_line_item_template_info.collection).each (i, model_attrs) ->
        # TODO abstract to kindred
        # gets the uuid of the parent box for the target
        box_id = model_attrs["box_id"]
        box_uuid = $("[data-kindred-model]").find("[data-class='box'][data-id='" + box_id + "']").data("k-uuid")

        $.extend(model_attrs, {target_uuid: box_uuid, box_id: box_id})
        box_line_item = new App.BoxLineItem(model_attrs)

        box_line_item.append_to_page()
