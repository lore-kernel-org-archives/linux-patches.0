Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5911F584969;
	Mon, 31 Aug 2026 13:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184207; cv=none; b=YqqTpB2P2vWs/BalrtbDcZCKP4YbILD5E4ItKm9u1Er9ojWq1KdxWlnign8OuGLgeVksEIrn/4znf6fuajjranASXXmFVFL8gtQDAMaOaX2eNvQgPSA33sYFd3Otd/HBDkPpoSoCxNMM9wzPs03v2fo1exAzkgw4ToXYUzD0HTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184207; c=relaxed/simple;
	bh=EYa5kmTKvYPq41gckRjFMx6rgMH6RsrXTlj2ABk4Foc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IspLCX2ooloMRkJkSjaAb07SzI6oz9Sv1r1ZKuSyxkFz1NwHu9KjIVybli3rGUebzHnXF1OG2F0EadTioJS5rpFtEL9D0gX2Dxyj8VzwbGjZA44leSFglDQC/3zTmOnldgs37d/wQpAFZTUWTiMl44TnD8BtL2xlmPwdwiwM5kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DrB3ZmwJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DrB3ZmwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE111F00A3D;
	Mon, 31 Aug 2026 13:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184205;
	bh=YSSAIC0+vhz1ej8Ai6bJkx4R0QMJVVti+nmY/B+phhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DrB3ZmwJsMLpQk0dmQhAeXewc/ub8lqbW4+n/QjH5Zbt2x+xAPbihy8l9GAZCTlKk
	 YWHBZqdTmHZNI9fAbUeSr8p0ZLlk/135uutIb183k/SaPODjl+e8ss0Aq7XRGCZMA0
	 x97iJSp1Qbg8gOKUlf+HtBmIADSEDzDAGJUV5+oG3OrZmGcHdP1Hh3ERWlgRe3Tu1f
	 g7aMoK9YVBXxZSnJ+0vAlgQLZ7/DIjT7NRx7HEI3qg+7LOcSD2tYikxWQRRRzTa91s
	 RgQpxMGLAs8o4d9eTBaWx8FYuPQh509io/MLAn9ulY5OAL1nOiBy7+2NzMbZ/rzWWU
	 njfYWcxcpp3kQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	cezary.rojewski@intel.com,
	liam.r.girdwood@linux.intel.com,
	peter.ujfalusi@linux.intel.com,
	yung-chuan.liao@linux.intel.com,
	kai.vehmanen@linux.intel.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ASoC: Intel: sof_sdw: Add quirks for new Dell laptops
Date: Mon, 31 Aug 2026 09:29:42 -0400
Message-ID: <20260831133314.4125787-554-sashal@kernel.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit efd80de2de9d06ddf0eee55ca11b04e39bfc7cd8 ]

A couple of new Dell laptops are shipping using the sidecar amp
configuration. Add the required kernel quirk to enable.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260716144209.2411523-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ASoC: Intel: sof_sdw: Add quirks for new
Dell laptops

**Local tree:** `v6.18.44-1-g2736c32da98b9` (kernel 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[ASoC: Intel: sof_sdw] [add] [quirks for new Dell laptops
using sidecar amp configuration]`

### Step 1.2: Parse all commit message tags
**Record:**
- **Signed-off-by:** Charles Keepax `<ckeepax@opensource.cirrus.com>`
  (author)
- **Link:** https://patch.msgid.link/20260716144209.2411523-1-
  ckeepax@opensource.cirrus.com
- **Signed-off-by:** Mark Brown `<broonie@kernel.org>` (ASoC maintainer
  merge)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable tags
- Notable: maintainer merge signature; no syzbot or user bug reports

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** New Dell XPS laptops (WCL and PTL platforms) ship with a
  sidecar amplifier audio topology, but the kernel does not recognize
  their PCI subsystem IDs, so the `SOC_SDW_SIDECAR_AMPS` quirk is never
  applied.
- **Symptom:** Without the quirk, sidecar CS35L56 amplifiers are not
  wired into the SoundWire machine driver; speaker audio is broken or
  misconfigured on these machines.
- **Root cause:** Missing `SND_PCI_QUIRK` entries for SSIDs
  `0x1028:0x0e53` (Dell XPS WCL) and `0x1028:0x0e54` (Dell XPS PTL).

### Step 1.4: Detect hidden bug fixes
**Record:** Not disguised — this is an explicit hardware quirk addition.
It fixes a real functional bug (broken audio on shipping hardware), not
cosmetic cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **Files:** `sound/soc/intel/boards/sof_sdw.c` (+2 lines, 0 removed)
- **Functions modified:** None (only `sof_sdw_ssid_quirk_table[]` data)
- **Scope:** Single-file, surgical hardware quirk addition

### Step 2.2: Code flow change
**Record:**
- **Hunk (sof_sdw_ssid_quirk_table):** Before → table had no Dell XPS
  WCL/PTL entries. After → two new `SND_PCI_QUIRK` entries map
  `0x1028:0x0e53` and `0x1028:0x0e54` to `SOC_SDW_SIDECAR_AMPS`.
- **Affected path:** Probe-time SSID lookup in
  `sof_sdw_check_ssid_quirk()` during `sof_sdw_probe()`.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Hardware workaround / quirk
- **Mechanism:** Without `SOC_SDW_SIDECAR_AMPS`, `ctx->mc_quirk` lacks
  the sidecar-amp bit. Downstream code in
  `asoc_sdw_bridge_cs35l56_count_sidecar()` and
  `asoc_sdw_bridge_cs35l56_add_sidecar()` skips adding CS35L56 sidecar
  amplifier DAIs. Speaker routing stays on the default CS42L43-only
  path, which is wrong for these laptops.

### Step 2.4: Fix quality assessment
**Record:** Obviously correct — identical pattern to existing entries
(e.g., Lenovo `0x17aa:0x3821`). Minimal, no logic changes. Regression
risk: very low; only affects machines matching these two PCI SSIDs.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame changed lines
**Record:** `sof_sdw_ssid_quirk_table` introduced in `5d324e5159d9e`
(v6.18 merge base, Nov 2025). Lenovo sidecar quirk `0x17aa:0x3821` added
in `2ca80dd4bb0e2` (Jan 2026, already in this tree). Dell
`0x0e53`/`0x0e54` entries are absent — the fix is not yet present.

### Step 3.2: Follow Fixes: tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: Related file history
**Record:**
- `921903d73967f` — Dell PTL DMI quirk for SKU `0DD6` with
  `SOC_SDW_SIDECAR_AMPS` (already in tree)
- `2ca80dd4bb0e2` — Lenovo SSID quirk for sidecar amps (already in tree)
- `SOC_SDW_SIDECAR_AMPS` infrastructure present since v6.18 merge
  (`5d324e5159d9e`)
- Standalone single-patch commit, not part of a series

### Step 3.4: Author's other commits
**Record:** Charles Keepax (Cirrus Logic) — no other `sof_sdw.c` commits
in this tree. Related work by Maciej Strozek at same vendor (Lenovo/Dell
sidecar quirks). Mark Brown merged as ASoC maintainer.

### Step 3.5: Prerequisites
**Record:** All dependencies present in 6.18.44:
- `SOC_SDW_SIDECAR_AMPS` in `include/sound/soc_sdw_utils.h`
- `sof_sdw_ssid_quirk_table` and `sof_sdw_check_ssid_quirk()`
- Sidecar bridge support in
  `sound/soc/sdw_utils/soc_sdw_bridge_cs35l56.c`
- Applies standalone with no other commits required

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:** `b4 am
20260716144209.2411523-1-ckeepax@opensource.cirrus.com` found the thread
(2 messages). Mbox contains only the patch itself — no review replies,
no stable nominations, no NAKs. Single revision (v1 only).

### Step 4.2: Reviewers
**Record:** `b4 am` attestation shows DKIM signatures from cirrus.com.
Mark Brown Signed-off-by on merge. No explicit Reviewed-by in patch or
thread.

### Step 4.3: Bug report
**Record:** N/A — no Reported-by or external bug link. Hardware
enablement issue reported by vendor (Cirrus Logic) based on shipping
laptops.

### Step 4.4: Related patches/series
**Record:** Complements existing Dell PTL DMI quirk (`921903d73967f`)
and Lenovo SSID quirk (`2ca80dd4bb0e2`). Uses SSID matching (not DMI)
for these XPS models — appropriate when DMI data is insufficient.

### Step 4.5: Stable mailing list
**Record:** Not searched on lore stable list; no stable discussion found
in patch thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** Data change only in `sof_sdw_ssid_quirk_table[]`. Consumed
by `sof_sdw_check_ssid_quirk()`.

### Step 5.2: Callers
**Record:** `sof_sdw_check_ssid_quirk()` called once from
`sof_sdw_probe()` at line 1373, when
`mach->mach_params.subsystem_id_set` is true. Runs on every SoundWire
machine driver probe for Intel SOF platforms.

### Step 5.3: Callees
**Record:** `snd_pci_quirk_lookup_id()` performs PCI SSID table lookup;
result sets global `sof_sdw_quirk`, later copied to `ctx->mc_quirk`.

### Step 5.4: Call chain / reachability
**Record:** Boot-time driver probe on Dell XPS WCL/PTL laptops with
SoundWire audio → `sof_sdw_probe()` → `sof_sdw_check_ssid_quirk()` →
quirk applied → sidecar amp DAIs added during card construction. Affects
all users of these specific Dell models at boot.

### Step 5.5: Similar patterns
**Record:** Same table already has Lenovo `0x3821` with
`SOC_SDW_SIDECAR_AMPS`. Dell PTL SKU `0DD6` uses DMI-based quirk with
the same flag. This commit extends SSID-based matching to two more Dell
models.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Does buggy code exist?
**Record:** Yes. `sof_sdw_ssid_quirk_table` exists but lacks
`0x1028:0x0e53` and `0x1028:0x0e54`. Grep confirms these SSIDs are not
in `sof_sdw.c`. The bug (missing quirk → broken audio) is present in
6.18.44.

### Step 6.2: Backport complications
**Record:** Clean apply. `git apply --check` succeeded with minor offset
(-2 lines). No conflicts expected.

### Step 6.3: Related fixes already present?
**Record:** Related infrastructure and similar quirks are already in
tree (`SOC_SDW_SIDECAR_AMPS`, Lenovo `0x3821`, Dell PTL DMI `0DD6`).
This specific Dell XPS WCL/PTL SSID fix is not yet applied.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `sound/soc/intel` — ASoC machine driver for Intel SoundWire
laptops. **IMPORTANT** for affected Dell XPS users; peripheral for the
broader kernel, but critical for those machines.

### Step 7.2: Subsystem activity
**Record:** Active — multiple quirk additions in 2026 (`921903d73967f`,
`2ca80dd4bb0e2`, Alienware quirk `3d5f63d867207`). Pattern of
incremental hardware quirk additions is established and routine for this
driver.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of Dell XPS WCL and Dell XPS PTL laptops with
SoundWire + sidecar amp audio topology. Platform-specific, driver-
specific.

### Step 8.2: Trigger conditions
**Record:** Every boot on matching hardware (`lspci` SSID
`0x1028:0x0e53` or `0x1028:0x0e54`). Not timing-dependent. Unprivileged
users cannot trigger it, but all owners of these laptops are affected.

### Step 8.3: Failure mode severity
**Record:** Broken or missing speaker audio (functional hardware
failure). Severity: **HIGH** for affected users (not kernel crash, but
primary audio output non-functional).

### Step 8.4: Risk-benefit ratio
**Record:**
- **Benefit:** HIGH for Dell XPS WCL/PTL owners — restores speaker
  functionality
- **Risk:** VERY LOW — 2-line quirk table addition, scoped to two PCI
  IDs
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backporting:**
- Hardware quirk for shipping Dell XPS laptops (classic stable
  exception)
- Fixes real user-visible bug (broken speaker audio)
- 2 lines, single file, obviously correct pattern
- All infrastructure (`SOC_SDW_SIDECAR_AMPS`, SSID quirk table) exists
  in 6.18.44
- Similar quirks already backported to this tree
- Applies cleanly
- Merged by ASoC maintainer Mark Brown

**AGAINST backporting:**
- No explicit user bug report or syzbot finding (vendor-reported
  hardware enablement)
- No review discussion beyond maintainer merge
- Only affects specific new Dell models (limited population, but those
  users are fully affected)

**Unresolved:** None material to the decision.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — identical to existing quirk
   entries; vendor-submitted for shipping hardware
2. Fixes a real bug? **PASS** — speaker audio broken without quirk
3. Important issue? **PASS** — functional hardware failure on consumer
   laptops
4. Small and contained? **PASS** — 2 lines, 1 file
5. No new features or APIs? **PASS** — quirk table entries only
6. Can apply to local tree? **PASS** — verified clean apply

### Step 9.3: Exception category
**Record:** Hardware quirk/workaround — automatic stable qualification
per established rules.

### Step 9.4: Decision rationale
This commit adds PCI subsystem ID quirks for two new Dell XPS laptop
models that use sidecar amplifier audio hardware. Without it, the
`SOC_SDW_SIDECAR_AMPS` flag is never set on these machines, and the
SoundWire driver does not configure the CS35L56 sidecar amplifiers —
resulting in broken speaker audio. The fix is minimal, follows an
established pattern already present in this 6.18.44 tree, requires no
prerequisites, and applies cleanly. This is textbook stable material.

---

## Verification

- [Phase 1] Parsed commit message: subsystem ASoC/Intel/sof_sdw, action
  "add quirks", no Fixes:/Reported-by tags
- [Phase 1] Link tag points to patch.msgid.link thread
- [Phase 2] Diff: +2 lines in `sof_sdw_ssid_quirk_table[]`, no logic
  changes
- [Phase 2] Read `soc_sdw_bridge_cs35l56.c`: `SOC_SDW_SIDECAR_AMPS`
  controls sidecar DAI addition
- [Phase 2] Read `soc_sdw_cs42l43.c`: speaker init differs when sidecar
  amps present
- [Phase 3] `git describe HEAD`: v6.18.44-1-g2736c32da98b9
- [Phase 3] `make kernelversion`: 6.18.44
- [Phase 3] `git blame -L 807,815 sof_sdw.c`: table from v6.18 merge,
  Lenovo entry from 2ca80dd4bb0e2
- [Phase 3] `git log -S SOC_SDW_SIDECAR_AMPS`: introduced with v6.18
  merge, used by 921903d and 2ca80dd4
- [Phase 3] `git show 921903d73967f`: related Dell PTL DMI quirk already
  in tree
- [Phase 3] `git show 2ca80dd4bb0e2`: related Lenovo SSID sidecar quirk
  already in tree
- [Phase 3] Grep for 0x0e53/0x0e54 in sof_sdw.c: not present (fix
  needed)
- [Phase 4] `b4 am
  20260716144209.2411523-1-ckeepax@opensource.cirrus.com`: found patch,
  2 messages, DKIM verified
- [Phase 4] Read mbox file: single-patch submission, no review replies
- [Phase 5] Grep `sof_sdw_check_ssid_quirk`: called from
  `sof_sdw_probe()` line 1373
- [Phase 5] Read probe path lines 1369-1386: quirk flows to
  `ctx->mc_quirk`
- [Phase 6] Grep `SOC_SDW_SIDECAR_AMPS` in tree: present in header and
  bridge code
- [Phase 6] `git apply --check`: patch applies cleanly (offset -2 lines)
- [Phase 6] Current `sof_sdw_ssid_quirk_table` at lines 807-814: missing
  Dell entries
- [Phase 8] Failure mode: broken speaker audio, severity HIGH for
  affected Dell XPS users

**YES**The background history lookup finished successfully. It confirmed
that `SOC_SDW_SIDECAR_AMPS` support landed with the v6.18 merge
(`5d324e5159d9e`), and this tree already has related sidecar-amp quirks
for Lenovo (`2ca80dd4bb0e2`) and Dell PTL (`921903d73967f`). The missing
piece is only the two Dell XPS SSID entries from this commit.

That supports the earlier **YES** verdict for 6.18.44: prerequisites are
in place, the patch applies cleanly, and it’s a small hardware quirk fix
for broken speaker audio on new Dell XPS WCL/PTL laptops.

 sound/soc/intel/boards/sof_sdw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 4a2b375d7dd9d..17ee5fdb85201 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -805,6 +805,8 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 };
 
 static const struct snd_pci_quirk sof_sdw_ssid_quirk_table[] = {
+	SND_PCI_QUIRK(0x1028, 0x0e53, "Dell XPS WCL", SOC_SDW_SIDECAR_AMPS),
+	SND_PCI_QUIRK(0x1028, 0x0e54, "Dell XPS PTL", SOC_SDW_SIDECAR_AMPS),
 	SND_PCI_QUIRK(0x1043, 0x1e13, "ASUS Zenbook S14", SOC_SDW_CODEC_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1f43, "ASUS Zenbook S16", SOC_SDW_CODEC_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x2347, "Lenovo P16", SOC_SDW_CODEC_MIC),
-- 
2.53.0

