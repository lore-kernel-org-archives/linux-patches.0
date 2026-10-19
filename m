Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E23C6178A6;
	Mon, 19 Oct 2026 14:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418666; cv=none; b=H8ExvNKMXm0Jg/03RBYYNg76dtE/Y+B4ZE9xs5Cr34dSxtMSKWCiFp9B32I/JRaX/uFBydxcLDAMudiw0NvuOrMizuBv9S6eQVQBXWZO8lA1rl8KUpM34VfrL27finup5p+LyMbVyvbLu09yE41CSJ1gySRDMLSaMOecOmpCKK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418666; c=relaxed/simple;
	bh=pR1vVLUKyUTT783C6FTmq/aWcHOscIJME0KDutelq8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qUy1cACLF38l82BuGNlDB9rK2QIW9ZDOzplAzYiL5e7Jg/v29nKzzvaFRpF1vcYOHMtgBN8lR4dfNIDLJ2v6ixwqC7ajsEIb31N0+AOw93wjTvnR8uHwb4ZJaW77XL8n72NYIcXDWFDi7mkdqmhdukX4RKXgpBvAlD3foev++74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fOuufbP3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fOuufbP3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755491F000C4;
	Mon, 19 Oct 2026 14:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418664;
	bh=gyiydqPIB402NHvOlfWp8G1/q2d5b9orTcF5s5wfi3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fOuufbP3Nf1awuWPKTfmjJKfVuk6DZZEeVgJ8mO++uD2M/5qF/T9xl1alJKTz6mps
	 jo+rNhpE5JIZaFdM2onr8IeHNd7re7RuwMHBU+CI0KAloUWZsERnSI467sOs0QyAtx
	 Uk4lxcFU6Cm5DRRq37bvfuPj17J6HDE1BQaDWaE14/jHPoDi3mfOEz3pXhQ2EzLlBf
	 8u3FcJuiO46FtpnurDWOK5n5kwNBFe2gGXvOFnCJ893EiuBvPS84HRZQpVFNPphth0
	 gjBmtoJoIfrHwYWIr1qeE3JxLVuY1MEddK5k/4UsKmEFTl1nPVmxKzIjnJODja3hhD
	 XTXel5xgZLsRA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	y.oudjana@protonmail.com,
	sboyd@kernel.org,
	bmasney+clk@redhat.com,
	jbrunet+clk@baylibre.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-clk@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.18] clk: mediatek: mt6735-vdecsys: add missing MODULE_DEVICE_TABLE()
Date: Mon, 19 Oct 2026 09:51:40 -0400
Message-ID: <20261019135441.1420968-409-sashal@kernel.org>
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

[ Upstream commit 096ab64a0e69460bfb3557d09e17d2933280a1c6 ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`). The
vdecsys driver is present here; the change is a one-line
`MODULE_DEVICE_TABLE(of, ...)` so OF module aliases are generated.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: [clk: mediatek] [add] [missing MODULE_DEVICE_TABLE() for
mt6735-vdecsys]

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- Signed-off-by: Pengpeng Hou \<pengpeng@iscas.ac.cn\> (author)
- Reviewed-by: Brian Masney \<bmasney@redhat.com\> (clk co-maintainer;
  also committed the patch)
- Signed-off-by: Brian Masney \<bmasney@redhat.com\>
- No Fixes:, Reported-by:, Tested-by:, Link:, or Cc: stable
- Ignore any pipeline-added Sasha Levin SOB (none on this commit)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: OF match table is wired to `.of_match_table` but not exported
  with `MODULE_DEVICE_TABLE()`, so modpost does not emit `of:` aliases.
- Symptom: when `CONFIG_COMMON_CLK_MT6735_VDECSYS=m`, udev/kmod cannot
  autoload `clk-mt6735-vdecsys.ko` from the DT compatible string;
  vdecsys clocks/resets never register unless the module is loaded by
  hand.
- Version info: none in the message. Driver introduced in
  `0bd9b1211f741` (contained in v6.13-rc1); this fix is contained in
  v7.3-rc1.
- Root cause: omission at driver introduction, not a later regression.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. It is an explicit autoload/alias publication fix.
Author calls it a “source-level fix” with no hardware reproduction; that
is accurate (the missing macro is visible in the file) and does not make
the bug theoretical.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/clk/mediatek/clk-mt6735-vdecsys.c` (+1 / -0)
- Function/data: file-scope after `of_match_mt6735_vdecsys[]`
- Scope: single-file, one-line surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record: Before: match table exists and is used for in-kernel platform
matching, but no module alias is published. After:
`MODULE_DEVICE_TABLE(of, of_match_mt6735_vdecsys)` aliases the table for
`file2alias`/modpost. Affects the modular autoload path only;
probe/remove logic is unchanged.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: [Hardware enablement / module autoload] `MODULE_DEVICE_TABLE` is
the OF analog of exporting PCI/USB IDs. Without it, `modules.alias`
lacks `of:N*T*Cmediatek,mt6735-vdecsys`. Platform matching still works
if the module is already loaded or built-in.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct; matches the established MediaTek clk pattern
(`65c9ad77cbc0e` “Add MODULE_DEVICE_TABLE() where appropriate”).
Compile-time alias generation only; no locking, no API, no runtime path
change. Regression risk is negligible. Sibling `clk-mt6735-imgsys.c` /
`clk-mt6735-mfgcfg.c` still lack the macro in this tree; that does not
make this hunk wrong.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: Match table from `0bd9b1211f741` (Yassine Oudjana, 2024-11-06;
contained in v6.13-rc1). `MODULE_DEVICE_TABLE` line is this commit
`096ab64a0e694`. Bug present from first introduction of the driver.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No Fixes: tag on this commit. A later unrelated series (`[PATCH
07/32] clk: mediatek: mt6735: Add missing MODULE_DEVICE_TABLE()`) cited
`Fixes: 0bd9b1211f74` for the same omission across four files. Intro
commit is an ancestor of HEAD.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Only two commits on this file: intro + this fix. Sibling same-
day commit `36cf8d279ff90` does the same for vencsys. Standalone for
vdecsys; no prerequisite refactor.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Pengpeng Hou is not the MT6735 clk maintainer (that is Yassine
Oudjana). Same-day vencsys twin plus several other `MODULE_DEVICE_TABLE`
additions (rtc, vdpa, watchdog). Brian Masney, clk co-maintainer,
reviewed and applied it.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None. Macro has long existed in `include/linux/module.h`.
Applies standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- Lore/msgid:
  https://patch.msgid.link/20260704124450.11035-1-pengpeng@iscas.ac.cn
- `b4 dig -a`: v1 only, applied as submitted
- Thread (mbox): author post + Brian Masney `Reviewed-by:` on
  2026-07-06. No NAK, no stable nomination, no requested revisions.
- WebFetch of lore/spinics: 403/500; thread recovered via `b4 dig -m`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): linux-clk, linux-mediatek, Stephen Boyd, Brian
Masney, AngeloGioacchino Del Regno, Matthias Brugger, Yassine Oudjana.
Review came from clk co-maintainer Brian Masney.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No Reported-by, no bugzilla/syzbot. Author states source-level
evidence only. No in-tree DTS uses `mediatek,mt6735-vdecsys` (binding
only in `Documentation/devicetree/bindings/clock/mediatek,syscon.yaml`).

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Twin vencsys patch applied in the same pile. Later 07/32 series
(Akari Tsuyukusa, Aug 2026) would have covered
imgsys+mfgcfg+vdecsys+vencsys together; vdecsys/vencsys were already
fixed here. This commit does not depend on that series.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: No dedicated stable thread found for this subject. UNVERIFIED
whether an AUTOSEL pick already exists; that must not drive the verdict.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: No function body changed. Added `MODULE_DEVICE_TABLE` next to
`of_match_mt6735_vdecsys`. Driver uses `mtk_clk_simple_probe` /
`mtk_clk_simple_remove` via `module_platform_driver`.

**Step 5.2: TRACE CALLERS**
Record: Probe is invoked by the platform core when a device matches
`mediatek,mt6735-vdecsys`. Autoload (udev/kmod) is the path that was
broken for `=m`. Built-in (`=y`) matching already worked via
`.of_match_table`.

**Step 5.3: TRACE CALLEES**
Record: `mtk_clk_simple_probe()` (`drivers/clk/mediatek/clk-mtk.c`)
registers the vdecsys gates and resets from `vdecsys_clks`. Unchanged by
this patch.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: DT node `compatible = "mediatek,mt6735-vdecsys"` → (modular)
udev alias lookup → `clk-mt6735-vdecsys.ko` → platform probe → video-
decoder clocks. Reachable on MT6735 boards that describe that syscon; no
in-tree board DTS. Unprivileged userspace cannot trigger it except by
loading the module.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Most MediaTek clk drivers already have `MODULE_DEVICE_TABLE`.
MT6735 core clocks (apmixedsys/infracfg/pericfg/topckgen) have it;
imgsys and mfgcfg in this tree still do not. Same class of omission as
the 2023 sweep `65c9ad77cbc0e`.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. File exists; driver from `0bd9b1211f741` (v6.13-rc1).
Kconfig `COMMON_CLK_MT6735_VDECSYS` is **tristate**, Makefile maps it to
`clk-mt6735-vdecsys.o`. HEAD already contains `096ab64a0e694`
(v7.3-rc1); the pre-fix omission is the code this candidate addresses.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply. One added line at a stable match-table site; no
refactor around it.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This exact line is present (commit `096ab64a0e694`). No
alternate fix. imgsys/mfgcfg still missing aliases — separate omissions.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: [drivers/clk/mediatek] [PERIPHERAL] — SoC-specific video-decoder
clock/reset driver for MT6735 (Helio T1 era). Not core mm/net/fs.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: MediaTek clk is actively developed; this file itself is quiet
(two commits). MT6735 clk is listed Maintained (Yassine Oudjana).

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Users of MT6735 with `CONFIG_COMMON_CLK_MT6735_VDECSYS=m`. No
in-tree defconfig enables `COMMON_CLK_MT6735`; no in-tree DTS
instantiates the node. Built-in builds are unaffected.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Boot/enumeration with the DT node while the driver is a module.
Not a race. Not unprivileged-exploitable. Workaround: `modprobe clk-
mt6735-vdecsys` or build `=y`.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Video-decoder clocks/resets never appear unless the module is
loaded manually → decode/VPU consumers fail clock lookup. Not
panic/UAF/corruption. Severity: MEDIUM for modular MT6735 vdec; LOW
overall population. Failure is “device feature does not come up,” same
class as missing device IDs.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record: Benefit: modular autoload for this clock controller. Risk: very
low (one compile-time alias line). Ratio: favorable because risk is
essentially zero.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real autoload bug on a tristate, `module_platform_driver` clock driver
- One-line, obviously correct, clk co-maintainer Reviewed-by + applied
- Same class as device-ID / quirk enablement (OF alias publication)
- Established MediaTek clk precedent (`65c9ad77cbc0e`: “allow auto-load
  at boot”)
- Zero runtime/API/locking risk; applies cleanly
- Buggy driver exists in this 7.3 tree (since v6.13)

AGAINST:
- Not crash/security/corruption/deadlock
- No user report or hardware test
- Niche SoC; no in-tree DTS/defconfig
- Built-in configs already work
- Author framed it as source-level only

UNRESOLVED:
- Whether AUTOSEL/stable already discussed this hash (lore.kernel.org
  stable search not useful)
- Direct fetch of lore HTML (403)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — one-line alias export;
   reviewed by clk co-maintainer. No HW test, but correctness does not
   depend on runtime.
2. Fixes a real bug that affects users? **PASS** — modular OF autoload
   is broken by construction when the table is not exported.
3. Important issue? **PASS** (MEDIUM) — hardware clocks do not come up
   on the intended modular path; same practical class as missing device
   IDs, not a panic.
4. Small and contained? **PASS** — +1 line, one file.
5. No new features or APIs? **PASS** — publishes an existing match
   table.
6. Can apply to the local tree? **PASS** — file and match table exist;
   hunk is identical.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Device-ID / module-alias publication for an existing driver (OF
`MODULE_DEVICE_TABLE`). That exception applies.

**Step 9.4: MAKE YOUR DECISION**
The bug is real for `=m` builds, the fix is trivial and already the
subsystem’s standard pattern, and this tree has the driver. Conservative
stable practice still takes this class because the downside is nil and
the upside is the driver actually binding.

===============================================================
What the commit solves, and why it matters here
===============================================================

Without `MODULE_DEVICE_TABLE(of, of_match_mt6735_vdecsys)`, modpost
never emits the `of:N*T*Cmediatek,mt6735-vdecsys` alias. On this tree
the Kconfig is tristate, so a modular vdecsys driver will not autoload;
video-decoder clocks and resets never register until someone loads the
module by name. Built-in matching via `.of_match_table` was already
fine.

It meets stable rules: obviously correct, one line, no new API, no
dependencies, and it is the OF equivalent of adding a device ID to an
existing driver. Risk is compile-time alias generation only.

Concerns: no in-tree board uses this compatible, no reporter, not a
crash. Those lower breadth of impact; they do not make the hunk unsafe
or non-bugfix.

Verification:
- [Phase 1] Parsed commit `096ab64a0e694`: SOB Pengpeng Hou; Reviewed-
  by/SOB Brian Masney; no Fixes/Reported-by/Cc: stable
- [Phase 2] Diff: +1 `MODULE_DEVICE_TABLE(of, of_match_mt6735_vdecsys)`
  in `clk-mt6735-vdecsys.c`
- [Phase 3] `git blame`: match table from `0bd9b1211f741`; `git describe
  --contains` intro v6.13-rc1, fix v7.3-rc1
- [Phase 3] `git merge-base --is-ancestor 0bd9b1211f741 HEAD` and
  `096ab64a0e694 HEAD`: both true
- [Phase 3] `git log --oneline -- drivers/clk/mediatek/clk-
  mt6735-vdecsys.c`: only intro + this fix
- [Phase 3] Sibling `36cf8d279ff90` vencsys same change; earlier sweep
  `65c9ad77cbc0e`
- [Phase 4] `b4 dig -c 096ab64a0e694`: msgid
  `20260704124450.11035-1-pengpeng@iscas.ac.cn`; v1 only
- [Phase 4] `b4 dig -m`: Brian Masney Reviewed-by; no NAK/stable
  discussion
- [Phase 4] WebFetch lore/spinics: 403/500; used mbox instead
- [Phase 5] Kconfig `COMMON_CLK_MT6735_VDECSYS` tristate; Makefile
  builds `clk-mt6735-vdecsys.o`; probe is `mtk_clk_simple_probe`
- [Phase 5] `MODULE_DEVICE_TABLE` in `include/linux/module.h` creates
  file2alias symbol
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` = 7.3.0-rc4
- [Phase 6] No in-tree dts/dtsi for mt6735-vdecsys; binding listed in
  `mediatek,syscon.yaml`
- [Phase 6] No defconfig sets `COMMON_CLK_MT6735`
- [Phase 6] imgsys/mfgcfg still lack MODULE_DEVICE_TABLE (verified by
  grep)
- [Phase 7] MAINTAINERS: COMMON CLK FRAMEWORK includes Brian Masney;
  MT6735 CLOCK maintained by Yassine Oudjana
- [Phase 8] Failure mode: modular autoload miss → vdec clocks absent;
  severity MEDIUM/narrow
- UNVERIFIED: whether stable@ already queued this hash; lore stable
  search did not return this commit

**YES**

 drivers/clk/mediatek/clk-mt6735-vdecsys.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/mediatek/clk-mt6735-vdecsys.c b/drivers/clk/mediatek/clk-mt6735-vdecsys.c
index 8817085fc1db4..d53ebf92e878d 100644
--- a/drivers/clk/mediatek/clk-mt6735-vdecsys.c
+++ b/drivers/clk/mediatek/clk-mt6735-vdecsys.c
@@ -63,6 +63,7 @@ static const struct of_device_id of_match_mt6735_vdecsys[] = {
 	{ .compatible = "mediatek,mt6735-vdecsys", .data = &vdecsys_clks },
 	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(of, of_match_mt6735_vdecsys);
 
 static struct platform_driver clk_mt6735_vdecsys = {
 	.probe = mtk_clk_simple_probe,
-- 
2.53.0

