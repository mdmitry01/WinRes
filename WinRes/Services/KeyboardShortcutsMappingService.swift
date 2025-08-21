import Carbon.HIToolbox

enum KeyboardShortcutsMappingServiceError: Error {
    case invalidKeyCharacter
}

class KeyboardShortcutsMappingService {
    private static func getEventFlags(model: MapKeyboardShortcutsModel) -> CGEventFlags {
        var flags: CGEventFlags = [];
        if (model.includesControlModifier) {
            flags.insert(.maskControl);
        }
        if (model.includesOptionModifier) {
            flags.insert(.maskAlternate);
        }
        if (model.includesCommandModifier) {
            flags.insert(.maskCommand);
        }
        if (model.includesShiftModifier) {
            flags.insert(.maskShift);
        }
        
        return flags
    }
    
    public static func pressKey(model: MapKeyboardShortcutsModel) throws -> Void {
        guard let firstChar = model.keyCharacter.first else {
            throw KeyboardShortcutsMappingServiceError.invalidKeyCharacter
        }
        guard let keyCode = self.getKeyCodeFromCharacter(firstChar) else {
            throw KeyboardShortcutsMappingServiceError.invalidKeyCharacter
        }
        try Utils.pressKey(
            keyCode: UInt16(keyCode),
            flags: self.getEventFlags(model: model),
        )
    }

    // based on https://github.com/JetBrains/jcef/blob/8c4b81a83c72d6257061509c00f3f0484388f731/remote/browser/KeyEventProcessing.cpp#L242
    private static func getKeyCodeFromCharacter(_ character: Character) -> Int? {
        switch (character.lowercased()) {
        case " ":
            return kVK_Space;
        case "\n":
            return kVK_Return;
            
        case "0":
            return kVK_ANSI_0;
        case "1":
            return kVK_ANSI_1;
        case "2":
            return kVK_ANSI_2;
        case "3":
            return kVK_ANSI_3;
        case "4":
            return kVK_ANSI_4;
        case "5":
            return kVK_ANSI_5;
        case "6":
            return kVK_ANSI_6;
        case "7":
            return kVK_ANSI_7;
        case "8":
            return kVK_ANSI_8;
        case "9":
            return kVK_ANSI_9;
            
        case "a":
            return kVK_ANSI_A;
        case "b":
            return kVK_ANSI_B;
        case "c":
            return kVK_ANSI_C;
        case "d":
            return kVK_ANSI_D;
        case "e":
            return kVK_ANSI_E;
        case "f":
            return kVK_ANSI_F;
        case "g":
            return kVK_ANSI_G;
        case "h":
            return kVK_ANSI_H;
        case "i":
            return kVK_ANSI_I;
        case "j":
            return kVK_ANSI_J;
        case "k":
            return kVK_ANSI_K;
        case "l":
            return kVK_ANSI_L;
        case "m":
            return kVK_ANSI_M;
        case "n":
            return kVK_ANSI_N;
        case "o":
            return kVK_ANSI_O;
        case "p":
            return kVK_ANSI_P;
        case "q":
            return kVK_ANSI_Q;
        case "r":
            return kVK_ANSI_R;
        case "s":
            return kVK_ANSI_S;
        case "t":
            return kVK_ANSI_T;
        case "u":
            return kVK_ANSI_U;
        case "v":
            return kVK_ANSI_V;
        case "w":
            return kVK_ANSI_W;
        case "x":
            return kVK_ANSI_X;
        case "y":
            return kVK_ANSI_Y;
        case "z":
            return kVK_ANSI_Z;

        case ";":
            return kVK_ANSI_Semicolon;
        case "=":
            return kVK_ANSI_Equal;
        case ",":
            return kVK_ANSI_Comma;
        case "-":
            return kVK_ANSI_Minus;
        case ".":
            return kVK_ANSI_Period;
        case "/":
            return kVK_ANSI_Slash;
        case "`":
            return kVK_ANSI_Grave;
        case "[":
            return kVK_ANSI_LeftBracket;
        case "\\":
            return kVK_ANSI_Backslash;
        case "]":
            return kVK_ANSI_RightBracket;
        case "'":
            return kVK_ANSI_Quote;
        default:
            return nil
        }
    }
}
