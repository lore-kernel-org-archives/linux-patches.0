Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE2257F75D;
	Mon, 31 Aug 2026 13:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184186; cv=none; b=fWCXGov+ySTMqq21Q7HlbWcmVl6Os7+TjQbzS5nbKBHb/WVFTk/AFeNFUIBi2xrauAUtIsmsDA/AkWoRKAWq6OWXYlzDXwBUCHO2eQO8Z4D4RQw+t+Av2TRdIUUdc9W1e3c5F4/yBQfyE7HLH+fg9PRBEwmDyl3VgJxOYZ6J548=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184186; c=relaxed/simple;
	bh=vLMNqK5faWZZZJ2ngx/fCEUd23wWhXdJzcL2g0ORqFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k48HNbw2LCeMnMzZKdo02ubtLO6pPwxlx+IsO9Qp77rIH91JvZWY3Uu4flM0L6C9qJZl+oxFNnEY6I7dvsCNsDuGYjdfwMgMufu5OHMSgtjRscIcWs/oqD82RsD8Ing8lHTrWaLfJWta9sZJtsLZUJMaLpL8LjZiuWzmabxgoxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VRQCBJ6j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VRQCBJ6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F39E1F00ACA;
	Mon, 31 Aug 2026 13:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184183;
	bh=gfDLxdeyZUh4BVx/IUtNZHBamX7ys7yUPjAPrYygr4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VRQCBJ6jwS6YJN3fGvH/N1ncfo5gkJdqwvNtsVe6vZqhlM4k5on+YeEFfqfsm6zuQ
	 op96tWNRfgOHY4gcFcZqKp/DSzplJO5X7kufJYh46u7b2kHlGfJKqTV0dZ3QkOLlj4
	 lu5bbSRTxjnscWr1jPpOYT7o/tw/5uFXiQxis2KlFlw9KWq2fXcE3oZyhX92p56KCW
	 niRS/uLyVnvFu6r2LULEddqU+nkGkPUoTAWBjqC4qVxvFqHFGsT4EVn1ibBNSljOQZ
	 F1N/k5CSu0HABVpGGiHLEJoI3x+ILMGmr+41rSW5HAgLIWTROh4LAs9qHn9dstcq1V
	 psp5taJxhkDtw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Colton Jones <cjones1308@pm.me>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ALSA: hda/realtek: Add CS35L41 I2C quirk for ASUS UM3405GA
Date: Mon, 31 Aug 2026 09:29:29 -0400
Message-ID: <20260831133314.4125787-541-sashal@kernel.org>
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

From: Colton Jones <cjones1308@pm.me>

[ Upstream commit f61bc797ac0075dbaac5e44238674858e9dbe399 ]

The ASUS Zenbook 14 UM3405GA uses a Realtek ALC294 codec with two
Cirrus Logic CS35L41 speaker amplifiers exposed through the CSC3551 ACPI
device. The machine reports the Realtek subsystem ID 1043:19f4.

Without a PCI quirk, the codec falls back to generic pin matching and the
internal speakers remain silent even though PCM playback completes.

Add the UM3405GA subsystem ID and reuse the same ASUS I2C headset-mic
fixup used by the closely related UM3406HA. That fixup configures the
headset microphone pin and chains to CS35L41 I2C speaker-amp binding.

Signed-off-by: Colton Jones <cjones1308@pm.me>
Link: https://patch.msgid.link/20260615033619.7-1-cjones1308@pm.me
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ALSA: hda/realtek: Add CS35L41 I2C quirk for
ASUS UM3405GA

**Local tree:** Linux **6.18.44** (`v6.18.44-1-g2736c32da98b9`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[ALSA: hda/realtek]` `[Add]` — Add a PCI subsystem ID quirk
for ASUS UM3405GA laptop audio.

### Step 1.2: Parse all commit message tags
**Record:**
- **Link:**
  `https://patch.msgid.link/20260615033619.7-1-cjones1308@pm.me`
- **Signed-off-by:** Colton Jones `<cjones1308@pm.me>` (author)
- **Signed-off-by:** Takashi Iwai `<tiwai@suse.de>` (ALSA/HDA maintainer
  merge)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable@vger.kernel.org` tags present (absence of stable
  tag is expected per pipeline instructions)

**Notable patterns:** Maintainer (Takashi Iwai) signed off — standard
for accepted ALSA patches.

### Step 1.3: Analyze commit body text
**Record:**
- **Bug description:** ASUS Zenbook 14 UM3405GA uses Realtek ALC294 +
  two Cirrus CS35L41 speaker amps over I2C (CSC3551 ACPI device),
  subsystem ID `1043:19f4`. Without a PCI quirk, codec falls back to
  generic pin matching.
- **Symptom:** Internal speakers remain silent; PCM playback completes
  but produces no audible output.
- **Root cause (author):** Missing subsystem ID → wrong/missing fixup →
  CS35L41 I2C amp binding and pin configuration not applied.
- **Fix approach:** Add `1043:19f4` quirk entry reusing
  `ALC294_FIXUP_ASUS_I2C_HEADSET_MIC` (same as closely related
  UM3406HA).

### Step 1.4: Detect hidden bug fixes
**Record:** Not disguised — this is an explicit hardware-enablement
quirk. It fixes broken audio output on a specific shipping laptop model.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **Files changed:** `sound/hda/codecs/realtek/alc269.c` — 1 line added,
  0 removed
- **Function/table modified:** `alc269_fixup_tbl[]` (static quirk table)
- **Scope classification:** Single-file, single-line surgical hardware
  quirk addition

### Step 2.2: Understand the code flow change
**Record:**
- **Hunk (quirk table entry):**
  - **Before:** SSID `1043:19f4` has no matching `SND_PCI_QUIRK` entry;
    `snd_hda_pick_fixup()` at codec probe does not select a model-
    specific fixup.
  - **After:** SSID `1043:19f4` maps to
    `ALC294_FIXUP_ASUS_I2C_HEADSET_MIC`, which configures headset-mic
    pin 0x19 and chains to `ALC287_FIXUP_CS35L41_I2C_2` for CS35L41 I2C
    amp binding.
  - **Execution path:** Codec probe (`alc269_probe` →
    `snd_hda_pick_fixup()` → fixup chain application during
    `HDA_FIXUP_ACT_PRE_PROBE` / `HDA_FIXUP_ACT_PROBE`).

### Step 2.3: Identify the bug mechanism
**Record:**
- **Bug category:** Hardware quirk / logic correctness (missing device
  ID mapping)
- **Mechanism:** Without the quirk, `cs35l41_fixup_i2c_two()` is never
  invoked for this machine's CSC3551 ACPI devices, so external CS35L41
  amplifiers are not bound and speakers produce no sound.

### Step 2.4: Assess fix quality
**Record:**
- **Fix quality:** Obviously correct — reuses an existing, proven fixup
  already applied to the sibling model UM3406HA (`0x1043:0x1c03`).
- **Regression risk:** Very low — only affects machines reporting SSID
  `1043:19f4`; no changes to shared logic, locking, or APIs.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame the changed lines
**Record:** Insertion point is between existing entries at lines
7121–7122 (`0x19e1` and `0x1a13`). Surrounding quirk table entries date
from July 2025 (`aeeb85f26c3bb`). The target fixup
`ALC294_FIXUP_ASUS_I2C_HEADSET_MIC` was introduced in commit
`018f659753fd3` (Aug 18, 2025) for UM3406HA. The missing `0x19f4` entry
is a gap, not a recently introduced regression.

### Step 3.2: Follow Fixes: tag
**Record:** No `Fixes:` tag present — step not applicable.

### Step 3.3: Check file history for related changes
**Record:** Related commits in this tree:
- `018f659753fd3` — introduced `ALC294_FIXUP_ASUS_I2C_HEADSET_MIC` +
  UM3406HA quirk
- `ef8b0cc691f1a` — UX3405MA headset mic fix (different SSID `0x1a63`,
  SPI variant)
- `93ee5471731b8` — UM3406GA CS35L41 support (stable backport format,
  different model)
- Numerous similar one-line quirk additions in recent history (e.g.,
  TongFang, HP, Lenovo quirks)

**Prerequisites:** Standalone — only adds a table entry; does not
require other patches from a series.

### Step 3.4: Check author's other commits
**Record:** No commits by Colton Jones found in this tree (`git log
--author="Colton Jones"` returned empty). This is a first-time
contributor patch, but it follows established patterns and was merged by
the subsystem maintainer.

### Step 3.5: Check for dependent/prerequisite commits
**Record:**
- **Required fixup `ALC294_FIXUP_ASUS_I2C_HEADSET_MIC`:** Present —
  introduced by `018f659753fd3`, confirmed ancestor of HEAD.
- **Required chain target `ALC287_FIXUP_CS35L41_I2C_2`:** Present —
  `cs35l41_fixup_i2c_two()` at line 6126.
- **Can apply standalone:** Yes — one-line addition to existing table
  with all dependencies already in tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Find original patch discussion
**Record:** `b4 dig -c <commit>` could not be run — commit is not yet in
this tree. `b4 dig` with subject search returned no results. WebFetch of
`patch.msgid.link` and `lore.kernel.org` blocked by Anubis bot
protection.

**UNVERIFIED:** Full mailing list review thread content.

### Step 4.2: Check who reviewed the patch
**Record:** UNVERIFIED via b4 dig. Commit message shows Takashi Iwai
(ALSA maintainer) as merge Signed-off-by.

### Step 4.3: Search for bug report
**Record:** No `Reported-by:` tag. Commit message describes hardware-
verified silent speaker behavior on UM3405GA. No external bug tracker
link beyond patch submission.

### Step 4.4: Check for related patches and series
**Record:** Standalone 1/1 patch. Closely related to `018f659753fd3`
(UM3406HA) which introduced the reused fixup. Not part of a multi-patch
series.

### Step 4.5: Check stable mailing list history
**Record:** UNVERIFIED — lore.kernel.org inaccessible via WebFetch.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Identify key functions in the diff
**Record:** Modified: `alc269_fixup_tbl[]` (data table). Affected fixup
chain: `ALC294_FIXUP_ASUS_I2C_HEADSET_MIC` →
`ALC287_FIXUP_CS35L41_I2C_2` → `cs35l41_fixup_i2c_two()`.

### Step 5.2: Trace callers
**Record:** `snd_hda_pick_fixup(codec, alc269_fixup_models,
alc269_fixup_tbl, alc269_fixups)` called from `alc269_probe()` at line
8471. This runs on every Realtek ALC269-family codec probe when
`CONFIG_SND_HDA_CODEC_REALTEK` is enabled — standard laptop audio
initialization path.

### Step 5.3: Trace callees
**Record:** Fixup chain calls:
1. Pin configuration for headset mic (pin 0x19 → `0x03a19020`)
2. `cs35l41_fixup_i2c_two()` → `comp_generic_fixup()` binding CSC3551
   ACPI I2C devices to CS35L41 HDA codec components

### Step 5.4: Follow call chain (bug reachability)
**Record:** Triggered automatically at boot/module load on UM3405GA
hardware when the HDA Realtek driver probes the ALC294 codec. Every boot
on affected hardware hits this path. Not userspace-triggerable, but
affects all users of this laptop model.

### Step 5.5: Search for similar patterns
**Record:** Identical pattern used for UM3406HA at line 7131:
```7131:7131:sound/hda/codecs/realtek/alc269.c
        SND_PCI_QUIRK(0x1043, 0x1c03, "ASUS UM3406HA",
ALC294_FIXUP_ASUS_I2C_HEADSET_MIC),
```
Same hardware family (Zenbook 14, ALC294 + CS35L41 I2C). The UM3405GA
fix is a direct extension of this established pattern.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: Does the buggy code exist in this tree?
**Record:** **Yes.** The quirk table exists but lacks `1043:19f4`.
Verified: `grep "0x19f4"` in `alc269.c` returns no matches. Gap is
between `0x19e1` (line 7121) and `0x1a13` (line 7122). Without this
entry, UM3405GA users on 6.18.y get silent speakers.

### Step 6.2: Check for backport complications
**Record:** **Clean apply expected.** Context lines at insertion point
match the diff exactly:
```7120:7123:sound/hda/codecs/realtek/alc269.c
        SND_PCI_QUIRK(0x1043, 0x19ce, "ASUS B9450FA",
ALC294_FIXUP_ASUS_HPE),
        SND_PCI_QUIRK(0x1043, 0x19e1, "ASUS UX581LV",
ALC295_FIXUP_ASUS_MIC_NO_PRESENCE),
        SND_PCI_QUIRK(0x1043, 0x1a13, "Asus G73Jw",
ALC269_FIXUP_ASUS_G73JW),
        SND_PCI_QUIRK(0x1043, 0x1a63, "ASUS UX3405MA",
ALC294_FIXUP_ASUS_SPI_HEADSET_MIC),
```
No conflicting recent churn in this table region.

### Step 6.3: Check if related fixes are already here
**Record:** Prerequisite fixup `ALC294_FIXUP_ASUS_I2C_HEADSET_MIC` is
present (lines 5177–5185). UM3406HA quirk using the same fixup is
present (line 7131). The UM3405GA-specific entry (`0x19f4`) is **not**
present — this is the missing piece.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Identify subsystem and criticality
**Record:** **Subsystem:** `sound/hda` — Realtek HD-audio codec driver.
**Criticality:** IMPORTANT (peripheral driver, but affects a common
laptop class — ASUS Zenbook 14).

### Step 7.2: Assess subsystem activity
**Record:** Highly active — multiple quirk additions in recent
`alc269.c` history. One-line PCI quirk additions are routine stable
material for this subsystem.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** **Driver-specific / hardware-specific** — owners of ASUS
Zenbook 14 UM3405GA (SSID `1043:19f4`) with
`CONFIG_SND_HDA_CODEC_REALTEK` enabled.

### Step 8.2: Trigger conditions
**Record:** Every boot on affected hardware when the Realtek codec
driver probes. Trigger is deterministic and 100% on unmatched hardware.
Not a security issue; not privilege-dependent.

### Step 8.3: Failure mode severity
**Record:** **Silent internal speakers** — audio subsystem non-
functional for primary output. Severity: **MEDIUM** (no crash, data
corruption, or security impact, but core laptop functionality broken).

### Step 8.4: Risk-benefit ratio
**Record:**
- **Benefit:** Restores speaker output on a shipping ASUS laptop;
  follows proven UM3406HA pattern.
- **Risk:** Minimal — 1-line addition, SSID-specific, no logic changes.
- **Ratio:** Strongly favorable.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Compile the evidence

**FOR backporting:**
- Fixes real hardware bug (silent speakers on UM3405GA)
- Falls under stable exception: **hardware quirk** (PCI subsystem ID
  addition to existing driver)
- One-line, surgical change reusing proven fixup from sibling model
- All prerequisites present in Linux 6.18.44 tree
- Merged by ALSA maintainer (Takashi Iwai)
- Identical pattern to UM3406HA quirk already in tree since
  `018f659753fd3`
- Clean apply to current tree expected

**AGAINST backporting:**
- No crash/corruption/security impact (functional hardware issue only)
- First-time contributor (mitigated by maintainer review and pattern
  reuse)

**UNRESOLVED:**
- Mailing list discussion content (lore/patch.msgid.link inaccessible)
- Whether reviewers explicitly nominated for stable

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — reuses existing fixup;
   maintainer merged
2. Fixes a real bug affecting users? **PASS** — silent speakers on
   UM3405GA
3. Important issue? **PASS** — broken primary audio output on shipping
   hardware (hardware quirk exception)
4. Small and contained? **PASS** — 1 line, 1 file
5. No new features or APIs? **PASS** — subsystem ID quirk only
6. Can apply to local tree? **PASS** — prerequisites present, clean
   context

### Step 9.3: Exception categories
**Record:** **Hardware quirk** — adding PCI subsystem ID (`1043:19f4`)
to map to existing fixup in an existing driver. This is one of the most
common and accepted stable backport categories.

### Step 9.4: Decision rationale

For Linux **6.18.44**, this commit should be backported. The tree
already contains the `ALC294_FIXUP_ASUS_I2C_HEADSET_MIC` fixup and the
UM3406HA quirk using it; only the UM3405GA subsystem ID mapping is
missing. The patch is a single-line addition with no dependencies, no
API changes, and no regression risk beyond the targeted hardware. Users
of ASUS Zenbook 14 UM3405GA on 6.18.y currently have non-functional
internal speakers — exactly the class of issue stable trees routinely
fix via HDA quirk additions.

---

## Verification

- **[Phase 1]** Parsed subject, tags (Link, Signed-off-by ×2); no
  Fixes/Reported-by/Cc:stable
- **[Phase 1]** Identified bug: silent speakers due to missing SSID
  quirk
- **[Phase 2]** Diff: 1 line added to `alc269_fixup_tbl[]` in `alc269.c`
- **[Phase 2]** Verified fixup chain:
  `ALC294_FIXUP_ASUS_I2C_HEADSET_MIC` → `ALC287_FIXUP_CS35L41_I2C_2` →
  `cs35l41_fixup_i2c_two()` (lines 5177–5185, 6126–6128, 3198–3200)
- **[Phase 3]** `git describe HEAD`: v6.18.44-1-g2736c32da98b9 (6.18.44)
- **[Phase 3]** `git blame` lines 7120–7135: insertion point between
  `0x19e1` and `0x1a13` confirmed
- **[Phase 3]** `git log -1 -S ALC294_FIXUP_ASUS_I2C_HEADSET_MIC`:
  `018f659753fd3` (Aug 2025)
- **[Phase 3]** `git merge-base --is-ancestor 018f659753fd3 HEAD`:
  prerequisite fixup is in tree
- **[Phase 3]** `grep 0x19f4 alc269.c`: no match — quirk absent from
  tree
- **[Phase 3]** `grep UM3406HA alc269.c`: sibling quirk present at line
  7131
- **[Phase 4]** WebFetch lore.kernel.org and patch.msgid.link: blocked
  (Anubis) — **UNVERIFIED**
- **[Phase 4]** `b4 dig` with subject search: no results (commit not in
  tree) — **UNVERIFIED**
- **[Phase 5]** `snd_hda_pick_fixup()` called from `alc269_probe()` at
  line 8471
- **[Phase 5]** `cs35l41_fixup_i2c_two()` present at line 3198
- **[Phase 6]** Confirmed gap at lines 7121–7122 where `0x19f4` entry
  should be inserted
- **[Phase 6]** Context lines match diff exactly for clean apply
- **[Phase 8]** Failure mode: silent speakers, severity MEDIUM; benefit
  high for affected hardware, risk minimal

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index c8714e59d8199..490589c042bd9 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7121,6 +7121,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1982, "ASUS B1400CEPE", ALC256_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x19ce, "ASUS B9450FA", ALC294_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x19e1, "ASUS UX581LV", ALC295_FIXUP_ASUS_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1043, 0x19f4, "ASUS UM3405GA", ALC294_FIXUP_ASUS_I2C_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1a13, "Asus G73Jw", ALC269_FIXUP_ASUS_G73JW),
 	SND_PCI_QUIRK(0x1043, 0x1a63, "ASUS UX3405MA", ALC294_FIXUP_ASUS_SPI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1a83, "ASUS UM5302LA", ALC294_FIXUP_CS35L41_I2C_2),
-- 
2.53.0

