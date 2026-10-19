Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C9C50CB9E;
	Mon, 19 Oct 2026 13:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418184; cv=none; b=NX3rrTjM4aDeNNASaifO4SpRk7M+8hpFqqXWbdAEwARsYtP8JLdxKBrpo11SUa/nCsWfafHPhtorKz6szpRwakCfs3SFFJYD6tYThPkm1EFJvONR4prnTNTVz7suPHiGO/v+wQc5l2gYcoBmvtx5SaPuKtm7saj2E3OqXu885KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418184; c=relaxed/simple;
	bh=64wbx6iNUX5hMashJA/cGV6HZLlxpQuugyBu+6yJj7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g4pr+6TpZAp2gZCNsrzOPG0dnmgn37tSA1Z9xXWKUr+CJdL9aQX9skrg3b4LmSJmvQS2TYwj31dDIBGFEf463w+s8AeHUddFI3tcGy4XdnesDW0s9yRaVdZIsl7WLGGCozqvGX3SYyLn8l1c1dCOu9xFPui82tWW8+SCywVhlzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g5zpEdYE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g5zpEdYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531681F000C6;
	Mon, 19 Oct 2026 13:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418181;
	bh=3yg544AMwJMoN2dDiUd4b0S+WmHBEgyeTWHzy1W5j1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g5zpEdYEVUTWkKbw714MSDsGtRqKplLyQJvJGFWOsXhDmlqTiHDiDEZdg95uyrvi8
	 zhEuJSUxCwuREpGOSK/UbTX4NEvI8IPYDvzOJCm9NDXfMheLgICpRNw685ACaO35GR
	 wSdku1gTYqcK5FqZcdwpj2VJUMLo+/OdaWQA98ZEALa4WWgEUGlqqhlxh/TVTmeqx8
	 bBHB+tp+KYO7Gh3ApF7ByYeeWNwXQnaIFnxntUUYJg6+FeDoybDdbiMnw531b7Tzya
	 h9zTOwOfv1g02aKbDPtLWDjfPoNzgoUbODL5A9Ayj0aqyEXz3pnfXngm17MtTGUce3
	 ZN+8unMOJvDtg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	daniel.baluta@nxp.com,
	perex@perex.cz,
	tiwai@suse.com,
	sound-open-firmware@alsa-project.org,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ASoC: SOF: Intel: mtl: Power down DSP if it is left enabled in pre_fw_run()
Date: Mon, 19 Oct 2026 09:46:01 -0400
Message-ID: <20261019135441.1420968-70-sashal@kernel.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 31fd7a0bbfa4b7e8aff11f278e817664c6a5f68b ]

It is expected that the DSP is in power down state when the firmware boot
is attempted.
If the DSP for any reason was left powered up then the DSP boot will
fail since the ROM boot sequence might not be able to run.

Make sure that the DSP is off before proceeding to boot it up.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Link: https://patch.msgid.link/20260730122857.5294-3-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Local tree is **6.1.188** (`pending-6.1`). The Meteor Lake SOF path this
patch targets is present here, so the question is whether the DSP-left-
on boot failure is worth a backport on this tree.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[ASoC / SOF Intel MTL] [Power down] Ensure DSP is off before
firmware boot in `pre_fw_run()`**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- `Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>`
  (author; Intel SOF)
- `Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>` (Intel SOF)
- `Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>` (ASoC/SOF
  maintainer)
- `Link: https://patch.msgid.link/20260730122857.5294-3-
  peter.ujfalusi@linux.intel.com`
- `Signed-off-by: Mark Brown <broonie@kernel.org>` (ASoC maintainer,
  applied)
- No `Fixes:`, no `Reported-by:`, no `Cc: stable` (absence is expected
  for this review)
- Ignore any `Signed-off-by: Sasha Levin` / `[Upstream commit ...]`
  pipeline markers

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** Firmware boot is assumed to start with the DSP powered down.
  If it is already up, the ROM boot sequence cannot run and DSP boot
  fails.
- **Symptom:** SOF firmware boot failure → no audio on Meteor Lake.
- **Cover letter (series 0/2, verified via b4):** “We have seen reports
  that for some undetermined reasons the DSP was on during system boot
  and this caused firmware boot failure as the DSP cannot be booted up -
  it was already in booted up state.”
- **Root cause:** DSP subsystem left powered (BIOS leftover, kexec,
  failed prior boot, etc.); `pre_fw_run()` only powers up, never powers
  down first.
- **Version info:** Applied by Mark Brown to `for-7.3` (next merge
  window), not as a current-rc hotfix.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: **Not a disguised cleanup.** Explicit hardware recovery: if CPA
shows the DSP already on, power it down before the normal power-up
sequence. This is a real functional fix.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `sound/soc/sof/intel/mtl.c` only
- ~23 lines added, 0 removed
- New: `mtl_dsp_is_enabled()`
- Modified: `mtl_dsp_pre_fw_run()` — extra check at the start
- **Scope:** single-file, surgical

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Before:** `mtl_dsp_pre_fw_run()` always sets SPA to power the DSP
  subsystem on, waits, then powers the gated DSP domain. No check of
  current power state.
- **After:** Read `MTL_HFDSSCS`; if `MTL_HFDSSCS_CPA_MASK` is set, call
  existing `mtl_power_down_dsp()`. On failure, `dev_warn` and continue.
  Then the existing power-up sequence runs.
- **Path:** firmware boot (`snd_sof_run_firmware()`), probe and resume.
  The new code runs only when the DSP is already enabled.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- **Category:** hardware workaround / logic correctness (wrong assumed
  power state)
- **Mechanism:** ROM boot needs a cold/off DSP. CPA=1 means the
  subsystem is already on; setting SPA again does not run ROM init.
  Powering down first restores a clean boot state.
- Same idea as SKL’s existing `hda_dsp_core_is_enabled()` handling in
  `hda-loader-skl.c` (already in this tree).

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- **Quality:** Obviously correct. Uses existing `mtl_power_down_dsp()`
  and the same CPA bit already used for power-up poll.
- **Minimal:** one helper + one guarded call; normal path unchanged.
- **Regression risk:** Low. Clean suspend already calls
  `power_down_dsp()` (`hda_suspend()`), so IMR/resume should still see
  CPA=0. The new path only fires on the abnormal “already on” case.
  Power-down failure is warn-and-continue, not a hard fail.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- `mtl_dsp_pre_fw_run()` introduced in `064520e8aeaa2` (“ASoC: SOF:
  Intel: Add support for MeteorLake (MTL)”, Bard Liao, 2022-06-15) —
  **in this 6.1 tree**.
- `mtl_power_down_dsp()` added in `2090cb9bf5747` (2022-09-23) — **also
  in this tree** (`git merge-base --is-ancestor` confirmed).
- Buggy “power up without checking current state” has been here for the
  whole 6.1 lifetime of MTL.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. Bug is the original MTL `pre_fw_run()` design,
not a later regression.

**Step 3.3: CHECK FILE HISTORY**

Record: Recent local history is MTL bring-up/PM (`064520e8aeaa2`,
`2090cb9bf5747`, `6ae87bab269b3`, timeout/dump tweaks). No existing
“power down if already on” logic. Standalone vs CAVS: this is patch
**2/2**; patch 1/2 is `hda.c` for older CAVS. MTL overrides
`.pre_fw_run` with `mtl_dsp_pre_fw_run`, so **this commit does not
depend on 1/2**.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Peter Ujfalusi is an Intel SOF regular. Reviewers are Intel SOF
(Bard Liao) and Liam Girdwood. High confidence in the hardware
diagnosis.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record:
- Needs `mtl_power_down_dsp()`, `MTL_HFDSSCS`, `MTL_HFDSSCS_CPA_MASK` —
  all present.
- Upstream context has later PTL/ACE 2.0 register selection
  (`PTL_HFPWRCTL2`, `SOF_INTEL_ACE_2_0`). **Those are context only, not
  this change.** 6.1 `pre_fw_run()` is the original MTL-only version.
- In 6.1 `mtl_power_down_dsp()` is `static` and defined **after**
  `mtl_dsp_pre_fw_run()` (line 401 vs 240). Upstream later made it a
  header prototype. Backport needs a **static forward declaration** (or
  a reorder). That is a trivial, mechanical adjustment, not a missing
  feature.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c 31fd7a0bbfa4` (hash from Mark Brown’s apply mail) matched
  patch-id.
- Thread: https://patch.msgid.link/20260730122857.5294-3-
  peter.ujfalusi@linux.intel.com
- Cover: `[PATCH 0/2] ASoC: SOF: Intel: hda/mtl: Handle powered on DSP
  on boot`
- Full thread saved via `b4 mbox` (4 messages): cover, 1/2 hda, 2/2 mtl,
  Mark Brown apply.
- **v1 only** (`b4 dig -a`); no v2/v3.
- **No NAKs.** Applied to `https://git.kernel.org/broonie/sound for-7.3`
  as `31fd7a0bbfa4`.
- No reviewer `Cc: stable` in the thread.

**Step 4.2: CHECK WHO REVIEWED**

Record (`b4 dig -w`): To/Cc were Liam Girdwood, Mark Brown, linux-sound,
Kai Vehmanen, Bard Liao, Pierre-Louis Bossart. Right maintainers.
Reviewed-by from Bard Liao and Liam Girdwood.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No public bugzilla/syzbot link. Evidence is the cover letter:
Intel has reports of DSP-on-at-boot causing firmware boot failure.
Severity from reporters: **audio DSP does not boot**. User count:
unspecified (“reports”), not a single anecdotal one-off in the message,
but not named either.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Series is 2 independent platform hooks (hda CAVS vs mtl ACE).
This MTL patch is self-contained. No later follow-up found in the
thread.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org/stable WebFetch returned 403. Web search found
no stable-list discussion of this subject. **UNVERIFIED:** no evidence
it was requested or rejected for stable.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**

Record: `mtl_dsp_is_enabled()` (new), `mtl_dsp_pre_fw_run()` (modified),
`mtl_power_down_dsp()` (callee, unchanged).

**Step 5.2: TRACE CALLERS**

Record:
- `sof_mtl_ops.pre_fw_run = mtl_dsp_pre_fw_run` (`sof_mtl_ops_init`)
- `snd_sof_dsp_pre_fw_run()` → `snd_sof_run_firmware()`
  (`sound/soc/sof/loader.c`)
- `snd_sof_run_firmware()` from probe (`sound/soc/sof/core.c`) and
  resume (`sound/soc/sof/pm.c`)

**Step 5.3: TRACE CALLEES**

Record: `snd_sof_dsp_read()` (CPA), `mtl_power_down_dsp()` →
`mtl_dsp_core_power_down()` then clear SPA and poll CPA=0. Same sequence
already used on suspend/remove.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Probe of `sof-audio-pci-intel-mtl` (PCI `8086:7e28`) → load
firmware → `pre_fw_run` → ROM boot. **Reachable on every MTL SOF boot**,
not a debug-only path. Unprivileged users do not trigger it directly; it
runs at device probe/resume.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: SKL loader already handles “core already enabled” (`hda-loader-
skl.c`). CAVS sibling is series 1/2. MTL/ACE had a gap this commit
fills.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes.** `sound/soc/sof/intel/mtl.c` `mtl_dsp_pre_fw_run()`
(from ~line 240) powers on with no prior CPA check. Introduced with MTL
in v6.1 (`064520e8aeaa2`). PCI ID and `CONFIG_SND_SOC_SOF_METEORLAKE`
exist. Local `make kernelversion`: **6.1.188**.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Minor conflicts, not rework.**
- Upstream hunk context includes later `mtl_enable_interrupts(..., bool
  enable)`, `EXPORT_SYMBOL_NS`, PTL `dsppwrctl`/`chip->hw_ip_version` —
  **not in 6.1**.
- Logical change still maps 1:1 onto 6.1 `pre_fw_run()`.
- Need a forward declaration of static `mtl_power_down_dsp()`.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: No local commit with this subject or “power down if left
enabled” on `mtl.c`. Not already fixed.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **ASoC SOF Intel Meteor Lake** (`sound/soc/sof/intel/mtl.c`).
**IMPORTANT** for MTL laptops/desktops using SOF (not core mm/net).
Peripheral relative to the whole kernel, but this is the Intel audio DSP
path for that generation.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: MTL was added during 6.1 development and then mostly stable on
this branch (timeouts, dumps, PM ops). Mature for 6.1, not a brand-new
post-branch subsystem.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **Driver-specific** — `CONFIG_SND_SOC_SOF_METEORLAKE`, PCI
`8086:7e28`. 6.1 LTS users on Meteor Lake (e.g. Debian bookworm-class
kernels on Core Ultra hardware).

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: DSP already powered when `pre_fw_run()` runs (BIOS, kexec,
leftover from a failed boot). Not every boot. Not userspace-triggerable
as a security issue. Intel reports it on **system boot**.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: SOF firmware boot failure → **no audio**. Not a
panic/UAF/corruption. **HIGH for affected hardware** (device does not
work), **MEDIUM** in whole-tree terms.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** MTL machines that otherwise fail DSP boot get working
  audio. Matches the hardware-quirk exception.
- **Risk:** Low — ~20 lines, gated on CPA, uses existing power-down,
  warn-and-continue on failure, suspend already powers down so IMR
  resume should be unaffected.
- **Ratio:** Favorable for this tree.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real, reported firmware-boot failure when DSP is already on
- User-visible: no audio
- Small, obviously correct, Intel-reviewed
- Buggy code and `mtl_power_down_dsp()` both exist in 6.1
- Hardware workaround class (explicitly stable-appropriate)
- Standalone from series 1/2
- Normal boot/resume unchanged

**AGAINST:**
- Not a crash/security/corruption/deadlock
- Trigger is uncommon / “undetermined”
- Applied to for-7.3, not sent as -rc
- Needs a small backport (context + forward declaration)

**UNRESOLVED:**
- Stable list discussion (lore/stable 403)
- Exact BIOS/platforms in the unnamed reports

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — Intel review; uses existing
   power-down + CPA
2. Fixes a real bug that affects users? **PASS** — reported DSP-on-at-
   boot, firmware boot fail
3. Important issue? **PASS** — audio device fails to initialize
   (hardware-workaround class)
4. Small and contained? **PASS** — one file, ~23 lines
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — logic applies; minor
   context/prototype adaptation

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: **Hardware quirk/workaround** — force a known-good DSP power
state before ROM boot, analogous to USB/PCI reset-on-init quirks.

**Step 9.4: DECISION**

This is a small recovery for a real MTL SOF boot failure that exists in
6.1. The bug is “DSP already on → firmware never boots,” not a
theoretical cleanup. Risk is low because the new code only runs when CPA
is already set, and that path already exists for suspend/remove. It
should be backported to this tree.

---

### What the commit solves for stable users

On Meteor Lake, SOF expects the DSP subsystem off before ROM boot. If it
is already on, `pre_fw_run()` still only sets SPA; ROM init does not run
and probe/resume fails with no audio. The fix reads CPA and, if set,
calls the existing `mtl_power_down_dsp()` so the following power-up is a
clean boot.

### Stable rules / risk

Meets the rules: real bug, small, no new API, hardware workaround.
Benefit is working audio on affected MTL systems; regression risk is
low.

### Concerns

Literal `git am` will not apply (later PTL/`bool enable` context). A 6.1
backport is the same helper + call, plus a static forward declaration of
`mtl_power_down_dsp()`. Series 1/2 (`hda.c`) is not required for this
MTL change.

---

### Verification

- **[Phase 1]** Parsed tags from the provided message and the b4 mbox:
  author Peter Ujfalusi; Reviewed-by Bard Liao, Liam Girdwood; applied
  by Mark Brown; no Fixes/Reported-by/Cc: stable
- **[Phase 1]** Cover letter (mbox): Intel reports of DSP-on-at-boot
  causing firmware boot failure
- **[Phase 2]** Diff: +23 lines in `mtl.c`; `mtl_dsp_is_enabled()` +
  guarded `mtl_power_down_dsp()` in `mtl_dsp_pre_fw_run()`
- **[Phase 3]** `git describe HEAD` / `make kernelversion`: p-6.1-12 /
  **6.1.188**
- **[Phase 3]** `git merge-base --is-ancestor 064520e8aeaa2 HEAD`: MTL
  support present
- **[Phase 3]** `git merge-base --is-ancestor 2090cb9bf5747 HEAD`:
  `mtl_power_down_dsp` present
- **[Phase 3]** `git blame -L 240,284 sound/soc/sof/intel/mtl.c`:
  pre_fw_run still original 064520e8aeaa2; no CPA-down check
- **[Phase 3]** Confirmed `MTL_HFDSSCS` / `MTL_HFDSSCS_CPA_MASK` in
  `mtl.h`
- **[Phase 3]** Function order: `mtl_dsp_pre_fw_run` @240,
  `mtl_power_down_dsp` @401 (forward decl needed)
- **[Phase 4]** `b4 mbox` of 20260730122857.5294-3: cover + 1/2 + 2/2 +
  apply; no NAK
- **[Phase 4]** `b4 dig -c 31fd7a0bbfa4`: lore match; v1 only; applied
  to for-7.3 as 31fd7a0bbfa4
- **[Phase 4]** `b4 dig -w`: maintainers CC’d
- **[Phase 4]** lore.kernel.org WebFetch: 403
- **[Phase 5]** Callers: `snd_sof_run_firmware` ← probe (`core.c`) and
  resume (`pm.c`)
- **[Phase 5]** `hda_suspend()` already calls `chip->power_down_dsp()` —
  clean resume should have CPA=0
- **[Phase 5]** SKL already has similar “if core enabled” handling in
  `hda-loader-skl.c`
- **[Phase 6]** `pci-mtl.c` PCI ID 8086:7e28;
  `CONFIG_SND_SOC_SOF_METEORLAKE` in Kconfig
- **[Phase 6]** MTL overrides `.pre_fw_run`; series 1/2 not a dependency
- **[Phase 8]** Failure: SOF firmware boot fail / no audio, not oops
- **UNVERIFIED:** stable@ discussion (HTTP 403); named
  reporters/machines

**YES**

 sound/soc/sof/intel/mtl.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/sound/soc/sof/intel/mtl.c b/sound/soc/sof/intel/mtl.c
index 2242c96bfa519..f119e0e0651a2 100644
--- a/sound/soc/sof/intel/mtl.c
+++ b/sound/soc/sof/intel/mtl.c
@@ -236,6 +236,17 @@ int mtl_enable_interrupts(struct snd_sof_dev *sdev, bool enable)
 }
 EXPORT_SYMBOL_NS(mtl_enable_interrupts, "SND_SOC_SOF_INTEL_MTL");
 
+static bool mtl_dsp_is_enabled(struct snd_sof_dev *sdev)
+{
+	int val;
+
+	val = snd_sof_dsp_read(sdev, HDA_DSP_BAR, MTL_HFDSSCS);
+	if (val & MTL_HFDSSCS_CPA_MASK)
+		return true;
+
+	return false;
+}
+
 /* pre fw run operations */
 static int mtl_dsp_pre_fw_run(struct snd_sof_dev *sdev)
 {
@@ -249,6 +260,18 @@ static int mtl_dsp_pre_fw_run(struct snd_sof_dev *sdev)
 	u32 dsppwrsts;
 	const struct sof_intel_dsp_desc *chip;
 
+	/* Power down the DSP if it is left enabled to ensure clean boot state */
+	if (mtl_dsp_is_enabled(sdev)) {
+		dev_dbg(sdev->dev, "powering down DSP first\n");
+
+		ret = mtl_power_down_dsp(sdev);
+		if (ret < 0) {
+			dev_warn(sdev->dev,
+				 "%s: failed to power down already-enabled DSP\n", __func__);
+			/* Continue anyway to attempt recovery */
+		}
+	}
+
 	chip = get_chip_info(sdev->pdata);
 	if (chip->hw_ip_version > SOF_INTEL_ACE_2_0) {
 		dsppwrctl = PTL_HFPWRCTL2;
-- 
2.53.0

