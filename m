Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7CC51357A;
	Mon, 31 Aug 2026 13:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183794; cv=none; b=grY0iEo/WwXhWJH1LSs7tsNTdEeIFwZTRj1EWsp346M2HaQ/8x2ti8z0nnBnHZfbwiJXoMxqaRPDANMk5qVBOm4TBodzMRCVrifLANl92Q48wOLfPbDRFxuQlK+/oKdusSJg+vww7darPT8xzwptcqE6MjpRy09olcsjQZQL6yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183794; c=relaxed/simple;
	bh=/rIdjbJQJ2GqgvAPCrKrONnisAn2PgNEyGeY7gU/TkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PP70XhDKeXELTUcTBedM707aNeytj1sYXH2HIjF0q1vlcnIv7r6N+dvRrSQei4j4ZHTfKLEzeo+z5/pyQti11uU4k4WFrSjsLdLtCWjdGmjXfEy2q+CgmkDJrfcY3ozCWr4NJbQpTKX9cUq1b4Xb9mdQ4mUph2WV2ndohPx29Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=difC8JgR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="difC8JgR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BDD91F00A3E;
	Mon, 31 Aug 2026 13:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183791;
	bh=b8I3FUHEB/WhSDy/hA5h+jKXW4Z/GC1dh52DxZX49jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=difC8JgRZHFFULL2ZuRI8AAjAQL49oyr/5IyO/qcwbMxsjWIbv3pmXS4/wdZbX3wR
	 TjHK1FL/suQmkWfrZtexSKkAVS1wPEkPThaaV1PBrm4ahIqs4c+x31deZyeHK/p2BB
	 lqP1RsQV0ffj4qS+PO2vQbv1RCjFrnb2p7G9841fzt9CTn6N3O6w3s2aQcpWl3yXv6
	 ptIl/DSgX3XGX9rvEIMUzLpf1ny9EztQDfoFuRU1LeJRefM5W+kSAPE7XoFZIkrZ3Y
	 M0izGDYgX9NNULbGNlKSjn2yneJFEXHzg6Qq85a2XjII2ypPIEs0vLFDLXorLTPK8R
	 iTVHIwV4OvBKg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Moritz Baron <moritz.baron@stud.uni-hannover.de>,
	Felix Aljoscha Schnuell <felix.aljoscha.schnuell@stud.uni-hannover.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] ALSA: hda/realtek: Add quirk for Lenovo Yoga Pro 7 14IRH8
Date: Mon, 31 Aug 2026 09:25:34 -0400
Message-ID: <20260831133314.4125787-306-sashal@kernel.org>
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

From: Moritz Baron <moritz.baron@stud.uni-hannover.de>

[ Upstream commit 853e10ec445984e99b3c7f6375f4e185614b842a ]

The Lenovo Yoga Pro 7 14IRH8 (ALC287 codec, subsystem ID 0x17aa:0x38b1)
has bass speakers on pin 0x17 that are not routed through a DAC with
volume control. This causes the bass speakers to play at full volume
regardless of the volume slider position.

Apply ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN which corrects the DAC
routing for pin 0x17, enabling proper volume control. This is the same
fix used for other Yoga Pro 7 models with identical audio topology
(14APH8, 14AHP9, 14ASP10, 14IAH10).

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217949

Co-developed-by: Felix Aljoscha Schnuell <felix.aljoscha.schnuell@stud.uni-hannover.de>
Signed-off-by: Felix Aljoscha Schnuell <felix.aljoscha.schnuell@stud.uni-hannover.de>
Signed-off-by: Moritz Baron <moritz.baron@stud.uni-hannover.de>
Link: https://patch.msgid.link/20260609141648.60608-1-moritz.baron@stud.uni-hannover.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 2)...
Retry attempt 2...
# Stable Backport Analysis: ALSA: hda/realtek: Add quirk for Lenovo Yoga
Pro 7 14IRH8

**Local tree:** Linux 6.18.44 (`v6.18.44`)
**Commit under review:** `853e10ec44598` (on `master`, not yet in this
tree)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[ALSA: hda/realtek] [add] quirk for Lenovo Yoga Pro 7
14IRH8 — maps codec SSID 0x17aa:0x38b1 to existing bass-speaker DAC
routing fixup`

### Step 1.2: Tags
**Record:**
- **Link:** https://bugzilla.kernel.org/show_bug.cgi?id=217949
- **Link:**
  https://patch.msgid.link/20260609141648.60608-1-moritz.baron@stud.uni-
  hannover.de
- **Co-developed-by:** Felix Aljoscha Schnuell
- **Signed-off-by:** Felix Aljoscha Schnuell, Moritz Baron, Takashi Iwai
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Cc: stable
- Notable: Bugzilla link documents a long-standing user report; Takashi
  Iwai (ALSA maintainer) merged it

### Step 1.3: Body Analysis
**Record:**
- **Bug:** Lenovo Yoga Pro 7 14IRH8 (ALC287, codec SSID `0x17aa:0x38b1`)
  routes bass speakers on pin 0x17 through a DAC without volume control
- **Symptom:** Bass speakers play at full volume regardless of the
  volume slider
- **Root cause:** Wrong quirk match — machine shares PCI SSID
  `0x17aa:0x3852` with Yoga 7 14ITL5 and gets the wrong `SND_PCI_QUIRK`
  fixup
- **Fix:** Add `HDA_CODEC_QUIRK` for codec SSID `0x17aa:0x38b1` applying
  existing `ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN`
- **Version info:** None explicit; hardware is a 2023-era Lenovo laptop

### Step 1.4: Hidden Bug Fix Detection
**Record:** Not disguised — this is an explicit hardware quirk fix for
broken audio volume control, not cleanup or optimization.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `sound/hda/codecs/realtek/alc269.c` (+4 lines, 0 removed)
- **Functions modified:** `alc269_fixup_tbl[]` static table only
- **Scope:** Single-file, surgical quirk-table addition

### Step 2.2: Code Flow Change
**Record:**
- **Before:** Yoga Pro 7 14IRH8 matches `SND_PCI_QUIRK(0x17aa, 0x3852,
  "Lenovo Yoga 7 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS)` — wrong
  fixup for this hardware
- **After:** `HDA_CODEC_QUIRK(0x17aa, 0x38b1, ...)` is inserted *before*
  the `0x3852` PCI quirk; codec SSID match takes precedence, applying
  `ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN`
- **Path affected:** Codec probe/init during audio driver load (every
  boot for affected hardware)

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Hardware workaround / logic correctness fix
- **Mechanism:** Incorrect pin-to-DAC routing leaves bass speakers on
  DAC 0x06/0x08 (no volume control). The existing fixup function
  `alc287_fixup_yoga9_14iap7_bass_spk_pin()` reroutes pin 0x17 to DAC
  0x02/0x03 with proper volume control

### Step 2.4: Fix Quality
**Record:**
- **Quality:** High — reuses a fixup already applied to Yoga Pro 7
  14APH8, 14AHP9, 14ASP10, 14IAH10, and others in this tree
- **Pattern:** Identical to `b98ecc1c60ad7` (Yoga Pro 7 14IMH9 / codec
  SSID `0x38cf` vs shared PCI SSID `0x3847`)
- **Regression risk:** Very low — only affects machines with codec SSID
  `0x17aa:0x38b1`; `HDA_CODEC_QUIRK` uses `match_codec_ssid = true`

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- Insertion point lines 7435–7438 blame to `b98ecc1c60ad7` (14IMH9
  HDA_CODEC_QUIRK, 2026-03-31) and `aeeb85f26c3bb` (Realtek driver
  split, 2025-07-09) for the `0x3852` PCI quirk
- The mis-match condition (shared PCI SSID) has existed since the
  Realtek driver split; the 14IRH8-specific codec quirk was never added
  until `853e10ec44598`

### Step 3.2: Fixes: Tag
**Record:** No Fixes: tag present — N/A

### Step 3.3: Related File History
**Record:**
- `ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN` fixup function present since
  `aeeb85f26c3bb` (driver split)
- Related quirk additions already in v6.18.44: `634e5e1e06f5c` (14APH8),
  `ad22051afdad9` (14AHP9), `8d70503068510` (14ASP10), `0fa5713ac7a19`
  (14IAH10), `b98ecc1c60ad7` (14IMH9)
- `HDA_CODEC_QUIRK` macro present since at least `e656ef8698e28` in this
  file
- Standalone patch — not part of a series

### Step 3.4: Author Context
**Record:** Moritz Baron / Felix Schnuell are student contributors;
patch merged by Takashi Iwai. No prior commits from these authors in
this tree's realtek path.

### Step 3.5: Dependencies
**Record:**
- **Dependency:** `ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN` fixup —
  **present** in v6.18.44
- **Dependency:** `HDA_CODEC_QUIRK` macro — **present** in
  `sound/hda/common/hda_local.h`
- **Dependency:** `alc287_fixup_yoga9_14iap7_bass_spk_pin()` —
  **present** since driver split
- Can apply standalone: **yes** (`git apply --check` succeeded on HEAD)

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:**
- `b4 dig -c 853e10ec44598` →
  https://patch.msgid.link/20260609141648.60608-1-moritz.baron@stud.uni-
  hannover.de
- `b4 dig -a`: single revision found (no v2/v3 series)
- Lore page blocked by bot protection (Anubis) — could not read thread
  content

### Step 4.2: Reviewers
**Record:** `b4 dig -w` returned only the patch URL; full recipient list
not retrieved. Takashi Iwai Signed-off-by confirms maintainer
acceptance.

### Step 4.3: Bug Report
**Record:**
- Bugzilla #217949: "Yoga Pro 7 14IRH8 volume controls broken" — filed
  2023-09-25, attachment from reporter
- Severity from reporter perspective: broken volume control on a
  commercial laptop
- Long-standing issue (nearly 3 years before fix)

### Step 4.4: Related Patches
**Record:** Same fixup family used across multiple Yoga Pro 7 models;
14IMH9 (`b98ecc1c60ad7`) uses identical `HDA_CODEC_QUIRK` pattern for
shared PCI SSID and is already in v6.18.44

### Step 4.5: Stable List History
**Record:** Not searched on lore stable list (lore blocked). However,
the original 14APH8 quirk (`634e5e1e06f5c`) explicitly had `Cc:
stable@vger.kernel.org`, establishing precedent for this fixup family in
stable.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `alc269_fixup_tbl[]` (modified);
`alc287_fixup_yoga9_14iap7_bass_spk_pin()` (existing, invoked via fixup
chain)

### Step 5.2: Callers
**Record:** `snd_hda_pick_fixup(codec, alc269_fixup_models,
alc269_fixup_tbl, alc269_fixups)` at line 8471, called during Realtek
ALC269 codec probe (`alc269_probe` path). Triggered on every boot when
HDA codec is enumerated.

### Step 5.3: Callees
**Record:** Selected fixup invokes
`alc287_fixup_yoga9_14iap7_bass_spk_pin()` which sets pin config for
0x17 and connects it to DAC 0x02/0x03 (DACs with volume control),
chained to `ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK`

### Step 5.4: Reachability
**Record:** Triggered automatically during kernel audio subsystem init
on affected hardware — no userspace action required beyond normal boot.
Every Yoga Pro 7 14IRH8 owner is affected.

### Step 5.5: Similar Patterns
**Record:** At least 6 other models in this tree use
`ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN` with the same bass-speaker
topology; 14IMH9 uses the same `HDA_CODEC_QUIRK` pattern for PCI SSID
collision.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy Code Exists?
**Record:** **Yes.** `SND_PCI_QUIRK(0x17aa, 0x3852, ...)` at line 7438
matches Yoga Pro 7 14IRH8 via shared PCI SSID. Codec SSID `0x38b1` quirk
is **missing** from v6.18.44.

### Step 6.2: Backport Complications
**Record:** **Clean apply.** `git format-patch -1 853e10ec44598 --stdout
| git apply --check` succeeded with exit code 0 on HEAD. Line numbers
differ (master ~7741 vs stable ~7438) but context matches.

### Step 6.3: Related Fixes Already Present?
**Record:** The fixup function and enum exist; sibling model quirks
exist; only the `0x38b1` table entry is missing. No duplicate fix found.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** `sound/hda/codecs/realtek/` — IMPORTANT (affects laptop
users with this specific hardware, not universal core path)

### Step 7.2: Subsystem Activity
**Record:** Actively maintained — multiple realtek quirk commits in
v6.18.44 history (TongFang, HP, Lenovo, ASUS, Samsung additions in
recent weeks)

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Lenovo Yoga Pro 7 14IRH8 owners with ALC287 codec
(CONFIG_SND_HDA_INTEL / SOF audio stack). Driver-specific, single-
machine SSID.

### Step 8.2: Trigger Conditions
**Record:** Every boot with default audio driver — automatic codec
probe. Common/likely for all owners of this model. Not security-
relevant; not userspace-triggerable beyond normal audio use.

### Step 8.3: Failure Mode Severity
**Record:** Bass speakers at uncontrollable full volume — **MEDIUM**
functional bug. Not a crash, deadlock, or data corruption, but makes
volume control effectively broken for bass output. Poor UX and
potentially harmful at high volume.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH for affected users (restores working volume control
  using proven fixup)
- **Risk:** VERY LOW (4-line table entry, codec-SSID-specific, pattern
  validated on 6+ sibling models)
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real hardware bug with Bugzilla report since 2023
- Hardware quirk exception category (explicitly allowed for stable)
- Tiny, surgical 4-line change
- Reuses existing, battle-tested fixup already in tree
- Identical pattern to 14IMH9 quirk already backported to v6.18.44
- Merged by ALSA maintainer Takashi Iwai
- Applies cleanly to v6.18.44
- All prerequisites present in this tree

**AGAINST backport:**
- Not a crash/security/corruption issue (severity is functional audio)
- Lore discussion content unverified (bot protection)

**Unresolved:**
- No reviewer thread content (lore blocked)
- No explicit Tested-by on this specific machine in commit message

Neither unresolved item affects the technical decision.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — reuses fixup proven on
   identical topology across multiple Yoga Pro 7 models; maintainer
   merged
2. Fixes a real bug? **PASS** — Bugzilla #217949, volume control non-
   functional
3. Important issue? **PASS** — broken volume control on commercial
   laptop (MEDIUM severity, real user impact)
4. Small and contained? **PASS** — 4 lines, 1 file
5. No new features/APIs? **PASS** — quirk table entry only
6. Can apply to local tree? **PASS** — clean apply, all dependencies
   present

### Step 9.3: Exception Category
**Record:** Hardware quirk/workaround (audio codec quirk for broken DAC
routing on specific Lenovo laptop)

### Step 9.4: Decision Rationale

This commit adds a codec-SSID-specific quirk entry so the Lenovo Yoga
Pro 7 14IRH8 gets the correct bass-speaker DAC routing fixup instead of
the wrong PCI-SSID-based quirk shared with Yoga 7 14ITL5. The fix is
minimal, self-contained, uses infrastructure already present in Linux
6.18.44, follows an established pattern already applied to sibling
models in this tree, and addresses a documented multi-year user bug. It
fits squarely within the hardware-quirk exception for stable kernels.

---

## Verification

- [Phase 1] Parsed subject, tags, body from commit `853e10ec44598`
- [Phase 1] Bugzilla #217949 confirmed: "Yoga Pro 7 14IRH8 volume
  controls broken" (2023-09-25)
- [Phase 2] Diff: +4 lines in `alc269_fixup_tbl[]`, adds
  `HDA_CODEC_QUIRK(0x17aa, 0x38b1, ...)`
- [Phase 2] Read `alc287_fixup_yoga9_14iap7_bass_spk_pin()` at lines
  3408–3423 — reroutes pin 0x17 to DACs with volume control
- [Phase 3] `git describe HEAD` → v6.18.44; Makefile VERSION 6.18.44
- [Phase 3] `git merge-base --is-ancestor 853e10ec44598 HEAD` → exit 1
  (commit NOT in current tree)
- [Phase 3] `git blame -L 7435,7440` → 14IMH9 quirk at 7435, 0x3852 PCI
  quirk since driver split
- [Phase 3] `ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN` present since
  `aeeb85f26c3bb`
- [Phase 3] Related quirk commits in tree: `634e5e1e06f5c`,
  `b98ecc1c60ad7`, `0fa5713ac7a19`, etc.
- [Phase 4] `b4 dig -c 853e10ec44598` → patch.msgid.link URL found
- [Phase 4] `b4 dig -a` → single revision
- [Phase 4] Lore thread fetch blocked by Anubis bot protection —
  UNVERIFIED
- [Phase 5] `snd_hda_pick_fixup()` call at line 8471 confirmed
- [Phase 5] `HDA_CODEC_QUIRK` macro at `hda_local.h:314-320` with
  `match_codec_ssid = true`
- [Phase 6] `0x38b1` not present in tree; `0x3852` PCI quirk present at
  line 7438
- [Phase 6] `git format-patch ... | git apply --check` → exit 0 (clean
  apply)
- [Phase 6] `ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN` fixup struct at
  lines 6255–6260 confirmed
- [Phase 8] Failure mode: bass at full volume, severity MEDIUM

**YES**

 sound/hda/codecs/realtek/alc269.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 0ef5468b0701a..c8714e59d8199 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7437,6 +7437,10 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	HDA_CODEC_QUIRK(0x17aa, 0x38cf, "Lenovo Yoga Pro 7 14IMH9", ALC287_FIXUP_YOGA9_14IMH9_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3847, "Legion 7 16ACHG6", ALC287_FIXUP_LEGION_16ACHG6),
 	SND_PCI_QUIRK(0x17aa, 0x384a, "Lenovo Yoga 7 15ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
+	/* Yoga Pro 7 14IRH8 shares PCI SSID 17aa:3852 with Yoga 7 14ITL5;
+	 * use codec SSID to distinguish them
+	 */
+	HDA_CODEC_QUIRK(0x17aa, 0x38b1, "Lenovo Yoga Pro 7 14IRH8", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3852, "Lenovo Yoga 7 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3853, "Lenovo Yoga 7 15ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3855, "Legion 7 16ITHG6", ALC287_FIXUP_LEGION_16ITHG6),
-- 
2.53.0

