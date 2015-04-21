//
//  THSegmentedPagerTests.m
//  THSegmentedPagerExample
//
//  Created by Victor Ilyukevich on 4/18/15.
//  Copyright (c) 2015 3Bus. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <FBSnapshotTestCase/FBSnapshotTestCase.h>
#import <Expecta+Snapshots/EXPMatchers+FBSnapshotTest.h>
#import "THSegmentedPager.h"

void TriggerViewAppearing(UIViewController *controller);

SpecBegin(THSegmentedPager)

__block THSegmentedPager *subject;

beforeEach(^{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle bundleForClass:self.class]];
    subject = [storyboard instantiateInitialViewController];
});

it(@"can load and then add pages from Storyboard", ^{
    expect(subject.pages.count).to.equal(0);
    [subject setupPagesFromStoryboardWithIdentifiers:@[@"Foo", @"Bar"]];
    expect(subject.pages.count).to.equal(2);
    [subject setupPagesFromStoryboardWithIdentifiers:@[@"Baz"]];
    expect(subject.pages.count).to.equal(3);

    TriggerViewAppearing(subject);
    expect(subject.pageControl.sectionTitles).to.equal(@[@"Foo", @"Bar", @"Baz"]);
});

context(@"with one page", ^{
    beforeEach(^{
        [subject setupPagesFromStoryboardWithIdentifiers:@[@"Baz"]];
        TriggerViewAppearing(subject);
    });
    it(@"is selected by default", ^{
        expect(subject.selectedController.title).to.equal(@"Baz");
    });
    it(@"looks good", ^{
        expect(subject).to.haveValidSnapshot();
    });
});

context(@"with Foo, Bar, Baz pages", ^{
    beforeEach(^{
        [subject setupPagesFromStoryboardWithIdentifiers:@[@"Foo", @"Bar", @"Baz"]];
        TriggerViewAppearing(subject);
    });

    it(@"has Foo selected by default as the first page", ^{
        expect(subject.selectedController.title).to.equal(@"Foo");
    });

    it(@"looks good", ^{
        expect(subject).to.haveValidSnapshot();
    });

    context(@"when Bar is selected", ^{
        beforeEach(^{
            [subject setSelectedPageIndex:1 animated:NO];
        });

        it(@"has Bar selected", ^{
            expect(subject.selectedController.title).to.equal(@"Bar");
        });

        it(@"looks good", ^{
            expect(subject).to.haveValidSnapshot();
        });
    });
});

SpecEnd

void TriggerViewAppearing(UIViewController *controller)
{
    [controller beginAppearanceTransition:YES animated:NO];
    [controller.view setNeedsUpdateConstraints];
    [controller endAppearanceTransition];
}
