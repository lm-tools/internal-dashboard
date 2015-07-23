class Dashing.Statuscake extends Dashing.Widget

  ready: ->
    super

  onData: (data) ->
    node = $(@node)
    status = data.overall_status
    node.removeClass (function (index, css) {
        return (css.match (/(^|\s)status-\S+/g) || []).join(' ');
    });
    node.addClass "status-#{status}"
