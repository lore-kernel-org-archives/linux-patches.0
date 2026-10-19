Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B0E4C4631;
	Mon, 19 Oct 2026 14:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418473; cv=none; b=MQsqmfxxTH7SO+szx/efPlA3w821Ta7+ET/m9C4oBrttZNowjE36Xi8r2K44l+K7/s5VpR9XGKhc5OdgL5w1b6J7V5KCJ0dLNVvLRRL8bCtGC7mLPcNo43HGrphMAL4wJ7c4b9CROfPtMti/aWPlj52HoCfTT7OdYIaS2QpvVd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418473; c=relaxed/simple;
	bh=6XU0lqPH3jdeGC/bl04dSr3cVY9MEoDMm4TloCtq3yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p/yKkZzkPrq8S27kxYyz/bHCz41iz19/X17tI/syZ3fFeR+KCrqVZ/O5D1q4VFHyB49zQp3HKY3DQb6zMfhAXQXLHsKNEqO+UgHdDBKej99nVBe7j/HcKeYn5eJsW/n19erFC+4pRn3tyjhdqOyy3y7nrWHrrHJ3twKHrvMMskY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Id0Q25yC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Id0Q25yC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7D21F000C6;
	Mon, 19 Oct 2026 14:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418470;
	bh=QJpIoSxqa3XEZcAypJMC+joetbdaLKnznHB4VQAZ2Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Id0Q25yCsEOee2MwdftUJlBZFSh3DpnWOQr9J6Fss2MpcUgqI++SOSPd6SvNdAvEu
	 gSaN7e8ZZRobZIArmUBl8zcIBuLuKS4isyNh/nsuOnlGT1C5sTHPN0vI6vX17QdjRh
	 oWj6WjsspM6zUaz0x40pYNeZTaYpefL6l+bxQgvjvuoHPvQt9+tvVp+S649oZze2w9
	 wDKTMXstMZi7Z7mriHcbgLx8SWUkpAjUTDf1uuMe+xo/pfgZzmypjUwvsFBpBacGJh
	 YWkdPp9q5/NXMhU447McLuzXonY0tpiM+orAk17iQxnKi8Eq9zXtF0Goe1YClpONxv
	 fukkpYrKutX6A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	hverkuil@kernel.org,
	mchehab@kernel.org,
	thierry.reding@kernel.org,
	jonathanh@nvidia.com,
	linux-tegra@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] media: cec: tegra: add missing MODULE_DEVICE_TABLE()
Date: Mon, 19 Oct 2026 09:49:22 -0400
Message-ID: <20261019135441.1420968-271-sashal@kernel.org>
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

[ Upstream commit 8dcf23edaf4bdf22259f6a47cfddc8bb1467425c ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a one-line OF module-alias fix on a driver that has been in the
tree since v4.15. Local checkout is **v7.3-rc4** (`7.3.0-rc4`,
`f0100363d8c37`), not a numbered stable branch. The candidate is
`8dcf23edaf4bd`.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: `[media/cec/tegra] [add] missing MODULE_DEVICE_TABLE() so OF
module aliases are generated`

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn> (author)
- Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org> (CEC/Tegra CEC
  maintainer; applied the patch)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, Link:,
  or Cc: stable
- Absence of Fixes:/Cc: stable is expected for this review pipeline and
  is not a negative signal

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: OF match table is wired to `.of_match_table` but not exported via
  `MODULE_DEVICE_TABLE(of, ...)`.
- Symptom: when `CONFIG_CEC_TEGRA=m`, depmod/modinfo get no `of:`
  aliases, so udev will not autoload `tegra_cec.ko` for
  `nvidia,tegra114-cec` / `tegra124-cec` / `tegra210-cec`.
- Version info: none in the message. Git shows the match table dates to
  the original driver (v4.15-rc1).
- Root cause: missing module-alias publication, not a probe/runtime
  logic error.
- Author states this is a source-level finding, not a live hardware
  repro.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a disguised cleanup. It is an explicit autoload/hardware-
enablement fix. The “source-level” wording is candor, not a claim that
nothing is wrong.

===============================================================
PHASE 2: DIFF ANALYSIS
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `drivers/media/cec/platform/tegra/tegra_cec.c` (+1 / -0)
- Functions: none. Adds `MODULE_DEVICE_TABLE(of, tegra_cec_of_match)`
  after the existing `tegra_cec_of_match[]` table.
- Scope: single-file, one-line surgical change.

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: table exists and is assigned to
  `platform_driver.driver.of_match_table`, so a **already loaded** or
  **built-in** driver still matches DT nodes.
- After: `scripts/mod/file2alias.c` also emits `of:` modaliases into the
  `.ko`, so userspace can autoload the module from sysfs modalias.
- Path affected: module build / autoload, not probe/remove/IRQ/CEC
  transfer.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- Category: hardware enablement / missing device-table export (same
  family as adding IDs).
- Mechanism: `MODULE_DEVICE_TABLE()` creates the
  `__mod_device_table__kmod_*` alias that `file2alias.c` consumes.
  Without it, the kernel can bind the driver once loaded, but the module
  will not be loaded automatically.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: sibling CEC platform drivers (`stm32-cec`,
  `meson/ao-cec`, `s5p_cec`, `stih-cec`, `cec-gpio`) already use the
  same pattern.
- Minimal: one line, no API/struct/locking change.
- Regression risk: very low. Builtin builds are unaffected at runtime;
  modular builds only gain aliases.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Match table introduced in `9d2d60687c9a06` ("media: tegra-cec: add
  Tegra HDMI CEC driver", Hans Verkuil, 2017-07-15; first contained in
  **v4.15-rc1**).
- Original file had the OF table and `.of_match_table =
  of_match_ptr(...)` and **no** `MODULE_DEVICE_TABLE`.
- Bug has been present for the entire life of the driver.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Not applicable. Introduction commit is
`9d2d60687c9a06`, present in this tree (`git merge-base --is-ancestor`
of the candidate vs HEAD succeeds).

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record (recent on this file):
- `7bc1f3c8bd673` (2023): drop `of_match_ptr` so the table is always
  used (build fix for !OF).
- `8dcf23edaf4bd` (this commit)
- Later functional CEC fixes (`be627f257ce28`, `bce7236c16c2c`) do not
  depend on this line.
- Standalone; not patch X/Y.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record:
- Pengpeng Hou submitted a large set of “add missing
  MODULE_DEVICE_TABLE()” patches (rtc, vdpa, watchdog, fbdev, soc, can,
  clk, power, this CEC driver). Same recipe, LLM-style commit text.
- Hans Verkuil is listed maintainer of `ARM/TEGRA HDMI CEC` and applied
  this patch. That is a strong quality signal for the **change**, even
  if the author is doing a sweep.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: None. The macro has existed for decades
(`include/linux/module.h`). The table and `.of_match_table` assignment
are original. Applies standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c 8dcf23edaf4bd` →
  https://patch.msgid.link/20260704122631.99057-1-pengpeng@iscas.ac.cn
- Single revision (v1 only). `b4 dig -a` also matched an unrelated 2024
  Liao Chen v4l2-subdev series by patch-id search noise; this commit is
  a standalone v1.
- Direct lore HTTP fetch returned 403; full thread was saved via `b4 dig
  -m` to `/tmp/tegra_cec_moddev.mbox`.
- NVIDIA Tegra developer Mikko Perttunen replied 2026-07-15: objected to
  the “source-level fix / no dynamic hardware reproduction” paragraph as
  AI boilerplate, and said **“Otherwise looks fine to me.”** No NAK. No
  request for v2. Hans applied v1 as-is (that paragraph remained).
- No reviewer asked for Cc: stable.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): To/Cc included Hans Verkuil, Mauro Chehab, Thierry
Reding, Jonathan Hunter, linux-tegra, linux-media, linux-kernel. Right
lists and maintainers. Informal ack from Mikko Perttunen (NVIDIA);
applied by Hans Verkuil.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No Reported-by, bugzilla, or syzbot. Evidence is the missing
export next to a live OF table. No user report of failed autoload was
found.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Same-day author sweep of missing `MODULE_DEVICE_TABLE` across
subsystems. Not a dependent series; each driver patch is self-contained.
Sibling CEC OF drivers already had the macro.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: No lore.kernel.org/stable thread for this exact Tegra CEC patch
(search did not return a relevant hit). Same-class patches **have** gone
into stable before, including:
- `PCI: tegra: Add missing MODULE_DEVICE_TABLE` on 4.19-stable
- `can: ctucanfd: add missing MODULE_DEVICE_TABLE()` from the same
  author, committed to linux-stable by Greg Kroah-Hartman
  (`d937bdb244a75` upstream)

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: No functions modified. Macro addition adjacent to
`tegra_cec_of_match[]`. Related structures: `tegra_cec_driver`
(`module_platform_driver`).

Step 5.2: TRACE CALLERS
Record: `tegra_cec_probe` is the platform probe (DT device
instantiation). `MODULE_DEVICE_TABLE` is not called at runtime;
`scripts/mod/file2alias.c` `do_table()` consumes the alias at module
build. Impact surface is autoload of `tegra_cec.ko` only.

Step 5.3: TRACE CALLEES
Record: N/A for the added line. The driver already includes
`<linux/module.h>` and `<linux/of.h>`.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Reachable for users with `CONFIG_CEC_TEGRA=m` on Tegra
114/124/210 HDMI CEC DT nodes (e.g. Jetson TK1 / older Tegra boards).
Unprivileged userspace cannot trigger a crash; the user-visible failure
is “CEC adapter never appears until `modprobe tegra_cec`”. Builtin
(`=y`) is already fine.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Other CEC platform drivers already export OF tables. This file
was the outlier. Same missing-macro pattern exists across many drivers
and is treated as a real autoload bug.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. File `drivers/media/cec/platform/tegra/tegra_cec.c` exists.
Pre-commit parent still has the OF table and `.of_match_table` without
the macro. Candidate **is already an ancestor of HEAD** (`git merge-base
--is-ancestor 8dcf23edaf4bd HEAD`). Bug introduced v4.15-rc1; present in
every long-lived stable series that has this driver.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Expected apply: **clean**. Context around the table (compatibles
tegra114/124/210) is original. Later commits only add the macro and then
unrelated CEC protocol fixes. Line numbers differ slightly on current
HEAD because of later edits, but the hunk is trivial.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: This is the fix; it is already in this 7.3-rc4 tree. No earlier
substitute autoload fix on this file. `7bc1f3c8bd673` only dropped
`of_match_ptr`; it did not add aliases.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: `drivers/media/cec/platform/tegra/` — HDMI CEC on NVIDIA Tegra.
Criticality: **PERIPHERAL** (SoC-specific media driver), but real
product hardware (Jetson TK1 and Tegra X1 designs were the original test
targets).

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Low churn. Driver added 2017; occasional correctness fixes.
Mature. The missing macro is long-standing, not a regression from recent
refactoring.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver-specific / config-specific: `CONFIG_CEC_TEGRA=m` on DT
platforms with `nvidia,tegra114-cec`, `nvidia,tegra124-cec`, or
`nvidia,tegra210-cec`. Not universal.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Every boot/hotplug of that DT node when the driver is a module
and nothing else loads it. Common on distros that package CEC as a
module; irrelevant if the vendor kernel builds it in. Not a race. Not
triggerable as a crash by unprivileged users.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: HDMI CEC device never binds until manual `modprobe`. No oops,
leak, or corruption. Severity: **MEDIUM** for those boards
(feature/hardware dead), **LOW** globally. This is the same user-visible
class as “device ID missing so the module never loads.”

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: restores intended autoload for modular Tegra CEC; matches
  every other CEC OF driver.
- Risk: one compile-time alias line; no runtime path change.
- Ratio: high benefit for affected users, negligible risk.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE

FOR backporting:
- Real bug: OF match table used by the platform driver is not published
  to module aliases.
- `CEC_TEGRA` is **tristate**; modular builds are first-class.
- One line, obviously correct, no new API.
- Same pattern as the documented **device-ID / hardware enablement**
  exception.
- Maintainer-applied (Hans Verkuil); NVIDIA engineer said the change
  looks fine.
- Sibling CEC drivers already have `MODULE_DEVICE_TABLE(of, ...)`.
- Bug present since v4.15; no prerequisites.
- Same class of patches has historically been accepted into stable
  (including this author’s `can: ctucanfd` MODULE_DEVICE_TABLE fix).

AGAINST:
- Not a crash, UAF, deadlock, or security hole.
- No end-user report; author did not claim hardware reproduction.
- Peripheral SoC driver; small user population.
- Author is doing a mass static-analysis sweep; commit text was called
  out as AI boilerplate.
- Builtin kernels are unaffected.

UNRESOLVED:
- Could not HTTP-fetch lore (403); discussion recovered from `b4 dig -m`
  instead.
- Could not find a stable-list thread for **this** SHA.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — one well-known macro;
   applied by the subsystem maintainer; NVIDIA developer agreed. Build-
   tested at least (author/reviewer).
2. Fixes a real bug that affects users? **PASS** — modular autoload for
   real Tegra CEC DT compatibles.
3. Important issue? **PASS** under the hardware-enablement exception
   (device does not come up). Not CRITICAL crash/corruption.
4. Small and contained? **PASS** — +1 line, one file.
5. No new features or APIs? **PASS** — publishes an existing table.
6. Can apply to the local tree? **PASS** — file and table exist; hunk is
   trivial. (This 7.3-rc4 tree already contains the commit.)

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: **Device ID / module alias publication for an existing driver.**
Closest listed exception is new device IDs; this is the matching half
(exporting the IDs the driver already matches). Also analogous to
quirks/DT enablement: it makes already-supported hardware actually
attach when built as a module.

Step 9.4: MAKE YOUR DECISION
The local tree is mainline **7.3.0-rc4**. The driver and buggy omission
exist here and in any stable series that still has `tegra_cec`. The
patch is a one-line, maintainer-acked autoload fix with no runtime risk.
That is stable material.

What problem it solves for stable users: with `CONFIG_CEC_TEGRA=m`, udev
never loads the module from the DT compatible, so HDMI CEC stays dead
until a manual modprobe. Distros that ship this as a module on
Jetson/Tegra boards hit that.

Risk vs benefit: benefit is hardware actually probing; risk is
essentially zero.

Verification:
- [Phase 1] Parsed tags: author + Hans Verkuil SOB only; no
  Fixes/Reported-by/Cc: stable
- [Phase 1] Body describes missing OF alias publication, not a crash
- [Phase 2] Diff: +1 line `MODULE_DEVICE_TABLE(of, tegra_cec_of_match)`
  in `tegra_cec.c`
- [Phase 2] Confirmed `.of_match_table = tegra_cec_of_match` already
  present
- [Phase 3] `git blame`: table from `9d2d60687c9a06` (v4.15-rc1); macro
  from `8dcf23edaf4bd`
- [Phase 3] Original driver dump: no MODULE_DEVICE_TABLE
- [Phase 3] Author sweep of similar one-liners; Hans is MAINTAINERS
  owner of ARM/TEGRA HDMI CEC
- [Phase 4] `b4 dig -c 8dcf23edaf4bd`:
  https://patch.msgid.link/20260704122631.99057-1-pengpeng@iscas.ac.cn
- [Phase 4] `b4 dig -a`: single v1; no later revision
- [Phase 4] `b4 dig -w`: linux-media, linux-tegra, Hans, Mauro, Thierry
  Reding, Jonathan Hunter
- [Phase 4] mbox: Mikko Perttunen “Otherwise looks fine to me”;
  complaint was about AI commit-message padding only
- [Phase 4] lore WebFetch 403; content taken from mbox
- [Phase 4] No stable@ thread for this SHA; same-class
  MODULE_DEVICE_TABLE patches have landed in stable
- [Phase 5] Kconfig `CEC_TEGRA` is tristate; Makefile
  `obj-$(CONFIG_CEC_TEGRA) += tegra_cec.o`
- [Phase 5] `MODULE_DEVICE_TABLE` in `include/linux/module.h` creates
  file2alias symbol; `scripts/mod/file2alias.c` `do_table()` consumes it
- [Phase 5] Other CEC OF drivers already have the macro
- [Phase 6] `git describe HEAD`: v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion`: 7.3.0-rc4
- [Phase 6] `git merge-base --is-ancestor 8dcf23edaf4bd HEAD`: yes
  (already in this tree)
- [Phase 6] Backport difficulty: clean one-liner
- [Phase 7] Peripheral media driver, maintainer-applied
- [Phase 8] Failure mode: module not autoloaded → CEC unused; severity
  MEDIUM for Tegra modular users, not a panic
- UNVERIFIED: live udev autoload on real Tegra hardware (author did not
  claim it)

**YES**

 drivers/media/cec/platform/tegra/tegra_cec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/cec/platform/tegra/tegra_cec.c b/drivers/media/cec/platform/tegra/tegra_cec.c
index 3ed50097262f6..fe66336e734f8 100644
--- a/drivers/media/cec/platform/tegra/tegra_cec.c
+++ b/drivers/media/cec/platform/tegra/tegra_cec.c
@@ -458,6 +458,7 @@ static const struct of_device_id tegra_cec_of_match[] = {
 	{ .compatible = "nvidia,tegra210-cec", },
 	{},
 };
+MODULE_DEVICE_TABLE(of, tegra_cec_of_match);
 
 static struct platform_driver tegra_cec_driver = {
 	.driver = {
-- 
2.53.0

