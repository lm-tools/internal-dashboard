class Dashing.Statuscake extends Dashing.Widget

  ready: ->
    super

  onData: (data) ->
    node = $(@node)
    status = data.overall_status
    node.removeClass (index, css) ->
      (css.match(/(^|\s)status-\S+/g) or []).join ' '
    node.addClass "status-#{status}"
