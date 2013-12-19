# -*- coding: utf-8 -*-
#
# Angelo "pallotron" Failla <pallotron@freaknet.org>
# License: GPL3
#
'''
Display Different TZ beside the local one in buffer messages.
'''
import weechat as w
import pytz
import datetime

SCRIPT_NAME    = "message_dual_tz"
SCRIPT_AUTHOR  = "Angelo 'pallotron' Failla <pallotron@freaknet.org>"
SCRIPT_VERSION = "0.1"
SCRIPT_LICENSE = "GPL3"
SCRIPT_DESC    = "Display Alternate Time from different TimeZone in buffers"

# script options
settings = {
    "timezone"       : 'US/Pacific',
    "timeformat"     : "%H:%M:%S %Z",
}

def get_time():
    tzname = w.config_get_plugin('timezone')
    tz = pytz.timezone(tzname)
    return datetime.datetime.now(tz).strftime(w.config_get_plugin('timeformat'))

def message_dual_tz_config_cb(*kwargs):
    tzname = w.config_get_plugin('timezone')
    tz = pytz.timezone(tzname)
    return datetime.datetime.now(tz).strftime(
        w.config_get_plugin('timeformat')
    )

def message_dual_prnt_hook(data, modifier, modifier_data, line):
    logtype = modifier_data.split(';')[-1].split(',')[-1]
    plugin = modifier_data.split(';')[0]
    if plugin != 'core' and not logtype.startswith('logger_backlog'):
        return "%s [%s]\t%s" % (
            line.split('\t')[0],
            get_time(),
            ''.join(line.split('\t')[1:])
        )
    else:
        return "%s" % line.strip()

if w.register(SCRIPT_NAME, SCRIPT_AUTHOR, SCRIPT_VERSION, SCRIPT_LICENSE,
                    SCRIPT_DESC, '', ''):
    for option, default_value in settings.iteritems():
        if not w.config_is_set_plugin(option):
            w.config_set_plugin(option, default_value)
    w.hook_modifier('weechat_print', 'message_dual_prnt_hook', '')
