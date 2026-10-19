Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611C05BA3CB;
	Mon, 19 Oct 2026 14:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418455; cv=none; b=qC07lHUFsIgyZmD10B+O8TxYQ5+CjlLVCIEASCmTnfltxgD8xWU7MMYk8WR2oNjCiiVk87A5wgkJqHd0BKJRjlievsmcEhkFhDz+O7k1OFJIbtS5WpeGhLffYvFKn+6eWp6831X3Ab7H7z3+CibRgVjOBumppqFgxdoPy7188pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418455; c=relaxed/simple;
	bh=r0zsBFHATJcVfG4CZqubPjoA1F7bzzSDI9zIRslLnXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lkTkERMv7KsYFaYiODOsMXipqkasO/zcE70s+RuyLN80CdpHkI6j1eLyopbiodvs/+GFivqP0aC0ftxlFgVZo5u89v+E6MDPa9jtc7FiKju9v3JJYNi8n34Cb0B+zpa7YJ903Wxtybq+nIsjffngTrqYn1tLXTObSRmEJX1Xpoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FK/oHWpV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FK/oHWpV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C381F000CB;
	Mon, 19 Oct 2026 14:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418453;
	bh=6rgQydcwj3fnLt9d7NChznuTHnqmnYcDevtU01Fxjjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FK/oHWpVhQQgXfumIe1uM8UDXZPeUpJkS7Cw78IXFLbh5Q5FrYQfFX4F4pnh1eWVW
	 glTcFwqdqbIf0/Nd5D559AC2sZaXzz4c29VXXEh7g/QVk2inszqJ+x0RcARNhFHiZn
	 NwJoxW7oH0OTxEYIdlyXOl2M5Rinsjz3vt8CJjWhd0R6eDEC3A62jevst+FjYVPpYA
	 WTGTSRHxsA0EXeywYdnpsEr+C21WWaMb5nmQ+pBmjHx4qseayBG8TooJPrxpjv/bqk
	 nZ4U2MWaG60foR2iP2FWx6Jr2Yqb5SqWtZAezUM+3AquiSsLJH+BUWTJF1NBbPkLIU
	 6mhH1sAy4bHAA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	adrian.hunter@intel.com,
	ychuang3@nuvoton.com,
	schung@nuvoton.com,
	linux-mmc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] mmc: sdhci-of-ma35d1: add missing MODULE_DEVICE_TABLE()
Date: Mon, 19 Oct 2026 09:49:10 -0400
Message-ID: <20261019135441.1420968-259-sashal@kernel.org>
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

[ Upstream commit 9b3732cce41d177acac731e0b8024d72f0dfde38 ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable backport analysis: `mmc: sdhci-of-ma35d1: add missing
MODULE_DEVICE_TABLE()`

Local tree: **v7.3-rc4** (`7.3.0-rc4`, `VERSION=7 PATCHLEVEL=3
SUBLEVEL=0 EXTRAVERSION=-rc4`).
Candidate: `9b3732cce41d177acac731e0b8024d72f0dfde38`.
The driver and the missing-alias bug exist in this tree; the one-line
fix is already present here as a mainline commit.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[mmc / sdhci-of-ma35d1] [add] [export OF match table via
MODULE_DEVICE_TABLE so the module can autoload]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Fixes:** none (expected)
- **Reported-by / Tested-by / Reviewed-by / Acked-by:** none
- **Link:** none in the committed message
- **Cc: stable:** none (expected)
- **Signed-off-by:** Pengpeng Hou (author); Ulf Hansson (MMC maintainer,
  applied it)
- Ignore any pipeline SOBs

Notable: maintainer SOB; no user report; no syzbot.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** OF match table is wired to `.of_match_table` but not exported
  with `MODULE_DEVICE_TABLE(of, ...)`.
- **Symptom:** `depmod`/`modinfo` get no `of:` aliases, so udev/kmod
  will not autoload `sdhci-ma35` when DT has `compatible =
  "nuvoton,ma35d1-sdhci"`. Built-in (`=y`) matching still works.
- **Version info:** none in the message. Driver introduced in v6.12-rc1.
- **Root cause:** missing `MODULE_DEVICE_TABLE` so `file2alias.c` never
  publishes the table.

Original mailing-list body (stripped before commit) said this is a
source-level fix with no hardware reproduction; evidence is the table
itself.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: **Not hidden.** It is an explicit autoload/alias fix. Same class
as “add a device ID”: the ID exists; userspace was never told.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/mmc/host/sdhci-of-ma35d1.c` — **+1 / −0**
- Function: none; one statement after `sdhci_ma35_dt_ids[]`
- Scope: **single-file, one-line surgical fix**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** `sdhci_ma35_dt_ids` is only used as `.of_match_table` (in-
  kernel match when the module is already loaded or built-in).
- **After:** same, plus `MODULE_DEVICE_TABLE(of, sdhci_ma35_dt_ids)` so
  modpost emits `MODULE_ALIAS("of:N*T*Cnuvoton,ma35d1-sdhci")`.
- Path: **module build / autoload**, not probe/error/init runtime logic.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **[Hardware enablement / missing module alias]** — category
**(h) plus logic for autoload**. Not UAF, leak, race, or crash. Without
the macro, a modular build never gets OF aliases. Confirmed by
`include/linux/module.h`: `MODULE_DEVICE_TABLE` creates a `used` alias
so `scripts/mod/file2alias.c` can find the table.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- **Quality:** obviously correct; this is the documented way to export
  OF IDs.
- **Regression risk:** negligible. Macro only adds a static alias
  symbol; no locking, no API, no runtime path change except autoload
  starts working.
- **Red flags:** none on the diff. Author is doing a wide
  `MODULE_DEVICE_TABLE` sweep (rtc, vdpa, gpio, iio, …); that does not
  make *this* line wrong. MMC maintainer applied it after trimming the
  disclaimer.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Table and driver: `addc9ecb9ddb3` (“Add Nuvoton MA35D1 SDHCI driver”),
  Shan-Chun Hung, 2024-07-16, committed 2024-08-26.
- First appeared: **v6.12-rc1** (`git describe --contains addc9ecb9ddb3`
  → `v6.12-rc1~158^2~42`).
- Original driver had the match table and `.of_match_table` and **no**
  `MODULE_DEVICE_TABLE` from day one.
- Bug age: ~v6.12 through this July 2026 fix.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: **No Fixes: tag.** Buggy commit is the original driver add,
verified by blame and by `git show addc9ecb9ddb3` (tail of the file has
the table without the macro). That commit **is** an ancestor of this
tree.

**Step 3.3: CHECK FILE HISTORY**
Record (this file only):
- `addc9ecb9ddb3` — add driver
- `078e548af9c3a` — `remove_new` → `remove`
- `01bc623f9a5c2` — drop `sdhci_pltfm_free()`
- `995832b2cebe6` — include-header churn
- `9b3732cce41d1` — this fix

No prerequisite refactor for this one line. **Standalone.**

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Pengpeng Hou is not the MMC maintainer; many similar “add
missing MODULE_DEVICE_TABLE()” commits across subsystems. Ulf Hansson
applied this one. Related MMC precedent by others: `6e540da4c1db7`
(“mmc: sdhci-of-aspeed: fix module autoloading”) is the same one-line
change **and had `Fixes:` + `Cc: stable@vger.kernel.org`**.

**Step 3.5: DEPENDENT/PREREQUISITE COMMITS**
Record: **None.** Only needs `sdhci_ma35_dt_ids` and `module.h` (already
included). Can apply standalone on any tree that has this driver.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 9b3732cce41d1` →
  https://patch.msgid.link/20260704124115.2874-1-pengpeng@iscas.ac.cn
- `b4 dig -a`: **v1 only** (2026-07-04). Applied version is that v1
  (commit message cleaned).
- Thread (mbox): Ulf Hansson, 2026-07-06: **“Applied for next (by
  cleanup of the commit message a bit), thanks!”**
- No NAK, no reviewer-requested `Cc: stable`, no risk discussion.
- lore.kernel.org HTTP fetch returned 403 (Anubis); thread recovered via
  `b4 dig -m`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc included Ulf Hansson (MMC), Adrian Hunter
(SDHCI), Nuvoton (Jacky Huang, Shan-Chun Hung), `linux-mmc`, `linux-arm-
kernel`. Right people. Only maintainer reply was “applied”.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: **No user/syzbot/bugzilla report.** Author stated it was
inferred from source. The failure mode is still deterministic for `=m`
builds.

**Step 4.4: RELATED PATCHES AND SERIES**
Record: **Standalone 1/1.** Same-week author activity is a tree-wide
missing-alias sweep, not a multi-patch MMC series.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: **UNVERIFIED** via lore.kernel.org/stable (Anubis 403). No `Cc:
stable` on this patch. Closest analogue in-tree (`sdhci-of-aspeed`
autoload) *was* explicitly nominated for stable.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**
Record: **No function body changed.** Touches `sdhci_ma35_dt_ids` and
the `sdhci_ma35_driver` registration site.

**Step 5.2: TRACE CALLERS**
Record:
- `.probe = ma35_probe` — driver-core platform probe.
- `.of_match_table = sdhci_ma35_dt_ids` — OF matching when the driver is
  present.
- `MODULE_DEVICE_TABLE` is not a runtime caller; it feeds **modpost**.
- Impact surface: modular `CONFIG_MMC_SDHCI_OF_MA35D1=m` on
  `nuvoton,ma35d1-sdhci` DT.

**Step 5.3: TRACE CALLEES**
Record: Unchanged. `ma35_probe` still does `sdhci_pltfm_init` / host
setup. Macro expands to a static alias (verified in
`include/linux/module.h`).

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: DT node `compatible = "nuvoton,ma35d1-sdhci"` → kmod alias
lookup → load `sdhci-ma35` → `ma35_probe`. Reachable on MA35D1 boot if
the driver is a module. Not a syscall/UAF path. **Userspace-visible:**
missing MMC/SD host until manual `modprobe`.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Other `sdhci-of-*.c` drivers already have
`MODULE_DEVICE_TABLE(of, ...)`. Historical MMC autoload fixes: aspeed,
am654, at91, mediatek. This driver was the outlier.

Kconfig: `MMC_SDHCI_OF_MA35D1` is **tristate** (`depends on ARCH_MA35 ||
COMPILE_TEST`), so `=m` is a supported config. Help text: “say Y or M
here.”

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** File exists; table and `.of_match_table` exist; the
missing alias was the original 6.12 code. This checkout already contains
the fix line at `drivers/mmc/host/sdhci-of-ma35d1.c:293`. `git merge-
base --is-ancestor addc9ecb9ddb3 HEAD` and `9b3732cce41d1 HEAD` both
succeed. Bug introduced **v6.12**, not after this tree.

**Step 6.2: BACKPORT COMPLICATIONS**
Record: **Clean apply.** One added line next to a table that has been
there since the driver was added. Later churn (`remove`,
`sdhci_pltfm_free`, includes) does not conflict with this hunk.

**Step 6.3: RELATED FIXES ALREADY HERE**
Record: This *is* the fix. No earlier equivalent. Sibling OF SDHCI
drivers already export their tables.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**
Record: **MMC host / SDHCI platform driver.** Criticality:
**PERIPHERAL** (Nuvoton MA35D1 only), but it is the SD/MMC host for that
SoC — root-on-SD/eMMC is a realistic layout.

**Step 7.2: SUBSYSTEM ACTIVITY**
Record: `drivers/mmc/host/` is active (many recent fixes). This
particular file is low-churn (five commits total).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**
Record: **Platform-specific / config-specific:** `ARCH_MA35` +
`CONFIG_MMC_SDHCI_OF_MA35D1=m`. Built-in (`=y`) is unaffected. Distro-
style modular kernels are the users who benefit.

**Step 8.2: TRIGGER CONDITIONS**
Record: Every boot/enumeration of `nuvoton,ma35d1-sdhci` when the driver
is a module. Not a race. Unprivileged users do not trigger it;
**boot/udev does**. Common *on that hardware* if distros ship the driver
as `=m`.

**Step 8.3: FAILURE MODE SEVERITY**
Record: **Missing driver autoload → SD/MMC host never probes → no
card/root disk until manual load.** Not oops/UAF. Severity **MEDIUM**,
**HIGH** if root is on that host and the module is not in the initramfs
by name. Same user-visible class as a missing device ID.

**Step 8.4: RISK-BENEFIT RATIO**
Record:
- **Benefit:** medium for MA35D1 modular builds (storage may not
  appear).
- **Risk:** **very low** (1 line, alias-only).
- **Ratio:** favorable. Same pattern already taken for stable on other
  SDHCI OF drivers.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: EVIDENCE**

**For backporting:**
- Real, deterministic autoload bug when `MMC_SDHCI_OF_MA35D1=m`.
- One-line, obviously correct, no new API.
- Driver has been in this lineage since v6.12; table was never exported.
- MMC maintainer applied it; SDHCI/Nuvoton were on Cc; no NAK.
- Same change as `mmc: sdhci-of-aspeed: fix module autoloading`, which
  carried `Cc: stable`.
- Matches the stable-rules “device ID” / hardware-enablement exception
  in spirit: publish an ID the driver already matches.
- Applies cleanly; no prerequisites.

**Against:**
- No `Reported-by` / no hardware reproduction (author said so).
- Peripheral SoC, not a core path.
- Not a crash, UAF, or corruption.
- No `Cc: stable` on this specific patch (Ulf took it for *next*, not as
  an urgent fix).
- Author is running a tree-wide alias sweep (quality of *this* hunk is
  still fine).

**Unresolved:**
- Whether linux-stable already discussed this (lore.kernel.org/stable
  blocked).
- How many shipping MA35D1 kernels use `=m` vs `=y` (unverified).

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — standard macro; maintainer
   applied. “Tested” is source-level, not lab hardware.
2. Fixes a real bug that affects users? **PASS** — modular autoload is
   broken; Kconfig allows `=m`.
3. Important issue? **PASS** (as device-ID / hardware-enablement, not as
   a crash). Storage host may never appear on boot.
4. Small and contained? **PASS** — +1 line, one file.
5. No new features or APIs? **PASS** — only module aliases for an
   existing compatible string.
6. Can apply to the local tree? **PASS** — driver present; hunk is the
   existing table site.

**Step 9.3: EXCEPTION CATEGORIES**
Record: **Device ID / module alias publication for an existing driver**
(same practical class as adding PCI/USB/OF IDs). Not a new driver.

**Step 9.4: DECISION**
This tree has the MA35D1 SDHCI driver and had the missing alias from
introduction until this commit. The patch is a one-line, zero-runtime-
risk fix that makes the already-supported compatible string autoload
when the driver is a module. That is stable-appropriate hardware
enablement, not a feature or refactor.

---

## What the commit solves for stable users

On Nuvoton MA35D1, `sdhci-of-ma35d1` already matches
`nuvoton,ma35d1-sdhci` **if loaded**. Without `MODULE_DEVICE_TABLE`, a
modular kernel never generates the OF alias, so the MMC/SD controller is
silent until someone runs `modprobe`. Backporting restores autoload.
Risk is essentially zero.

---

## Verification
- [Phase 1] Parsed commit `9b3732cce41d1`: no Fixes/Reported-
  by/Cc:stable; SOBs Pengpeng Hou + Ulf Hansson
- [Phase 2] Diff: +1 line `MODULE_DEVICE_TABLE(of, sdhci_ma35_dt_ids)`
  in `sdhci-of-ma35d1.c`
- [Phase 2] `MODULE_DEVICE_TABLE` expansion verified in
  `include/linux/module.h:255-257`
- [Phase 3] `git blame`: table from `addc9ecb9ddb3` (v6.12-rc1), no
  MODULE_DEVICE_TABLE until this commit
- [Phase 3] `git show addc9ecb9ddb3`: original driver had
  `.of_match_table` only
- [Phase 3] `git merge-base --is-ancestor addc9ecb9ddb3 HEAD` and
  `9b3732cce41d1 HEAD`: both true
- [Phase 3] File log: 5 commits; no extra prereqs for this line
- [Phase 3] Precedent `6e540da4c1db7` (aspeed autoload): same one-liner,
  had `Cc: stable`
- [Phase 4] `b4 dig -c/-a/-w/-m`: v1-only; lore msgid
  `20260704124115.2874-1-pengpeng@iscas.ac.cn`; Ulf “Applied for next”
- [Phase 4] WebFetch lore/patch.msgid.link: 403; thread read from mbox
  instead
- [Phase 5] Kconfig: `MMC_SDHCI_OF_MA35D1` is tristate, `depends on
  ARCH_MA35 || COMPILE_TEST`
- [Phase 5] Other `sdhci-of-*.c` already have `MODULE_DEVICE_TABLE`
- [Phase 6] `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`; `make
  kernelversion` = `7.3.0-rc4`
- [Phase 6] Current file line 293 already has the macro
- [Phase 8] Failure mode: module not autoloaded; no oops
- UNVERIFIED: linux-stable list discussion (Anubis); how common `=m` is
  on MA35D1 distro kernels

**YES**

 drivers/mmc/host/sdhci-of-ma35d1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/sdhci-of-ma35d1.c b/drivers/mmc/host/sdhci-of-ma35d1.c
index 287026422616c..73f772db04148 100644
--- a/drivers/mmc/host/sdhci-of-ma35d1.c
+++ b/drivers/mmc/host/sdhci-of-ma35d1.c
@@ -291,6 +291,7 @@ static const struct of_device_id sdhci_ma35_dt_ids[] = {
 	{ .compatible = "nuvoton,ma35d1-sdhci" },
 	{}
 };
+MODULE_DEVICE_TABLE(of, sdhci_ma35_dt_ids);
 
 static struct platform_driver sdhci_ma35_driver = {
 	.driver	= {
-- 
2.53.0

