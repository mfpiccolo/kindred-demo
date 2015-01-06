class App.BoxHelpers

  @toggle_box_remove: (_this, evt) ->
    # visual
    box_elem = $(evt.target).closest("fieldset")
    box_elem.toggleClass("flag-remove")
    box_elem.find("a.box-level").toggleClass("hide")

    # # data
    box = new App.Box(_this.params $(evt.target).data())

    delete_input = $("input[data-attr='delete_box'][data-k-uuid='" + box.uuid + "']")
    box.assign_attributes_from_page()
    if box_elem.hasClass("flag-remove")
      delete_input.val(box.id)
    else
      delete_input.val("")

  @toggle_row_remove: (_this, evt) ->
    # visual
    row = $(evt.target).parents("tr")
    row.toggleClass("flag-remove")
    row.find("input, select").prop("disabled", !row.find("input, select").prop("disabled"))
    row.find("a").toggleClass("hide")

    # data
    box_li = new App.BoxLineItem(_this.params $(evt.target).data())
    box_li.assign_attributes_from_page()
    if row.hasClass("flag-remove")
      box_li.set("delete", "true")
    else
      box_li.remove("delete")
    box_li.update_vals_on_page()
