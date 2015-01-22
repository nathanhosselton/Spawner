#import <AVFoundation/AVSpeechSynthesis.h>

@implementation AVSpeechSynthesizer (SPAnnounce)

- (void)say:(NSString *)speech {
//TODO: Create custom utterance with app standards and user defaults
    AVSpeechUtterance *utter = [AVSpeechUtterance speechUtteranceWithString:speech];

    [self speakUtterance:utter];
}

@end



#import "main.h"
#import <PromiseKit.h>

static AVSpeechSynthesizer *announcer;

@implementation SPAnnounce

+ (void)load {
    [NSNotificationCenter once:UIApplicationDidFinishLaunchingNotification].then(^{
        announcer = [AVSpeechSynthesizer new];
    });
}

+ (void)weapon:(WeaponIdentifier)weapon {
    NSString *speech;

    switch (weapon) {
        case Rockets:
            speech = @"rockets";
            break;
        case Sniper:
            speech = @"sniper";
            break;
        case Overshield:
            speech = @"over shield";
            break;
        case Naked:
            speech = @"naked";
            break;
    }

    [announcer say:speech];
}

+ (void)count:(NSNumber *)count {
    if (![announcer isSpeaking])
        [announcer say:count.stringValue];
}

@end