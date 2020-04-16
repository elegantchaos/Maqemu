// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 16/04/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

/**
 *    These constants are the virtual keycodes defined originally in
 *    Inside Mac Volume V, pg. V-191. They identify physical keys on a
 *    keyboard.
 *    For example, kVK_ANSI_A indicates the virtual keycode for the key
 *    with the letter 'A' in the US keyboard layout. Other keyboard
 *    layouts may have the 'A' key label on a different physical key;
 *    in this case, pressing 'A' will generate a different virtual
 *    keycode.
 */

public extension UInt16 {
    /* keycodes labeled according to the key position on an ANSI-standard US keyboard */
    static var keyA: UInt16 { return 0x00 }
    static var keyS: UInt16 { return 0x01 }
    static var keyD: UInt16 { return 0x02 }
    static var keyF: UInt16 { return 0x03 }
    static var keyH: UInt16 { return 0x04 }
    static var keyG: UInt16 { return 0x05 }
    static var keyZ: UInt16 { return 0x06 }
    static var keyX: UInt16 { return 0x07 }
    static var keyC: UInt16 { return 0x08 }
    static var keyV: UInt16 { return 0x09 }
    static var keyB: UInt16 { return 0x0B }
    static var keyQ: UInt16 { return 0x0C }
    static var keyW: UInt16 { return 0x0D }
    static var keyE: UInt16 { return 0x0E }
    static var keyR: UInt16 { return 0x0F }
    static var keyY: UInt16 { return 0x10 }
    static var keyT: UInt16 { return 0x11 }
    static var key1: UInt16 { return 0x12 }
    static var key2: UInt16 { return 0x13 }
    static var key3: UInt16 { return 0x14 }
    static var key4: UInt16 { return 0x15 }
    static var key6: UInt16 { return 0x16 }
    static var key5: UInt16 { return 0x17 }
    static var keyEqual: UInt16 { return 0x18 }
    static var key9: UInt16 { return 0x19 }
    static var key7: UInt16 { return 0x1A }
    static var keyMinus: UInt16 { return 0x1B }
    static var key8: UInt16 { return 0x1C }
    static var key0: UInt16 { return 0x1D }
    static var keyRightBracket: UInt16 { return 0x1E }
    static var keyO: UInt16 { return 0x1F }
    static var keyU: UInt16 { return 0x20 }
    static var keyLeftBracket: UInt16 { return 0x21 }
    static var keyI: UInt16 { return 0x22 }
    static var keyP: UInt16 { return 0x23 }
    static var keyL: UInt16 { return 0x25 }
    static var keyJ: UInt16 { return 0x26 }
    static var keyQuote: UInt16 { return 0x27 }
    static var keyK: UInt16 { return 0x28 }
    static var keySemicolon: UInt16 { return 0x29 }
    static var keyBackslash: UInt16 { return 0x2A }
    static var keyComma: UInt16 { return 0x2B }
    static var keySlash: UInt16 { return 0x2C }
    static var keyN: UInt16 { return 0x2D }
    static var keyM: UInt16 { return 0x2E }
    static var keyPeriod: UInt16 { return 0x2F }
    static var keyGrave: UInt16 { return 0x32 }
    static var keyKeypadDecimal: UInt16 { return 0x41 }
    static var keyKeypadMultiply: UInt16 { return 0x43 }
    static var keyKeypadPlus: UInt16 { return 0x45 }
    static var keyKeypadClear: UInt16 { return 0x47 }
    static var keyKeypadDivide: UInt16 { return 0x4B }
    static var keyKeypadEnter: UInt16 { return 0x4C }
    static var keyKeypadMinus: UInt16 { return 0x4E }
    static var keyKeypadEquals: UInt16 { return 0x51 }
    static var keyKeypad0: UInt16 { return 0x52 }
    static var keyKeypad1: UInt16 { return 0x53 }
    static var keyKeypad2: UInt16 { return 0x54 }
    static var keyKeypad3: UInt16 { return 0x55 }
    static var keyKeypad4: UInt16 { return 0x56 }
    static var keyKeypad5: UInt16 { return 0x57 }
    static var keyKeypad6: UInt16 { return 0x58 }
    static var keyKeypad7: UInt16 { return 0x59 }
    static var keyKeypad8: UInt16 { return 0x5B }
    static var keyKeypad9: UInt16 { return 0x5C }
    
    /* keycodes for keys that are independent of keyboard layout*/
    static var keyReturn: UInt16 { return 0x24 }
    static var keyTab: UInt16 { return 0x30 }
    static var keySpace: UInt16 { return 0x31 }
    static var keyDelete: UInt16 { return 0x33 }
    static var keyEscape: UInt16 { return 0x35 }
    static var keyCommand: UInt16 { return 0x37 }
    static var keyShift: UInt16 { return 0x38 }
    static var keyCapsLock: UInt16 { return 0x39 }
    static var keyOption: UInt16 { return 0x3A }
    static var keyControl: UInt16 { return 0x3B }
    static var keyRightShift: UInt16 { return 0x3C }
    static var keyRightOption: UInt16 { return 0x3D }
    static var keyRightControl: UInt16 { return 0x3E }
    static var keyFunction: UInt16 { return 0x3F }
    static var keyF17: UInt16 { return 0x40 }
    static var keyVolumeUp: UInt16 { return 0x48 }
    static var keyVolumeDown: UInt16 { return 0x49 }
    static var keyMute: UInt16 { return 0x4A }
    static var keyF18: UInt16 { return 0x4F }
    static var keyF19: UInt16 { return 0x50 }
    static var keyF20: UInt16 { return 0x5A }
    static var keyF5: UInt16 { return 0x60 }
    static var keyF6: UInt16 { return 0x61 }
    static var keyF7: UInt16 { return 0x62 }
    static var keyF3: UInt16 { return 0x63 }
    static var keyF8: UInt16 { return 0x64 }
    static var keyF9: UInt16 { return 0x65 }
    static var keyF11: UInt16 { return 0x67 }
    static var keyF13: UInt16 { return 0x69 }
    static var keyF16: UInt16 { return 0x6A }
    static var keyF14: UInt16 { return 0x6B }
    static var keyF10: UInt16 { return 0x6D }
    static var keyF12: UInt16 { return 0x6F }
    static var keyF15: UInt16 { return 0x71 }
    static var keyHelp: UInt16 { return 0x72 }
    static var keyHome: UInt16 { return 0x73 }
    static var keyPageUp: UInt16 { return 0x74 }
    static var keyForwardDelete: UInt16 { return 0x75 }
    static var keyF4: UInt16 { return 0x76 }
    static var keyEnd: UInt16 { return 0x77 }
    static var keyF2: UInt16 { return 0x78 }
    static var keyPageDown: UInt16 { return 0x79 }
    static var keyF1: UInt16 { return 0x7A }
    static var keyLeftArrow: UInt16 { return 0x7B }
    static var keyRightArrow: UInt16 { return 0x7C }
    static var keyDownArrow: UInt16 { return 0x7D }
    static var keyUpArrow: UInt16 { return 0x7E }
    
    /* ISO keyboards only*/
    static var keyISO_Section: UInt16 { return 0x0A }
    
    /* JIS keyboards only*/
    static var keyJIS_Yen: UInt16 { return 0x5D }
    static var keyJIS_Underscore: UInt16 { return 0x5E }
    static var keyJIS_KeypadComma: UInt16 { return 0x5F }
    static var keyJIS_Eisu: UInt16 { return 0x66 }
    static var keyJIS_Kana                  = 0x68
}
