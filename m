Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8B0559CB6;
	Mon, 31 Aug 2026 13:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184040; cv=none; b=M7sGVhXWNgN2hZFkrWm5hvPaLemIWFq/+iT62KjNio4BBYBmSxkkDECniC1uNBODiU2u9wu6O6FIH4EJAquBInyYCXe31FPmaRTExyiE1U+f9pFsINMxvTWYsJwGXy6nXYjBeQnrW4Jbl4IMB23YX0gFeK62xIQAhXsi1DTWfbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184040; c=relaxed/simple;
	bh=agQdFWgGdxOk9QtCWPcZkyFXsru8JE2Gu6KW/lltHts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G8KJaj5/ipjipTzmff5OHa5zpkfKm2cnxPdBLz7/yA/cHZXjB6h2ZOOvp7HNihty/LJlf/k213QJhyMU1pm0xqXQ1DnRQu80Zfm4BUHh6qAHBqsvXDfffrnYptciCIiNY7CvVCNcPHoyd/hqvywhnFLKxAbEtg1C/RBYMZNI6gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dumFuYa6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dumFuYa6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646DB1F00A3D;
	Mon, 31 Aug 2026 13:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184036;
	bh=bDCAWpER37datQHefj9rAvTXlYrx134DmbFTqr6CzU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dumFuYa6yDYRmeLQKdvjFHAo54QMmopuR1/vyJkBNZt7KTlb37MX3k38fylHTuB9e
	 ZBQ0vOr48p2+Y6jFhaNBmLNUWcYksV8s7wqVTRYKbSEeQ1jiwYnXVHwa+mJF4loD7U
	 YJRS8jlLhet6g7SUFC5k2JY0tiPwISrr+kbbnycAmBiF1UEPerKZrp5KOmGZOteeoE
	 DFmNM7UoigY46YIxEZCxsQuc+fGfPseSxedpQvrYmSlw95YVvanuwBJhhD58S1v7KE
	 yx9rP1mVH/HybE3i9Gyg55uUjqW/eLhyhabrJWsgOlsHiE8MIta8UAD7N2jGly4Xg/
	 IBKVdn0uXvAhA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Baojun Xu <baojun.xu@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ASoC: sdw_utils: Add missed component_name strings for TI amps
Date: Mon, 31 Aug 2026 09:28:01 -0400
Message-ID: <20260831133314.4125787-453-sashal@kernel.org>
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

From: Baojun Xu <baojun.xu@ti.com>

[ Upstream commit 79bec463819428912e1cfcb534e4379093b422ce ]

Added component_name for UCM.

Signed-off-by: Baojun Xu <baojun.xu@ti.com>
Link: https://patch.msgid.link/20260611125359.19839-1-baojun.xu@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ASoC: sdw_utils: Add missed component_name
strings for TI amps

**Local tree:** `v6.18.44` (`git describe HEAD` →
`v6.18.44-1-g2736c32da98b9`, `make kernelversion` → `6.18.44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[ASoC: sdw_utils]` `[Add]` — add missing `component_name`
string for TI TAS2783A speaker amp in the SoundWire utils codec table.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Baojun Xu `<baojun.xu@ti.com>` (author)
- **Signed-off-by:** Mark Brown `<broonie@kernel.org>` (ASoC maintainer
  merge)
- **Link:**
  https://patch.msgid.link/20260611125359.19839-1-baojun.xu@ti.com
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable tags
- Notable: very minimal message; no explicit bug report or syzbot
  involvement

### Step 1.3: Body analysis
**Record:**
- **Bug described:** Omission of `component_name` for the TAS2783A amp
  entry; body says only “Added component_name for UCM.”
- **Symptom/failure mode:** `card->components` will not include
  `spk:tas2783`, so ALSA Use Case Manager (UCM) cannot match the correct
  profile on TAS2783A platforms.
- **Version info:** None in the message.
- **Root cause (from code context):** TAS2783A was added to
  `codec_info_list[]` in `b41949a2109e4` without `component_name`, while
  the centralized `asoc_sdw_rtd_init()` path (since `0f60ecffbfe35`)
  depends on that field to build the `spk:` component string.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Despite the “Add” wording, this is a functional bug fix
— an incomplete integration of TAS2783A into the UCM component-string
mechanism, identical in nature to `c61da55412a08` (“Add missed
component_name strings for speaker amps”).

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `sound/soc/sdw_utils/soc_sdw_utils.c` (+1 line)
- **Functions modified:** `codec_info_list[]` static data only (no
  function body changes)
- **Scope:** Single-file, single-line surgical fix

### Step 2.2: Code flow change
**Record:**
- **Before:** TAS2783A AMP DAI entry has `dai_name = "tas2783-codec"`
  but `component_name` is NULL.
- **After:** `component_name = "tas2783"` is set.
- **Affected path:** During `asoc_sdw_rtd_init()` (called from Intel/AMD
  SOF SoundWire machine drivers at card init), when processing an AMP
  DAI with `component_name` set, the code appends to `spk_components`
  and ultimately sets `card->components` to include `spk:tas2783` (or
  `spk:tas2783+tas2783` for dual-amp configs).

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic / correctness fix (missing metadata for UCM)
- **Mechanism:** `asoc_sdw_rtd_init()` at lines 843–868 only generates
  the `spk:` string when `component_name` is non-NULL.
  `asoc_sdw_ti_spk_rtd_init()` does not set `card->components` itself
  (unlike cs42l43, which has a dedicated `rtd_init`). Without this
  field, speaker component tagging is silently skipped for TAS2783A.

### Step 2.4: Fix quality
**Record:**
- Obviously correct: matches every other AMP entry (`rt1308`, `rt1316`,
  `mx8373`, `cs35l56`, etc.).
- Minimal: one line, no behavior change for other codecs.
- Regression risk: very low; only adds a string that was always intended
  to be present.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- TAS2783A entry introduced by `b41949a2109e4` (Niranjan H Y,
  2025-09-12) — present in `v6.18` release.
- `component_name` infrastructure added by `f792733e08d5f` (2025-06-25).
- Prior omission fix `c61da55412a08` (2025-07-09) added `component_name`
  for other amps and was Cc’d to stable.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag in this commit. Related prior fix
`c61da55412a08` has `Fixes: f792733e08d5f` and is already in this tree.

### Step 3.3: Related file history
**Record:**
- `0f60ecffbfe35`: centralized `spk:` string generation in
  `asoc_sdw_rtd_init()`
- `c61da55412a08`: fixed same omission for
  rt1308/rt1316/rt1318/rt721/cs42l43
- `b41949a2109e4`: added TAS2783A without `component_name` (the gap this
  patch closes)
- `45f5c9eec43a9`: removed cs42l43 `component_name` because cs42l43 sets
  it conditionally in its own `rtd_init` — tas2783 does not have that
  alternative path
- Standalone patch (not part of a series)

### Step 3.4: Author context
**Record:** Baojun Xu is a regular TI codec contributor (tas2781/tas2783
work). Mark Brown merged. No subsystem-maintainer authorship, but TI
hardware vendor fix.

### Step 3.5: Dependencies
**Record:** No dependencies. Requires only code already in this tree:
- `component_name` field in `asoc_sdw_dai_info` ✓
- TAS2783A in `codec_info_list[]` ✓
- `asoc_sdw_rtd_init()` spk string logic ✓
- Applies cleanly (one line after `.dai_name = "tas2783-codec",` at line
  66)

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **URL:**
  https://patch.msgid.link/20260611125359.19839-1-baojun.xu@ti.com
- **Series revisions:** v1 only (b4 am found 1 patch, 2 messages total —
  patch + no substantive review thread)
- **Reviewer feedback:** None found in thread
- **Stable nominations:** None in thread
- **NAKs/concerns:** None

### Step 4.2: Reviewers
**Record:** b4 am shows only author SOB and DKIM attestation; Mark
Brown’s merge SOB is in the commit message but no Reviewed-by in the
mailing list thread.

### Step 4.3: Bug report
**Record:** No external bug report, syzbot link, or user Reported-by.
Impact inferred from prior commit `c61da55412a08` and UCM design
(`0f60ecffbfe35` commit message: UCM expects `spk:rt722+rt1320` style
strings).

### Step 4.4: Related patches
**Record:** Direct precedent: `c61da55412a08` — same bug class,
explicitly Cc’d stable, already in this tree.

### Step 4.5: Stable list history
**Record:** Not searched separately; prior identical fix was explicitly
nominated for stable by Intel maintainer.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** Data change in `codec_info_list[]`; runtime effect in
`asoc_sdw_rtd_init()` (line 784).

### Step 5.2: Callers
**Record:** `asoc_sdw_rtd_init()` called from:
- `sound/soc/intel/boards/sof_sdw.c` (Intel SOF SoundWire — primary path
  for MTL+TAS2783)
- `sound/soc/amd/acp/acp-sdw-sof-mach.c`
- `sound/soc/amd/acp/acp-sdw-legacy-mach.c`

### Step 5.3: Callees
**Record:** `asoc_sdw_rtd_init()` calls per-codec `rtd_init` callbacks,
then checks `component_name` for AMP DAIs and builds `card->components`
via `devm_kasprintf()`.

### Step 5.4: Reachability
**Record:** Triggered at sound card initialization on any platform using
TAS2783A via SOF SoundWire machine driver. ACPI match exists in `soc-
acpi-intel-mtl-match.c` (`sof-mtl-tas2783.tplg`). Reachable on every
boot for affected hardware; not userspace-triggerable but affects all
users of that hardware.

### Step 5.5: Similar patterns
**Record:** TAS2783A is the only production AMP entry in
`codec_info_list[]` currently missing `component_name`. All other
speaker amps (rt1308, rt1316, rt1318, rt1320, rt721, rt722, mx8373,
mx8363, cs35l56) have it set.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code exists?
**Record:** Yes. Lines 61–78 of `soc_sdw_utils.c` show TAS2783A entry
without `component_name`. Present since `v6.18` release (`git merge-base
--is-ancestor b41949a2109e4 v6.18` confirmed).

### Step 6.2: Backport complications
**Record:** Clean apply expected — single line insertion. Local tree
structure matches the patch (uses `part_id = 0x0000`, not the
`vendor_id` layout shown in some newer mainline revisions).

### Step 6.3: Related fixes already present?
**Record:** `c61da55412a08` (same fix for other amps) is in tree. This
specific tas2783 line is not yet applied.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** ASoC / SoundWire utils — **IMPORTANT** (affects audio on
Intel MTL laptops with TAS2783A amps, not core kernel).

### Step 7.2: Subsystem activity
**Record:** Actively developed; recent commits include RT712/RT721
quirks, reference leak fix, tas2783 driver updates.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of Intel Meteor Lake (and compatible) platforms with
TAS2783A SoundWire speaker amps — config-specific, platform-specific.
ACPI entry `tas2783_link0` / `sof-mtl-tas2783.tplg` confirmed in tree.

### Step 8.2: Trigger conditions
**Record:** Every boot/init of affected hardware using SOF SoundWire
machine driver. Common for those machines, not timing-dependent.
Unprivileged users cannot trigger directly but inherit broken audio
routing.

### Step 8.3: Failure mode severity
**Record:** Missing `spk:tas2783` in `card->components` → UCM profile
mismatch → speakers may not route correctly or UCM may select wrong
configuration. **Severity: MEDIUM** (functional audio breakage, not
crash/corruption/security).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** MEDIUM — fixes real speaker/UCM integration for hardware
  supported in this tree
- **Risk:** VERY LOW — one-line data addition, established pattern
- **Ratio:** Favorable; matches precedent of `c61da55412a08` which
  stable maintainers were asked to take

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence compile

**FOR backport:**
- Real functional bug on supported hardware in this tree
- Identical bug class to `c61da55412a08`, which was explicitly Cc’d
  stable
- TAS2783A is the only AMP missing `component_name`; no alternative path
  sets the string
- One-line, obviously correct fix with near-zero regression risk
- All prerequisites present in v6.18.44

**AGAINST backport:**
- Not a crash, security issue, data corruption, or deadlock
- Sparse commit message with no user bug report
- Affects niche/new hardware (MTL + TAS2783A)
- No reviewer stable nomination for this specific patch

**Unresolved:** No user bug report confirming broken speakers in the
field; impact inferred from code path and prior maintainer statements.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — mirrors all other AMP
   entries; maintainer merged; no logic change
2. Fixes a real bug affecting users? **PASS** — omission breaks UCM
   `spk:` tagging for TAS2783A
3. Important issue? **PASS (borderline)** — functional audio breakage on
   supported platforms; not crash-level but same class as prior stable-
   nominated fix
4. Small and contained? **PASS** — 1 line, 1 file
5. No new features or APIs? **PASS** — completes existing metadata, no
   new API
6. Can apply to local tree? **PASS** — prerequisites present, clean
   apply

### Step 9.3: Exception categories
**Record:** Hardware quirk/workaround adjacent — completes hardware
enablement metadata for an existing driver, similar to device-ID-class
fixes. Not a pure device-ID addition, but same stability rationale.

### Step 9.4: Decision rationale

This commit fixes an integration omission introduced when TAS2783A
support landed in `b41949a2109e4`. Without `component_name`, the
centralized `asoc_sdw_rtd_init()` path never emits `spk:tas2783` in
`card->components`, breaking UCM profile matching for Intel MTL
platforms using `sof-mtl-tas2783.tplg`. The fix is trivial, follows
established precedent (`c61da55412a08`), and all required infrastructure
exists in v6.18.44. While not a crash fix, it corrects broken speaker
routing on real hardware that this stable tree already supports.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message and
  mbox
- [Phase 1] `b4 am 20260611125359.19839-1-baojun.xu@ti.com`: found v1
  patch, 1 insertion, Link confirmed
- [Phase 2] Read `soc_sdw_utils.c` lines 60–78, 843–868: confirmed
  missing `component_name` and generation logic
- [Phase 2] Read `soc_sdw_ti_amp.c`: confirmed
  `asoc_sdw_ti_spk_rtd_init()` does NOT set `card->components`
- [Phase 3] `git describe HEAD`: v6.18.44; `make kernelversion`: 6.18.44
- [Phase 3] `git blame -L 60,78`: tas2783 entry from `b41949a2109e4`
- [Phase 3] `git show c61da55412a08`: prior identical fix, Cc stable
- [Phase 3] `git show f792733e08d5f`, `0f60ecffbfe35`: component_name
  infrastructure and UCM rationale
- [Phase 3] `git show b41949a2109e4`: tas2783 added without
  component_name
- [Phase 3] `git show 45f5c9eec43a9`: cs42l43 exception (has own
  rtd_init path) — does not apply to tas2783
- [Phase 3] `git merge-base --is-ancestor` checks: tas2783 driver,
  machine entry, component_name infra all in HEAD and v6.18
- [Phase 4] Mbox thread: no reviews, no stable nomination, no NAKs
- [Phase 4] WebFetch patch.msgid.link: blocked by bot protection; used
  b4 am mbox instead
- [Phase 5] `grep asoc_sdw_rtd_init`: callers in sof_sdw.c, acp-sdw
  machines
- [Phase 5] `grep SOC_SDW_DAI_TYPE_AMP`: tas2783 is only production AMP
  missing component_name
- [Phase 6] Confirmed buggy code at lines 66–67 in local tree
- [Phase 6] `grep tas2783` in `soc-acpi-intel-mtl-match.c`: MTL platform
  support confirmed
- [Phase 8] Failure mode: UCM mismatch, severity MEDIUM (not CRITICAL)

**YES**

 sound/soc/sdw_utils/soc_sdw_utils.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/sdw_utils/soc_sdw_utils.c b/sound/soc/sdw_utils/soc_sdw_utils.c
index 3facb78748acf..86b0b25bed56a 100644
--- a/sound/soc/sdw_utils/soc_sdw_utils.c
+++ b/sound/soc/sdw_utils/soc_sdw_utils.c
@@ -64,6 +64,7 @@ struct asoc_sdw_codec_info codec_info_list[] = {
 			{
 				.direction = {true, true},
 				.dai_name = "tas2783-codec",
+				.component_name = "tas2783",
 				.dai_type = SOC_SDW_DAI_TYPE_AMP,
 				.dailink = {SOC_SDW_AMP_OUT_DAI_ID, SOC_SDW_AMP_IN_DAI_ID},
 				.init = asoc_sdw_ti_amp_init,
-- 
2.53.0

