import Foundation
import Orion

// The fade engine reads crossfade-enable from the persisted prefs; the duration
// slider writes setAudioCrossfadeTime: but never flips audioCrossfade, so it
// stays disabled (gapless). Keep the enable bool in sync with the duration.

struct EeveeCrossfadePrefGroup: HookGroup {}

class PreferencesCrossfadeHook: ClassHook<NSObject> {
    typealias Group = EeveeCrossfadePrefGroup
    static let targetName = "_TtC31Preferences_CorePreferencesImpl28SPTPreferencesImplementation"

    func setAudioCrossfadeTime(_ value: Int) {
        NSLog("[EeveeSpotify][Crossfade] setAudioCrossfadeTime: %d", value)
        orig.setAudioCrossfadeTime(value)
        orig.setAudioCrossfade(value > 0)
    }

    // Passthrough; declared so orig.setAudioCrossfade is callable above.
    func setAudioCrossfade(_ value: Bool) {
        NSLog("[EeveeSpotify][Crossfade] setAudioCrossfade: %d", value ? 1 : 0)
        orig.setAudioCrossfade(value)
    }
}

func activateEeveeCrossfadeForce() {
    let targetClass = "_TtC31Preferences_CorePreferencesImpl28SPTPreferencesImplementation"
    if NSClassFromString(targetClass) != nil {
        NSLog("[EeveeSpotify][Crossfade] Activating hook for %@", targetClass)
        EeveeCrossfadePrefGroup().activate()
    } else {
        NSLog("[EeveeSpotify][Crossfade] Target class %@ not found – skipping hook", targetClass)
    }
}
