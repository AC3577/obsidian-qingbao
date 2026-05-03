# 本相实验室TrueSelf_Lab 风格分析报告
**采集时间**：2026-05-02
**分析对象**：「心灵呼吸」系列插画

---

## 一、风格定位

| 维度 | 描述 |
|------|------|
| 核心关键词 | 东方意境 / 禅意山水 / 灵性觉醒 / 治愈系 |
| 色调 | 灰蓝 + 暖米 + 柔雾感，高明度低饱和 |
| 构图 | 中心对称，山水环绕，冥想人物居中 |
| 氛围 | 宁静、梦幻、治愈、灵性 |
| 品牌定位 | 人格底色/认知偏差/潜在天赋/情感逻辑 |

**粉丝数**：34,090（小红书账号）
**内容特征**：6篇笔记，主打AI生成东方灵性风格插画

---

## 二、风格元素拆解

### 视觉元素
- **山水意象**：雾气缭绕的山峦 + 平静水面
- **中心人物**：冥想/打坐姿态，居中构图
- **光影处理**：柔和光晕，云层透光，半透明感
- **质感**：水墨渲染 + 柔光叠加，梦幻感
- **色调**：灰蓝/雾蓝为主，暖米色点缀

### 情感定位
- 治愈、宁静、灵性觉醒
- 东方禅意 + 西方超验主义融合
- 心理/精神向内探索感

---

## 三、可生成此风格的AI工具及提示词

### Midjourney（最推荐）

**提示词（英文）**：
```
A serene landscape painting with misty mountains and calm water at dawn, a meditative figure seated in lotus position at the center, eastern ink wash painting style blended with soft pastel tones, dreamy atmosphere, zen aesthetic, spiritual wellness concept, soft golden light glowing through clouds, harmonious and balanced composition, high quality illustration, 16:9 aspect ratio --ar 16:9 --style raw --s 200 --v 6.1
```

**垫图指令**：上传参考图 + `/imagine` + 风格描述 + `--iw 0.7`（参考强度0.7）

### Stable Diffusion + ControlNet

**推荐工作流**：
1. ControlNet Reference + Soft Edge（保持构图）
2. Denoise strength: 0.4-0.6（保留原图风格）
3. 底模推荐：majicMIX / Guofeng3 / RealisticVision
4. LoRA：东方美学 / 水墨渲染

**提示词（中文适配）**：
```
禅意山水画，雾气缭绕的山峦，平静如镜的水面，中心坐着冥想的人物，东方式水墨渲染风格，融合柔和的西方色调，梦幻氛围，治愈系插画，柔和光影，高质量，16:9
```

### GPT-Image-2 / Nano Banana 2

**提示词**：
```
禅意山水，雾气缭绕的山峦与平静水面，中心冥想人物，东方水墨与柔和色调结合，梦幻治愈氛围，柔和光影，插画风格，高质量
```

---

## 四、相似风格创作者（国内外参考）

### 国内
| 创作者 | 平台 | 风格差异 |
|--------|------|---------|
| 第三极光 | 小红书 | 类似东方灵性，但偏星座/神秘学 |
| 笨笨小球 | B站 | AI插画教程向，偏扁平插画 |
| 设计师的睡前毒物 | B站 | AI设计向，非灵性方向 |

### 国外（参考用）
| 创作者/风格 | 描述 |
|-------------|------|
| Sakulich | Midjourney水墨风格，禅意向 |
| James R. Eads | 梦幻烟雾渐变风格，色彩更浓 |
| Vladimir Kustanovich | 超现实自然风景，迷雾感 |
| Alphonse Muuga | 柔焦人像+自然，色调偏暖 |

---

## 五、提示词公式（可套用）

**结构**：
```
[主体] + [环境] + [风格] + [氛围] + [构图] + [参数]
```

**变体提示词（适用于不同场景）**：

**变体1：四季主题**
```
Spring/summer/autumn/winter landscape with misty mountains and calm water, a meditative figure seated at center, oriental ink wash painting meets soft watercolor, zen spiritual atmosphere, dreamy pastel tones, center composition, high quality illustration, 16:9
```

**变体2：人物+场景**
```
A solitary figure meditating in mountain landscape at golden hour, ethereal mist, soft backlighting creating halo effect, eastern ink painting aesthetic blended with impressionist watercolor, peaceful spiritual mood, harmonious natural environment, fine art illustration quality
```

**变体3：极简版**
```
Zen landscape, misty mountains, still water, meditating figure center, oriental-occidental fusion art style, dreamy pastel atmosphere, soft light, minimalist composition, high quality illustration
```

---

## 六、Obsidian原始数据位置

- 博主主页：`/root/obsidian-vault/情报收集/🧠 知识库/博主素材库/本相实验室TrueSelf_Lab/profile.json`
- 图片路径：`notes/images/69f01f12000000003700/5.jpg`
- 相关笔记：`notes/天干丁火地支卯木女不同季节不同环境~.md` 等八字系列

---
*报告整理：2026-05-02 | media-intel 情报部*