# agile-decision-engine-test
The test demo for [agile-decision-engine](https://github.com/ponderyao/agile-decision-engine)

## 使用步骤
1. 按组件提供的建表SQL创建数据表后，执行该demo的`decision-test.sql`文件，录入模拟数据
2. 在`application.yml`文件中配置ip、名称、账号、密码等数据库信息
3. 启动，通过 postman 工具测试不同输入情况下是否按策略输出不同结果
