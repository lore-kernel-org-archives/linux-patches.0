Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B684E084E;
	Mon, 31 Aug 2026 13:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183583; cv=none; b=kMfMs0acl6o2zYrdYgK4BnhaAi0letVs3hlZhDGBQ+sT0T8aPH0CyTdnYctfvqRJmCJkjbZOJrvLsDZEJa+V5hAVqKOgFGqEeobtwUZBAYgE2OPQahDhuAHAErQJqJEEwrSva53oitK5M/FutnUsUdaH3n5UL5MmV1wEkpSn3cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183583; c=relaxed/simple;
	bh=dMwVcp8FBXhsGODO6KrlNhYd9dc9H1SiUP76wGM67Yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VivHM86B8f6hW7S+dWjr3Rnp6ld0d+k2Zow21rGImHEAWXAyQp2SU3mXK8AFy2pktCGpayG6OOwObyFdR02Hms9nzHc5CnX+YVVDnC1YWXBCc5LHwi+xLtq1ekQqt0IypyXF1bwfId+rhTHWMEaA4m1w5ighH47oxTeLi+YEHeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iJn0GRdQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iJn0GRdQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0FB1F00A3E;
	Mon, 31 Aug 2026 13:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183580;
	bh=HoB4g/rt9CqwjhhLJydbZlhFZuVjpMaZ8oMy9xa3FGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iJn0GRdQ/0pnDM/B63J/+VLi0rDX4dH0H+pIJvRYRI1oY9QyNmxfXPlxSNz9RPb5s
	 jllJRqrADRwmtm75f/7sIlrGtZ50752zIikT6K+ad1YbW/jdVeOCsJrHqQgnrqrSYV
	 ImQPCUHvG64veA2qMxvzT8WG9ku8Mqkh6vVZYaAkTqGVyhwxapSqOc+6R1pwxMsRNL
	 kV9uBP0IBLuZwsL+VrJCBqUg3UXZHce14Aj+Rl3xsuq3G9Y05m8EGlubd6DPQPhcS0
	 lhl2arWjFtAEwv6lKQxyxB/x3aA34rBz2Q4TRnW0DbqgTVhLeqA91E0mXvCuGw09J3
	 tArUGGs0T0maw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	lgirdwood@gmail.com,
	daniel.baluta@nxp.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sound-open-firmware@alsa-project.org
Subject: [PATCH AUTOSEL 6.18] ASoC/soundwire: Intel: reset the PCMSyCM registers in hda_sdw_bpt_close
Date: Mon, 31 Aug 2026 09:23:28 -0400
Message-ID: <20260831133314.4125787-180-sashal@kernel.org>
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

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 992eb0dfbc4f594d60ae57974efa835bfac34d1e ]

Resetting the PCMSyCM registers is required for Intel SoundWire stream. The
same procedure is done in sdw_hda_dai_hw_params() for the normal
SoundWire stream, too.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Acked-by: Vinod Koul <vkoul@kernel.org>
Link: https://patch.msgid.link/20260730012518.2180906-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: Reset PCMSyCM Registers in
`hda_sdw_bpt_close`

**Local tree:** `v6.18.44` (6.18.y stable)
**Commit under review:** `992eb0dfbc4f5` — *ASoC/soundwire: Intel: reset
the PCMSyCM registers in hda_sdw_bpt_close*
**Status in this tree:** Not present (on `master` only)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[ASoC/soundwire: Intel]` `[reset]` — Reset PCMSyCM
registers during BPT stream close to match the open/setup path.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Bard Liao, Mark Brown (ignore pipeline-added SOBs)
- **Reviewed-by:** Péter Ujfalusi, Liam Girdwood, Pierre-Louis Bossart
- **Acked-by:** Vinod Koul (SoundWire maintainer)
- **Link:** https://patch.msgid.link/20260730012518.2180906-1-yung-
  chuan.liao@linux.intel.com
- **No** Fixes:, Reported-by:, Tested-by:, Cc: stable@vger.kernel.org
- Notable: Three Intel audio maintainers reviewed; SoundWire maintainer
  Acked.

### Step 1.3: Body Analysis
**Record:**
- **Bug:** `hda_sdw_bpt_close()` deprepared DMA buffers but did not
  reset PCMSyCM hardware registers programmed during
  `hda_sdw_bpt_open()`.
- **Symptom:** Not explicitly stated (no crash trace or user report),
  but stale PCMSyCM state can interfere with subsequent SoundWire audio
  streams on the same link.
- **Root cause:** Asymmetric open/close — open programs PCMSyCM via
  `hdac_bus_eml_sdw_map_stream_ch()`, close omitted the inverse reset.
- **Reference pattern:** Commit message cites `sdw_hda_dai_hw_params()`;
  the actual reset pattern lives in `sdw_hda_dai_hw_free()` (commit
  message typo, not a code issue).

### Step 1.4: Hidden Bug Fix?
**Record:** Yes. Despite the neutral "reset" wording, this is a real
hardware cleanup bug — missing register teardown on a production code
path, not cosmetic cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
| File | Change |
|------|--------|
| `sound/soc/sof/intel/hda-sdw-bpt.c` | +24 lines (core fix) |
| `drivers/soundwire/intel_ace2x.c` | +3 lines (pass `link_id`) |
| `include/sound/hda-sdw-bpt.h` | +2 lines (API signature) |

**Functions modified:** `hda_sdw_bpt_close()`, `hda_sdw_bpt_open()`
(error path), `intel_ace2x_bpt_open_stream()`,
`intel_ace2x_bpt_close_stream()`
**Scope:** Single-subsystem, surgical fix across 3 files.

### Step 2.2: Code Flow Change
**Record:**
- **Hunk 1 (`hda_sdw_bpt_close`):** Before: only DMA deprepare. After:
  reset PDI0 (playback) and PDI1 (capture) PCMSyCM registers via
  `hdac_bus_eml_sdw_map_stream_ch(..., 0, 0, stream)`, then deprepare
  DMA regardless of reset errors.
- **Hunk 2 (API):** Adds `int link_id` parameter to
  `hda_sdw_bpt_close()` to identify the SoundWire sublink.
- **Hunk 3 (callers):** `intel_ace2x.c` passes `sdw->instance`;
  `hda_sdw_bpt_open()` error path passes existing `link_id`.

### Step 2.3: Bug Mechanism
**Record:** **Category (g) — logic/correctness / hardware state
cleanup.**
`hda_sdw_bpt_open()` programs PCMSyCM for PDI0 and PDI1. Without reset
on close, hardware retains stale channel/stream mappings. The normal
SoundWire path already resets in `sdw_hda_dai_hw_free()`:

```631:638:sound/soc/sof/intel/hda-dai.c
        /* in the case of SoundWire we need to reset the PCMSyCM
registers */
        ret = hdac_bus_eml_sdw_map_stream_ch(sof_to_bus(sdev), link_id,
cpu_dai->id,
                                             0, 0, substream->stream);
```

The fix applies the same reset pattern to the BPT path.

### Step 2.4: Fix Quality
**Record:** Obviously correct — mirrors established
`sdw_hda_dai_hw_free()` behavior. Minimal, symmetric with `_open()`.
Pierre-Louis Bossart confirmed: *"LGTM, this patch makes the _close()
sequence and api mimic the _open() one."* Low regression risk; continues
DMA cleanup even if register reset fails.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `hda_sdw_bpt_close()` introduced in `5d5cb86fb46ea`
(2025-02-27, "add helpers for SoundWire BPT DMA") without PCMSyCM reset.
Present since **v6.15**, including this tree at v6.18.44.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related File History
**Record:** Recent related commits in this tree:
- `67d0475e78b39` — release bpt_stream when close
- `8b184c34806e5` — set persistent_buffer false
- `5d5cb86fb46ea` — initial BPT helpers

Standalone single-patch series (v1 only). No prerequisite commits
required.

### Step 3.4: Author Context
**Record:** Bard Liao is a regular Intel SoundWire/SOF contributor.
Related commits in this subsystem include BPT CHAIN_DMA support and
stream lifecycle fixes.

### Step 3.5: Dependencies
**Record:** No dependencies. Uses `hdac_bus_eml_sdw_map_stream_ch()`
(present since 2023, `ccc2f0c1b6b61`) and `sdw->instance` (already used
in `hda_sdw_bpt_open()` at line 167 of `intel_ace2x.c`). Applies
standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:**
- **URL:** https://patch.msgid.link/20260730012518.2180906-1-yung-
  chuan.liao@linux.intel.com
- **Series:** v1 only (no revisions)
- **Key feedback:** Vinod Koul Acked; Pierre-Louis Bossart Reviewed with
  LGTM
- **No** stable nomination, NAKs, or explicit failure reports in thread

### Step 4.2: Reviewers
**Record:** CC'd: linux-sound, broonie, tiwai, vkoul, pierre-
louis.bossart, peter.ujfalusi — appropriate subsystem maintainers and
Intel audio team.

### Step 4.3: Bug Reports
**Record:** No Reported-by:, syzbot, or bugzilla links. Impact inferred
from code analysis and established PCMSyCM reset requirement.

### Step 4.4: Related Patches
**Record:** Related stable-nominated PCMSyCM fix: `6e38a7e098d32`
("Handle prepare without close for non-HDA DAI's") included `Cc:
stable@vger.kernel.org # 6.10.x 6.11.x` for SDW PCMSyCM reset on
prepare-after-drain. Same subsystem, same register family.

### Step 4.5: Stable List History
**Record:** No stable-list discussion found for this specific patch. Not
a negative signal.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `hda_sdw_bpt_close()`, `intel_ace2x_bpt_close_stream()`,
`intel_ace2x_bpt_open_stream()`, `hdac_bus_eml_sdw_map_stream_ch()`

### Step 5.2: Callers
**Record:**
- `intel_ace2x_bpt_close_stream()` — called from BPT error paths and
  after `intel_ace2x_bpt_wait()` completes
- `hda_sdw_bpt_close()` — called from `intel_ace2x_bpt_open_stream()`
  error path and `hda_sdw_bpt_open()` error path
- BPT entry: `sdw_bpt_send_async()` / `sdw_bpt_wait()` in `bus.c` →
  Intel `hw_ops` → `intel_ace2x_bpt_*`
- Used for SoundWire register access (BRA/BPT), codec driver operations,
  and debugfs BPT interface

### Step 5.3: Callees
**Record:** `hdac_bus_eml_sdw_map_stream_ch()` programs/resets PCMSyCM
shim registers; `hda_sdw_bpt_dma_deprepare()` tears down DMA.

### Step 5.4: Reachability
**Record:** Triggered during SoundWire BPT transfers on Intel ACE2.x
platforms with `CONFIG_SND_SOF_SOF_HDA_SDW_BPT` (auto-selected for Intel
LNL+ with SoundWire). Reachable from kernel driver/codec operations and
debugfs — not a dead path.

### Step 5.5: Similar Patterns
**Record:** `sdw_hda_dai_hw_free()` uses identical reset
(`channel_mask=0, stream_id=0`). Open side in `hda_sdw_bpt_open()`
already programs PCMSyCM at lines 277–292. Fix completes the symmetry.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy Code Exists?
**Record:** **Yes.** `hda_sdw_bpt_close()` in v6.18.44 only deprepares
DMA (lines 425–438 of `hda-sdw-bpt.c`). Bug present since v6.15
(`5d5cb86fb46ea`), well before 6.18 branched.

### Step 6.2: Backport Complications
**Record:** `.c` files apply cleanly (`git apply --check` passes).
Header file fails automated apply because master added
`hda_sdw_bpt_get_buf_size_alignment()` after `hda_sdw_bpt_close()` —
that function is **not** in v6.18.44. The signature change itself is
trivial and needs only dropping that extra context line. **Minor manual
adjustment**, not a rework.

### Step 6.3: Related Fixes Already Present?
**Record:** No equivalent PCMSyCM reset in BPT close path. Other BPT
fixes present (`67d0475e78b39`, `8b184c34806e5`) address different
issues.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** **sound/ASoC/SOF/Intel SoundWire** — IMPORTANT. Affects
audio on modern Intel laptops (Meteor Lake, Lunar Lake, Panther Lake)
with SoundWire codecs.

### Step 7.2: Subsystem Activity
**Record:** Actively developed — BPT support added in 6.15, multiple
follow-up fixes through 6.18.y.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Users of Intel SOF + SoundWire platforms with BPT enabled
(`CONFIG_SND_SOF_SOF_HDA_SDW_BPT`). Growing population of modern Intel
laptops.

### Step 8.2: Trigger Conditions
**Record:** Any BPT transfer on a SoundWire link (register access, codec
configuration, debugfs BPT operations) followed by normal audio use on
the same link. Not timing-dependent; deterministic stale hardware state.

### Step 8.3: Failure Mode Severity
**Record:** Stale PCMSyCM mappings can cause subsequent audio stream
setup/playback failures on the affected link. **Severity: MEDIUM-HIGH**
for affected hardware — functional audio breakage, not kernel
crash/oops/corruption.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Prevents audio malfunction after BPT operations;
  completes missing hardware cleanup
- **Risk:** Very low — ~30 lines, mirrors proven pattern, well-reviewed
- **Ratio:** Clear benefit outweighs minimal risk

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real bug: missing PCMSyCM register reset on BPT close
- Bug present in v6.18.44 since BPT introduction (v6.15)
- Mirrors `sdw_hda_dai_hw_free()` — same reset already deemed stable-
  worthy in related commit
- Small, surgical, obviously correct
- Reviewed by 3 maintainers + Acked by SoundWire maintainer
- Can break audio on production Intel SoundWire hardware

**AGAINST backport:**
- No explicit user crash report or syzbot finding
- Commit message doesn't describe concrete failure symptoms
- Header needs trivial manual adjustment for 6.18.y apply

**Unresolved:** No documented user-facing failure report; impact
inferred from code analysis and hardware register semantics.

### Step 9.2: Stable Rules Checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — mirrors existing
pattern; maintainer-reviewed |
| 2. Fixes real bug? | **PASS** — missing hardware register cleanup |
| 3. Important issue? | **PASS** — audio failure on affected Intel
hardware |
| 4. Small and contained? | **PASS** — ~30 lines, 3 files |
| 5. No new features/APIs? | **PASS** — extends existing close with
required cleanup; signature change is internal |
| 6. Can apply to local tree? | **PASS** — clean apply on .c files;
trivial header tweak |

### Step 9.3: Exception Categories
**Record:** N/A — standard bug fix, not device ID/quirk/DT/build/doc
exception.

### Step 9.4: Decision Rationale

This commit fixes a genuine omission in the SoundWire BPT teardown path.
Since BPT was introduced in v6.15, `hda_sdw_bpt_open()` has programmed
PCMSyCM registers while `hda_sdw_bpt_close()` left them programmed —
unlike the normal SoundWire audio path, which explicitly resets them in
`sdw_hda_dai_hw_free()`. On Intel SOF + SoundWire laptops, BPT
operations (register access, codec configuration) are followed by normal
audio use; stale PCMSyCM state can cause audio failures on that link.

The fix is small, mirrors an established and previously stable-nominated
pattern, and is endorsed by the SoundWire maintainer and Intel audio
team. The missing user report is outweighed by the clear hardware
semantics and code asymmetry.

---

## Verification

- **[Phase 1]** `git show 992eb0dfbc4f5`: parsed full commit message and
  all tags
- **[Phase 1]** Read `sdw_hda_dai_hw_free()` at lines 631–638 of `hda-
  dai.c`: confirmed PCMSyCM reset pattern; commit message references
  wrong function name (`hw_params` vs `hw_free`)
- **[Phase 2]** Diff analysis: 3 files, ~30 net lines; core fix adds two
  `hdac_bus_eml_sdw_map_stream_ch()` calls with `(0, 0)` reset
- **[Phase 3]** `git describe HEAD`: v6.18.44; `make kernelversion`:
  6.18.44
- **[Phase 3]** `git blame` on `hda_sdw_bpt_close()`: introduced
  `5d5cb86fb46ea` (2025-02-27)
- **[Phase 3]** `git merge-base --is-ancestor 5d5cb86fb46ea v6.18.44`:
  BPT code present in this tree
- **[Phase 3]** `git merge-base --is-ancestor 992eb0dfbc4f5 HEAD`:
  commit NOT in current tree
- **[Phase 3]** `git tag --contains 5d5cb86fb46ea`: first in v6.15
- **[Phase 3]** `git log --oneline -20` on affected files: no duplicate
  fix found
- **[Phase 4]** `b4 dig -c 992eb0dfbc4f5`: found thread at
  patch.msgid.link URL
- **[Phase 4]** `b4 dig -c 992eb0dfbc4f5 -w`: Vinod Koul, broonie,
  vkoul, pierre-louis.bossart CC'd
- **[Phase 4]** `b4 dig -c 992eb0dfbc4f5 -a`: single v1 patch, no
  revisions
- **[Phase 4]** `/tmp/bpt_thread.mbox`: Vinod Koul Acked; Pierre-Louis
  Bossart LGTM; no stable nomination or NAKs
- **[Phase 4]** WebFetch of patch URL: blocked by bot protection; used
  mbox instead
- **[Phase 5]** `grep hdac_bus_eml_sdw_map_stream_ch`: present in `hda-
  mlink.c`, used in `hda-dai.c` and `hda-sdw-bpt.c`
- **[Phase 5]** `grep bpt_` call chain: `bus.c` → `intel_ace2x.c` →
  `hda_sdw_bpt_close()`
- **[Phase 5]** `grep sdw->instance` in `intel_ace2x.c`: already used in
  `hda_sdw_bpt_open()` at line 167
- **[Phase 6]** Read current `hda_sdw_bpt_close()` at lines 425–438:
  confirms buggy code (no PCMSyCM reset)
- **[Phase 6]** `git show 992eb0dfbc4f5 -- sound/soc/sof/intel/hda-sdw-
  bpt.c drivers/soundwire/intel_ace2x.c | git apply --check`: **passes**
- **[Phase 6]** `git show 992eb0dfbc4f5 -- include/sound/hda-sdw-bpt.h |
  git apply --check`: **fails** — master has
  `hda_sdw_bpt_get_buf_size_alignment()` not in v6.18.44; trivial manual
  fix
- **[Phase 6]** `git diff v6.18.44 master -- include/sound/hda-sdw-
  bpt.h`: confirmed divergence
- **[Phase 7]** `grep CONFIG_SND_SOF_SOF_HDA_SDW_BPT` in Kconfig:
  present, auto-selected for Intel LNL+
- **[Phase 8]** Failure mode assessed from PCMSyCM register semantics
  and parallel `sdw_hda_dai_hw_free()` behavior

**YES**Those background git searches finished successfully and match
what the analysis already used:

- **BPT introduction:** SoundWire BPT support landed with
  `5d5cb86fb46ea` ("add helpers for SoundWire BPT DMA"), first appearing
  in **v6.15** and present in your **v6.18.44** tree.
- **PCMSyCM history:** The register helper dates to `ccc2f0c1b6b61`
  (2023); the normal SoundWire reset path is in `sdw_hda_dai_hw_free()`,
  and a related stable-nominated fix is `6e38a7e098d32`.

That confirms the bug has been in the BPT close path since BPT was
added, and the backport recommendation remains **YES**.

 drivers/soundwire/intel_ace2x.c   |  4 +++-
 include/sound/hda-sdw-bpt.h       |  5 +++--
 sound/soc/sof/intel/hda-sdw-bpt.c | 31 ++++++++++++++++++++++++++++---
 3 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/drivers/soundwire/intel_ace2x.c b/drivers/soundwire/intel_ace2x.c
index f0e0a79b30b0e..c1ea420bc11ff 100644
--- a/drivers/soundwire/intel_ace2x.c
+++ b/drivers/soundwire/intel_ace2x.c
@@ -192,6 +192,7 @@ static int intel_ace2x_bpt_open_stream(struct sdw_intel *sdw, struct sdw_slave *
 		__func__, str_read_write(command), ret);
 
 	ret1 = hda_sdw_bpt_close(cdns->dev->parent, /* PCI device */
+				 sdw->instance,
 				 sdw->bpt_ctx.bpt_tx_stream, &sdw->bpt_ctx.dmab_tx_bdl,
 				 sdw->bpt_ctx.bpt_rx_stream, &sdw->bpt_ctx.dmab_rx_bdl);
 	if (ret1 < 0)
@@ -226,7 +227,8 @@ static void intel_ace2x_bpt_close_stream(struct sdw_intel *sdw, struct sdw_slave
 	struct sdw_cdns *cdns = &sdw->cdns;
 	int ret;
 
-	ret = hda_sdw_bpt_close(cdns->dev->parent /* PCI device */, sdw->bpt_ctx.bpt_tx_stream,
+	ret = hda_sdw_bpt_close(cdns->dev->parent /* PCI device */, sdw->instance,
+				sdw->bpt_ctx.bpt_tx_stream,
 				&sdw->bpt_ctx.dmab_tx_bdl, sdw->bpt_ctx.bpt_rx_stream,
 				&sdw->bpt_ctx.dmab_rx_bdl);
 	if (ret < 0)
diff --git a/include/sound/hda-sdw-bpt.h b/include/sound/hda-sdw-bpt.h
index f649549b75d52..330cda50f100c 100644
--- a/include/sound/hda-sdw-bpt.h
+++ b/include/sound/hda-sdw-bpt.h
@@ -27,7 +27,7 @@ int hda_sdw_bpt_send_async(struct device *dev, struct hdac_ext_stream *bpt_tx_st
 int hda_sdw_bpt_wait(struct device *dev, struct hdac_ext_stream *bpt_tx_stream,
 		     struct hdac_ext_stream *bpt_rx_stream);
 
-int hda_sdw_bpt_close(struct device *dev, struct hdac_ext_stream *bpt_tx_stream,
+int hda_sdw_bpt_close(struct device *dev, int link_id, struct hdac_ext_stream *bpt_tx_stream,
 		      struct snd_dma_buffer *dmab_tx_bdl, struct hdac_ext_stream *bpt_rx_stream,
 		      struct snd_dma_buffer *dmab_rx_bdl);
 #else
@@ -56,7 +56,8 @@ static inline int hda_sdw_bpt_wait(struct device *dev, struct hdac_ext_stream *b
 	return -EOPNOTSUPP;
 }
 
-static inline int hda_sdw_bpt_close(struct device *dev, struct hdac_ext_stream *bpt_tx_stream,
+static inline int hda_sdw_bpt_close(struct device *dev, int link_id,
+				    struct hdac_ext_stream *bpt_tx_stream,
 				    struct snd_dma_buffer *dmab_tx_bdl,
 				    struct hdac_ext_stream *bpt_rx_stream,
 				    struct snd_dma_buffer *dmab_rx_bdl)
diff --git a/sound/soc/sof/intel/hda-sdw-bpt.c b/sound/soc/sof/intel/hda-sdw-bpt.c
index ff5abccf0d88b..4e5c99413c750 100644
--- a/sound/soc/sof/intel/hda-sdw-bpt.c
+++ b/sound/soc/sof/intel/hda-sdw-bpt.c
@@ -297,7 +297,8 @@ int hda_sdw_bpt_open(struct device *dev, int link_id, struct hdac_ext_stream **b
 		__func__, ret);
 
 close:
-	ret1 = hda_sdw_bpt_close(dev, *bpt_tx_stream, dmab_tx_bdl, *bpt_rx_stream, dmab_rx_bdl);
+	ret1 = hda_sdw_bpt_close(dev, link_id, *bpt_tx_stream, dmab_tx_bdl,
+				 *bpt_rx_stream, dmab_rx_bdl);
 	if (ret1 < 0)
 		dev_err(dev, "%s: hda_sdw_bpt_close failed: %d\n",
 			__func__, ret1);
@@ -422,14 +423,38 @@ int hda_sdw_bpt_wait(struct device *dev, struct hdac_ext_stream *bpt_tx_stream,
 }
 EXPORT_SYMBOL_NS(hda_sdw_bpt_wait, "SND_SOC_SOF_INTEL_HDA_SDW_BPT");
 
-int hda_sdw_bpt_close(struct device *dev, struct hdac_ext_stream *bpt_tx_stream,
+int hda_sdw_bpt_close(struct device *dev, int link_id, struct hdac_ext_stream *bpt_tx_stream,
 		      struct snd_dma_buffer *dmab_tx_bdl, struct hdac_ext_stream *bpt_rx_stream,
 		      struct snd_dma_buffer *dmab_rx_bdl)
 {
+	struct snd_sof_dev *sdev = dev_get_drvdata(dev);
 	int ret;
 	int ret1;
 
-	ret = hda_sdw_bpt_dma_deprepare(dev, bpt_rx_stream, dmab_rx_bdl);
+	/*
+	 * In the case of SoundWire we need to reset the PCMSyCM registers.
+	 * Need to continue depreparing the DMA buffers even if this fails.
+	 */
+	ret = hdac_bus_eml_sdw_map_stream_ch(sof_to_bus(sdev), link_id,
+					     0, /* PDI0 */
+					     0, 0, SNDRV_PCM_STREAM_PLAYBACK);
+	if (ret < 0)
+		dev_err(dev, "%s: hdac_bus_eml_sdw_map_stream_ch failed %d for PDI0\n",
+			__func__, ret);
+
+	ret1 = hdac_bus_eml_sdw_map_stream_ch(sof_to_bus(sdev), link_id,
+					      1, /* PDI1 */
+					      0, 0, SNDRV_PCM_STREAM_CAPTURE);
+	if (ret1 < 0) {
+		dev_err(dev, "%s: hdac_bus_eml_sdw_map_stream_ch failed %d for PDI1\n",
+			__func__, ret1);
+		if (!ret)
+			ret = ret1;
+	}
+
+	ret1 = hda_sdw_bpt_dma_deprepare(dev, bpt_rx_stream, dmab_rx_bdl);
+	if (!ret)
+		ret = ret1;
 
 	ret1 = hda_sdw_bpt_dma_deprepare(dev, bpt_tx_stream, dmab_tx_bdl);
 	if (!ret)
-- 
2.53.0

