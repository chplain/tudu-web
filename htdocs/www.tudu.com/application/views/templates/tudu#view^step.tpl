{{strip}}
<div id="tudu-flow" class="grid_list_wrap grid_list_group" style="margin:-7px 0 10px; 0">
    <div class="grid_list_title" style="line-height:24px" id="toggle-flow">
        <span class="icon icon_elbow_minus toggle_flow" style="cursor:pointer;"></span><h3>{{$LANG.tudu_flow}}</h3>
    </div>
    <div id="step-list" class="grid_list_group_ct grid_list_btm_line flow_group" style="padding:4px 5px;">
        <span class="step_item" title="{{$tudu.from.0}}"{{if $tudu.stepid == '^head' || $tudu.stepid == '^break'}} style="font-weight:bold;"{{/if}}>{{$tudu.from.0}}</span>
        {{strip}}
        {{foreach from=$steps name=step item=item}}
        {{assign var=pidx value=null}}
        {{if $item.type == 1}}
        {{foreach from=$item.users item=u}}
        <span class="icon{{if $pidx != $u.processindex}} icon_flow_arrow{{else}} icon_flow_plus{{/if}}"></span>
        {{assign var=pidx value=$u.processindex}}
        {{if !$u.future || $u.status >= 2}}
        <a href="{{if $query.unid != $u.uniqueid}}/tudu/view?tid={{$tudu.tuduid}}&unid={{$u.uniqueid}}&back={{$query.back}}{{else}}/tudu/view?tid={{$tudu.tuduid}}{{/if}}" class="step_item{{if $query.unid == $u.uniqueid}} step_item_selected{{/if}}"{{if $u.stepid == $tudu.stepid && $u.status == 1}} style="font-weight:bold;"{{/if}}{{if $u.status > 2 && $query.unid != $u.uniqueid}} style="color:#c00"{{/if}} title="{{$u.truename}} {{if $u.status == 2}}{{$LANG.examine}}{{$LANG.agree}}{{elseif $u.status == 3}} {{$LANG.examine}}{{$LANG.disagree}}{{else}} {{$LANG.wait_review}}{{/if}}">
        {{$u.truename}}
        {{if $u.status == 2}}({{$LANG.agree}}){{elseif $u.status == 3}}({{$LANG.disagree}}){{else}}({{$LANG.wait_review}}){{/if}}
        </a>
        {{else}}
        <span class="step_item" style="color:#999">{{$u.truename}}({{$LANG.future_review}})</span>
        {{/if}}
        {{/foreach}}
        {{else}}

        {{if count($item.users) > 1}}
        <span class="icon icon_flow_arrow"></span>
        {{if !$item.future}}
        <a href="javascript:void(0);" name="multi-accepter" class="step_item"{{if $item.status == 4 || $item.stepstatus == 4}} style="text-decoration:line-through"{{elseif $item.stepid == $tudu.stepid}} style="font-weight:bold;" _iscurrent="1"{{/if}} title="{{foreach from=$item.users name=stepuser item=user}}{{$user.truename}}{{if $smarty.foreach.stepuser.index < count($item.users) - 1}},{{/if}}{{/foreach}}" title="{{$LANG.multi_accepter}} {{$LANG.execute}}" _users="{{foreach from=$item.users name=stepuser item=user}}{{$user.uniqueid}} {{$user.truename}}{{if $smarty.foreach.stepuser.index < count($item.users) - 1}}#{{/if}}{{/foreach}}">
        {{$LANG.multi_accepter}}
        </a>
        {{else}}
        <span class="step_item" style="color:#999" title="{{foreach from=$item.users name=stepuser item=u}}{{if $u.uniqueid == $user.uniqueid}}{{$LANG.me}}{{else}}{{$u.truename}}{{/if}}{{if $smarty.foreach.stepuser.index < count($item.users) - 1}},{{/if}}{{/foreach}}">
        {{$LANG.multi_accepter}}
        </span>
        {{/if}}

        {{else}}
        {{if !$item.future}}
        <span class="icon icon_flow_arrow"></span>
        <a href="{{if $query.unid != $item.users.0.uniqueid}}/tudu/view?tid={{$tudu.tuduid}}&unid={{$item.users.0.uniqueid}}&back={{$query.back}}{{else}}/tudu/view?tid={{$tudu.tuduid}}{{/if}}" class="step_item{{if $query.unid == $item.users.0.uniqueid}} step_item_selected{{/if}}"{{if $item.users.0.stepid == $tudu.stepid}} style="font-weight:bold;"{{elseif $item.users.0.status == 4 || $item.users.0.stepstatus == 4}} style="text-decoration:line-through"{{/if}} title="{{$item.users.0.truename}} {{if $item.users.0.stepid == $tudu.stepid}}{{$tudu.percent|default:0}}%{{else}}{{$LANG.execute}}{{/if}}">
        {{$item.users.0.truename}}
        {{if $item.users.0.stepid == $tudu.stepid}}({{$item.users.0.percent|default:0}}%){{/if}}
        </a>
        {{else}}
        <span class="icon icon_flow_arrow"></span>
        <span class="step_item" style="color:#999">
        {{$item.users.0.truename}}
        {{if $item.users.0.stepid == $tudu.stepid}}({{$item.users.0.percent|default:0}}%){{/if}}
        </span>
        {{/if}}
        {{/if}}

        {{/if}}
        {{/foreach}}
        {{/strip}}
        {{if $tudu.type == 'notice'}}
        <span class="icon icon_flow_arrow"></span>
        <span class="step_item" style="{{if $tudu.stepid == '^end'}}color:#666;font-weight:bold;{{else}}color:#999;{{/if}}" title="{{foreach item=cc from=$tudu.cc name=cc}}{{if !$smarty.foreach.cc.first}},&#13;{{/if}}{{$cc.0}}{{if $cc.3}}<{{if strpos($cc.3, '@')}}{{$cc.3}}{{else}}{{$LANG.group}}{{/if}}>{{/if}}{{/foreach}}">
        {{foreach item=cc from=$tudu.cc name=cc}}{{if $smarty.foreach.cc.index < 6}}{{if $cc.3 == $user.username}}{{$LANG.me}}{{else}}{{$cc.0}}{{/if}}{{if $smarty.foreach.cc.index + 1 < count($tudu.cc)}},{{/if}}{{/if}}{{foreachelse}}-{{/foreach}}{{if $tudu.cc && count($tudu.cc) > 6}}...{{/if}}
        </span>
        {{/if}}
    </div>
</div>
{{/strip}}
<script type="text/javascript">
<!--
$('#toggle-flow span, #toggle-flow h3').click(function(){
    var ico = $('#toggle-flow span.icon');
    if (ico.hasClass('icon_elbow_minus')) {
        ico.removeClass('icon_elbow_minus').addClass('icon_elbow_plus');
    } else {
        ico.removeClass('icon_elbow_plus').addClass('icon_elbow_minus');
    }
    $('#step-list').toggle();
});

$('#step-list').bind('click', function(e){
    var el = e.srcElement ? $(e.srcElement) : $(e.target);
    if (el.is('a[name="multi-accepter"]')) {
        var showpercent = el.attr('_iscurrent') && $('#tudu-accepter').size(),
            mlist       = $('#multi-list'),
            users       = el.attr('_users');

        if (!el.hasClass('step_item_selected')) {
            if (users) {
                users = users.split('#');

                if (!mlist.size()) {
                    mlist = $('<div id="multi-list" class="drop-list"><ul></ul></div>').hide();
                    mlist.appendTo(document.body);
                }

                var ul = mlist.find('ul:eq(0)'),
                    li = [];

                ul.empty();
                for (var i = 0, c = users.length; i < c; i++) {
                    var u = users[i].split(' ', 2),
                        id = u[0], text = u[1];
                    if (showpercent && $('#accepter-' + id).size()) {
                        text = text + '&nbsp;(' + $('#accepter-' + id).attr('_percent') + '%)';
                    }

                    li.push('<li><a href="/tudu/view?tid={{$tudu.tuduid}}&unid='+id+'">'+text+'</a>');
                }

                ul.html(li.join(''));
            }

            var offset = el.offset();
            mlist.css({left: offset.left + 5 + 'px', top: offset.top + el.outerHeight() + 'px'}).show();

            el.addClass('step_item_selected');
        } else {
            if (mlist.size()) {
                mlist.hide();
            }

            el.removeClass('step_item_selected');
        }
    }

    TOP.stopEventBuddle(e);
});

$(document.body).bind('click', function(){
	$('#multi-list').hide();
});
-->
</script>