use Test;

use Project::Issue;
use Project::Milestone;
use Project;

constant $project-name = "Foo";
my $issue-id = 1;

my $p = Project.new( :$project-name );
for 1..2 -> $m {
    my $milestone = Project::Milestone.new(:$project-name,:milestone-id($m));
    for (Open,Closed) -> $state {
        my $issue = Project::Issue.new( :$project-name, :$issue-id );
        $issue.close() if $state == Closed;
        $milestone.new-issue( $issue );
        $issue-id++;
    }
    $p.new-milestone( $milestone );
    is( $p.milestones.keys.elems, $m, "Correct number of milestones added");
    is( $p.percentage-completed(){$m}, 0.5, "Percentaje completed is correct")
}

my $summary = $p.completion-summary();
isa-ok( $summary, List, "Returns a hash");
isa-ok( $summary[0]<mean>, 0.5, "Returns correct average");


throws-like {
    $p.new-milestone(
            Project::Milestone.new( :project-name("Bar"), :milestone-id(33) )
            );
}, X::TypeCheck::Binding::Parameter, "Can't add milestone of another project";

done-testing;
