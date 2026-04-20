Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D637D3AA1B3;
	Mon, 20 Apr 2026 13:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776690983; cv=none; b=qfd6+fzOBHW1wJUtzmiSfP37RQLqsF+robk1gk9yi5tPIS4CyZAN+o90QszLW5ipON4sa9T0tYAzHbS4Pka+ooE8BwTrSEGDdn4Ata+Z7K2N1B9ElouqxuoqHU8ySENInHCZa1Lsbx9Ojdmf3nCH/pTqY2g5wcamcj3d3YvHoog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776690983; c=relaxed/simple;
	bh=qBmqtkmHqbZzDNTj21yCDiXoWYOvs1iFtBsfOu+6220=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPJQJI78elpM4+5zl9hwFwOHyB1Sx7S+e9bMriVttd+QMHu4Kyds9bJPlkYojuzeHm6FjaXPo0yrcofqG97elYvu7Ye8GDvkisyoQ2KIekfzLOtQ7eeRoAJOZgTblhXwvIXF32ROMnkvsuiIa3vFfV5+rJH49DAnlH217JYiTSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oBVg96PX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oBVg96PX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C94AC19425;
	Mon, 20 Apr 2026 13:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776690982;
	bh=qBmqtkmHqbZzDNTj21yCDiXoWYOvs1iFtBsfOu+6220=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oBVg96PXTN6wyVz0oxBjRQ3JNsHIUyqoSWNnZOkrV/HQqUL6n85rVnfu78AcI/4HT
	 2hseJDZroow+qprgqKN5Jfc2YAtczmcF1L/4C3FkY1XMyLg9FU/0Ugy7GL7rOuQU3P
	 UaibBf/kfriOD71S7VFeVFazKTfaOTnTqfgQ0MyMgKPX4iiSnenKXvd97soOFYWObm
	 tPq1sQlx7PLP2DqTtyzkwUux+YB5HPMxhCQa4vTCU5DvE46+GMZRDpvXugmQ5NKLEg
	 ye1OJiPeDB7tKVba2LsLeuWO11eUynRrYb2yTN2R44Hhlf0CTj5YmnPda8fNszMOWn
	 AJMvv8iUIxLEw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] ALSA: hda/realtek: Add support for ASUS 2026 Commercial laptops using CS35L41 HDA
Date: Mon, 20 Apr 2026 09:08:11 -0400
Message-ID: <20260420131539.986432-25-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Transfer-Encoding: 8bit

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit 66a6333ba5087b00b7d6cb9ff671f4e2739383b3 ]

Add support for laptops:
- ASUS PM5406CGA
- ASUS PM5606CGA
- ASUS P5406CCA
- ASUS P5606CCA

Laptops use 2 CS35L41 Amps with HDA, using Internal boost, with I2C or
SPI.

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Link: https://patch.msgid.link/20260330134651.443439-3-sbinding@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The insertion point is clear: the 4 new entries (0x3601, 0x3611, 0x3701,
0x3711) go between the existing 0x3391 entry (line 7367) and the 0x3a20
entry (line 7368). The context lines from the diff match perfectly.

Now I have all the information I need for a thorough analysis. Let me
compile my findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `ALSA: hda/realtek`
- Action verb: "Add support"
- Summary: Adding SND_PCI_QUIRK entries for 4 new ASUS commercial laptop
  models to enable CS35L41 HDA audio.
- Record: [ALSA/hda/realtek] [Add] [Hardware quirk entries for 4 ASUS
  laptop models]

**Step 1.2: Tags**
- `Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>` -
  author (Cirrus Logic employee, works on CS35L41 amplifier support)
- `Link: https://patch.msgid.link/20260330134651.443439-3-
  sbinding@opensource.cirrus.com` - patch 3 in a series
- `Signed-off-by: Takashi Iwai <tiwai@suse.de>` - ALSA subsystem
  maintainer accepted it
- No Fixes: tag (expected for new device quirk additions)
- No Reported-by: tag (typical for hardware enablement)
- No Cc: stable tag (expected, hence this review)

**Step 1.3: Commit Body**
- Lists 4 specific ASUS laptop models: PM5406CGA, PM5606CGA, P5406CCA,
  P5606CCA
- Hardware uses 2 CS35L41 amplifiers with HDA, internal boost, via I2C
  or SPI
- No bug description - pure hardware enablement via existing quirk
  infrastructure

**Step 1.4: Hidden Bug Fix Detection**
- This is NOT a hidden bug fix. It is explicitly a hardware quirk
  addition to enable audio on new laptop models. Without these entries,
  audio amplifiers on these 4 laptops would not be properly initialized,
  meaning users get no sound or degraded sound.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- 1 file changed: `sound/hda/codecs/realtek/alc269.c`
- 4 lines added, 0 lines removed
- Changes are within the `alc269_fixup_tbl[]` quirk table

**Step 2.2: Code Flow Change**
- Before: The 4 ASUS SSID values (0x3601, 0x3611, 0x3701, 0x3711) have
  no matching quirk entry, so the CS35L41 amplifiers are not configured
- After: Each SSID maps to its appropriate fixup function
  (`ALC287_FIXUP_CS35L41_I2C_2` for I2C models,
  `ALC245_FIXUP_CS35L41_SPI_2` for SPI models)

**Step 2.3: Bug Mechanism**
- Category (h): Hardware workarounds - Device-specific quirk table
  entries
- These are `SND_PCI_QUIRK()` entries in the HDA codec's quirk table,
  the standard mechanism for enabling amplifier support on specific
  laptops

**Step 2.4: Fix Quality**
- Obviously correct: follows identical pattern to dozens of existing
  entries for the same vendor (0x1043 = ASUS) using the same fixup IDs
- Minimal: exactly 4 lines, each a self-contained quirk table entry
- Zero regression risk: only affects devices with these specific SSID
  values
- Author is a Cirrus Logic engineer who maintains the CS35L41 driver

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
- The quirk table area is from commit aeeb85f26c3bbe (Takashi Iwai,
  2025-07-09) which was a large refactoring/move of the file
- The `ALC287_FIXUP_CS35L41_I2C_2` fixup has been present since at least
  6.x era, well-established

**Step 3.2: Fixes tag** - N/A (no Fixes: tag, expected for quirk
additions)

**Step 3.3: File History**
- The file has very frequent quirk additions (verified: recent commits
  are almost all "Add quirk for X" style)
- Stefan Binding has multiple prior identical commits (e.g.,
  0156c22fb0ca8 adding ASUS PM3406CKA and PM3606CKA)

**Step 3.4: Author**
- Stefan Binding works at Cirrus Logic (sbinding@opensource.cirrus.com),
  the company that makes the CS35L41 amplifier
- He is the primary contributor for CS35L41 HDA quirk additions
- The patch was accepted by Takashi Iwai, the ALSA maintainer

**Step 3.5: Dependencies**
- Both fixup types (`ALC287_FIXUP_CS35L41_I2C_2` at line 6248 and
  `ALC245_FIXUP_CS35L41_SPI_2` at line 6262) exist in the 7.0 tree
- The context lines match the current tree (0x3391 PM3606CKA followed by
  0x3a20)
- This is fully standalone - no other patches needed

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1:** The Link tag indicates this is patch 3 of a series
(443439-3). Lore is blocked by anti-bot measures. However, the identical
pattern of prior commits from the same author (e.g., 0156c22fb0ca8) was
a v1 single patch that was simply adding quirk entries - no controversy
expected.

**Step 4.2:** Accepted by Takashi Iwai (ALSA maintainer) directly.
Stefan Binding is the recognized CS35L41 maintainer at Cirrus Logic.

**Step 4.3-4.5:** No bug report - this is hardware enablement. No
stable-specific discussion expected for quirk additions.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1:** No functions modified - only data table entries added.

**Step 5.2-5.4:** The `SND_PCI_QUIRK` macro adds an entry to a static
lookup table. When a matching PCI subsystem ID is found, the
corresponding fixup function is called during codec initialization. The
fixup functions (`cs35l41_fixup_i2c_two`, `cs35l41_fixup_spi_two`) are
well-established and used by 100+ other entries.

**Step 5.5:** Over 100 identical entries exist for ASUS laptops in this
same table using these same fixup IDs.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1:** The quirk table and both fixup types exist in all active
stable trees (they've been present since at least 6.1). The new SSID
values are for new hardware that doesn't have entries yet.

**Step 6.2:** The patch should apply cleanly - it's inserting lines at a
well-defined sorted position in a table. Minor context-line offset
adjustments may be needed depending on how many entries are already in
each stable tree.

**Step 6.3:** No related fixes needed - these are new device IDs.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1:** ALSA/HDA - audio subsystem. IMPORTANT criticality - audio
is essential for laptop users.

**Step 7.2:** Very actively developed - constant quirk additions for new
hardware.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1:** Users of these 4 specific ASUS commercial laptop models
(PM5406CGA, PM5606CGA, P5406CCA, P5606CCA).

**Step 8.2:** Trigger: boot with this hardware. Without the quirk,
CS35L41 amplifiers are not configured, meaning no sound or broken sound.

**Step 8.3:** Without quirk: non-functional or degraded audio on these
laptops. Severity: MEDIUM-HIGH (audio completely broken on specific
hardware).

**Step 8.4:**
- Benefit: HIGH - enables audio on 4 new laptop models for stable tree
  users
- Risk: VERY LOW - 4 lines of data-only additions to a lookup table,
  using existing fixup functions, affecting only devices with matching
  SSIDs
- Ratio: Excellent benefit-to-risk

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence FOR backporting:**
- Pure hardware quirk addition (exception category: YES automatically)
- 4 lines, data-only, zero code logic change
- Uses well-established fixup types with 100+ existing users
- Author is the Cirrus Logic CS35L41 maintainer
- Accepted by ALSA subsystem maintainer Takashi Iwai
- Enables audio on commercial laptops that stable users would use
- Identical pattern to many prior commits that have gone to stable

**Evidence AGAINST:**
- None identified

**Step 9.2: Stable Rules Checklist:**
1. Obviously correct? YES - identical pattern to 100+ existing entries
2. Fixes real bug? YES - enables broken audio hardware
3. Important issue? YES - no audio on affected laptops
4. Small and contained? YES - 4 lines in 1 file
5. No new features? Correct - uses existing fixup infrastructure
6. Can apply to stable? YES - all dependencies exist in stable trees

**Step 9.3: Exception Category:**
This is a **hardware quirk/workaround** addition - one of the explicitly
allowed exception categories that is automatically YES for stable.

## Verification

- [Phase 1] Parsed tags: Link shows patch 3 of series, SOBs from author
  (Cirrus Logic) and Takashi Iwai (ALSA maintainer)
- [Phase 2] Diff analysis: 4 lines added to SND_PCI_QUIRK table in
  `alc269_fixup_tbl[]`, purely data additions
- [Phase 2] Verified both fixup types exist:
  `ALC287_FIXUP_CS35L41_I2C_2` at line 6248,
  `ALC245_FIXUP_CS35L41_SPI_2` at line 6262
- [Phase 3] git blame: insertion area is stable, context lines (0x3391
  at line 7367, 0x3a20 at line 7368) match the diff
- [Phase 3] Verified identical prior commit 0156c22fb0ca8 by same author
  adding ASUS PM3406CKA/PM3606CKA
- [Phase 3] Author Stefan Binding has 10+ commits for CS35L41 quirk
  additions in this file
- [Phase 5] Both fixup functions (`cs35l41_fixup_i2c_two`,
  `cs35l41_fixup_spi_two`) are defined and used by 100+ entries
- [Phase 6] Fixup infrastructure exists in stable tree (verified in 7.0
  tree)
- [Phase 8] Risk assessment: 4 data-only lines, VERY LOW regression risk
- UNVERIFIED: Could not access lore.kernel.org for mailing list
  discussion (anti-bot protection); however, this has no bearing on the
  decision since the commit type (hardware quirk addition) is
  automatically a YES category.

This is a textbook hardware quirk addition: 4 `SND_PCI_QUIRK` entries
adding PCI subsystem IDs for new ASUS laptops to enable existing CS35L41
amplifier support. It is data-only, uses well-established fixup
infrastructure, was authored by the Cirrus Logic CS35L41 maintainer, and
accepted by the ALSA subsystem maintainer. It falls squarely into the
"hardware quirk" exception category that is always appropriate for
stable.

**YES**

 sound/hda/codecs/realtek/alc269.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 45f9d64873885..d86781e976ac0 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7365,6 +7365,10 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x31e1, "ASUS B5605CCA", ALC294_FIXUP_ASUS_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x31f1, "ASUS B3605CCA", ALC294_FIXUP_ASUS_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x3391, "ASUS PM3606CKA", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x1043, 0x3601, "ASUS PM5406CGA", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x1043, 0x3611, "ASUS PM5606CGA", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x1043, 0x3701, "ASUS P5406CCA", ALC245_FIXUP_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1043, 0x3711, "ASUS P5606CCA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x3a20, "ASUS G614JZR", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
 	SND_PCI_QUIRK(0x1043, 0x3a30, "ASUS G814JVR/JIR", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
 	SND_PCI_QUIRK(0x1043, 0x3a40, "ASUS G814JZR", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
-- 
2.53.0

