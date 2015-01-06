class App.BoxLineItem extends App.Base
  @route = "box_line_items"
  @set_class_name("BoxLineItem")

  @save_all: (opts) ->
    data = {}
    # TODO fix the naive inflection
    collection = @collection_from_page(@snake_name)
    added_attrs = []

    deletable_box_ids = $("input[data-attr='delete_box']").map ->
      $(@).val()

    $.each collection, (i, attrs) ->
      added_attrs.push($.extend attrs, opts.add_data_to_each)

    data[@snake_name + "s"] = added_attrs
    data["deletable_box_ids"] = deletable_box_ids.toArray()


    url_match = new RegExp(/{{([^{}]+)}}/g)
    @route = @route.replace(url_match, (match, p1) =>
      attribute = match.slice(2, - 2)
      opts.add_data_to_each[attribute]
    )

    path = @route + "/save_all.json"
    method = 'PUT'

    $.ajax
      type: method
      url: App.BaseUrl + "/" + path
      data: data

      success: (data, textStatus, xhr) =>
        @after_save_all(data, textStatus, xhr)
      error: (xhr) =>
        @after_save_all_error(xhr)

  @after_save_all: (data, textStatus, xhr) ->
    # $alert = ajaxLoad 'Saving Line Items...'
    deletable_box_ids = data["removed_box_uuids"]
    box_line_items = data["box_line_items"]
    $(box_line_items).each (i, response_object) =>
      attrs = response_object[@snake_name]
      model = new App[@class_name]({uuid: attrs["uuid"]})

      if attrs.remove == true
        $(".remove-box-li[data-k-uuid='" + model.uuid + "']").parents("tr").remove()
      else
        model = new App[@class_name]({uuid: attrs["uuid"]})
        model.assign_attributes(attrs)
        model._clear_errors()
        model._update_data_vals_on_page()

    $(deletable_box_ids).each (i, uuid) ->
      $("fieldset[data-k-uuid='" + uuid + "']").remove()
    # ajaxDone $alert, 'Save all successful.', 'success'

  @after_save_all_error: (xhr) ->
    # $alert = ajaxLoad 'Saving Line Items...'
    data = JSON.parse(xhr.responseText)
    box_line_items = data["box_line_items"]
    $(box_line_items).each (i, response_object) =>
      model = new App[@class_name](response_object[@snake_name])

      uuid = response_object[@snake_name].uuid
      model.assign_attributes_from_page()
      model._handle_errors(response_object["errors"])
    # ajaxDone $alert, 'Save all failed.', 'fail'
