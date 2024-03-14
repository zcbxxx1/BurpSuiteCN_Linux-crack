#### 声明！该脚本仅用于在linux系统上安装burp专业版使用；在官方更新算法激活前长期有效

首先克隆（或下载）本仓库

赋予脚本执行权限`chmod +x newCrack.sh`

运行脚本`./newCrack.sh`

![](https://secure2.wostatic.cn/static/5fALsCXESC5vpCnhPubikj/image.png?auth_key=1710409182-6idJ6DbSSzM2wBVzYL9wh4-0-9f956a478c3a1521969fb3228c35aa3d)

如果没有安装过

则按照 1 → 2 → 3 → 4 → 6运行（设置英文版）

或 1 → 2 → 3 → 5 → 6运行（设置汉化版）

输入6开始破解后如下图所示，会运行注册机与程序本体

**Licence Text 一行可以随意修改**

将License凭证复制后填写到Burp Suite的凭证输入框中，然后点击Next

![](https://secure2.wostatic.cn/static/3oT4o8FXd7LUr3bajGqgc5/image.png?auth_key=1710410489-rKnURnXv2oYHRMe1hpumLp-0-c9b1d65c7b74b61cfdcbdd1c76a60183)

点击手动激活——Manual activation

![](https://secure2.wostatic.cn/static/kxbBJGQwPdHZtgKwCWc9Kf/image.png?auth_key=1710410556-vPSLNv268jXALUQrUMATma-0-d01aa1f8ec17c3c31da8e0d41320fecd)

复制**BurpSuite**激活请求码到**注册机**中的request部分，然后将**注册机**响应生成的response状态码复制到**BurpSuite**的response部分，接着**Next**

![](https://secure2.wostatic.cn/static/ibXaEgsPcJvtqFYa9u9joU/image.png?auth_key=1710410598-36B36q99gyQ5VQP5Q76B5e-0-a23b812350732278f2c1b8f0f77f7b19)

然后激活完成

之后运行直接点击**安装路径下的**`BurpSuitePro`即可（默认为`/opt/BurpSuitePro/BurpSuitePro`）或者直接运行安装程序后系统生成的快捷方式

(存在任何问题或脚本优化欢迎提issue)

附：感谢注册机与汉化包整合提供者Leon406

https://github.com/Leon406/BurpSuiteCN-Release
