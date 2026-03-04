local _, ns = ...
ns.MAP_GUIDE_DATA = {
    -- ========================================================================================================================
    -- 联盟
    -- ========================================================================================================================
    --------------------------------------------------------------------------------
    -- 暴风城
    --------------------------------------------------------------------------------
    [84] = {
        group = "Stormwind",
        -- 传送
        { coord = 82692959, icon = 135758, text = "◆月光林地", title = "月光林地传送门", info = "和赛纳里奥使者安亚·碧月对话（|cFF00FF00有海加尔守护者声望需求|r）", color = "portal", textA = "RIGHT" },
        { coord = 48790858, icon = 237556, text = "同盟传送", title = "同盟种族传送门", info = "光铸道标/麦卡贡传送器/暗炉城钻探机/泰洛古斯裂隙\n\n|cFFEE8800作者描述：通过光铸道标传送到维迪卡尔可以看到整个艾泽拉斯星球（放心往前不会掉下去）|r", color = "portal" },
        { coord = 74461834, icon = 237556, text = "其他传送门", title = "大地的裂变版本传送门", info = "海加尔山/暮光高地/瓦斯琪尔/奥丹姆/深岩之洲/托尔巴拉德传送门", color = "portal" },
        { coord = 23875612, icon = 135755, text = "◆达纳苏斯", title = "达纳苏斯传送门", color = "portal", textA = "RIGHT" },
        { coord = 66883441, icon = 132334, text = "◆地铁/搏击", title = "矿道地铁/搏击俱乐部", info = "乘坐矿道地铁可通往铁炉堡", color = "portal", textA = "RIGHT" },
        { coord = 48758811, text = "传送大厅", color = "portal" },
        { coord = 18252569, text = "北风苔原", color = "portal" },
        { coord = 21315500, text = "伯拉勒斯", color = "portal" },
        { coord = 22415815, text = "觉醒海岸", color = "portal" },
        -- 主要
        { coord = 60397527, icon = 134414, text = "旅店", title = "旅店（贸易区）", info = "奥里森", color = "inn" },
        { coord = 75685411, icon = 134414, text = "旅店", title = "旅店（旧城区）", info = "梅根·提尔曼", color = "inn" },
        { coord = 64933194, icon = 134414, text = "◆旅店", title = "旅店（矮人区）", info = "塔格娜·耕石", color = "inn", textA = "RIGHT" },
        { coord = 49891572, icon = 134414, text = "旅店", title = "旅店（大使馆）", info = "莎妮·护界", color = "inn" },
        { coord = 61167080, icon = 133784, text = "拍卖", title = "拍卖行（贸易区）", color = "official" },
        { coord = 60113221, icon = 133784, text = "拍卖", title = "拍卖行（矮人区）", color = "official" },
        { coord = 63037883, icon = 413587, text = "银行", title = "银行及公会银行（贸易区）", color = "official" },
        { coord = 64802853, icon = 413587, text = "银行", title = "银行及公会银行（矮人区）", color = "official" },
        -- 专业
        { coord = 85822595, icon = 441139, text = "考古", title = "考古学训练师", info = "哈里森·琼斯", color = "profession", type = "Archaeology" },
        { coord = 55668608, icon = 4620669, text = "炼金", title = "炼金术训练师", info = "莉琳希亚·夜风", color = "profession", type = "Alchemy" },
        { coord = 63673700, icon = 4620670, text = "锻造", title = "锻造训练师（矮人区）", info = "瑟鲁姆·深炉", color = "profession", type = "Blacksmithing" },
        { coord = 77285321, icon = 4620671, text = "烹饪", title = "烹饪训练师（旧城区）", info = "斯蒂芬·雷百克", color = "profession", type = "Cooking" },
        { coord = 50651721, icon = 4620671, text = "烹饪", title = "烹饪训练师（大使馆）", info = "达利娅·穹花", color = "profession", type = "Cooking" },
        { coord = 52947442, icon = 4620672, text = "附魔", title = "附魔训练师（法师区）", info = "鲁坎·考迪尔", color = "profession", type = "Enchanting" },
        { coord = 51211267, icon = 4620672, text = "附魔", title = "附魔训练师（大使馆）", info = "艾丽斯塔·黎明之尘", color = "profession", type = "Enchanting" },
        { coord = 62853197, icon = 4620673, text = "工程", title = "工程学训练师（矮人区）", info = "利廉姆·火轴", color = "profession", type = "Engineering" },
        { coord = 54796959, icon = 4620674, text = "钓鱼", title = "钓鱼训练师", info = "阿诺德·利兰", color = "profession", type = "Fishing" },
        { coord = 40846586, icon = 4620675, text = "草药", title = "草药学训练师（雄狮之眠）", info = "莎拉米尔", color = "profession", type = "Herbalism" },
        { coord = 54308411, icon = 4620675, text = "草药", title = "草药学训练师（法师区）", info = "塔尼莎", color = "profession", type = "Herbalism" },
        { coord = 49837482, icon = 4620676, text = "铭文", title = "铭文训练师", info = "卡塔莉娜·斯坦弗", color = "profession", type = "Inscription" },
        { coord = 63486184, icon = 4620677, text = "珠宝", title = "珠宝加工训练师", info = "特蕾莎·登曼", color = "profession", type = "Jewelcrafting" },
        { coord = 59513777, icon = 4620679, text = "采矿", title = "采矿训练师（矮人区）", info = "吉尔曼·石手", color = "profession", type = "Mining" },
        { coord = 53088135, icon = 4620681, text = "裁缝", title = "裁缝训练师（法师区）", info = "乔吉奥·波利罗", color = "profession", type = "Tailoring" },
        { coord = 52011952, icon = 4620681, text = "裁缝", title = "裁缝训练师（大使馆）", info = "艾维多斯", color = "profession", type = "Tailoring" },
        { coord = 71916264, icon = 4620678, text = "制皮/剥皮◆", title = "制皮/剥皮训练师", info = "西蒙·坦纳尔/马瑞斯·格兰治", color = "profession", type = { "Leatherworking", "Skinning" }, textA = "LEFT" },
        { coord = 49101237, icon = 1392955, text = "工程/锻造/采矿◆", title = "工程学/锻造/采矿训练师（大使馆）", info = "技师法鲁德/伊莱娅/德鲁本·粗臂", color = "profession", type = { "Engineering", "Blacksmithing", "Mining" }, textA = "LEFT" },
        -- 其他
        { coord = 61516461, icon = 133801, text = "理发", title = "理发店", info = "耶利尼克·沙希尔", color = "service" },
        { coord = 50766074, icon = 133564, text = "幻化", title = "幻化师/遗忘传说供应商", info = "织幻者哈沙姆\n搜寻者纳杰德：出售|cFF00FF00丢失的老版本橙装|r", color = "service" },
        { coord = 51037195, icon = 4696085, text = "商栈", title = "商栈", info = "陶妮和怀尔德商栈/宠物幻化处", color = "service" },
        { coord = 42546050, icon = 1769016, text = "兽栏/制皮◆", title = "兽栏/制皮训练师（雄狮之眠）", info = "塞丽斯塔/泰龙尼斯", color = "stable", tags = { "stable", "profession" }, textA = "LEFT" },
        { coord = 67263767, icon = 1769016, text = "兽栏", title = "兽栏（矮人区）", info = "耶诺瓦·石盾", color = "stable" },
        { coord = 53271283, icon = 1769016, text = "◆兽栏", title = "兽栏（大使馆）", info = "阿什利·黯叶", color = "stable", textA = "RIGHT" },
        { coord = 76926801, icon = 413588, text = "坐骑", title = "坐骑", info = "凯蒂·斯托克斯：出售人类种族坐骑战马", color = "collection" },
        { coord = 73005952, icon = 413588, text = "◆坐骑/幸运商人", title = "摩托商人/幸运商人", info = "保利：出售坐骑|cFF00FF00勇士的践踏之刃|r\n\n“巧手”雷尼·麦考伊：出售玩具|cFF00FF00波贝的炫彩酱汁|r和幸运相关的道具\n\n|cFFEE8800作者描述：背包内常年放满幸运道具，相信玄学！|r", color = "collection", tags = { "collection", "vendor" }, textA = "RIGHT" },
        { coord = 38096439, icon = 135265, text = "玩具", title = "玩具旅行者的篝火", info = "对安多哈尔的索拉尔使用/疲倦，可以获得玩具|cFF00FF00旅行者的篝火|r", color = "collection" },
        { coord = 61332268, icon = 1109100, text = "玩具", title = "玩具自拍神器", info = "阿丽尔·闪拍：完成任务可获得玩具|cFF00FF00自拍神器|r", color = "collection" },
        { coord = 69482515, icon = 652131, text = "宠物", title = "战斗宠物训练师", info = "奥黛丽·伯恩赫普", color = "collection" },
        { coord = 58905274, icon = 647628, text = "宠物", title = "宠物联盟气球", info = "蔚蔚：完成任务可以获得宠物|cFF00FF00联盟气球|r", color = "collection" },
        { coord = 56087712, icon = 7449410, text = "家宅", title = "弗雷德里克的奇妙家具", info = "“第二把交椅”袍铎", color = "collection" },
        { coord = 48546877, icon = 7449410, text = "家宅", title = "促销装饰补给", info = "图乌兰：出售1款家宅装饰|cFF00FF00黑暗之门|r", color = "collection" },
        { coord = 49278011, icon = 7449410, text = "家宅", title = "旅行书店", info = "索莉罗：出售2款书本类家宅装饰", color = "collection" },
        { coord = 64157702, icon = 514261, text = "公会", title = "公会商人", info = "塞伊·普雷斯勒", color = "vendor" },
        { coord = 56251731, icon = 134156, text = "克罗米", title = "克罗米", info = "切换时间线", color = "special" },
        { coord = 87673608, icon = 894556, text = "◆经验锁定", title = "经验锁定", info = "贝斯滕", color = "special", textA = "RIGHT" },
        { coord = 75300926, icon = 1109100, text = "动画", title = "动画短片", info = "克罗米：可观看巨龙之魂副本中|cFF00FF00击败死亡之翼的动画|r", color = "special" },
        { coord = 49488569, icon = 618982, text = "战役", title = "场景战役", info = "档案员托马斯：可体验8.0前夕剧情|cFF00FF00洛丹伦之战|r", color = "special" },
        { coord = 47888441, icon = 132288, text = "变形", title = "变形效果", info = "和大法师纳卡达对话可随机变成一种生物，持续5分钟，支持施法但禁用坐骑，有30分钟变形Debuff", color = "special" },
        { coord = 67747303, icon = 255150, text = "暴风城", title = "暴风城军需官", info = "骑士队长兰希·莱薇森：出售暴风城战袍和暴风城风格家宅装饰", color = "quartermaster" },
        { coord = 67831704, icon = 255150, text = "土水派", title = "土水派军需官/龙龟饲养员", info = "门徒韩俊：出售土水派熊猫人战袍\n\n老白鼻（左）：出售熊猫人种族坐骑龙龟\n\n对附近的熊猫萌萌使用/love可以获得道具|cFF00FF00竹笋|r，使用后可变身同款熊猫，支持施法", color = "quartermaster" },
        { coord = 76136540, icon = 413588, text = "PVP坐骑◆", title = "战争坐骑军需官", info = "通灵领主赛普（|cFF4499FF邪气鞍座|r）\n\n卡特尔中尉（|cFF4499FF荣耀印记|r）", color = "pvp", textA = "LEFT" },
        { coord = 74756773, icon = 1455894, text = "PVP商人◆", title = "勇士大厅", info = "克莱特军士长/加克斯宾中尉：出售旧世界PVP装备/武器（|cFF4499FF荣耀印记|r）\n\n军士长贝金斯：出售PVP宝石和2款战袍（|cFF4499FF荣耀印记|r）\n\n崔丝提亚中尉：出售第9赛季残忍角斗士装备和武器（|cFF4499FF荣耀印记|r）\n\n迪格汉默上尉：出售第11赛季灾变角斗士装备和武器（|cFF4499FF荣耀印记|r）\n\n骑士队长杰西卡：出售3款宠物\n\n埃德兰·哈尔辛：出售嗜血角斗士装备（|cFF4499FF荣耀印记|r）\n\n爱丽丝·费雪：出售孵化候选者装备（|cFF4499FF荣誉点数|r）\n\n骑士队长蒂麦尔·塞缇丝：出售第10赛季冷酷角斗士装备和武器（|cFF4499FF荣耀印记|r）\n\n莉莉安娜·恩贝弗斯特：出售荣誉传家宝（|cFF4499FF荣耀印记|r）", color = "pvp", textA = "LEFT" },
        { coord = 77826577, icon = 7449410, text = "◆PVP家宅", title = "战场装饰专家", info = "莉伊卡：出售多种战场类家宅装饰，有成就限制（|cFF4499FF荣誉点数/荣耀印记|r）", color = "pvp", textA = "RIGHT" },
        { coord = 78976232, icon = 236179, text = "木桩", title = "木桩", color = "pvp" },
        { coord = 51176790, text = "监狱", color = "instance" }
    },

    [499] = { -- 暴风城：矿道地铁
        group = "Stormwind",
        { coord = 52324805, icon = 132334, text = "搏击俱乐部", title = "搏击俱乐部", info = "矿道地铁下方入口", color = "portal" }
    },

    [500] = { -- 暴风城：搏击俱乐部
        group = "Stormwind",
        { coord = 54202521, icon = 2737713, text = "搏击俱乐部", title = "搏击俱乐部军需官", info = "奎肯布什：出售坐骑/宠物/战袍/衬衣/传家宝/家宅装饰/传送到搏击俱乐部的戒指", color = "quartermaster" }
    },

    --------------------------------------------------------------------------------
    -- 铁炉堡
    --------------------------------------------------------------------------------
    [87] = {
        group = "Ironforge",
        -- 传送
        { coord = 76435115, icon = 132334, text = "地铁", title = "矿道地铁", info = "乘坐矿道地铁可通往暴风城", color = "portal" },
        -- 主要
        { coord = 18125142, icon = 134414, text = "旅店", title = "旅店", info = "洛雷·火酒", color = "inn" },
        { coord = 24817379, icon = 133784, text = "拍卖", title = "拍卖行", color = "official" },
        { coord = 34986131, icon = 413587, text = "银行", title = "银行及公会银行", color = "official" },
        -- 专业
        { coord = 75591113, icon = 441139, text = "考古", title = "考古学训练师", info = "学者教授铁裤", color = "profession", type = "Archaeology" },
        { coord = 66615565, icon = 4620669, text = "炼金", title = "炼金术训练师", info = "塔雷·浆泡", color = "profession", type = "Alchemy" },
        { coord = 52494200, icon = 4620670, text = "锻造", title = "锻造训练师", info = "本古斯·深炉", color = "profession", type = "Blacksmithing" },
        { coord = 60083644, icon = 4620671, text = "烹饪", title = "烹饪训练师", info = "达瑞尔·瑞克努索", color = "profession", type = "Cooking" },
        { coord = 68454353, icon = 4620673, text = "工程", title = "工程学训练师", info = "宾斯匹德", color = "profession", type = "Engineering" },
        { coord = 55905914, icon = 4620675, text = "草药", title = "草药学训练师", info = "雷纳·石枝", color = "profession", type = "Herbalism" },
        { coord = 43142937, icon = 4620681, text = "裁缝", title = "裁缝训练师", info = "约莫德:石眉", color = "profession", type = "Tailoring" },
        { coord = 60124535, icon = 1392955, text = "◆附魔/铭文", title = "附魔/铭文训练师", info = "吉布·草须/艾莉丝·布莱里特", color = "profession", type = { "Enchanting", "Inscription" }, textA = "RIGHT" },
        { coord = 50782640, icon = 4620677, text = "◆珠宝/采矿", title = "珠宝加工/采矿训练师", info = "哈尼尔·坚石/吉尔弗拉姆·石趾", color = "profession", type = { "Jewelcrafting", "Mining" }, textA = "RIGHT" },
        { coord = 40033307, icon = 4620678, text = "制皮/剥皮◆", title = "制皮/剥皮训练师", info = "费布·钢轴/巴尔萨斯·裂石", color = "profession", type = { "Leatherworking", "Skinning" }, textA = "LEFT" },
        -- 其他
        { coord = 25954934, icon = 133801, text = "理发", title = "理发店", info = "贝拉·布拉鲁斯", color = "service" },
        { coord = 69308361, icon = 1769016, text = "兽栏", title = "兽栏", info = "乌布雷克·火拳", color = "stable" },
        { coord = 76140809, icon = 7449410, text = "家宅", title = "图书馆陈列爱好者", info = "因葛·明视：出售2款书柜类家宅装饰", color = "collection" },
        { coord = 36288582, icon = 514261, text = "公会", title = "公会商人/注册员/战袍商人", info = "斯蒂格·赫斯克尔勒/乔多·钢眉/利莎·钢眉", color = "vendor" },
        { coord = 74470984, icon = 135360, text = "传家宝◆", title = "传家宝管理员", info = "克罗姆·粗臂：出售传家宝/传家宝升级道具/各个地图玩具|cFF00FF00侦查地图|r", color = "vendor", textA = "LEFT" },
        { coord = 25500707, icon = 237556, text = "传送", title = "传送门训练师", info = "贝尔斯塔弗·风暴之眼", color = "special" },
        { coord = 54834749, icon = 255148, text = "诺莫瑞根/铁炉堡◆", title = "诺莫瑞根/铁炉堡军需官", info = "工匠大师崔尼：出售诺莫瑞根战袍\n\n石盔上尉：出售铁炉堡战袍和铁炉堡风格家宅装饰", color = "quartermaster", textA = "LEFT" },
        { coord = 58846964, icon = 236179, text = "木桩", title = "木桩", color = "pvp" }
    },

    --------------------------------------------------------------------------------
    -- 达纳苏斯
    --------------------------------------------------------------------------------
    [89] = {
        group = "Darnassus",
        -- 传送
        { coord = 44067849, icon = 237556, text = "◆外域/埃索达/传送", title = "地狱火半岛/埃索达传送门/传送门训练师", info = "埃莉萨·杜马斯", color = "portal", tags = { "portal", "special" }, textA = "RIGHT" },
        { coord = 37095050, icon = 237556, text = "鲁瑟兰村", title = "鲁瑟兰村传送门", info = "走进粉色区域自动传送", color = "portal" },
        -- 主要
        { coord = 48421499, icon = 134414, text = "旅店", title = "旅店（风嚎橡树）", info = "格温·阿姆斯特", color = "inn" },
        { coord = 62533278, icon = 134414, text = "旅店", title = "旅店（工匠区）", info = "塞琳尼", color = "inn" },
        { coord = 54875837, icon = 133784, text = "拍卖", title = "拍卖行", color = "official" },
        { coord = 43615100, icon = 413587, text = "银行", title = "银行及公会银行", color = "official" },
        -- 专业
        { coord = 42638333, icon = 441139, text = "考古", title = "考古学训练师", info = "隐世者汉蒙", color = "profession", type = "Archaeology" },
        { coord = 53913853, icon = 4620669, text = "炼金", title = "炼金术训练师", info = "安尼希尔", color = "profession", type = "Alchemy" },
        { coord = 57005270, icon = 4620670, text = "锻造", title = "锻造训练师", info = "罗尔夫·卡尔尼尔", color = "profession", type = "Blacksmithing" },
        { coord = 49883663, icon = 4620671, text = "烹饪", title = "烹饪训练师", info = "阿雷贡", color = "profession", type = "Cooking" },
        { coord = 49126098, icon = 4620674, text = "钓鱼", title = "钓鱼训练师", info = "阿斯坦娅", color = "profession", type = "Fishing" },
        { coord = 49146880, icon = 4620675, text = "草药", title = "草药学训练师", info = "菲罗迪恩·唤月", color = "profession", type = "Herbalism" },
        { coord = 53983111, icon = 4620677, text = "珠宝", title = "珠宝加工训练师", info = "艾莎·银露", color = "profession", type = "Jewelcrafting" },
        { coord = 49623237, icon = 4620673, text = "◆工程/采矿", title = "工程学（1楼）/采矿训练师（2楼）", info = "塔娜·伦特危尔/工头佩尔尼奇", color = "profession", type = { "Engineering", "Mining" }, textA = "RIGHT", offsetY = -5 },
        { coord = 56423101, icon = 1392955, text = "◆附魔/铭文", title = "附魔（1楼）/铭文训练师（2楼）", info = "塔兰丹/芬迪·达金", color = "profession", type = { "Enchanting", "Inscription" }, textA = "RIGHT" },
        { coord = 60493683, icon = 1392955, text = "◆裁缝/制皮/剥皮", title = "裁缝（1楼）/制皮/剥皮训练师（2楼）", info = "迈里恩/泰龙尼斯/艾拉迪尔", color = "profession", type = { "Tailoring", "Leatherworking", "Skinning" }, textA = "RIGHT" },
        -- 其他
        { coord = 43172893, icon = 1769016, text = "兽栏", title = "兽栏", info = "阿拉辛", color = "stable" },
        { coord = 64055357, icon = 652131, text = "宠物", title = "猫头鹰训练师", info = "夏琳奈尔：出售2款宠物|cFF00FF00猫头鹰|r", color = "collection" },
        { coord = 42493260, icon = 413588, text = "坐骑", title = "驯豹人", info = "莱兰奈：出售暗夜精灵种族坐骑猎豹", color = "collection" },
        { coord = 48142179, icon = 413588, text = "坐骑", title = "高山马管理员", info = "阿斯特丽德·长袜：出售2款坐骑|cFF00FF00高山马|r", color = "collection" },
        { coord = 64583811, icon = 514261, text = "公会", title = "公会商人/注册员/战袍商人", info = "瓦莉亚·月弓/琳沙娜/沙鲁蒙", color = "vendor", offsetY = -5 },
        { coord = 36164847, icon = 255151, text = "达纳苏斯◆", title = "达纳苏斯军需官", info = "月之女祭司娜萨拉：出售达纳苏斯战袍", color = "quartermaster", textA = "LEFT" },
        { coord = 37134743, icon = 466012, text = "◆吉尔尼斯", title = "吉尔尼斯军需官", info = "坎德雷勋爵：出售吉尔尼斯战袍和吉尔尼斯风格家宅装饰", color = "quartermaster", textA = "RIGHT" },
        { coord = 60485344, icon = 236179, text = "木桩", title = "木桩", color = "pvp" },
        { coord = 60484603, icon = 236179, text = "木桩", title = "木桩", color = "pvp" }
    },

    --------------------------------------------------------------------------------
    -- 埃索达
    --------------------------------------------------------------------------------
    [103] = {
        group = "Exodar",
        -- 传送
        { coord = 48356292, icon = 135763, text = "暴风", title = "暴风城传送门", color = "portal" },
        -- 主要
        { coord = 59511877, icon = 134414, text = "旅店", title = "旅店", info = "布雷尔", color = "inn" },
        { coord = 63255869, icon = 133784, text = "拍卖", title = "拍卖行", color = "official" },
        { coord = 45434389, icon = 413587, text = "银行", title = "银行及公会银行", color = "official" },
        -- 专业
        { coord = 33646637, icon = 441139, text = "考古", title = "考古学训练师", info = "蒂亚", color = "profession", type = "Archaeology" },
        { coord = 55742671, icon = 4620671, text = "烹饪", title = "烹饪训练师", info = "穆曼", color = "profession", type = "Cooking" },
        { coord = 54169285, icon = 4620673, text = "工程", title = "工程学训练师", info = "奥克基尔", color = "profession", type = "Engineering" },
        { coord = 31951467, icon = 4620674, text = "钓鱼", title = "钓鱼训练师", info = "伊雷特", color = "profession", type = "Fishing" },
        { coord = 44882423, icon = 4620677, text = "珠宝", title = "珠宝加工训练师", info = "法里", color = "profession", type = "Jewelcrafting" },
        { coord = 64426900, icon = 4620681, text = "裁缝", title = "裁缝训练师", info = "雷菲克", color = "profession", type = "Tailoring" },
        { coord = 27466284, icon = 4620669, text = "炼金/草药◆", title = "炼金术/草药学训练师", info = "鲁克/塞摩尔汉", color = "profession", type = { "Alchemy", "Herbalism" }, textA = "LEFT" },
        { coord = 59708777, icon = 4620670, text = "◆锻造/采矿", title = "锻造/采矿训练师", info = "米阿尔/穆亚特", color = "profession", type = { "Blacksmithing", "Mining" }, textA = "RIGHT" },
        { coord = 40183924, icon = 1392955, text = "附魔/铭文◆", title = "附魔/铭文训练师", info = "纳霍加/索斯", color = "profession", type = { "Enchanting", "Inscription" }, textA = "LEFT" },
        { coord = 65667458, icon = 4620678, text = "◆制皮/剥皮", title = "制皮/剥皮训练师", info = "阿克汉姆/雷米勒", color = "profession", type = { "Leatherworking", "Skinning" }, textA = "RIGHT" },
        -- 其他
        { coord = 60192521, icon = 1769016, text = "兽栏", title = "兽栏", info = "阿尔泰德", color = "stable" },
        { coord = 30073377, icon = 652131, text = "宠物", title = "宠物商人", info = "希克斯：出售3款|cFF00FF00蛾子宠物|r", color = "collection" },
        { coord = 53776844, icon = 514261, text = "公会", title = "公会商人/注册员/战袍商人", info = "露妮/弗纳姆/伊斯卡", color = "vendor" },
        { coord = 45996269, icon = 237556, text = "传送◆", title = "传送门训练师", info = "鲁纳尔兰", color = "special", textA = "LEFT" },
        { coord = 54963722, icon = 255147, text = "埃索达", title = "埃索达军需官", info = "卡杜：出售埃索达战袍", color = "quartermaster" },
        { coord = 23783255, icon = 236179, text = "木桩", title = "木桩", color = "pvp" }
    },

    --------------------------------------------------------------------------------
    -- 吉尔尼斯
    --------------------------------------------------------------------------------
    [218] = {
        group = "Gilneas",
        -- 主要
        { coord = 39006111, icon = 134414, text = "旅店", title = "旅店", info = "格温·阿姆斯特", color = "inn" },
        { coord = 59423774, icon = 413587, text = "银行", title = "银行", color = "official" },
        { coord = 58352756, icon = 1392955, text = "专业", title = "全专业技能训练师", info = "杰克·“万金油”·德林顿", color = "profession", type = { "Alchemy", "Blacksmithing", "Enchanting", "Engineering", "Herbalism", "Inscription", "Jewelcrafting", "Leatherworking", "Mining", "Skinning", "Tailoring" } },
        -- 其他
        { coord = 35977079, icon = 1769016, text = "兽栏", title = "兽栏", info = "费尼甘·考布勒", color = "stable" },
        { coord = 41903770, icon = 463876, text = "管家", title = "格雷迈恩管家", info = "和管家对话后可以使城内所有NPC消失一天", color = "special" },
        { coord = 57315545, icon = 466012, text = "◆吉尔尼斯", title = "吉尔尼斯军需官", info = "坎德雷勋爵：出售吉尔尼斯战袍和吉尔尼斯风格家宅装饰", color = "quartermaster", textA = "RIGHT" }
    },

    --------------------------------------------------------------------------------
    -- 暴风之盾
    --------------------------------------------------------------------------------
    [622] = {
        group = "Stormshield",
        -- 传送
        { coord = 60783792, icon = 135763, text = "暴风", title = "暴风城传送门", color = "portal" },
        { coord = 36384114, icon = 237556, text = "雄狮岗哨◆", title = "雄狮岗哨传送门", info = "通往塔纳安丛林的雄狮岗哨，需要完成任务线才可看到", color = "portal", textA = "LEFT" },
        -- 主要
        { coord = 35707789, icon = 134414, text = "旅店", title = "旅店", info = "加西亚·悦花", color = "inn" },
        { coord = 54056634, icon = 133784, text = "拍卖", title = "拍卖行", color = "official" },
        { coord = 54684868, icon = 413587, text = "银行", title = "银行及公会银行", color = "official" },
        -- 专业
        { coord = 49023319, icon = 441139, text = "考古", title = "考古学训练师/考古碎片", info = "曼达·达洛维\n\n格拉吉斯（左1）：出售以下商品\n\n各种考古碎片，至少考古600（|cFF4499FF修复的遗物|r）\n\n|cFF00FF00德拉诺考古学家的地图|r：随机分布德拉诺挖掘场（需要|cFF00FF00鸦人流亡者|r声望崇拜）\n\n|cFF00FF00德拉诺考古学家的磁石|r：随机传送到德拉诺可用的挖掘场（需要|cFF00FF00鸦人流亡者|r声望崇拜）", color = "profession", type = "Archaeology" },
        { coord = 49264640, icon = 4620670, text = "锻造", title = "锻造训练师", info = "艾米·金炉", color = "profession", type = "Blacksmithing" },
        { coord = 35117616, icon = 4620671, text = "烹饪", title = "烹饪训练师", info = "埃尔顿·布莱克（旅店老板背后右转向下）", color = "profession", type = "Cooking" },
        { coord = 56656538, icon = 4620672, text = "附魔", title = "附魔训练师", info = "比尔·星酒", color = "profession", type = "Enchanting" },
        { coord = 48164047, icon = 4620673, text = "工程", title = "工程学训练师", info = "希尔达·铜丝", color = "profession", type = "Engineering" },
        { coord = 55477849, icon = 4620674, text = "钓鱼", title = "钓鱼训练师", info = "奥斯汀·温德米尔", color = "profession", type = "Fishing" },
        { coord = 63163368, icon = 4620676, text = "铭文", title = "铭文训练师（2楼）", info = "铭文师芝源", color = "profession", type = "Inscription" },
        { coord = 43483390, icon = 4620677, text = "珠宝", title = "珠宝加工训练师", info = "技师妮希亚", color = "profession", type = "Jewelcrafting" },
        { coord = 47294364, icon = 4620679, text = "采矿", title = "采矿训练师", info = "乔纳斯·链拳", color = "profession", type = "Mining" },
        { coord = 51513709, icon = 4620681, text = "裁缝", title = "裁缝训练师", info = "约书亚·福斯汀", color = "profession", type = "Tailoring" },
        { coord = 52394273, icon = 4620678, text = "◆制皮/剥皮", title = "制皮/剥皮训练师", info = "吉斯顿·锐羽/游侠兰顿", color = "profession", type = { "Leatherworking", "Skinning" }, textA = "RIGHT" },
        { coord = 37396922, icon = 4620669, text = "炼金/草药◆", title = "炼金术/草药学训练师", info = "贾登·塔斯克/洁·野花", color = "profession", type = { "Alchemy", "Herbalism" }, textA = "LEFT" },
        -- 其他
        { coord = 63113543, icon = 133564, text = "幻化◆", title = "幻化师(1楼)", info = "织幻者沙尔", color = "service", textA = "LEFT" },
        { coord = 33356486, icon = 1769016, text = "兽栏", title = "兽栏", info = "奥维尔·曼弗雷德", color = "stable" },
        { coord = 29645292, icon = 1001490, text = "图纸", title = "要塞图纸商人", info = "金凯德·加科布", color = "unique" },
        { coord = 48506225, icon = 1061300, text = "水晶", title = "埃匹希斯水晶商人", info = "共有6位，出售坐骑|cFF00FF00苔皮淡水兽|r/要塞追随者合约|cFF00FF00寻晨者鲁卡里斯|r", color = "unique" },
        { coord = 52026358, icon = 618858, text = "挑战", title = "黄金挑战商人（绝版）", info = "挑战者萨维娜\n\n|cFFEE8800作者描述：武器设计非常漂亮，当年错过了好可惜|r", color = "unique" },
        { coord = 63933575, icon = 237556, text = "◆传送", title = "传送门训练师（2楼）", info = "朱莉亚·瓦吉斯", color = "special", textA = "RIGHT" },
        { coord = 51846136, icon = 838813, text = "R币", title = "R币兑换", info = "大法师兰达洛克：出售|cFF00FF00钢化命运印记|r", color = "special" },
        { coord = 42917786, icon = 1052654, text = "热砂", title = "热砂军需官", info = "加兹瑞克斯·轮锁：出售以下商品\n\n坐骑|cFF00FF00驯养的刀脊野猪|r\n\n宠物|cFF00FF00白色淡水兽幼崽/被捕获的森林幼苗|r", color = "quartermaster" },
        { coord = 46607674, icon = 1048727, text = "主教", title = "主教议会军需官", info = "守备官努瑞姆：出售以下商品\n\n坐骑|cFF00FF00土色岩皮雷象|r\n\n玩具|cFF00FF00永久时光气泡|r\n\n宠物|cFF00FF00德莱尼微型防御者|r\n\n8款家宅装饰（|cFF4499FF要塞物资|r）", color = "quartermaster" },
        { coord = 44537494, icon = 1042646, text = "鸦人", title = "鸦人流亡者军需官", info = "暗影贤者巴考斯：出售以下商品\n\n坐骑|cFF00FF00暗鬃冲锋者|r\n\n宠物|cFF00FF00塞泰之子|r\n\n3款家宅装饰（|cFF4499FF金币+埃匹希斯水晶|r）", color = "quartermaster" },
        { coord = 54771688, icon = 1042294, text = "乌瑞恩", title = "乌瑞恩先锋军军需官", info = "魔导师朗格莱：出售乌瑞恩先锋军战袍/坐骑|cFF00FF00暗鬃冲锋者|r", color = "quartermaster" },
        { coord = 54501872, icon = 1455894, text = "PVP商人◆", title = "PVP商人", info = "原祖/好战/狂野争斗者/角斗士（|cFF4499FF荣耀印记|r）", color = "pvp", textA = "LEFT" },
        { coord = 60731523, icon = 236179, text = "木桩", title = "木桩", color = "pvp" }
    },

    --------------------------------------------------------------------------------
    -- 伯拉勒斯
    --------------------------------------------------------------------------------
    [1161] = {
        group = "Boralus",
        -- 传送
        { coord = 70581713, icon = 237556, text = "传送大厅◆", title = "传送门训练师/暴风城/希利苏斯/纳沙塔尔/埃索达/铁炉堡传送门", info = "伊薇娅·维弗邦德\n\n希利苏斯传送门：需要|cFF00FF00切回当前时间线|r才能看到\n\n纳沙塔尔传送门：需要|cFF00FF00完成主线任务|r才能看到)", color = "portal", textA = "LEFT" },
        -- 主要
        { coord = 74111265, icon = 134414, text = "◆旅店/随机本", title = "旅店/随机本", info = "维斯雷·洛克霍德\n\n基库：可排奥迪尔/达萨罗之战/风暴熔炉/永恒王宫/尼奥罗萨，觉醒之城的随机本", color = "inn", tags = { "inn", "instance" }, textA = "RIGHT" },
        { coord = 75871756, icon = 413587, text = "银行", title = "银行及公会银行", color = "official" },
        -- 专业
        { coord = 68330848, icon = 441139, text = "考古", title = "考古学训练师", info = "简·哈德森", color = "profession", type = "Archaeology" },
        { coord = 71211067, icon = 4620671, text = "烹饪", title = "烹饪训练师", info = "“船长”拜伦·梅尔萨克", color = "profession", type = "Cooking" },
        { coord = 74160558, icon = 4620674, text = "钓鱼", title = "钓鱼训练师", info = "阿伦·高尔", color = "profession", type = "Fishing" },
        { coord = 73450849, icon = 1392955, text = "专业区域", title = "各种专业训练师", info = "主要专业区域\n\n|cFFEE8800作者描述：范围太小，无法详细标注|r", color = "profession" },
        -- 其他
        { coord = 64602818, icon = 133801, text = "理发", title = "理发店", info = "特里·罗克菲尔德", color = "service" },
        { coord = 71581369, icon = 133564, text = "◆幻化/R币", title = "幻化师/R币兑换", info = "织幻者艾基尔\n\n特兹兰：可用金币/职业大厅资源/荣耀印记兑换|cFF00FF00战痕命运印记|r", color = "service", tags = { "service", "special" }, textA = "RIGHT", offsetY = -5 },
        { coord = 69601316, icon = 1769016, text = "兽栏", title = "兽栏", info = "莱拉·斯塔福德", color = "stable" },
        { coord = 50934593, icon = 652131, text = "宠物", title = "宠物补给", info = "达纳·普尔", color = "collection" },
        { coord = 70201476, icon = 514261, text = "公会", title = "公会商人", info = "派瑞·查尔顿", color = "vendor" },
        { coord = 76921151, icon = 1030900, text = "外观", title = "衬衫商人", info = "马文·希普斯柯：出售16款|cFF00FF00衬衫幻化|r", color = "vendor", offsetY = 5 },
        { coord = 66902577, icon = 2565243, text = "勋章", title = "服役勋章兑换", info = "供应商烈炉：出售以下商品（|cFF4499FF第七军团服役勋章|r）\n\n|cFF00FF00十地饮剂|r：可提升10%经验（等级不高于49级）\n\n6款传家宝\n\n2款披风幻化\n\n玩具|cFF00FF00掷刃车|r\n\n戒指|cFF00FF00船长的指挥玺戒|r：传送到伯拉勒斯\n\n3款坐骑", color = "unique" },
        { coord = 66053231, icon = 1604167, text = "海岛", title = "达布隆币商人/“打捞”专家", info = "克拉丽莎船长：出售以下商品（|cFF4499FF海员达布隆币|r）\n\n3款帽子幻化\n\n玩具|cFF00FF00手锚/暴躁的螃蟹/瘤木冲浪板|r\n\n宠物|cFF00FF00猩红八爪鱼/白化观暮鸦|r\n\n坐骑|cFF00FF00咸水海马/泥翼信天翁|r\n\n夜奔船长：出售3款打捞品（|cFF4499FF海员达布隆币|r）", color = "unique" },
        { coord = 54337261, icon = 1044996, text = "佩佩", title = "潜水头盔佩佩", info = "凯瑟琳的猫之家，进门左边鱼缸里拾取|cFF00FF00微型潜水盔|r", color = "unique" },
        { coord = 77181647, icon = 2437249, text = "拆解", title = "自动拆解机1000型", color = "special" },
        { coord = 67522154, icon = 2012311, text = "海军部", title = "普罗德摩尔海军部军需官", info = "供给官芙蕾：出售以下商品\n\n5款家宅装饰\n\n玩具|cFF00FF00豺狼人标靶木桶|r\n\n坐骑|cFF00FF00海军骏马缰绳/普罗德摩尔观潮狮鹫缰绳|r", color = "quartermaster" },
        { coord = 68972470, icon = 2024072, text = "◆第七军团", title = "第七军团军需官", info = "守备官嘉兰娜", color = "quartermaster", textA = "RIGHT" },
        { coord = 56352603, icon = 1455894, text = "PVP商人◆", title = "海歌船屋", info = "专业联络人布拉格尼/利丹·古斯塔夫：PVP图纸配方\n\n副指挥官加布里埃尔元帅：旅店/争霸版本3个赛季PVP套装（|cFF4499FF荣耀印记|r）", color = "pvp", textA = "LEFT" },
        -- 副本
        { coord = 70493550, text = "达萨罗之战", color = "instance" }
    },

    --------------------------------------------------------------------------------
    -- 贝拉梅斯
    --------------------------------------------------------------------------------
    [2239] = {
        group = "Belamath",
        -- 传送
        { coord = 55326473, icon = 237556, text = "◆暴风/其他", title = "暴风城/黑海岸/海加尔山/瓦尔莎拉传送门", info = "暴风城传送门在左边亭子里，其他3个传送门在右边房间里", color = "portal", textA = "RIGHT" },
        -- 主要
        { coord = 48295403, icon = 134414, text = "旅店/附魔/烹饪/兽栏/商人◆", title = "旅店/附魔训练师/烹饪训练师/兽栏/杂货商", info = "塞琳尼/附魔师法尔林·树影/阿雷贡/阿拉辛\n\n艾兰蒂斯：出售7款家宅装饰（|cFF4499FF巨龙群岛补给|r）", color = "inn", tags = { "inn", "profession", "stable", "vendor" }, textA = "LEFT" },
        -- 专业
        { coord = 52885592, icon = 4620673, text = "工程", title = "工程学训练师", info = "渡鸦工匠塔里尔", color = "profession", type = "Engineering" },
        { coord = 48196402, icon = 4620674, text = "钓鱼", title = "钓鱼训练师", info = "垂钓者阿斯坦娅", color = "profession", type = "Fishing" },
        { coord = 54736190, icon = 4620676, text = "◆铭文", title = "铭文训练师", info = "芬迪·达金", color = "profession", type = "Inscription", textA = "RIGHT" },
        { coord = 48825796, icon = 4620681, text = "裁缝", title = "裁缝训练师", info = "埃德尔鲁·夏叶", color = "profession", type = "Tailoring" },
        { coord = 54905941, icon = 4620669, text = "◆炼金/草药", title = "炼金术/草药学训练师", info = "泰兰希尔/艾什教授", color = "profession", type = { "Alchemy", "Herbalism" }, textA = "RIGHT" },
        { coord = 54576069, icon = 4620678, text = "制皮/剥皮/商人◆", title = "制皮/剥皮训练师/交易货物商人", info = "达丽亚娜/耶蕾娜·夜空\n\n迈斯林迪尔：出售2款家宅装饰（|cFF4499FF巨龙群岛补给|r）", color = "vendor", tags = { "profession", "vendor" }, textA = "LEFT" },
        { coord = 47895674, icon = 1392955, text = "珠宝/锻造/采矿◆", title = "珠宝加工/锻造/采矿训练师", info = "艾莎·银露/塞兰妮亚/帕莉亚蕾", color = "profession", type = { "Jewelcrafting", "Blacksmithing", "Mining" }, textA = "LEFT" },
        -- 其他
        { coord = 51426602, icon = 413588, text = "坐骑", title = "驯豹人", info = "莱兰奈：出售暗夜精灵种族坐骑猎豹", color = "collection" },
        { coord = 50165924, icon = 1109100, text = "动画", title = "过往先知", info = "女祭司瑟尔德雷：可观看|cFF00FF00贝拉梅斯的建立/伊瑟拉的离别/玛法里奥的归来|r3段动画", color = "special" },
        { coord = 46507063, icon = 4881291, text = "达纳苏斯◆", title = "达纳苏斯军需官", info = "月之女祭司娜萨拉：出售|cFF00FF00达纳苏斯战袍/披风/月银肩甲装饰品|r和1款家宅装饰（|cFF4499FF巨龙群岛补给|r）", color = "quartermaster", textA = "LEFT" }
    },

    -- ========================================================================================================================
    -- 部落
    -- ========================================================================================================================
    --------------------------------------------------------------------------------
    -- 奥格瑞玛
    --------------------------------------------------------------------------------
    [85] = {
        group = "Orgrimmar",
        -- 传送
        { coord = 48006260, text = "暗月马戏团", color = "vendor" },
        { coord = 39955091, icon = 135758, text = "月光林地◆", title = "月光林地传送门", info = "和赛纳里奥使者托尔·黑蹄对话（|cFF00FF00有海加尔守护者声望需求|r）", color = "portal", textA = "LEFT" },
        { coord = 43046470, icon = 135765, text = "雷霆崖", title = "通往雷霆崖的飞艇", color = "portal" },
        { coord = 50755557, icon = 135766, text = "幽暗城", title = "幽暗城传送门", color = "portal" },
        { coord = 50343738, icon = 237556, text = "其他传送门", title = "大地的裂变版本传送门", info = "通往海加尔山/暮光高地/瓦斯琪尔/奥丹姆/深岩之洲的传送门", color = "portal" },
        { coord = 70583092, icon = 132334, text = "搏击", title = "搏击俱乐部", color = "portal" },
        { coord = 38117537, icon = 237556, text = "同盟传送", title = "同盟种族传送门", color = "portal" },
        { coord = 47403926, icon = 462340, text = "托巴", title = "托尔巴拉德传送门", color = "portal" },
        { coord = 43966742, icon = 450907, text = "电梯", title = "上楼的电梯", color = "portal" },
        { coord = 49835040, icon = 450907, text = "电梯", title = "上楼的电梯", color = "portal" },
        { coord = 51196308, icon = 450907, text = "电梯", title = "上楼的电梯", color = "portal" },
        { coord = 44686237, text = "北风苔原", color = "portal" },
        { coord = 57428974, text = "传送大厅", color = "portal" },
        { coord = 52435328, text = "荆棘谷", color = "portal" },
        -- 主要
        { coord = 53637877, icon = 134414, text = "旅店", title = "旅店（力量谷）", info = "格雷什卡", color = "inn" },
        { coord = 32406476, icon = 134414, text = "旅店/兽栏/拍卖/银行◆", title = "旅店/兽栏/拍卖/银行（精神谷）", info = "希加姆比/克苏卡(1楼)\n\n拍卖/银行（2楼）", color = "inn", tags = { "inn", "stable", "service" }, textA = "LEFT" },
        { coord = 38894864, icon = 134414, text = "旅店/兽栏/剥皮/裁缝◆", title = "旅店/裁缝训练师/剥皮训练师/兽栏（智慧谷）", info = "米瓦娜/希瓦希·三羽\n\n雷恩托/伦托", color = "inn", tags = { "inn", "profession", "stable" }, textA = "LEFT" },
        { coord = 71304997, icon = 134414, text = "旅店", title = "旅店（荣誉谷）", info = "努法", color = "inn" },
        { coord = 40828011, icon = 134414, text = "旅店/烹饪/草药/克罗米◆", title = "旅店/烹饪训练师/草药训练师/克罗米（大使馆）", info = "缇兹娜·银杯/风苏/林地栽培者卡多斯\n\n克罗米：切换时间线", color = "inn", tags = { "inn", "profession", "special" }, textA = "LEFT" },
        { coord = 53987324, icon = 133784, text = "拍卖", title = "拍卖行（力量谷）", color = "official" },
        { coord = 41674887, icon = 133784, text = "拍卖", title = "拍卖行（智慧谷）", color = "official" },
        { coord = 66633627, icon = 133784, text = "拍卖", title = "拍卖行（荣誉谷）", color = "official" },
        { coord = 35857730, icon = 133784, text = "拍卖", title = "拍卖行（大使馆）", color = "official" },
        { coord = 48838319, icon = 413587, text = "银行", title = "银行及公会银行（力量谷）", color = "official" },
        { coord = 39904629, icon = 413587, text = "银行", title = "银行及公会银行（智慧谷）", color = "official" },
        { coord = 67585259, icon = 413587, text = "银行", title = "银行及公会银行（荣誉谷）", color = "official" },
        -- 专业
        { coord = 49067056, icon = 441139, text = "考古", title = "考古学训练师（室内1楼）", info = "贝洛克·辉刃", color = "profession", type = "Archaeology" },
        { coord = 55684577, icon = 4620669, text = "炼金", title = "炼金术训练师", info = "耶尔玛克", color = "profession", type = "Alchemy" },
        { coord = 40575024, icon = 4620670, text = "◆锻造", title = "锻造训练师（智慧谷）", info = "奥普诺·铁角", color = "profession", type = "Blacksmithing", textA = "RIGHT" },
        { coord = 76523453, icon = 4620670, text = "锻造", title = "锻造训练师（荣誉谷）", info = "奥克索斯·铁怒/伯古什/萨鲁·钢怒", color = "profession", type = "Blacksmithing" },
        { coord = 32246967, icon = 4620671, text = "烹饪", title = "烹饪训练师（精神谷）", info = "扎姆沙", color = "profession", type = "Cooking" },
        { coord = 53504958, icon = 4620672, text = "附魔", title = "附魔训练师（下层）（暗巷区）", info = "古丹", color = "profession", type = "Enchanting" },
        { coord = 56845654, icon = 4620673, text = "◆工程", title = "工程学训练师（下层）（暗巷区）", info = "罗克希克", color = "profession", type = "Engineering", textA = "RIGHT" },
        { coord = 37098473, icon = 4620673, text = "工程", title = "工程学训练师（大使馆）", info = "“杰克”·帕萨雷克·砸修", color = "profession", type = "Engineering" },
        { coord = 35176734, icon = 4620674, text = "钓鱼", title = "钓鱼训练师（精神谷）", info = "老恩姆贝托", color = "profession", type = "Fishing" },
        { coord = 66454192, icon = 4620674, text = "钓鱼", title = "钓鱼训练师（荣誉谷）", info = "鲁玛克", color = "profession", type = "Fishing" },
        { coord = 34836285, icon = 4620675, text = "草药", title = "草药学训练师（精神谷）", info = "加迪", color = "profession", type = "Herbalism" },
        { coord = 54295094, icon = 4620675, text = "草药", title = "草药学训练师（上层）（暗巷区）", info = "穆拉加", color = "profession", type = "Herbalism", },
        { coord = 55095587, icon = 4620676, text = "铭文", title = "铭文训练师（上层）（暗巷区）", info = "内罗格", color = "profession", type = "Inscription" },
        { coord = 39038551, icon = 4620679, text = "采矿", title = "采矿训练师（大使馆）", info = "蕾拉·碎石", color = "profession", type = "Mining" },
        { coord = 60745913, icon = 4620681, text = "裁缝", title = "裁缝训练师（暗巷区）", info = "玛加尔", color = "profession", type = "Tailoring" },
        { coord = 44927771, icon = 4620670, text = "◆锻造/采矿", title = "锻造/采矿训练师（力量谷）", info = "罗格/古恩托", color = "profession", type = { "Blacksmithing", "Mining" }, textA = "RIGHT" },
        { coord = 72313491, icon = 4620677, text = "珠宝/采矿◆", title = "珠宝加工/采矿训练师（荣誉谷）", info = "鲁格娜/马卡鲁", color = "profession", type = { "Jewelcrafting", "Mining" }, textA = "LEFT" },
        { coord = 60905489, icon = 4620678, text = "◆制皮/剥皮", title = "制皮/剥皮训练师（暗巷区）", info = "卡洛雷克/苏尔德", color = "profession", type = { "Leatherworking", "Skinning" }, textA = "RIGHT" },
        -- 其他
        { coord = 40346060, icon = 133801, text = "理发/外观◆", title = "理发店/眼镜外观兑换", info = "贝布莉·科弗库尔\n\n卡尼斯：出售5款|cFF00FF00眼镜外观|r", color = "service", textA = "LEFT" },
        { coord = 47647448, icon = 133564, text = "幻化", title = "幻化师（力量谷）", info = "织幻者祖姆基", color = "service" },
        { coord = 57926551, icon = 133564, text = "幻化", title = "幻化师/遗忘传说供应商（暗巷区）", info = "织幻者杜沙尔\n搜寻者克拉斯：出售|cFF00FF00丢失的老版本橙装|r", color = "service" },
        { coord = 48837605, icon = 4696085, text = "商栈", title = "商栈", info = "赞希里商栈/宠物幻化处", color = "service" },
        { coord = 38138713, icon = 1769016, text = "兽栏/裁缝◆", title = "兽栏/裁缝训练师（大使馆）", info = "赫恩·石羽/织魔者奥莉尔", color = "stable", tags = { "stable", "profession" }, textA = "LEFT" },
        { coord = 62153527, icon = 1769016, text = "兽栏/坐骑◆", title = "兽栏/驯狼者（荣誉谷）", info = "姆罗格\n\n奥古纳罗：出售兽人职业坐骑战狼", color = "stable", tags = { "stable", "collection" }, textA = "LEFT" },
        { coord = 38067808, icon = 413588, text = "坐骑", title = "三轮摩托商人", info = "卡尔·万金：出售地精种族坐骑三轮摩托", color = "collection" },
        { coord = 47995865, icon = 413588, text = "坐骑", title = "驭风者饲养员", info = "卓卡玛：出售双足飞龙坐骑", color = "collection" },
        { coord = 52555926, icon = 652131, text = "宠物", title = "战斗宠物训练师", info = "瓦佐克", color = "collection" },
        { coord = 48124686, icon = 647626, text = "宠物", title = "宠物部落气球任务", info = "珈珈：完成任务可以获得宠物|cFF00FF00部落气球|r", color = "collection" },
        { coord = 52928900, icon = 7449410, text = "家宅", title = "弗雷德里克的奇妙家具", info = "“第二把交椅”袍铎", color = "collection" },
        { coord = 48378114, icon = 7449410, text = "家宅", title = "促销装饰补给", info = "佳比：出售1款家宅装饰|cFF00FF00黑暗之门|r", color = "collection" },
        { coord = 47148002, icon = 514261, text = "公会", title = "公会商人/注册员/战袍商人", info = "古拉姆/乌特伦/伽雷尔：出售燃烧的远征版本的声望战袍", color = "vendor" },
        { coord = 48187177, icon = 1030900, text = "外观◆", title = "勇气/正义/传承正义军需官（室外2楼）", info = "杰姆斯瓦兹/贡娜/鲁戈克", color = "vendor", textA = "LEFT" },
        { coord = 35786854, icon = 237556, text = "◆传送/铭文", title = "传送门训练师/铭文训练师（2楼）（精神谷）", info = "观星者吉拉吉/犹尔曼", color = "special", tags = { "special", "profession" }, textA = "RIGHT" },
        { coord = 74914326, icon = 237556, text = "传送", title = "传送门训练师（1楼）（荣誉谷）", info = "拉茜丝蕾·金星", color = "special" },
        { coord = 74274432, icon = 894556, text = "经验锁定◆", title = "经验锁定（3楼）", info = "斯拉兹", color = "special", textA = "LEFT" },
        { coord = 43903941, icon = 1109100, text = "动画", title = "动画短片", info = "伊萨里奥斯勋爵：可观看巨龙之魂副本中|cFF00FF00击败死亡之翼的动画|r", color = "special" },
        { coord = 50165844, icon = 236681, text = "声望", title = "奥格瑞玛/暗矛/锈水财阀声望军需官", info = "石头守卫纳尔戈尔：出售奥格瑞玛战袍和1款家宅装饰\n\n勇土乌拉金：出售暗矛战袍\n\n弗里兹·维拉马尔：出售锈水财阀战袍", color = "quartermaster" },
        { coord = 68584025, icon = 255152, text = "火金派", title = "火金派军需官/龙龟饲养员", info = "门徒君思：出售火金派熊猫人战袍\n\n乌龟大师吴玳（对面）：出售熊猫人种族坐骑龙龟\n\n对附近的熊猫洛洛使用/love可获得道具|cFF00FF00魔力竹笋|r，使用后可变身同款熊猫，支持施法", color = "quartermaster" },
        { coord = 41847317, icon = 413588, text = "PVP坐骑◆", title = "战争坐骑军需官", info = "亡灵卫兵奈萨里安（|cFF4499FF邪气鞍座|r）\n\n狼骑兵波尔克（|cFF4499FF荣耀印记|r）", color = "pvp", textA = "LEFT" },
        { coord = 38137120, icon = 1455894, text = "PVP商人◆", title = "传说大厅", info = "石头守卫扎尔格/一等军士长霍拉麦：出售旧世界PVP装备/武器（|cFF4499FF荣耀印记|r）\n\n卫兵布莱恩·石皮：出售PVP宝石和2款战袍（|cFF4499FF荣耀印记|r）\n\n加尔拉：出售荣誉传家宝（|cFF4499FF荣耀印记|r）\n\n阿妮卡·梅莱:出售孵化候选者装备（|cFF4499FF荣誉点数|r）\n\n洛戈克：出售嗜血角斗士装备（|cFF4499FF荣耀印记|r）\n\n桃丽丝·沃兰休斯：出售第9赛季残忍角斗士装备和武器（|cFF4499FF荣耀印记|r）\n\n血卫士扎尔什：出售第10赛季冷酷角斗士装备和武器（|cFF4499FF荣耀印记|r）\n\n雷角中士：出售第11赛季灾变角斗士装备和武器（|cFF4499FF荣耀印记|r）\n\n军团士兵沃拉迪斯：3款宠物", color = "pvp", textA = "LEFT" },
        { coord = 63693285, icon = 236179, text = "木桩", title = "木桩（荣誉谷）", color = "pvp" },
        { coord = 62174848, icon = 236179, text = "木桩", title = "木桩（城墙上）", color = "pvp" }
    },

    [503] = { -- 奥格瑞玛：搏击俱乐部
        group = "Orgrimmar",
        { coord = 50872916, icon = 2737714, text = "搏击俱乐部", title = "搏击俱乐部军需官", info = "保尔·诺斯：出售坐骑/宠物/战袍/衬衣/传家宝/家宅装饰/传送到搏击俱乐部的戒指", color = "quartermaster" }
    },

    --------------------------------------------------------------------------------
    -- 雷霆崖
    --------------------------------------------------------------------------------
    [88] = {
        group = "ThunderBluff",
        -- 传送
        { coord = 15402567, icon = 135759, text = "奥格", title = "通往奥格瑞玛的飞艇", color = "portal" },
        -- 主要
        { coord = 45816471, icon = 134414, text = "旅店", title = "旅店", info = "帕拉", color = "inn" },
        { coord = 40405178, icon = 133784, text = "拍卖", title = "拍卖行", color = "official" },
        { coord = 47605859, icon = 413587, text = "银行", title = "银行", color = "official" },
        -- 专业
        { coord = 75042810, icon = 441139, text = "考古", title = "考古学训练师", info = "欧托·灰皮", color = "profession", type = "Archaeology" },
        { coord = 46623319, icon = 4620669, text = "炼金", title = "炼金术训练师", info = "本娜·冰蹄", color = "profession", type = "Alchemy" },
        { coord = 39385509, icon = 4620670, text = "锻造", title = "锻造训练师", info = "卡恩·石蹄", color = "profession", type = "Blacksmithing" },
        { coord = 50745311, icon = 4620671, text = "烹饪", title = "烹饪训练师", info = "阿丝卡·迷雾行者", color = "profession", type = "Cooking" },
        { coord = 45323849, icon = 4620672, text = "附魔", title = "附魔训练师", info = "泰戈·晨行者", color = "profession", type = "Enchanting" },
        { coord = 36065961, icon = 4620673, text = "工程", title = "工程学训练师", info = "工程师苍蹄", color = "profession", type = "Engineering" },
        { coord = 56134642, icon = 4620674, text = "钓鱼", title = "钓鱼训练师", info = "卡尔·迷雾行者", color = "profession", type = "Fishing" },
        { coord = 49964035, icon = 4620675, text = "草药", title = "草药学训练师", info = "克米恩·冰蹄", color = "profession", type = "Herbalism" },
        { coord = 28742088, icon = 4620676, text = "铭文", title = "铭文训练师", info = "波什金·哈比德尔（预见之池洞中）", color = "profession", type = "Inscription" },
        { coord = 34825397, icon = 4620677, text = "珠宝", title = "珠宝加工训练师", info = "娜哈莉·追云者", color = "profession", type = "Jewelcrafting" },
        { coord = 41494256, icon = 4620678, text = "制皮", title = "制皮训练师", info = "犹纳", color = "profession", type = "Leatherworking" },
        { coord = 34385784, icon = 4620679, text = "采矿", title = "采矿训练师", info = "布瑞克·石蹄", color = "profession", type = "Mining" },
        { coord = 44454315, icon = 4620680, text = "剥皮", title = "剥皮训练师", info = "莫兰塔", color = "profession", type = "Skinning" },
        { coord = 44514533, icon = 4620681, text = "裁缝", title = "裁缝训练师", info = "坦帕", color = "profession", type = "Tailoring" },
        -- 其他
        { coord = 45086024, icon = 1769016, text = "兽栏", title = "兽栏", info = "布尔鲁格", color = "stable" },
        { coord = 37446343, icon = 514261, text = "公会", title = "公会商人/注册员/战袍商人", info = "兰达·鸣角/克拉姆/瑟拉姆：出售燃烧的远征版本的声望战袍", color = "vendor" },
        { coord = 22471690, icon = 237556, text = "传送", title = "传送门训练师", info = "比尔吉特·克兰斯顿（预见之池洞中）", color = "special" },
        { coord = 47045021, icon = 255153, text = "雷霆崖", title = "雷霆崖军需官（圆柱顶层）", info = "卫兵图霍：出售雷霆崖战袍和1款家宅装饰", color = "quartermaster" },
        { coord = 57828317, icon = 236179, text = "木桩", title = "木桩", color = "pvp" }
    },

    --------------------------------------------------------------------------------
    -- 幽暗城
    --------------------------------------------------------------------------------
    [90] = {
        group = "Undercity",
        -- 传送
        { coord = 85271707, icon = 236778, text = "外域", title = "地狱火半岛传送门", color = "portal" },
        -- 主要
        { coord = 67733788, icon = 134414, text = "旅店/兽栏◆", title = "旅店/兽栏（上层）", info = "诺曼/安雅·玛尔雷", color = "inn", tags = { "inn", "stable" }, textA = "LEFT" },
        { coord = 71434666, icon = 133784, text = "拍卖", title = "拍卖行", color = "official" },
        { coord = 67555242, icon = 133784, text = "拍卖", title = "拍卖行", color = "official" },
        { coord = 64415240, icon = 133784, text = "拍卖", title = "拍卖行", color = "official" },
        { coord = 60484645, icon = 133784, text = "拍卖", title = "拍卖行", color = "official" },
        { coord = 60504171, icon = 133784, text = "拍卖", title = "拍卖行", color = "official" },
        { coord = 64393582, icon = 133784, text = "拍卖", title = "拍卖行", color = "official" },
        { coord = 67633589, icon = 133784, text = "拍卖", title = "拍卖行", color = "official" },
        { coord = 71514190, icon = 133784, text = "拍卖", title = "拍卖行", color = "official" },
        { coord = 65984409, icon = 413587, text = "银行", title = "银行及公会银行", color = "official" },
        -- 专业
        { coord = 75423770, icon = 441139, text = "考古", title = "考古学训练师", info = "亚当·霍萨克", color = "profession", type = "Archaeology" },
        { coord = 47777332, icon = 4620669, text = "炼金", title = "炼金术训练师", info = "赫伯特·哈尔希医生", color = "profession", type = "Alchemy" },
        { coord = 61273058, icon = 4620670, text = "锻造", title = "锻造训练师", info = "詹姆斯·范·布朗特", color = "profession", type = "Blacksmithing" },
        { coord = 62164490, icon = 4620671, text = "烹饪", title = "烹饪训练师（下层）", info = "尤奈斯·伯奇", color = "profession", type = "Cooking" },
        { coord = 61856139, icon = 4620672, text = "附魔", title = "附魔训练师", info = "拉文尼亚·克洛文", color = "profession", type = "Enchanting" },
        { coord = 76147404, icon = 4620673, text = "工程", title = "工程学训练师", info = "弗兰克林·洛伊德", color = "profession", type = "Engineering" },
        { coord = 80723126, icon = 4620674, text = "钓鱼", title = "钓鱼训练师", info = "阿曼德·克伦威尔", color = "profession", type = "Fishing" },
        { coord = 54024957, icon = 4620675, text = "草药", title = "草药学训练师", info = "马尔萨·奥列斯塔", color = "profession", type = "Herbalism" },
        { coord = 61065800, icon = 4620676, text = "铭文", title = "铭文训练师", info = "玛尔迦·帕克雷", color = "profession", type = "Inscription" },
        { coord = 70763072, icon = 4620681, text = "裁缝", title = "裁缝训练师", info = "乔瑟夫·格里高利", color = "profession", type = "Tailoring" },
        { coord = 56273687, icon = 4620677, text = "珠宝/采矿◆", title = "珠宝加工/采矿训练师", info = "内勒尔·费恩/布罗姆·基里安", color = "profession", type = { "Jewelcrafting", "Mining" }, textA = "LEFT" },
        { coord = 70155918, icon = 4620678, text = "◆制皮/剥皮", title = "制皮/剥皮训练师", info = "亚瑟·摩尔/基里安·哈根", color = "profession", type = { "Leatherworking", "Skinning" }, textA = "RIGHT" },
        -- 其他
        { coord = 69974658, icon = 133801, text = "理发◆", title = "理发店（上层）", info = "纳兹尼克·苏萨弗", color = "service", textA = "LEFT" },
        { coord = 69864371, icon = 514261, text = "公会", title = "公会商人/注册员/战袍商人（下层）", info = "金·霍恩/克里斯托弗·德库尔/迈瑞尔·普莱森斯：出售燃烧的远征版本的声望战袍", color = "vendor" },
        { coord = 78167563, icon = 135360, text = "传家宝", title = "传家宝管理员", info = "艾斯特蕾·根德瑞：出售传家宝/传家宝升级道具/各个地图玩具|cFF00FF00侦查地图|r", color = "vendor" },
        { coord = 84151555, icon = 237556, text = "传送", title = "传送门训练师", info = "莱克斯顿·莫泰姆", color = "special" },
        { coord = 63024900, icon = 255236, text = "幽暗城", title = "幽暗城军需官（上层）", info = "多纳尔德·亚当斯上尉：出售幽暗城战袍和2款家宅装饰", color = "quartermaster" },
        { coord = 55221587, icon = 236179, text = "木桩", title = "木桩", color = "pvp" }
    },

    --------------------------------------------------------------------------------
    -- 战争之矛
    --------------------------------------------------------------------------------
    [624] = {
        group = "Warspear",
        -- 传送
        { coord = 60805161, icon = 135759, text = "奥格", title = "奥格瑞玛传送门", color = "portal" },
        -- 主要
        { coord = 44974323, icon = 134414, text = "旅店", title = "旅店", info = "娜宁·晨光", color = "inn" },
        { coord = 54672562, icon = 133784, text = "拍卖", title = "拍卖行", color = "official" },
        { coord = 51376191, icon = 413587, text = "银行", title = "银行及公会银行", color = "official" },
        -- 专业
        { coord = 73613118, icon = 441139, text = "考古", title = "考古学训练师/考古碎片", info = "丽娜·碎轮\n\n瑟卡（墙外）：出售以下商品\n\n各种考古碎片，至少考古600（|cFF4499FF修复的遗物|r）\n\n|cFF00FF00德拉诺考古学家的地图|r：随机分布德拉诺挖掘场（需要|cFF00FF00鸦人流亡者|r声望崇拜）\n\n|cFF00FF00德拉诺考古学家的磁石|r：随机传送到德拉诺可用的挖掘场（需要|cFF00FF00鸦人流亡者|r声望崇拜）", color = "profession", type = "Archaeology" },
        { coord = 60952638, icon = 4620669, text = "炼金", title = "炼金术训练师", info = "克里斯托弗·柯西", color = "profession", type = "Alchemy" },
        { coord = 74073708, icon = 4620670, text = "锻造", title = "锻造训练师", info = "马兹顿·商齿", color = "profession", type = "Blacksmithing" },
        { coord = 45614487, icon = 4620671, text = "烹饪", title = "烹饪训练师（楼梯背后向下）", info = "盖伊·火眼", color = "profession", type = "Cooking" },
        { coord = 78735291, icon = 4620672, text = "附魔", title = "附魔训练师", info = "哈尼充", color = "profession", type = "Enchanting" },
        { coord = 71664031, icon = 4620673, text = "工程", title = "工程学训练师", info = "汉·跳箭", color = "profession", type = "Engineering" },
        { coord = 69121656, icon = 4620674, text = "钓鱼", title = "钓鱼训练师", info = "布里克斯·箭投", color = "profession", type = "Fishing" },
        { coord = 62683062, icon = 4620675, text = "草药", title = "草药学训练师", info = "安东尼·阿里安", color = "profession", type = "Herbalism" },
        { coord = 77084756, icon = 4620676, text = "铭文", title = "铭文训练师", info = "乔鲁晏", color = "profession", type = "Inscription" },
        { coord = 60243991, icon = 4620677, text = "珠宝", title = "珠宝加工训练师", info = "亚历山大·迅钢", color = "profession", type = "Jewelcrafting" },
        { coord = 49492785, icon = 4620678, text = "制皮", title = "制皮训练师", info = "布尔加·硬皮", color = "profession", type = "Leatherworking" },
        { coord = 79413532, icon = 4620679, text = "采矿", title = "采矿训练师", info = "姆格·石裂", color = "profession", type = "Mining" },
        { coord = 48703130, icon = 4620680, text = "剥皮", title = "剥皮训练师", info = "孔达尔·猎誓", color = "profession", type = "Skinning" },
        { coord = 59424281, icon = 4620681, text = "裁缝", title = "裁缝训练师", info = "塞莎·银血", color = "profession", type = "Tailoring" },
        -- 其他
        { coord = 58565293, icon = 133564, text = "幻化", title = "幻化师", info = "织幻者贾索尔", color = "service" },
        { coord = 77435949, icon = 1769016, text = "兽栏", title = "兽栏", info = "乌佳", color = "stable" },
        { coord = 42553642, icon = 1001490, text = "图纸", title = "要塞图纸商人", info = "托格·菲力克辛顿", color = "unique" },
        { coord = 66636426, icon = 1061300, text = "水晶", title = "埃匹希斯水晶商人", info = "共有6位，出售坐骑|cFF00FF00苔皮淡水兽|r/要塞追随者合约|cFF00FF00寻晨者鲁卡里斯|r", color = "unique" },
        { coord = 65295926, icon = 618858, text = "挑战", title = "黄金挑战商人（绝版）", info = "挑战者森弗吉\n\n|cFFEE8800作者描述：武器设计非常漂亮，当年错过了好可惜|r", color = "unique" },
        { coord = 59225019, icon = 237556, text = "传送", title = "传送门训练师", info = "萨麦尔·玫刃", color = "special" },
        { coord = 64196231, icon = 838813, text = "R币", title = "R币兑换", info = "命运扭曲者提拉尔：出售|cFF00FF00钢化命运印记|r", color = "special" },
        { coord = 54006092, icon = 236681, text = "声望", title = "霜狼兽人/鸦人流亡者/热砂军需官", info = "贝斯卡·赤牙：出售以下商品\n\n坐骑|cFF00FF00迅捷霜狼|r\n\n宠物|cFF00FF00霜狼幼崽|r\n\n玩具|cFF00FF00永久冰霜精华|r\n\n鸦语者斯奇加：出售以下商品\n\n坐骑|cFF00FF00暗鬃冲锋者|r\n\n宠物|cFF00FF00塞泰之子|r\n\n3款家宅装饰（|cFF4499FF金币+埃匹希斯水晶|r）\n\n米米·响泡：出售以下商品\n\n坐骑|cFF00FF00驯养的刀脊野猪|r\n\n宠物|cFF00FF00白色淡水兽幼崽/被捕获的森林幼苗|r", color = "quartermaster" },
        { coord = 49165493, icon = 1042727, text = "沃金", title = "沃金之矛军需官", info = "达兹里安：出售沃金之矛战袍/坐骑", color = "quartermaster" },
        { coord = 48585755, icon = 1455894, text = "PVP商人◆", title = "PVP商人", info = "原祖/好战/狂野争斗者/角斗士（|cFF4499FF荣耀印记|r）", color = "pvp", textA = "LEFT" },
        { coord = 69635638, icon = 236179, text = "木桩", title = "木桩", color = "pvp" }
    },

    --------------------------------------------------------------------------------
    -- 达萨罗
    --------------------------------------------------------------------------------
    [1165] = {
        group = "Dazaralor",
        -- 主要
        { coord = 48458796, icon = 134414, text = "旅店", title = "旅店（2层）", info = "古克古克\n\n|cFFEE8800作者吐槽：室外是“达萨罗”城市地图，室内是“祖达萨”区域地图，离谱|r", color = "inn" },
        { coord = 52438494, icon = 134414, text = "旅店", title = "旅店（3层）", info = "无情的希莫", color = "inn" },
        { coord = 34751160, icon = 134414, text = "旅店", title = "旅店（佐卡罗广场上）", info = "可悲的拉克尔", color = "inn" },
        { coord = 38651627, icon = 134414, text = "旅店", title = "旅店（佐卡罗广场下）", info = "保镖“铁手伙计”罗茜", color = "inn" },
        { coord = 52631722, icon = 134414, text = "旅店", title = "旅店（赞枢尔）", info = "塔努布", color = "inn" },
        { coord = 45034021, icon = 133784, text = "◆拍卖/拆解/工程", title = "拍卖行（工程限定）/拆解大师Mk1型/工程学训练师", color = "official", tags = { "official", "special", "profession" }, textA = "RIGHT" },
        -- 专业
        { coord = 42223797, icon = 4620669, text = "炼金", title = "炼金术训练师", info = "聪明的库玛莉", color = "profession", type = "Alchemy" },
        { coord = 52469044, icon = 4620671, text = "烹饪◆", title = "烹饪训练师（2层）", info = "豪查", color = "profession", type = "Cooking", textA = "LEFT" },
        { coord = 38091416, icon = 4620671, text = "烹饪", title = "烹饪训练师（2层）", info = "豪查", color = "profession", type = "Cooking" },
        { coord = 50522336, icon = 4620674, text = "钓鱼", title = "钓鱼训练师", info = "安静的塔莉", color = "profession", type = "Fishing" },
        { coord = 42103560, icon = 4620675, text = "草药", title = "草药学训练师", info = "贾登·弗拉", color = "profession", type = "Herbalism" },
        { coord = 42333971, icon = 4620676, text = "铭文", title = "铭文训练师", info = "记载者伽祖尔（工匠平台）", color = "profession", type = "Inscription" },
        { coord = 39201745, icon = 4620676, text = "铭文", title = "铭文训练师", info = "托可（佐卡罗广场）", color = "profession", type = "Inscription" },
        { coord = 36551789, icon = 4620681, text = "裁缝", title = "裁缝训练师", info = "米力奈·哈吉特", color = "profession", type = "Tailoring" },
        { coord = 43623830, icon = 4620670, text = "◆锻造/采矿", title = "锻造/采矿训练师", info = "掌炉者扎克阿尔/金匠西科特", color = "profession", type = { "Blacksmithing", "Mining" }, textA = "RIGHT" },
        { coord = 44073462, icon = 1392955, text = "◆裁缝/制皮/剥皮", title = "裁缝/制皮/剥皮训练师（工匠平台）", info = "耐心的品金/赞约/“快刀”拉娜", color = "profession", type = { "Tailoring", "Leatherworking", "Skinning" }, textA = "RIGHT" },
        -- 其他
        { coord = 47358105, icon = 133801, text = "理发", title = "理发店（2层）", info = "康纳·响痕", color = "service" },
        { coord = 54488849, icon = 133564, text = "◆幻化/R币", title = "幻化师/R币兑换（2层）", info = "织幻者哈伊里\n\n祖尔温：可用金币/职业大厅资源/荣耀印记兑换|cFF00FF00战痕命运印记|r", tags = { "service", "special" }, color = "service" },
        { coord = 47968914, icon = 1769016, text = "兽栏◆", title = "兽栏（3层）", info = "驭兽者苏佳妮", color = "stable", textA = "LEFT" },
        { coord = 45773630, icon = 1769016, text = "兽栏", title = "兽栏（巨擘封印）", info = "驭兽者卡拉塔克", color = "stable" },
        { coord = 55933236, icon = 652131, text = "宠物", title = "宠物商人（室内）", info = "快乐的霍罗阿：出售2款玩具和4款宠物", color = "collection" },
        { coord = 47739166, icon = 652131, text = "坐骑", title = "骆驼商人（2层）", info = "多哥：出售2款坐骑|cFF00FF00骆驼|r（需要|cFF00FF00拉穆卡恒|r声望崇拜）", color = "collection" },
        { coord = 48588709, icon = 652131, text = "坐骑◆", title = "坐骑商人（3层）", info = "塔路图：出售坐骑|cFF00FF00灰皮恐角龙|r和宠物|cFF00FF00失落的栉龙|r", color = "collection", textA = "LEFT" },
        { coord = 51229508, icon = 2565244, text = "勋章", title = "服役勋章兑换", info = "供给商穆克拉：出售以下商品（|cFF4499FF荣耀战团服役勋章|r）\n\n|cFF00FF00十地饮剂|r：可提升10%经验（等级不高于49级）\n\n5款传家宝\n\n7款家宅装饰\n\n2款披风幻化\n\n3款坐骑\n\n宠物|cFF00FF00坦基尔|r\n\n玩具|cFF00FF00凋零轰炸者|r\n\n戒指|cFF00FF00指挥官的战斗玺戒|r：传送到达萨罗", color = "unique" },
        { coord = 44479445, icon = 1604167, text = "海岛", title = "达布隆币商人/公海“打捞”专家", info = "泽塔佳船长：出售以下商品（|cFF4499FF海员达布隆币|r）\n\n3款帽子幻化\n\n玩具|cFF00FF00手锚/暴躁的螃蟹/瘤木冲浪板|r\n\n宠物|cFF00FF00猩红八爪鱼/白化观暮鸦|r\n\n坐骑|cFF00FF00咸水海马/泥翼信天翁|r\n\n1款家宅装饰\n\n基特船长：出售3款打捞品（|cFF4499FF海员达布隆币|r）", color = "unique" },
        { coord = 53018994, icon = 236456, text = "◆格里伏塔", title = "绝世宝物商人（3层）", info = "格里伏塔：出售玩具|cFF00FF00赞达拉人像护符|r（|cFF4499FF伪造的拉斯塔哈面具|r）", color = "unique", textA = "RIGHT" },
        { coord = 51833502, icon = 236179, text = "木桩", title = "木桩（室内）", color = "pvp" }
    },

    [1163] = { -- 达萨罗：巨擘封印
        group = "Dazaralor",
        -- 传送
        { coord = 73796238, icon = 135761, text = "银月城", title = "银月城传送门", color = "portal" },
        { coord = 73786992, icon = 135759, text = "奥格", title = "奥格瑞玛传送门", color = "portal" },
        { coord = 73717743, icon = 135765, text = "雷霆崖", title = "雷霆崖传送门", color = "portal" },
        { coord = 73588541, icon = 236829, text = "希利苏斯", title = "希利苏斯传送门", info = "需要|cFF00FF00切回当前时间线|r才能看到", color = "portal" },
        { coord = 62948538, icon = 3012072, text = "纳沙塔尔", title = "纳沙塔尔传送门", info = "需要|cFF00FF00做主线任务|r才能看到", color = "portal" },
        -- 主要
        { coord = 48757191, icon = 134414, text = "旅店", title = "旅店", info = "“美人”布丽琳", color = "inn" },
        { coord = 30526779, icon = 413587, text = "银行", title = "银行及公会银行", info = "|cFFEE8800作者吐槽：室外是“巨擘封印”地图，室内是“祖达萨”区域地图，直接退了2级，离谱|r", color = "official" },
        -- 专业
        { coord = 32003112, icon = 441139, text = "考古", title = "考古学训练师", info = "考察者阿勒琳达", color = "profession", type = "Archaeology" },
        -- 其他
        { coord = 66997347, icon = 237556, text = "传送", title = "传送门训练师", info = "首席传送师欧库勒斯", color = "special" }
    },

    [1164] = { -- 达萨罗：记载者大厅
        group = "Dazaralor",
        -- 专业
        { coord = 28524989, icon = 4620671, text = "烹饪", title = "烹饪训练师", info = "皇家大厨提萨拉", color = "profession", type = "Cooking" },
        { coord = 70493300, icon = 4620676, text = "铭文", title = "铭文训练师", info = "记载者基扎尼", color = "profession", type = "Inscription" },
        -- 其他
        { coord = 54213702, icon = 514261, text = "公会", title = "公会商人/注册员", info = "尤拉·天足/克林基利·腐拳", color = "vendor" },
        { coord = 67257151, icon = 2015853, text = "赞达拉帝国", title = "赞达拉帝国军需官", info = "纳塔哈卡塔：出售以下商品\n\n玩具|cFF00FF00聚会图腾|r\n\n坐骑|cFF00FF00钴蓝翼手龙缰绳/幽灵飞翼龙的缰绳|r", color = "quartermaster" },
        { coord = 68593071, icon = 397907, text = "随机本", title = "随机本", info = "埃浦：可排奥迪尔/达萨罗之战/风暴熔炉/永恒王宫/尼奥罗萨，觉醒之城的随机本", color = "instance" }
    },

    -- ========================================================================================================================
    -- 中立
    -- ========================================================================================================================
    --------------------------------------------------------------------------------
    -- 沙塔斯
    --------------------------------------------------------------------------------
    [111] = {
        group = "Shattrath",
        -- 传送
        { coord = 57234828, icon = 135763, text = "◆暴风", title = "暴风城传送门", color = "portal", textA = "RIGHT" },
        { coord = 56814887, icon = 135759, text = "奥格◆", title = "奥格瑞玛传送门", color = "portal", textA = "LEFT" },
        { coord = 48584201, icon = 236806, text = "奎岛", title = "奎尔丹纳斯岛传送门", color = "portal" },
        { coord = 74683144, icon = 4630413, text = "时光之穴◆", title = "时光之穴传送门", info = "和塞菲尔对话（需要|cFF00FF00时光守护者|r声望崇拜）", color = "portal", textA = "LEFT" },
        -- 主要
        { coord = 28294936, icon = 134414, text = "旅店", title = "旅店（奥尔多）", info = "旅店老板米娜蕾", color = "inn" },
        { coord = 56328155, icon = 134414, text = "旅店", title = "旅店（占星者）", info = "旅店老板海索恩", color = "inn" },
        { coord = 51192696, icon = 133784, text = "拍卖", title = "拍卖行（奥尔多）", color = "official" },
        { coord = 56896273, icon = 133784, text = "拍卖", title = "拍卖行（占星者）", color = "official" },
        { coord = 48092930, icon = 413587, text = "银行", title = "银行及公会银行（奥尔多）", color = "official" },
        { coord = 60176037, icon = 413587, text = "银行", title = "银行及公会银行（占星者）", color = "official" },
        -- 专业
        { coord = 62667033, icon = 441139, text = "考古", title = "考古学训练师", info = "搜寻者波杜鲁", color = "profession", type = "Archaeology" },
        { coord = 45632151, icon = 4620669, text = "炼金", title = "炼金术训练师（2层）（贫民窟）", info = "罗罗基姆", color = "profession", type = "Alchemy" },
        { coord = 69634268, icon = 4620670, text = "锻造", title = "锻造训练师（贫民窟）", info = "克拉度·利刃/祖拉·熔怒", color = "profession", type = "Blacksmithing" },
        { coord = 63106837, icon = 4620671, text = "烹饪", title = "烹饪训练师", info = "杰克·塔博尔", color = "profession", type = "Cooking" },
        { coord = 36022074, icon = 4620677, text = "珠宝", title = "珠宝加工训练师（奥尔多上）", info = "哈曼纳尔", color = "profession", type = "Jewelcrafting" },
        { coord = 63976590, icon = 4620680, text = "剥皮", title = "剥皮训练师（贫民窟）", info = "塞莫尔", color = "profession", type = "Skinning" },
        { coord = 38473015, icon = 4620669, text = "炼金/草药◆", title = "炼金术/草药学训练师（奥尔多）", info = "炼金师卡恩胡/吉嘉", color = "profession", type = { "Alchemy", "Herbalism" }, textA = "LEFT" },
        { coord = 38297097, icon = 4620669, text = "炼金/草药◆", title = "炼金术/草药学训练师（占星者）", info = "埃尔辛/草药学家奥莱拉", color = "profession", type = { "Alchemy", "Herbalism" }, textA = "LEFT" },
        { coord = 37663161, icon = 1392955, text = "◆工程/锻造", title = "工程/锻造训练师（奥尔多）", info = "技师米希拉/奥努度", color = "profession", type = { "Engineering", "Blacksmithing" }, textA = "RIGHT" },
        { coord = 43656509, icon = 1392955, text = "◆工程/锻造", title = "工程学/锻造训练师（占星者）", info = "工程师辛蓓/巴利尔", color = "profession", type = { "Engineering", "Blacksmithing" }, textA = "RIGHT" },
        { coord = 36294393, icon = 1392955, text = "◆铭文/附魔", title = "铭文/附魔训练师（奥尔多）", info = "记录员利迪欧/苏蕾", color = "profession", type = { "Inscription", "Enchanting" }, textA = "RIGHT" },
        { coord = 55747451, icon = 1392955, text = "铭文/附魔◆", title = "铭文/附魔训练师（占星者）", info = "抄写员兰罗尔/附魔师安蒂亚拉", color = "profession", type = { "Inscription", "Enchanting" }, textA = "LEFT" },
        { coord = 36034830, icon = 4620677, text = "◆珠宝/采矿", title = "珠宝加工（奥尔多下）/采矿训练师", info = "奈米哈/弗诺", color = "profession", type = { "Jewelcrafting", "Mining" }, textA = "RIGHT" },
        { coord = 58527511, icon = 4620677, text = "◆珠宝/采矿", title = "珠宝加工/采矿训练师（占星者）", info = "吉蕾布莉·银丝/韩里尔", color = "profession", type = { "Jewelcrafting", "Mining" }, textA = "RIGHT" },
        { coord = 67276742, icon = 1392955, text = "◆制皮/特殊裁缝", title = "制皮/暗纹/魔焰/月布裁缝训练师（贫民窟）", info = "达尔玛里/安迪恩·达克斯宾/金吉·斯比维尔/纳丝玛拉·月歌", color = "profession", type = { "Leatherworking", "Tailoring" }, textA = "RIGHT" },
        { coord = 41006334, icon = 1392955, text = "剥皮/裁缝/制皮◆", title = "剥皮/裁缝/制皮训练师（占星者）", info = "伊尔杜/米拉丽丝/戴恩瑞尔", color = "profession", type = { "Skinning", "Tailoring", "Leatherworking" }, textA = "LEFT" },
        { coord = 37452724, icon = 1392955, text = "剥皮/裁缝/制皮◆", title = "剥皮/裁缝/制皮训练师（奥尔多）", info = "德雷姆/编织者欧尔/库里姆", color = "profession", type = { "Skinning", "Tailoring", "Leatherworking" }, textA = "LEFT" },
        { coord = 43998965, icon = 1392955, text = "专业", title = "全专业技能（奥尔多）", info = "每个书柜代表一个专业，可学习外域专业技能和制作外域家宅装饰", type = { "Alchemy", "Blacksmithing", "Enchanting", "Engineering", "Herbalism", "Inscription", "Jewelcrafting", "Leatherworking", "Mining", "Skinning", "Tailoring" }, color = "profession" },
        -- 其他
        { coord = 28604777, icon = 1769016, text = "兽栏", title = "兽栏（奥尔多）", info = "奥尔鲁赫", color = "stable" },
        { coord = 55987999, icon = 1769016, text = "兽栏", title = "兽栏（占星者）", info = "伊苏瑞尔", color = "stable" },
        { coord = 23653284, icon = 1030900, text = "套装", title = "套装兑换（奥尔多）", info = "阿苏尔", color = "vendor" },
        { coord = 24882688, icon = 1030900, text = "套装", title = "套装兑换（奥尔多）", info = "克尔拉兰", color = "vendor" },
        { coord = 42419044, icon = 1030900, text = "套装◆", title = "套装兑换（占星者）", info = "阿罗迪斯·炎刃", color = "vendor", textA = "LEFT" },
        { coord = 44949168, icon = 1030900, text = "套装", title = "套装兑换（占星者）", info = "维恩娜·晨星", color = "vendor" },
        { coord = 65656926, icon = 236456, text = "◆格里伏塔", title = "绝世宝物商人", info = "格里伏塔", color = "unique", textA = "RIGHT" },
        { coord = 75443050, icon = 133786, text = "◆社交名媛", title = "社交名媛", info = "哈莉丝·西尔顿：出售以下商品\n\n背包|cFF00FF00“巨无霸”背包/便携黑洞|r\n\n2款戒指玩具", color = "unique", textA = "RIGHT" },
        { coord = 30773461, icon = 136149, text = "◆印记提交", title = "圣光护卫者阿德因", info = "提交|cFF00FF00萨格拉斯印记|r", color = "quartermaster", textA = "RIGHT" },
        { coord = 45208145, icon = 133378, text = "徽记提交◆", title = "魔导师菲亚琳", info = "提交|cFF00FF00日怒徽记/火翼徽记|r", color = "quartermaster", textA = "LEFT" },
        { coord = 47712575, icon = 236441, text = "奥尔多", title = "奥尔多军需官", info = "恩达尔林", color = "quartermaster" },
        { coord = 60516432, icon = 236449, text = "占星者", title = "占星者军需官", info = "恩努利尔", color = "quartermaster" },
        { coord = 62006882, icon = 463482, text = "贫民窟◆", title = "贫民窟军需官", info = "纳克杜", color = "quartermaster", textA = "LEFT" },
        { coord = 51004171, icon = 135026, text = "◆沙塔尔", title = "沙塔尔军需官", info = "奥玛多尔", color = "quartermaster", textA = "RIGHT", }
    },

    --------------------------------------------------------------------------------
    -- 达拉然（诺森德）
    --------------------------------------------------------------------------------
    [125] = {
        group = "DalaranNorthrend",
        -- 传送
        { coord = 40086277, icon = 135763, text = "暴风", title = "暴风城传送门", color = "portal" },
        { coord = 55332544, icon = 135759, text = "奥格◆", title = "奥格瑞玛传送门", color = "portal", textA = "LEFT" },
        { coord = 33676863, icon = 237021, text = "冬拥湖", title = "冬拥湖传送门（联盟）", color = "portal" },
        { coord = 58082582, icon = 237021, text = "冬拥湖", title = "冬拥湖传送门（部落）", color = "portal" },
        { coord = 25974419, icon = 1536440, text = "天台", title = "紫罗兰天台传送门", info = "通往紫罗兰城堡顶层的紫罗兰天台", color = "portal" },
        { coord = 35324526, icon = 134324, text = "下水道", title = "下水道入口（左）", color = "portal" },
        { coord = 60214764, icon = 134324, text = "下水道", title = "下水道入口（右）", color = "portal" },
        -- 主要
        { coord = 50253952, icon = 134414, text = "旅店", title = "旅店（中立）", info = "艾米丝·埃索盖斯", color = "inn" },
        { coord = 44676333, icon = 134414, text = "旅店", title = "旅店（联盟）", info = "伊丝拉米·轻风", color = "inn" },
        { coord = 65633217, icon = 134414, text = "旅店", title = "旅店（部落）", info = "兽女乌达", color = "inn" },
        { coord = 38522511, icon = 133784, text = "拍卖", title = "蒸汽动力拍卖师", color = "official" },
        { coord = 37095479, icon = 133784, text = "拍卖/套装◆", title = "蒸汽动力拍卖师/传承正义军需官（银色领地2楼）", info = "布拉斯博特·机钳/5位传承正义军需官", color = "official", tags = { "official", "vendor" }, textA = "LEFT" },
        { coord = 65512345, icon = 133784, text = "◆拍卖/套装", title = "蒸汽动力拍卖师/传承正义军需官", info = "雷加纳德·弧炎/5位传承正义军需官", color = "official", tags = { "official", "vendor" }, textA = "RIGHT" },
        { coord = 43977693, icon = 413587, text = "银行", title = "银行及公会银行（联盟旁）", color = "official" },
        { coord = 52861801, icon = 413587, text = "银行", title = "银行及公会银行（部落旁）", color = "official" },
        -- 专业
        { coord = 48353820, icon = 441139, text = "考古", title = "考古学训练师", info = "博学者达瑞妮斯", color = "profession", type = "Archaeology" },
        { coord = 42653204, icon = 4620669, text = "炼金", title = "炼金术训练师", info = "林奇·黑箭", color = "profession", type = "Alchemy" },
        { coord = 44772854, icon = 4620670, text = "锻造", title = "锻造训练师", info = "奥兰德·夏菲尔/奥拉尔德·施米尔/伊曼蒂尔·锋歌", color = "profession", type = "Blacksmithing" },
        { coord = 40256612, icon = 4620671, text = "烹饪", title = "烹饪训练师（联盟）", info = "凯瑟琳·李\n\n德里克·奥斯：出售玩具|cFF00FF00大厨的帽子|r（|cFF4499FF美食家奖章|r）", color = "profession", type = "Cooking" },
        { coord = 69983900, icon = 4620671, text = "烹饪", title = "烹饪训练师（部落）", info = "埃维罗·隆古巴\n\n米森希：出售玩具|cFF00FF00大厨的帽子|r（|cFF4499FF美食家奖章|r）", color = "profession", type = "Cooking" },
        { coord = 39063982, icon = 4620672, text = "附魔", title = "附魔训练师", info = "附魔师纳萨尼斯", color = "profession", type = "Enchanting" },
        { coord = 39072659, icon = 4620673, text = "工程", title = "工程学训练师", info = "迪墨菲·欧申克/芬德尔·汽哨/钳工蒂迪", color = "profession", type = "Engineering" },
        { coord = 53046494, icon = 4620674, text = "钓鱼", title = "钓鱼训练师", info = "玛西娅·切斯", color = "profession", type = "Fishing" },
        { coord = 42933409, icon = 4620675, text = "草药", title = "草药学训练师", info = "多萝希·埃裉", color = "profession", type = "Herbalism" },
        { coord = 41603715, icon = 4620676, text = "铭文", title = "铭文训练师", info = "帕林教授", color = "profession", type = "Inscription" },
        { coord = 40673536, icon = 4620677, text = "珠宝", title = "珠宝加工训练师", info = "提莫斯·琼斯\n\n哈罗德·温斯顿：出售戒指|cFF00FF00肯瑞托戒指|r，可传送到达拉然", color = "profession", type = "Jewelcrafting" },
        { coord = 41492568, icon = 4620679, text = "采矿", title = "采矿训练师", info = "杰迪安·汉德尔斯", color = "profession", type = "Mining" },
        { coord = 36133355, icon = 4620681, text = "裁缝", title = "裁缝训练师/特殊裁缝商人", info = "查理·沃尔斯/月布裁缝专家埃德尔鲁·夏叶/魔焰裁缝专家兰尔拉·亮纹/暗纹裁缝专家琳娜·布鲁德", color = "profession", type = "Tailoring" },
        { coord = 34762842, icon = 4620678, text = "制皮/剥皮◆", title = "制皮/剥皮训练师", info = "蒂亚妮·坎宁斯/迪尔克·马克斯", color = "profession", type = { "Leatherworking", "Skinning" }, textA = "LEFT" },
        -- 其他
        { coord = 52283154, icon = 133801, text = "理发", title = "理发店", info = "吉兹·考波克利", color = "service" },
        { coord = 59633741, icon = 1769016, text = "兽栏", title = "兽栏", info = "塔西娅·幽谷", color = "stable" },
        { coord = 58833900, icon = 652131, text = "宠物", title = "宠物补给", info = "布琳妮：出售2款玩具和4款宠物", color = "collection" },
        { coord = 44814562, icon = 134508, text = "玩具", title = "玩具商人", info = "耶比托·乔巴斯/发条助手：出售多款玩具和宠物", color = "collection" },
        { coord = 58124208, icon = 413588, text = "坐骑", title = "特殊坐骑商人", info = "梅尔·弗兰希斯：出售多款坐骑，包括三人坐骑|cFF00FF00旅行者的苔原猛犸象|r", color = "collection" },
        { coord = 51205442, icon = 514261, text = "公会", title = "公会注册员/战袍商人", info = "安德鲁·马休/伊丽莎白·罗斯：出售巫妖王之怒版本的声望战袍", color = "vendor" },
        { coord = 37153795, icon = 1030900, text = "外观", title = "急救衬衣", info = "安吉莉克·巴特雷：出售2款|cFF00FF00绷带外观衬衣|r", color = "vendor" },
        { coord = 43494905, icon = 1030900, text = "套装", title = "套装兑换（布甲）", info = "帕尔蒂丝/鲁本·劳伦：出售布甲套装\n\n卡兰杜娜：出售16款衬衣", color = "vendor" },
        { coord = 46412668, icon = 1030900, text = "套装", title = "套装兑换（板甲）", info = "杜比·克雷/格里丝华尔德·哈兰德/霍莱斯·哈德兰：出售板甲套装", color = "vendor" },
        { coord = 38605555, icon = 1030900, text = "商人", title = "魔法货物（巫术姐妹店内）", info = "恩多拉·莫尔海德：出售以下商品\n\n法师技能|cFF00FF00神秘宝典：奥术语言|r\n\n法师技能|cFF00FF00神秘宝典：幻觉|r\n\n法师玩具|cFF00FF00魔宠石|r", color = "vendor" },
        { coord = 57475316, icon = 133939, text = "外观", title = "卖花女", info = "爱丽丝·普里洛斯：出售6款|cFF00FF00花朵副手外观|r", color = "vendor" },
        { coord = 40012834, icon = 135851, text = "冰冻", title = "冰冻宝珠商人", info = "鼎鼎有名的佛罗佐：出售材料和裁缝图样|cFF00FF00凝霜飞毯|r（|cFF4499FF冰冻宝珠|r）", color = "unique" },
        { coord = 56314673, icon = 237556, text = "传送", title = "传送门训练师", info = "大法师塞琳德拉\n\n点击后方水晶可传送至达拉然城外的紫罗兰哨站", color = "special" },
        { coord = 49774749, icon = 1109100, text = "动画", title = "动画短片", info = "雕像喷泉两侧的|cFF00FF00荣耀之碑|r：可观看冰冠堡垒副本中|cFF00FF00击败巫妖王的动画|r", color = "special" },
        { coord = 25214776, icon = 236693, text = "肯瑞托", title = "肯瑞托军需官", info = "大法师奥瓦利斯", color = "quartermaster" },
        { coord = 64165484, icon = 397907, text = "随机本", title = "随机本", info = "大法师提迈尔：可排翡翠梦魇/暗夜要塞/萨格拉斯之墓/燃烧王座的随机本\n\n|cFFEE8800作者吐槽：所以为什么诺森德达拉然会有军团达拉然的随机本NPC|r", color = "instance" },
        -- 副本
        { coord = 66396774, text = "紫罗兰监狱", color = "instance" }
    },

    [126] = { -- 达拉然（诺森德）：下水道
        group = "DalaranNorthrend",
        -- 主要
        { coord = 35465758, icon = 134414, text = "旅店", title = "旅店", info = "旅店老板埃因·格林", color = "inn" },
        { coord = 32515535, icon = 413587, text = "银行", title = "银行及公会银行", color = "official" },
        -- 其他
        { coord = 64171658, icon = 1030900, text = "商人", title = "魔法材料商人", info = "达拉希尔：出售1款宠物|cFF00FF00魅影精灵|r", color = "vendor" },
        { coord = 47362760, icon = 133740, text = "书商", title = "鬼祟的书商", info = "卡维兹·洛典：出售各种|cFF00FF00一部催人泪下的言情小说|r和萨满技能|cFF00FF00妖术书：蟑螂|r", color = "unique" },
        { coord = 59345822, icon = 1455894, text = "PVP商人", title = "PVP商人", info = "凶残/憎恨/致命/狂怒/无情/暴怒角斗士PVP商人", color = "pvp" }
    },

    --------------------------------------------------------------------------------
    -- 达拉然（破碎群岛）
    --------------------------------------------------------------------------------
    [627] = {
        group = "DalaranLegion",
        -- 传送
        { coord = 49474784, icon = 1536440, text = "守护者大厅", title = "守护者大厅", info = "可传送到龙眠神殿/达拉然巨坑/卡拉赞", color = "portal" },
        { coord = 39546318, icon = 135763, text = "暴风", title = "暴风城传送门", color = "portal" },
        { coord = 55262398, icon = 135759, text = "奥格", title = "奥格瑞玛传送门", color = "portal" },
        { coord = 34594553, icon = 134324, text = "下水道", title = "下水道入口（左）", color = "portal" },
        { coord = 59854790, icon = 134324, text = "下水道", title = "下水道入口（右）", color = "portal" },
        { coord = 74254931, text = "阿古斯", color = "portal" },
        -- 主要
        { coord = 49794013, icon = 134414, text = "旅店", title = "旅店（中立）", info = "艾米丝·埃索盖斯", color = "inn" },
        { coord = 44196374, icon = 134414, text = "旅店", title = "旅店（联盟）", info = "伊丝拉米·轻风", color = "inn" },
        { coord = 65423222, icon = 134414, text = "旅店", title = "旅店（部落）", info = "兽女乌达", color = "inn" },
        { coord = 43497742, icon = 413587, text = "银行", title = "银行及公会银行（联盟旁）", color = "official" },
        { coord = 52441805, icon = 413587, text = "银行", title = "银行及公会银行（部落旁）", color = "official" },
        -- 专业
        { coord = 41212644, icon = 441139, text = "考古", title = "考古学训练师", info = "博学者达瑞妮斯", color = "profession", type = "Archaeology" },
        { coord = 42043177, icon = 4620669, text = "炼金", title = "炼金术训练师", info = "林奇·黑箭/德崔斯·瓦德拉", color = "profession", type = "Alchemy" },
        { coord = 39706651, icon = 4620671, text = "烹饪", title = "烹饪训练师/烹饪订单（联盟）", info = "凯瑟琳·李\n\n诺米：可下达烹饪订单", color = "profession", type = "Cooking" },
        { coord = 69973895, icon = 4620671, text = "◆烹饪", title = "烹饪训练师/烹饪订单（部落）", info = "埃维罗·隆古巴\n\n诺米：可下达烹饪订单", color = "profession", type = "Cooking", textA = "RIGHT" },
        { coord = 39224093, icon = 4620672, text = "附魔/幻化◆", title = "附魔训练师/幻化师", info = "附魔师纳萨尼斯/织幻者图维斯", color = "profession", tags = { "profession", "service" }, textA = "LEFT" },
        { coord = 38812472, icon = 4620673, text = "工程", title = "工程学训练师", info = "迪墨菲·欧申克/钳工蒂迪", color = "profession", type = "Engineering" },
        { coord = 52836560, icon = 4620674, text = "钓鱼", title = "钓鱼训练师", info = "玛西娅·切斯", color = "profession", type = "Fishing" },
        { coord = 42343389, icon = 4620675, text = "草药", title = "草药学训练师", info = "莉亚娜·泰/奎茵·柔步", color = "profession", type = "Herbalism" },
        { coord = 41283705, icon = 4620676, text = "铭文", title = "铭文训练师", info = "帕林教授", color = "profession", type = "Inscription" },
        { coord = 40053529, icon = 4620677, text = "珠宝", title = "珠宝加工训练师/珠宝商人", info = "提莫斯·琼斯\n\n斯米克斯·璃目：出售戒指|cFF00FF00肯瑞托强化指环|r，可传送到达拉然", color = "profession", type = "Jewelcrafting" },
        { coord = 46092664, icon = 4620679, text = "采矿", title = "采矿训练师", info = "迪格丝大妈", color = "profession", type = "Mining" },
        { coord = 35003461, icon = 4620681, text = "裁缝", title = "裁缝训练师", info = "坦妮瑟娅", color = "profession", type = "Tailoring" },
        { coord = 35082943, icon = 4620678, text = "制皮/剥皮◆", title = "制皮/剥皮训练师", info = "娜穆·月水/蒂亚妮·坎宁斯/泰尼德·怒金\n孔达尔·猎誓", color = "profession", type = { "Leatherworking", "Skinning" }, textA = "LEFT" },
        -- 其他
        { coord = 51863166, icon = 133801, text = "理发", title = "理发店", info = "吉兹·考波克利", color = "service" },
        { coord = 59233762, icon = 1769016, text = "兽栏", title = "兽栏", info = "塔西娅·幽谷", color = "stable" },
        { coord = 58453916, icon = 652131, text = "◆宠物/哀嚎/死矿", title = "宠物商人/哀嚎洞穴/死亡矿井传送门", info = "达姆斯：出售6款宠物和玩具|cFF00FF00娜茜萨的镜子|r，让宠物变成你的样子\n\n缇菲·机簧（联盟）/吉雅达·金索（部落）：出售6款宠物和玩具|cFF00FF00魔法宠物镜|r，让你变成宠物的样子\n\n玛纳波夫：对话可传送到|cFF00FF00哀嚎洞穴/死亡矿井|r", color = "collection", textA = "RIGHT" },
        { coord = 43904662, icon = 134508, text = "玩具", title = "玩具商人", info = "耶比托·乔巴斯：出售多款玩具和宠物，包括玩具|cFF00FF00棱彩装饰|r", color = "collection" },
        { coord = 57614212, icon = 413588, text = "坐骑", title = "特殊坐骑商人", info = "梅尔·弗兰希斯：出售多款坐骑，包括三人坐骑|cFF00FF00旅行者的苔原猛犸象|r", color = "collection" },
        { coord = 43154909, icon = 7449410, text = "家宅", title = "艺术品商人", info = "拉希尔·火脉：出售1款家宅装饰|cFF00FF00“仰望天空”画作|r", color = "collection" },
        { coord = 50565513, icon = 514261, text = "公会", title = "公会注册员/战袍商人", info = "安德鲁·马休/伊丽莎白·罗斯：出售巫妖王之怒版本的声望战袍", color = "vendor" },
        { coord = 36013753, icon = 1030900, text = "外观", title = "急救衬衣", info = "安吉莉克·巴特雷：出售2款|cFF00FF00绷带外观衬衣|r", color = "vendor" },
        { coord = 50907303, icon = 1030900, text = "套装", title = "套装兑换（皮甲/锁甲）", info = "拉法尔·朗罗/瓦蕾莉·兰格鲁（皮甲套装兑换）\n玛蒂尔达·明火/布拉古德·明火（锁甲套装兑换）", color = "vendor" },
        { coord = 37285559, icon = 1030900, text = "套装", title = "套装兑换（布甲）", info = "帕尔蒂丝/布商：出售布甲套装\n\n萨兰·日线：出售16款|cFF00FF00衬衣|r\n\n理查德·哈特斯多克：出售2款|cFF00FF00头部幻化|r", color = "vendor" },
        { coord = 44743195, icon = 1417744, text = "血商", title = "血商", info = "伊尔妮雅·血棘：出售军团版本各种材料和职业大厅资源（|cFF4499FF萨格拉斯之血|r）", color = "unique" },
        { coord = 57115353, icon = 133939, text = "外观", title = "卖花女", info = "爱丽丝·普里洛斯：出售6款|cFF00FF00花朵副手外观|r", color = "vendor" },
        { coord = 48811361, icon = 1604168, text = "古怪硬币◆", title = "虚空宝库管理员", info = "苏伊奥斯：出售坐骑|cFF00FF00阿坎迪安战龟|r/玩具|cFF00FF00圣光微粒|r（商品随机刷新）", color = "unique" },
        { coord = 45172908, icon = 236521, text = "◆橙装/锻造", title = "橙装商人/锻造训练师", info = "奥法工匠维迪尔：出售军团版本全职业橙装（|cFF4499FF觉醒精华|r）/奥拉尔德·施米尔", color = "special", tags = { "unique", "profession" }, textA = "RIGHT" },
        { coord = 55994701, icon = 237556, text = "传送", title = "传送门训练师", info = "大法师塞琳德拉", color = "special" },
        { coord = 56906716, icon = 1604167, text = "R币", title = "R币兑换", info = "大法师兰达洛克：可用金币/职业大厅资源/荣耀印记兑换|cFF00FF00破碎命运印记|r", color = "special" },
        { coord = 25914458, icon = 134156, text = "动画/克罗米◆", title = "动画短片/场景战役", info = "罗伯特·纽哈斯：可观看|cFF00FF00伊利丹动画/卡德加动画|r\n\n克罗米的影像：可进入|cFF00FF00拯救克罗米|r场景战役，退出会被传送到诺森德龙眠神殿顶层", color = "special", textA = "LEFT" },
        { coord = 29197530, icon = 1455894, text = "PVP商人◆", title = "灰牙之地", info = "角斗士/争斗者/精锐PVP商人", color = "pvp", textA = "LEFT" },
        { coord = 56922819, icon = 1455894, text = "◆PVP商人", title = "风行者圣殿", info = "角斗士/争斗者/精锐PVP商人", color = "pvp", textA = "RIGHT" },
        { coord = 63605479, icon = 397907, text = "随机本", title = "随机本", info = "大法师提迈尔：可排翡翠梦魇/暗夜要塞/萨格拉斯之墓/燃烧王座的随机本", color = "instance" },
        -- 副本
        { coord = 65576746, text = "紫罗兰监狱", color = "instance" }
    },

    [628] = { -- 达拉然（破碎群岛）：下水道
        group = "DalaranLegion",
        { coord = 71401794, icon = 626190, text = "黑市", title = "黑市首领", info = "郭雅夫人", color = "official" },
        { coord = 58265750, icon = 652131, text = "宠物", title = "宠物商人", info = "劳拉·马利：出售宠物|cFF00FF00阴沟水母|r和2款制皮图样，学习后可制作玩具|cFF00FF00火圈/皮质宠物缰绳|r（|cFF4499FF盲目之眼|r）", color = "collection" },
        { coord = 46605613, icon = 801132, text = "商人", title = "凶狠的术士", info = "马修·莱比斯：出售铭文工艺图|cFF00FF00魔典：空灵领主|r，学习后可制作术士空灵领主宠物外观，并在理发店解锁（|cFF4499FF盲目之眼|r）", color = "vendor" },
        { coord = 66217418, icon = 801132, text = "商人", title = "魔法物品（2楼）", info = "达兹克·“普罗德摩尔”：出售裁缝图样|cFF00FF00衣柜：达拉然平民|r（|cFF4499FF盲目之眼|r）", color = "vendor" },
        { coord = 65578027, icon = 801132, text = "商人", title = "传送门与杂货（3楼）", info = "柯胡塔：出售附魔公式|cFF00FF00魔光火盆|r，学习后可制作玩具魔光火盆（|cFF4499FF盲目之眼|r）", color = "vendor" },
        { coord = 76108359, icon = 134743, text = "◆语言药剂", title = "语言药剂商人", info = "菲兹·电胆：出售|cFF00FF00语言药剂|r，可看懂敌对阵营说话", color = "unique", textA = "RIGHT" }
    },

    [629] = { -- 达拉然（破碎群岛）：守护者大厅
        group = "DalaranLegion",
        -- 传送
        { coord = 33867859, icon = 5927657, text = "◆泰洛古斯裂隙", title = "泰洛古斯裂隙传送门", color = "portal", textA = "RIGHT" },
        { coord = 64972109, icon = 237509, text = "达拉然", title = "达拉然传送门", color = "portal" },
        { coord = 30808433, icon = 236699, text = "龙眠神殿◆", title = "龙眠神殿传送门", color = "portal", textA = "LEFT" },
        { coord = 28787747, icon = 237508, text = "达拉然巨坑◆", title = "达拉然巨坑传送门", color = "portal", textA = "LEFT" },
        { coord = 32027155, icon = 1530372, text = "卡拉赞", title = "卡拉赞传送门", color = "portal" },
        -- 其他
        { coord = 33348447, icon = 3015740, text = "残忆", title = "残忆商人（绝版）", info = "怀念者阿穆尔", color = "unique" },
        { coord = 30588120, icon = 1033586, text = "升级", title = "物品升级", info = "库佐尔兹", color = "service" }
    },

    --------------------------------------------------------------------------------
    -- 奥利波斯
    --------------------------------------------------------------------------------
    [1670] = {
        group = "Oribos",
        -- 传送
        { coord = 20884570, icon = 135763, text = "暴风", title = "暴风城传送门", color = "portal" },
        { coord = 20885478, icon = 135759, text = "奥格", title = "奥格瑞玛传送门", color = "portal" },
        { coord = 57115035, icon = 450907, text = "上楼", title = "上楼", color = "portal" },
        { coord = 52104278, icon = 450907, text = "上楼", title = "上楼", color = "portal" },
        { coord = 47065035, icon = 450907, text = "上楼", title = "上楼", color = "portal" },
        { coord = 52105785, icon = 450907, text = "上楼", title = "上楼", color = "portal" },
        -- 主要
        { coord = 67465034, icon = 134414, text = "旅店", title = "旅店", info = "旅店老板塔·雷拉", color = "inn" },
        { coord = 60442939, icon = 413587, text = "银行", title = "银行", color = "official" },
        { coord = 65193601, icon = 413587, text = "◆公会银行", title = "公会银行", color = "official", textA = "RIGHT" },
        -- 专业
        { coord = 39244039, icon = 4620669, text = "炼金", title = "炼金术训练师", info = "炼药师奥·派尔", color = "profession", type = "Alchemy" },
        { coord = 40513147, icon = 4620670, text = "锻造", title = "锻造训练师", info = "匠人奥·伯克", color = "profession", type = "Blacksmithing" },
        { coord = 46822266, icon = 4620671, text = "烹饪", title = "烹饪训练师", info = "厨师奥·克鲁特", color = "profession", type = "Cooking" },
        { coord = 48392942, icon = 4620672, text = "附魔", title = "附魔训练师", info = "灌魔师奥·弗雷什", color = "profession", type = "Enchanting" },
        { coord = 38084474, icon = 4620673, text = "◆工程/拍卖", title = "工程学训练师/全息拍卖师（工程学限定）", info = "机械师奥·古尔/光子齿轮议价者", color = "profession", tags = { "profession", "official" }, textA = "RIGHT" },
        { coord = 46172636, icon = 4620674, text = "钓鱼", title = "钓鱼训练师/钓鱼商人", info = "寻回者奥·普林\n\n经销商奥·那格勒：出售|cFF00FF00“掮灵垂钓器”|r", color = "profession", type = "Fishing" },
        { coord = 40223827, icon = 4620675, text = "草药", title = "草药学训练师", info = "遴选师奥·玛尔", color = "profession", type = "Herbalism" },
        { coord = 36503670, icon = 4620676, text = "铭文", title = "铭文训练师", info = "抄写员奥·泰希", color = "profession", type = "Inscription" },
        { coord = 35234138, icon = 4620677, text = "珠宝", title = "珠宝加工训练师", info = "鉴定师奥·威森克", color = "profession", type = "Jewelcrafting" },
        { coord = 39303299, icon = 4620679, text = "采矿", title = "采矿训练师", info = "挖掘者奥·非尔", color = "profession", type = "Mining" },
        { coord = 45503178, icon = 4620681, text = "裁缝", title = "裁缝训练师", info = "缝合者奥·菲斯", color = "profession", type = "Tailoring" },
        { coord = 42172725, icon = 4620678, text = "制皮/剥皮◆", title = "制皮/剥皮训练师", info = "制革师奥·吉尔/剥皮者奥·克姆", color = "profession", type = { "Leatherworking", "Skinning" }, textA = "LEFT" },
        -- 其他
        { coord = 64456426, icon = 133801, text = "理发", title = "理发店", info = "美容师塔·维兹基", color = "service" },
        { coord = 64596988, icon = 133564, text = "幻化", title = "幻化师", info = "织幻者塔·奥伦", color = "service" },
        { coord = 34605652, icon = 1033586, text = "升级", title = "物品升级", info = "侵攻者佐·达什", color = "service" },
        { coord = 59237543, icon = 1769016, text = "兽栏", title = "兽栏", info = "守护者塔·沙兰", color = "stable" },
        { coord = 65176755, icon = 652131, text = "宠物", title = "宠物商人", info = "饲养者塔·希尔特：出售以下商品\n\n|cFF00FF00黄晶珠蜒/绿松石珠蜒/红宝石珠蜒|r（|cFF4499FF特定的灰色品质物品|r）\n\n|cFF00FF00无暇的紫晶珠蜒|r：概率提供彩虹飘带特效（|cFF4499FF宠物符咒|r）\n\n附魔公式|cFF00FF00心能活化宠物绳|r：学习后可制作同名玩具（|cFF4499FF宠物符咒|r）", color = "collection" },
        { coord = 23304897, icon = 237556, text = "传送", title = "传送门训练师", info = "传送代理商（仅法师可见）", color = "special" },
        { coord = 36176413, icon = 3257748, text = "格里恩", title = "格里恩", info = "文官阿得赖斯提斯", color = "special" },
        { coord = 42987418, icon = 3257749, text = "通灵领主◆", title = "通灵领主", info = "剑斗士米维克斯", color = "special", textA = "LEFT" },
        { coord = 39746089, icon = 3257750, text = "法夜", title = "法夜", info = "月莓女勋爵", color = "special" },
        { coord = 44856895, icon = 3257751, text = "温西尔", title = "温西尔", info = "德莱文将军", color = "special" },
        { coord = 79564985, icon = 1109100, text = "动画", title = "动画短片", info = "过往撰写师罗-艾德拉布：可观看|cFF00FF00暗影界的故事/仲裁官的故事|r2段动画", color = "special" },
        { coord = 47127771, icon = 3726261, text = "◆四大盟约", title = "盟约军需官", info = "四大盟约军需官出售以下通用商品\n\n1款宠物/1款坐骑/1款盟约武器附魔幻象/职业盟约雕文/道具|cFF00FF00深邃机遇容器|r：学会所有导灵器并提升至278等级（|cFF4499FF宇宙助溶剂|r）\n\n不朽军团军需官达尔·瓦提什：出售以下商品\n\n工程图纸|cFF00FF00结构图：虫洞发生器：暗影界|r，学习后可制作同名玩具\n\n背部幻化|cFF00FF00野蛮骨化之翼/死亡之像|r\n\n晋升者军需官副官米卡罗丝：出售以下商品\n\n玩具|cFF00FF00候选者担架|r\n\n工程图纸|cFF00FF00结构图：PHA7-YNX型灵豹|r，可制作同名宠物\n\n荒猎团军需官莉亚雯：出售以下商品\n\n铭文工艺图|cFF00FF00暮光符文牡鹿印记|r，学习后可制作德鲁伊旅行形态外观，并在理发店解锁\n\n背部幻化|cFF00FF00法夜纺织背包|r\n\n收割者之庭军需官朴素者达尔维：出售以下商品\n\n玩具|cFF00FF00罪钒茶具|r\n\n背部幻化|cFF00FF00微光金色罪碑锁链|r\n\n宣罪军需官档案员莉昂娜拉：出售以下商品（|cFF4499FF罪碑碎片|r）\n\n玩具|cFF00FF00迅捷背诵羽毛笔/粗俗仲裁者|r\n\n背部幻化|cFF00FF00地穴看守者的黝黑斗篷|r\n\n宠物|cFF00FF00档案员的羽毛笔|r", color = "quartermaster", textA = "RIGHT" },
        { coord = 35045814, icon = 1455894, text = "PVP商人◆", title = "PVP商人", info = "争端评估者承销商佐·库尔/争端大师佐·索尔格", color = "pvp", textA = "LEFT" },
        { coord = 41367144, icon = 397907, text = "随机本", title = "随机本", info = "塔·艾尔法：可排纳斯利亚堡/统御圣所/初诞者圣墓的随机本", color = "instance" }
    },

    [1671] = { -- 奥利波斯：转移之环
        group = "Oribos",
        --传送
        { coord = 49565159, icon = 3257863, text = "噬渊", title = "噬渊", info = "一跃而下", color = "portal" },
        { coord = 49582570, text = "扎雷殁提斯", color = "portal" },
        { coord = 30452288, text = "刻希亚", color = "portal" },
        -- 其他
        { coord = 60027110, icon = 3726261, text = "◆盟约道具", title = "传家宝掮灵", info = "奥·达拉：出售以下商品\n\n|cFF00FF00旅行者的心能宝箱|r：用于心能转移，可存战团银行（|cFF4499FF贮藏心能|r）\n\n|cFF00FF00掮灵的卓越印记|r：当前盟约直升60级\n\n|cFF00FF00无穷熏香|r：学会所有导灵器并提升至200等级\n\n|cFF00FF00时缚沉思|r：使一名盟约伙伴直升30级\n\n玩具|cFF00FF00侦察地图：深入暗影界|r", color = "unique", textA = "RIGHT" }
    },

    [1672] = { -- 奥利波斯：掮灵之居
        group = "Oribos",
        { coord = 50304318, icon = 236456, text = "格里伏塔◆", title = "绝世宝物商人", info = "格里伏塔|cFFEE8800\n\n作者吐槽：很多上千金的灰色时尚小垃圾|r", color = "unique", textA = "LEFT" }
    },

    --------------------------------------------------------------------------------
    -- 兵主之座
    --------------------------------------------------------------------------------
    [1698] = {
        group = "SanctumofDomination",
        -- 传送
        { coord = 56383154, icon = 3847780, text = "奥利波斯◆", title = "奥利波斯传送门", color = "portal", textA = "LEFT" },
        { coord = 56463705, icon = 237556, text = "造物", title = "六叠的隐居处，造物密院", color = "portal" },
        { coord = 61603772, icon = 237556, text = "锐眼", title = "努拉基尔，锐眼密院", color = "portal" },
        { coord = 62893425, icon = 237556, text = "◆泽雷克利斯", title = "泽雷克利斯：玛卓克萨斯", color = "portal", textA = "RIGHT" },
        { coord = 61553055, icon = 237556, text = "祭仪", title = "埃索拉玛斯，祭仪密院", color = "portal" },
        { coord = 58812311, icon = 237556, text = "瞭望台", title = "瞭望台，兵主之座", color = "portal" },
        -- 主要
        { coord = 46932996, icon = 134414, text = "旅店", title = "旅店", info = "塔巴尼·夜愿", color = "inn" },
        -- 其他
        { coord = 56274805, icon = 1033586, text = "升级", title = "物品升级", info = "淤肠", color = "service" },
        { coord = 60984648, icon = 3614361, text = "外观", title = "4难度纳斯利亚武器匠", info = "麦利萨·绝命/莫迪斯·艾尔弗森/泰亚·塔瑟雷/奥迪欧斯·谷欧", color = "vendor" },
        { coord = 46694238, icon = 1391776, text = "灵魂", title = "灵魂守护者", info = "奥斯伯恩·布莱克：灵魂用于升级盟约圣所", color = "special" },
        { coord = 52793829, text = "圣所升级", title = "圣所升级", color = "special" },
        { coord = 39164629, text = "指挥台", color = "special" },
        { coord = 37323413, text = "羁绊熔炉", color = "special" },
        { coord = 49663360, text = "心能导流器", color = "special" },
        { coord = 40452448, icon = 237523, text = "符文熔炉◆", color = "special", textA = "LEFT" },
        { coord = 52714107, icon = 3257749, text = "◆通灵领主", title = "通灵领主名望军需官", info = "苏·泽泰", color = "quartermaster", textA = "RIGHT" },
        { coord = 49689087, icon = 236179, text = "木桩", title = "木桩", color = "pvp" }
    },

    --------------------------------------------------------------------------------
    -- 堕罪堡
    --------------------------------------------------------------------------------
    [1699] = {
        group = "Sinfall",
        -- 传送
        { coord = 62532654, icon = 3847780, text = "◆奥利波斯", title = "奥利波斯传送门", color = "portal", textA = "RIGHT" },
        { coord = 36324833, icon = 450905, text = "下层", title = "通往堕罪堡下层深渊", color = "portal" },
        { coord = 17846124, icon = 450907, text = "上层", title = "通往堕罪堡上层地表", color = "portal" },
        { coord = 38076045, icon = 3257863, text = "噬渊", title = "噬渊传送门", info = "噬渊温西尔突袭激活时才可见", color = "portal" },
        { coord = 42024849, icon = 2103878, text = "蝙蝠", title = "堕罪地面飞行蝠", info = "点击蝙蝠可被带到地表", color = "portal" },
        { coord = 45264990, text = "永恒高台", color = "portal" },
        { coord = 41573764, text = "堕傲庄", color = "portal" },
        -- 主要
        { coord = 66783383, icon = 134414, text = "旅店", title = "旅店", info = "夜幕卫士薇克莱拉", color = "inn" },
        -- 其他
        { coord = 71522894, icon = 1769016, text = "兽栏", title = "兽栏", info = "瓦希利卡", color = "stable" },
        { coord = 47656132, icon = 133617, text = "镜面修复◆", title = "镜面修复工具", info = "西蒙妮：出售|cFF00FF00手工制作的镜面修复工具|r（|cFF4499FF注能红宝石|r）", color = "unique", textA = "LEFT" },
        { coord = 45432834, icon = 1391776, text = "灵魂", title = "灵魂守护者", info = "特纳瓦尔：灵魂用于升级盟约圣所", color = "special" },
        { coord = 55706222, text = "指挥台", color = "special" },
        { coord = 41481672, text = "羁绊熔炉", color = "special" },
        { coord = 55642629, text = "圣所升级", title = "圣所升级/温西尔名望军需官", info = "工头平指/艺人查其", color = "quartermaster" },
        { coord = 52575249, icon = 236179, text = "木桩", title = "木桩", color = "pvp" },
        { coord = 60185349, icon = 236179, text = "木桩", title = "木桩", color = "pvp" }
    },

    [1700] = { -- 堕罪堡：深渊
        group = "Sinfall",
        -- 传送
        { coord = 71053798, icon = 450907, text = "上层", title = "通往堕罪堡上层", color = "portal" },
        { coord = 71742140, text = "饲育者林地", color = "portal" },
        { coord = 59373700, text = "灾厄林", color = "portal" },
        { coord = 64155271, text = "赎罪大厅", color = "portal" },
        { coord = 80174860, text = "统御要塞", color = "portal" },
        -- 其他
        { coord = 73382480, icon = 1033586, text = "升级", title = "物品升级", info = "凯·耶尔莫", color = "service" },
        { coord = 53834640, icon = 3614361, text = "随机", title = "随机纳斯利亚武器匠", info = "夜幕卫士杰丝莱莎", color = "vendor" },
        { coord = 55385435, icon = 3614361, text = "普通", title = "普通纳斯利亚武器匠", info = "阿法纳斯勋爵", color = "vendor" },
        { coord = 45366531, icon = 3614361, text = "英雄", title = "英雄纳斯利亚武器匠", info = "纺尸者麦康奈尔", color = "vendor" },
        { coord = 40304631, icon = 3614361, text = "史诗", title = "史诗纳斯利亚武器匠", info = "沃帕莉雅", color = "vendor" },
        { coord = 70652741, icon = 3257751, text = "堕罪", title = "堕罪军需官", info = "“苍白之刃”格雷戈", color = "quartermaster" },
        { coord = 45425571, text = "心能导流器", color = "special" }
    },

    --------------------------------------------------------------------------------
    -- 森林之心
    --------------------------------------------------------------------------------
    [1701] = {
        group = "HeartoftheForest",
        -- 传送
        { coord = 51002025, icon = 237556, text = "传送", title = "通往蘑网之环/奥利波斯传送门", color = "portal" },
        { coord = 53763838, icon = 450907, text = "上层", title = "通往森林之心上层华盖", color = "portal" },
        -- 主要
        { coord = 54785617, icon = 134414, text = "旅店", title = "旅店", info = "科瓦林", color = "inn" },
        -- 其他
        { coord = 46945683, icon = 1033586, text = "升级", title = "物品升级", info = "工匠大师拉姆达", color = "service" },
        { coord = 33944351, icon = 1391776, text = "灵魂", title = "灵魂守护者", info = "翩翩：灵魂用于升级盟约圣所", color = "special" },
        { coord = 37982463, icon = 3586268, text = "形态", title = "灵魂变形形态", info = "曼恩女士/丘法：改变法夜盟约技能灵魂变形的形态外观", color = "special" },
        { coord = 40733292, text = "圣所升级", title = "圣所升级（下层）", color = "special" },
        { coord = 30338286, text = "指挥台", color = "special" },
        { coord = 32204751, text = "羁绊熔炉", color = "special" },
        { coord = 47003820, text = "心能导流器", title = "心能导流器（下层）", color = "special" },
        { coord = 54004129, text = "女王的温室", title = "女王的温室（下层）", color = "special" },
        { coord = 59483180, icon = 3257750, text = "◆荒猎团/法夜", title = "荒猎团/法夜名望军需官", info = "艾丝琳/艾尔雯", color = "quartermaster", textA = "RIGHT" },
        { coord = 40038075, icon = 236179, text = "木桩", title = "木桩", color = "pvp" },
        { coord = 53857865, icon = 236179, text = "木桩", title = "木桩", color = "pvp" }
    },

    [1702] = { -- 森林之心：树根
        group = "HeartoftheForest",
        -- 传送
        { coord = 59972849, icon = 3847780, text = "◆奥利波斯", title = "奥利波斯传送门", color = "portal", textA = "RIGHT" },
        { coord = 55382675, text = "蘑网之环", color = "portal" },
        -- 其他
        { coord = 49445400, icon = 3614361, text = "外观", title = "4难度纳斯利亚武器匠", info = "耀风/阿德拉/哈尔科斯/苏拉努姆", color = "vendor" },
        { coord = 39405427, text = "圣所升级", color = "special" },
        { coord = 47856131, text = "心能导流器", color = "special" },
        { coord = 57386556, text = "女王的温室", color = "special" }
    },

    [1819] = { -- 森林之心：蘑网之环
        group = "HeartoftheForest",
        -- 传送
        { coord = 58136202, text = "森林之心", color = "portal" },
        { coord = 59645287, text = "未知深域", color = "portal" },
        { coord = 57874261, text = "塞兹仙林", color = "portal" },
        { coord = 55693764, text = "沉静之林", color = "portal" },
        { coord = 50593634, text = "长者之地", color = "portal" },
        { coord = 46353709, text = "暮辉林地", color = "portal" },
        { coord = 41384216, text = "幽蓝树桩", color = "portal" },
        { coord = 38534954, text = "生命河床", color = "portal" },
        { coord = 39335517, text = "未知伟域", color = "portal" },
        { coord = 41586142, text = "森林之缘", color = "portal" },
        { coord = 46326597, text = "碎心岭", color = "portal" },
        { coord = 53506697, text = "戈姆之巢", color = "portal" },
        -- 其他
        { coord = 55695013, icon = 3257750, text = "军需官", title = "玛拉斯缪斯军需官", info = "柯迪纳留斯", color = "quartermaster" }
    },

    --------------------------------------------------------------------------------
    -- 极乐堡
    --------------------------------------------------------------------------------
    [1707] = {
        group = "ElysianHold",
        -- 传送
        { coord = 48796475, icon = 3847780, text = "◆奥利波斯", title = "奥利波斯传送门", color = "portal", textA = "RIGHT" },
        { coord = 48676173, text = "传送网络", color = "portal" },
        -- 主要
        { coord = 26353389, icon = 134414, text = "旅店", title = "旅店（上层）", info = "看护者卡林", color = "inn" },
        -- 其他
        { coord = 22793158, icon = 1769016, text = "兽栏", title = "兽栏（上层）", info = "野兽照看者克里斯塔", color = "stable" },
        { coord = 31314760, icon = 413588, text = "坐骑/宠物◆", title = "坐骑和宠物商人（上层）", info = "宾基罗斯/泽里斯科斯：需要解锁对应成就才能购买", color = "collection", textA = "LEFT" },
        { coord = 56538224, icon = 3614361, text = "外观", title = "4难度纳斯利亚武器匠（上层）", info = "凯丽·胡/阿里修斯/供应商普罗索斯/战斗大师恩迪欧斯", color = "vendor" },
        { coord = 42635313, text = "圣所升级", title = "圣所升级", color = "special" },
        { coord = 43334109, text = "指挥台", color = "special" },
        { coord = 60203520, text = "羁绊熔炉", color = "special" },
        { coord = 37606876, text = "心能导流器", title = "心能导流器", color = "special" },
        { coord = 28774057, text = "晋升之路", title = "晋升之路", color = "special" }
    },

    [1708] = { -- 极乐堡：羁绊圣所
        group = "ElysianHold",
        -- 其他
        { coord = 57373018, icon = 1033586, text = "升级", title = "物品升级（下层）", info = "铸手非罗", color = "service" },
        { coord = 59513418, icon = 1391776, text = "灵魂", title = "灵魂守护者（下层）", info = "灵魂向导戴丽雅：灵魂用于升级盟约圣所", color = "special", offsetY = 5 },
        { coord = 42635313, text = "圣所升级", title = "圣所升级", color = "special" },
        { coord = 43334109, text = "指挥台", color = "special" },
        { coord = 60203520, text = "羁绊熔炉", color = "special", },
        { coord = 37606876, text = "心能导流器", title = "心能导流器", color = "special" },
        { coord = 28774057, text = "晋升之路", title = "晋升之路", color = "special" },
        { coord = 63363052, icon = 3257748, text = "格里恩", title = "格里恩军需官（下层）", info = "副官伽罗斯", color = "quartermaster" }
    },

    --------------------------------------------------------------------------------
    -- 瓦德拉肯
    --------------------------------------------------------------------------------
    [2112] = {
        group = "Valdrakken",
        -- 传送
        { coord = 59774169, icon = 135763, text = "暴风/传送◆", title = "暴风城传送门/传送门训练师", info = "艾蕾苟萨", color = "portal", tags = { "portal", "special" }, textA = "LEFT" },
        { coord = 56653831, icon = 135759, text = "奥格", title = "奥格瑞玛传送门", color = "portal" },
        { coord = 61953214, icon = 237556, text = "顶层", title = "传送到守护巨龙之座（顶层）", color = "portal" },
        { coord = 62675729, icon = 1396974, text = "◆翡翠梦境", title = "翡翠梦境传送门", color = "portal", textA = "RIGHT" },
        { coord = 26094099, icon = 236716, text = "◆荒芜之地", title = "荒芜之地传送门", color = "portal", textA = "RIGHT" },
        -- 主要
        { coord = 47994878, icon = 134414, text = "旅店", title = "旅店", info = "玛琳斯", color = "inn" },
        { coord = 72504716, icon = 134414, text = "旅店", title = "旅店", info = "麦拉多尔米", color = "inn" },
        { coord = 43065961, icon = 133784, text = "拍卖", title = "拍卖行", color = "official" },
        { coord = 57605654, icon = 413587, text = "银行", title = "银行及公会银行", color = "official" },
        { coord = 15135294, icon = 626190, text = "黑市入口", title = "黑市入口（悬崖下方）", color = "official" },
        { coord = 20184917, icon = 626190, text = "黑市", title = "黑市首领", info = "郭雅夫人", color = "official" },
        -- 专业
        { coord = 36407169, icon = 4620669, text = "炼金", title = "炼金术训练师", info = "康弗拉苟", color = "profession", type = "Alchemy" },
        { coord = 36944663, icon = 4620670, text = "锻造", title = "锻造训练师", info = "塑金者库洛科", color = "profession", type = "Blacksmithing" },
        { coord = 46514624, icon = 4620671, text = "烹饪", title = "烹饪训练师", info = "艾鲁苟萨：出售2款|cFF00FF00单手锤外观|r", color = "profession", type = "Cooking" },
        { coord = 31056137, icon = 4620672, text = "附魔", title = "附魔训练师", info = "索拉苟萨", color = "profession", type = "Enchanting" },
        { coord = 42254863, icon = 4620673, text = "工程", title = "工程学训练师", info = "克林基克里克·碎轰", color = "profession", type = "Engineering" },
        { coord = 44827471, icon = 4620674, text = "钓鱼", title = "钓鱼训练师/渔具商人", info = "托克洛\n\n帕卡克：出售宠物|cFF00FF00小野鸭|r", color = "profession", tags = { "profession", "vendor" } },
        { coord = 37426835, icon = 4620675, text = "草药", title = "草药学训练师", info = "阿格里库斯", color = "profession", type = "Herbalism" },
        { coord = 38847342, icon = 4620676, text = "铭文", title = "铭文训练师", info = "塔伦达拉", color = "profession", type = "Inscription" },
        { coord = 40806111, icon = 4620677, text = "珠宝", title = "珠宝加工训练师", info = "图鲁拉多米", color = "profession", type = "Jewelcrafting" },
        { coord = 38905142, icon = 4620679, text = "采矿", title = "采矿训练师", info = "潜地者赛基塔", color = "profession", type = "Mining" },
        { coord = 32136626, icon = 4620681, text = "裁缝", title = "裁缝训练师", info = "寻线者帕克斯/寻线者弗拉冯", color = "profession", type = "Tailoring" },
        { coord = 28536086, icon = 4620678, text = "制皮/剥皮◆", title = "制皮/剥皮训练师", info = "塑皮者科鲁兹/粗犷的莱拉索尔", color = "profession", type = { "Leatherworking", "Skinning" }, textA = "LEFT" },
        -- 其他
        { coord = 30355284, icon = 133801, text = "理发", title = "理发店", info = "经营者瓦拉斯塔萨", color = "service" },
        { coord = 74455606, icon = 133564, text = "幻化", title = "幻化师", info = "织幻者达耶里斯", color = "service" },
        { coord = 34636155, icon = 1103069, text = "订单", title = "制造订单", info = "下达制造业订单", color = "service" },
        { coord = 45673825, icon = 1033586, text = "升级", title = "物品升级", info = "考尔克夏恩", color = "service" },
        { coord = 46747889, icon = 1769016, text = "兽栏", title = "兽栏", info = "凯斯塔兹：出售以下商品\n\n玩具|cFF00FF00宠物绳|r\n\n宠物|cFF00FF00吓人的箱子/滑鳗|r\n\n6款|cFF00FF00驭空术坐骑外观|r（|cFF4499FF巨龙版本材料+巨龙群岛补给|r）", color = "stable" },
        { coord = 48308293, icon = 652131, text = "宠物", title = "宠物补给", info = "莱辛德拉", color = "collection" },
        { coord = 74496315, icon = 652131, text = "宠物", title = "宠物商人", info = "园丁卡玛：出售2款|cFF00FF00始祖龙宠物|r（|cFF4499FF原始熊脊骨+巨大而坚硬的股骨+巨龙群岛补给|r）", color = "collection" },
        { coord = 36436299, icon = 1030900, text = "商人", title = "贸易协调员", info = "多赛诺斯：出售众多图纸配方，包含1款|cFF00FF00驭空术坐骑外观|r（|cFF4499FF巨龙群岛补给|r）", color = "vendor" },
        { coord = 33852769, icon = 1030900, text = "商人", title = "首席图书管理员", info = "黎波尔苟：出售法师雕文|cFF00FF00奥术魔宠雕文|r", color = "vendor" },
        { coord = 31616930, icon = 1030900, text = "外观", title = "外观兑换", info = "加耶拉：出售几款套装和副手幻化（|cFF4499FF巨龙版本材料+巨龙群岛补给|r）", color = "vendor" },
        { coord = 36045011, icon = 1030900, text = "外观", title = "外观兑换", info = "铸甲师泰里斯克：出售几款头部和肩膀幻化（|cFF4499FF巨龙版本材料+巨龙群岛补给|r）", color = "vendor" },
        { coord = 57922427, icon = 1030900, text = "外观", title = "园艺供应商", info = "园丁赛留丝：出售4款园艺造型武器幻化（|cFF4499FF彩虹珍珠+巨龙群岛补给|r）", color = "vendor" },
        { coord = 77543868, icon = 135360, text = "传家宝", title = "传家宝商人", info = "赫雷多穆：出售传家宝装备和武器60-70级升级道具", color = "vendor" },
        { coord = 73804552, icon = 4555657, text = "青铜锭", title = "古老的青铜锭（绝版）", info = "米莉欧辛：出售坐骑|cFF00FF00老基格沃斯先生|r和众多装备幻化（|cFF4499FF古老的青铜锭|r）\n\n|cFFEE8800作者描述：只有仍然拥有该货币的人才能看到兑换NPC|r", color = "unique" },
        { coord = 42804270, icon = 4638431, text = "◆血腥硬币", title = "血腥硬币商人（进门右边墙角）", info = "护战者格雷什：出售玩具|cFF00FF00恶龙克星的胜利旗帜|r（|cFF4499FF血腥硬币|r）", color = "unique", textA = "RIGHT" },
        { coord = 38113773, icon = 134388, text = "升级/元素◆", title = "物品升级/元素涌流商人", info = "艾尔扎\n\n密斯莱莎：出售以下商品（|cFF4499FF元素涌流|r）\n\n各职业|cFF00FF00狂怒风暴套装|r\n\n宠物|cFF00FF00魅火/斯托米|r\n\n坐骑|cFF00FF00雷革蝾螈|r", color = "unique", tags = { "service", "unique" }, textA = "LEFT" },
        { coord = 60264230, icon = 1109100, text = "◆动画", title = "动画短片（上楼右转）", info = "斯托里多米：可观看|cFF00FF00龙希尔的起源/奈萨里奥的陨落/巨龙的黎明|r3段动画", color = "special", textA = "RIGHT" },
        { coord = 25015070, icon = 4640486, text = "幻形", title = "幻形讲坛", color = "special" },
        { coord = 26074003, icon = 4638429, text = "泰坦圣物◆", title = "首席泰坦研究员", info = "索罗缇丝：用|cFF00FF00泰坦圣物|r兑换瓦德拉肯联军声望", color = "special", textA = "LEFT" },
        { coord = 35182464, icon = 4638531, text = "远古牢窟神器◆", title = "远古牢窟神器兑换", info = "莉莉安·明月：用|cFF00FF00远古牢窟神器|r兑换声望", color = "special", textA = "LEFT" },
        { coord = 58163521, icon = 4687630, text = "联军", title = "瓦德拉肯联军军需官", info = "乌纳托斯：出售众多图纸配方/幻化/宠物/家宅装饰/驭空术坐骑外观（|cFF4499FF巨龙版本材料+巨龙群岛补给|r）", color = "quartermaster" },
        { coord = 35425910, icon = 4557373, text = "工匠商盟◆", title = "工匠商盟军需官", info = "拉布尔：出售众多图纸配方和|cFF00FF00工匠商盟战袍|r（|cFF4499FF匠人之勇|r）", color = "quartermaster", textA = "LEFT" },
        { coord = 44313653, icon = 1455894, text = "PVP商人◆", title = "PVP商人", info = "征服/荣誉/精锐征服/战争模式军需官\n黑曜/苍郁/腾龙/猩红争斗者配方", color = "pvp", textA = "LEFT" },
        { coord = 43823961, icon = 236179, text = "木桩", title = "木桩", color = "pvp" }
    },

    --------------------------------------------------------------------------------
    -- 多恩诺嘉尔
    --------------------------------------------------------------------------------
    [2339] = {
        group = "Dornogal",
        -- 传送
        { coord = 41172269, icon = 237556, text = "◆卡雷什/暴风", title = "卡雷什/暴风城传送门", color = "portal", textA = "RIGHT" },
        { coord = 38162723, icon = 135759, text = "奥格", title = "奥格瑞玛传送门", color = "portal" },
        { coord = 53583868, text = "时间流", color = "portal" },
        { coord = 63625206, text = "艾基", color = "portal" },
        { coord = 35756022, text = "喧鸣深窟", color = "portal" },
        { coord = 73550530, text = "海妖岛", title = "海妖岛飞艇", info = "和天空船长卡贝克拉对话", color = "portal" },
        { coord = 52485045, text = "安德麦", color = "portal" },
        -- 主要
        { coord = 45204722, icon = 134414, text = "旅店", title = "旅店", info = "罗耐什", color = "inn" },
        { coord = 56754720, icon = 133784, text = "拍卖", title = "拍卖行", color = "official" },
        { coord = 53274426, icon = 413587, text = "银行", title = "银行及公会银行", color = "official" },
        { coord = 64765260, icon = 626190, text = "◆黑市", title = "黑市首领", info = "郭雅夫人", color = "official", textA = "RIGHT" },
        -- 专业
        { coord = 49066323, icon = 4620670, text = "锻造", title = "锻造训练师", info = "达利恩", color = "profession", type = "Blacksmithing" },
        { coord = 44194585, icon = 4620671, text = "烹饪", title = "烹饪训练师", info = "阿索达斯", color = "profession", type = "Cooking" },
        { coord = 52487135, icon = 4620672, text = "附魔", title = "附魔训练师", info = "纳嘉德", color = "profession", type = "Enchanting" },
        { coord = 49065608, icon = 4620673, text = "工程", title = "工程学训练师", info = "热力先知阿赫达斯", color = "profession", type = "Engineering" },
        { coord = 50492684, icon = 4620674, text = "钓鱼", title = "钓鱼训练师", info = "德罗卡", color = "profession", type = "Fishing" },
        { coord = 44766931, icon = 4620675, text = "草药", title = "草药学训练师", info = "阿克丹", color = "profession", type = "Herbalism" },
        { coord = 54455898, icon = 4620678, text = "制皮", title = "制皮训练师", info = "玛尔布", color = "profession", type = "Leatherworking" },
        { coord = 53035279, icon = 4620679, text = "采矿", title = "采矿训练师", info = "塔里布", color = "profession", type = "Mining" },
        { coord = 54455697, icon = 4620680, text = "剥皮", title = "剥皮训练师", info = "基纳德", color = "profession", type = "Skinning" },
        { coord = 54576342, icon = 4620681, text = "裁缝", title = "裁缝训练师", info = "科塔格", color = "profession", type = "Tailoring" },
        { coord = 48807092, icon = 1392955, text = "炼金/铭文/珠宝◆", title = "炼金/铭文/珠宝加工训练师", info = "塔里格/布里甘/马吉尔", color = "profession", type = { "Alchemy", "Inscription", "Jewelcrafting" }, textA = "LEFT" },
        -- 其他
        { coord = 58615264, icon = 133801, text = "理发", title = "理发店", info = "织线者格雷卡", color = "service" },
        { coord = 58074878, icon = 133564, text = "幻化", title = "幻化师", info = "织幻者戴基兰", color = "service" },
        { coord = 44645608, icon = 4696085, text = "商栈", title = "商栈", info = "安蒂·海髯/忒哈", color = "service" },
        { coord = 52054200, icon = 1033586, text = "升级", title = "物品升级", info = "库佐尔兹", color = "service" },
        { coord = 47864440, icon = 1064187, text = "地下堡", title = "地下堡行者总部", info = "雷诺·杰克逊（左）：出售地下堡外观（|cFF4499FF共鸣水晶|r）\n\n芬利·莫格顿爵士（右）：出售地下堡钥匙/道具/幻化/装备（|cFF4499FF晦幽铸币|r）", color = "service" },
        { coord = 58055645, icon = 1103069, text = "订单", title = "制造订单", info = "办事员格雷塔尔：下达制造业订单\n\n赛奈特（右1）：出售|cFF00FF00装备纹章|r和|cFF00FF00强化矩阵|r\n\n达拉·伏罗希（右2）：重置专业专精点（|cFF00FF00仅限1次|r）", color = "service" },
        { coord = 55366711, icon = 1769016, text = "兽栏", title = "兽栏", info = "卡尔甘德", color = "stable" },
        { coord = 58506486, icon = 652131, text = "宠物", title = "宠物商人", info = "埃拉尼：出售5款宠物", color = "collection" },
        { coord = 57266084, icon = 1030900, text = "套装", title = "套装商人", info = "欧斯迪恩：出售众多幻化套装（优先|cFF4499FF土壳宝石|r，其次|cFF4499FF共鸣水晶|r）\n\n乔里德（左1）：出售1款家宅装饰", color = "vendor" },
        { coord = 62575093, icon = 236456, text = "◆格里伏塔", title = "绝世宝物商人", info = "格里伏塔：出售以下商品\n\n|cFF00FF00始祖龟幸运符|r：重复性传送道具，传送到库尔提拉斯斯托颂谷地珍宝海岸\n\n|cFF00FF00灰羽护符|r：用来收集灰烬之羽\n\n|cFF00FF00格里伏塔的耐用抛光粉|r：可以洗去装备美化\n\n|cFF00FF00立方渎神石|r：珠宝图纸", color = "unique", textA = "RIGHT", offsetY = 4 },
        { coord = 60960530, icon = 4279015, text = "变形术", title = "变形术秘典", info = "进入燃火之厅和瓦莉拉·萨古纳尔对话完成任务，获得法师专属|cFF00FF00变形术秘典苔绒羱|r\n\n|cFFEE8800作者吐槽：米尔豪斯竟然在和瓦莉拉打炉石|r", color = "unique" },
        { coord = 50015414, icon = 2000852, text = "化生台", title = "化生台", info = "套装转化", color = "special" },
        { coord = 47976789, icon = 4640486, text = "幻形", title = "幻形讲坛", color = "special" },
        { coord = 39102417, icon = 5891369, text = "多恩议会◆", title = "多恩诺嘉尔议会军需官", info = "审计员巴乌尔兹", color = "quartermaster", textA = "LEFT" },
        { coord = 59825641, icon = 4557373, text = "◆工匠商盟", title = "工匠商盟军需官", info = "莱伦达尔：出售专业图纸配方（|cFF4499FF匠人之敏|r）", color = "quartermaster", textA = "RIGHT" },
        { coord = 55237685, icon = 1455894, text = "PVP商人", title = "配方/战争模式军需官/荣誉军需官", info = "霍萨恩：出售PVP装备配方和材料（|cFF4499FF荣誉点数|r）\n\n吉尔德兰：出售老兵等级PVP装备（|cFF4499FF血腥硬币|r）\n\n维勒尔德：出售探索者等级PVP装备和2款家宅装饰（|cFF4499FF荣誉点数|r）\n\n拉兰迪：出售勇士等级PVP装备（|cFF4499FF征服点数|r）", color = "pvp" },
        { coord = 59996972, icon = 1455894, text = "◆升级/PVP商人", title = "物品升级/精锐征服军需官/战争补给", info = "雷多尼尔：物品升级\n\n罗古恩：出售PVP武器外观（|cFF4499FF荣耀印记|r）\n\n玛尔拉：出售PVP药水和道具（|cFF4499FF荣誉点数|r）", color = "pvp", tags = { "service", "pvp" }, textA = "RIGHT" },
        { coord = 57677324, icon = 236179, text = "木桩", title = "木桩", color = "pvp" },
        -- 副本
        { coord = 31903569, text = "驭雷栖巢", color = "instance" }
    },

    [2266] = { -- 多恩诺嘉尔：千禧阈限
        group = "Dornogal",
        { coord = 40204880, icon = 5901551, text = "◆多恩诺嘉尔", title = "多恩诺嘉尔传送门", color = "portal", textA = "RIGHT" },
        { coord = 74424716, icon = 4062727, text = "塔扎维什", title = "塔扎维什传送门", info = "通往塔扎维什，纬纱集市", color = "portal" },
        { coord = 70447268, icon = 3551339, text = "雷文德斯", title = "雷文德斯传送门", info = "通往赎罪大厅", color = "portal" }
    },

    --------------------------------------------------------------------------------
    -- 千丝之城
    --------------------------------------------------------------------------------
    [2213] = {
        group = "CityofThreads",
        -- 主要
        { coord = 49782190, icon = 134414, text = "旅店", title = "旅店（上层）", info = "伊弗加瓦尔", color = "inn" },
        { coord = 57073948, icon = 134414, text = "旅店", title = "旅店（下层）", info = "遭嫌弃的艾里基", color = "inn" },
        -- 专业
        { coord = 45831356, icon = 4620669, text = "◆炼金/商人", title = "炼金术训练师", info = "夏尔巴\n\n炼金术供应商赛斯巴格：出售|cFF00FF00变形翻译药水：蛛魔语|r（|cFF4499FF刻基|r）", color = "profession", tags = { "profession", "vendor" }, textA = "RIGHT" },
        { coord = 47892464, icon = 4620671, text = "烹饪", title = "烹饪训练师", info = "调味厨师德鲁克", color = "profession", type = "Cooking" },
        { coord = 45583449, icon = 4620672, text = "附魔", title = "附魔训练师", info = "希尔拉菲", color = "profession", type = "Enchanting" },
        { coord = 57493275, icon = 4620673, text = "工程", title = "工程学训练师", info = "拉兰基", color = "profession", type = "Engineering" },
        { coord = 51432521, icon = 4620674, text = "钓鱼", title = "钓鱼训练师", info = "玛拉克罗兹", color = "profession", type = "Fishing" },
        { coord = 47271667, icon = 4620675, text = "草药", title = "草药学训练师", info = "卡瓦里斯", color = "profession", type = "Herbalism" },
        { coord = 41752648, icon = 4620676, text = "铭文", title = "铭文训练师", info = "奎尔", color = "profession", type = "Inscription" },
        { coord = 47771942, icon = 4620677, text = "◆珠宝/玩具", title = "珠宝加工训练师/商人", info = "格万罗\n\n珠宝加工供应商阿尔弗斯·瓦拉乌鲁:出售玩具|cFF00FF00爱蛛者眼镜语|r（|cFF4499FF刻基|r）", color = "profession", tags = { "profession", "collection" }, textA = "RIGHT" },
        { coord = 49721742, icon = 4620681, text = "裁缝", title = "裁缝训练师", info = "喜丝者瓦利", color = "profession", type = "Tailoring" },
        { coord = 46832256, icon = 4620670, text = "锻造/采矿◆", title = "锻造/采矿训练师", info = "麦尔/不倦的敏泰恩", color = "profession", type = { "Blacksmithing", "Mining" }, textA = "LEFT" },
        { coord = 43771960, icon = 4620678, text = "制皮/剥皮◆", title = "制皮/剥皮训练师", info = "戈什/法约尼", color = "profession", type = { "Leatherworking", "Skinning" }, textA = "LEFT" },
        -- 其他
        { coord = 44211713, icon = 652131, text = "宠物", title = "宠物商人", info = "巢穴之母马恩提克：出售2款宠物（|cFF4499FF刻基|r）", color = "collection" },
        { coord = 57334587, icon = 1030900, text = "套装", title = "套装兑换/商人（下层）", info = "阿布克萨/伊普克萨/基尔克萨：出售尼鲁巴尔王宫套装（|cFF4499FF至高探洞者的印记/裹网珍玩|r）\n\n止渴者阿夏拉萨拉：出售饮料|cFF00FF00元气饱满|r，进食充分后加速提高2点并且可以水上行走（|cFF4499FF刻基|r）", color = "vendor" },
        { coord = 63313823, icon = 651601, text = "彩虹茶", title = "向日葵先生的茶（下层）", info = "桌子上点击|cFF00FF00向日葵之茶|r，可获得获得|cFF00FF00彩虹拖尾特效|r（需要完成向日葵先生的任务，即可永久饮用）\n\n|cFFEE8800作者描述：玩具棱彩装饰同款效果，持续20分钟，使用任意传送都会消失|r", color = "special" },
        -- 副本
        { coord = 52164587, text = "回响之城", color = "instance" },
        { coord = 44181192, text = "千丝之城", color = "instance" },
        { coord = 35027249, text = "尼鲁巴尔王宫", color = "instance" },
        -- 地下堡
        { coord = 58716679, text = "幽暗要塞", color = "delve" },
        { coord = 07833386, icon = 5779390, text = "◆泽克维尔的巢穴", title = "宿敌地下堡", color = "delve", textA = "RIGHT" }
    },

    [2216] = { -- 千丝之城：下层
        group = "CityofThreads",
        -- 主要
        { coord = 57073948, icon = 134414, text = "旅店", title = "旅店（下层）", info = "遭嫌弃的艾里基", color = "inn" },
        -- 其他
        { coord = 57334587, icon = 1030900, text = "套装", title = "套装兑换/商人（下层）", info = "阿布克萨/伊普克萨/基尔克萨：出售团本尼鲁巴尔王宫套装（|cFF4499FF至高探洞者的印记/裹网珍玩|r）\n\n止渴者阿夏拉萨拉：出售饮料|cFF00FF00元气饱满|r，进食充分后加速提高2点并且可以水上行走（|cFF4499FF刻基|r）", color = "vendor" },
        { coord = 63313823, icon = 651601, text = "彩虹茶", title = "向日葵先生的茶（下层）", info = "桌子上点击|cFF00FF00向日葵之茶|r，可获得获得|cFF00FF00彩虹拖尾特效|r（需要完成向日葵先生的任务，即可永久饮用）\n\n|cFFEE8800作者描述：玩具棱彩装饰同款效果，持续20分钟，使用任意传送都会消失|r", color = "special" }
    },

    --------------------------------------------------------------------------------
    -- 安德麦
    --------------------------------------------------------------------------------
    [2346] = {
        group = "Undermine",
        -- 传送
        { coord = 17295076, icon = 5770812, text = "喧鸣深窟◆", title = "喧鸣深窟深沟钻机", info = "和卡莉·爽乘对话，通往喧鸣深窟", color = "portal", textA = "LEFT" },
        { coord = 18805221, icon = 2065640, text = "赞达拉", title = "赞达拉深沟钻机", info = "和比格兹·快道对话，通往祖达萨的卡亚海滨", color = "portal" },
        { coord = 27815405, text = "多恩诺嘉尔", color = "portal" },
        -- 主要
        { coord = 43515170, icon = 134414, text = "◆旅店/合约/军需官/套装", title = "旅店/财阀招募/安德麦财阀军需官/套装兑换（2楼右边）", info = "帕克斯·紧身：和NPC对话可单人剧情模式体验解放安德麦尾王\n\n凯蒂·板环：签订每周财阀声望\n\n专业论述（|cFF4499FF匠人之敏|r）\n\n坐骑|cFF00FF00紫罗兰装甲惊哮犬/紧身特快|r（|cFF4499FF共鸣水晶|r）\n\n4款家宅装饰（|cFF4499FF共鸣水晶|r）\n\n卡莉·炸桥：出售团本解放安德麦套装（|cFF4499FF浮华嵌宝珍玩|r）", color = "inn", tags = { "inn", "special", "quartermaster", "vendor" }, textA = "RIGHT" },
        { coord = 24464486, icon = 626190, text = "黑市", title = "黑市首领", info = "郭雅夫人", color = "official" },
        -- 其他
        { coord = 32128220, icon = 652131, text = "宠物", title = "战斗宠物训练师", info = "克里奇", color = "collection" },
        { coord = 59622725, icon = 652131, text = "宠物", title = "战斗宠物训练师", info = "普雷兹里·斩浪", color = "collection" },
        { coord = 43268284, icon = 413588, text = "坐骑", title = "坐骑商人", info = "斯凯吉特·烬轰：出售3款坐骑（|cFF4499FF混杂机械件|r）", color = "collection" },
        { coord = 24516333, icon = 1030900, text = "外观", title = "外观兑换", info = "格里希特·粗人：出售四大财阀|cFF00FF00战袍/护肩/头盔|r3种幻化，必须签订财阀声望才能购买对应声望的外观", color = "vendor" },
        { coord = 25753814, icon = 134757, text = "可乐罐", title = "S.C.R.A.P.交易", info = "安杰罗·锈桶：出售以下商品\n\n|cFF00FF00筛过的废料堆|r：可开出宠物和坐骑（|cFF4499FF空卡亚可乐罐/典藏卡亚可乐罐|r）\n\n玩具|cFF00FF00安德麦补给箱|r（|cFF4499FF空卡亚可乐罐|r）\n\n宠物|cFF00FF00咬碎者/小白鼠|r（|cFF4499FF典藏卡亚可乐罐|r）\n\nS.C.R.A.P.豪华清洁器（|cFF4499FF沾满污泥的物件|r）", color = "unique" },
        { coord = 34097129, icon = 533422, text = "金鱼", title = "钓鱼训练师/“金”鱼交易", info = "布莱尔·巴斯：出售3款鱼漂玩具和1款家宅装饰（|cFF4499FF“金”鱼|r）", color = "unique" },
        { coord = 37734706, text = "车辆改装", color = "special" },
        { coord = 39152220, icon = 6323357, text = "锈水", title = "绣水军需官", info = "洛可·笑轰：出售以下商品（|cFF4499FF共鸣水晶|r）\n\n玩具|cFF00FF00锈水财阀旗帜/盒装店面|r\n\n宠物|cFF00FF00锈水垃圾搬运工|r\n\n坐骑|cFF00FF00猩红装甲惊哮犬|r\n\n2款家宅装饰", color = "quartermaster" },
        { coord = 63431674, icon = 6323358, text = "黑水", title = "黑水军需官", info = "水手长哈迪：出售以下商品（|cFF4499FF共鸣水晶|r）\n\n玩具|cFF00FF00黑水财阀旗帜/私人捕鱼船|r\n\n宠物|cFF00FF00破浪机甲暴龙|r\n\n坐骑|cFF00FF00黑水伐木机尊享版MK2型|r\n\n2款家宅装饰", color = "quartermaster" },
        { coord = 27137257, icon = 6323359, text = "热砂", title = "热砂军需官", info = "实验室助理拉兹丽：出售以下商品（|cFF4499FF共鸣水晶|r）\n\n玩具|cFF00FF00热砂财阀旗帜/恒久诺格弗格药剂|r\n\n宠物|cFF00FF00艾匹|r\n\n坐骑|cFF00FF00钞绿色飞行器|r\n\n2款家宅装饰", color = "quartermaster" },
        { coord = 53317272, icon = 6323360, text = "风险", title = "风险军需官", info = "拆废者薛兹：出售以下商品（|cFF4499FF共鸣水晶|r）\n\n玩具|cFF00FF00风险投资公司旗帜/投掷锯刃|r\n\n宠物|cFF00FF00火箭拳|r\n\n坐骑|cFF00FF00黄褐运载火箭|r\n\n2款家宅装饰", color = "quartermaster" },
        { coord = 30743891, icon = 6124649, text = "暗索", title = "暗索军需官（下水道入口）", info = "希奇·内幕：出售以下商品\n\n|cFF00FF00一箱暗索杂物|r：开出声望道具（|cFF4499FF市场研究|r）\n\n幻化|cFF00FF00暗索内幕外套|r（|cFF4499FF共鸣水晶|r）\n\n2款家宅装饰（|cFF4499FF共鸣水晶|r）", color = "quartermaster" },
        -- 副本
        { coord = 41584878, text = "解放安德麦", color = "instance" },
        -- 地下堡
        { coord = 35215288, text = "闸板陋巷", color = "delve" },
        { coord = 50330942, text = "破拆穹顶", title = "宿敌地下堡", color = "delve" }
    },

    --------------------------------------------------------------------------------
    -- 塔扎维什
    --------------------------------------------------------------------------------
    [2472] = {
        group = "Tazavesh",
        -- 传送
        { coord = 50001947, icon = 1064187, text = "◆多恩诺嘉尔", title = "多恩诺嘉尔地下堡行者总部传送门", color = "portal", textA = "RIGHT" },
        { coord = 62579426, text = "多恩诺嘉尔", color = "portal" },
        { coord = 46845685, text = "相位", color = "portal" },
        -- 主要
        { coord = 41442482, icon = 134414, text = "旅店", title = "旅店", info = "巴·奥尔", color = "inn" },
        -- 专业
        { coord = 46021831, icon = 4620671, text = "烹饪", title = "烹饪训练师", info = "巴·迪巴拉", color = "profession", type = "Cooking" },
        -- 其他
        { coord = 43012875, icon = 133564, text = "幻化", title = "幻化师", info = "织幻者雅顿", color = "service" },
        { coord = 47412689, icon = 1769016, text = "兽栏", title = "兽栏", info = "巴·西姆塔尔", color = "stable" },
        { coord = 51865387, icon = 134508, text = "玩具", title = "异域玩具", info = "管理员威·卡：出售玩具|cFF00FF00柔软的泡沫塑料剑/静默耳塞|r", color = "collection" },
        { coord = 54315584, icon = 1392955, text = "◆采集兑换", title = "采集兑换", info = "欧·米特：兑换卡兹阿加基础草药（|cFF4499FF幻影蕾/卡雷什莲花|r）\n\n欧·米尤兹：兑换卡兹阿加基础矿石（|cFF4499FF凄棱石/卡雷什共鸣之石|r）", color = "vendor", textA = "RIGHT" },
        { coord = 54595833, icon = 133939, text = "外观", title = "异域花朵", info = "掮灵威·贝纳：出售6款|cFF00FF00花朵副手外观|r", color = "unique" },
        { coord = 53195412, icon = 133740, text = "◆书商", title = "异域书籍", info = "佐·法尔：出售各种|cFF00FF00一部催人泪下的言情小说|r", color = "unique", textA = "RIGHT" },
        { coord = 49453917, icon = 876371, text = "奸商", title = "奸商1号", info = "塔·莱克斯\n\n|cFFEE8800作者吐槽：就单纯想标记一下，比格里伏塔还过分的千金垃圾|r", color = "unique" },
        { coord = 43293549, icon = 876371, text = "奸商", title = "奸商2号", info = "塔·萨姆：出售1款家宅装饰|cFF00FF00财团收藏家的笼子|r\n\n|cFFEE8800作者吐槽：比奸商1号还过分的万金垃圾|r", color = "unique" },
        { coord = 39992966, icon = 6937965, text = "升级/托拉斯◆", title = "物品升级/卡雷什托拉斯名望军需官", info = "圣物匠赛·德斯\n\n欧·西里克：出售众多家宅装饰（|cFF4499FF共鸣水晶|r）\n\n", color = "quartermaster", tags = { "quartermaster", "service" }, textA = "LEFT" },
        -- 副本
        { coord = 36301217, text = "纬纱集市", color = "instance" },
        { coord = 43880399, text = "生态园顶", color = "instance" },
        -- 地下堡
        { coord = 38415117, text = "虚空之锋庇护所", title = "宿敌地下堡", color = "delve" }
    },

    --------------------------------------------------------------------------------
    -- 银月城（至暗之夜）
    --------------------------------------------------------------------------------
    [2393] = {
        group = "SilvermoonCityMidnight",
        -- 传送
        { coord = 52706528, text = "传送大厅", title = "暴风/奥格传送门/传送门训练师", info = "", color = "portal" },
        { coord = 42125831, icon = 4622479, text = "时间流", title = "时间流", color = "portal" },
        -- 主要
        { coord = 56467035, icon = 134414, text = "◆旅店/烹饪", title = "旅店/烹饪训练师（上层）", info = "约维娅/塞莱恩", color = "inn", tags = { "inn", "profession" }, textA = "RIGHT" },
        { coord = 51097610, icon = 133784, text = "拍卖", title = "拍卖行(下层)", color = "official" },
        { coord = 50816522, icon = 413587, text = "银行", title = "银行及公会银行", color = "official" },
        -- 专业
        { coord = 44836038, icon = 4620674, text = "钓鱼", title = "钓鱼训练师", info = "德拉森", color = "profession", type = "Fishing" },
        { coord = 43175565, icon = 4620678, text = "制皮/剥皮◆", title = "制皮/剥皮训练师", info = "塔尔玛/提恩", color = "profession", type = { "Leatherworking", "Skinning" }, textA = "LEFT" },
        { coord = 46915162, icon = 1392955, text = "◆铭文/炼金/草药", title = "铭文/炼金/草药学训练师", info = "赞塔希娅/卡博隆/植物学家娜萨兰", color = "profession", type = { "Inscription", "Alchemy", "Herbalism" }, textA = "RIGHT" },
        { coord = 47985365, icon = 1392955, text = "◆附魔/裁缝/珠宝", title = "附魔/裁缝/珠宝加工训练师", info = "多洛索斯/贾兰娜/埃米恩", color = "profession", type = { "Enchanting", "Tailoring", "Jewelcrafting" }, textA = "RIGHT" },
        { coord = 43655178, icon = 1392955, text = "工程/锻造/采矿◆", title = "工程/锻造/采矿训练师", info = "丹文\n波玛尔\n比利尔（室内）", color = "profession", type = { "Blacksmithing", "Engineering", "Mining" }, textA = "LEFT" },
        -- 其他
        { coord = 42257851, icon = 133801, text = "理发", title = "理发店", info = "墙上的镜子", color = "service" },
        { coord = 52865743, icon = 133564, text = "幻化", title = "幻化师", info = "织幻者迪弗尔拉", color = "service" },
        { coord = 45655557, icon = 1103069, text = "◆订单/工商/兽栏", title = "制造订单/工匠商盟军需官/兽栏管理员", info = "玛尔娜：下达制造业订单\n\n莱伦达尔：出售众多图纸配方（|cFF4499FF匠人之魄|r）\n\n塞拉菲娜·血心", color = "service", tags = { "service", "quartermaster", "stable" }, textA = "RIGHT" },
        { coord = 48937812, icon = 4696085, text = "商栈", title = "商栈（上层）", info = "珊迪·海髯/扎尔菈妮", color = "service" },
        { coord = 48656203, icon = 1033586, text = "升级", title = "物品升级", info = "库佐尔兹（进门右手边）", color = "service" },
        { coord = 52557827, icon = 1064187, text = "◆地下堡", title = "地下堡行者总部（上层）", info = "娜蕾迪亚·流光（左）：\n\n传送师阿斯特兰迪斯（右）：", color = "service", textA = "RIGHT" },
        { coord = 27267738, icon = 1769016, text = "兽栏", title = "兽栏", info = "沙尔蕾恩", color = "stable" },
        { coord = 41726638, icon = 1030900, text = "◆套装/传家宝", title = "套装商人/传家宝商人", info = "安德拉：出售众多幻化套装（|cFF4499FF华服资金|r|r）\n\n附魔师埃罗丁（左）：出售众多传家宝", color = "vendor", textA = "RIGHT" },
        { coord = 40386492, icon = 2000852, text = "化生台", title = "化生台", info = "套装转化", color = "special" },
        { coord = 52187367, icon = 4640486, text = "幻形", title = "幻形讲坛（上层）", color = "special" },
        { coord = 55766595, icon = 4554435, text = "狩猎", title = "痛苦名录/狩猎模式军需官/装饰专家（下层）", info = "痛苦名录：查看狩猎玩法等级\n\n狩猎模式军需官构造体瓦诺雷：出售坐骑/玩具/宠物/幻化/附魔公式/铭文家宅装饰工艺图（|cFF4499FF痛苦残渣|r和|cFF4499FF匠人之魄|r）\n\n装饰专家构造体阿里艾：出售众多家宅装饰，有成就限制（|cFF4499FF痛苦残渣|r）", color = "quartermaster" },
        { coord = 36258449, icon = 236179, text = "木桩", title = "木桩", color = "pvp" },
        -- 副本
        { coord = 57166099, text = "密谋小径", color = "instance" },
        -- 地下堡
        { coord = 40785411, text = "学府骚动", color = "delve" }
    },

    -- ========================================================================================================================
    -- 区域
    -- ========================================================================================================================
    --------------------------------------------------------------------------------
    -- 暗月马戏团
    --------------------------------------------------------------------------------
    [407] = {
        group = "Darkmoonfaire",
        { coord = 51232314, icon = 237556, text = "回程", title = "回程传送门", color = "portal" },
        { coord = 47766478, icon = 134508, text = "玩具", title = "纪念品与玩具商人", info = "吉瓦斯·格里加特：出售玩具/幻化/道具|cFF00FF00暗月大礼帽（10%经验加成）|r", color = "collection" },
        { coord = 48086953, icon = 413588, text = "藏品", title = "宠物与坐骑", info = "兰拉：出售3款坐骑和7款宠物", color = "collection" },
        { coord = 54335316, icon = 531974, text = "代币", title = "游戏代币商人", info = "吉娜·沙普沃斯", color = "vendor" },
        { coord = 48906175, icon = 531974, text = "代币", title = "游戏代币商人", info = "沙兹·吃币", color = "vendor", offsetY = -5 },
        { coord = 48947571, icon = 531974, text = "代币", title = "游戏代币商人", info = "崔克西·沙普沃斯", color = "vendor" },
        { coord = 54675867, icon = 134481, text = "门票", title = "过山车", info = "狄玫：对话购买门票，坐过山车可获得10%经验加成，最高持续1小时", color = "vendor" },
        { coord = 50475932, icon = 134481, text = "门票", title = "旋转木马", info = "狄珂：对话购买门票，坐旋转木马可获得10%经验加成，最高持续1小时", color = "vendor" },
        { coord = 47676672, icon = 135360, text = "传家宝/套装◆", title = "传家宝/幻化套装兑换", info = "迪兰德·晨峰/巴伦姆/巴伦玛", color = "vendor", textA = "LEFT" },
        { coord = 36545797, icon = 134757, text = "墨黑药水◆", title = "墨黑药水商人", info = "罗纳·绿齿：出售|cFF00FF00墨黑药水|r，使周围变黑2小时，可在场景过亮时使用", color = "unique", textA = "LEFT" },
        { coord = 48287194, icon = 134289, text = "焰火", title = "焰火商人", info = "波米·斯巴克：出售玩具|cFF00FF00XL号烟火小马|r", color = "unique" },
        { coord = 51497508, icon = 1030900, text = "外观", title = "礼服商人", info = "切斯特：出售几款|cFF00FF00礼服幻化|r和玩具|cFF00FF00见鬼的纪念品|r", color = "unique" },
        { coord = 52518874, icon = 237302, text = "◆钓鱼商人", title = "钓鱼奖品", info = "格丽萨·日露：出售坐骑|cFF00FF00暗水鳐鱼|r/玩具|cFF00FF00航海家的滑哨|r/暗月火酒/2款宠物和几款食谱（|cFF4499FF暗月刃喉鱼|r）", color = "unique", textA = "RIGHT" },
        { coord = 51896092, icon = 236669, text = "考古", title = "考古任务/暗月卡牌兑换", info = "萨杜斯·帕雷教授（考古材料：|cFF00FF00化石碎片x15|r）", color = "special" },
        { coord = 50536956, icon = 236669, text = "炼金", title = "炼金任务", info = "塞兰妮亚（炼金材料：|cFF00FF00月莓汁x5，泡沫饮料x5|r）", color = "special" },
        { coord = 51108206, icon = 236669, text = "锻造", title = "锻造任务", info = "亚布·尼比盖尔（锻造材料：|cFF00FF00铁砧x1|r）", color = "special" },
        { coord = 52916792, icon = 236669, text = "◆烹饪/钓鱼", title = "烹饪/钓鱼任务", info = "斯塔姆·雷角（烹饪材料：|cFF00FF00面粉x5|r）", color = "special", textA = "RIGHT" },
        { coord = 53237585, icon = 236669, text = "◆附魔/铭文", title = "附魔/铭文任务", info = "塞恪（铭文材料：|cFF00FF00轻羊皮纸x5|r）", color = "special", textA = "RIGHT" },
        { coord = 49256079, icon = 236669, text = "工程/制皮/采矿◆", title = "工程/制皮/采矿任务", info = "瑞林（制皮材料：|cFF00FF00蓝色染料x5，闪光的小珠x10，粗线x5|r）", color = "special", textA = "LEFT" },
        { coord = 55007078, icon = 236669, text = "◆草药/珠宝/剥皮", title = "草药/珠宝/剥皮任务", info = "克洛诺斯", color = "special", textA = "RIGHT" },
        { coord = 55565500, icon = 236669, text = "裁缝", title = "裁缝任务", info = "萨琳娜·杜洛曼（裁缝材料：|cFF00FF00红色染料x1，蓝色染料x1，粗线x1|r）", color = "special" },
    },

    [7] = { -- 暗月马戏团：莫高雷入口
        group = "Darkmoonfaire",
        { coord = 36843586, icon = 669449, text = "暗月马戏团", title = "入口传送门（每月一次）", info = "专业任务材料准备：\n\n考古：|cFF00FF00化石碎片x15|r\n\n炼金：|cFF00FF00月莓汁x5，泡沫饮料x5|r\n\n锻造：|cFF00FF00铁砧x1|r\n\n烹饪：|cFF00FF00面粉x5|r\n\n铭文：|cFF00FF00轻羊皮纸x5|r\n\n制皮：|cFF00FF00蓝色染料x5，闪光的小珠x10，粗线x5|r\n\n裁缝：|cFF00FF00红色染料x1，蓝色染料x1，粗线x1|r", color = "portal" }
    },

    [37] = { -- 暗月马戏团：闪金镇入口
        group = "Darkmoonfaire",
        { coord = 41796948, icon = 669449, text = "暗月马戏团", title = "入口传送门（每月一次）", info = "专业任务材料准备：\n\n考古：|cFF00FF00化石碎片x15|r\n\n炼金：|cFF00FF00月莓汁x5，泡沫饮料x5|r\n\n锻造：|cFF00FF00铁砧x1|r\n\n烹饪：|cFF00FF00面粉x5|r\n\n铭文：|cFF00FF00轻羊皮纸x5|r\n\n制皮：|cFF00FF00蓝色染料x5，闪光的小珠x10，粗线x5|r\n\n裁缝：|cFF00FF00红色染料x1，蓝色染料x1，粗线x1|r", color = "portal" }
    },

    --------------------------------------------------------------------------------
    -- 卡兹阿加
    --------------------------------------------------------------------------------
    [2248] = { -- 多恩岛
        group = "IsleofDorn",
        -- 传送
        { coord = 67333107, text = "喧鸣深窟", title = "通往喧鸣深窟的电梯", color = "portal" },
        { coord = 37407298, text = "喧鸣深窟", title = "通往喧鸣深窟的电梯", color = "portal", offsetY = 5 },
        -- 副本
        { coord = 45274112, text = "驭雷栖巢", color = "instance" },
        { coord = 76564380, text = "燧酿酒庄", color = "instance" },
        -- 地下堡
        { coord = 62124280, text = "克莱格瓦之眠", color = "delve" },
        { coord = 52046564, text = "真菌之愚", color = "delve" },
        { coord = 38587392, text = "地匍矿洞", color = "delve", offsetY = 0 }
    },

    [2214] = { -- 喧鸣深窟
        group = "TheRingingDeeps",
        -- 传送
        { coord = 72957320, icon = 2011121, text = "安德麦", title = "安德麦深沟钻机", info = "斯黛里亚：通往安德麦", color = "portal" },
        { coord = 44386614, icon = 450906, text = "艾基卡赫特", title = "通往艾基卡赫特的通道", color = "portal" },
        { coord = 36592404, text = "陨圣峪", title = "通往陨圣峪的通道", color = "portal" },
        { coord = 37442848, text = "多恩岛", title = "通往多恩岛的通道", color = "portal" },
        { coord = 49254460, text = "多恩岛", title = "通往多恩岛的电梯", color = "portal" },
        { coord = 61547695, text = "多恩岛", title = "通往多恩岛的电梯", color = "portal" },
        { coord = 42003032, text = "海妖岛", title = "通往海妖岛的钻探机", color = "portal" },
        -- 副本
        { coord = 42700857, text = "矶石宝库", color = "instance" },
        { coord = 55472163, text = "暗焰裂口", color = "instance" },
        { coord = 42103952, text = "水闸行动", color = "instance" },
        -- 地下堡
        { coord = 70173716, text = "恐惧陷坑", color = "delve" },
        { coord = 42164861, text = "水能堡", color = "delve" },
        { coord = 76009653, text = "九号挖掘场", color = "delve" }
    },

    [2215] = { -- 陨圣峪
        group = "Hallowfall",
        -- 传送
        { coord = 38297385, icon = 450905, text = "艾基卡赫特", title = "通往艾基卡赫特的通道", color = "portal" },
        { coord = 76706819, icon = 450905, text = "艾基卡赫特", title = "通往艾基卡赫特的通道", color = "portal" },
        { coord = 78664130, text = "喧鸣深窟", title = "通往喧鸣深窟的通道", color = "portal" },
        { coord = 81314479, text = "多恩岛", title = "通往多恩岛的通道", color = "portal" },
        -- 副本
        { coord = 41314934, text = "圣焰隐修院", color = "instance" },
        { coord = 54906316, text = "破晨号", color = "instance" },
        -- 地下堡
        { coord = 34294736, text = "夜幕圣所", color = "delve" },
        { coord = 50635326, text = "无底沉穴", color = "delve" },
        { coord = 71273125, text = "丝菌师洞穴", color = "delve" },
        { coord = 65436158, text = "飞掠裂口", color = "delve" }
    },

    [2255] = { -- 艾基卡赫特
        group = "AzjKahet",
        -- 传送
        { coord = 25623158, icon = 450907, text = "陨圣峪", title = "通往陨圣峪的通道", color = "portal" },
        { coord = 65221273, icon = 450907, text = "陨圣峪", title = "通往陨圣峪的通道", color = "portal" },
        { coord = 73452200, icon = 450908, text = "喧鸣深窟", title = "通往喧鸣深窟的通道", color = "portal" },
        { coord = 57364188, text = "多恩诺嘉尔", title = "多恩诺嘉尔传送门", color = "portal" },
        -- 副本
        { coord = 46776919, text = "千丝之城", color = "instance" },
        { coord = 49548108, text = "回响之城", color = "instance" },
        { coord = 43579031, text = "尼鲁巴尔王宫", color = "instance" },
        -- 地下堡
        { coord = 45041868, text = "螺旋织纹", color = "delve" },
        { coord = 54937372, text = "塔克雷桑深渊", color = "delve" },
        { coord = 51798818, text = "幽暗要塞", color = "delve" },
        { coord = 34097695, icon = 5779390, text = "泽克维尔的巢穴◆", title = "宿敌地下堡", color = "delve", textA = "LEFT" }
    },

    [2371] = { -- 卡雷什
        group = "KAresh",
        -- 传送
        { coord = 69368834, text = "多恩诺嘉尔", color = "portal" },
        { coord = 45212391, text = "相位", color = "portal" },
        { coord = 56202151, text = "相位", color = "portal" },
        { coord = 53922675, text = "相位", color = "portal" },
        { coord = 60212905, text = "相位", color = "portal" },
        { coord = 75883311, text = "相位", color = "portal" },
        { coord = 65444798, text = "相位", color = "portal" },
        { coord = 77174893, text = "相位", color = "portal" },
        { coord = 51214856, text = "相位", color = "portal" },
        { coord = 58905789, text = "相位", color = "portal" },
        { coord = 53846360, text = "相位", color = "portal" },
        { coord = 51386714, text = "相位", color = "portal" },
        { coord = 65898009, text = "相位", color = "portal" },
        -- 主要
        { coord = 76733443, icon = 134414, text = "◆旅店", title = "旅店", info = "欧·伏特", color = "inn", textA = "RIGHT" },
        { coord = 60722764, icon = 134414, text = "◆旅店/兽栏", title = "旅店/兽栏", info = "黑炉洛丝琳姆/虚空驯服者哈尔帕拉", color = "inn", tags = { "inn", "stable" }, textA = "RIGHT" },
        -- 其他
        { coord = 75603417, icon = 1392955, text = "采集兑换/钓鱼◆", title = "采集兑换/钓鱼训练师", info = "欧·雷卡：兑换卡兹阿加基础矿石（|cFF4499FF凄棱石/卡雷什共鸣之石|r）\n\n欧·科塔：兑换卡兹阿加基础草药（|cFF4499FF幻影蕾/卡雷什莲花|r）\n\n经销商巴·纳科尔", color = "vendor", tags = { "vendor", "profession" }, textA = "LEFT" },
        { coord = 50363630, icon = 135752, text = "披风/相位◆", title = "雷什裹布升级员/相位潜行商人", info = "哈希姆：领取披风及披风升级（|cFF4499FF虚灵丝线|r）\n\n莎德安妮丝：出售众多坐骑/宠物/幻化套装/玩具（|cFF4499FF无拘钱币|r）", color = "special", textA = "LEFT" },
        { coord = 41972253, icon = 6997112, text = "破袭队", title = "法力熔炉破袭队名望军需官", info = "收购者巴·赛欧姆（左1）：出售团本法力熔炉：欧米伽套装（|cFF4499FF饥渴虚空珍玩|r）\n\n巴·丘索（左2）：出售团本法力熔炉：欧米伽披风外观（|cFF4499FF织丝兽的流丝官|r）\n\n佐·图鲁（右1）：查看名望等级\n\n佐·罗伯（右2）：出售团本法力熔炉：欧米伽武器外观（|cFF4499FF虚灵精华残缕|r）", color = "quartermaster", tags = { "quartermaster", "vendor" }, offsetY = -5 },
        -- 副本
        { coord = 63597023, text = "纬纱集市", color = "instance" },
        { coord = 65286847, text = "生态园顶", color = "instance" },
        { coord = 41642148, text = "法力熔炉:欧米伽", color = "instance", offsetY = 5 },
        -- 地下堡
        { coord = 55104809, text = "档案馆", color = "delve" },
        { coord = 64037897, text = "虚空之锋庇护所", title = "宿敌地下堡", color = "delve" }
    },

    --------------------------------------------------------------------------------
    -- 奎尔萨拉斯
    --------------------------------------------------------------------------------
    [2395] = { -- 永歌森林
        group = "EversongWoods",
        -- 副本
        { coord = 35437879, text = "风行者之塔", color = "instance" },
        -- 地下堡
        { coord = 49062236, text = "学府骚动", color = "delve" },
        { coord = 45408607, text = "聚影领地", color = "delve" },
        { coord = 63788000, text = "阿塔阿曼", color = "delve" }
    },

    [2405] = { -- 虚影风暴
        group = "Voidstorm",
        -- 副本
        { coord = 51641880, text = "虚空之痕竞技场", color = "instance" },
        { coord = 64926172, text = "节点希纳斯", color = "instance" },
        { coord = 45216472, text = "虚影尖塔", color = "instance" },
        -- 地下堡
        { coord = 37134898, text = "影卫营", color = "delve" },
        { coord = 54794709, text = "戮日圣殿", color = "delve" }
    },

    [2424] = { -- 奎尔丹纳斯岛
        group = "IsleofQuelDanas",
        { coord = 52618529, text = "进军奎尔丹纳斯", color = "instance" },
        { coord = 63441536, text = "魔导师平台", color = "instance" }
    },

    [2437] = { -- 祖阿曼
        group = "ZulAman",
        -- 副本
        { coord = 43843948, text = "迈萨拉洞窟", color = "instance" },
        { coord = 29878444, text = "纳洛拉克的洞穴", color = "instance" },
        -- 地下堡
        { coord = 05495918, text = "聚影领地", color = "delve" },
        { coord = 24765296, text = "阿塔阿曼", color = "delve" },
        { coord = 25398437, text = "暮光地穴", color = "delve" },
    },

    [2413] = { -- 哈籁恩达尔
        group = "Harandar",
        -- 副本
        { coord = 26497803, text = "夺目谷", color = "instance" },
        { coord = 61416287, text = "梦境裂隙", color = "instance" },
        -- 地下堡
        { coord = 36244914, text = "回忆深沟", color = "delve" },
        { coord = 70466487, text = "憎怨斗坑", color = "delve" }
    },

}
