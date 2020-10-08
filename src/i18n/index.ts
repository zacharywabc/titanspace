const langs: Record<string, any> = {
  'zh-CN': {
    DEFI: 'DeFi系统',
    HOW_JOIN: '如何加入',
    ABOUT: '关于TSC',
    SLOGAN: '去中心化金融 + 智能化合约 + TRX，TSC双线收益',
    GLOBAL: '全球参与者',
    TLOCK: '总锁仓',
    TRELEASE: '总释放',
    JOIN: '加入',
    SMART: '智能合约',
    STAT: '个人统计信息',
    DYNAMIC: '个人本轮动态信息',
    CANCEL: '撤销',
    LOCK: '锁定',
    TSC_COIN: 'TSC提币',
    TRX_COIN: 'TAX提币',
    TSC_FEE: '1%手续费，最低20TSC',
    TRX_FEE: '0手续费',
    SMART_ADD: '智能合约地址',
    SMART_TOTAL: '智能合约存款总量',
    SMART_BALANCE: '智能合约存款结余',
    MEMBER_COIN_TOTAL: '会员提币总量',
    DAY_1: '每天1%发放总量',
    TOP_10_CD: 'Top10分红倒计时',
    TOP_10_TOTAL: 'Top10瓜分总量（本轮）',
    TSC_REWORD: 'TSC奖励总量',
    TSC_WITHDRAWAL: 'TSC提币总量',
    REF_ADD: '推荐人地址',
    INV_LINK: '我的邀请链接',
    TRX_LINK: '我的TRX地址',
    INV_TOTAL: '投资总额',
    REWARD_161: '161.8%奖励总额',
    DIRECT: '直推人数',
    DIRECT_REWARD: '直推奖励总额',
    TOTAL_TEAM: '团队收益总额',
    GLOBAL_10: '全球top10奖励',
    TSC_REWARD: 'TSC奖励总额',
    TOTAL_WITHDRAWAL: '提币总额',
    INV_TRX: '在投TRX',
    DAY_REWARD: '每日奖励',
    TSC_FACTOR: 'TSC释放因子',
    TRX_AVA: '可提TRX',
    TSC_AVA: '可提TSC',
  },
  en: {
    DEFI: 'DeFi',
  },
};

Object.keys(langs).forEach((k) => {
  langs[k.split('-')[0]] = langs[k];
});

langs.default = langs['zh-CN'];

export { langs };

export default function (lang: string) {
  return (key: string) => langs[lang]?.[key] || langs.default[key] || key;
}
