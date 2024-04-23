use Mojo::Base -strict;
use strict;
use testapi;
use lockapi;
use mmapi;
use warnings;
use version_utils qw(:VERSION :SCENARIO);
use Utils::Backends 'is_remote_backend';
 
my $check_time = 50;
my $timer = 0;
my $maxtime = 2000 * get_var('TIMEOUT_SCALE', 1);

sub switch_keyboard_layout {
    record_info 'keyboard layout', 'Check keyboard layout switching to another language';
    my $keyboard_layout = get_var('INSTALL_KEYBOARD_LAYOUT');
    # for instance, select france and test "querty"
    send_key 'alt-k';    # Keyboard Layout
    send_key_until_needlematch("keyboard-layout-$keyboard_layout", 'down', 60);
    if (check_var('DESKTOP', 'textmode')) {
        send_key 'ret';
        assert_screen "keyboard-layout-$keyboard_layout-selected";
        send_key 'alt-e';    # Keyboard Test in text mode
    }
    else {
        send_key 'alt-y';    # Keyboard Test in graphic mode
    }
    type_string "azerty";
    assert_screen "keyboard-test-$keyboard_layout";
    # Select back default keyboard layout
    send_key 'alt-k';
    send_key_until_needlematch("keyboard-layout", 'up', 60);
    wait_screen_change { send_key 'ret' } if (check_var('DESKTOP', 'textmode'));
}

 sub verify_timeout_and_check_screen {
    my ($timer, $needles) = @_;
    if ($timer > $maxtime) {
        #Try to assert_screen to explicitly show mismatching needles
        assert_screen $needles;
        #Die explicitly in case of infinite loop when we match some needle
        die "Timeout hit on during oes installation";
    }
    return check_screen $needles, $check_time;
}


sub run {
    my ($self) = @_;
    mouse_hide;
    my $timeout = get_var("DEFAULT_TIMEOUT", 6);
    my @welcome_tags = qw(beta-warning welcome-agreement linuxrc-install-error);   
    check_screen \@welcome_tags, $check_time;
    until (match_has_tag 'welcome-agreement') {
        # Verify timeout and continue if there was a match
        next unless verify_timeout_and_check_screen(($timer += $check_time), \@welcome_tags);
        if (match_has_tag 'beta-warning') {
            send_key 'alt-o';
        }
        if (match_has_tag 'linuxrc-install-error') {
            die "Installation media is not reachable or mismatch in ISO and Installation source";
        }
    }
    wait_still_screen(3);
    send_key 'alt-a'; 
    assert_screen "welcome-agreement-accept", $timeout;
    send_key 'alt-n';
    # Verify install arguments passed by bootloader
    # Linuxrc writes its settings in /etc/install.inf
    if (!is_remote_backend && get_var('VALIDATE_INST_SRC')) {
        # Ensure to have the focus in some non-selectable control, i.e.: Keyboard Test
        # before switching to console during installation
        wait_screen_change { send_key 'alt-y' };
        wait_screen_change { send_key 'ctrl-alt-shift-x' };
        my $method     = uc get_required_var('INSTALL_SOURCE');
        my $mirror_src = get_required_var("MIRROR_$method");
        my $rc         = script_run 'grep -o --color=always install=' . $mirror_src . ' /proc/cmdline';
        die "Install source mismatch in boot parameters!\n" unless ($rc == 0);
        $rc = script_run "grep --color=always -e \"^RepoURL: $mirror_src\" -e \"^ZyppRepoURL: $mirror_src\" /etc/install.inf";
        die "Install source mismatch in linuxrc settings!\n" unless ($rc == 0);
        wait_screen_change { send_key 'ctrl-d' };
        save_screenshot;
    }
    switch_keyboard_layout if get_var('INSTALL_KEYBOARD_LAYOUT');
    send_key $cmd{next} unless has_license_on_welcome_screen;
}
1;
# vim: set sw=4 et:
