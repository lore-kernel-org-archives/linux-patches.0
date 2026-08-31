Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C6B47209F;
	Mon, 31 Aug 2026 13:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183844; cv=none; b=s09+6yLXZRNKwbC/mNLRteeYsLXmpdxGViARJqbVVn9Oo50pVr24meZPSFvraLphJ+B1MMxr63IKBwxzvPqIscMZfBqsL9Tf9jFuKHiuedSk2SOAmnnwf8nQUgxrT1GzDDtfVLLcZgjW0OkHTko9WCTnLZgI8ABId9Sf4lCgqsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183844; c=relaxed/simple;
	bh=bbo3ShUlx1xrXxxhLU53BULDHm4IZY6/UA4TjPkTGds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DEsKTwfB2ru2YwVZfQ/Uly/z4zU4VKan+6Vo6stLnz7KtgdZ4P+qXy6lIbcsQIna72PeiZc2SWmdBuDxBiMSc63crcHueIlnORVC3J0L4x91tb22+v1r8Eq1i4Q6sWbMAYZOY0qr/s6O0m36xW6xZ6jh2GLpEcOLZ/I9/qfrc3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WlL0SPPG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WlL0SPPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE4F1F00A3D;
	Mon, 31 Aug 2026 13:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183842;
	bh=eWzTYdlIPqanQMX1ite56ZRDgdr839ejioJhThETM14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WlL0SPPGeXYTI8mqf+wHZfEfM3IM88UXL+bKZXxXi7Et6TI6NJmEoWqeL3lI17b4U
	 AN7ba5X9kaiPnnCbVf+0Ex6ssayUc4tweGxNFsD0NCFx2lXwMgQBhYpFvA4iNjr7SR
	 rE1pAEgPG/vw5DaBQOI3Yh0Nk/BWuu6iZExyKSznwTODHMHBqDDc04Mq4qKPA+Jubx
	 6Kwuhz1uKypIuzIb5AvD7IrjJc+C5LIolsPRAKKiolxasFolUuLiN0RyIriYK4aD1g
	 DhlT5DupZhdaCD2JmtvWw1Ka3VozqwDvqByAm2JaPzaHMRWw/9edTOsrmeCpcswMcA
	 hjC5POI0xBvVA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	andrew@lunn.ch,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] net: ethtool: cmis_cdb: hold instance lock for ops locked devices
Date: Mon, 31 Aug 2026 09:26:04 -0400
Message-ID: <20260831133314.4125787-336-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 1d3964e29e53b02a7c61ed6d6e4aeccba3275ebc ]

FW module flashing was written so that the flashing happens
without holding rtnl_lock. This allows flashing multiple modules
at once. Current drivers can handle that well, but we should
let drivers depend on the netdev instance lock. Instance lock
is per netdev, and so is the module so we won't break parallel
updates.

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20260603012840.2254293-3-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `net: ethtool: cmis_cdb: hold instance lock
for ops locked devices`

**Local tree:** `v6.18.44` (Linux 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[net: ethtool: cmis_cdb]` — no explicit "fix" verb, but
intent is locking correctness — `hold instance lock for ops locked
devices` during CMIS module firmware flashing.

### Step 1.2: Commit Tags
**Record:**
| Tag | Value |
|-----|-------|
| Reviewed-by | Jakub Sitnicki \<jakub@cloudflare.com\> |
| Acked-by | Stanislav Fomichev \<sdf@fomichev.me\> (ethtool/netdev
locking maintainer) |
| Link |
https://patch.msgid.link/20260603012840.2254293-3-kuba@kernel.org |
| Signed-off-by | Jakub Kicinski \<kuba@kernel.org\> |
| Fixes: | **Absent** (expected for candidate review) |
| Cc: stable | **Absent** (expected) |
| Reported-by / Tested-by | **Absent** |

Notable: subsystem maintainer Acked-by; no user/fuzzer reports.

### Step 1.3: Body Analysis
**Record:**
- **Bug described:** Module FW flashing runs without `rtnl_lock` (by
  design, for parallel flashing on different netdevs), but ops-locked
  drivers expect the per-netdev instance lock (`netdev_lock_ops`) during
  ethtool callbacks.
- **Symptom/failure mode:** Unsynchronized ethtool driver callbacks on
  ops-locked netdevs during firmware flashing.
- **Root cause:** `module_flash_fw_work()` calls
  `ethtool_cmis_fw_update()` without holding `netdev_lock_ops()`, while
  most other ethtool paths (added in commit `2bcf4772e45ad`) do hold it.
- **Version info:** None explicit in message.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Yes — described as locking improvement, but it closes a real
race: concurrent ethtool ops vs. module-flash work on the same ops-
locked netdev.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Change Inventory
**Record:**
| File | Changes |
|------|---------|
| `include/net/netdev_lock.h` | +6 lines — new
`netdev_assert_locked_ops()` helper |
| `net/ethtool/cmis_cdb.c` | +3 lines — include + 2 lockdep assertions |
| `net/ethtool/cmis_fw_update.c` | +2 / -6 — reset path: lock acquire →
assert |
| `net/ethtool/module.c` | +2 lines — lock/unlock around fw update work
|

**Functions modified:** `netdev_assert_locked_ops()` (new),
`cmis_cdb_validate_password()`, `__ethtool_cmis_cdb_execute_cmd()`,
`cmis_fw_update_reset()`, `module_flash_fw_work()`

**Scope:** Single-subsystem, surgical (net +13 / -6).

### Step 2.2: Code Flow Changes
**Record:**
| Hunk | Before → After |
|------|----------------|
| `module_flash_fw_work()` | Calls `ethtool_cmis_fw_update()` unlocked →
wrapped in `netdev_lock_ops()` / `netdev_unlock_ops()` |
| `cmis_fw_update_reset()` | Acquires/releases lock internally → asserts
lock already held by caller |
| `__ethtool_cmis_cdb_execute_cmd()` / `cmis_cdb_validate_password()` |
No lock check → `netdev_assert_locked_ops(dev)` before
`set_module_eeprom_by_page()` |
| `netdev_lock.h` | No ops-only assert helper → adds
`netdev_assert_locked_ops()` (lockdep only when
`netdev_need_ops_lock()`) |

**Path affected:** Workqueue path for module firmware flashing (normal
operation path, not error-only).

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Synchronization / race condition (missing lock)
- **Mechanism:** After `2bcf4772e45ad` ("try to protect all callback
  with netdev instance lock"), most ethtool entry points take
  `netdev_lock_ops()` for drivers with `request_ops_lock=true`. The
  deferred work path (`module_flash_fw_work`) was missed. It calls
  `set_module_eeprom_by_page()` and `reset()` without the instance lock,
  while other ethtool ops on the same netdev can run concurrently with
  the lock held — two threads can enter driver ethtool callbacks
  simultaneously on ops-locked drivers.

### Step 2.4: Fix Quality
**Record:**
- **Quality:** Obviously correct — holds lock for entire fw-update
  duration; moves redundant nested lock in `cmis_fw_update_reset()` to
  assertion; adds lockdep checks at driver callback boundaries.
- **Regression risk:** Very low. `netdev_lock_ops()` is a no-op when
  `netdev_need_ops_lock()` is false. Per-netdev lock preserves parallel
  flashing across different netdevs.
- **Red flags:** None. No API changes, no refactoring.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- `module_flash_fw_work()` without outer lock: introduced in
  `32b4c8b53ee77` (2024-06-27, "Add ability to flash transceiver
  modules' firmware")
- `cmis_fw_update_reset()` per-call locking: added in `2bcf4772e45ad`
  (2025-03-05)
- Recent related fixes already in 6.18.y: `9f5108f5ee273` (bitfield race
  on `module_fw_flash_in_progress`), `9e70c8efb0caf` (validation under
  rtnl)

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: Related File History
**Record:**
- Module FW flash feature: `32b4c8b53ee77` (present in tree)
- Netdev instance lock for ethtool: `2bcf4772e45ad` (present in tree)
- Patch is part of net-next v2 02/11 series preparing ethtool to run
  without rtnl, but **this patch is self-contained** — it does not
  require other series patches to function.

### Step 3.4: Author Context
**Record:** Jakub Kicinski is networking maintainer; authored related
module-flash fixes (`9f5108f5ee273`, `9e70c8efb0caf`) already backported
to this tree.

### Step 3.5: Dependencies
**Record:** Requires `netdev_lock_ops()` infrastructure and module FW
flash code — both present. Standalone; no prerequisite commits from the
broader rtnl-unlock series needed.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:**
- **URL:** https://lists.openwall.net/netdev/2026/06/03/31
- **Series:** `[PATCH net-next v2 02/11]` — part of "make sure
  __ethtool_get_link_ksettings() is ops-locked" prep series
- **Revisions:** v1 (01/14) → v2 (02/11); committed version matches v2
- **Reviewer feedback:** Naming discussion (netdev_assert_locked_ops vs
  netdev_ops_assert_locked); no functional objections
- **Stable nominations:** None found in thread
- **NAKs:** None

### Step 4.2: Reviewers
**Record:** CC'd to netdev@, davem, edumazet, pabeni, andrew+netdev,
driver maintainers. Reviewed-by Jakub Sitnicki; Acked-by Stanislav
Fomichev.

### Step 4.3: Bug Reports
**Record:** No syzbot, bugzilla, or user crash reports. Bug identified
through code review as part of ethtool locking hardening.

### Step 4.4: Series Context
**Record:** Patch 2/11 of rtnl-unlock prep series. This specific change
is independently valuable — fixes fw-flash locking regardless of whether
rtnl is dropped elsewhere.

### Step 4.5: Stable List History
**Record:** No stable@ discussion found for this specific patch. Related
module-flash fixes were already backported to 6.18.y.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `module_flash_fw_work()`, `ethtool_cmis_fw_update()`,
`__ethtool_cmis_cdb_execute_cmd()`, `cmis_cdb_validate_password()`,
`cmis_fw_update_reset()`

### Step 5.2: Callers
**Record:**
- `module_flash_fw_work()` ← `schedule_work()` from
  `module_flash_fw_schedule()` ← `ethnl_act_module_fw_flash()` (netlink
  from userspace `ethtool --flash-module-firmware`)
- `set_module_eeprom_by_page` called on drivers including **bnxt**
  (`request_ops_lock=true`) and **mlxsw** (no ops lock — unaffected)

### Step 5.3: Callees
**Record:** Driver ethtool ops (`set_module_eeprom_by_page`, `reset`),
CMIS CDB command execution, sleep/polling during FW transfer.

### Step 5.4: Reachability
**Record:**
- Triggered by privileged admin via netlink ethtool
- Uncommon but real on datacenter NICs/switches with CMIS transceivers
- Race window: entire FW flash duration (seconds to minutes) if
  concurrent ethtool ops occur on same netdev

### Step 5.5: Similar Patterns
**Record:** All other ethtool paths in this tree use `netdev_lock_ops()`
/ `netdev_ops_assert_locked()` — fw-flash work path is the outlier.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (6.18.44)

### Step 6.1: Buggy Code Present?
**Record:** **YES.** Current `module_flash_fw_work()` at lines 229 calls
`ethtool_cmis_fw_update()` without `netdev_lock_ops()`.
`netdev_assert_locked_ops()` does not exist. Bug introduced when
instance-lock protection was added (`2bcf4772e45ad`) without covering
the workqueue path.

### Step 6.2: Backport Complications
**Record:** Minor context difference — local tree uses
`netdev_ops_assert_locked` naming; patch base uses
`netdev_assert_locked_ops_compat`. New helper
`netdev_assert_locked_ops()` adds cleanly near existing helpers.
Expected: **clean apply with possible trivial context adjustment**.

### Step 6.3: Related Fixes Already Present?
**Record:** Related module-flash race fixes (`9f5108f5ee273`,
`9e70c8efb0caf`, `61848c83b9132`) are in tree. This specific locking fix
is **not** yet applied.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** `net/ethtool` — **IMPORTANT** (datacenter NICs, switches;
admin-triggered but safety-critical during FW updates).

### Step 7.2: Activity
**Record:** Actively maintained — multiple module-flash fixes landed in
2025–2026, several already backported to 6.18.y.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Users of ops-locked drivers (bnxt, mlx5, bnge) performing
CMIS transceiver module firmware flashing. Config-specific: requires
`CONFIG_ETHTOOL` and driver `set_module_eeprom_by_page` support.

### Step 8.2: Trigger Conditions
**Record:** Module FW flash in progress on ops-locked netdev **and**
concurrent ethtool operation on same netdev. Uncommon but plausible in
automated datacenter management. Privileged admin operation.

### Step 8.3: Failure Mode Severity
**Record:** Concurrent unsynchronized driver ethtool callbacks →
possible **CRITICAL/HIGH** (NIC misbehavior, kernel oops, transceiver FW
corruption during update). No confirmed crash report, but consequences
of FW-update races are severe.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH for affected hardware — correct locking on safety-
  critical FW flash path
- **Risk:** VERY LOW — ~20 lines, no-op on non-ops-locked drivers,
  preserves parallel flash across netdevs
- **Ratio:** Strongly favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real locking hole on ops-locked drivers during module FW flash
- Prerequisites (module flash + netdev ops lock) present in 6.18.44
- Small, surgical, maintainer-reviewed fix
- Related module-flash fixes already backported to this tree
- Affects common datacenter drivers (bnxt with `request_ops_lock=true`)
- Lockdep assertions catch future regressions

**AGAINST backport:**
- Part of larger net-next rtnl-unlock series (but this patch is
  standalone)
- No user/fuzzer crash reports
- Rare code path (admin FW flash only)
- Naming context may need minor adjustment on backport

**Unresolved:** No runtime crash evidence; impact inferred from code
analysis and locking model.

### Step 9.2: Stable Rules Checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — reviewed/acked; lockdep
assertions; logically sound |
| 2. Fixes real bug? | **PASS** — missing instance lock on fw-flash work
path |
| 3. Important issue? | **PASS** — race on ops-locked drivers during FW
update (HIGH severity) |
| 4. Small and contained? | **PASS** — 4 files, ~20 lines |
| 5. No new features/APIs? | **PASS** — locking only |
| 6. Applies to local tree? | **PASS** — buggy code present;
prerequisites in tree |

### Step 9.3: Exception Categories
**Record:** N/A — standard race-condition bug fix.

### Step 9.4: Decision Rationale

This commit closes a locking gap introduced when netdev instance-lock
protection was extended to ethtool callbacks but the deferred module-
firmware-flash workqueue path was overlooked. On ops-locked drivers like
bnxt, concurrent ethtool operations during a firmware flash can enter
driver callbacks without serialization — a real race with potentially
severe consequences during transceiver FW updates. The fix is minimal,
self-contained, does not depend on the rest of the rtnl-unlock series,
and follows the same pattern as related module-flash fixes already
backported to 6.18.y.

---

## Verification

- [Phase 1] `git describe HEAD` → v6.18.44; parsed subject, tags
  (Reviewed-by, Acked-by, Link), body
- [Phase 2] Analyzed provided diff; read current `module.c:221-242`,
  `cmis_fw_update.c:435-445`, `cmis_cdb.c:161-187,535-557`
- [Phase 3] `git blame` on `module_flash_fw_work` → introduced
  `32b4c8b53ee77`, lock gap since `2bcf4772e45ad`
- [Phase 3] `git show 2bcf4772e45ad` → added lock to init path and
  `cmis_fw_update_reset`, not work path
- [Phase 3] `git merge-base --is-ancestor` → module flash YES, netdev
  lock ethtool YES
- [Phase 3] `git log --oneline -20` on ethtool module files → related
  fixes present
- [Phase 4] Fetched https://lists.openwall.net/netdev/2026/06/03/31 → v2
  02/11 patch content confirmed
- [Phase 4] Web search → series context, Fomichev Acked-by, naming
  discussion
- [Phase 4] `b4 dig -c 2bcf4772e45ad` → found related thread
  (patch.msgid.link blocked by bot protection)
- [Phase 5] `grep` call chain: `ethnl_act_module_fw_flash` →
  `module_flash_fw_schedule` → `schedule_work` → `module_flash_fw_work`
- [Phase 5] `grep request_ops_lock` → bnxt, mlx5, bnge set it; mlxsw
  does not
- [Phase 5] `grep set_module_eeprom_by_page` → bnxt, mlxsw implement it
- [Phase 6] `grep netdev_assert_locked_ops` → not in tree (fix not
  applied)
- [Phase 6] Read current `module_flash_fw_work()` → missing outer
  `netdev_lock_ops()`
- [Phase 6] Read `include/net/netdev_lock.h` → `netdev_lock_ops()` no-op
  when `!netdev_need_ops_lock()`
- [Phase 7] Confirmed net/ethtool subsystem; recent backports
  `9f5108f5ee273`, `9e70c8efb0caf` in tree
- [Phase 8] Assessed severity from locking model + bnxt
  `request_ops_lock=true` (no crash report)

**YES**

 include/net/netdev_lock.h    | 6 ++++++
 net/ethtool/cmis_cdb.c       | 3 +++
 net/ethtool/cmis_fw_update.c | 8 ++------
 net/ethtool/module.c         | 2 ++
 4 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/net/netdev_lock.h b/include/net/netdev_lock.h
index 3d3aef80beac1..849b91ab4e28b 100644
--- a/include/net/netdev_lock.h
+++ b/include/net/netdev_lock.h
@@ -80,6 +80,12 @@ netdev_ops_assert_locked_or_invisible(const struct net_device *dev)
 		netdev_ops_assert_locked(dev);
 }
 
+static inline void netdev_assert_locked_ops(const struct net_device *dev)
+{
+	if (netdev_need_ops_lock(dev))
+		netdev_assert_locked(dev);
+}
+
 static inline void netdev_lock_ops_compat(struct net_device *dev)
 {
 	if (netdev_need_ops_lock(dev))
diff --git a/net/ethtool/cmis_cdb.c b/net/ethtool/cmis_cdb.c
index fe156991d0bec..b39c7d47580da 100644
--- a/net/ethtool/cmis_cdb.c
+++ b/net/ethtool/cmis_cdb.c
@@ -2,6 +2,7 @@
 
 #include <linux/ethtool.h>
 #include <linux/jiffies.h>
+#include <net/netdev_lock.h>
 
 #include "common.h"
 #include "module_fw.h"
@@ -179,6 +180,7 @@ cmis_cdb_validate_password(struct ethtool_cmis_cdb *cdb,
 
 	pe_pl = *((struct cmis_password_entry_pl *)page_data.data);
 	pe_pl.password = params->password;
+	netdev_assert_locked_ops(dev);
 	err = ops->set_module_eeprom_by_page(dev, &page_data, &extack);
 	if (err < 0) {
 		if (extack._msg)
@@ -546,6 +548,7 @@ __ethtool_cmis_cdb_execute_cmd(struct net_device *dev,
 	if (!page_data->data)
 		return -ENOMEM;
 
+	netdev_assert_locked_ops(dev);
 	err = ops->set_module_eeprom_by_page(dev, page_data, &extack);
 	if (err < 0) {
 		if (extack._msg)
diff --git a/net/ethtool/cmis_fw_update.c b/net/ethtool/cmis_fw_update.c
index 291d04d2776a5..dff83807e975c 100644
--- a/net/ethtool/cmis_fw_update.c
+++ b/net/ethtool/cmis_fw_update.c
@@ -435,13 +435,9 @@ cmis_fw_update_commit_image(struct ethtool_cmis_cdb *cdb,
 static int cmis_fw_update_reset(struct net_device *dev)
 {
 	__u32 reset_data = ETH_RESET_PHY;
-	int ret;
 
-	netdev_lock_ops(dev);
-	ret = dev->ethtool_ops->reset(dev, &reset_data);
-	netdev_unlock_ops(dev);
-
-	return ret;
+	netdev_assert_locked_ops(dev);
+	return dev->ethtool_ops->reset(dev, &reset_data);
 }
 
 void
diff --git a/net/ethtool/module.c b/net/ethtool/module.c
index 9a11e7def0029..8a313c975e2f5 100644
--- a/net/ethtool/module.c
+++ b/net/ethtool/module.c
@@ -226,7 +226,9 @@ static void module_flash_fw_work(struct work_struct *work)
 	module_fw = container_of(work, struct ethtool_module_fw_flash, work);
 	dev = module_fw->fw_update.dev;
 
+	netdev_lock_ops(dev);
 	ethtool_cmis_fw_update(&module_fw->fw_update);
+	netdev_unlock_ops(dev);
 
 	module_flash_fw_work_list_del(&module_fw->list);
 
-- 
2.53.0

