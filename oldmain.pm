# Copyright 2014-2018 SUSE LLC
# SPDX-License-Identifier: GPL-2.0-or-later


use Mojo::Base -strict;
use testapi;
use autotest;

sub load_boot_tests_oes{
    if (get_var("ISO_MAXSIZE")){
        
        autotest::loadtest 'tests/isosize.pm';
    }
    }

## INSTALLATION
sub load_inst_tests_oes{
    autotest::loadtest 'tests/welcome.pm';
   
    }
    
    if (get_var("INSTALL")){
     if (!get_var("AUTOYAST")){
        # Default Installation
        load_boot_tests_oes;
        load_inst_tests_oes;
        
        }
        }


1;
