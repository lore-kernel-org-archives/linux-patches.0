Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8070644AB7E;
	Mon, 31 Aug 2026 13:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183257; cv=none; b=aeg3BJ7XELc+eGrZU8m/4ZbXsgjOv4BJS3zThhxQETmkc/Nm4IFfnp3tr8cM6x07EkCrqMWtofhBaCTK/Il7J8yLRsDdf6+GTql5r4UcR6VhQfidgoWZV8rDAQbWzgPL7WcwYHHIOvneVSrCC/S3MkoywMurd+MiFe+XBTrQ6Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183257; c=relaxed/simple;
	bh=eplsoB8XcdCHOn29nnpUEDBavp5+zZA4qmphKFD2drQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LBM3WFhODmO7IfWeEAntfGXerBliJDQta9Ifh16K6bUVKJIvN0XmMAIdTaR+xg/Ujcidk5dvEsEzwXKEFQW1y4z2wwHq5FpsgpAhrUInI0E/WW6cx9YbU2FYvowMuoI73nNyNvbgxVtbvf234GJxiALUqJ6956A9pOF7e+YqliM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RlDrtLrs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RlDrtLrs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714651F00A3D;
	Mon, 31 Aug 2026 13:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183255;
	bh=y7BXraG1NpBGvrW7HSrRNIvifCQAbZN3HiJzIJzsVz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RlDrtLrsobJVtoGgks37zpSCzqyliSMP+nP6tEegg6UlbVznm029c7i6bVUOwMGV5
	 tsN0iFmGpToxnR24VxbJytLt0sZEmsAvoUWOdG7MBBWFKbqaAesXgNqp0MNovmreLv
	 GUi/wfnfEcHu3fOf1hNL0jDgwkil2PwuaJG+NatThyJeNgzUSrdLvZ3J1KsHzY+tHo
	 +wzze75hDHUK9S8Z49kwYRb7wMBf+UCU5Y0LKkOPoGuBQR3N4iF7p++0GWDrBlr8GF
	 QyxNgjxJN/gqjueD9UcHfH0fA11qU9mi0ztR25YeH9zrjyflagNNojcN7DnfKNrrsd
	 iLvzVw6G3xIMg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Marcel=20K=C5=82os?= <marcel@marmak.net.pl>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] ALSA: hda/realtek: Add quirk for HP EliteBook 830 G8 (8AB8) to enable mute LEDs
Date: Mon, 31 Aug 2026 09:21:07 -0400
Message-ID: <20260831133314.4125787-39-sashal@kernel.org>
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

From: Marcel Kłos <marcel@marmak.net.pl>

[ Upstream commit 728d34ebf91c0e80b63a66b237dd0dfc5a8e5b4d ]

The sound and microphone mute LEDs do not function on this newer
revision of the board (8AB8) while they do on the older 880D models.
I have verified this on another laptop which was manufactured before
the one with the issue.
Added the ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED from a G9 model, which
uses the same codec, to make it work. Tested on kernel version 7.1.3 on
the aforementioned newer revision notebook.

Signed-off-by: Marcel Kłos <marcel@marmak.net.pl>
Link: https://patch.msgid.link/4dab5622-9100-4730-8c99-b58da939549b@marmak.net.pl
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: HP EliteBook 830 G8 (8AB8) Mute LED Quirk

**Local tree:** `v6.18.44` (kernel 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[ALSA: hda/realtek]` `[Add]` — Add quirk for HP EliteBook
830 G8 (8AB8) to enable mute LEDs

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Signed-off-by:** Marcel Kłos `<marcel@marmak.net.pl>` (author)
- **Signed-off-by:** Takashi Iwai `<tiwai@suse.de>` (ALSA maintainer —
  applied to mainline tree)
- **Link:** https://patch.msgid.link/4dab5622-9100-4730-8c99-
  b58da939549b@marmak.net.pl
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable@vger.kernel.org tags
- Notable: maintainer Signed-off-by indicates acceptance; no syzbot or
  multi-reporter signals

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug:** Sound and microphone mute LEDs do not function on the newer
  board revision (MB 8AB8, PCI SSID `0x103c:0x8ab8`)
- **Symptom:** Mute LEDs stay non-functional; audio itself is not
  described as broken
- **Comparison:** Older 880D revision works with existing quirk; author
  verified on two laptops (old works, new broken)
- **Root cause (author):** Newer revision needs
  `ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED` (CS35L41 SPI amplifier init
  chained with HP GPIO LED fixup), same as G9 models with the same codec
- **Testing:** Author tested on kernel 7.1.3 on affected hardware
- **Version info:** None explicit beyond author's test kernel

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not a hidden bug fix — this is an explicit hardware quirk
addition. It fixes broken mute/mic-mute LED feedback on a specific
laptop model. Not a crash, leak, or race; a hardware-
enablement/workaround fix.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- **Files:** `sound/hda/codecs/realtek/alc269.c` — +1 line, 0 removals
- **Function/table:** `alc269_fixup_tbl[]` (static quirk table)
- **Scope:** Single-file, single-line surgical addition

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Record:**
- **Before:** PCI SSID `0x103c:0x8ab8` has no matching `SND_PCI_QUIRK`
  entry. `snd_hda_pick_fixup()` at probe time finds no match; device
  gets default codec setup without CS35L41 SPI init or HP GPIO LED fixup
  chain.
- **After:** `0x103c:0x8ab8` maps to
  `ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED`, which chains
  `cs35l41_fixup_spi_two` → `ALC285_FIXUP_HP_GPIO_LED`.
- **Path affected:** HDA codec probe initialization path for this
  specific HP laptop only.

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Record:**
- **Category:** Hardware workaround / codec quirk
- **Mechanism:** Newer EliteBook 830 G8 board revision uses CS35L41 SPI
  amplifiers (like G9 models) but was missing from the quirk table. The
  older `0x880d` entry uses only `ALC285_FIXUP_HP_GPIO_LED` (no CS35L41
  SPI init). Without the correct quirk, GPIO LED control is never
  configured, so mute LEDs don't respond.

### Step 2.4: ASSESS THE FIX QUALITY
**Record:**
- **Quality:** Obviously correct pattern — identical fixup already used
  for ~20+ HP models in this tree (e.g., `0x8abb`, `0x8ad1`,
  `0x8b42`–`0x8b47`)
- **Minimal:** One line, no unrelated changes
- **Regression risk:** Very low — fixup is proven on same-vendor G9
  hardware with same codec; author tested on affected machine. Worst
  case would be incorrect LED behavior on misidentified hardware, not
  audio breakage (author reports audio works without quirk)

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:**
- Adjacent entry `0x880d` ("HP EliteBook 830 G8") blamed to
  `5d324e5159d9e` (v6.18-rc8 merge, Nov 2025) with
  `ALC285_FIXUP_HP_GPIO_LED`
- Adjacent entry `0x8ab9` ("HP EliteBook 840 G8 (MB 8AB8)") same commit,
  `ALC285_FIXUP_HP_GPIO_LED`
- `0x8ab8` is absent — the gap this commit fills
- `ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED` fixup infrastructure present
  since same merge era

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** No Fixes: tag present. N/A.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:**
- Many similar mute-LED quirk commits in this tree: `89ed38540e6be`,
  `7556bd5cd8ef3`, `8db3663d3c3e2`, `bee43f7b9bc62`, etc.
- Standalone one-off quirk, not part of a multi-patch series
- No prerequisites beyond existing
  `ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED` infrastructure (confirmed
  present)

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** No prior commits from Marcel Kłos in `sound/hda/` in this
tree. First-time contributor patch; accepted by maintainer Takashi Iwai.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:**
- **Dependency:** `ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED` enum, fixup
  definition, and `cs35l41_fixup_spi_two()` — all present in 6.18.44
- **Standalone:** Yes — single quirk table entry, no series dependencies
- `git apply --check` on the mbox: **applies cleanly**

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
**Record:**
- Retrieved via `b4 am` from Link URL; saved as `20260714_marcel_alsa_hd
  a_realtek_add_quirk_for_hp_elitebook_830_g8_8ab8_to_enable_mute_leds.m
  bx`
- Thread: 2 messages, patch only (no review replies in mbox)
- No stable nominations, NAKs, or reviewer comments in retrieved thread
- lore.kernel.org fetch blocked by bot protection; relied on local mbox

### Step 4.2: CHECK WHO REVIEWED THE PATCH
**Record:** Maintainer Takashi Iwai Signed-off-by on committed version.
Original mbox had no Reviewed-by/Acked-by. CC list not retrieved (b4 dig
-w not run on commit hash — commit not yet in this tree).

### Step 4.3: SEARCH FOR THE BUG REPORT
**Record:** No external bug report Link: or Reported-by:. Bug reported
by author directly via patch submission. Severity: mute LED non-
functionality on specific laptop hardware.

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
**Record:** Standalone patch, not part of a series. Related context:
`0x880d` quirk for older EliteBook 830 G8 revision already in tree.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
**Record:** Not searched separately; no stable discussion found in patch
thread. N/A for decision — absence of Cc: stable is expected per
instructions.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
**Record:** Modified data: `alc269_fixup_tbl[]`. Invoked fixup chain:
`cs35l41_fixup_spi_two` → `alc285_fixup_hp_gpio_led` via
`ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED`.

### Step 5.2: TRACE CALLERS
**Record:**
- `snd_hda_pick_fixup(codec, alc269_fixup_models, alc269_fixup_tbl,
  alc269_fixups)` called from Realtek codec init at line 8471
- Triggered during HDA codec probe on boot / module load when
  `CONFIG_SND_HDA_CODEC_REALTEK` is enabled
- Only affects machines matching PCI SSID `0x103c:0x8ab8`

### Step 5.3: TRACE CALLEES
**Record:**
- `cs35l41_fixup_spi_two` → `comp_generic_fixup(..., "spi", "CSC3551",
  ..., 2)` — binds CS35L41 SPI amplifier components
- Chained to `alc285_fixup_hp_gpio_led` — configures HP mute LED GPIO
  behavior

### Step 5.4: FOLLOW THE CALL CHAIN
**Record:** Boot-time codec probe → PCI SSID match in quirk table →
fixup applied. Not userspace-triggerable; affects only owners of this
specific HP laptop model. Common enterprise laptop (EliteBook 830 G8).

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
**Record:** `ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED` already used
extensively for HP G9/G11/ZBook models in the same table (20+ entries).
This is the established pattern for HP laptops with CS35L41 SPI amps
needing mute LED support.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
**Record:** **Yes.** Tree is 6.18.44. `0x880d` EliteBook 830 G8 quirk
exists (older revision, `ALC285_FIXUP_HP_GPIO_LED`). `0x8ab8` is
**missing** — the bug (no quirk for newer revision) is present. All
fixup infrastructure exists.

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
**Record:** **Clean apply.** `git apply --check` on mbox succeeded.
Insertion point (before `0x8ab9` entry at line 6868) matches patch
context exactly. No conflicts expected.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
**Record:** No existing quirk for `0x8ab8`. `git log --grep="830 G8"`
and `--grep="8ab8"` returned no matching fix. This fix is not yet
applied.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
**Record:** **Subsystem:** `sound/hda` — Realtek HDA codec driver.
**Criticality:** PERIPHERAL (laptop-specific audio/LED), but affects a
widely deployed enterprise laptop model.

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
**Record:** `alc269.c` is actively maintained — numerous quirk additions
in recent history on this stable branch. Mute-LED quirk additions are
routine in this subsystem.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
**Record:** **Driver-specific / hardware-specific** — owners of HP
EliteBook 830 G8 with motherboard revision 8AB8 (PCI SSID
`0x103c:0x8ab8`). Requires `CONFIG_SND_HDA_CODEC_REALTEK`.

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
**Record:** Every boot on affected hardware. Deterministic, not a race.
Cannot be triggered by unprivileged users as a security issue — it's a
missing hardware quirk at probe time.

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
**Record:** **Failure mode:** Mute and mic-mute keyboard LEDs do not
reflect audio mute state. **Severity: LOW** — no crash, corruption,
hang, or audio breakage. UX/indicator issue only.

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
**Record:**
- **Benefit:** Restores expected LED behavior for EliteBook 830 G8
  (8AB8) users on 6.18.y; enterprise laptop with real-world deployment
- **Risk:** Very low — 1-line addition using proven, widely-deployed
  fixup chain already in tree
- **Ratio:** Favorable — minimal risk, clear benefit for affected
  hardware owners. Falls squarely in the hardware-quirk exception
  category for stable.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backporting:**
- Hardware codec quirk — explicit stable exception category
- Fixes real, user-verified hardware issue on enterprise laptop
- One line, surgical, uses existing fixup infrastructure
- Applies cleanly to 6.18.44
- Maintainer (Takashi Iwai) Signed-off-by
- Identical fixup pattern proven on 20+ HP models already in tree
- Consistent with numerous similar mute-LED quirk backports in this
  file's history

**AGAINST backporting:**
- Low severity — LEDs only, audio works without fix
- Does not meet "important issue" criteria
  (crash/security/corruption/deadlock) on its own
- No external bug reports beyond author
- No explicit stable nomination in mailing list thread

**UNRESOLVED:**
- lore.kernel.org full thread not accessible (bot protection); relied on
  local mbox (patch only, no discussion)

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — proven fixup chain, author
   hardware-tested, maintainer accepted
2. Fixes a real bug affecting users? **PASS** — mute LEDs broken on
   specific hardware revision
3. Important issue (crash, security, corruption, deadlock)? **PASS (via
   quirk exception)** — not critical severity, but hardware quirk
   category is explicitly stable-appropriate
4. Small and contained? **PASS** — 1 line, 1 file
5. No new features or APIs? **PASS** — quirk table entry only, no new
   fixup type
6. Can apply to local tree? **PASS** — clean apply verified, all
   prerequisites present

### Step 9.3: CHECK FOR EXCEPTION CATEGORIES
**Record:** **Hardware quirk / audio codec quirk** — `SND_PCI_QUIRK`
entry for a specific laptop model using an existing fixup. This is an
explicit stable exception per stable-kernel-rules and the analysis
guidelines.

### Step 9.4: DECISION RATIONALE

This commit adds a one-line PCI quirk for the newer HP EliteBook 830 G8
board revision (`0x8ab8`) that is missing from the 6.18.44 quirk table,
while the older `0x880d` revision is already covered. The fix reuses
`ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED`, which is well-established in
this tree for HP laptops with CS35L41 SPI amplifiers. While mute LED
failure is low severity (no crash or audio breakage), hardware codec
quirks are routinely and appropriately backported to stable — this is
standard ALSA stable material with negligible regression risk and clear
benefit for affected laptop owners.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message
  and mbox
- **[Phase 1]** Tags: Marcel Kłos SOB, Takashi Iwai SOB, Link to
  patch.msgid.link; no Fixes/Reported-by/Cc: stable
- **[Phase 2]** Diff: +1 line in `alc269_fixup_tbl[]`,
  `SND_PCI_QUIRK(0x103c, 0x8ab8, ...)`
- **[Phase 2]** Fixup chain verified at lines 6148–6152:
  `cs35l41_fixup_spi_two` chained to `ALC285_FIXUP_HP_GPIO_LED`
- **[Phase 3]** `git describe HEAD`: v6.18.44-1-g2736c32da98b9; Makefile
  VERSION=6 PATCHLEVEL=18 SUBLEVEL=44
- **[Phase 3]** `git blame` lines 6784, 6868: both adjacent quirks from
  `5d324e5159d9e` (v6.18-rc8 era)
- **[Phase 3]** `git log --grep="830 G8"`: no existing fix for 0x8ab8
- **[Phase 3]** `git apply --check` on mbox: **clean apply**
- **[Phase 4]** `b4 am` on Link URL: retrieved 2-message thread, patch
  content matches
- **[Phase 4]** WebFetch lore.kernel.org: blocked (bot protection); used
  local mbox instead
- **[Phase 5]** `grep ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED`: 20+
  existing usages in alc269.c
- **[Phase 5]** `snd_hda_pick_fixup` call site verified at line 8471
- **[Phase 5]** `cs35l41_fixup_spi_two` defined at line 3208
- **[Phase 6]** `grep 0x8ab8` in alc269.c: **not present** (bug exists)
- **[Phase 6]** `grep 0x880d`: present with `ALC285_FIXUP_HP_GPIO_LED`
  (older revision)
- **[Phase 6]** `ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED` enum and fixup
  definition: **present**
- **[Phase 7]** Recent alc269.c history shows active quirk additions
  (mute LED, HP, Lenovo, etc.)
- **[Phase 8]** Failure mode: mute LED non-functionality, severity LOW;
  benefit for specific HP hardware

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index c7c8c59745a3a..7f3e1c47729a1 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6891,6 +6891,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8aa3, "HP ProBook 450 G9 (MB 8AA1)", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8aa8, "HP EliteBook 640 G9 (MB 8AA6)", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8aab, "HP EliteBook 650 G9 (MB 8AA9)", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8ab8, "HP EliteBook 830 G8 Notebook PC (MB 8AB8)", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ab9, "HP EliteBook 840 G8 (MB 8AB8)", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8abb, "HP ZBook Firefly 14 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ad1, "HP EliteBook 840 14 inch G9 Notebook PC", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
-- 
2.53.0

