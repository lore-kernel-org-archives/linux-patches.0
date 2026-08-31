Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00B7521227;
	Mon, 31 Aug 2026 13:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183849; cv=none; b=jLxAN0sILUrZaH2Z8p6Q15FuadQV7xSnI/GNQkPQnMqO7W3LrZzhlqYUztaCKlX6mgxxt9vdKS6g4VHrCCcGA3pf0Cs939rNKepVxdlSd+dmOwC+tu1ZEBealAyhMeDic2rUU+kVdkLk0ft6Lf5F/myzUJydKYN8cvyQ2ISFOyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183849; c=relaxed/simple;
	bh=+eIMNW+G9+vS/u+rgKv4T3f8IJb0j8tppCh6r0VNmSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iUmPcdGbDQQ+HKGiXWavRBXRH3BLwvgAeue1D0MFDJAT1mLetLYTOP6gVrtxHunIazlleIFGBA6bSuu7cO9KNjhvFHyMJvUF1DqYEofOHdhD+R5Wocxx7Joc1V3zc+chcHiZCtT3adgo9z8Z5XmSmWki2E0SP9HgieTlvcPZ77M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TBJqPGmz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TBJqPGmz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777681F00ADE;
	Mon, 31 Aug 2026 13:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183846;
	bh=5ZSYxAxyXIXMLA4+TJmzL2ZvISOyC00ADA5E9FDWHxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TBJqPGmzAffSjVBKMbUqIx2pC1SCHbubjAB+XkX9FUF4r2SOpm1Roj2gSGY2iE0v6
	 DgMNO7flNIJN4J5iVPwk9sIINs6Uw1LXKY0uARAeS6rufJlv6UsE6t3ISAEg3Xi+c2
	 JeKa2ePk+V/y0XVpmtjb2gIAG7QI0vHFBxMoUtDk24vRPDvz0QEt+4bAWtwd7QfEds
	 bYKSCYgDDqeTjMy0GeNONMtrKmMuNclV7DuHqRJe+7dUXLXG/HKGpsc2mO7HkGv7HJ
	 4v53s5Itz/oSX5ZnNpPv8HgmatItvcFNQwc4C1J4HkS7Lqn75iXNWYcMtZWZ56lTh1
	 Cp4NB/Q6L3GjA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	shengjiu.wang@gmail.com,
	Xiubo.Lee@gmail.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ASoC: fsl-asoc-card: reduce WM8904 PLL ratio to meet frequency limit
Date: Mon, 31 Aug 2026 09:26:07 -0400
Message-ID: <20260831133314.4125787-339-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 99b5316f08f390a5e1ea2239ecca8e2b4ef70ac6 ]

WM8904 has a 27 MHz PLL frequency limit. The current S24_LE PLL ratio
of 384 exceeds this at high sample rates (96 kHz × 384 = 36.864 MHz).

Reduce the ratio to 192 for WM8904, keeping PLL within limits at all
supported rates (96 kHz × 192 = 18.432 MHz).

Add codec-specific pll_ratio_s24 field, default 384, override to 192
for WM8904.

Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20260429100028.2739711-6-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[ASoC: fsl-asoc-card]` `[reduce]` — Lower WM8904 S24_LE PLL
ratio so FLL output stays within the codec’s frequency limit.

### Step 1.2: Commit Message Tags
**Record:**
- **Signed-off-by:** Shengjiu Wang `<shengjiu.wang@nxp.com>` (author,
  NXP)
- **Link:** https://patch.msgid.link/20260429100028.2739711-6-
  shengjiu.wang@nxp.com
- **Signed-off-by:** Mark Brown `<broonie@kernel.org>` (ASoC maintainer,
  applied the series)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, or Cc: stable tags
- Part of **[PATCH v2 5/5]** in series “ASoC: fsl-asoc-card: Add some
  improvements”

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** WM8904 FLL/PLL output is limited to 27 MHz. With the
  hardcoded S24_LE ratio of 384, high sample rates exceed that (96 kHz ×
  384 = 36.864 MHz).
- **Symptom:** FLL programmed out of spec → audio fails or is unreliable
  at high rates with S24_LE on WM8904 boards.
- **Root cause:** `fsl-asoc-card.c` uses a single 384 multiplier for all
  codecs with PLL enabled; WM8904 needs 192.
- **Fix:** Add per-codec `pll_ratio_s24` (default 384), set 192 for
  `fsl,imx-audio-wm8904`.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Yes — despite “reduce ratio,” this is a hardware correctness
fix (codec clock out of spec), not a cosmetic cleanup.

---

## Phase 2: Diff Analysis

### Step 2.1: Change Inventory
**Record:**
- **File:** `sound/soc/fsl/fsl-asoc-card.c` (+7 / −1)
- **Functions:** `fsl_asoc_card_hw_params()`, `fsl_asoc_card_probe()`
- **Structs:** `codec_priv` (+1 field)
- **Scope:** Single-file, surgical fix

### Step 2.2: Code Flow Changes
**Record:**
- **Hunk 1 (struct):** Adds `pll_ratio_s24` to `codec_priv` with
  documentation.
- **Hunk 2 (`hw_params`):** `pll_out = sample_rate * 384` → `pll_out =
  sample_rate * codec_priv->pll_ratio_s24` for S24_LE.
- **Hunk 3 (`probe` init):** Default `pll_ratio_s24 = 384` for all
  codecs.
- **Hunk 4 (WM8904 branch):** Override to `pll_ratio_s24 = 192` for
  `fsl,imx-audio-wm8904`.

**Before → After:** WM8904 at 96 kHz S24_LE requests 36.864 MHz FLL
output → 18.432 MHz (within 27 MHz limit).

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Hardware workaround / logic correctness (wrong clock
  ratio for a specific codec).
- **Mechanism:** Generic 384× ratio violates WM8904’s 27 MHz PLL limit
  at rates above ~70 kHz with S24_LE (e.g. 88.2 kHz × 384 = 33.9 MHz, 96
  kHz × 384 = 36.9 MHz).

### Step 2.4: Fix Quality
**Record:**
- Minimal, codec-specific override; other codecs unchanged (default
  384).
- Low regression risk; only affects WM8904 machine configs using PLL
  path.
- NXP-authored, ASoC-maintainer-applied.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** In this 6.18.43 tree, the hardcoded `384` at line 225 and
WM8904 probe block at lines 833–838 are present. Stable history is
flattened, but `imx-audio-wm8904` support is in the tree since at least
Linux 6.18-rc7 (`ac3fd01e4c1ef`).

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related File History
**Record:** Patch is **[5/5]** in a series; patches 1–4 cover ASRC DPCM,
CS42888 constraints, and WM8960/WM8962 format limits — unrelated to this
WM8904 PLL fix. This patch is self-contained.

### Step 3.4: Author Context
**Record:** Shengjiu Wang is an active NXP/i.MX audio contributor with
multiple stable-worthy ASoC fixes in this tree.

### Step 3.5: Dependencies
**Record:** No prerequisites. Applies standalone; only needs existing
`fsl,imx-audio-wm8904` support and PLL code path already in 6.18.43.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:** `b4 mbox` retrieved thread from lore (7 messages). Patch v2
5/5 submitted 2026-04-29. Mark Brown applied entire series to
`broonie/sound` for-7.2 on 2026-04-30. This patch:
https://git.kernel.org/broonie/sound/c/99b5316f08f3. No stable
nomination or NAK found in thread.

### Step 4.2: Reviewers
**Record:** CC’d: broonie@kernel.org, lgirdwood@gmail.com,
perex@perex.cz, tiwai@suse.com, linux-sound@vger.kernel.org. Mark Brown
applied with “Thanks!”

### Step 4.3: Bug Report
**Record:** No external bug tracker. Issue found during NXP board
testing per cover letter (“During testing several issues were
identified”).

### Step 4.4: Series Context
**Record:** 5-patch series; this patch is independent of patches 1–4.

### Step 4.5: Stable List History
**Record:** UNVERIFIED — lore stable search blocked by bot protection;
no stable discussion found in mbox thread.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `fsl_asoc_card_hw_params()`, `fsl_asoc_card_probe()`,
`wm8904_set_fll()` (codec callee).

### Step 5.2: Callers
**Record:** `fsl_asoc_card_hw_params` registered as `.hw_params` in card
DAI ops (line 295) — invoked on every PCM open/hw_params for
playback/capture.

### Step 5.3: Callees
**Record:** `snd_soc_dai_set_pll()` → `wm8904_set_fll()` →
`fll_factors()` configures WM8904 FLL registers. `wm8904.c` does not
validate Fout against 27 MHz; it can succeed in software while hardware
is out of spec (Fvco computed up to ~147 MHz at 36.864 MHz Fout).

### Step 5.4: Reachability
**Record:** Userspace opens PCM stream on imx8mp Hummingboard Pulse (and
related boards) with WM8904 → `hw_params` → PLL programmed. WM8904
advertises `SNDRV_PCM_FMTBIT_S24_LE` and rates up to 96 kHz — the broken
path is reachable from normal audio use.

### Step 5.5: Similar Patterns
**Record:** Other codecs on the same driver (WM8962, WM8994, NAU8822)
keep default 384; only WM8904 needs the lower ratio — consistent with
codec-specific hardware limits.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.43)

### Step 6.1: Buggy Code Present?
**Record:** **YES.** Local tree is `v6.18.43` (stable/linux-6.18.y).
Buggy hardcoded `384` at line 225; WM8904 config at lines 833–838
without ratio override. `imx8mp-hummingboard-pulse-codec.dtsi` uses
`fsl,imx-audio-wm8904`. Multiple DTBs build from that DTSI.

### Step 6.2: Backport Complications
**Record:** Clean apply expected — patch matches current file structure
(index `44083d15f6e5` in submission aligns with local tree).

### Step 6.3: Related Fixes Already Present?
**Record:** `pll_ratio_s24` not in tree; fix not yet applied.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem and Criticality
**Record:** **ASoC / sound/soc/fsl** — IMPORTANT for i.MX embedded
platforms; not core kernel, but affects real shipped hardware.

### Step 7.2: Subsystem Activity
**Record:** Actively maintained; WM8904 Hummingboard support added in
6.18 cycle.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of i.MX boards with `fsl,imx-audio-wm8904` (SolidRun
imx8mp Hummingboard Pulse/Pro/Mate/Ripple variants).
CONFIG_SND_SOC_FSL_ASOC_CARD + WM8904.

### Step 8.2: Trigger Conditions
**Record:** PCM stream with `SNDRV_PCM_FORMAT_S24_LE` at sample rates
where `rate × 384 > 27 MHz` — notably 88.2 kHz and 96 kHz. Common for
hi-res audio. Unprivileged users via standard ALSA/PulseAudio/PipeWire.

### Step 8.3: Failure Severity
**Record:** **MEDIUM-HIGH** for affected hardware — broken or unreliable
audio (FLL out of spec), not a kernel crash. Real functional defect on
supported boards.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Restores correct audio at high sample rates on WM8904
  boards already supported in 6.18.y.
- **Risk:** Very low — 7-line change, WM8904-only override, defaults
  preserved for other codecs.
- **Ratio:** Strong benefit, minimal risk.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real hardware bug on boards in this tree
- Vendor-authored, maintainer-applied fix
- Small, self-contained, standalone within series
- Buggy code confirmed present in 6.18.43
- Hardware quirk / workaround category (stable-appropriate)
- Affects user-visible audio functionality

**AGAINST backport:**
- Not a crash/security/data-corruption issue
- Limited to one machine driver + one codec variant
- WM8904 fsl-asoc-card support is relatively new in 6.18

**Unresolved:** No independent Tested-by; no explicit stable nomination
in mailing list.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — math verified; NXP + Mark
   Brown; identified in board testing.
2. Fixes real bug affecting users? **PASS** — broken hi-rate S24_LE
   audio on WM8904 imx boards.
3. Important issue? **PASS (MEDIUM)** — functional hardware defect, not
   crash-level.
4. Small and contained? **PASS** — 7 lines, one file.
5. No new features/APIs? **PASS** — internal driver parameter only.
6. Can apply to local tree? **PASS** — code exists, clean apply
   expected.

### Step 9.3: Exception Category
**Record:** Hardware quirk/workaround — codec-specific clock ratio
correction.

### Step 9.4: Decision Rationale
For **linux-6.18.y (6.18.43)**: the buggy WM8904 PLL configuration is
present, real imx8mp Hummingboard hardware is supported, and the fix is
minimal and codec-specific. This is appropriate stable material as a
hardware correctness fix for boards already enabled in this tree.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message and
  mbox
- [Phase 2] Diff analysis: 7 lines in `fsl-asoc-card.c`, 2 functions
  modified
- [Phase 3] `git describe HEAD` → v6.18.43; `git blame` line 225 shows
  hardcoded 384
- [Phase 3] `git log stable/linux-6.18.y -S "imx-audio-wm8904"` →
  present since 6.18-rc7
- [Phase 3] Confirmed patch 5/5 is standalone within series (mbox cover
  letter)
- [Phase 4] `b4 mbox` → 7-message thread; Mark Brown applied series
  2026-04-30
- [Phase 4] No stable/CC/stable or NAK in mbox thread
- [Phase 4] UNVERIFIED: lore stable list search (bot-blocked)
- [Phase 5] `fsl_asoc_card_hw_params` called from `.hw_params` DAI ops
  (line 295)
- [Phase 5] `wm8904_set_fll`/`fll_factors` reviewed — no 27 MHz Fout
  validation in driver
- [Phase 5] WM8904 supports S24_LE and up to 96 kHz (`wm8904.c` lines
  2023–2026)
- [Phase 6] Buggy code confirmed at line 225; WM8904 probe at lines
  833–838
- [Phase 6] `imx8mp-hummingboard-pulse-codec.dtsi` uses `fsl,imx-audio-
  wm8904`
- [Phase 6] Multiple DTBs include pulse codec DTSI (Makefile lines 211,
  pro/mate/ripple)
- [Phase 8] 96 kHz × 384 = 36.864 MHz > 27 MHz; 96 kHz × 192 = 18.432
  MHz < 27 MHz
- [Phase 8] 88.2 kHz × 384 = 33.87 MHz also exceeds limit

**YES**The background git history checks are done. They confirm:

- **`imx-audio-wm8904` support is in the 6.18.y tree** (present since at
  least Linux 6.18-rc7), including the Hummingboard Pulse DTS and the
  hardcoded `384` PLL ratio.
- **The fix is not in this tree yet** — `pll_ratio_s24` does not appear
  on master or stable.
- **History is flattened** in this checkout, so individual introduction
  commits are hard to isolate, but the buggy WM8904 path is clearly
  present in 6.18.43.

That supports the earlier **YES** verdict: this is a small, standalone
hardware fix for boards already supported in linux-6.18.y.

 sound/soc/fsl/fsl-asoc-card.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl-asoc-card.c b/sound/soc/fsl/fsl-asoc-card.c
index 71113886e494b..dcf2e495ad19f 100644
--- a/sound/soc/fsl/fsl-asoc-card.c
+++ b/sound/soc/fsl/fsl-asoc-card.c
@@ -48,6 +48,9 @@
  * @mclk_id: MCLK (or main clock) id for set_sysclk()
  * @fll_id: FLL (or secordary clock) id for set_sysclk()
  * @pll_id: PLL id for set_pll()
+ * @pll_ratio_s24: PLL output ratio for S24_LE format (PLL_freq = sample_rate × ratio)
+ *                 Default is 384, but some codecs (e.g., WM8904) require lower values
+ *                 to stay within PLL frequency limits
  */
 struct codec_priv {
 	struct clk *mclk;
@@ -56,6 +59,7 @@ struct codec_priv {
 	u32 mclk_id;
 	int fll_id;
 	int pll_id;
+	int pll_ratio_s24;
 };
 
 /**
@@ -222,7 +226,7 @@ static int fsl_asoc_card_hw_params(struct snd_pcm_substream *substream,
 
 		if (codec_priv->pll_id >= 0 && codec_priv->fll_id >= 0) {
 			if (priv->sample_format == SNDRV_PCM_FORMAT_S24_LE)
-				pll_out = priv->sample_rate * 384;
+				pll_out = priv->sample_rate * codec_priv->pll_ratio_s24;
 			else
 				pll_out = priv->sample_rate * 256;
 
@@ -742,6 +746,7 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 	for (codec_idx = 0; codec_idx < 2; codec_idx++) {
 		priv->codec_priv[codec_idx].fll_id = -1;
 		priv->codec_priv[codec_idx].pll_id = -1;
+		priv->codec_priv[codec_idx].pll_ratio_s24 = 384;
 	}
 
 	/* Diversify the card configurations */
@@ -835,6 +840,7 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 		priv->codec_priv[0].mclk_id = WM8904_FLL_MCLK;
 		priv->codec_priv[0].fll_id = WM8904_CLK_FLL;
 		priv->codec_priv[0].pll_id = WM8904_FLL_MCLK;
+		priv->codec_priv[0].pll_ratio_s24 = 192;
 		priv->dai_fmt |= SND_SOC_DAIFMT_CBP_CFP;
 	} else if (of_device_is_compatible(np, "fsl,imx-audio-spdif")) {
 		ret = fsl_asoc_card_spdif_init(codec_np, cpu_np, codec_dai_name, priv);
-- 
2.53.0

