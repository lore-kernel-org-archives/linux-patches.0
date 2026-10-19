Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172A560FF07;
	Mon, 19 Oct 2026 14:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418630; cv=none; b=aVJWmtmHU85Usvw31Ezd9vUEDgR3uWZ5noK7pQwLye34NLVL3t5pdmnN/VhID0JsKcB6ysI0rHqeNoh72GywWyBNoVPRohKg9STSgptLhM32CF6xwZG4YRZGEvd0fZVd+IPa8u8JNAaYssAmBPf8d98Bz21OGXHFLLGJJ4koG4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418630; c=relaxed/simple;
	bh=TyijZPZNVQ4NAT0+bvDWX8mxgFZpAbKLiUirdLRWDfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PLKEOBad9WR8tLrXJD8GZvzFsP2IAWFUsJQh+58fVQBAm/nwcDb7QT6ToB3cQby/CH4TsvGYX/V11ofqH+BGMnrdf7ieApCZ9xo39L9JYg6hHKMOsRzvr/NKIMNhcZMwPX6w9DEfMfWJoAYRbc3m9k4j5eM10SpVZV5ZFIm4UxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dKpJb57h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dKpJb57h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8831F000C6;
	Mon, 19 Oct 2026 14:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418628;
	bh=a7S47/WW/v4K1F5IJZOTzYM/zCZR3J61VKUez1IAJA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dKpJb57hBRRKcnd8Fl5XWfTkv0NKaoVakLmhFTJBON3+5QUnE5aI1gDklz8teXBv5
	 93o2VRVLXFG2fgS2Da0hjp62Nj1pv/6ya4BnI39nVbGZhR3dKc1n42Xh4PZk5/n4YX
	 ygYIxpXeZLhcbRgGyGXloQsRwMEH7KTODwA6fPMWlSxOrbMfjaTziYUUamTygvMkwv
	 tdGjK+/52TA0CopFsg9frRffjTn9edx7IVPuVbcz8Bc4lMZRVT1lKZBbUvrDycGu5/
	 lscHfgR1MTlcemAAus1ceKZKF9rh8gWvDSnI9+D4kf9z/ITbzKtoyD0zHUNnMNYC4F
	 3bgACbxcUOPjQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-rtc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] rtc: ab-eoz9: add missing MODULE_DEVICE_TABLE()
Date: Mon, 19 Oct 2026 09:51:15 -0400
Message-ID: <20261019135441.1420968-384-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 7490b8356e52e09c196645912f2c054f79aa5f3a ]

The driver has a match table for the i2c bus wired into its driver
structure, but the table is not exported with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE() entry so module alias information
is generated for automatic module loading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the driver registration structure, and the missing module alias
publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260704152528.53258-1-pengpeng@iscas.ac.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a one-line `MODULE_DEVICE_TABLE(i2c, ...)` addition on a driver
that already exists in this 6.12 tree. The I2C ID table is wired up but
never exported, so i2c-style module autoload is broken.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [rtc: ab-eoz9] [add] [export the existing I2C match table via
MODULE_DEVICE_TABLE so aliases are generated for autoload]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn> (author)
- Link:
  https://patch.msgid.link/20260704152528.53258-1-pengpeng@iscas.ac.cn
- Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com> (RTC
  maintainer)
- No Fixes: tag (expected for this review queue)
- No Cc: stable (expected)
- No Reported-by / Tested-by / Reviewed-by / Acked-by
- Ignore pipeline SOBs if present

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: `abeoz9_id[]` is used as `id_table` but never published with
  `MODULE_DEVICE_TABLE(i2c, ...)`, so file2alias does not emit
  `i2c:abeoz9` aliases.
- Symptom: when `RTC_DRV_ABEOZ9=m`, udev/modprobe will not autoload the
  module for a non-DT I2C instantiation (`new_device`, board info,
  etc.).
- Failure mode: driver stays unloaded; RTC does not appear until a
  manual `modprobe rtc-ab-eoz9`.
- Version info: none in the message.
- Root cause: missing alias publication, not a match-table or probe-
  logic error.
- Author explicitly calls this a source-level fix with no dynamic
  hardware repro.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not hidden. It is a missing-autoload bug. The “source-level”
wording does not change that `MODULE_DEVICE_TABLE` is the documented way
I2C drivers publish aliases (`Documentation/i2c/writing-clients.rst`).

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `drivers/rtc/rtc-ab-eoz9.c` (+1 / -0)
- One line after `abeoz9_id[]`: `MODULE_DEVICE_TABLE(i2c, abeoz9_id);`
- No functions changed; table/registration data only
- Scope: single-file surgical fix

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: OF table already has `MODULE_DEVICE_TABLE(of,
  abeoz9_dt_match)`. I2C table exists and is assigned to `.id_table` but
  is not exported.
- After: I2C table is also exported. Built-in builds are unchanged
  (`MODULE_DEVICE_TABLE` is empty when `!MODULE` in
  `include/linux/module.h`).
- Path affected: module-alias generation at build time, not
  probe/runtime.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- Category: hardware enablement / missing device-ID alias (same class as
  adding IDs)
- Mechanism: without the export, `i2c:abeoz9` never appears in module
  info. `i2c_device_uevent()` uses `MODALIAS=i2c:<name>` when OF/ACPI
  modalias is unavailable (`drivers/i2c/i2c-core-base.c`). Autoload then
  fails.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: one standard macro, same pattern as `rtc-
  ab-b5ze-s3.c` and most other I2C RTC drivers.
- Minimal: one line, no unrelated edits.
- Regression risk: very low. No locking, no probe/remove change, no ABI.
  Built-in is a no-op.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Driver added in `67075b63cce26` (“rtc: add AB-RTCMC-32.768kHz-EOZ9 RTC
  support”, Artem Panfilov, 2019-02-17).
- Present in v5.2. OF `MODULE_DEVICE_TABLE` was there from day one; I2C
  export was never added.
- `abeoz9_id` line `{ "abeoz9" }` last touched by `a47d377e22c4a` (drop
  explicit `driver_data = 0`).

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Buggy pattern dates to the introducing commit
`67075b63cce26`, which is an ancestor of this HEAD.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- Recent file history is unrelated (temperature/undervoltage, probe
  style, IRQ flags).
- Not part of a numbered series. Standalone one-liner.
- Sibling Abracon driver `rtc-ab-b5ze-s3.c` already has both OF and I2C
  `MODULE_DEVICE_TABLE`.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record:
- Pengpeng Hou is not the RTC maintainer. Same-day pattern: `can:
  ctucanfd: add missing MODULE_DEVICE_TABLE()` is already in this tree
  as `877e99535dfb9` (upstream `d937bdb244a7`, with Cc: stable).
- RTC maintainer Alexandre Belloni applied the rtc patch (SOB +
  “Applied, thanks!”).

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: None. Uses existing `abeoz9_id` and the existing
`MODULE_DEVICE_TABLE` macro. Standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- lore fetch via WebFetch returned 403; retrieved with `b4 mbox` msgid
  `20260704152528.53258-1-pengpeng@iscas.ac.cn`.
- Thread: original patch + Sashiko bot “no issues” + Alexandre Belloni
  apply mail.
- Single revision (PATCH, not v2/v3). Applied as `7490b8356e52` in the
  RTC tree.
- Submitted context uses `{ "abeoz9" }`, which matches this 6.12 file
  (the candidate blob with `{ .name = "abeoz9" }` is a later-mainline
  context difference only).
- No NAK. No reviewer-requested Cc: stable.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: To: Alexandre Belloni; Cc: linux-rtc, linux-kernel. Maintainer
applied it. No other human review comments.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No user/syzbot/bugzilla report. Author states source-level
evidence only. No in-tree `.dts` user of `abracon,abeoz9` besides
`trivial-rtc.yaml`.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Batch of missing-`MODULE_DEVICE_TABLE` scans the same day (at
least CAN PCI + this RTC). CAN one already backported here. This RTC
patch is self-contained.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: No stable-list discussion found for this subject. Absence is
expected; that is why it is in this review queue.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: No functions modified. Data: `abeoz9_id[]`. Consumers:
`abeoz9_driver.id_table`. Macro: `MODULE_DEVICE_TABLE`.

Step 5.2: TRACE CALLERS
Record:
- `abeoz9_probe` is only referenced from `abeoz9_driver.probe`.
- I2C core calls it on match. Autoload is the gap before probe.
- `i2c_device_uevent()`: OF alias if of_node, else ACPI, else `i2c:` +
  `client->name`.

Step 5.3: TRACE CALLEES
Record: The new line does not call anything at runtime. file2alias
consumes `__mod_i2c__abeoz9_id_device_table`.

Step 5.4: FOLLOW THE CALL CHAIN
Record:
- Userspace-reachable: instantiating `abeoz9` on an I2C adapter (sysfs
  `new_device`, board info) with the driver as a module.
- DT path already autoloads via existing OF table.
- `!CONFIG_OF` / no of_node: I2C alias is the only autoload path, and it
  is missing.
- Driver does not require DT to probe (`abeoz9_trickle_parse_dt` returns
  0 if the property is absent).

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Most I2C RTC drivers already have `MODULE_DEVICE_TABLE(i2c,
...)`. This driver is the incomplete sibling of `rtc-ab-b5ze-s3`. Same-
day CAN PCI fix already landed in this tree.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record:
- Tree: `p-6.12-3-gc504cf0baa3d8`, `make kernelversion` = 6.12.111
  (VERSION 6 / PATCHLEVEL 12 / SUBLEVEL 111).
- File present. `MODULE_DEVICE_TABLE(of, ...)` at line 567; `abeoz9_id`
  at 570–573; no `MODULE_DEVICE_TABLE(i2c, ...)`.
- `7490b8356e52` is not an ancestor of HEAD (`git merge-base --is-
  ancestor` exit 1).
- Bug present since v5.2.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Original mailed patch context is `{ "abeoz9" }`, which is
exactly this tree. Clean apply. No refactor blocking it.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No equivalent fix on `rtc-ab-eoz9.c`. OF alias only.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: `drivers/rtc/` I2C RTC. Criticality: PERIPHERAL / driver-
specific. RTC still matters for wall-clock and wake on boards that use
this Abracon part.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: RTC is mature and still getting stable-worthy fixes in this
tree. This file itself is low-churn.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Users of Abracon AB-RTCMC-32.768kHz-EOZ9 with
`RTC_DRV_ABEOZ9=m`. DT boards already autoload. Affected: non-DT I2C
instantiation, or any path that emits `i2c:abeoz9` rather than the OF
modalias. Config-specific (`=m` only).

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record:
- Trigger: I2C client named `abeoz9` appears while the driver is a
  module and no OF/ACPI modalias is used.
- Not every boot on DT systems.
- Unprivileged users cannot typically create I2C clients; this is not a
  security trigger.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- Failure: module not loaded; RTC absent until manual modprobe. No oops,
  UAF, or corruption.
- Severity: MEDIUM for affected hardware (device does not work
  automatically). LOW globally (niche chip, DT already covered).
- Still a real user-visible bug, same class as missing device IDs.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: medium-low population, high for anyone on the broken autoload
  path; restores hardware probe without manual load.
- Risk: very low (one line, no runtime code).
- Ratio: favorable. Same class already accepted here for ctucanfd.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real autoload bug: I2C ID table is used but not exported.
- One line, obviously correct, maintainer-applied.
- Driver and bug have been in this 6.12 tree since the v5.2
  introduction.
- Original patch applies cleanly here.
- Zero runtime change for built-in; aliases only when `=m`.
- Stable rules allow device-ID additions; this publishes an existing ID.
- Sibling Abracon RTC already has the I2C export.
- Same-day CAN `MODULE_DEVICE_TABLE` fix is already in this tree.

AGAINST:
- No user report or syzbot; author says source-level only.
- Not a crash/security/deadlock.
- DT autoload already works; chip is mainly DT/embedded.
- No in-tree board DTS users of `abracon,abeoz9`.

UNRESOLVED:
- Could not fetch lore.kernel.org via WebFetch (403); thread recovered
  via `b4 mbox`.
- No stable-list thread found.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — one standard macro; maintainer
   applied; matches documented I2C driver pattern.
2. Fixes a real bug that affects users? PASS — missing `i2c:abeoz9`
   alias; module does not autoload on the I2C path.
3. Important issue? PASS under the device-ID / hardware-enablement
   exception. User-visible: RTC module does not load. Not a panic.
4. Small and contained? PASS — +1 line, one file.
5. No new features or APIs? PASS — existing table, existing macro.
6. Can apply to the local tree? PASS — buggy code present; mailed
   context matches 6.12.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Device ID / module-alias publication for an existing driver. Not
a new driver, API, or module parameter.

Step 9.4: MAKE YOUR DECISION
YES. The bug exists in this 6.12.111 tree, the fix is a one-line alias
export with no runtime risk, and it is the same class of hardware-
enablement stable already takes (including this author’s CAN patch
already on this branch).

What the commit solves for stable users: if `rtc-ab-eoz9` is built as a
module, I2C instantiation that emits `i2c:abeoz9` (non-DT) never
autoloads the driver. DT boards already work via the OF table. The extra
line closes the I2C alias gap.

Risk vs benefit: benefit is autoload for this RTC on the I2C path; risk
is essentially nil. No prerequisites. Original mailed hunk matches this
tree’s `{ "abeoz9" }` initializer.

Verification:
- [Phase 1] Parsed tags: author SOB Pengpeng Hou; Link msgid; RTC
  maintainer SOB Alexandre Belloni; no Fixes/Cc:stable/Reported-by
- [Phase 1] Body: missing I2C MODULE_DEVICE_TABLE; source-level, no
  hardware repro claimed
- [Phase 2] Diff: +1 line `MODULE_DEVICE_TABLE(i2c, abeoz9_id)` after
  `abeoz9_id[]` in `drivers/rtc/rtc-ab-eoz9.c`
- [Phase 2] `include/linux/module.h`: macro is alias-only when `MODULE`,
  empty when built-in
- [Phase 3] blame: table from `67075b63cce26` (2019); OF export present
  then; I2C export never added
- [Phase 3] `git merge-base --is-ancestor 67075b63cce26 HEAD`:
  introducing commit is in this tree; in v5.2
- [Phase 3] `git log --oneline --grep='MODULE_DEVICE_TABLE' --
  drivers/rtc/rtc-ab-eoz9.c`: empty (fix not here)
- [Phase 3] Same-author `877e99535dfb9` can/ctucanfd MODULE_DEVICE_TABLE
  already in this tree
- [Phase 4] `b4 mbox` msgid
  `20260704152528.53258-1-pengpeng@iscas.ac.cn`: 3 messages; maintainer
  applied as `7490b8356e52`; mailed hunk uses `{ "abeoz9" }`
- [Phase 4] WebFetch lore/msgid.link: 403; discussion recovered from
  mbox and openwall/lkml mirrors
- [Phase 5] `i2c_device_uevent`: OF first, then ACPI, then
  `MODALIAS=i2c:` + client name
- [Phase 5] grep: `abeoz9_probe` only from this driver; no in-tree DTS
  users besides `trivial-rtc.yaml`
- [Phase 5] `rtc-ab-b5ze-s3.c` already has both OF and I2C
  MODULE_DEVICE_TABLE
- [Phase 6] `git describe HEAD`: `p-6.12-3-gc504cf0baa3d8`; `make
  kernelversion`: 6.12.111
- [Phase 6] Local file lines 562–582: OF table exported; I2C table not;
  `{ "abeoz9" }`
- [Phase 6] `git merge-base --is-ancestor 7490b8356e52 HEAD`: exit 1
  (not in this tree)
- [Phase 7] Kconfig `RTC_DRV_ABEOZ9` is tristate; not set in defconfigs
  searched
- [Phase 8] Failure mode: missing module autoload for I2C path, severity
  MEDIUM for that hardware, not a crash
- UNVERIFIED: live lore.kernel.org HTML (403); no stable-list hit for
  this subject

**YES**

 drivers/rtc/rtc-ab-eoz9.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-ab-eoz9.c b/drivers/rtc/rtc-ab-eoz9.c
index de002f7a39bf4..8dc656bb78bfb 100644
--- a/drivers/rtc/rtc-ab-eoz9.c
+++ b/drivers/rtc/rtc-ab-eoz9.c
@@ -549,6 +549,7 @@ static const struct i2c_device_id abeoz9_id[] = {
 	{ "abeoz9" },
 	{ }
 };
+MODULE_DEVICE_TABLE(i2c, abeoz9_id);
 
 static struct i2c_driver abeoz9_driver = {
 	.driver = {
-- 
2.53.0

