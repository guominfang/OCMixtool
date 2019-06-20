# OCMixtool

> 一个简易的 objective-C 混淆工具

需要混淆的项目中语法尽可能满足常见的语法规范：[objective-c-style-guide](https://github.com/nytimes/objective-c-style-guide)

## 目前支持以下混淆

- [x] 修改前缀
- [x] 混淆名称：
  - 类名
  - Eunm 名称
  - Block 名称
- [ ] 混淆方法名
- [ ] 混淆属性名
- [ ] 修改工程名称

## 使用

1. 在配置文件[OCMConfig.h](OCMixtool/Config/OCMConfig.h)和[OCMConfig.m](OCMixtool/Config/OCMConfig.m)配置对应的信息，如：

- 该混淆项目的路径
- 需要混淆的文件目录
- 混淆的旧工程名称，新工程名称
- 混淆的旧前缀，新前缀
- 配置需要忽略的文件目录名称

2.直接运行项目，等待混淆结束。
