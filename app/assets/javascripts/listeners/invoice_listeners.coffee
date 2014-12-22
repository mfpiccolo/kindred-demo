class App.InvoiceListeners extends App.Listener

  @set: ->
    $("#line-item-table").on "click.Listeners.LineItem.save", ".persist", (evt) =>
      console.log @params $(evt.toElement).data()
      li = new App.LineItem(@params $(evt.toElement).data())
      li.assign_attributes_from_page()
      li.save()
      li.mark_dirty_or_clean()

    $("#line-item-table").on "click.Listeners.LineItem.delete", ".delete", (evt) ->
      li = new App.LineItem({id: $(@).data("id"), uuid: $(@).data("k-uuid")})
      li.destroy()
      $(@).parent().parent().remove()

    $("#line-item-buttons").on "click.Listeners.LineItem.new_li", "#new-line-item", (evt) =>
      li = new App.LineItem(@params $(evt.toElement).data())
      li.append_to_page()
      li.mark_dirty_or_clean()

    $("#line-item-table").on "keyup.Listeners.LineItem.dirty_input", "input[data-k-uuid]", (evt) ->
      App.LineItemsHelper.mark_li_dirty_or_clean(@)

    $("#line-item-table").on "change.Listeners.LineItem.dirty_checkbox", "[data-k-uuid]", (evt) ->
      App.LineItemsHelper.mark_li_dirty_or_clean(@)

    $("#line-item-buttons").on "click.Listeners.LineItem.save_all", "#line-items-save-all", (evt) ->
      evt.preventDefault()
      App.LineItem.save_all({
        add_data_to_each: {invoice_id: $(@).data("invoice-id")}
      })

    $(".show-code").on "click.Listeners.LineItem.show_code", "#show-code-link", (evt) ->
      $(".show-code").hide()
      $(".hide-code").show()
      $(".content").addClass("pane")
      $(".content").show()

    $(".hide-code").on "click.Listeners.LineItem.hide-code", "#hide-code-link", (evt) ->
      $(".show-code").show()
      $(".hide-code").hide()
      $(".content").removeClass("pane")
      $(".code").hide()

