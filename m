Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E688E64990C;
	Mon, 19 Oct 2026 14:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418806; cv=none; b=F1XmMkpe6SFf5hTteE8iCdlsy4ZTyyEd6VFBKq6/AljARNIIgi4kdHuBZZDVhp8SZ4zM4Tix7O+GiIgXwZ5xUIMZzGXbK/NrFzOnU6cgbDqEHFuAqKGnpvM3+2Y+NaoNhPjaJ54U6XBOqY99jiRtFuDcMUF5iItWMMW1AvjoZ5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418806; c=relaxed/simple;
	bh=OxuENGihqPPyqE/n8s1mshvqs8J7RErz8kyHNSZSu50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oHHvEM4I0AMkpd5hTapM+l6hXcVxRZ5AqnVS/sM+lKKf/71cjwqdu2BUBkUNr0AFSCpWq/AihOaskSvhFlD3B8Hif8xpieKEgyBVxvRYfv3iuqRzTkwbBL9Lzz9mPYYOLVzueAlRr8SFekGN5uYhbjUK8q1LgEUMPcWa9nfOSjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BItVbjqZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BItVbjqZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734CB1F000C5;
	Mon, 19 Oct 2026 14:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418801;
	bh=dVT/lc0X87cPzZC0IZOAStJKDaNEt1e40Q93nkmWZJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BItVbjqZYHoLIf2RabOZ+tRjogM81Tsfoms7iCtbg9zuAvDlNG6QVzFodCXYqNMfO
	 uoi1GSgFmDTkEoXadjH7YlWZ1gFV8N/YyLFTpxzUt9KcBsv/mnTWX+ivQFfhv77lGf
	 fhhFvCM223bHUadRJr5NezEqPcZpTv6xVbRmEmHB1GTy/leBkwaSAfJBxgx7b+jmUk
	 po8NexWQQKb1XQXTHf1G1QJM0ZEC9+x95Mq41+F61tsu9KiIEbiVNo/4saIMrpca4X
	 ETxo1BJmMkZMqjEHC1L6PrzeB3twlBddlHxyWV8MTQMA90uaOfkj7fSUAJ4/OKX/qk
	 zNw736JastvbQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mithil Bavishi <bavishimithil@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Andreas Kemnade <andreas@kemnade.info>,
	"Kevin Hilman (TI)" <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>,
	aaro.koskinen@iki.fi,
	rogerq@kernel.org,
	tony@atomide.com,
	linux@armlinux.org.uk,
	linux-arm-kernel@lists.infradead.org,
	linux-omap@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ARM: OMAP2+: Add CFI type for omap4_finish_suspend
Date: Mon, 19 Oct 2026 09:53:17 -0400
Message-ID: <20261019135441.1420968-506-sashal@kernel.org>
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

From: Mithil Bavishi <bavishimithil@gmail.com>

[ Upstream commit 4a7b197ad28d71f9fac873f283b4408df3fdb287 ]

With CONFIG_CFI enabled, OMAP4 can trap in omap4_enter_lowpower()
because omap_pm_ops.finish_suspend points directly to the assembly
routine omap4_finish_suspend, which lacks the expected KCFI type
metadata.

Annotate omap4_finish_suspend with SYM_TYPED_FUNC_START so the assembly
routine carries the KCFI type metadata.

Signed-off-by: Mithil Bavishi <bavishimithil@gmail.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://patch.msgid.link/20260604054048.18980-1-bavishimithil@gmail.com
Signed-off-by: Kevin Hilman (TI) <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.18.53**. The patch is a three-line CFI annotation
for an OMAP4 assembly suspend finisher that is called through a C
function pointer, so a `CONFIG_CFI` kernel can oops on idle/suspend.
That is a real crash with a tiny, standard fix.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[ARM: OMAP2+]** **[Add]** Add KCFI type metadata for assembly
`omap4_finish_suspend`. The verb is “Add”, but the body is a CFI-trap
fix, not a feature.

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Reviewed-by: Nathan Chancellor (Clang/CFI)
- Reviewed-by: Andreas Kemnade (OMAP)
- Link: https://patch.msgid.link/20260604054048.18980-1-
  bavishimithil@gmail.com
- Signed-off-by: Mithil Bavishi (author)
- Signed-off-by: Kevin Hilman (TI) (OMAP maintainer; applied)
- No Fixes:, Reported-by, Tested-by, or Cc: stable (absence expected)
- Ignore pipeline “Upstream commit” / Sasha Levin SOB

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: with `CONFIG_CFI`, OMAP4 can trap in `omap4_enter_lowpower()`
  because `omap_pm_ops.finish_suspend` points at assembly
  `omap4_finish_suspend` with no KCFI type hash.
- Symptom: CFI failure / oops on low-power entry.
- Root cause: indirectly called asm lacks `__kcfi_typeid_*`.
- Fix: `SYM_TYPED_FUNC_START` / `SYM_FUNC_END`.
- No version range given; ARM CFI itself is from 6.11.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not disguised. It is an explicit CFI-trap fix, same class as
other `SYM_TYPED_FUNC_START` annotations.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `arch/arm/mach-omap2/sleep44xx.S` (+3 / −2)
- Functions: `omap4_finish_suspend` only
- Scope: single-file surgical annotation

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Hunk 1: `#include <linux/cfi_types.h>` so `SYM_TYPED_FUNC_START` is
  defined.
- Hunk 2: `ENTRY(omap4_finish_suspend)` →
  `SYM_TYPED_FUNC_START(omap4_finish_suspend)`. Without `CONFIG_CFI`
  this is the same as `SYM_FUNC_START`/`ENTRY`. With CFI it emits
  `.4byte __kcfi_typeid_omap4_finish_suspend` before the symbol.
- Hunk 3: `ENDPROC` → `SYM_FUNC_END` (paired end; ARM `ENDPROC` vs
  generic `SYM_FUNC_END` is ELF metadata only).
- Path: function prologue of the suspend finisher; no control-flow
  change.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: **(h) hardware/CFI metadata + (g) correctness.** Indirect call
to asm without a type hash. Compiler CFI checks at
`omap_pm_ops.finish_suspend(...)` fail → trap. Fix attaches the
compiler-emitted type id to the asm entry.

Step 2.4: ASSESS THE FIX QUALITY
Record: Obviously correct and the established pattern
(`include/linux/cfi_types.h`). No locking, no API, no data-structure
change. Regression risk is very low: without CFI it is equivalent to
`ENTRY`/`SYM_FUNC_START`; with CFI it only adds the expected hash.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record: `ENTRY(omap4_finish_suspend)` body from Santosh Shilimkar,
`b2b9762f76981` (2010). Function-pointer assignment
`omap_pm_ops.finish_suspend = omap4_finish_suspend` from `9f192cf7dad8f`
(2013). The crash only appears after ARM CFI (`1a4fec49efe52`, “ARM:
9392/2: Support CLANG CFI”, 2024-04-29, in v6.11+).

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Buggy combination is long-lived asm + CFI on ARM
since 6.11.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: File is quiet. Last functional change before this was
`2402ff05c6e6b` (use `v7_invalidate_l1`). Standalone, not “patch X/Y”.
Maintainer applied it as `[1/1]`.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Mithil Bavishi’s nearby work here is OMAP DT (Galaxy Tab 2), not
a CFI series. Reviewers are the domain experts.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: Needs `SYM_TYPED_FUNC_START` (`e84e008e7b02`, 2022) and ARM
`ARCH_SUPPORTS_CFI` (`1a4fec49efe52`). Both are ancestors of this
6.18.53 tree. Applies standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c 4a7b197ad28d71f9fac873f283b4408df3fdb287` → v3 https://patc
  h.msgid.link/20260604054048.18980-1-bavishimithil@gmail.com
- `b4 dig -a`: v2 2026-05-22, v3 2026-06-03 (applied)
- v1 (May 12): “Make OMAP4 finish_suspend callback CFI-safe”. Nathan
  asked for `SYM_TYPED_FUNC_START` and whether other `omap_pm_ops`
  members need it. Andreas: `omap4_cpu_resume` / secondary startup are
  stored as `u32` phys addrs (no CFI); `scu_prepare` is C. Only
  `finish_suspend` needs the annotation.
- Kevin Hilman applied v3 (`d58849ac3044` in his tree). No NAK found.
- lore.kernel.org fetches returned 403; discussion recovered from b4,
  spinics, LKML mirrors, openwall.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: `b4 dig -w` CCs: OMAP maintainers (Kemnade, Hilman, Lindgren,
Quadros, Koskinen), RMK, Sami Tolvanen, Kees Cook, Nathan Chancellor,
linux-omap, linux-arm-kernel, llvm@. Right people.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla. Mechanism is described in the patch;
reviewers treated it as a real CFI trap, not speculative.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone. v1→v3 is the same fix rewritten to
`SYM_TYPED_FUNC_START`.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable returned 403. UNVERIFIED whether stable@
already discussed it. No local `git log` hit for a prior OMAP4 CFI
annotation.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `omap4_finish_suspend` (asm). Callers use
`omap_pm_ops.finish_suspend`.

Step 5.2: TRACE CALLERS
Record (verified in this tree):
- `omap-mpuss-lowpower.c:440` assigns the pointer on OMAP44xx.
- `omap4_enter_lowpower()`: `cpu_suspend(...,
  omap_pm_ops.finish_suspend)` or
  `omap_pm_ops.finish_suspend(save_state)` (C indirect call — CFI-
  checked).
- `omap4_hotplug_cpu()`: always `omap_pm_ops.finish_suspend(cpu_state)`.
- `pm44xx.c:79` → suspend.
- `cpuidle44xx.c:108,187` → idle.

Step 5.3: TRACE CALLEES
Record: cache flush, SCU power mode, WFI. Unchanged.

Step 5.4: FOLLOW THE CALL CHAIN
Record: cpuidle / suspend / hotplug → `omap4_enter_lowpower` /
`omap4_hotplug_cpu` → indirect call. Userspace-reachable via idle and
suspend. On CFI failure ARM `hw_breakpoint_cfi_handler` does `die("Oops
- CFI", ...)` unless `CFI_PERMISSIVE`.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: `omap4_cpu_resume` still uses `ENTRY` — intentional (ROM jump
via phys addr). Rest of mach-omap2 asm is not stored in that C function-
pointer slot. Widespread `SYM_TYPED_FUNC_START` in
`arch/arm/mm/proc-*.S`.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. `git describe HEAD` = **v6.18.53-5049-g0f0bdc2b0dffb**,
`make kernelversion` = **6.18.53**. `v6.18.53` has
`ENTRY(omap4_finish_suspend)` and `ARCH_SUPPORTS_CFI`. `git diff
v6.18.53 -- arch/arm/mach-omap2/sleep44xx.S` is exactly this patch.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Clean apply. File otherwise unchanged vs v6.18.53.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No other omap4_finish_suspend CFI fix. This tree already has
other ARM CFI work (`ARM: 9481/2: breakpoint: CFI breakpoints only on
demand`), so CFI-on-ARM is in-scope for 6.18.y.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: `arch/arm/mach-omap2` platform PM. **PERIPHERAL** hardware, but
the path is idle/suspend (high frequency if that SoC + CFI is used).

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Mature; sleep44xx.S rarely changes. Bug is CFI enablement
meeting old code, not new churn.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver/platform + config: `CONFIG_ARCH_OMAP4` and `CONFIG_CFI`.
Not universal.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: CPU idle, suspend, hotplug on OMAP4 with CFI. Not an
unprivileged exploit; it is a false CFI hit on a legitimate call. With
default CFI (non-permissive) it oopses.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: CFI mismatch → `report_cfi_failure()` → `BUG_TRAP_TYPE_BUG` →
`die("Oops - CFI")`. **HIGH** (oops/panic on idle/suspend). Permissive
CFI is warn-only.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: medium-high for OMAP4+CFI (otherwise idle/suspend is broken);
  none otherwise, and the macros are inert without CFI.
- Risk: very low (3 lines, no behavior change off CFI).
- Ratio: favorable.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real CFI trap → oops on a live idle/suspend/hotplug path
- ARM CFI exists in this 6.18.y tree
- Tiny, standard, reviewed by CFI and OMAP maintainers
- Applies cleanly; helpers already present
- Harmless when CFI is off

AGAINST:
- Only `ARCH_OMAP4` + `CONFIG_CFI` (small population)
- No public crash log / syzbot
- OMAP4 is old

UNRESOLVED:
- lore.kernel.org 403; no stable@ thread recovered
- No independent Tested-by on hardware in the tags

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — standard annotation;
   Reviewed-by Nathan Chancellor and Andreas Kemnade
2. Fixes a real bug that affects users? **PASS** — CFI false positive on
   indirect call
3. Important issue? **PASS** — oops/panic on idle/suspend when CFI is on
   (HIGH, config-specific)
4. Small and contained? **PASS** — 5 lines, one file
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — identical context on v6.18.53

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Not a device-ID/quirk/DT/docs patch. Closest analogue:
supported-config correctness (CFI annotation), like a build/runtime fix
for `CONFIG_CFI`.

Step 9.4: MAKE YOUR DECISION
The population is small, but the failure is a kernel oops on a common PM
path, the patch is three lines and matches existing ARM CFI helpers in
this tree, and it does nothing when CFI is off. That meets 6.18.y stable
rules.

What it solves for this tree: 6.18 already selects `ARCH_SUPPORTS_CFI`.
OMAP4 still assigns the asm finisher to a C function pointer and calls
it from cpuidle/suspend. Without the type hash, a CFI kernel can
`die("Oops - CFI")` in `omap4_enter_lowpower()`. Benefit vs risk is
strongly in favor of backporting.

Verification:
- [Phase 1] Subject/tags: CFI-trap fix; Reviewed-by Nathan Chancellor,
  Andreas Kemnade; SOB Kevin Hilman; no Fixes/syzbot
- [Phase 2] Diff: sleep44xx.S +3/−2; include cfi_types.h;
  ENTRY→SYM_TYPED_FUNC_START; ENDPROC→SYM_FUNC_END
- [Phase 2] Without CONFIG_CFI, SYM_TYPED_FUNC_START == SYM_FUNC_START
  == ENTRY (include/linux/cfi_types.h, linkage.h)
- [Phase 3] blame: asm from b2b9762f76981 (2010); pointer assign
  9f192cf7dad8f (2013)
- [Phase 3] ARM CFI: 1a4fec49efe52 in v6.11 and in this tree (`git
  merge-base --is-ancestor`)
- [Phase 3] cfi_types.h: e84e008e7b02 in this tree; SYM_TYPED_FUNC_START
  present at v6.18.53
- [Phase 3] Standalone; parent of upstream 4a7b197ad28d7 is 7.2-rc1 (not
  in 6.18 mainline, hence backport)
- [Phase 4] b4 dig: v2+v3 lore URLs; v3 applied by Hilman; v1 review:
  only finish_suspend needs typing
- [Phase 4] Recipients: OMAP + LLVM/CFI maintainers
- [Phase 4] UNVERIFIED: stable@ discussion (lore 403)
- [Phase 5] Callers: omap4_enter_lowpower, omap4_hotplug_cpu;
  cpuidle44xx.c, pm44xx.c
- [Phase 5] ARM CFI handler: hw_breakpoint.c die("Oops - CFI") on
  BUG_TRAP_TYPE_BUG
- [Phase 5] kernel/cfi.c: default non-permissive → BUG
- [Phase 6] git describe HEAD: v6.18.53-5049-g0f0bdc2b0dffb;
  kernelversion 6.18.53
- [Phase 6] git diff v6.18.53 -- sleep44xx.S is this patch (clean apply)
- [Phase 8] Trigger: idle/suspend/hotplug; severity HIGH oops; risk very
  low
- UNVERIFIED: hardware Tested-by; lore.kernel.org full thread text (403)

**YES**

 arch/arm/mach-omap2/sleep44xx.S | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/sleep44xx.S b/arch/arm/mach-omap2/sleep44xx.S
index f09c9197808b1..8b515f30072b0 100644
--- a/arch/arm/mach-omap2/sleep44xx.S
+++ b/arch/arm/mach-omap2/sleep44xx.S
@@ -6,6 +6,7 @@
  * 	Santosh Shilimkar <santosh.shilimkar@ti.com>
  */
 
+#include <linux/cfi_types.h>
 #include <linux/linkage.h>
 #include <asm/assembler.h>
 #include <asm/smp_scu.h>
@@ -58,7 +59,7 @@
  * stack frame and it expects the caller to take care of it. Hence the entire
  * stack frame is saved to avoid possible stack corruption.
  */
-ENTRY(omap4_finish_suspend)
+SYM_TYPED_FUNC_START(omap4_finish_suspend)
 	stmfd	sp!, {r4-r12, lr}
 	cmp	r0, #0x0
 	beq	do_WFI				@ No lowpower state, jump to WFI
@@ -223,7 +224,7 @@ skip_scu_gp_clear:
 	isb
 	dsb
 	ldmfd	sp!, {r4-r12, pc}
-ENDPROC(omap4_finish_suspend)
+SYM_FUNC_END(omap4_finish_suspend)
 
 /*
  * ============================
-- 
2.53.0

