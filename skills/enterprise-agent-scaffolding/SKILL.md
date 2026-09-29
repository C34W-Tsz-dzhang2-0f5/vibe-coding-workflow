---
name: enterprise-agent-scaffolding
description: 企业级 AI agent 生产脚手架规范与落地清单。当开发或评审面向生产的 agent（涉及多租户隔离、审计日志、可观测性 tracing/metrics、成本控制与熔断、HITL 人工审批、不可逆动作拦截、行为评测集 eval、CI/CD 灰度部署、AgentOps、企业级合规）时使用。与 vibe-coding-workflow（编码侧方法论）互补——本技能覆盖其缺失的生产非功能属性。触发场景：用户要"做企业级 agent""上生产""合规/审计/多租户""agent 上线前检查""防止 agent 失控循环/越权/数据泄漏""agent 成本失控"。
---

# Enterprise Agent Scaffolding（企业级 Agent 生产脚手架）

## 定位与边界
- 本技能是 **vibe-coding-workflow 的生产态补充**。vibe-coding-workflow 管"把 agent 代码写好"（S0-S6 + 四专家：架构/可维护性/安全/QA）；本技能管"让 agent 能上生产"的**非功能脚手架**。两者不重叠，应串行使用：先用本技能定生产边界，再用 vibe-coding-workflow 写代码。
- 适用：任何要进生产、碰真实用户数据或外部系统的 agent。不适用：纯 demo、无外部副作用的助手、一次性脚本。

## 何时必须启用（任一命中即触发）
- agent 会读写企业系统（CRM / ERP / DB / 文件系统 / 邮件）
- 多用户或多租户共用同一套服务
- 动作不可逆（发消息、改记录、转账、删数据）
- 受监管行业（金融 / 医疗 / 政务）或需审计留痕
- 有成本或代币预算约束
- 需要灰度发布与回滚

## 八大非功能要素（必做清单）
每项：必做项 + 决策点 + 责任归属（本技能 / 四专家 / 协同）。

### 1. 多租户隔离（Tenant Isolation）🔴
- 每租户数据 / 状态 / 配置严格隔离，绝不跨租户共享内存、缓存或向量库。
- 隔离策略三选一：DB-per-tenant（最强）/ schema-per-tenant（SaaS 折中）/ row-level security（最弱，需配合策略引擎）。
- 租户上下文随每次请求注入，agent 不得"记住"上一个租户。
- 责任：本技能定架构 + 磐石专家（security-expert）做越权检测。

### 2. 身份与权限（IAM / Least Privilege）🔴
- agent 以**唯一工作负载身份**运行；发起用户身份贯穿每次 tool call。
- 工具令牌按任务最小权限 + 短时效（task-scoped, short-lived），严禁长期宽泛凭证。
- 读写工具分离："起草邮件"与"发送邮件"是两个工具；"建线索"与"导出联系人"分开授权。
- 权限矩阵文档化：每个工具——谁能用、为何用。
- 责任：磐石专家主导代码层，本技能补运行态 IAM 设计。

### 3. 审计日志（Audit Logging）🔴
- 每步 tool call / 决策 / 升级 / 失败 / 权限变更**不可篡改、可查询**地记录。
- 记录字段：traceId、输入提示（可选脱敏）、原始输出、token 数、延迟、工具调用及结果。
- 敏感字段（PII / 凭证 / 机密）脱敏后再落日志。
- 责任：本技能定日志 schema + 明镜专家（qa-expert）验证覆盖。

### 4. 可观测性（Observability / Tracing）🔴
- 端到端 trace：retrieval → tool call → 中间产物 → 最终动作，带时间戳与成本。
- 指标：成功率、延迟、单次成本、升级率、token / 工具调用拆解。
- 行为评测不能只看最终答案——要评工具选择、策略合规、证据链。
- 责任：本技能。

### 5. 成本控制与熔断（Cost Governance / Circuit Breaker）🔴
- per-run / per-tenant / per-user 预算硬上限。
- 步数上限（maxSteps）、超时（timeoutMs）、token 预算（maxTokensPerRun）。
- 失控循环（runaway loop）自动熔断 + 告警；连接池 / 容器按需伸缩。
- 责任：本技能。

### 6. 人工审批与不可逆拦截（HITL）🔴
- 按动作风险分级：L1 助手（草稿）→ L2 副驾（人批外部动作）→ L3 受控（低风险自治）→ L4 自治（端到端 + 监控）。
- **不可逆动作必须独立人审**，不能靠模型"自审自己是否安全"。
- 升级路径可用、有 owner。
- 责任：本技能定分级 + 磐石专家审代码实现。

### 7. 行为评测集（Eval Suite）🟡
- 发布前必须有标注测试集 + 通过阈值；每次 prompt / 模型变更先跑 eval。
- 含对抗场景：模糊指令、冲突数据、工具不可用、畸形输入、prompt injection、意料外响应。
- 持续从生产失败 / 用户纠正回流为新 case。
- 责任：明镜专家 + 本技能（场景库）。

### 8. CI/CD 与灰度（Deployment）🟡
- 离线 eval + canary 发布；行为变更先小流量。
- 回滚预案；prompt / agent 版本化、可独立部署。
- 责任：本技能 + vibe-coding-workflow S5/S6。

## 落地流程（与 vibe-coding-workflow 衔接）
```
[本技能 S-前置]  选定用例 → 定边界(要素 1-8 必做项) → 出脚手架骨架
        ↓
[vibe-coding-workflow S0-S6]  按边界写 agent 代码 + 四专家评审
        ↓
[本技能 上线前门禁]  八要素 checklist 全过 → canary → 监控 → 回滚预案
```
详细架构审查清单见 [references/checklist.md]；最小可运行骨架见 [references/scaffold.ts]。

## 反模式（红线，禁止）
- ❌ 给 agent 长期宽泛凭证（standing broad credentials）。
- ❌ 让模型"自审自己是否安全"（a second prompt asking "is this safe?" 不是独立控制）。
- ❌ 把所有对话当长期记忆存储（隐私 / 投毒 / 相关性问题）。
- ❌ 多 agent 早于单 agent baseline 跑通（Anthropic：先单 agent + eval，再谈复杂度）。
- ❌ 只测最终答案、不测过程（工具选择 / 策略合规 / 证据链）。
- ❌ 无步数 / 超时 / token 上限（失控循环）。
- ❌ 把工作流跑通等同于"企业级完成"——漏审计 / 多租户 / 成本三件套即上线事故。

## 风险分级
- 🔴 高：缺审计 / 多租户 / 成本任一项，禁止上生产。
- 🟡 中：eval 套件与 HITL 分级不到位，会漏掉"过程正确、结果错误"的 agent。
- 🟢 低：纯编码质量由 vibe-coding-workflow 四专家兜底。

## 来源（已核验，落笔前查过）
- Anthropic — Engineering Reliable Multi-Agent Systems (2026)：harness > model；先单 agent baseline + eval。
- Artefact — Enterprise-grade agents non-negotiables：IAM / 审计 / eval / 可观测 / 成本 / HITL / 数据治理 / fallback。
- Katory — Architecting the Agentic Enterprise：架构审查清单（ARB 必问题）。
- agxntsix — Claude Agent SDK 生产化 2200–4500 工时，认证三阶段（API key → OAuth → SSO）。
- OWASP Gen AI Security / NIST AI RMF：agentic 安全与风险框架。
