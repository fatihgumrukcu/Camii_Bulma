import Foundation

struct PrayerData {
    static let prayers: [Prayer] = [
        Prayer(
            name: "Sübhaneke",
            arabicText: "سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ وَتَبَارَكَ اسْمُكَ وَتَعَالَى جَدُّكَ وَلاَ إِلَهَ غَيْرُكَ",
            turkishPronunciation: "Sübhâneke allâhümme ve bi hamdik ve tebâra kesmük ve teâlâ ceddük ve lâ ilâhe ğayruk",
            meaning: "Allah'ım! Sen eksik sıfatlardan pak ve uzaksın. Seni daima böyle tenzih eder ve överim. Senin adın mübarektir. Varlığın her şeyden üstündür. Senden başka ilah yoktur."
        ),
        Prayer(
            name: "Tahiyyat",
            arabicText: "التَّحِيَّاتُ لِلَّهِ وَالصَّلَوَاتُ وَالطَّيِّبَاتُ السَّلاَمُ عَلَيْكَ أَيُّهَا النَّبِيُّ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ السَّلاَمُ عَلَيْنَا وَعَلَى عِبَادِ اللَّهِ الصَّالِحِينَ أَشْهَدُ أَنْ لاَ إِلَهَ إِلاَّ اللَّهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ",
            turkishPronunciation: "Ettehiyyâtü lillâhi vessalevâtü vettayyibât. Esselâmü aleyke eyyühen nebiyyü ve rahmetullahi ve berakâtüh. Esselâmü aleynâ ve alâ ibâdillâhis sâlihîn. Eşhedü en lâ ilâhe illallâh ve eşhedü enne muhammeden abdühû ve rasûlüh.",
            meaning: "Dil ile, beden ve mal ile yapılan bütün ibadetler Allah'a mahsustur. Ey Peygamber! Allah'ın selamı, rahmet ve bereketleri senin üzerine olsun. Selam bizim üzerimize ve Allah'ın salih kulları üzerine olsun. Ben şahitlik ederim ki, Allah'tan başka ilah yoktur. Yine şahitlik ederim ki, Muhammed O'nun kulu ve elçisidir."
        ),
        Prayer(
            name: "Allahümme Salli",
            arabicText: "اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ",
            turkishPronunciation: "Allâhümme salli alâ muhammedin ve alâ âli muhammed. Kemâ salleyte alâ ibrâhîme ve alâ âli ibrâhîm. İnneke hamîdün mecîd.",
            meaning: "Allah'ım! Muhammed'e ve Muhammed'in ümmetine rahmet eyle; şerefini yücelt. İbrahim'e ve İbrahim'in ümmetine rahmet ettiğin gibi. Şüphesiz övülmeye layık yalnız sensin, şan ve şeref sahibi de sensin."
        ),
        Prayer(
            name: "Allahümme Barik",
            arabicText: "اللَّهُمَّ بَارِكْ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ كَمَا بَارَكْتَ عَلَى إِبْرَاهِيمَ وَعَلَى آلِ إِبْرَاهِيمَ إِنَّكَ حَمِيدٌ مَجِيدٌ",
            turkishPronunciation: "Allâhümme bârik alâ muhammedin ve alâ âli muhammed. Kemâ bârekte alâ ibrâhîme ve alâ âli ibrâhîm. İnneke hamîdün mecîd.",
            meaning: "Allah'ım! Muhammed'e ve Muhammed'in ümmetine hayır ve bereket ver. İbrahim'e ve İbrahim'in ümmetine verdiğin gibi. Şüphesiz övülmeye layık yalnız sensin, şan ve şeref sahibi de sensin."
        ),
        Prayer(
            name: "Rabbena Atina",
            arabicText: "رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ",
            turkishPronunciation: "Rabbenâ âtinâ fid'dünyâ haseneten ve fil'âhireti haseneten ve kınâ azâbennâr.",
            meaning: "Rabbimiz! Bize dünyada iyilik ver, ahirette de iyilik ver. Bizi cehennem azabından koru!"
        ),
        Prayer(
            name: "Kunut 1",
            arabicText: "اللَّهُمَّ إِنَّا نَسْتَعِينُكَ وَنَسْتَغْفِرُكَ وَنَسْتَهْدِيكَ وَنُؤْمِنُ بِكَ وَنَتُوبُ إِلَيْكَ وَنَتَوَكَّلُ عَلَيْكَ",
            turkishPronunciation: "Allâhümme innâ nesteînüke ve nestağfiruke ve nestehdîk. Ve nü'minü bike ve netûbü ileyk. Ve netevekkelü aleyke",
            meaning: "Allah'ım! Senden yardım isteriz, günahlarımızı bağışlamanı isteriz, razı olduğun şeylere hidayet etmeni isteriz. Sana inanırız, sana tevbe ederiz. Sana güveniriz."
        ),
        Prayer(
            name: "Kunut 2",
            arabicText: "وَنُثْنِي عَلَيْكَ الْخَيْرَ كُلَّهُ نَشْكُرُكَ وَلاَ نَكْفُرُكَ وَنَخْلَعُ وَنَتْرُكُ مَنْ يَفْجُرُكَ",
            turkishPronunciation: "Ve nüsnî aleykel hayra küllehû neşkürüke ve lâ nekfürük. Ve nahleu ve netrükü men yefcürük",
            meaning: "Bütün hayırlarla seni överiz. Sana şükrederiz. Seni inkar etmeyiz. Sana karşı geleni terk eder ve uzaklaşırız."
        ),
        Prayer(
            name: "Kunut 3",
            arabicText: "اللَّهُمَّ إِيَّاكَ نَعْبُدُ وَلَكَ نُصَلِّي وَنَسْجُدُ وَإِلَيْكَ نَسْعَى وَنَحْفِدُ نَرْجُو رَحْمَتَكَ وَنَخْشَى عَذَابَكَ إِنَّ عَذَابَكَ بِالْكُفَّارِ مُلْحَقٌ",
            turkishPronunciation: "Allâhümme iyyâke na'büdü ve leke nüsallî ve nescüd. Ve ileyke nes'â ve nahfid. Nercû rahmeteke ve nahşâ azâbek. İnne azâbeke bilküffâri mülhak",
            meaning: "Allah'ım! Biz yalnız sana kulluk ederiz. Namazı yalnız senin için kılarız, ancak sana secde ederiz. Yalnız sana koşar ve sana yaklaşmak isteriz. Rahmetini umarız, azabından korkarız. Şüphesiz senin azabın kafirlere ulaşacaktır."
        ),
        Prayer(
            name: "Amentü",
            arabicText: "آمَنْتُ بِاللهِ وَمَلَائِكَتِهِ وَكُتُبِهِ وَرُسُلِهِ وَالْيَوْمِ الْآخِرِ وَبِالْقَدَرِ خَيْرِهِ وَشَرِّهِ مِنَ اللهِ تَعَالَى وَالْبَعْثِ بَعْدَ الْمَوْتِ حَقٌّ أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ",
            turkishPronunciation: "Âmentü billâhi ve melâiketihî ve kütübihî ve rusülihî vel yevmil âhiri ve bil kaderi hayrihî ve şerrihî minallâhi teâlâ vel ba'sü ba'del mevti hakkun eşhedü en lâ ilâhe illallâh ve eşhedü enne muhammeden abdühû ve rasûlüh",
            meaning: "Allah'a, meleklerine, kitaplarına, peygamberlerine, ahiret gününe, kadere, hayır ve şerrin Allah'tan olduğuna inandım. Öldükten sonra diriliş haktır. Allah'tan başka ilah olmadığına, Muhammed'in O'nun kulu ve elçisi olduğuna şahitlik ederim."
        )
    ]
    
    static let dailyVerses: [DailyVerse] = [
        DailyVerse(
            arabicText: "وَإِلَٰهُكُمْ إِلَٰهٌ وَاحِدٌ ۖ لَّا إِلَٰهَ إِلَّا هُوَ الرَّحْمَٰنُ الرَّحِيمُ",
            turkishMeaning: "Sizin ilahınız bir tek ilahtır. O'ndan başka ilah yoktur. O Rahmân'dır, Rahîm'dir.",
            source: "Bakara Suresi, 163. Ayet"
        ),
        DailyVerse(
            arabicText: "رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ",
            turkishMeaning: "Rabbimiz! Bize dünyada iyilik ver, ahirette de iyilik ver. Bizi cehennem azabından koru!",
            source: "Bakara Suresi, 201. Ayet"
        ),
        DailyVerse(
            arabicText: "اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ",
            turkishMeaning: "Allah, O'ndan başka ilah olmayan, kendisi diri ve yarattıklarını gözetip durandır.",
            source: "Bakara Suresi, 255. Ayet (Ayetel Kürsi)"
        )
    ]
}
