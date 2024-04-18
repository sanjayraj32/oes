use strict;
use testapi;

sub run {
    my $self   = shift;
    my $iso    = get_var("ISO");
    my $size   = -s $iso;
    my $result = 'ok';
    my $max    = get_var("ISO_MAXSIZE");
    if ($size > $max) {
        $result = 'fail';
    }
    bmwqemu::diag("Check if actual ISO size $size fits $max: $result");
    $self->result($result);
}

sub test_flags() {
    return { 'important' => 1 };
}
1;
