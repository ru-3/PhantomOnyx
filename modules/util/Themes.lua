return {
    Themes = {
        Purple = {
            Body = Color3.fromRGB(10, 10, 10),
            Primary = Color3.fromRGB(5, 5, 5),
            Lit = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 20, 90)),
                ColorSequenceKeypoint.new(0.25, Color3.fromRGB(90, 40, 130)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60, 60, 160)),
                ColorSequenceKeypoint.new(0.75, Color3.fromRGB(40, 100, 190)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 140, 200))
            },
            TextColor = Color3.fromRGB(255, 255, 255),
            SubTextColor = Color3.fromRGB(200, 200, 200),
            ButtonGradient = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(190, 20, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(110, 10, 200))
            },
            Accent = Color3.fromRGB(192, 132, 252),
            AccentDark = Color3.fromRGB(139, 92, 246),
            AccentLight = Color3.fromRGB(216, 180, 254),
            HeaderBtn = Color3.fromRGB(160, 100, 240),
            DisplayName = "Purple",
            PreviewColors = {Color3.fromRGB(190, 20, 255), Color3.fromRGB(139, 92, 246), Color3.fromRGB(60, 20, 90)}
        },
        Crimson = {
            Body = Color3.fromRGB(10, 8, 8),
            Primary = Color3.fromRGB(6, 4, 4),
            Lit = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 10, 30)),
                ColorSequenceKeypoint.new(0.25, Color3.fromRGB(180, 20, 50)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 50, 80)),
                ColorSequenceKeypoint.new(0.75, Color3.fromRGB(220, 80, 60)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(240, 120, 80))
            },
            TextColor = Color3.fromRGB(255, 255, 255),
            SubTextColor = Color3.fromRGB(255, 200, 200),
            ButtonGradient = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 40, 80)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 10, 40))
            },
            Accent = Color3.fromRGB(252, 100, 132),
            AccentDark = Color3.fromRGB(180, 40, 80),
            AccentLight = Color3.fromRGB(255, 160, 180),
            HeaderBtn = Color3.fromRGB(220, 60, 100),
            DisplayName = "Crimson",
            PreviewColors = {Color3.fromRGB(220, 40, 80), Color3.fromRGB(180, 40, 80), Color3.fromRGB(120, 10, 30)}
        },
        Ocean = {
            Body = Color3.fromRGB(6, 10, 14),
            Primary = Color3.fromRGB(4, 8, 12),
            Lit = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 60, 100)),
                ColorSequenceKeypoint.new(0.25, Color3.fromRGB(20, 100, 150)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30, 150, 180)),
                ColorSequenceKeypoint.new(0.75, Color3.fromRGB(40, 180, 200)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 220, 230))
            },
            TextColor = Color3.fromRGB(220, 245, 255),
            SubTextColor = Color3.fromRGB(180, 230, 255),
            ButtonGradient = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 160, 220)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 80, 160))
            },
            Accent = Color3.fromRGB(80, 200, 240),
            AccentDark = Color3.fromRGB(30, 130, 200),
            AccentLight = Color3.fromRGB(140, 230, 255),
            HeaderBtn = Color3.fromRGB(40, 170, 220),
            DisplayName = "Ocean",
            PreviewColors = {Color3.fromRGB(30, 160, 220), Color3.fromRGB(30, 130, 200), Color3.fromRGB(10, 60, 100)}
        },
        Emerald = {
            Body = Color3.fromRGB(6, 11, 8),
            Primary = Color3.fromRGB(4, 8, 5),
            Lit = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 80, 40)),
                ColorSequenceKeypoint.new(0.25, Color3.fromRGB(20, 130, 70)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 170, 100)),
                ColorSequenceKeypoint.new(0.75, Color3.fromRGB(60, 200, 120)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 230, 150))
            },
            TextColor = Color3.fromRGB(220, 255, 230),
            SubTextColor = Color3.fromRGB(180, 240, 200),
            ButtonGradient = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 190, 100)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 110, 55))
            },
            Accent = Color3.fromRGB(80, 220, 130),
            AccentDark = Color3.fromRGB(30, 160, 85),
            AccentLight = Color3.fromRGB(140, 245, 180),
            HeaderBtn = Color3.fromRGB(50, 190, 110),
            DisplayName = "Emerald",
            PreviewColors = {Color3.fromRGB(40, 190, 100), Color3.fromRGB(30, 160, 85), Color3.fromRGB(10, 80, 40)}
        },
        Sunset = {
            Body = Color3.fromRGB(12, 9, 6),
            Primary = Color3.fromRGB(8, 6, 4),
            Lit = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(140, 50, 10)),
                ColorSequenceKeypoint.new(0.25, Color3.fromRGB(200, 90, 20)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(230, 140, 30)),
                ColorSequenceKeypoint.new(0.75, Color3.fromRGB(240, 180, 50)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 220, 80))
            },
            TextColor = Color3.fromRGB(255, 245, 220),
            SubTextColor = Color3.fromRGB(255, 220, 170),
            ButtonGradient = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(240, 140, 30)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 60, 10))
            },
            Accent = Color3.fromRGB(252, 180, 80),
            AccentDark = Color3.fromRGB(200, 110, 30),
            AccentLight = Color3.fromRGB(255, 220, 140),
            HeaderBtn = Color3.fromRGB(230, 150, 40),
            DisplayName = "Sunset",
            PreviewColors = {Color3.fromRGB(240, 140, 30), Color3.fromRGB(200, 110, 30), Color3.fromRGB(140, 50, 10)}
        },
        Rose = {
            Body = Color3.fromRGB(12, 7, 10),
            Primary = Color3.fromRGB(8, 4, 7),
            Lit = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 20, 80)),
                ColorSequenceKeypoint.new(0.25, Color3.fromRGB(190, 40, 120)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(225, 80, 150)),
                ColorSequenceKeypoint.new(0.75, Color3.fromRGB(240, 120, 170)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(250, 160, 200))
            },
            TextColor = Color3.fromRGB(255, 240, 248),
            SubTextColor = Color3.fromRGB(255, 205, 225),
            ButtonGradient = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(235, 70, 150)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 20, 90))
            },
            Accent = Color3.fromRGB(250, 130, 185),
            AccentDark = Color3.fromRGB(190, 50, 120),
            AccentLight = Color3.fromRGB(255, 185, 215),
            HeaderBtn = Color3.fromRGB(230, 90, 155),
            DisplayName = "Rose",
            PreviewColors = {Color3.fromRGB(235, 70, 150), Color3.fromRGB(190, 50, 120), Color3.fromRGB(130, 20, 80)}
        },
        Midnight = {
            Body = Color3.fromRGB(6, 7, 14),
            Primary = Color3.fromRGB(4, 5, 10),
            Lit = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 25, 90)),
                ColorSequenceKeypoint.new(0.25, Color3.fromRGB(35, 45, 140)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(55, 70, 180)),
                ColorSequenceKeypoint.new(0.75, Color3.fromRGB(80, 100, 210)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(110, 130, 235))
            },
            TextColor = Color3.fromRGB(230, 235, 255),
            SubTextColor = Color3.fromRGB(190, 200, 240),
            ButtonGradient = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 90, 220)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 40, 140))
            },
            Accent = Color3.fromRGB(120, 140, 250),
            AccentDark = Color3.fromRGB(55, 70, 180),
            AccentLight = Color3.fromRGB(170, 185, 255),
            HeaderBtn = Color3.fromRGB(80, 100, 215),
            DisplayName = "Midnight",
            PreviewColors = {Color3.fromRGB(70, 90, 220), Color3.fromRGB(55, 70, 180), Color3.fromRGB(20, 25, 90)}
        },
        Toxic = {
            Body = Color3.fromRGB(8, 11, 5),
            Primary = Color3.fromRGB(5, 8, 3),
            Lit = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 90, 10)),
                ColorSequenceKeypoint.new(0.25, Color3.fromRGB(90, 150, 20)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140, 200, 30)),
                ColorSequenceKeypoint.new(0.75, Color3.fromRGB(180, 230, 50)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 250, 90))
            },
            TextColor = Color3.fromRGB(240, 255, 220),
            SubTextColor = Color3.fromRGB(210, 240, 170),
            ButtonGradient = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 220, 30)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 130, 10))
            },
            Accent = Color3.fromRGB(190, 240, 60),
            AccentDark = Color3.fromRGB(110, 170, 25),
            AccentLight = Color3.fromRGB(225, 255, 130),
            HeaderBtn = Color3.fromRGB(150, 210, 40),
            DisplayName = "Toxic",
            PreviewColors = {Color3.fromRGB(160, 220, 30), Color3.fromRGB(110, 170, 25), Color3.fromRGB(50, 90, 10)}
        },
        Silver = {
            Body = Color3.fromRGB(10, 10, 11),
            Primary = Color3.fromRGB(6, 6, 7),
            Lit = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 62, 70)),
                ColorSequenceKeypoint.new(0.25, Color3.fromRGB(100, 103, 112)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(145, 148, 158)),
                ColorSequenceKeypoint.new(0.75, Color3.fromRGB(185, 188, 198)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(225, 228, 238))
            },
            TextColor = Color3.fromRGB(245, 245, 250),
            SubTextColor = Color3.fromRGB(190, 192, 200),
            ButtonGradient = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(170, 173, 185)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 83, 95))
            },
            Accent = Color3.fromRGB(200, 203, 215),
            AccentDark = Color3.fromRGB(120, 123, 135),
            AccentLight = Color3.fromRGB(235, 237, 245),
            HeaderBtn = Color3.fromRGB(160, 163, 175),
            DisplayName = "Silver",
            PreviewColors = {Color3.fromRGB(170, 173, 185), Color3.fromRGB(120, 123, 135), Color3.fromRGB(60, 62, 70)}
        },
        Violet = {
            Body = Color3.fromRGB(9, 6, 14),
            Primary = Color3.fromRGB(6, 4, 10),
            Lit = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 20, 130)),
                ColorSequenceKeypoint.new(0.25, Color3.fromRGB(110, 40, 180)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 60, 220)),
                ColorSequenceKeypoint.new(0.75, Color3.fromRGB(190, 90, 240)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(225, 130, 250))
            },
            TextColor = Color3.fromRGB(248, 238, 255),
            SubTextColor = Color3.fromRGB(220, 195, 245),
            ButtonGradient = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(170, 70, 240)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 25, 170))
            },
            Accent = Color3.fromRGB(200, 120, 250),
            AccentDark = Color3.fromRGB(130, 55, 200),
            AccentLight = Color3.fromRGB(230, 175, 255),
            HeaderBtn = Color3.fromRGB(165, 85, 235),
            DisplayName = "Violet",
            PreviewColors = {Color3.fromRGB(170, 70, 240), Color3.fromRGB(130, 55, 200), Color3.fromRGB(70, 20, 130)}
        },
    },
    Current = nil,
    _listeners = {}
}
