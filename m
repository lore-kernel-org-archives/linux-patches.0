Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CAA55F972;
	Mon, 31 Aug 2026 13:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184057; cv=none; b=DXfbNLPZmSjsYB8qtKD3NJ+4y5lpNQWQO7iAryS8JfkbQRePug/S0AW/olOIVwYWmQcBWIArqyAemrv/gc6ehO/oFJNurbU+A794uOfT7KJjNKLziRlCoh93XyvbkI5wHLmN9Clw+gThwCUrKmlHi7+RRVTwWPRxsGVgWne5X8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184057; c=relaxed/simple;
	bh=44aSCLil5K1oQx2EdutGR9G20dQM6nP9QzGg9B9B7xE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r2T1cISRee1kfsyz3P0V/OMETtzmr/fKRZtylN3587Icc+IoldUohvQoc3WNMbhYAJGFfcuvI+HCTTf5Q6gEJWq/UgxqbAH2UlyEdeRxtfd06n72RTp8W9JxZtxTnSu8EeP92W7s0gV5ZlKLN+Yf8rI6Lpd0C/jfDL0aOMwZFGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cPb8JApy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cPb8JApy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6184F1F00A3F;
	Mon, 31 Aug 2026 13:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184054;
	bh=4k5LOiCtW72h2pqHH8HSiv4C8+Pr6/EAJf7KCOrU7ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cPb8JApynlapLpsnidtkoUWCLuQ1z98V9fOu5oLH5YacI2TKzHJaclLvSPXlqzHFC
	 CwZGYqRrbHt6piofwa4S9wH+/kTy3v0S9d2VwAUbIjWYgs1fOZYzgUMnKyi7EOGQbr
	 jpmF7oV71n0uNm9U/9/u8BY6N/4FWZMUUEwo8ROkHsCUzRHqfRfVKE4q8gUsOJJbDC
	 0W15n/cCQNlaR9PNroDhf4gbN3ZzAaEOilcTsWgLzAPcmxHsWLQ7MHKcVflbcAulIa
	 /fA6seOwWh6gXthjclPDWyDjWmvwjDJ0bMMfR2EPDFEBciEcHptl3x4CTstl77lir0
	 t/9/APmbO+IqQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Michael Diesen <michael.diesen@posteo.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ALSA: hda/realtek: Add quirk for HP Dragonfly Folio G3 2-in-1 (103c:8a05)
Date: Mon, 31 Aug 2026 09:28:12 -0400
Message-ID: <20260831133314.4125787-464-sashal@kernel.org>
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

From: Michael Diesen <michael.diesen@posteo.de>

[ Upstream commit bed0c8084044364f5ac3f3e89e1bbad423f6b0d4 ]

The HP Dragonfly Folio G3 2-in-1 also ships with PCI SSID 103c:8a05.
On this unit the ALC245 codec reports subsystem id 103c:8a06 - the SSID
that is already covered by commit 0a10faad5ca5 ("ALSA: hda/realtek: add
quirk for HP Dragonfly Folio G3 2-in-1") - while the PCI SSID that
SND_PCI_QUIRK matches against is 103c:8a05:

  snd_hda_codec_alc269 ehdaudio0D0: ALC245: picked fixup for PCI SSID 103c:8a05
  cs35l41-hda spi1-CSC3551:00-cs35l41-hda.0: CS35L41 Bound - SSID: 103C8A06

The existing entry therefore never applies here, the four CS35L41
amplifiers on SPI are not registered and the internal speakers stay
silent.

Add the same fixup that the 8a06 entry uses: the four amplifiers bind
and the speaker mute LED (codec GPIO 0x04) works.

Signed-off-by: Michael Diesen <michael.diesen@posteo.de>
Link: https://patch.msgid.link/20260727091920.4634-1-michael.diesen@posteo.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[ALSA: hda/realtek]` `[Add]` — Add PCI quirk for HP
Dragonfly Folio G3 2-in-1 with SSID `103c:8a05`.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Michael Diesen `<michael.diesen@posteo.de>`
  (author)
- **Link:** `https://patch.msgid.link/20260727091920.4634-1-
  michael.diesen@posteo.de`
- **Signed-off-by:** Takashi Iwai `<tiwai@suse.de>` (ALSA/HDA
  maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable@vger.kernel.org`
- Notable: maintainer sign-off from Takashi Iwai; no syzbot/fuzzer
  involvement

### Step 1.3: Body Analysis
**Record:**
- **Bug:** Some HP Dragonfly Folio G3 2-in-1 units expose PCI SSID
  `103c:8a05`, while the codec subsystem ID is `103c:8a06`. The existing
  quirk added by upstream `0a10faad5ca5` only matches `103c:8a06`.
- **Symptom:** Wrong/no fixup selected; four CS35L41 SPI amplifiers
  never bind; internal speakers stay silent; speaker mute LED (GPIO
  0x04) does not work.
- **Evidence in message:** dmesg shows `picked fixup for PCI SSID
  103c:8a05` but CS35L41 binds with SSID `103C8A06` — mismatch between
  PCI and codec SSIDs.
- **Root cause (author):** `SND_PCI_QUIRK` matching uses PCI SSID, so
  the `8a06` entry never applies on `8a05` hardware variants.
- **Fix approach:** Add `103c:8a05` entry using the same fixup as
  `8a06`: `ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED`.

### Step 1.4: Hidden Bug Fix?
**Record:** Not disguised — this is an explicit hardware quirk fix for
broken audio on a specific laptop model. Classic audio driver quirk
pattern.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **Files:** `sound/hda/codecs/realtek/alc269.c` only (+1 line)
- **Functions modified:** None directly; `alc269_fixup_tbl[]` quirk
  table only
- **Scope:** Single-file, one-line surgical addition

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `snd_hda_pick_fixup()` walks `alc269_fixup_tbl[]`; for PCI
  SSID `103c:8a05`, no matching `SND_PCI_QUIRK` entry → wrong or no
  CS35L41 SPI fixup → amplifiers not probed.
- **After:** PCI SSID `103c:8a05` matches new entry →
  `ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED` selected →
  `cs35l41_fixup_spi_four()` runs → four SPI CS35L41 amps bind; GPIO LED
  fixup chains.
- **Path affected:** Normal HDA codec probe/initialization on affected
  hardware.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Hardware quirk / logic correctness (wrong fixup
  selection due to PCI vs codec SSID mismatch)
- **Mechanism:** `snd_hda_pick_fixup()` matches PCI subsystem
  vendor/device for standard `SND_PCI_QUIRK` entries (see
  ```1066:1078:sound/hda/common/auto_parser.c```). Existing `8a06` entry
  cannot match `8a05` PCI SSID.

### Step 2.4: Fix Quality
**Record:**
- **Obviously correct:** Yes — duplicates the proven fixup already used
  for the same laptop model (`8a06` entry, present in this tree at line
  6842).
- **Minimal:** One line, no unrelated changes.
- **Regression risk:** Very low — only affects machines with PCI SSID
  `103c:8a05`; uses existing, tested fixup type.
- **Red flags:** None.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:**
- `0x8a06` Dragonfly Folio G3 quirk introduced by `302eb87651326`
  (upstream `0a10faad5ca5`), committed to this tree 2026-08-09.
- `0x8a05` entry does **not** exist in this tree (`git log -S "0x8a05"`
  on `alc269.c` returns empty).
- The incomplete coverage (only `8a06`) has existed since the
  prerequisite landed ~1 week before HEAD.

### Step 3.2: Fixes: Tag
**Record:** No `Fixes:` tag. Prerequisite commit referenced in message
body: `0a10faad5ca5` — present in this tree as `302eb87651326`. That
commit added the incomplete `8a06`-only quirk; this commit completes
coverage for the `8a05` PCI variant.

### Step 3.3: Related File History
**Record:** Recent related commits in this tree:
- `302eb87651326` — add quirk for HP Dragonfly Folio G3 (`8a06`)
- `6b2c0cd5f9689` — Fix speakers on Legion Pro 7 with mismatched
  codec/PCI SSID (same class of bug, already backported here)
- `7484669d1fbab`, `12e43f99242b0` — other quirk additions

Standalone fix; not part of a multi-patch series.

### Step 3.4: Author Context
**Record:** Michael Diesen has no prior commits in
`sound/hda/codecs/realtek/` in this tree. Patch carries maintainer sign-
off from Takashi Iwai.

### Step 3.5: Dependencies
**Record:**
- **Requires:** `ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED` fixup type and
  `302eb87651326` (`8a06` quirk) — both present in this tree.
- **Can apply standalone:** Yes — single-line table entry insertion
  immediately before existing `8a06` line.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:** UNVERIFIED — `b4 dig -c <commit>` could not be run (commit
not present in this checkout). `WebFetch` and `curl` to
lore.kernel.org/patch.msgid.link blocked by Anubis bot protection.

### Step 4.2: Reviewers
**Record:** UNVERIFIED via b4 dig -w. Commit message shows Takashi Iwai
(subsystem maintainer) as committer sign-off.

### Step 4.3: Bug Report
**Record:** No external bug tracker link. Author-provided dmesg excerpts
in commit message serve as reproduction evidence.

### Step 4.4: Related Patches
**Record:** Follow-up to `0a10faad5ca5` / `302eb87651326`. Same pattern
as `6b2c0cd5f9689` (Legion Pro dual-SSID speaker fix, already in
6.18.y).

### Step 4.5: Stable List History
**Record:** UNVERIFIED — could not search lore.kernel.org/stable due to
bot protection.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:**
- `alc269_fixup_tbl[]` — quirk table (modified)
- `snd_hda_pick_fixup()` — fixup selection (caller, unchanged)
- `cs35l41_fixup_spi_four()` — fixup handler for selected entry
  (unchanged)
- `alc269_probe()` — calls `snd_hda_pick_fixup()` during codec probe

### Step 5.2: Callers
**Record:** `alc269_probe()` → `snd_hda_pick_fixup(codec,
alc269_fixup_models, alc269_fixup_tbl, alc269_fixups)` at line 8471.
Called during HDA codec driver probe on every Realtek ALC269-family
codec initialization.

### Step 5.3: Callees
**Record:** Selected fixup `ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED`
calls `cs35l41_fixup_spi_four()` which calls `comp_generic_fixup()` to
bind four SPI CS35L41-HDA amplifiers, then chains
`ALC285_FIXUP_HP_GPIO_LED` for mute LED.

### Step 5.4: Reachability
**Record:** Triggered at boot/module load when `snd-hda-intel` probes
the HDA codec on HP Dragonfly Folio G3 hardware with PCI SSID
`103c:8a05`. Common laptop audio path; affects all users of that
hardware variant.

### Step 5.5: Similar Patterns
**Record:** Multiple HP laptops in the same table use
`ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED` (e.g., `0x89c3`, `0x8a06`,
`0x8b63`). Same dual-SSID pattern fixed for Lenovo Legion Pro in
`6b2c0cd5f9689`.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** Tree is `v6.18.44` / `6.18.44` on
`stable/linux-6.18.y`. File `sound/hda/codecs/realtek/alc269.c` exists
with `0x8a06` Dragonfly quirk at line 6842 but **no** `0x8a05` entry.
The bug (incomplete SSID coverage) is live in this tree since
`302eb87651326` landed.

### Step 6.2: Backport Complications
**Record:** **Clean apply expected** — one-line insertion before
existing `8a06` entry. Table is already sorted (`8a05` < `8a06`). No
structural divergence from mainline diff context.

### Step 6.3: Related Fixes Already Present?
**Record:** Prerequisite `302eb87651326` (`8a06` quirk) is an ancestor
of HEAD. No `8a05` fix found. No duplicate fix for this SSID.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem
**Record:** `sound/hda` — Realtek HDA codec driver. **Criticality:
IMPORTANT** (peripheral driver, but affects core laptop functionality
for affected users).

### Step 7.2: Activity
**Record:** Actively maintained — multiple quirk commits in recent
6.18.y history (TongFang, Legion, HP, Samsung, Lenovo entries in last
~20 commits).

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of HP Dragonfly Folio G3 2-in-1 laptops reporting PCI
SSID `103c:8a05` with ALC245 codec. Driver-specific, platform-specific.

### Step 8.2: Trigger Conditions
**Record:** Every boot on affected hardware when HDA codec probes. Not
timing-dependent. Not userspace-triggerable for exploitation; hardware
identity match only. **Likelihood:** Certain on affected units.

### Step 8.3: Failure Mode Severity
**Record:** Internal speakers completely non-functional; CS35L41
amplifiers not registered; mute LED broken. **Severity: MEDIUM** —
functional hardware breakage, not kernel crash/corruption, but makes the
machine's primary audio output unusable without workarounds.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Restores speaker audio and mute LED on affected premium
  laptops; completes fix started by `302eb87651326`.
- **Risk:** Very low — one-line quirk using existing fixup, narrow
  hardware match.
- **Ratio:** Strongly favorable.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real hardware bug with documented dmesg evidence
- Silent internal speakers on affected laptop model
- One-line hardware quirk — textbook stable exception category
- Uses existing, proven fixup already in tree
- Prerequisite commit already backported to 6.18.y
- ALSA maintainer (Takashi Iwai) sign-off
- Same dual-SSID pattern already accepted in this tree (`6b2c0cd5f9689`)
- Trivial, obviously correct change

**AGAINST backport:**
- No kernel crash, security issue, or data corruption
- Affects only one hardware variant
- Mailing list review details unverified

**UNRESOLVED:**
- Full lore.kernel.org review thread inaccessible
- No explicit `Tested-by:` in commit message

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — mirrors existing `8a06`
   entry; author tested on hardware per message
2. Fixes a real bug affecting users? **PASS** — silent speakers on real
   laptop
3. Important issue? **PASS** — complete loss of internal speaker audio
   (MEDIUM severity hardware functionality)
4. Small and contained? **PASS** — 1 line, 1 file
5. No new features or APIs? **PASS** — hardware quirk only
6. Can apply to local tree? **PASS** — prerequisite present, clean one-
   line apply

### Step 9.3: Exception Category
**Record:** Hardware quirk/workaround for broken/misidentified PCI SSID
on existing supported hardware. Automatic stable qualification per
documented exception rules.

### Step 9.4: Decision Rationale
This commit completes speaker support for HP Dragonfly Folio G3 2-in-1
on the 6.18.y stable tree. The prerequisite `8a06` quirk was already
backported but only covers one PCI SSID variant; units with `103c:8a05`
still have silent speakers. The fix is a single `SND_PCI_QUIRK` line
reusing an existing fixup — minimal risk, clear user benefit, and
directly analogous to other speaker quirk fixes already accepted in this
stable series.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message
- [Phase 1] Identified maintainer sign-off (Takashi Iwai), Link: tag
  present
- [Phase 2] Diff analysis: +1 line in `alc269_fixup_tbl[]`,
  `SND_PCI_QUIRK(0x103c, 0x8a05, ...)`
- [Phase 3] `git describe HEAD`: `v6.18.44`; `make kernelversion`:
  `6.18.44`
- [Phase 3] `git blame` line 6842: `8a06` quirk from `302eb87651326`
- [Phase 3] `git log -S "0x8a05" -- sound/hda/codecs/realtek/alc269.c`:
  empty (fix not in tree)
- [Phase 3] `git show 302eb87651326`: prerequisite adds `8a06` quirk,
  upstream `0a10faad5ca5`
- [Phase 3] `git merge-base --is-ancestor 302eb87651326 HEAD`:
  prerequisite confirmed in tree
- [Phase 3] `git show 6b2c0cd5f9689`: similar dual-SSID speaker fix
  already in 6.18.y
- [Phase 4] `b4 dig -c`: not run — commit not in checkout
- [Phase 4] UNVERIFIED: lore.kernel.org and patch.msgid.link blocked by
  Anubis
- [Phase 5] Read `snd_hda_pick_fixup()` at
  `sound/hda/common/auto_parser.c:1066-1078`: PCI SSID matching
  confirmed
- [Phase 5] Read `ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED` at
  `alc269.c:6158-6162`: uses `cs35l41_fixup_spi_four`
- [Phase 5] Read `cs35l41_fixup_spi_four()` at `alc269.c:3218-3221`:
  binds 4 SPI amplifiers
- [Phase 5] `alc269_probe()` calls `snd_hda_pick_fixup()` at line 8471
- [Phase 6] Grep `0x8a05` in `alc269.c`: not found; `0x8a06` at line
  6842 present
- [Phase 6] Fixup type `ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED` exists
  with multiple other HP entries
- [Phase 6] `cs35l41_hda` driver files present under
  `sound/hda/codecs/side-codecs/`
- [Phase 7] `git log --oneline -20 -- sound/hda/codecs/realtek/`: active
  quirk maintenance
- [Phase 8] Failure mode: silent speakers, not kernel crash — MEDIUM
  severity

**YES**The background searches finished and match the earlier analysis:

- **`8a05` quirk search:** No commit adding `103c:8a05` to `alc269.c`
  exists in this 6.18.44 tree.
- **Michael Diesen commit search:** No matching commit from that author;
  unrelated `8a05` hits elsewhere in history are not this ALSA fix.

So the prerequisite `8a06` quirk is present, but the `8a05` entry is
still missing — backporting this one-line quirk to 6.18.y is warranted.

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 2a0a1891ac423..5a0672fc82284 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6891,6 +6891,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x89d3, "HP EliteBook 645 G9 (MB 89D2)", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x89da, "HP Spectre x360 14t-ea100", ALC245_FIXUP_HP_SPECTRE_X360_EU0XXX),
 	SND_PCI_QUIRK(0x103c, 0x89e7, "HP Elite x2 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8a05, "HP Dragonfly Folio G3 2-in-1", ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a06, "HP Dragonfly Folio G3 2-in-1", ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a0f, "HP Pavilion 14-ec1xxx", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a1b, "HP 255 15.6 inch G9 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
-- 
2.53.0

