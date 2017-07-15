package Lingua::Config;

use strict;
use warnings;

use File::Spec;
use File::Basename;
use Config::General;

BEGIN {

    my $config_dir     = dirname(__FILE__);
    my $config_file    = File::Spec->catfile($config_dir, 'config');
    my $conf           = Config::General->new(
                            -ConfigFile      => $config_file,
                            -InterPolateVars => 1,
                        );
    our %config        = $conf->getall;
    $config{'jvm-share'} = $ENV{MOD_PERL} ? $config{'mod-perl-jvm'} : $config{'local-jvm'};
    $config{'jvm-dir'}   = $ENV{MOD_PERL} ? $config{'mod-perl-java'} : $config{'local-java'};
}

1;
