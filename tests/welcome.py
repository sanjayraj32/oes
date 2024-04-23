from testapi import *

# Define the variables
check_time = 50
timer = 0
maxtime = 2000 * get_var('TIMEOUT_SCALE', 1)

def switch_keyboard_layout():
    record_info('keyboard layout', 'Check keyboard layout switching to another language')
    keyboard_layout = get_var('INSTALL_KEYBOARD_LAYOUT')

    # Select the keyboard layout
    send_key('alt-k')
    send_key_until('keyboard-layout-{keyboard_layout}', 'down', timeout=60)

    if get_var('DESKTOP') == 'textmode':
        send_key('ret')
        assert_screen('keyboard-layout-{keyboard_layout}-selected')
        send_key('alt-e')  # Keyboard Test in text mode
    else:
        send_key('alt-y')  # Keyboard Test in graphic mode

        # Type "azerty" to test the keyboard layout
        type_string("azerty")
        assert_screen('keyboard-test-{keyboard_layout}')

        # Select back default keyboard layout
        send_key('alt-k')
        send_key_until_needlematch("keyboard-layout", 'up', 60)
    if get_var('DESKTOP') == 'textmode':
        wait_screen_change { send_key 'ret' } # Confirm selection in text mode

def run():
    mouse_hide()
    timeout = get_var("DEFAULT_TIMEOUT", 6)
    welcome_tags = ['beta-warning', 'welcome-agreement', 'linuxrc-install-error']
    check_screen(welcome_tags, check_time)  # Assuming check_time is defined elsewhere

    while not match_has_tag('welcome-agreement'):
        # Verify timeout and continue if there was a match
        if not verify_timeout_and_check_screen((timer += check_time), welcome_tags):
            continue

        if match_has_tag('beta-warning'):
            send_key('alt-o')

        if match_has_tag('linuxrc-install-error'):
            raise Exception("Installation media is not reachable or mismatch in ISO and Installation source")
    wait_still_screen(3)
    send_key('alt-a')
    assert_screen('welcome-agreement-accept', timeout)
    send_key('alt-n')
    if get_var('INSTALL_KEYBOARD_LAYOUT'):
        switch_keyboard_layout()
    if not has_license_on_welcome_screen():
        send_key('next')
