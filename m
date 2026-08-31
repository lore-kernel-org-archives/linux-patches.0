Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E709134B1B0;
	Mon, 31 Aug 2026 13:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183927; cv=none; b=cVeGF10HsRSBVrtIqRwAYlj3Db7/ON7ZkZ5CbqDXIdyFW1/trzWdPj6tRD0imzdncKrPBmA6ixQIZRERKF5lSpFrF2DyzwE0mp8ZRynKOasIFuRpcpP15Id8VHEQFyGXKyfBk8Gn823XN3D8PfGDvVnLF9Sg8jeweTroaKEylDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183927; c=relaxed/simple;
	bh=jrIrwbXPTwlPI40je3VOQZKw4Ba8CpQ8GyXpajIE+rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K+RfUYlg6mxhrulmehB/SnpD9EFhoms0IVFD+btV4yKPjfYtS+a90cMWHIkcoiXyfqKp1CqXY7eJxMN+xAXw5w31I6u9nzt5WyOjkYMPUPJs4KN0HBUriT1OFOZta5pHAN7qHfYNgI17+enfDFCcOwf2v539yZM2xOcJ61zBo5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k04gsmgt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k04gsmgt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682A91F00ACF;
	Mon, 31 Aug 2026 13:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183924;
	bh=5cc6U4hyTJQJPorZBOnPIJdHuDXg9jM0n2s7KKcMI3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k04gsmgteoPMqP6WZFhDXEcNBv2WzkVoCPLOEDyMaWPQ1qM9AUFp9+3kZliWNWkGi
	 +ckXTVnESsQQrrBNKByPTqiCde7/zmQD+vaHPp4pmkLMbmZBwiIHaYQHNFMQpBc5mn
	 Q5ZzNBZZ4LqaJ1TBbLj91fGcOT+usDRRzydRIkkBPazZYgr7NYAUdGG87SaTHB0tT/
	 rnKkN/hytbMG0mCfAhHww8qcrQqL3M4C/yu2lr/2zkdvlHP/YTHiu364qX5BepDVYi
	 kbMkLvtzidWB+1fBgScth4PWqoMUTUn42s5pudwWC4Ohw7yAZzAoa6Nu7GsoLWeSt6
	 CrgIbPGOjLncQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Douglas Anderson <dianders@chromium.org>,
	Saravana Kannan <saravanak@kernel.org>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>,
	driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] driver core: Replace dev->can_match with dev_can_match()
Date: Mon, 31 Aug 2026 09:26:52 -0400
Message-ID: <20260831133314.4125787-384-sashal@kernel.org>
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

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit f2648bb3150a71241a2254aa4ac10680d7f9fb16 ]

In C, bitfields are not necessarily safe to modify from multiple
threads without locking. Switch "can_match" over to the "flags" field
so modifications are safe.

Cc: Saravana Kannan <saravanak@kernel.org>
Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20260406162231.v5.2.I54b3ae6311ff34ad30227659d91bb109911a4aea@changeid
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `driver core: Replace dev->can_match with
dev_can_match()`

**Local tree:** `v6.18.43` (Makefile: 6.18.43)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 — Subject line**
Record: `[driver core]` `[Replace]` — move `can_match` from a struct
bitfield to atomic flag accessors (`dev_can_match()` /
`dev_set_can_match()`).

**Step 1.2 — Tags**
Record:
- `Cc: Saravana Kannan <saravanak@kernel.org>`
- `Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>`
- `Reviewed-by: Danilo Krummrich <dakr@kernel.org>`
- `Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>`
- `Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>`
- `Signed-off-by: Douglas Anderson <dianders@chromium.org>`
- `Link: https://patch.msgid.link/20260406162231.v5.2.I54b3ae6311ff34ad3
  0227659d91bb109911a4aea@changeid`
- `Signed-off-by: Danilo Krummrich <dakr@kernel.org>`
- No `Fixes:`, no `Reported-by:`, no `Cc: stable@vger.kernel.org`
- Notable: subsystem maintainer (Greg K-H) and PM/driver-core reviewers
  acked/reviewed

**Step 1.3 — Body**
Record:
- **Bug:** In C, bitfields are not safe to modify from multiple threads
  without locking.
- **Symptom:** Not spelled out; this is a concurrency-correctness fix,
  not a crash report.
- **Root cause:** `can_match` was stored as a `bool` bitfield in `struct
  device` while being read/written from concurrent probe paths.
- **Fix:** Move `can_match` into the existing `flags` bitmap (same
  pattern as `DEV_FLAG_READY_TO_PROBE`) and use `dev_can_match()` /
  `dev_set_can_match()` atomic accessors.

**Step 1.4 — Hidden bug fix?**
Record: **Yes.** Despite the neutral “Replace” wording, this fixes a
real data-race / undefined-behavior problem. The parent commit
`3e8fefd2997c8` explicitly avoided bitfields for `ready_to_probe` for
this exact reason, but left `can_match` as a bitfield — this patch
completes that design.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1 — Inventory**
Record:
- `include/linux/device.h`: +5 doc, +1 enum, −1 bitfield, +1 accessor
  macro (~15 net lines)
- `drivers/base/core.c`: 6 sites, `dev->can_match` → `dev_can_match()` /
  `dev_set_can_match()`
- `drivers/base/dd.c`: 4 sites, same replacement
- **Functions touched:** `dev_is_best_effort`,
  `device_links_check_suppliers`, `device_links_driver_bound`,
  `fw_devlink_no_driver`, `device_add`, `driver_deferred_probe_add`,
  `__driver_probe_device`, `__device_attach_driver`, `__driver_attach`
- **Scope:** Single-subsystem, surgical mechanical refactor (~40 lines
  changed)

**Step 2.2 — Code flow (per hunk)**
Record:
- **Before:** Direct read/write of `dev->can_match` bitfield (non-atomic
  RMW on shared storage).
- **After:** `test_bit` / `set_bit` on `dev->flags[DEV_FLAG_CAN_MATCH]`
  via inline accessors.
- **Paths affected:** Device probe attach, deferred probe, fw_devlink
  supplier checks, `device_add()` tail.

**Step 2.3 — Bug mechanism**
Record: **Synchronization / data-race fix.** Category (b): concurrent
unsynchronized bitfield access. Adjacent bitfields in `struct device`
(`state_synced`, `offline`, `of_node_reused`, DMA flags) can be
corrupted by non-atomic RMW on `can_match`.

**Step 2.4 — Fix quality**
Record: Obviously correct — mirrors the already-merged `ready_to_probe`
pattern. Minimal risk; no API surface change for drivers (accessors are
static inline in `device.h`). Regression risk: very low.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 — Blame**
Record: `can_match` bitfield introduced in `3e8fefd2997c8` (“driver
core: Don't let a device probe until it's ready”), merged via
`5d324e5159d9e`, present since at least `v6.18.27` in this tree. Blame
on `include/linux/device.h:699` and `drivers/base/dd.c:868` points to
that introduction.

**Step 3.2 — Fixes: tag**
Record: N/A — no `Fixes:` tag. The logical bug-introducer is
`3e8fefd2997c8`, which **is** in this tree (`git merge-base --is-
ancestor` confirmed).

**Step 3.3 — Related file history**
Record: Recent driver-core commits in this tree (`0830287cc6cb7`,
`3880ee7c88d78`, etc.) do not touch `can_match`. No duplicate fix found.
This commit is **not** yet in the tree (`dev_can_match` grep returns
nothing).

**Step 3.4 — Author context**
Record: Douglas Anderson authored `3e8fefd2997c8` and `fa9a4c5e69aaa`
(similar fwnode flags thread-safety fix). Driver-core maintainer chain
reviewed both.

**Step 3.5 — Dependencies**
Record: Requires `3e8fefd2997c8` (adds `can_match`, `flags` bitmap,
`__create_dev_flag_accessors`). That prerequisite **exists** in
v6.18.43. Patch is standalone; no series dependency beyond that.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1 — Original discussion**
Record: `b4 dig -c <hash>` could not run — commit not in local tree.
Link fetch to patch.msgid.link and lore.kernel.org returned 403/bot-
block. **UNVERIFIED:** full review thread content.

**Step 4.2 — Reviewers**
Record: From commit message — Greg K-H (driver core maintainer), Rafael
Wysocki (PM/driver core), Danilo Krummrich (reviewer/committer), Marek
Szyprowski (Acked-by).

**Step 4.3 — Bug report**
Record: N/A — no external bug report linked.

**Step 4.4 — Series context**
Record: Link msgid contains `v5.2`, suggesting patch 2 of v5 of the
“ready to probe” series. This is a follow-up to `3e8fefd2997c8`, which
was `Cc: stable@vger.kernel.org`.

**Step 4.5 — Stable list**
Record: **UNVERIFIED** — could not search lore stable archive (403).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 — Key functions**
Record: `dev_can_match`, `dev_set_can_match`, `dev_is_best_effort`,
`device_links_check_suppliers`, `device_links_driver_bound`,
`fw_devlink_no_driver`, `device_add`, `driver_deferred_probe_add`,
`__driver_probe_device`, `__device_attach_driver`, `__driver_attach`.

**Step 5.2 — Callers / concurrency**
Record:
- **Writes** to `can_match`: `__driver_probe_device` (device lock held
  per `driver_probe_device` comment), `__device_attach_driver` (device
  lock held in `__device_attach`), **`__driver_attach` (NO device_lock
  when setting `can_match` at line 1258)**.
- **Reads**: `device_add()` at line 3778 **without** device lock;
  `driver_deferred_probe_add()` without device lock;
  `dev_is_best_effort()` during device-link walks under
  `device_links_write_lock`; `fw_devlink_no_driver()` under
  `device_links_write_lock`.
- Concurrent probe from module load (`driver_register` → `driver_attach`
  → `__driver_attach`) vs. `device_add()` is the documented race class
  from `3e8fefd2997c8`.

**Step 5.3 — Callees**
Record: After fix, uses `test_bit`/`set_bit` on `dev->flags` — same as
`dev_ready_to_probe()`.

**Step 5.4 — Reachability**
Record: Reachable from `finit_module`/`modprobe`, `device_add()`,
deferred probe workqueue — common boot and hotplug paths. **Userspace-
reachable** via module loading.

**Step 5.5 — Similar patterns**
Record: `ready_to_probe` already uses atomic `flags`; `fa9a4c5e69aaa`
made fwnode flags thread-safe. `can_match` as bitfield is the
inconsistent outlier.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (v6.18.43)

**Step 6.1 — Buggy code present?**
Record: **Yes.** `bool can_match:1` at `include/linux/device.h:699`;
direct `dev->can_match` access in `drivers/base/core.c` and
`drivers/base/dd.c`. Introduced in `3e8fefd2997c8`, ancestor of HEAD.

**Step 6.2 — Backport complications**
Record: **Clean apply expected.** `DECLARE_BITMAP(flags,
DEV_FLAG_COUNT)` and `__create_dev_flag_accessors` macro already exist;
only need to add `DEV_FLAG_CAN_MATCH` and swap usages. No conflicting
local changes found.

**Step 6.3 — Fix already present?**
Record: **No.** `dev_can_match` / `DEV_FLAG_CAN_MATCH` absent from tree.

---

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1 — Subsystem / criticality**
Record: **driver core** (`drivers/base/`) — **CORE** subsystem; affects
all device probe/bind on all platforms using the driver model.

**Step 7.2 — Activity**
Record: Actively maintained; recent probe/deferred-probe fixes in this
tree.

---

## PHASE 8: IMPACT AND RISK

**Step 8.1 — Who is affected**
Record: **Universal** for systems using driver core probe, especially
with fw_devlink and parallel/async module loading (Android, others).

**Step 8.2 — Trigger conditions**
Record: Concurrent device probe during `device_add()`, driver
registration, deferred probe, or async attach — timing-dependent but
realistic (documented in `3e8fefd2997c8` on Android parallel module
loading). Unprivileged users can trigger via `modprobe`/`finit_module`.

**Step 8.3 — Failure mode**
Record: Undefined behavior from concurrent bitfield RMW — possible
corruption of adjacent `struct device` bitfields (`state_synced`,
`offline`, `of_node_reused`, DMA flags), leading to incorrect fw_devlink
behavior, stuck deferred probe, or wrong best-effort probing.
**Severity: HIGH** (subtle but serious driver-core state corruption;
same class as the already-stable-nominated `3e8fefd` fix).

**Step 8.4 — Risk/benefit**
Record:
- **Benefit:** HIGH — eliminates UB in core probe path on a tree that
  already carries the `can_match` feature.
- **Risk:** LOW — mechanical, pattern-proven, maintainer-reviewed.
- **Ratio:** Strong benefit, minimal risk.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1 — Evidence**

| FOR | AGAINST |
|-----|---------|
| Fixes real concurrent bitfield UB | No user crash report for this
specific patch |
| Prerequisite `3e8fefd` already in v6.18.43 | Mailing-list stable
nomination unverified |
| Completes design of parent stable-nominated commit |
Theoretical/timing-dependent (no syzbot) |
| Small, surgical, maintainer-acked | |
| Core subsystem, userspace-triggerable via modprobe | |
| Same pattern as `ready_to_probe` (already atomic) | |

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — mirrors existing
   `ready_to_probe` accessors; reviewed by Greg K-H, Rafael, Danilo.
2. Fixes a real bug? **PASS** — concurrent bitfield access is C UB with
   verified unsynchronized read/write paths.
3. Important issue? **PASS** — driver-core state corruption / probe
   hangs (HIGH).
4. Small and contained? **PASS** — ~40 lines, 3 files.
5. No new features/APIs? **PASS** — internal refactor only.
6. Can apply to local tree? **PASS** — prerequisite present, no
   conflicting fix.

**Step 9.3 — Exception category**
Record: N/A (not device ID/quirk/DT/build/doc); standard concurrency bug
fix.

**Step 9.4 — Decision rationale**
This tree (v6.18.43) contains `can_match` as an unsafe bitfield since
`3e8fefd2997c8`. That parent commit explicitly moved `ready_to_probe` to
atomic flags because bitfields are unsafe under concurrent probe, but
left `can_match` as a bitfield — an oversight this patch corrects.
Verified code paths show unsynchronized reads (`device_add`,
`driver_deferred_probe_add`) and writes (`__driver_attach` without
device lock) on the same field, with adjacent bitfields also modified
concurrently. The fix is small, obviously correct, maintainer-approved,
and directly supports the already-backported probe-race infrastructure
in this tree.

---

## Verification

- [Phase 1] Parsed subject, all tags from provided commit message
- [Phase 2] Diff analysis: 3 files, bitfield →
  `dev_can_match()`/`dev_set_can_match()`, 10 call sites
- [Phase 3] `git describe HEAD` → `v6.18.43`
- [Phase 3] `git merge-base --is-ancestor 3e8fefd2997c8 HEAD` → yes
- [Phase 3] `git blame` on `device.h:699`, `dd.c:868` → introduced by
  `3e8fefd2997c8`/`5d324e5159d9e`
- [Phase 3] `git log -S'can_match'` → single introduction commit
  `3e8fefd2997c8`
- [Phase 3] `grep dev_can_match` → not in tree (fix not applied)
- [Phase 4] patch.msgid.link / lore.kernel.org → 403 blocked
- [Phase 4] `b4 dig` → cannot run without commit hash in tree
- [Phase 5] Read `dd.c:857-868`, `dd.c:1252-1258`, `core.c:3778`,
  `device.h:718-740` — confirmed concurrent access patterns
- [Phase 5] `grep state_synced|offline` in `drivers/base/` — adjacent
  bitfields modified concurrently
- [Phase 6] `grep dev->can_match` — 8 sites in `core.c`/`dd.c`; bitfield
  at `device.h:699`
- [Phase 6] `DECLARE_BITMAP(flags)` and
  `__create_dev_flag_accessors(ready_to_probe)` present at
  `device.h:715-740`
- [Phase 8] Parent commit `3e8fefd2997c8` documents Android parallel
  module-loading race; `Cc: stable@vger.kernel.org`
- **UNVERIFIED:** Lore review thread content, explicit stable-list
  discussion for this specific patch

**YES**

 drivers/base/core.c    | 10 +++++-----
 drivers/base/dd.c      | 10 +++++-----
 include/linux/device.h |  9 +++++----
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 5034d9b103642..2b0179096c73d 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1084,7 +1084,7 @@ static void device_links_missing_supplier(struct device *dev)
 
 static bool dev_is_best_effort(struct device *dev)
 {
-	return (fw_devlink_best_effort && dev->can_match) ||
+	return (fw_devlink_best_effort && dev_can_match(dev)) ||
 		(dev->fwnode && fwnode_test_flag(dev->fwnode, FWNODE_FLAG_BEST_EFFORT));
 }
 
@@ -1152,7 +1152,7 @@ int device_links_check_suppliers(struct device *dev)
 
 			if (dev_is_best_effort(dev) &&
 			    device_link_test(link, DL_FLAG_INFERRED) &&
-			    !link->supplier->can_match) {
+			    !dev_can_match(link->supplier)) {
 				ret = -EAGAIN;
 				continue;
 			}
@@ -1435,7 +1435,7 @@ void device_links_driver_bound(struct device *dev)
 		} else if (dev_is_best_effort(dev) &&
 			   device_link_test(link, DL_FLAG_INFERRED) &&
 			   link->status != DL_STATE_CONSUMER_PROBE &&
-			   !link->supplier->can_match) {
+			   !dev_can_match(link->supplier)) {
 			/*
 			 * When dev_is_best_effort() is true, we ignore device
 			 * links to suppliers that don't have a driver.  If the
@@ -1823,7 +1823,7 @@ static int fw_devlink_no_driver(struct device *dev, void *data)
 {
 	struct device_link *link = to_devlink(dev);
 
-	if (!link->supplier->can_match)
+	if (!dev_can_match(link->supplier))
 		fw_devlink_relax_link(link);
 
 	return 0;
@@ -3775,7 +3775,7 @@ int device_add(struct device *dev)
 	 * match with any driver, don't block its consumers from probing in
 	 * case the consumer device is able to operate without this supplier.
 	 */
-	if (dev->fwnode && fw_devlink_drv_reg_done && !dev->can_match)
+	if (dev->fwnode && fw_devlink_drv_reg_done && !dev_can_match(dev))
 		fw_devlink_unblock_consumers(dev);
 
 	if (parent)
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index dabdfc088f3f6..d019d0f98ad47 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -132,7 +132,7 @@ static DECLARE_WORK(deferred_probe_work, deferred_probe_work_func);
 
 void driver_deferred_probe_add(struct device *dev)
 {
-	if (!dev->can_match)
+	if (!dev_can_match(dev))
 		return;
 
 	mutex_lock(&deferred_probe_mutex);
@@ -858,14 +858,14 @@ static int __driver_probe_device(const struct device_driver *drv, struct device
 		return dev_err_probe(dev, -EPROBE_DEFER, "Device not ready to probe\n");
 
 	/*
-	 * Set can_match = true after calling dev_ready_to_probe(), so
+	 * Call dev_set_can_match() after calling dev_ready_to_probe(), so
 	 * driver_deferred_probe_add() won't actually add the device to the
 	 * deferred probe list when dev_ready_to_probe() returns false.
 	 *
 	 * When dev_ready_to_probe() returns false, it means that device_add()
 	 * will do another probe() attempt for us.
 	 */
-	dev->can_match = true;
+	dev_set_can_match(dev);
 	dev_dbg(dev, "bus: '%s': %s: matched device with driver %s\n",
 		drv->bus->name, __func__, drv->name);
 
@@ -1011,7 +1011,7 @@ static int __device_attach_driver(struct device_driver *drv, void *_data)
 		return 0;
 	} else if (ret == -EPROBE_DEFER) {
 		dev_dbg(dev, "Device match requests probe deferral\n");
-		dev->can_match = true;
+		dev_set_can_match(dev);
 		driver_deferred_probe_add(dev);
 		/*
 		 * Device can't match with a driver right now, so don't attempt
@@ -1255,7 +1255,7 @@ static int __driver_attach(struct device *dev, void *data)
 		return 0;
 	} else if (ret == -EPROBE_DEFER) {
 		dev_dbg(dev, "Device match requests probe deferral\n");
-		dev->can_match = true;
+		dev_set_can_match(dev);
 		driver_deferred_probe_add(dev);
 		/*
 		 * Driver could not match with device, but may match with
diff --git a/include/linux/device.h b/include/linux/device.h
index dc1252a06480c..56e5a9314367d 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -485,10 +485,14 @@ struct device_physical_location {
  *
  * @DEV_FLAG_READY_TO_PROBE: If set then device_add() has finished enough
  *		initialization that probe could be called.
+ * @DEV_FLAG_CAN_MATCH: The device has matched with a driver at least once or it
+ *		is in a bus (like AMBA) which can't check for matching drivers
+ *		until other devices probe successfully.
  * @DEV_FLAG_COUNT: Number of defined struct_device_flags.
  */
 enum struct_device_flags {
 	DEV_FLAG_READY_TO_PROBE = 0,
+	DEV_FLAG_CAN_MATCH = 1,
 
 	DEV_FLAG_COUNT
 };
@@ -575,9 +579,6 @@ enum struct_device_flags {
  * @state_synced: The hardware state of this device has been synced to match
  *		  the software state of this device by calling the driver/bus
  *		  sync_state() callback.
- * @can_match:	The device has matched with a driver at least once or it is in
- *		a bus (like AMBA) which can't check for matching drivers until
- *		other devices probe successfully.
  * @dma_coherent: this particular device is dma coherent, even if the
  *		architecture supports non-coherent devices.
  * @dma_ops_bypass: If set to %true then the dma_ops are bypassed for the
@@ -696,7 +697,6 @@ struct device {
 	bool			offline:1;
 	bool			of_node_reused:1;
 	bool			state_synced:1;
-	bool			can_match:1;
 #if defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_DEVICE) || \
     defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU) || \
     defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU_ALL)
@@ -738,6 +738,7 @@ static inline bool dev_test_and_set_##accessor_name(struct device *dev) \
 }
 
 __create_dev_flag_accessors(ready_to_probe, DEV_FLAG_READY_TO_PROBE);
+__create_dev_flag_accessors(can_match, DEV_FLAG_CAN_MATCH);
 
 #undef __create_dev_flag_accessors
 
-- 
2.53.0

