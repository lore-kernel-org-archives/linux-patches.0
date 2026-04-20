Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416F5451056;
	Mon, 20 Apr 2026 13:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691829; cv=none; b=uQsu7tTtwsG0YK9CejN2V4HsAn5uADoT7sv0qn8bhF8ulyyk+rMJYtj/6ly0rvnu8vJ53NF1lQexFBsIwdD610kwF1GnH2vU5e9LYKd72faQCzCjMkG5nHIRXSxzuLQTDSXQ2InrA2u2utKJ2hlKg6iNxMbf5TNW33tVJwDQo/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691829; c=relaxed/simple;
	bh=O4b1Y+xQEG8AiQcB2M8vWaECIB5j/E6fhegWDL6BDYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cVoAuV39xUjxeuBWR62SdDQtBAdp5g6WwHxTN6G6Janx7zeHg9+KbWGM4H64gbKaAi+vT08eb1Mt83KsjGtG8CAjPRYLJ0yHxMS7lt0k/vKtLsAOvKjKs0TmUaDYs7+TdcOzumAFYP3Qv8CXPZJFsT4GjPFNQv+sWtNoVLzvNuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p/cUjcry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p/cUjcry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2718EC19425;
	Mon, 20 Apr 2026 13:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691829;
	bh=O4b1Y+xQEG8AiQcB2M8vWaECIB5j/E6fhegWDL6BDYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p/cUjcryWN5bypyGaqQfaLhCxmspM2h6yDThmBZ6c079wCDG5Orx3z76YX7RF5Lo0
	 54wfZDxdZ4XEfyjR5YDAX0a7SztUsYl6LJ625rSWTgjP1D4pJIgoFiYvxna5mdofeb
	 KmRq9Ic6NL1EWRkHSsGtNif4AlXruwsh3kQ20jGQ46oly/ymcl4wCL3fed9FC9LPU0
	 +oD7dvQiWhGHj+wfnP3txNZZIPnbToY7qIezJxJHQA1Wxd5GuflsfKTSQcY2CM8Auv
	 eZ0DT2jJ3IQhJarlDj/AFaeQsHjVqg6gk5ITzdqgK2nFyIwmv8xoOwVSS9HfQMWMAC
	 v3zij0qfnfVOw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.19] ALSA: hda/realtek: Add support for HP Laptops
Date: Mon, 20 Apr 2026 09:20:13 -0400
Message-ID: <20260420132314.1023554-219-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit 8dbbd39d0605b93a176f2c775dd2b6bb7c7a8adb ]

Add support for HP Auster, Trekker and Agusta G7KX.
Laptops use 2 CS35L41 Amps with HDA, using Internal boost, with I2C

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Link: https://patch.msgid.link/20260330134651.443439-2-sbinding@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I now have all the information needed for a comprehensive analysis.
Here's my complete walkthrough:

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: `ALSA: hda/realtek` (HDA audio codec - Realtek)
- **Action verb**: "Add support" - adding hardware support entries
- **Summary**: Adds PCI quirk entries for HP Auster, Trekker G7JC, and
  Agusta G7KX laptops
- Record: [ALSA/HDA Realtek] [Add] [Hardware quirk entries for HP
  laptops with CS35L41 amps]

### Step 1.2: Tags
- **Signed-off-by**: Stefan Binding (sbinding@opensource.cirrus.com) -
  Cirrus Logic engineer, regular CS35L41 contributor
- **Link**: `https://patch.msgid.link/20260330134651.443439-2-
  sbinding@opensource.cirrus.com` - patch 2 of series
- **Signed-off-by**: Takashi Iwai (tiwai@suse.de) - ALSA subsystem
  maintainer
- No Fixes: tag (expected for quirk additions)
- No Reported-by: tag (expected - hardware enablement)
- No Cc: stable tag (expected - this is what we're evaluating)
- Record: Standard tags for a quirk addition. Merged by the ALSA
  subsystem maintainer.

### Step 1.3: Commit Body
- "Add support for HP Auster, Trekker and Agusta G7KX."
- "Laptops use 2 CS35L41 Amps with HDA, using Internal boost, with I2C"
- This is a standard hardware enablement description from Cirrus Logic.
- Record: Without these quirk entries, the CS35L41 amplifiers on these
  HP laptops won't be configured correctly, resulting in no audio output
  or broken audio.

### Step 1.4: Hidden Bug Fix?
- Not a hidden bug fix - this is a straightforward hardware enablement
  via quirk table entries. However, the absence of these entries means
  audio doesn't work on these laptops, which is a real user-facing
  issue.
- Record: Not a hidden bug fix. It's a hardware quirk addition, which is
  an explicitly allowed exception for stable.

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed**: 1 file (`sound/hda/codecs/realtek/alc269.c`)
- **Lines added**: 4 (pure additions)
- **Lines removed**: 0
- **Functions modified**: None (only the `alc269_fixup_tbl[]` data table
  is changed)
- Record: Single-file, 4-line addition to a data table. Minimal scope.

### Step 2.2: Code Flow Change
Four new `SND_PCI_QUIRK()` entries inserted in sorted order:
1. `0x8e75` → "HP Trekker G7JC" → `ALC287_FIXUP_CS35L41_I2C_2`
2. `0x8f07` → "HP Agusta G7KX" → `ALC287_FIXUP_CS35L41_I2C_2`
3. `0x8f2d` → "HP Auster 14" → `ALC287_FIXUP_CS35L41_I2C_2`
4. `0x8f2e` → "HP Auster 14" → `ALC287_FIXUP_CS35L41_I2C_2`

Before: These PCI subsystem IDs have no quirk entry → generic behavior →
CS35L41 amps not properly configured.
After: These IDs match → `cs35l41_fixup_i2c_two()` is called → 2 CS35L41
amps configured via I2C with internal boost.

### Step 2.3: Bug Mechanism
- Category: **Hardware workaround / device ID addition**
- Without the quirk entry, the HDA codec driver doesn't know these
  laptop models have CS35L41 amplifiers that need specific I2C
  configuration. Audio will be broken or absent.

### Step 2.4: Fix Quality
- Obviously correct: just adds entries to a sorted lookup table using an
  existing fixup
- Minimal/surgical: 4 lines, data-only
- Zero regression risk: only affects the specific HP PCI subsystem IDs
  listed
- No code logic changes whatsoever

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
- The `ALC287_FIXUP_CS35L41_I2C_2` fixup was introduced in commit
  `07bcab93946cd` (January 2022, merged in v5.18). It has been stable
  and used by dozens of other HP/ASUS laptop quirk entries ever since.
- Record: The fixup function exists in all active stable trees (v5.18+).

### Step 3.2: No Fixes: tag (expected for quirk additions)

### Step 3.3: File History
- Stefan Binding has numerous similar commits adding CS35L41 quirk
  entries for HP laptops: `108c422c495dc` (HP Clipper), `720eebd514c0c`
  (HP Trekker), `f8b1ff6555868` (HP Turbine). This is a well-established
  pattern.
- Record: Standalone commit, no prerequisites needed.

### Step 3.4: Author
- Stefan Binding is a Cirrus Logic engineer who is the primary
  contributor for CS35L41 HDA support. He has dozens of similar commits
  over the past 4 years.
- Record: Author is the de facto maintainer of CS35L41 HDA integration.

### Step 3.5: Dependencies
- This is part of a 2-patch series (patch 1/2). Patch 2/2 adds ASUS
  laptop quirks. The two patches are completely independent - they add
  entries for different manufacturers to the same table.
- `ALC287_FIXUP_CS35L41_I2C_2` already exists (line 6248 in current
  tree).
- Record: Fully standalone; no dependencies.

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1: Original Submission
- Found via `b4 am`: Series is "[PATCH v1 0/2] Add support for various
  HP and ASUS laptops using CS35L41 HDA"
- Cover letter confirms: "These laptops use Internal boost, with SPI or
  I2C."
- v1 only (no revisions needed) - accepted as-is by Takashi Iwai.
- Record: Clean submission, applied without revisions.

### Step 4.2: Reviewers
- Sent to Jaroslav Kysela (ALSA co-maintainer), Takashi Iwai (ALSA
  maintainer), linux-sound@vger.kernel.org,
  patches@opensource.cirrus.com
- Applied by Takashi Iwai directly.
- Record: Proper review chain through the subsystem maintainer.

### Step 4.3: No bug report (hardware enablement, not a bug report)

### Step 4.4: Series context
- Patch 2/2 adds ASUS quirks; completely independent.

### Step 4.5: Lore blocked by anti-bot protection; unable to search
stable mailing list directly. No stable-specific discussion expected for
a new quirk addition.

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Functions
- No functions modified. Only the `alc269_fixup_tbl[]` static data table
  is changed.

### Step 5.2-5.4: Call chain
- The quirk table is consulted during HDA codec probe via
  `snd_pci_quirk_lookup()`. When a matching PCI subsystem vendor/device
  ID is found, the corresponding fixup function
  (`cs35l41_fixup_i2c_two`) is called during codec initialization.
- This is a standard, well-tested path used by 100+ existing quirk
  entries.

### Step 5.5: Similar patterns
- 114 existing uses of `ALC287_FIXUP_CS35L41_I2C_2` in the current tree.
  This is one of the most commonly used fixups.

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy code in stable?
- The "bug" is the absence of quirk entries for these specific HP laptop
  models. The fixup infrastructure exists in all stable trees from v5.18
  onward.
- Record: `ALC287_FIXUP_CS35L41_I2C_2` confirmed present in v5.18 (13
  uses) and v6.6 (25 uses).

### Step 6.2: Backport complications
- Minor context mismatch: in the mainline diff, entry `0x8e60` shows "HP
  Trekker" with `ALC287_FIXUP_CS35L41_I2C_2`, but in the current 7.0
  tree, it shows "HP OmniBook 7 Laptop 16-bh0xxx" with
  `ALC245_FIXUP_CS35L41_I2C_2_MUTE_LED`. This means the first hunk
  context won't match exactly, but the insertion points (after 0x8e62,
  after 0x8ee7, after 0x8f0e) all exist and match.
- For older stable trees (pre-6.14), the file is at
  `sound/pci/hda/patch_realtek.c` instead of
  `sound/hda/codecs/realtek/alc269.c` (file moved in July 2025).
- Record: Minor fuzz needed for 7.0; path adjustment needed for older
  trees. Trivial.

### Step 6.3: No related fixes already in stable for these specific PCI
IDs.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1
- Subsystem: ALSA/HDA (audio) - **IMPORTANT** level. Audio is critical
  for laptop users.
- HP is one of the largest laptop manufacturers globally.

### Step 7.2
- This file is extremely actively maintained - frequent quirk additions
  for new laptop models.

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected users
- Users of HP Auster 14, HP Trekker G7JC, and HP Agusta G7KX laptops.
- These are new HP commercial/consumer laptop models.

### Step 8.2: Trigger
- Every boot on these specific laptop models. Audio is broken without
  the quirk.

### Step 8.3: Failure mode
- Without the quirk: CS35L41 amplifiers not configured → no audio output
  (speakers don't work).
- Severity: HIGH for affected users (audio completely non-functional).

### Step 8.4: Risk-benefit
- **Benefit**: Enables audio on specific HP laptop models. High value
  for affected users.
- **Risk**: Essentially zero. Adds 4 entries to a lookup table. Only
  affects the exact PCI subsystem IDs listed. Cannot affect any other
  hardware.
- **Ratio**: Extremely favorable.

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence
**FOR backporting:**
- Textbook hardware quirk addition (explicitly listed as an exception in
  stable rules)
- 4 lines of pure data additions, zero logic changes
- Uses well-established fixup present since v5.18
- Author is the primary CS35L41 maintainer at Cirrus Logic
- Merged by the ALSA subsystem maintainer (Takashi Iwai)
- Fixes real user-facing issue (broken audio on new HP laptops)
- Identical pattern to dozens of previously-backported quirk entries

**AGAINST backporting:**
- Minor context mismatch requiring trivial adjustment
- File path differs in older stable trees (pre-6.14)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** - data table entries using
   existing fixup
2. Fixes a real bug? **YES** - audio doesn't work on these laptops
   without it
3. Important issue? **YES** - complete audio failure on affected
   hardware
4. Small and contained? **YES** - 4 lines, single file, data-only
5. No new features or APIs? **CORRECT** - no new features
6. Can apply to stable? **YES** - with minor fuzz for context

### Step 9.3: Exception Category
This is a **hardware quirk addition** - one of the explicitly allowed
exception categories for stable.

### Step 9.4: Decision
Clear YES. This is a textbook example of a stable-worthy hardware quirk
addition.

## Verification

- [Phase 1] Parsed tags: Signed-off-by Stefan Binding (Cirrus Logic),
  applied by Takashi Iwai (ALSA maintainer)
- [Phase 2] Diff analysis: 4 lines added to `alc269_fixup_tbl[]` data
  table, all using existing `ALC287_FIXUP_CS35L41_I2C_2` fixup
- [Phase 3] git show 07bcab93946cd: confirmed
  `ALC287_FIXUP_CS35L41_I2C_2` introduced January 2022 (v5.18)
- [Phase 3] git show v5.18/v6.6 confirmed fixup present: 13 uses in
  v5.18, 25 in v6.6
- [Phase 3] git log author: Stefan Binding has dozens of identical quirk
  additions (108c422c495dc, 720eebd514c0c, f8b1ff6555868)
- [Phase 4] b4 am: Found 2-patch series, both independent quirk
  additions. v1 only, accepted without revision
- [Phase 4] b4 dig -w (on related commit): Sent to ALSA maintainers and
  linux-sound list
- [Phase 5] Grep: 114 existing uses of ALC287_FIXUP_CS35L41_I2C_2 in
  current tree
- [Phase 6] Fixup definition confirmed at line 6248; all insertion
  points (0x8e62, 0x8ee7, 0x8f0e) present in 7.0 tree
- [Phase 6] Context mismatch: 0x8e60 entry differs between mainline and
  7.0 (different name/fixup) - minor fuzz needed
- [Phase 6] File renamed from `sound/pci/hda/patch_realtek.c` to
  `sound/hda/codecs/realtek/alc269.c` in v6.14 cycle
- [Phase 8] Risk: zero (data-only, only matches specific PCI IDs).
  Benefit: high (enables audio on HP laptops)

**YES**

 sound/hda/codecs/realtek/alc269.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index d86781e976ac0..44f0fcd20cf51 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7198,6 +7198,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8e60, "HP OmniBook 7 Laptop 16-bh0xxx", ALC245_FIXUP_CS35L41_I2C_2_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8e61, "HP Trekker ", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8e62, "HP Trekker ", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8e75, "HP Trekker G7JC", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8e8a, "HP NexusX", ALC245_FIXUP_HP_TAS2781_I2C_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8e9c, "HP 16 Clipper OmniBook X X360", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8e9d, "HP 17 Turbine OmniBook X UMA", ALC287_FIXUP_CS35L41_I2C_2),
@@ -7219,8 +7220,11 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8ee4, "HP Bantie A6U", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x8ee5, "HP Bantie A6U", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x8ee7, "HP Abe A6U", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_GPIO),
+	SND_PCI_QUIRK(0x103c, 0x8f07, "HP Agusta G7KX", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8f0c, "HP ZBook X G2i 16W", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8f0e, "HP ZBook X G2i 16W", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8f2d, "HP Auster 14", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8f2e, "HP Auster 14", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8f40, "HP ZBook 8 G2a 14", ALC245_FIXUP_HP_TAS2781_I2C_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8f41, "HP ZBook 8 G2a 16", ALC245_FIXUP_HP_TAS2781_I2C_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8f42, "HP ZBook 8 G2a 14W", ALC245_FIXUP_HP_TAS2781_I2C_MUTE_LED),
-- 
2.53.0

