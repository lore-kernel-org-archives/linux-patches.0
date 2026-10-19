Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE43D5083FE;
	Mon, 19 Oct 2026 14:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418611; cv=none; b=VVpm++Qva9zFVsr9H7YzlT0LSen6AisNX5WmWD09MWMKGxf5FwOrGQUGKDCNn73ZxkUos5vQVuYPAhhv6DkntzD7eh/fyxDE1c539hPwwfPBPrggG3g6kBcbAEbr2DSYkrmr3W9x5sfP3RlfkSP1RZ7jEfiZBWm4mm5XhYcfUdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418611; c=relaxed/simple;
	bh=fd/bxe7wJdzTg1O/9SJP3qKvIIqctdYH8nMkYq3bv4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sYHCEArFWiKLUNEs1VDcwkpSK5cfr3YYhCE1G4cr3K4g5kVqJ5xndTZWQNdwCCsoMy/RbeAJ6GaqvbzbM+SqpRPqYzLgM6kzgPpc1P30wb8R+2f9z99GNs8t40+tNa5XGWXdW6A9nC12elFWwb5kQOVYVnLVCCnNaasZ4xx8U4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YhyzRa7O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YhyzRa7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34511F000C6;
	Mon, 19 Oct 2026 14:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418607;
	bh=Do2LNX96jLUZh2wnCuc2oBWreyYBE+BtVT124PVt374=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YhyzRa7OsUmjYdbxClRnPcF/bRtDziOxJ0CNuhTLgw7awzrpFRjP9GmNNHgTMDYdg
	 ywa1m7KJfls53sP7VOSrpywSBBCq1YFo/pSKundjcx/GGTHX3j/GTZZ0FsKd9rXtPU
	 SpL6sKdCpDUhkUm8B+7AraR1l4Nd/fqoRqxhAf8Xxq5nklud1lOPrw1ZFZo2NowCnx
	 zVvdN4exS+PwLlvd5/9RtGBW3TcjZbttRPvHgWViPR6LCrdS0Bup+ayJ/ItoTJseJq
	 c8JC9nSkBEyxymd0ZRRF0Id9Unu7/VWknsVLPMpgiPsDrkk/C2JaNtHHJKx2MVOuGS
	 EP0rtF0bSEn+Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-gpio@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] pinctrl: sx150x: add missing MODULE_DEVICE_TABLE()
Date: Mon, 19 Oct 2026 09:51:00 -0400
Message-ID: <20261019135441.1420968-369-sashal@kernel.org>
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

[ Upstream commit 5fe4b12c087db3e565f53b87f1dafdf2f0d1ee0f ]

The driver has a match table for the i2c bus wired into its driver
structure, but the table is not exported with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE() entry so module alias information
is generated for automatic module loading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the driver registration structure, and the missing module alias
publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to judge this: a one-line I2C alias export on a driver
that is modular in this tree, with OF autoload already working.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[pinctrl/sx150x] [add] [export the existing I2C match table
via MODULE_DEVICE_TABLE() so module aliases are generated]**

- Subsystem prefix: `pinctrl: sx150x:`
- Action verb: **add**
- Claimed intent: publish missing I2C module aliases for automatic
  loading

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Commit: `5fe4b12c087db3e565f53b87f1dafdf2f0d1ee0f`

Record:
- **Fixes:** none (expected)
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** none
- **Acked-by:** none
- **Link:** none in the git commit (lore exists; see Phase 4)
- **Cc: stable:** none (expected)
- **Signed-off-by:** Pengpeng Hou `<pengpeng@iscas.ac.cn>` (author);
  Linus Walleij `<linusw@kernel.org>` (pinctrl maintainer)
- Ignored pipeline markers: none present on this commit

Notable pattern: no user/syzbot report; maintainer SOB only.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** `sx150x_id[]` is wired as `sx150x_driver.id_table` but not
  exported with `MODULE_DEVICE_TABLE(i2c, ...)`.
- **Symptom:** depmod/udev never get `i2c:sx1501q` … `i2c:sx1509q`
  aliases, so the module does not autoload for I2C-name instantiation.
- **Version info:** none in the message.
- **Root cause (author):** match table is used at registration but not
  published for `file2alias` / modules.alias.
- Author states this is a **source-level** finding with **no hardware
  reproduction**.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: **Not a disguised cleanup.** It is an explicit autoload/metadata
fix. The “source-level” wording means the author inferred the bug from
the missing macro, not from a crash.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `drivers/pinctrl/pinctrl-sx150x.c` — **+1 / −0**
- Function/data: none; one statement after `sx150x_id[]`
- Scope: **single-file surgical fix**

```850:856:drivers/pinctrl/pinctrl-sx150x.c
        { .name = "sx1509q", .driver_data =
(kernel_ulong_t)&sx1509q_device_data },
        { }
};
MODULE_DEVICE_TABLE(i2c, sx150x_id);
```

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Before:** OF table already had `MODULE_DEVICE_TABLE(of,
  sx150x_of_match)`. I2C table was registered via `.id_table` but not
  aliased.
- **After:** `scripts/mod/file2alias.c` `do_i2c_entry()` emits
  `i2c:<name>` aliases (`I2C_MODULE_PREFIX` is `"i2c:"`).
- Path affected: **module build / depmod / udev autoload**, not
  probe/runtime logic.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- **Category:** hardware enablement / module autoload (same family as
  device-ID publication)
- **Mechanism:** without `MODULE_DEVICE_TABLE(i2c, sx150x_id)`,
  `file2alias` never sees the I2C table. DT devices still autoload via
  OF aliases (`i2c_device_uevent()` prefers
  `of_device_uevent_modalias()`). Non-DT instantiation (`new_device`,
  i2c-USB, board info) emits `MODALIAS=i2c:<name>` and would fail to
  autoload.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- Obviously correct: matches `Documentation/i2c/writing-clients.rst`.
- Minimal: one line, no API/locking/data-structure change.
- Regression risk: **very low** (modinfo aliases only; no runtime path
  change).
- Red flags: none.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- `sx150x_id[]` introduced in `9e80f9064e73f` (**2016**, v4.10-era):
  “pinctrl: Add SX150X GPIO Extender Pinctrl Driver”. That commit
  **removed** `MODULE_DEVICE_TABLE` because the driver was `bool`
  (citing gpio-sx150x `module.h` cleanup).
- I2C `MODULE_DEVICE_TABLE` added only by this commit (`5fe4b12c087db`,
  2026-07-10).
- Modularization: `fe2e8f17a56fe` (2025-08-19) made `PINCTRL_SX150X`
  **tristate** and added **only** `MODULE_DEVICE_TABLE(of, ...)`.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: **No Fixes: tag.** Buggy omission is from `fe2e8f17a56fe`
(incomplete modularization), not from a tagged regression.
`fe2e8f17a56fe` is an ancestor of this HEAD.

**Step 3.3: CHECK FILE HISTORY**

Record:
- Related: `fe2e8f17a56fe` (tristate + OF aliases); `dbbb19b8e412f`
  (allow `depends on I2C` so it can be `=m` when I2C is a module, landed
  later in 7.3).
- Standalone one-liner; not patch X/Y.
- Prerequisite for *meaning*: driver must be buildable as a module
  (`fe2e8f17a56fe`). That is in this tree.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Pengpeng Hou is **not** the pinctrl maintainer. Large sweep of
“add missing MODULE_DEVICE_TABLE()” across
rtc/vdpa/watchdog/clk/soc/etc. This is a systematic metadata sweep,
applied here by Linus Walleij.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: No new helpers. Applies anywhere `sx150x_id[]` exists (since
2016). Standalone. User-visible only when `PINCTRL_SX150X=m`.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- **Lore:**
  https://patch.msgid.link/20260704152230.51188-1-pengpeng@iscas.ac.cn
- **Revisions:** v1 only (`b4 dig -a`)
- Thread (mbox via `b4 dig -m`): submission + Linus Walleij **“Patch
  applied!”**
- No NAK, no review changes, **no Cc: stable** from author or maintainer
- WebFetch of lore.kernel.org returned **403**; discussion read from the
  saved mbox instead

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`): To Linus Walleij; Cc linux-gpio, linux-kernel.
Maintainer applied it. No other reviewers.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: **No bugzilla/syzbot/user report.** Author: source-level only.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Standalone v1. Same author has many sibling MODULE_DEVICE_TABLE
patches; none are prerequisites for this hunk.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: **UNVERIFIED** on lore.kernel.org/stable (HTTP 403). No `Cc:
stable` in commit or mbox.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**

Record: No functions changed. Touches `sx150x_id[]` publication.
Related: `sx150x_driver`, `sx150x_init()` → `i2c_add_driver()`.

**Step 5.2: TRACE CALLERS**

Record:
- `sx150x_init()` is `subsys_initcall` / module init; only caller of
  `i2c_add_driver(&sx150x_driver)`.
- `sx150x_probe()` is the I2C probe (line 1123). Bound via OF match or
  `id_table`.
- Not IRQ/hot-path; device enumeration / module autoload.

**Step 5.3: TRACE CALLEES**

Record: `MODULE_DEVICE_TABLE` is a build-time alias for `file2alias`. No
allocations, locks, or I/O.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record:
- DT boards (qcs615-ride, imx8mp-aristainetos3, kirkwood-l-50,
  vf610-zii, at91-natte, …): uevent uses **OF** modalias; already
  covered.
- Non-DT: `i2c_device_uevent()` falls through to
  `MODALIAS=i2c:<client->name>`. Original 2016 commit tested **x86_64
  I2C-USB** as well as BeagleBone DT — that path needs I2C aliases.
- Userspace `new_device` can also trigger it.
- Reachable: yes, from device enumeration / sysfs, not a syscall crash
  path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Same missing-macro pattern across many drivers in this cycle. OF
table in this file already had the macro; I2C table was the gap.

semcode MCP: **not available**; used git/grep/read.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record:
- Local tree: **`v7.3-rc4-27-gf0100363d8c37`**, `make kernelversion` =
  **7.3.0-rc4**, detached HEAD on mainline.
- Driver file present; Kconfig is `tristate`; both MODULE_DEVICE_TABLE
  lines present **because this commit is already in HEAD**.
- Bug existed in this lineage from `fe2e8f17a56fe` (in v6.18) until
  `5fe4b12c087db` (first in **v7.3-rc1**).
- `git merge-base --is-ancestor 5fe4b12c087db HEAD` → **yes**.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply.** Single line after `sx150x_id[]`. Pre-fix parent
still has the table and OF `MODULE_DEVICE_TABLE`. Context around named
initializers (`84c0fe4a2085f`) does not affect the added line.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: OF aliases already added by `fe2e8f17a56fe`. No other I2C alias
fix. This is the remaining hole, not a duplicate.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**

Record: **pinctrl / I2C GPIO expander driver**
(`drivers/pinctrl/pinctrl-sx150x.c`). Criticality: **PERIPHERAL**
(specific Semtech SX150x chips on a handful of boards). Not mm/fs/net
core.

**Step 7.2: SUBSYSTEM ACTIVITY**

Record: pinctrl is actively developed (frequent 7.3 merges). This driver
is mature (2016); the modularization is recent (6.18).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**

Record: **Driver-specific / config-specific:**
`CONFIG_PINCTRL_SX150X=m`, and instantiation **without** a working OF
(or ACPI) modalias — I2C name match. DT users already autoload via OF.

**Step 8.2: TRIGGER CONDITIONS**

Record:
- Trigger: module not loaded; I2C client named `sx1501q`…`sx1509q`
  appears (sysfs `new_device`, non-DT board, I2C-USB).
- Commonness: **low** on in-tree DT boards; **real** for the non-OF path
  the driver was written to support.
- Unprivileged trigger: no (needs device creation / root sysfs).

**Step 8.3: FAILURE MODE SEVERITY**

Record:
- Failure: GPIO/pinctrl expander **does not bind** until manual
  `modprobe`. No oops, deadlock, or corruption.
- Severity: **MEDIUM** for affected modular non-DT users; **LOW** for
  typical DT boards.
- Not CRITICAL.

**Step 8.4: RISK-BENEFIT RATIO**

Record:
- **Benefit:** modest — restores I2C autoload for a modular driver that
  documents non-OF use.
- **Risk:** very low — one compile-time alias line.
- **Ratio:** favorable. Same class as publishing device IDs.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR backporting:**
- Real autoload bug once the driver is a module (this tree: tristate).
- One line, obviously correct, maintainer-applied.
- Zero runtime regression risk.
- Same user-visible class as device-ID additions (module aliases).
- I2C `id_table` is actually used (`.id_table = sx150x_id`); OF aliases
  do not cover the i2c: modalias path.
- Original driver was tested on non-OF x86 I2C-USB.

**AGAINST:**
- Not a crash/UAF/security/corruption/deadlock issue.
- No user report; author says source-level only.
- DT autoload already works via OF `MODULE_DEVICE_TABLE`.
- Peripheral expander, small user set.
- Automated MODULE_DEVICE_TABLE sweep, not a targeted production
  incident.

**UNRESOLVED:**
- Whether stable@ already discussed this (lore 403).
- How many distros set `PINCTRL_SX150X=m` vs `=y`.

**Step 9.2: STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — correct by construction;
   maintainer applied. Hardware test not claimed.
2. Fixes a real bug that affects users? **PASS** — missing I2C aliases
   prevent autoload for non-DT / `i2c:` modalias.
3. Important issue? **PASS** (as device-ID / enablement, not as crash).
   User-visible: device never probes until manual modprobe. Stable text
   allows “add a device ID”; this publishes existing IDs.
4. Small and contained? **PASS** — +1 line, one file.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — applies cleanly; this
   checkout already contains the equivalent change.

**Step 9.3: EXCEPTION CATEGORIES**

Record: **Device ID / module alias publication** (not a new driver).
Closest exception: adding/exporting IDs on an existing driver so
hardware binds automatically.

**Step 9.4: DECISION**

This tree is **7.3-rc4 mainline**, where `PINCTRL_SX150X` is tristate
and the I2C table is live. The patch does not change runtime logic; it
only emits the aliases `file2alias` needs for `i2c:sx150*q`. That is a
real, contained autoload fix with essentially no regression risk. DT
boards already worked; the I2C table still matters for the non-OF path
this driver has supported since 2016.

It meets stable rules as a small, obviously correct hardware-binding
fix, not as a crash fix.

---

### What the commit solves (for this tree)

When built as a module, udev/modprobe cannot match
`MODALIAS=i2c:sx1509q` (and siblings) because those aliases were never
generated. Probe itself was fine if the module was loaded by hand or via
OF. The one-line `MODULE_DEVICE_TABLE(i2c, sx150x_id)` closes that gap.

### Risk vs benefit

Benefit is autoload for modular, non-DT (or sysfs-instantiated) SX150x
users. Risk is negligible. That trade-off is acceptable for stable.

### Concerns

No `Fixes:`/`Cc: stable` (not a negative by itself). Impact is not a
panic. Prerequisite modularization is already in this lineage. No
backport rework needed.

---

### Verification

- **[Phase 1]** Parsed `5fe4b12c087db`: subject/body/SOBs; no
  Fixes/Reported-by/stable Cc
- **[Phase 2]** Diff: +1 `MODULE_DEVICE_TABLE(i2c, sx150x_id)` in
  `pinctrl-sx150x.c`
- **[Phase 2]** Confirmed OF table already has `MODULE_DEVICE_TABLE(of,
  sx150x_of_match)` (line 870)
- **[Phase 2]** Confirmed `.id_table = sx150x_id` (line 1281)
- **[Phase 3]** `git blame`: table from `9e80f9064e73f` (2016); OF macro
  from `fe2e8f17a56fe`; I2C macro from this commit
- **[Phase 3]** `git show fe2e8f17a56fe`: tristate + OF
  MODULE_DEVICE_TABLE + MODULE_LICENSE; I2C table omitted
- **[Phase 3]** `git log --author=Pengpeng Hou`: many sibling
  MODULE_DEVICE_TABLE commits
- **[Phase 4]** `b4 dig -c 5fe4b12c087db`: lore msgid
  `20260704152230.51188-1-pengpeng@iscas.ac.cn`
- **[Phase 4]** `b4 dig -a`: v1 only
- **[Phase 4]** `b4 dig -w`: Linus Walleij + linux-gpio
- **[Phase 4]** mbox: “Patch applied!”; no NAK; no stable nomination
- **[Phase 4]** WebFetch lore/stable: **403 UNVERIFIED**
- **[Phase 5]** `i2c_device_uevent`: OF, then ACPI, then `i2c:` name
  (`drivers/i2c/i2c-core-base.c:163-176`)
- **[Phase 5]** `do_i2c_entry` emits `i2c:%s`
  (`scripts/mod/file2alias.c:855-860`)
- **[Phase 5]** In-tree DTS uses `semtech,sx150xq` compatibles
- **[Phase 5]** No ACPI table in this driver
- **[Phase 6]** `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`;
  `kernelversion` 7.3.0-rc4
- **[Phase 6]** `git merge-base --is-ancestor 5fe4b12c087db HEAD` → yes
- **[Phase 6]** Tags: fix first in v7.3-rc1; tristate in v6.18; missing
  in v7.2
- **[Phase 6]** Kconfig in this tree: `tristate` `depends on I2C`
- **[Phase 8]** Failure mode: module not autoloaded; severity
  MEDIUM/LOW, not crash
- **UNVERIFIED:** stable@ archive discussion; distro `=m` vs `=y`
  prevalence
- **UNVERIFIED:** semcode MCP not present

The fix is small, surgical, and meets stable criteria as module-alias /
device-ID enablement.

**YES**

 drivers/pinctrl/pinctrl-sx150x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinctrl-sx150x.c b/drivers/pinctrl/pinctrl-sx150x.c
index 1d6760ffe809a..f1647d9114e3b 100644
--- a/drivers/pinctrl/pinctrl-sx150x.c
+++ b/drivers/pinctrl/pinctrl-sx150x.c
@@ -850,6 +850,7 @@ static const struct i2c_device_id sx150x_id[] = {
 	{"sx1509q", (kernel_ulong_t) &sx1509q_device_data },
 	{}
 };
+MODULE_DEVICE_TABLE(i2c, sx150x_id);
 
 static const struct of_device_id sx150x_of_match[] = {
 	{ .compatible = "semtech,sx1501q", .data = &sx1501q_device_data },
-- 
2.53.0

