Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668564756A3;
	Mon, 31 Aug 2026 13:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183332; cv=none; b=EXrr8VGIgzQumJFuliSMp3QsBhQmvk0CacvDGKnPO8jxpxogFX+j/3diXHxwRdkCf6c6CTXoekG88pXgu5D3qGqdsUhcx5IJoH+kmi21q9YkECll2/EBQaOTljL2cIrrNcEOMtxG6oqo7IFj5YhjjmSpOiCVe0eBJQOm7/UqvFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183332; c=relaxed/simple;
	bh=4jWO0gVqanCuKitixeoY+1Y+zsxTA4akxbRjF4OdSNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dw0tMMoOLQOADQupHkCD9g4CUPU/5m/XY3TbOUof7beCB9qXq2+Xe09oixjg7YXDjx4W1QolabdmfmHNRE39wLUr4oLeRSC+BsC0tVA+cb7OPokUkQpoaHj/SJI5VZxKW/A4ED8JleW0ou3nFCDsuHOQ41k1oeKYJPyeRegixEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nDpcoIQw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nDpcoIQw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278C91F00A3D;
	Mon, 31 Aug 2026 13:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183329;
	bh=JgXObi8OpqL/D540kCQrZs5CkqGGBw3tGTT+Bw/lQEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nDpcoIQw4Fp33mpvzhQiS2qwFax/e1pqs5Nvj66xb9N5R8ytW+1Y3aQMTITNi96Cl
	 sDFnbRYgtNXWpw7rw3n8sen1NDVf3ZUjRFc96e0Z7Hk/UL6AXHebPRzVtWv7FcxSGn
	 fRWc6Gk7AJoMJSTxWiIdd8JhJjwNC0mRHBkgRlY+wQssYnnyuvL0dFTZFhEACGyptI
	 rMAq5q7s/ysgFsl2B+fi0otWb+0ZfcwLKF+HshdKMxzfoa+Vv3FihZ/ISt4ZGW4PQ2
	 4kHK3cMa8sdn6z+rDcHa2alstIiIyVM08lcHic/hpgb4mBWbm5hdQT+wqW30JUJVik
	 TXtDYWYPCPBNQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>,
	linusw@kernel.org,
	linux-renesas-soc@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] pinctrl: renesas: rzg2l: Add SR register cache for PM suspend/resume
Date: Mon, 31 Aug 2026 09:21:51 -0400
Message-ID: <20260831133314.4125787-83-sashal@kernel.org>
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

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 29df31ae3e8a0152dd8e8c2376816aad2f233473 ]

Include the SR (Slew Rate) register in the PM suspend/resume register
cache.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260413182456.811543-3-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: pinctrl: renesas: rzg2l: Add SR register
cache for PM suspend/resume

**Local tree:** `v6.18.43` / `6.18.43`

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[pinctrl: renesas: rzg2l]` `[add]` — Include the SR (Slew
Rate) register in the PM suspend/resume register cache.

### Step 1.2: Parse all commit message tags
**Record:**
- **Signed-off-by:** Lad Prabhakar `<prabhakar.mahadev-
  lad.rj@bp.renesas.com>` (author)
- **Reviewed-by:** Geert Uytterhoeven `<geert+renesas@glider.be>`
  (Renesas subsystem maintainer)
- **Link:**
  https://patch.msgid.link/20260413182456.811543-3-prabhakar.mahadev-
  lad.rj@bp.renesas.com
- **Signed-off-by:** Geert Uytterhoeven (maintainer tree SOB)
- No Fixes:, Reported-by:, Tested-by:, Cc: stable, or syzbot tags on
  this individual commit
- Notable: Part of v2 2/5 series; patch 1/5 (SMT fix) in the same series
  has extensive Tested-by lines from CIP and embedded testers

### Step 1.3: Analyze commit body text
**Record:**
- **Bug described:** SR registers were omitted from the PM
  suspend/resume register cache.
- **Symptom/failure mode:** After suspend-to-RAM and resume, slew-rate
  hardware settings are not saved/restored. Pins keep whatever SR values
  the hardware has after resume, not the values configured before
  suspend.
- **Version info:** None in commit message.
- **Root cause:** Incomplete PM register caching — SR was never added
  when suspend/resume support was built out, unlike IOLH, IEN, PUPD, and
  SMT.

### Step 1.4: Detect hidden bug fixes
**Record:** Yes — despite the "Add" wording, this completes an existing
suspend/resume implementation. It is the same class of bug as
`8d1c6b603327b` ("Fix SMT register cache handling"), which is already in
this tree. The cover letter explicitly frames the series as fixing PM
register caching issues.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **File:** `drivers/pinctrl/renesas/pinctrl-rzg2l.c` — ~35 insertions,
  3 deletions
- **Functions modified:** `rzg2l_pinctrl_reg_cache_alloc()`,
  `rzg2l_pinctrl_pm_setup_regs()`,
  `rzg2l_pinctrl_pm_setup_dedicated_regs()`
- **Struct modified:** `rzg2l_pinctrl_reg_cache` — adds `u32 *sr[2]`
- **Scope:** Single-file, surgical fix mirroring existing SMT/IEN/IOLH
  patterns

### Step 2.2: Code flow change per hunk
**Record:**
1. **Struct/cache alloc:** Adds `sr[2]` banked arrays for both main and
   dedicated pin caches, matching SMT layout.
2. **`rzg2l_pinctrl_pm_setup_regs()`:** On suspend, reads SR register(s)
   into cache; on resume, writes them back. Uses `has_sr = !!(caps &
   PIN_CFG_SR)` and handles split 32-bit banks when `pincnt >= 4`.
3. **`rzg2l_pinctrl_pm_setup_dedicated_regs()`:** Same SR save/restore
   for dedicated pins.

**Before → After:** SR registers were never touched during PM
transitions → SR is saved on suspend and restored on resume, consistent
with SMT/IEN/IOLH/PUPD.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic/correctness — incomplete hardware state
  save/restore on suspend/resume path
- **Mechanism:** `rzg2l_pinctrl_suspend_noirq()` calls
  `rzg2l_pinctrl_pm_setup_regs(pctrl, true)` and resume calls it with
  `false`. SR-capable pins (many SD, Ethernet, QSPI, UART pins via
  `PIN_CFG_SR`) lose their slew-rate configuration across S2RAM cycles.

### Step 2.4: Fix quality assessment
**Record:**
- **Quality:** High — follows the exact established pattern used for SMT
  (including dual-bank handling for ports with ≥4 pins).
- **Regression risk:** Very low — only adds cache entries and
  conditional read/write on existing PM paths.
- **Red flags:** None. No API changes, no locking changes.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame the changed lines
**Record:** Current `has_smt`/SMT cache block at lines 3056–3063 was
introduced by `8d1c6b603327b` (Apr 2026). SR handling is absent at the
same location — the omission predates the SMT fix and was never
addressed.

### Step 3.2: Follow Fixes: tag
**Record:** Not applicable — no Fixes: tag on this commit.

### Step 3.3: File history for related changes
**Record:** Recent related commits in this tree:
- `8d1c6b603327b` — Fix SMT register cache handling (patch 1/5,
  **already in 6.18.43**)
- `c4cfa8ee77374` — Fix incorrect PUPD register offset for high pins
- `509d342d02fff` — Fix save/restore of {IOLH,IEN,PUPD,SMT} for variable
  pincfg ports
- `dd6e519ba91e4` — Fix ISEL restore on resume

This commit is patch 2/5 of the "Fix PM register caching" v2 series.
Patches 3–5 (IOLH_RZV2H, NOD, dedicated PUPD) are separate and not
required for this SR fix.

### Step 3.4: Author's other commits
**Record:** Lad Prabhakar is an active Renesas contributor (RTC, PCI,
clk, mmc, pinctrl). The SMT fix from the same series (`8d1c6b603327b`)
is already in this tree, reviewed by Geert Uytterhoeven.

### Step 3.5: Prerequisites
**Record:**
- **Prerequisite present:** Patch 1/5 (SMT per-bank array `smt[2]`) is
  already in 6.18.43.
- **Standalone:** This patch only adds SR caching; it does not depend on
  patches 3–5.
- **Can apply cleanly:** Current tree matches the patch base (has
  `smt[2]`, lacks `sr[2]`).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:**
- **Series cover:** `v2_20260413_prabhakar_csengg_pinctrl_renesas_rzg2l_
  fix_pm_register_caching.cover` — describes fixing PM register caching
  including SR, SMT, IOLH, NOD, PUPD.
- **Lore URL:**
  https://patch.msgid.link/20260413182456.811543-3-prabhakar.mahadev-
  lad.rj@bp.renesas.com (direct fetch blocked by Anubis bot protection)
- **Series revisions:** v2; patch 2 updated per review to add dedicated
  SR cache (v1→v2 note in mbox)
- **Stable nominations in thread:** Not found in available local mbox
  content for this specific patch
- **NAKs/concerns:** None found in local mbox

### Step 4.2: Reviewers
**Record:** Geert Uytterhoeven (Renesas pinctrl maintainer) Reviewed-by
and Signed-off-by. Pavel Machek Reviewed-by on patch 2. Patch 1 has
extensive Tested-by from CIP and embedded community.

### Step 4.3: Bug report
**Record:** No external bug report or syzbot link. Bug identified by
code review during PM caching audit (cover letter: "addresses several
issues with the PM register caching implementation").

### Step 4.4: Related patches in series
**Record:** 5-patch series. Only patch 1 is in 6.18.43 so far. Patches
3–5 address separate register types (IOLH_RZV2H, NOD, dedicated PUPD)
and are independent of this SR fix.

### Step 4.5: Stable mailing list history
**Record:** Not searched (lore blocked). No stable-specific discussion
found in local mbox.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `rzg2l_pinctrl_reg_cache_alloc()`,
`rzg2l_pinctrl_pm_setup_regs()`,
`rzg2l_pinctrl_pm_setup_dedicated_regs()`, called from
`rzg2l_pinctrl_suspend_noirq()` / `rzg2l_pinctrl_resume_noirq()`.

### Step 5.2: Callers
**Record:**
- `rzg2l_pinctrl_suspend_noirq()` — `NOIRQ_SYSTEM_SLEEP_PM_OPS` at line
  3485
- `rzg2l_pinctrl_resume_noirq()` — same PM ops
- Triggered on every system suspend/resume on boards using this pinctrl
  driver with PM enabled

### Step 5.3: Callees
**Record:** `RZG2L_PCTRL_REG_ACCESS32()` macro — `readl`/`writel` on
`SR(off)` register at offset `0x1400 + (off) * 8`. SR is also used in
normal pinconf get/set (`PIN_CONFIG_SLEW_RATE` at lines 1314–1318,
1472–1476).

### Step 5.4: Call chain / reachability
**Record:** Boot → platform probe → PM suspend (S2RAM) →
`rzg2l_pinctrl_suspend_noirq()` → `rzg2l_pinctrl_pm_setup_regs(true)` →
SR **not** cached (bug). Resume path similarly fails to restore SR.
Reachable on any Renesas RZ/G2L/V2H board using suspend.

### Step 5.5: Similar patterns
**Record:** SMT, IEN, IOLH, PUPD all use identical `has_*` + dual-bank
`RZG2L_PCTRL_REG_ACCESS32` pattern. SR was the missing sibling.
`PIN_CFG_SR` appears on 100+ pin definitions across RZ/G2L, RZ/V2H,
RZ/G3E SoC data in the same file.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.43)

### Step 6.1: Does the buggy code exist?
**Record:** **Yes.** Suspend/resume is present
(`rzg2l_pinctrl_suspend_noirq` at line 3179). `PIN_CFG_SR` and `SR(off)`
exist. `rzg2l_pinctrl_reg_cache` has `smt[2]` but **no** `sr[2]`.
`rzg2l_pinctrl_pm_setup_regs()` handles SMT but not SR. Bug is live in
6.18.43.

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** Tree already has patch 1/5 (SMT
per-bank fix). No conflicting changes. Single file, established pattern.

### Step 6.3: Related fixes already present
**Record:** SMT cache fix (`8d1c6b603327b`) is in tree. SR cache fix is
**not** present. No duplicate fix found.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem and criticality
**Record:** `drivers/pinctrl/renesas/` — **PERIPHERAL** (platform-
specific, Renesas RZ SoCs). Critical for embedded/industrial users (CIP,
RZ/V2H EVKs, RZ/G2L boards) but not universal.

### Step 7.2: Subsystem activity
**Record:** Actively maintained — multiple PM suspend/resume fixes
landed in 2026 for this driver in this tree.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of `CONFIG_PINCTRL_RZG2L` on Renesas RZ/G2L,
RZ/V2H(P), RZ/V2N, RZ/G3E SoCs who use system suspend (S2RAM). Platform-
specific, not universal.

### Step 8.2: Trigger conditions
**Record:** System suspend-to-RAM on affected hardware. Common on
embedded/industrial systems. Requires PM-enabled kernel and SR-
configured pins (very common — SD, Ethernet, QSPI, UART pins all use
`PIN_CFG_SR`). Unprivileged users can trigger via standard suspend
interfaces.

### Step 8.3: Failure mode severity
**Record:** Wrong slew-rate settings after resume → signal integrity
degradation on high-speed interfaces (SDIO, Ethernet, QSPI). Can cause
peripheral malfunction, data errors, or intermittent failures post-
resume. Not a kernel oops/panic, but real hardware misbehavior.
**Severity: MEDIUM-HIGH** for affected platforms.

### Step 8.4: Risk-benefit ratio
**Record:**
- **Benefit:** Restores correct pin electrical configuration after
  suspend — prevents post-resume peripheral failures on widely deployed
  embedded SoCs.
- **Risk:** Very low — ~35 lines, mirrors proven SMT pattern, reviewed
  by maintainer.
- **Ratio:** Favorable for affected users; negligible risk to unaffected
  configurations.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence compilation

**FOR backporting:**
- Real suspend/resume bug — SR registers not saved/restored
- Same bug class as SMT fix already backported to 6.18.43
- Widely used register (`PIN_CFG_SR` on SD/Ethernet/QSPI/UART pins)
- Small, surgical, maintainer-reviewed fix
- Prerequisites (SMT per-bank cache) already in tree
- CIP/embedded community tested the series (patch 1)

**AGAINST backporting:**
- Platform-specific (Renesas RZ only)
- No crash/panic — functional/hardware correctness issue
- Commit message is terse; doesn't spell out user-visible symptoms
- Part of a 5-patch series (though this patch is self-contained)

**Unresolved:** Full lore thread review blocked by Anubis. No explicit
stable nomination found in local mbox.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — mirrors SMT/IEN pattern;
   series tested by CIP community on patch 1; maintainer reviewed.
2. Fixes a real bug affecting users? **PASS** — incomplete PM state
   save/restore on suspend/resume.
3. Important issue? **PASS** — post-resume hardware misconfiguration on
   high-speed peripherals (MEDIUM-HIGH severity for affected platforms).
4. Small and contained? **PASS** — ~35 lines, one file, three functions.
5. No new features or APIs? **PASS** — completes existing PM caching, no
   userspace-visible changes.
6. Can apply to local tree? **PASS** — buggy code present, prerequisite
   patch 1/5 already applied, clean apply expected.

### Step 9.3: Exception categories
**Record:** Not a device ID, quirk, DT, build, or docs fix. Standard bug
fix completing PM suspend/resume support.

### Step 9.4: Decision rationale

This commit fixes an omission in the Renesas RZ/G2L pinctrl driver's
suspend/resume register caching. The driver already saves and restores
SMT, IEN, IOLH, and PUPD registers, but SR (Slew Rate) was never
included. After S2RAM, pins on SDIO, Ethernet, QSPI, and other high-
speed interfaces can have incorrect electrical settings, causing
peripheral failures after resume.

The fix is minimal, follows an established in-driver pattern, was
reviewed by the subsystem maintainer, and its prerequisite (SMT per-bank
cache, patch 1/5) is already in 6.18.43. The same author and series
already had patch 1 backported to this tree, establishing that this
class of PM caching fix is appropriate for stable.

---

## Verification

- [Phase 1] `git describe HEAD` → `v6.18.43`; parsed subject, tags, body
  from user-provided commit
- [Phase 1] Read cover letter mbox: series context confirms PM caching
  bug class
- [Phase 2] Read current `pinctrl-rzg2l.c`: confirmed no `sr` in cache
  struct (lines 330–343), no `has_sr` in PM functions
- [Phase 2] Confirmed `RZG2L_PCTRL_REG_ACCESS32` macro and `SR(off)` at
  line 140
- [Phase 3] `git log --oneline -15 -- drivers/pinctrl/renesas/pinctrl-
  rzg2l.c` — related PM fixes listed
- [Phase 3] `git show 8d1c6b603327b` — SMT fix (patch 1/5) confirmed in
  tree
- [Phase 3] `git blame -L 3056,3063` — SMT block from 8d1c6b603327b; no
  SR block adjacent
- [Phase 3] `git log --author="Lad Prabhakar" -10` — active Renesas
  contributor
- [Phase 4] Read `v2_20260413_...pm_register_caching.mbx` — full series
  context, v2 revisions
- [Phase 4] `b4 dig -c 8d1c6b603327b` → lore URL for series
- [Phase 4] WebFetch lore URL for patch 3 — **blocked** by Anubis bot
  protection
- [Phase 5] Grep `PIN_CFG_SR` — 100+ pin definitions use SR capability
- [Phase 5] Grep `rzg2l_pinctrl_suspend` — PM ops at lines 3179, 3485
- [Phase 5] Read `rzg2l_pinctrl_reg_cache_alloc()` lines 2720–2766 — no
  SR allocation
- [Phase 6] Confirmed suspend/resume code exists and SR is missing from
  cache path
- [Phase 6] Confirmed patch 1/5 prerequisite present, patch 2/5 (this
  commit) absent
- [Phase 8] Assessed failure mode: post-resume slew-rate
  misconfiguration, MEDIUM-HIGH for RZ platforms

**YES**

 drivers/pinctrl/renesas/pinctrl-rzg2l.c | 38 +++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzg2l.c b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
index ab8d64a14dd0a..b4d7e80dd6468 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -322,6 +322,7 @@ struct rzg2l_pinctrl_pin_settings {
  * @pupd: PUPD registers cache
  * @ien: IEN registers cache
  * @smt: SMT registers cache
+ * @sr: SR registers cache
  * @sd_ch: SD_CH registers cache
  * @eth_poc: ET_POC registers cache
  * @oen: Output Enable register cache
@@ -336,6 +337,7 @@ struct rzg2l_pinctrl_reg_cache {
 	u32	*ien[2];
 	u32	*pupd[2];
 	u32	*smt[2];
+	u32	*sr[2];
 	u8	sd_ch[2];
 	u8	eth_poc[2];
 	u8	oen;
@@ -2746,6 +2748,11 @@ static int rzg2l_pinctrl_reg_cache_alloc(struct rzg2l_pinctrl *pctrl)
 		if (!cache->smt[i])
 			return -ENOMEM;
 
+		cache->sr[i] = devm_kcalloc(pctrl->dev, nports, sizeof(*cache->sr[i]),
+					    GFP_KERNEL);
+		if (!cache->sr[i])
+			return -ENOMEM;
+
 		/* Allocate dedicated cache. */
 		dedicated_cache->iolh[i] = devm_kcalloc(pctrl->dev, n_dedicated_pins,
 							sizeof(*dedicated_cache->iolh[i]),
@@ -2758,6 +2765,12 @@ static int rzg2l_pinctrl_reg_cache_alloc(struct rzg2l_pinctrl *pctrl)
 						       GFP_KERNEL);
 		if (!dedicated_cache->ien[i])
 			return -ENOMEM;
+
+		dedicated_cache->sr[i] = devm_kcalloc(pctrl->dev, n_dedicated_pins,
+						      sizeof(*dedicated_cache->sr[i]),
+						      GFP_KERNEL);
+		if (!dedicated_cache->sr[i])
+			return -ENOMEM;
 	}
 
 	pctrl->cache = cache;
@@ -2989,7 +3002,7 @@ static void rzg2l_pinctrl_pm_setup_regs(struct rzg2l_pinctrl *pctrl, bool suspen
 	struct rzg2l_pinctrl_reg_cache *cache = pctrl->cache;
 
 	for (u32 port = 0; port < nports; port++) {
-		bool has_iolh, has_ien, has_pupd, has_smt;
+		bool has_iolh, has_ien, has_pupd, has_smt, has_sr;
 		u32 off, caps;
 		u8 pincnt;
 		u64 cfg;
@@ -3010,6 +3023,7 @@ static void rzg2l_pinctrl_pm_setup_regs(struct rzg2l_pinctrl *pctrl, bool suspen
 		has_ien = !!(caps & PIN_CFG_IEN);
 		has_pupd = !!(caps & PIN_CFG_PUPD);
 		has_smt = !!(caps & PIN_CFG_SMT);
+		has_sr = !!(caps & PIN_CFG_SR);
 
 		if (suspend)
 			RZG2L_PCTRL_REG_ACCESS32(suspend, pctrl->base + PFC(off), cache->pfc[port]);
@@ -3061,6 +3075,15 @@ static void rzg2l_pinctrl_pm_setup_regs(struct rzg2l_pinctrl *pctrl, bool suspen
 							 cache->smt[1][port]);
 			}
 		}
+
+		if (has_sr) {
+			RZG2L_PCTRL_REG_ACCESS32(suspend, pctrl->base + SR(off),
+						 cache->sr[0][port]);
+			if (pincnt >= 4) {
+				RZG2L_PCTRL_REG_ACCESS32(suspend, pctrl->base + SR(off) + 4,
+							 cache->sr[1][port]);
+			}
+		}
 	}
 }
 
@@ -3075,7 +3098,7 @@ static void rzg2l_pinctrl_pm_setup_dedicated_regs(struct rzg2l_pinctrl *pctrl, b
 	 * port offset are close together.
 	 */
 	for (i = 0, caps = 0; i < pctrl->data->n_dedicated_pins; i++) {
-		bool has_iolh, has_ien;
+		bool has_iolh, has_ien, has_sr;
 		u32 off, next_off = 0;
 		u64 cfg, next_cfg;
 		u8 pincnt;
@@ -3097,6 +3120,7 @@ static void rzg2l_pinctrl_pm_setup_dedicated_regs(struct rzg2l_pinctrl *pctrl, b
 		has_iolh = !!(caps & (PIN_CFG_IOLH_A | PIN_CFG_IOLH_B |
 				      PIN_CFG_IOLH_C | PIN_CFG_IOLH_RZV2H));
 		has_ien = !!(caps & PIN_CFG_IEN);
+		has_sr = !!(caps & PIN_CFG_SR);
 		pincnt = hweight8(FIELD_GET(RZG2L_SINGLE_PIN_BITS_MASK, cfg));
 
 		if (has_iolh) {
@@ -3107,7 +3131,10 @@ static void rzg2l_pinctrl_pm_setup_dedicated_regs(struct rzg2l_pinctrl *pctrl, b
 			RZG2L_PCTRL_REG_ACCESS32(suspend, pctrl->base + IEN(off),
 						 cache->ien[0][i]);
 		}
-
+		if (has_sr) {
+			RZG2L_PCTRL_REG_ACCESS32(suspend, pctrl->base + SR(off),
+						 cache->sr[0][i]);
+		}
 		if (pincnt >= 4) {
 			if (has_iolh) {
 				RZG2L_PCTRL_REG_ACCESS32(suspend,
@@ -3119,6 +3146,11 @@ static void rzg2l_pinctrl_pm_setup_dedicated_regs(struct rzg2l_pinctrl *pctrl, b
 							 pctrl->base + IEN(off) + 4,
 							 cache->ien[1][i]);
 			}
+			if (has_sr) {
+				RZG2L_PCTRL_REG_ACCESS32(suspend,
+							 pctrl->base + SR(off) + 4,
+							 cache->sr[1][i]);
+			}
 		}
 		caps = 0;
 	}
-- 
2.53.0

