#import "main.h"
#import <PromiseKit.h>
#import <AVFoundation/AVSpeechSynthesis.h>

static AVSpeechSynthesizer *synth;

@implementation SPAnnounce

+ (void)load {
    [NSNotificationCenter once:UIApplicationDidFinishLaunchingNotification].then(^{
        synth = [AVSpeechSynthesizer new];
    });
}

+ (void)weapon:(WeaponIdentifier)weapon {
    NSString *speak;

    switch (weapon) {
        case Rockets:
            speak = @"rockets";
            break;
        case Sniper:
            speak = @"sniper";
            break;
        case Overshield:
            speak = @"over shield";
            break;
        case Naked:
            speak = @"naked";
            break;
    }

    AVSpeechUtterance *utter = [AVSpeechUtterance speechUtteranceWithString:speak];

    [synth speakUtterance:utter];
}

+ (void)count:(NSNumber *)count {
    if (!synth.speaking) {
        AVSpeechUtterance *utter = [AVSpeechUtterance speechUtteranceWithString:count.stringValue];
        [synth speakUtterance:utter];
    }
}

@end