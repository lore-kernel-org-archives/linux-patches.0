Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06FB5581F6;
	Mon, 31 Aug 2026 13:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184042; cv=none; b=M6b29C6yb3WaKaQ3qSqClt0AmiYJloJrobuFQ+yWQ/OxO639guTV8XpUNDWpWBjO4SJ+p8nZ0UaBzIKbujmodjsH3jxpkt4wbBS1Ev+rm5+QO7s3uQc1cp7+ke1wI+mfsIWwHc10L0mCmd1TGxlwxrPbJxv77XtIHL9ZTQTPGSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184042; c=relaxed/simple;
	bh=UDniQRXqG1Qtp036Q23As0+rK2KElb55TyMS/11Lv24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HNCZ5ewjqzNWQFHFSKU1sZKOWeuI4Y/toRX6e9sEDjRVpNAQ3Q8/zvGPKWo8UwIOH/VyNC05spBRc4lHxDqZAMKgABpxfHPVgDR+ExzjA9XfTK6D8Mn1lMK2QS5hPL32FGVG30LUzBHGOM7jQmzowVS1ycTGH2QdV64xo7eBX/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dIJrYB2b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dIJrYB2b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE8E1F00A3F;
	Mon, 31 Aug 2026 13:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184037;
	bh=z2Kbe/zPm1x6xNOLJ89bP0O7FoCKFHJ7ZDF6yEYrr7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dIJrYB2buLYi+DhmUch0J7EEsdKMQJcQGRKOoUg5AXKHYdu4d5nU3+0C9UlYgGOhQ
	 K0SNT6DmiMp7E2E6XNm9R5KvSf6+vcszwW3DJ6k0236tiUcVnE1PUByZwsXy1uBg7E
	 EElDFJmx5+0vIQs5OZDElWCBJGuDb0bI/EEifz8alA8QuI/m5zLL/ZTdzysTGxLojY
	 v8HFuCuvMe2lTYHZpVApiB9ovCuCEYW1gMMKYae0zMqxtUY410flqS2EpPNcBos+rr
	 iwqR6624wRZGfzV8K53ldr+vnbk8uMnDe7WiUm6CUNAGW0Zl+0y9rvJDwPyPRbqETt
	 eAih+IDL4Gbxg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xue Lei <Xue.Lei@windriver.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-rtc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] rtc: mv: add suspend/resume support for wakeup
Date: Mon, 31 Aug 2026 09:28:02 -0400
Message-ID: <20260831133314.4125787-454-sashal@kernel.org>
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

From: Xue Lei <Xue.Lei@windriver.com>

[ Upstream commit 851d961ff248218f681c53cf0f7f08cf8201a117 ]

Add PM suspend/resume callbacks to enable/disable IRQ wake for the
RTC alarm interrupt. This allows the RTC alarm to wake the system
from STR (e.g. via rtcwake -m mem -s N).

Without this, the RTC IRQ is masked during suspend by the MPIC's
IRQCHIP_MASK_ON_SUSPEND behavior, preventing alarm-based wakeup.

Signed-off-by: Xue Lei <Xue.Lei@windriver.com>
Link: https://patch.msgid.link/20260611023350.1370881-1-Xue.Lei@windriver.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[rtc: mv]` `[add]` — Add suspend/resume PM callbacks so the
Marvell Orion RTC alarm IRQ can wake the system from STR.

### Step 1.2: Tags
**Record:**
- **Fixes:** — none
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none (maintainer applied directly)
- **Acked-by:** — none
- **Link:** https://patch.msgid.link/20260611023350.1370881-1-
  Xue.Lei@windriver.com
- **Cc: stable:** — none (expected for manual review)
- **Signed-off-by:** Xue Lei, Alexandre Belloni (ignore pipeline SOB
  markers)

Notable: RTC subsystem maintainer (Belloni) applied the patch; no syzbot
or user bug reports.

### Step 1.3: Body Analysis
**Record:**
- **Bug:** RTC alarm cannot wake the system from suspend-to-RAM
  (`rtcwake -m mem -s N` fails).
- **Symptom:** System stays suspended past the alarm time; scheduled
  wake does not occur.
- **Root cause (author):** During suspend, the parent irqchip masks non-
  wakeup IRQs (`IRQCHIP_MASK_ON_SUSPEND`). Without `enable_irq_wake()`
  in the driver suspend path, the RTC alarm IRQ is masked and cannot
  fire.
- **Version info:** None in the message.

### Step 1.4: Hidden Bug Fix?
**Record:** Yes. Subject says “add suspend/resume support,” but this
completes broken wakeup behavior: the driver already calls
`device_init_wakeup(&pdev->dev, true)` when an IRQ is present (since
alarm support was added in 2009), yet never called `enable_irq_wake()`.
That is incomplete PM integration, not a new user-facing feature.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/rtc/rtc-mv.c` (+23 lines, 0 removed)
- **Functions added:** `mv_rtc_suspend()`, `mv_rtc_resume()`
- **Structure modified:** `mv_rtc_driver` (adds `.pm = &mv_rtc_pm_ops`)
- **Scope:** Single-file, surgical driver PM fix

### Step 2.2: Code Flow Change
**Record:**
- **Hunk 1 (suspend/resume):** Before: no driver PM callbacks; IRQ
  treated as a normal interrupt during suspend. After: if
  `device_may_wakeup(dev)` and `pdata->irq >= 0`, call
  `enable_irq_wake()` on suspend and `disable_irq_wake()` on resume.
- **Hunk 2 (driver struct):** Registers `SIMPLE_DEV_PM_OPS` with the
  platform driver.
- **Path affected:** System suspend/resume (`CONFIG_PM_SLEEP`), only
  when the RTC has a valid IRQ and wakeup is enabled.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Logic/correctness — incomplete PM wakeup integration.
- **Mechanism:** `kernel/irq/pm.c` `suspend_device_irq()` masks IRQs
  with `IRQCHIP_MASK_ON_SUSPEND` unless `irqd_is_wakeup_set()`.
  `device_init_wakeup()` alone does not set that flag;
  `enable_irq_wake()` does. Without it, the RTC alarm IRQ is masked at
  the irqchip during suspend and cannot wake the system.

### Step 2.4: Fix Quality
**Record:**
- **Quality:** Obviously correct; identical pattern used in `rtc-
  armada38x.c`, `rtc-tegra.c`, `rtc-cmos.c`, and many other RTC drivers
  in this tree.
- **Regression risk:** Very low. Symmetric enable/disable, guarded by
  `device_may_wakeup()` and `pdata->irq >= 0`.
- **Red flags:** None.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:**
- `device_init_wakeup()` at line 267: introduced with alarm support,
  present since commit `aeedacaeaf9c0` (2009-12-16, “rtc-mv: add support
  for Alarm”).
- PM suspend/resume callbacks: **not present** in this tree; added by
  candidate commit `851d961ff2482` (on `master`, not yet in HEAD).

### Step 3.2: Fixes: Tag
**Record:** No `Fixes:` tag. Bug dates to original alarm/wakeup support
(2009); never had `enable_irq_wake()`.

### Step 3.3: Related File History
**Record:** Recent `rtc-mv.c` changes are cleanups (`ede66fb37f127`,
`5621f28b01228`, `8c28c4993f117`). No prior wakeup PM fix. Standalone
1/1 patch (b4 dig confirms single revision).

### Step 3.4: Author Context
**Record:** Xue Lei (Wind River, embedded). Alexandre Belloni (RTC
maintainer) applied. No related series from this author in `rtc-mv.c`.

### Step 3.5: Dependencies
**Record:** No prerequisites. Uses standard kernel PM/IRQ APIs present
in 6.18.44. `git apply --check` on the diff succeeds against the current
tree.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:**
- **URL:** https://patch.msgid.link/20260611023350.1370881-1-
  Xue.Lei@windriver.com
- **Revisions:** v1 only (b4 dig `-a`)
- **Review:** Belloni replied “Applied, thanks!” — no NAKs, no
  objections
- **Stable nomination:** None in thread

### Step 4.2: Reviewers
**Record:** CC’d: `linux-rtc@vger.kernel.org`, `linux-
kernel@vger.kernel.org`, Belloni. Maintainer applied.

### Step 4.3: Bug Report
**Record:** No external bug report or syzbot link. Issue inferred from
irqchip PM behavior and missing driver callback.

### Step 4.4: Related Patches
**Record:** Sister driver `rtc-armada38x.c` already implements the same
`enable_irq_wake`/`disable_irq_wake` pattern (lines 543–571). `rtc-mv.c`
was the outlier.

### Step 4.5: Stable List History
**Record:** Not searched on lore stable list; no stable discussion found
in the patch thread.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `mv_rtc_suspend()`, `mv_rtc_resume()`, `mv_rtc_probe()`
(calls `device_init_wakeup`), `mv_rtc_alarm_irq_enable()`,
`mv_rtc_interrupt()`.

### Step 5.2: Callers
**Record:** PM core invokes driver suspend/resume during system STR.
`mv_rtc_probe()` runs at platform device init on Marvell boards
(Kirkwood, Dove, Armada 370/375). Users trigger wakeup via `rtcwake` or
`/sys/class/rtc/rtcX/wakealarm`.

### Step 5.3: Callees
**Record:** `enable_irq_wake()`, `disable_irq_wake()`,
`device_may_wakeup()`, `dev_get_drvdata()`.

### Step 5.4: Reachability
**Record:** Reachable on any `marvell,orion-rtc` platform with IRQ,
`CONFIG_PM_SLEEP`, and STR support. DT platforms verified: Kirkwood,
Dove, Armada 370/375 (`arch/arm/boot/dts/marvell/*.dtsi`). Commit’s
“MPIC” reference matches `drivers/irqchip/irq-armada-370-xp.c` irqchip
named `"MPIC"` with `IRQCHIP_MASK_ON_SUSPEND`.

### Step 5.5: Similar Patterns
**Record:** 40+ RTC drivers in this tree use the same `enable_irq_wake`
in suspend pattern. `rtc-armada38x.c` is the closest Marvell sibling.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** Local tree is **Linux 6.18.44** (`git describe`:
`v6.18.44-1-g2736c32da98b9`). `drivers/rtc/rtc-mv.c` has
`device_init_wakeup(&pdev->dev, true)` (line 267) but **no** PM ops or
`enable_irq_wake()`. Candidate commit `851d961ff2482` is on `master` but
**not** an ancestor of HEAD.

### Step 6.2: Backport Complications
**Record:** Clean apply verified (`git apply --check` passes). No
conflicting recent changes in the insertion region.

### Step 6.3: Related Fixes Already Present?
**Record:** None for `rtc-mv` wakeup PM. `rtc-armada38x` already has the
fix; `rtc-mv` does not.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem
**Record:** `drivers/rtc` — **IMPORTANT** (embedded/NAS platforms:
Marvell Kirkwood, Dove, Armada). Not core kernel, but affects PM on real
deployed hardware.

### Step 7.2: Activity
**Record:** Moderate activity; recent changes are cleanups, not PM
rework.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of Marvell Orion RTC on platforms with STR and a wired
RTC IRQ (Kirkwood NAS, Dove, Armada 370/375, etc.). Config-dependent:
`CONFIG_RTC_DRV_MV` + `CONFIG_PM_SLEEP` + working IRQ.

### Step 8.2: Trigger Conditions
**Record:** User sets RTC alarm and suspends (`rtcwake -m mem`,
`wakealarm` sysfs, or equivalent). **Common** on embedded systems using
scheduled wake. Unprivileged users can typically set RTC alarms.

### Step 8.3: Failure Mode Severity
**Record:** **MEDIUM** — no crash, corruption, or deadlock. System fails
to wake on schedule; operational impact for scheduled maintenance, NAS
wake, industrial controllers. Wakeup is advertised via
`device_init_wakeup()` but does not work.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Restores intended RTC alarm wakeup from STR on affected
  Marvell hardware.
- **Risk:** Very low (23 lines, established pattern, irq >= 0 guard).
- **Ratio:** Favorable — fixes a long-standing functional defect with
  minimal code.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, reproducible functional bug (rtcwake/STR wakeup broken)
- Driver already registers as wakeup-capable since 2009
- Standard, proven fix pattern (sibling `rtc-armada38x` already has it)
- Small, self-contained, applies cleanly to 6.18.44
- Maintainer-reviewed and applied
- Affects deployed embedded hardware

**AGAINST backport:**
- Not a crash, security, corruption, or deadlock
- Subject wording sounds like “adding feature”
- No user bug report or syzbot evidence
- Long-standing issue (lower urgency than regressions)

**Unresolved:** No end-user bugzilla report; impact quantified only by
code analysis and platform DT presence.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — standard pattern; maintainer
   applied; no review objections.
2. Fixes a real bug affecting users? **PASS** — broken STR wakeup on
   Marvell RTC platforms.
3. Important issue? **PASS (borderline)** — not crash/security, but
   broken suspend wakeup on hardware that advertises wakeup support;
   operational impact on embedded systems.
4. Small and contained? **PASS** — 23 lines, one file.
5. No new features or APIs? **PASS** — completes existing wakeup
   registration; no new sysfs/APIs.
6. Can apply to local tree? **PASS** — verified clean apply.

### Step 9.3: Exception Categories
**Record:** Suspend/resume hardware wakeup workaround — same category as
other RTC `enable_irq_wake` fixes. Not a device-ID/quirk/DT/build/doc
exception, but functionally equivalent to a PM quirk fix.

### Step 9.4: Decision Rationale

For **Linux 6.18.44**, this commit should be backported. The driver has
advertised wakeup capability via `device_init_wakeup()` since alarm
support was added, but without `enable_irq_wake()` the alarm IRQ is
masked during suspend on irqchips with `IRQCHIP_MASK_ON_SUSPEND`
(including Marvell Armada’s “MPIC” irqchip). That makes `rtcwake -m mem`
silently fail on affected Marvell platforms. The fix is minimal, follows
an established pattern already used in `rtc-armada38x.c` and dozens of
other RTC drivers, applies cleanly, and carries negligible regression
risk while restoring expected PM behavior.

---

## Verification

- [Phase 1] Parsed commit `851d961ff2482`: tags, body, intent recorded
- [Phase 2] Read full diff: +23 lines in `drivers/rtc/rtc-mv.c`, PM ops
  added
- [Phase 3] `git describe HEAD`: v6.18.44-1-g2736c32da98b9; Makefile
  VERSION 6.18.44
- [Phase 3] `git merge-base --is-ancestor 851d961ff2482 HEAD`: NOT IN
  TREE
- [Phase 3] `git log -S device_init_wakeup -- drivers/rtc/rtc-mv.c`:
  alarm added `aeedacaeaf9c0` (2009)
- [Phase 3] `git blame -L 266,270 drivers/rtc/rtc-mv.c`:
  `device_init_wakeup` present, no PM callbacks
- [Phase 3] `git apply --check` on commit diff: applies cleanly
- [Phase 4] `b4 dig -c 851d961ff2482`: found lore thread
- [Phase 4] `b4 dig -a`: single v1 revision
- [Phase 4] `b4 dig -w`: CC’d linux-rtc, Belloni
- [Phase 4] Mbox thread: Belloni “Applied, thanks!” — no stable Cc, no
  NAKs
- [Phase 5] Read `kernel/irq/pm.c` suspend path:
  `IRQCHIP_MASK_ON_SUSPEND` masks non-wakeup IRQs
- [Phase 5] Read `drivers/irqchip/irq-armada-370-xp.c`: MPIC chip has
  `IRQCHIP_MASK_ON_SUSPEND`
- [Phase 5] Grep `enable_irq_wake` in `drivers/rtc/`: 40+ drivers use
  same pattern
- [Phase 5] Read `rtc-armada38x.c` lines 543–571: identical
  suspend/resume wakeup handling
- [Phase 6] Read current `drivers/rtc/rtc-mv.c`: missing PM ops
  (confirmed buggy state)
- [Phase 6] Grep `marvell,orion-rtc` in `arch/arm/boot/dts/marvell/`:
  Kirkwood, Dove, Armada platforms
- [Phase 6] `git log --oneline -20 -- drivers/rtc/rtc-mv.c`: no prior
  wakeup PM fix

**YES**

 drivers/rtc/rtc-mv.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/rtc/rtc-mv.c b/drivers/rtc/rtc-mv.c
index c27ad626d09fc..f88976fd6d5da 100644
--- a/drivers/rtc/rtc-mv.c
+++ b/drivers/rtc/rtc-mv.c
@@ -301,6 +301,28 @@ static const struct of_device_id rtc_mv_of_match_table[] = {
 MODULE_DEVICE_TABLE(of, rtc_mv_of_match_table);
 #endif
 
+#ifdef CONFIG_PM_SLEEP
+static int mv_rtc_suspend(struct device *dev)
+{
+	struct rtc_plat_data *pdata = dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev) && pdata->irq >= 0)
+		enable_irq_wake(pdata->irq);
+	return 0;
+}
+
+static int mv_rtc_resume(struct device *dev)
+{
+	struct rtc_plat_data *pdata = dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev) && pdata->irq >= 0)
+		disable_irq_wake(pdata->irq);
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(mv_rtc_pm_ops, mv_rtc_suspend, mv_rtc_resume);
+
 /*
  * mv_rtc_remove() lives in .exit.text. For drivers registered via
  * module_platform_driver_probe() this is ok because they cannot get unbound at
@@ -312,6 +334,7 @@ static struct platform_driver mv_rtc_driver __refdata = {
 	.driver		= {
 		.name	= "rtc-mv",
 		.of_match_table = of_match_ptr(rtc_mv_of_match_table),
+		.pm	= &mv_rtc_pm_ops,
 	},
 };
 
-- 
2.53.0

