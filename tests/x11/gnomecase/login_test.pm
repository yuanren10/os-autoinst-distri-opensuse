# SUSE's openQA tests
#
# Copyright © 2016-2017 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# Summary: testcase 5255-1503905: Gnome:gnome-login test
#   other login scenario has been coverred by the change_password
#   script, here only cover the auto_login
# Maintainer: xiaojun <xjin@suse.com>

use base "x11test";
use strict;
use testapi;
use power_action_utils 'power_action';
use version_utils qw(is_sle);

sub auto_login_alter {
    my ($self) = @_;
    $self->unlock_user_settings;
    send_key "alt-u" unless check_screen('Automatic_Login_Opened', 0);
    send_key "alt-f4";
}

sub run {
    my ($self) = @_;

    assert_screen "generic-desktop";
    $self->auto_login_alter;
    my $ov = get_var('NOAUTOLOGIN');
    set_var('NOAUTOLOGIN', '');
    if (is_sle) {
        power_action('reboot');
    }
    else {
        power_action('reboot', keepconsole => 1);
    }
    $self->wait_boot(bootloader_time => 300);
    set_var('NOAUTOLOGIN', $ov);
    $self->auto_login_alter;
}

1;
