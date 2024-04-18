# Copyright 2014-2018 SUSE LLC
# SPDX-License-Identifier: GPL-2.0-or-later


use Mojo::Base -strict;
use testapi;
use autotest;

sub load_boot_tests_oes{
    if (get_var("ISO_MAXSIZE")){
        loadtest "tests/isosize.pm";
    }
    }
     if (get_var("INSTALL")){
            # Default Installation
            load_boot_tests_oes;
            }


1;
