import Foundation

struct DhikrType: Identifiable, Hashable {
    let id = UUID()
    let arabic: String
    let turkish: String
    let meaning: String
    let pronunciation: String
    let recommendedCount: Int
    
    static let commonDhikrs: [DhikrType] = [
        DhikrType(
            arabic: "سُبْحَانَ اللّهِ",
            turkish: "Sübhanallah",
            meaning: "Allah'ı tüm eksikliklerden tenzih ederim",
            pronunciation: "Sübhânallâh",
            recommendedCount: 33
        ),
        DhikrType(
            arabic: "اَلْحَمْدُ لِلّهِ",
            turkish: "Elhamdülillah",
            meaning: "Hamd Allah'a mahsustur",
            pronunciation: "Elhamdülillâh",
            recommendedCount: 33
        ),
        DhikrType(
            arabic: "اللّهُ أَكْبَرُ",
            turkish: "Allahu Ekber",
            meaning: "Allah en büyüktür",
            pronunciation: "Allâhu Ekber",
            recommendedCount: 33
        ),
        DhikrType(
            arabic: "لَا إِلَهَ إِلَّا اللّهُ",
            turkish: "La ilahe illallah",
            meaning: "Allah'tan başka ilah yoktur",
            pronunciation: "Lâ ilâhe illallâh",
            recommendedCount: 100
        ),
        DhikrType(
            arabic: "أَسْتَغْفِرُ اللّهَ",
            turkish: "Estağfirullah",
            meaning: "Allah'tan bağışlanma dilerim",
            pronunciation: "Estağfirullâh",
            recommendedCount: 100
        ),
        DhikrType(
            arabic: "لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللّهِ",
            turkish: "La havle ve la kuvvete illa billah",
            meaning: "Güç ve kuvvet ancak Allah'tandır",
            pronunciation: "Lâ havle ve lâ kuvvete illâ billâh",
            recommendedCount: 100
        ),
        DhikrType(
            arabic: "حَسْبُنَا اللّهُ وَنِعْمَ الْوَكِيلُ",
            turkish: "Hasbünallahü ve ni'mel vekil",
            meaning: "Allah bize yeter, O ne güzel vekildir",
            pronunciation: "Hasbünallâhü ve ni'mel vekîl",
            recommendedCount: 100
        ),
        DhikrType(
            arabic: "سُبْحَانَ اللّهِ وَبِحَمْدِهِ",
            turkish: "Sübhanallahi ve bihamdihi",
            meaning: "Allah'ı hamd ile tesbih ederim",
            pronunciation: "Sübhânallâhi ve bihamdihî",
            recommendedCount: 100
        ),
        DhikrType(
            arabic: "سُبْحَانَ اللّهِ الْعَظِيمِ",
            turkish: "Sübhanallahil azim",
            meaning: "Yüce Allah'ı tüm eksikliklerden tenzih ederim",
            pronunciation: "Sübhânallâhil azîm",
            recommendedCount: 33
        ),
        DhikrType(
            arabic: "اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ",
            turkish: "Allahümme salli ala Muhammed",
            meaning: "Allah'ım, Muhammed'e salat eyle",
            pronunciation: "Allâhümme salli alâ Muhammed",
            recommendedCount: 100
        ),
        DhikrType(
            arabic: "بِسْمِ اللّهِ الرَّحْمَنِ الرَّحِيمِ",
            turkish: "Bismillahirrahmanirrahim",
            meaning: "Rahman ve Rahim olan Allah'ın adıyla",
            pronunciation: "Bismillâhirrahmânirrahîm",
            recommendedCount: 100
        ),
        DhikrType(
            arabic: "يَا اللّهُ",
            turkish: "Ya Allah",
            meaning: "Ey Allah",
            pronunciation: "Yâ Allâh",
            recommendedCount: 100
        )
    ]
}
