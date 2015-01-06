class App.BoxListeners extends App.Listener

  @set: ->

    $("#boxes").on "click.Listeners.Box.new", ".new-box", (evt) =>
      evt.preventDefault()
      box = new App.Box(@params $(evt.target).data())
      box.save()
      box.append_to_page()

    $("#boxes").on "click.Listeners.Box.delete", ".delete-box", (evt) =>
      evt.preventDefault()
      box = new App.Box(@params $(evt.target).data())
      box.assign_attributes_from_page()
      unless box.id?
        $(".delete-box[data-k-uuid='" + box.uuid + "']").parents("tr").remove()
      App.BoxHelpers.toggle_box_remove(@, evt)

    $("#boxes").on "click.Listeners.Box.add-back", ".add-box-back", (evt) =>
      evt.preventDefault()
      App.BoxHelpers.toggle_box_remove(@, evt)

    $("#boxes").on "click.Listeners.BoxLineItem.new", ".new-box-line-item", (evt) =>
      evt.preventDefault()
      box_line_item = new App.BoxLineItem(@params $(evt.target).data())
      box_line_item.append_to_page()

    $("#boxes").on "click.Listeners.BoxLineItem.delete", ".remove-box-li", (evt) =>
      evt.preventDefault()
      box_li = new App.BoxLineItem(_this.params $(evt.target).data())
      box_li.assign_attributes_from_page()
      unless box_li.id?
        $(".remove-box-li[data-k-uuid='" + box_li.uuid + "']").parents("tr").remove()
      App.BoxHelpers.toggle_row_remove(@, evt)

    $("#boxes").on "click.Listeners.BoxLineItem.add-back", ".add-box-li-back", (evt) =>
      evt.preventDefault()
      App.BoxHelpers.toggle_row_remove(@, evt)

    $("#boxes").on "click.Listeners.BoxLineItem.save_all", "#box-line-items-save-all", (evt) ->
      evt.preventDefault()
      App.BoxLineItem.save_all({
        add_data_to_each: {invoice_id: $(@).data("invoice-id")}
      })

    $("#boxes").on "change.Listeners.BoxLineItem.li_change", ".box-li-select", (evt) =>
      params = $(evt.target).data()
      $.extend params, JSON.parse($(evt.target).val())
      box_li = new App.BoxLineItem(@params params)
      box_li.update_vals_on_page()

