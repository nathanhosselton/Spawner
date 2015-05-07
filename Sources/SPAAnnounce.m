#import <AVFoundation/AVSpeechSynthesis.h>

@implementation AVSpeechSynthesizer (SPAnnounce)

- (void)say:(NSString *)speech {
//TODO: Create custom utterance with app standards and user defaults
    AVSpeechUtterance *utter = [AVSpeechUtterance speechUtteranceWithString:speech];

    [self speakUtterance:utter];
}

@end



#import <PromiseKit.h>

static AVSpeechSynthesizer *announcer;

@implementation SPAAnnounce

+ (void)load {
    [NSNotificationCenter once:UIApplicationDidFinishLaunchingNotification].then(^{
        announcer = [AVSpeechSynthesizer new];
    });
}

+ (void):(NSString *)line {
    [announcer say:line];
}

+ (void)weapon:(WeaponIdentifier)weapon {
    NSString *line;

    switch (weapon) {
        case Rockets:
            line = @"rockets";
            break;
        case Sniper:
            line = @"sniper";
            break;
        case Overshield:
            line = @"over shield";
            break;
        case Naked:
            line = @"naked";
            break;
    }

    [announcer say:line];
}

+ (void)count:(NSNumber *)count {
    if (![announcer isSpeaking])
        [announcer say:count.stringValue];
}

@end