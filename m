Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DEDE50841C;
	Mon, 19 Oct 2026 14:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418612; cv=none; b=m26y8lKZsuZY2BmqJa2Ly1v/gFSgI7WucL5mH8KtNbTA7So64tbw+G0ltdXbU8LSTYW95HIpesM1yKGIXfaaaau3/dv4f+0W3aZRY+/gJ6zgdXDnUHsMNXS3P4Kv0I9PiRHnC195ZsC7Hty69DXn7c5VLf7oeyXlN54TSfQP+4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418612; c=relaxed/simple;
	bh=BcvsgOYZE/XsJ+D+p03Dqf37OQAI3d1cOGaFE1fdTxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ohgssXtY0O08pmdRH6kmC0jzLRenVoRASRSkh62JI22BKYv1nePWA7zc1oXzQMAc3cR+aY+U2jKnHZ8vnYzDgfI1a1Golm18Kkq4f0l299k+7Wk3+qXNf/AyyeY39v02aorJCNLGgJSUjahIPfknJ0jZVPxXIiGilQZVqf/u2Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nqpfLuB3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nqpfLuB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7B81F000C4;
	Mon, 19 Oct 2026 14:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418609;
	bh=3XWOh0TlZD3lVy6AJyQ1GhSc9Trgig1dArAlc2AK3/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nqpfLuB3FIE/Z/N+YcpGlDmc2DAVEroXp720IkqOU6/Y2l4079xYoG0Z9j8f9A55v
	 PkAmO51uL56pg1PyRuK83gfDGL3o7ODxMWdkkH2rcl8waYvvrxCEC5p1+ksRnKE/xG
	 aKF3Bct7KhGpqSAfFIW9nwtKtnSchbR6kFI1QiLpt0w2RiQawBlvLi00qxxUdSjqo3
	 tkGlPmaHf64+9dM1Ly7nFpvVIIXnFc/kYLZfx8am7+SjySomJd9K2e5njEvZcqnzva
	 WpO0uLRf0v1Dl2nabFnFmj7dPI9YDk9kmRtDt4mu9Ihbiq4iz5MVLguBLQPGGaHZEs
	 hI2dUc9BiJAKg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>,
	florian.fainelli@broadcom.com,
	linux-rtc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] rtc: brcmstb-waketimer: add missing MODULE_DEVICE_TABLE()
Date: Mon, 19 Oct 2026 09:51:01 -0400
Message-ID: <20261019135441.1420968-370-sashal@kernel.org>
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

[ Upstream commit 402c89d28fecd28652a4bfe997f08f6544836381 ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260704121734.54941-1-pengpeng@iscas.ac.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111** (`pending-6.12`). The one-line OF alias
publication is missing here, the match table is present, and the
original mailed hunk applies cleanly.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[rtc / brcmstb-waketimer] [add] [publish missing OF
MODULE_DEVICE_TABLE so the module can autoload]**

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- **Link:**
  https://patch.msgid.link/20260704121734.54941-1-pengpeng@iscas.ac.cn
- **Signed-off-by:** Pengpeng Hou (author)
- **Signed-off-by:** Alexandre Belloni (RTC maintainer; applied)
- **No Fixes:** (expected for this review)
- **No Cc: stable** (expected)
- **No Reported-by / Tested-by / Reviewed-by / Acked-by / syzbot**
- Pipeline markers (`[Upstream commit ...]`, Sasha Levin SOB) ignored
  per instructions

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** OF match table is wired to `.of_match_table` but not exported
  with `MODULE_DEVICE_TABLE()`, so modpost never emits
  `of:N*T*Cbrcm,brcmstb-waketimer` aliases.
- **Symptom:** When `CONFIG_RTC_DRV_BRCMSTB=m`, udev/kmod cannot
  autoload `rtc-brcmstb-waketimer.ko` from the DT compatible string. The
  wake-timer/RTC does not bind unless the module is loaded by hand.
- **Version info:** none in the message. Driver has been in tree since
  v4.13.
- **Root cause (author):** missing module-alias publication, evidenced
  by the driver-owned table and its use by the platform driver.
  Explicitly a source-level finding, not a live hardware repro.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: **Not disguised.** It is a real autoload bug, same class as
adding/publishing a device ID. Not style-only.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- **File:** `drivers/rtc/rtc-brcmstb-waketimer.c` (+1 / −0)
- **Function/site:** after `brcmstb_waketmr_of_match[]` (not inside a
  function)
- **Scope:** single-file, one-line surgical change
- **Upstream SHA (verified):**
  `402c89d28fecd28652a4bfe997f08f6544836381`

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- **Before:** table exists and is assigned to `.of_match_table` via
  `of_match_ptr()`. Built-in matching still works. Modular autoload does
  not, because file2alias never sees the table.
- **After:** `MODULE_DEVICE_TABLE(of, brcmstb_waketmr_of_match)` creates
  `__mod_of__brcmstb_waketmr_of_match_device_table` as an alias when
  `MODULE` is set (`include/linux/module.h`). `scripts/mod/file2alias.c`
  `do_of_entry_multi()` then emits `MODULE_ALIAS("of:N*T*Cbrcm,brcmstb-
  waketimer")`.
- **Path affected:** module install / depmod / udev autoload only.
  Probe, PM, and built-in bind paths are unchanged. When `!MODULE`, the
  macro is empty.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: **[Hardware enablement / missing device ID publication]**
- Category (h): OF alias not published, so modular bind fails.
- Not UAF, leak, race, NULL deref, or crash.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- **Quality:** obviously correct; this is the standard pattern (dozens
  of RTC drivers already have `MODULE_DEVICE_TABLE(of, ...)` in this
  tree).
- **Regression risk:** very low. Compile-time alias only.
  `__maybe_unused` on the table remains valid: built-in + `!CONFIG_OF`
  still has no C reference; as a module the alias references the table,
  which is intended.
- **No API, locking, or data-structure changes.**

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Match table and `.of_match_table` introduced in **`c4f07ecee22ec7`**
  (“rtc: brcmstb-waketimer: Add Broadcom STB wake-timer”, Brian Norris,
  2017) — first appears **v4.13-rc1**. Present in this tree (`git merge-
  base --is-ancestor` succeeded).
- `__maybe_unused` added in **`ae1247f79ddf8`** (v5.12 era) for
  `!CONFIG_OF` compile-test. That did not add `MODULE_DEVICE_TABLE`.
- Bug has been present for the entire life of the driver.

Step 3.2: FOLLOW THE FIXES: TAG
Record: **No Fixes: tag.** The introducing commit is `c4f07ecee22ec7`,
which is in this tree. No later intermediate autoload fix on this file.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record (this tree, path-limited):
- `e005a9b35b464` level alarm_irq
- `d64906b320ce6` `.remove` → `.remove_new`
- `24304a87158aa` non-wake alarm
- None of these publish OF aliases.
- **Standalone** one-line patch; not “X/Y” of a series that this file
  depends on. Parent of upstream `402c89d28fec` is a sibling RTC
  autoload fix (`rtc: s32g`), not a prerequisite for this driver.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Pengpeng Hou is not the RTC maintainer. In this tree the only
other `drivers/rtc/` commit from that author is unrelated (`rtc: zynqmp:
Return optional clock lookup errors`). Alexandre Belloni (RTC
maintainer) applied the patch. Florian Fainelli / Broadcom were on
To/Cc.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: **None.** Needs only `MODULE_DEVICE_TABLE` and the existing
`of_device_id` table, both present since the driver was added. **Can
apply standalone.**

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- **b4 dig -c 402c89d28fec:**
  https://patch.msgid.link/20260704121734.54941-1-pengpeng@iscas.ac.cn
- **b4 dig -a:** single **v1**, 2026-07-04; no v2/v3.
- Thread (3 messages): original patch; Sashiko bot “no issues”;
  Alexandre Belloni **“Applied, thanks!”** pointing at
  `https://git.kernel.org/abelloni/c/402c89d28fec`.
- **No NAK, no stable nomination, no reviewer risk flags.** WebFetch to
  lore returned 403; thread recovered via `b4 mbox`.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (b4 dig -w): To/Cc included Alexandre Belloni (RTC maintainer),
Florian Fainelli, bcm-kernel-feedback-list, linux-rtc, linux-arm-kernel,
linux-kernel. Maintainer applied it. No human Reviewed-by.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: **No user/syzbot/bugzilla report.** Author states it is source-
level. Severity from reporters: N/A. Users affected: anyone building
this driver as a module on DT platforms with `brcm,brcmstb-waketimer`.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Wave of the same one-line OF-alias pattern. This 6.12 tree
already contains:
- `330fdd1fb7d09` drm/tve200: add OF module alias for autoloading
- `2260191fbf7c6` crypto: keembay - publish OF module alias for OCS
  AES/SM4
Those are the same bug class, already accepted here. This brcmstb patch
does not depend on them.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable search via WebFetch returned 403.
**UNVERIFIED** whether this exact patch was discussed on stable@. No
local evidence it was rejected.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: **No function body changed.** Site is `brcmstb_waketmr_of_match`
/ `brcmstb_waketmr_driver`. Related runtime function:
`brcmstb_waketmr_probe`.

Step 5.2: TRACE CALLERS
Record: `brcmstb_waketmr_probe` is only referenced as `.probe` on
`brcmstb_waketmr_driver`, registered via `module_platform_driver()`.
Called from platform/OF device bind (kernel boot or module load), not
from a syscall directly. Userspace trigger is: DT node present + module
autoload (or manual `modprobe`).

Step 5.3: TRACE CALLEES
Record: Probe ioremaps, allocates an RTC device, requests IRQs,
`device_init_wakeup()`. The new line calls nothing at runtime.

Step 5.4: FOLLOW THE CALL CHAIN
Record: DT `compatible = "brcm,brcmstb-waketimer"` (in-tree on several
BMIPS boards, e.g. `arch/mips/boot/dts/brcm/bcm7435.dtsi`) → OF match →
probe. **Reachable on real STB hardware.** Autoload is the broken hop
when `=m`.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Many RTC drivers already export OF tables (`rtc-zynqmp.c`, `rtc-
mt7622.c`, …). Historical RTC fixes of the same kind: `206e04ec7539e`
(mxc_v2), `3fc990a5dbfff` (mt7622). Systematic missing-alias class, not
a one-off.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: **Yes.** `drivers/rtc/rtc-brcmstb-waketimer.c:413-424` has the
table and `.of_match_table` and **no** `MODULE_DEVICE_TABLE`. `git
merge-base --is-ancestor 402c89d28fec HEAD` failed (fix not here).
Introduced v4.13, long before 6.12.

Kconfig in this tree (`drivers/rtc/Kconfig`):
```
config RTC_DRV_BRCMSTB
        tristate "Broadcom STB wake-timer"
        depends on ARCH_BRCMSTB || BMIPS_GENERIC || COMPILE_TEST
        default ARCH_BRCMSTB || BMIPS_GENERIC
```
Explicitly modular. Default `y` on the SoCs that have the IP, so the
common defconfig path is built-in; `=m` is still a supported and
documented config.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: **Clean apply.** Original mailed hunk (3 lines of context
through `.probe`) — `git apply --check` **rc 0** on this tree. `.remove`
vs `.remove_new` is later in the struct and is not in the original hunk.
No rework needed.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: **No** commit on this file adds `MODULE_DEVICE_TABLE`. Sibling
OF-alias backports exist for other drivers (tve200, keembay), not a
substitute for this one.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: **[drivers/rtc — Broadcom STB wake-timer] [PERIPHERAL]** for
most 6.12 users; **IMPORTANT** on BCM7xxx set-top boxes (alarm/S2/S3/S5
wake). Not mm/net/block core.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Driver is mature (2017). Recent local commits are PM/IRQ and
platform-remove conversion, not a rewrite. Low churn around the match
table.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: **Driver-specific / config-specific.** Users of Broadcom STB
wake-timer with `CONFIG_RTC_DRV_BRCMSTB=m`. In-tree DT nodes are on
BMIPS boards (`bcm7346/7358/7360/7362/7425/7435`). `ARCH_BRCMSTB` also
exists on ARM and arm64; this tree’s ARM/arm64 dtsi files do not contain
the compatible string (vendor DTs may). Built-in (`=y`, the Kconfig
default on those arches) is unaffected.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record:
- Trigger: modular driver + OF device present + reliance on autoload
  (normal distro/udev path).
- Commonness: uncommon vs default `=y`; real whenever someone chooses
  `=m` (help text documents that).
- Unprivileged userspace cannot exploit this; it is bind/enablement, not
  a crash primitive.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: **[RTC/wake-timer never binds when built as a module] [MEDIUM]**
- Not oops/deadlock/corruption/CVE.
- On affected boxes, RTC alarm and suspend wake from this block can fail
  to be available until a manual `modprobe`.
- Fits stable-rules “device ID” / “oh, that’s not good” more than
  “oops”.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- **Benefit:** medium for modular STB configs (hardware actually gets
  its driver); low for default `=y` defconfigs.
- **Risk:** very low (1 line, modpost alias, no runtime behavior change
  for built-in).
- **Ratio:** favorable. Same class already merged in this 6.12.y tree.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
**FOR:**
- Real autoload bug: OF table used, aliases never generated.
- One line, obviously correct, maintainer-applied.
- Driver and buggy code exist in 6.12.111 since v4.13.
- Original patch applies cleanly here.
- Device-ID / hardware-enablement exception; wake-timer matters for STB
  suspend/resume.
- Identical OF-alias one-liners already in this tree (tve200, keembay).
- Zero runtime regression path for the default built-in config.

**AGAINST:**
- Not a crash, UAF, deadlock, or security hole.
- No user report; source-level scan.
- Kconfig default is built-in on the SoCs that have the hardware, so
  many production images never hit autoload.
- Peripheral driver, not core.

**UNRESOLVED:**
- Whether this SHA was already discussed on stable@ (lore 403).
- Whether vendor ARM/arm64 brcmstb DTs (not in this tree) also use this
  compatible.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — standard macro; RTC
   maintainer applied v1 with no objections.
2. Fixes a real bug that affects users? **PASS** — modular OF autoload
   does not work; Kconfig allows `=m`.
3. Important issue? **PASS** (device-ID / hardware-enablement class;
   functional miss for modular STB RTC/wake). Severity MEDIUM, not
   CRITICAL.
4. Small and contained? **PASS** — +1 line, one file.
5. No new features or APIs? **PASS** — publishes an alias for an
   existing match table.
6. Can apply to the local tree? **PASS** — `git apply --check`
   succeeded; code present; no missing prereqs.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: **Device ID / OF module alias publication for an existing
driver** (stable-rules: “or just add a device ID”). Closest match to the
documented ID-addition exception.

Step 9.4: MAKE YOUR DECISION
Backport. The bug is in this tree, the fix is the usual one-line alias
export, it applies cleanly, and it matches both the written device-ID
exception and OF-alias fixes already on 6.12.y. Default-y only reduces
how often it bites; it does not make the modular path fictional.

------------------------------------------------
What the commit solves for this tree
The 6.12 `rtc-brcmstb-waketimer` driver matches `brcm,brcmstb-waketimer`
but never asks modpost to emit that alias. Built as a module, the wake-
timer will not autoload. Adding `MODULE_DEVICE_TABLE(of, ...)` is the
complete fix.

Risk vs benefit
Benefit is restoring bind on modular STB configs; risk is essentially
nil. Context around `.remove_new` does not affect the original hunk.

------------------------------------------------
Verification:
- [Phase 1] Parsed tags: Link to msgid, SOB Pengpeng Hou + Alexandre
  Belloni; no Fixes/Cc stable/Reported-by
- [Phase 1] Body: missing OF alias; source-level, no hardware repro
  claimed
- [Phase 2] Diff: +1 line `MODULE_DEVICE_TABLE(of,
  brcmstb_waketmr_of_match)` after the match table
- [Phase 2] `include/linux/module.h`: macro is alias-for-modpost if
  `MODULE`, empty otherwise
- [Phase 2] `scripts/mod/file2alias.c` `do_of_entry_multi()`: emits
  `of:N*T*C<compatible>`
- [Phase 3] `git blame`: table from `c4f07ecee22ec7` (v4.13-rc1);
  `__maybe_unused` from `ae1247f79ddf8`
- [Phase 3] `git merge-base --is-ancestor c4f07ecee22ec HEAD`: intro
  commit is in this tree
- [Phase 3] `git merge-base --is-ancestor 402c89d28fec HEAD`: fix is
  **not** in this tree
- [Phase 3] `git show 402c89d28fec`: confirmed same +1 line,
  author/date/message
- [Phase 3] `git log --oneline -20 -- drivers/rtc/rtc-brcmstb-
  waketimer.c`: no prior MODULE_DEVICE_TABLE on this file
- [Phase 4] `b4 dig -c 402c89d28fec`: lore URL + v1-only series
- [Phase 4] `b4 dig -a`: only v1, 2026-07-04
- [Phase 4] `b4 dig -w`: Belloni, Fainelli, bcm-kernel-feedback-list,
  linux-rtc CC’d
- [Phase 4] `b4 mbox`: Belloni “Applied, thanks!”; Sashiko no issues; no
  NAK
- [Phase 4] WebFetch lore: 403; used b4 instead
- [Phase 4] UNVERIFIED: stable@ thread for this exact subject
- [Phase 5] Probe only used as platform `.probe`; DT compatible present
  in `arch/mips/boot/dts/brcm/*.dtsi`
- [Phase 6] `make kernelversion` / Makefile: **6.12.111**; `git describe
  HEAD`: p-6.12-3-gc504cf0baa3d8
- [Phase 6] Local file lines 413–424: table present, MODULE_DEVICE_TABLE
  absent
- [Phase 6] `git apply --check` of original hunk: **success (rc 0)**
- [Phase 6] Same-class already in tree: `330fdd1fb7d09`, `2260191fbf7c6`
- [Phase 7] MAINTAINERS: RTC subsystem maintained by Alexandre Belloni
- [Phase 8] Kconfig tristate + `default y` on ARCH_BRCMSTB/BMIPS_GENERIC
  verified via blame
- [Phase 8] Failure mode: missing modular bind, not a crash

**YES**

 drivers/rtc/rtc-brcmstb-waketimer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-brcmstb-waketimer.c b/drivers/rtc/rtc-brcmstb-waketimer.c
index fb47c32ab5ff4..55c15aad42cff 100644
--- a/drivers/rtc/rtc-brcmstb-waketimer.c
+++ b/drivers/rtc/rtc-brcmstb-waketimer.c
@@ -413,6 +413,7 @@ static const __maybe_unused struct of_device_id brcmstb_waketmr_of_match[] = {
 	{ .compatible = "brcm,brcmstb-waketimer" },
 	{ /* sentinel */ },
 };
+MODULE_DEVICE_TABLE(of, brcmstb_waketmr_of_match);
 
 static struct platform_driver brcmstb_waketmr_driver = {
 	.probe			= brcmstb_waketmr_probe,
-- 
2.53.0

