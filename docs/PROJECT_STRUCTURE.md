# Lua Roguelike RPG - 项目结构设计

## 目录结构

```
lua-roguelike-rpg/
├── conf.lua                    # LÖVE配置文件
├── main.lua                    # 游戏入口
├── docs/
│   └── SPEC.md                 # 需求规格说明书
│
├── src/                        # 源代码
│   ├── main.lua                # 主逻辑（协调各模块）
│   ├── game.lua                # 游戏状态管理
│   │
│   ├── core/                   # 核心系统
│   │   ├── engine.lua          # 游戏引擎基础
│   │   ├── state.lua           # 状态机
│   │   └── event.lua           # 事件系统
│   │
│   ├── render/                 # 渲染系统
│   │   ├── renderer.lua        # 主渲染器
│   │   ├── isometric.lua       # 等距投影
│   │   ├── camera.lua          # 摄像机
│   │   └── effects.lua         # 特效（粒子等）
│   │
│   ├── ui/                     # UI系统
│   │   ├── manager.lua         # UI管理器
│   │   ├── panel.lua           # 面板基类
│   │   ├── button.lua          # 按钮
│   │   ├── label.lua           # 标签
│   │   ├── healthbar.lua       # 血条
│   │   ├── menu.lua            # 菜单
│   │   └── dialog.lua          # 对话框
│   │
│   ├── battle/                 # 战斗系统
│   │   ├── battle.lua          # 战斗管理器
│   │   ├── turn.lua            # 回合管理
│   │   ├── action.lua          # 行动（攻击/技能/移动）
│   │   ├── target.lua          # 目标选择
│   │   ├── damage.lua          # 伤害计算
│   │   ├── qte.lua             # QTE机制
│   │   ├── ai.lua              # 敌人AI
│   │   └── animator.lua        # 战斗动画
│   │
│   ├── entity/                 # 实体系统
│   │   ├── entity.lua          # 实体基类
│   │   ├── character.lua       # 角色（玩家/NPC）
│   │   ├── hero.lua            # 英雄
│   │   ├── enemy.lua           # 敌人
│   │   └── unit.lua            # 战斗单位
│   │
│   ├── dungeon/                # 地牢系统
│   │   ├── dungeon.lua         # 地牢管理器
│   │   ├── floor.lua           # 楼层
│   │   ├── room.lua            # 房间
│   │   ├── generator.lua       # 地图生成
│   │   ├── tile.lua            # 瓦片
│   │   ├── object.lua          # 地图对象
│   │   └── leveltype.lua       # 关卡类型（PVE/Boss/逃生等）
│   │
│   ├── character/              # 角色系统
│   │   ├── hero.lua            # 英雄数据
│   │   ├── party.lua           # 小队管理
│   │   ├── attribute.lua       # 属性系统
│   │   └── faction.lua         # 阵营
│   │
│   ├── skill/                  # 技能系统
│   │   ├── skill.lua           # 技能基类
│   │   ├── passive.lua         # 被动技能
│   │   ├── active.lua          # 主动技能
│   │   ├── ultimate.lua        # 终极技能
│   │   ├── effect.lua          # 技能效果
│   │   └── learn.lua           # 技能学习（卷轴）
│   │
│   ├── equipment/              # 装备系统
│   │   ├── equipment.lua       # 装备基类
│   │   ├── weapon.lua         # 武器
│   │   ├── armor.lua          # 防具
│   │   ├── accessory.lua      # 饰品
│   │   ├── weapon_tree.lua    # 武器合成树
│   │   ├── upgrade.lua        # 装备升级
│   │   └── affix.lua          # 词条
│   │
│   ├── quest/                  # 任务/关卡目标
│   │   ├── quest.lua           # 任务系统
│   │   ├── objective.lua       # 目标
│   │   ├── puzzle.lua         # 解谜
│   │   └── escape.lua         # 逃生机制
│   │
│   ├── data/                   # 数据配置
│   │   ├── heroes.lua          # 英雄配置
│   │   ├── enemies.lua         # 敌人配置
│   │   ├── skills.lua          # 技能配置
│   │   ├── items.lua           # 物品配置
│   │   ├── weapons.lua         # 武器配置
│   │   ├── armors.lua          # 防具配置
│   │   ├── dungeon.lua         # 地牢配置
│   │   └── loot.lua            # 掉落配置
│   │
│   ├── save/                   # 存档系统
│   │   ├── save.lua            # 存档管理
│   │   ├── profile.lua         # 玩家档案
│   │   └── unlock.lua          # 解锁进度
│   │
│   ├── audio/                  # 音频系统
│   │   ├── audio.lua           # 音频管理器
│   │   ├── music.lua           # 背景音乐
│   │   └── sound.lua           # 音效
│   │
│   ├── input/                  # 输入系统
│   │   ├── input.lua           # 输入管理器
│   │   └── hotkey.lua          # 快捷键
│   │
│   └── util/                   # 工具函数
│       ├── math.lua            # 数学工具
│       ├── string.lua          # 字符串工具
│       ├── table.lua           # 表格工具
│       ├── color.lua           # 颜色工具
│       ├── vector.lua          # 向量
│       └── rng.lua             # 随机数
│
├── res/                        # 资源目录
│   ├── fonts/                  # 字体
│   ├── images/                 # 图片
│   │   ├── tiles/              # 地图瓦片
│   │   ├── characters/         # 角色图片
│   │   ├── effects/            # 特效图片
│   │   └── ui/                 # UI图片
│   ├── audio/                  # 音频
│   │   ├── music/              # 背景音乐
│   │   └── sounds/             # 音效
│   └── shaders/                # 着色器
│
└── tools/                      # 工具脚本
    ├── map_editor.lua          # 地图编辑器
    └── data_editor.lua         # 数据编辑器
```

## 模块说明

### src/core - 核心系统
游戏引擎基础，包括状态机和事件系统。

### src/render - 渲染系统
- **isometric.lua**: 等距视角投影计算
- **camera.lua**: 摄像机跟随和缩放
- **effects.lua**: 粒子系统、屏幕特效

### src/ui - UI系统
采用暗黑破坏神风格，四周面板布局。

### src/battle - 战斗系统
- **qte.lua**: QTE机制（弹反/闪避）
- **ai.lua**: 敌人AI逻辑
- **turn.lua**: 回合顺序管理

### src/entity - 实体系统
所有可交互对象的基类。

### src/dungeon - 地牢系统
- **leveltype.lua**: 关卡类型（PVE/Boss/逃生/守卫/解谜）
- **generator.lua**: 随机地图生成

### src/character - 角色系统
- **hero.lua**: 英雄配置（类DOTA设计）
- **party.lua**: 4人小队管理

### src/skill - 技能系统
- **learn.lua**: 技能卷轴学习

### src/equipment - 装备系统
- **weapon_tree.lua**: MOBA风格武器合成树
- **upgrade.lua**: 词条数值升级

### src/quest - 任务系统
- **puzzle.lua**: 解谜关卡逻辑
- **escape.lua**: 逃生关卡逻辑

### src/data - 数据配置
所有游戏数据配置（英雄、敌人、技能、物品等）。

### src/save - 存档系统
- **unlock.lua**: 解锁进度存储

### src/util - 工具函数
通用工具函数。

## 资源规范

### 图像格式
- 瓦片: PNG (支持透明)
- 角色: PNG (等距2.5D)
- UI: PNG (9patch可拉伸)

### 音频格式
- 音乐: OGG
- 音效: OGG/WAV

## 依赖关系

```
main.lua
  └── game.lua
        ├── core/engine.lua
        ├── render/renderer.lua
        ├── ui/manager.lua
        ├── battle/battle.lua
        ├── entity/character.lua
        ├── dungeon/dungeon.lua
        ├── character/party.lua
        ├── skill/skill.lua
        ├── equipment/equipment.lua
        ├── quest/quest.lua
        ├── data/*.lua
        ├── save/save.lua
        ├── audio/audio.lua
        └── input/input.lua
```
