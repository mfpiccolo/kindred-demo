class App.LineItem extends App.Base

  @route = "/line_items"
  @set_class_name("LineItem")

  # kindred override hook
  after_destroy: (data, textStatus, xhr) ->
    $("[data-error][data-k-uuid='" + @uuid + "']").parent().parent().remove()

  @after_save_all: (data, textStatus, xhr) ->
    $(data).each (i, response_object) =>
      attrs = response_object[@snake_name]
      model = new App[@class_name]({uuid: attrs["uuid"]})
      model.assign_attributes(attrs)
      model._clear_errors()
      model._update_data_vals_on_page()

      unless (userAgent = window?.navigator?.userAgent).match /capybara-webkit/ || userAgent.match /PhantomJS/
        # TODO this won't work with webkit
        model.mark_dirty_or_clean()

  mark_dirty_or_clean: =>
    if !@id?
      $("[data-k-uuid='" + @uuid + "'][data-dirty]").html("<div data-dirty='' data-k-uuid='" + @uuid + "'><i class='fa fa-exclamation-triangle fa-2x' style='color:#D24D57;'></i></div>")
    else if @dirty_from_page()
      $("[data-k-uuid='" + @uuid + "'][data-dirty]").html("<div data-dirty='' data-k-uuid='" + @uuid + "'><i class='fa fa-exclamation-triangle fa-2x' style='color:#F4D03F;'></i></div>")
    else
      $("[data-k-uuid='" + @uuid + "'][data-dirty]").html("<div data-dirty='' data-k-uuid='" + @uuid + "'><i class='fa fa-check-circle-o fa-2x' style='color:#2ECC71;'></i></div>")
