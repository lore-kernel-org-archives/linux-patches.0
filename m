Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665DD4B1462;
	Mon, 31 Aug 2026 13:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184242; cv=none; b=N/cgcyZd2qbwiv8rmQMhVBypthe+k9ZyGld4Fck3oNBau8HmnbYedzgKA+wZ0eP1aTk5lUcpR4QBXifNjWlPQ0mU6WChNaX3+sUSwFB/kuQjBO+Wof45wdvk0Pb2n5Y0EM0ZjfHHrDPh7WrFOsSHCzsuqdK52f0dn6po+dHcgDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184242; c=relaxed/simple;
	bh=2yQPoisS4ncjCeNWm5C9+xgE8OOcpvhPcpahce/Dtig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gPDG2T8PWDnFQPGGZTY+17Ay2qZRD+EhI7RPD4pNgP4s7Gj0DQFCQ1xg4SEzGHHhLZBRerBTvYaRcrZnfCkXqmpVvPB6dKq9PcWgqP1PWkx3o8g/TVS96KseHyGkfX4IzwOO/inX+hCfnlJHPlr/V4xyjDtyGrLU8hW7PBy/BxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H6KQFVFs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H6KQFVFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A591F00A3D;
	Mon, 31 Aug 2026 13:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184239;
	bh=BVnquQlohJhygpG+npV/htXxIisOwpoMA1zUgJ/x73Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H6KQFVFsEVQkjOV/aCSgk+bEjTFZWZEYnIUovAbrlt3CXxYDKs2piTX5QgjxgMVC2
	 gS8gESt2xqzrxKesJC6YPYIh2cPv9KRg7BDjSkXaucITYMRZ81srA6f+NlywG+yzRj
	 7oJ8NGRZgKOAZB47HQl1O/+5QiWDaqVBJiZQ7J/FOCoLH+a4nF8sMorlW4mNee4rc0
	 DrkO18JZGVG5Uu1Xge7OMVVaKIIoXRQpIEu6e7YmIRkYrM8vnUuG+7irGihsqMT+Oy
	 MEobEMvdV7v9vkTT8SwG3FNVtNdrUvnj5N5ltdQv2c1OHfhFuIf64jZi8/k1RZD67n
	 njFtkXHprj2VQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rohit Sinha <rohitsinha12043@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ALSA: hda/realtek - Add quirk for HP Victus 15-fa0xxx (MB 8A50)
Date: Mon, 31 Aug 2026 09:30:03 -0400
Message-ID: <20260831133314.4125787-575-sashal@kernel.org>
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

From: Rohit Sinha <rohitsinha12043@gmail.com>

[ Upstream commit 5c3f4b583c25911fad9890b463632761291f65ab ]

The mute LED on HP Victus 15-fa0xxx (board ID 8A50) uses ALC245 but
requires a quirk to work. This patch enables the existing
ALC245_FIXUP_HP_MUTE_LED_COEFBIT quirk for the device.

Tested on my HP Victus 15-fa0xxx. The LED behaviour works as intended.

Signed-off-by: Rohit Sinha <rohitsinha12043@gmail.com>
Link: https://patch.msgid.link/20260706211834.384022-1-rohitsinha12043@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ALSA hda/realtek HP Victus 15-fa0xxx (MB
8A50) Quirk

**Local tree:** `v6.18.44` (`VERSION = 6`, `PATCHLEVEL = 18`, `SUBLEVEL
= 44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[ALSA: hda/realtek] [add] quirk for HP Victus 15-fa0xxx (MB
8A50) mute LED`

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Rohit Sinha `<rohitsinha12043@gmail.com>` (author)
- **Signed-off-by:** Takashi Iwai `<tiwai@suse.de>` (ALSA maintainer
  merge)
- **Link:** `https://patch.msgid.link/20260706211834.384022-1-
  rohitsinha12043@gmail.com`
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable@vger.kernel.org` in the commit message (absence
  of stable tag is expected per review pipeline)

### Step 1.3: Body analysis
**Record:**
- **Bug:** Mute LED on HP Victus 15-fa0xxx (board ID 8A50, ALC245 codec)
  does not work without a device-specific quirk.
- **Symptom:** Mic-mute LED does not track mute state (LED stays
  wrong/off).
- **Root cause:** Missing `SND_PCI_QUIRK` entry for PCI SSID
  `0x103c:0x8a50`; existing `ALC245_FIXUP_HP_MUTE_LED_COEFBIT` fixup is
  not applied to this board variant.
- **Version info:** None stated; author tested on physical hardware.

### Step 1.4: Hidden bug fix?
**Record:** Not a crash/corruption fix disguised as cleanup. This is an
explicit hardware quirk addition for a laptop-specific mute-LED
GPIO/coefficient configuration. Falls under the audio codec quirk
exception category.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `sound/hda/codecs/realtek/alc269.c` (+1 line)
- **Functions modified:** None; only `alc269_fixup_tbl[]` quirk table
- **Scope:** Single-file, one-line surgical addition

### Step 2.2: Code flow change
**Record:**
- **Before:** HP Victus 15-fa0xxx with SSID `0x103c:0x8a50` probes
  ALC245 with no matching quirk; mute LED cdev is never configured.
- **After:** Same hardware matches quirk entry and gets
  `ALC245_FIXUP_HP_MUTE_LED_COEFBIT`, which calls
  `alc245_fixup_hp_mute_led_coefbit()` at `HDA_FIXUP_ACT_PRE_PROBE` to
  set coefficient-based mute LED parameters and register
  `snd_hda_gen_add_mute_led_cdev()`.
- **Path affected:** HDA codec probe during driver initialization for
  this specific HP laptop variant.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Hardware workaround / audio codec quirk
- **Mechanism:** HP uses board-specific coefficient bits to drive the
  mute LED on ALC245. Without the quirk table entry,
  `snd_hda_pick_fixup()` never selects the fixup, so the LED hardware is
  never programmed.

### Step 2.4: Fix quality
**Record:**
- **Quality:** Obviously correct — identical pattern to sibling entries
  already in-tree (e.g. `0x8a4f`, `0x8a25`, `0x8a26`).
- **Regression risk:** Very low; only affects one PCI SSID; uses an
  existing, well-tested fixup function.
- **Red flags:** None.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- Insertion point neighbor `0x8a4f` introduced in `5d324e5159d9e`
  (2025-11-28, Linus Torvalds merge).
- `ALC245_FIXUP_HP_MUTE_LED_COEFBIT` fixup function present since at
  least that merge.
- The missing `0x8a50` entry is an omission for a board variant of the
  same laptop line, not a recently introduced regression.

### Step 3.2: Fixes: tag
**Record:** No `Fixes:` tag present; not applicable.

### Step 3.3: Related file history
**Record:** Many similar mute-LED quirk commits in this tree, e.g.:
- `ded801af28a99` — HP Pavilion x360 mute LED (had `Cc:
  stable@vger.kernel.org`)
- `89ed38540e6be` — HP Victus 15-fa2xxx mute LED
- `9745c2561f55f` — HP Victus 16-e0xxx mute LED

Standalone one-line quirk; not part of a multi-patch series.

### Step 3.4: Author context
**Record:** Rohit Sinha has no other commits in this tree's realtek
path. Takashi Iwai (ALSA maintainer) applied and signed off.

### Step 3.5: Dependencies
**Record:** Requires only `ALC245_FIXUP_HP_MUTE_LED_COEFBIT` and
`alc245_fixup_hp_mute_led_coefbit()` — both confirmed present in this
tree. No other commits required. Applies standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **URL:** `https://lore.kernel.org/all/20260706211834.384022-1-
  rohitsinha12043@gmail.com/`
- **Series revisions:** Single submission (v1 only); no `-a` revisions
  found via b4.
- **Maintainer response:** Takashi Iwai replied "Applied now."
- **Stable nomination in thread:** None found in review replies.
- **NAKs/concerns:** None found.

### Step 4.2: Reviewers
**Record:** Patch sent to `alsa-devel@alsa-project.org`, Cc'd to
`tiwai@suse.de`. Applied by Takashi Iwai (subsystem maintainer).

### Step 4.3: Bug report
**Record:** No external bug report (bugzilla/syzbot). Hardware tested by
author on HP Victus 15-fa0xxx.

### Step 4.4: Related patches
**Record:** Same fixup already used for `0x8a4f` ("HP Victus 15-fa0xxx
(MB 8A4F)") in this tree — same product line, different motherboard ID.

### Step 4.5: Stable list history
**Record:** Not searched exhaustively; similar mute-LED quirk
`ded801af28a99` in this tree explicitly carried `Cc:
stable@vger.kernel.org`, establishing precedent for this quirk class.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** Indirectly affects `alc245_fixup_hp_mute_led_coefbit()` via
quirk table lookup in `snd_hda_pick_fixup()` during `alc_pre_init()` /
codec probe.

### Step 5.2: Callers
**Record:** `snd_hda_pick_fixup(codec, alc269_fixup_models,
alc269_fixup_tbl, alc269_fixups)` called from ALC269 codec probe path
(`alc269.c` ~line 8471). Triggered at every boot for matching HDA
hardware.

### Step 5.3: Callees
**Record:** Fixup sets `spec->mute_led_coef` fields and calls
`snd_hda_gen_add_mute_led_cdev(codec, coef_mute_led_set)` to expose LED
control to userspace/kernel audio stack.

### Step 5.4: Reachability
**Record:** Triggered automatically on probe for laptops with PCI SSID
`0x103c:0x8a50` and ALC245 codec. No userspace action needed beyond
normal audio driver load. Common laptop boot path.

### Step 5.5: Similar patterns
**Record:** At least 15+ entries in this tree use
`ALC245_FIXUP_HP_MUTE_LED_COEFBIT` for various HP laptops, including
Victus 15-fa0xxx MB 8A4F (`0x8a4f`) immediately adjacent to the
insertion point.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (v6.18.44)

### Step 6.1: Does the buggy code exist?
**Record:** **Yes.** The quirk table exists but `0x103c:0x8a50` is
**missing** from this tree. Verified via grep — no `0x8a50` entry.
Neighbor `0x8a4f` is present at line 6859. The prerequisite fixup
`ALC245_FIXUP_HP_MUTE_LED_COEFBIT` exists at lines 6315–6317 and
1566–1579.

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** One line to insert after the
`0x8a4f` entry. No structural divergence at insertion point.

### Step 6.3: Related fixes already present?
**Record:** No existing `0x8a50` entry. Sibling `0x8a4f` quirk for same
laptop model line is already present but does not cover board ID 8A50.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `sound/hda/codecs/realtek` — **IMPORTANT** (common laptop
audio driver; affects HP Victus laptop owners specifically).

### Step 7.2: Subsystem activity
**Record:** Actively maintained; frequent mute-LED quirk additions in
6.18.y (20+ related commits in recent history).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Owners of HP Victus 15-fa0xxx with motherboard ID 8A50 (PCI
SSID `0x103c:0x8a50`). Driver-specific, platform-specific.

### Step 8.2: Trigger conditions
**Record:** Every boot / codec probe on affected hardware.
Deterministic, not a race. Unprivileged users cannot trigger it
arbitrarily (hardware-specific).

### Step 8.3: Failure mode severity
**Record:** Mute LED does not reflect microphone mute state. Audio
itself works; this is a **LOW** severity functional/UX issue. Privacy
indicator (mute LED) is the user-visible failure. Not a crash, hang,
corruption, or security issue.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Enables correct mute LED behavior on a real, shipping HP
  laptop variant; matches established stable practice for HDA codec
  quirks.
- **Risk:** Minimal — one table entry, existing fixup, maintainer-
  applied and hardware-tested.
- **Ratio:** Low risk, moderate benefit for affected hardware users.
  Qualifies under hardware quirk exception.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Hardware quirk exception (audio codec `SND_PCI_QUIRK`)
- One-line, surgical, obviously correct
- Hardware-tested by reporter
- Applied by ALSA maintainer Takashi Iwai
- Prerequisite fixup already in v6.18.44
- Identical pattern to sibling quirk `0x8a4f` already in tree
- Precedent: similar mute-LED quirks nominated for stable
  (`ded801af28a99`)
- Clean apply to this tree

**AGAINST backport:**
- Does not fix crash, corruption, deadlock, or security issue
- Affects only one specific laptop board variant
- No `Cc: stable` tag (expected; not a negative signal)
- Low severity if LED is wrong (cosmetic/privacy-indicator issue)

**Unresolved:** Whether this specific commit has landed in mainline yet
(not in current v6.18.44 checkout); does not affect backport merit for
this tree where the entry is absent.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — one-line quirk, hardware-
   tested, maintainer-applied
2. Fixes a real bug affecting users? **PASS** — mute LED nonfunctional
   on real hardware without quirk
3. Important issue? **PASS (quirk exception)** — not crash-level, but
   real hardware defect fixed by established quirk pattern
4. Small and contained? **PASS** — 1 line, 1 file
5. No new features or APIs? **PASS** — enables existing fixup for new
   PCI ID only
6. Can apply to local tree? **PASS** — prerequisites present, clean
   insertion after `0x8a4f`

### Step 9.3: Exception category
**Record:** **Hardware quirk / audio codec quirk** — `SND_PCI_QUIRK`
entry for HP laptop mute LED on existing ALC245 driver with existing
fixup.

### Step 9.4: Problem and decision rationale

This commit adds PCI subsystem ID `0x103c:0x8a50` to the Realtek ALC269
quirk table so the mute LED on HP Victus 15-fa0xxx (motherboard 8A50) is
driven correctly via the existing `ALC245_FIXUP_HP_MUTE_LED_COEFBIT`
fixup. Without it, affected laptop owners get working audio but a
nonfunctional mute indicator — a common HP ALC245 hardware configuration
issue that kernel has addressed repeatedly for sibling board IDs.

For v6.18.44, all prerequisites exist, the entry is missing, and the
patch is a trivial one-liner with negligible regression risk. While not
a crash fix, it fits the well-established stable exception for HDA codec
hardware quirks that enable real laptop hardware behavior, consistent
with other HP Victus mute-LED quirk backports in this tree.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message
- **[Phase 1]** Confirmed no `Fixes:`/`Cc: stable` tags; author SOB +
  Takashi Iwai SOB present
- **[Phase 2]** Diff: +1 line in `alc269_fixup_tbl[]`,
  `ALC245_FIXUP_HP_MUTE_LED_COEFBIT`
- **[Phase 2]** Read `alc245_fixup_hp_mute_led_coefbit()` at lines
  1566–1579; sets coef bits and calls `snd_hda_gen_add_mute_led_cdev()`
- **[Phase 3]** `git describe HEAD`: `v6.18.44-1-g2736c32da98b9`
- **[Phase 3]** `git blame -L 6857,6860`: `0x8a4f` from `5d324e5159d9e`
  (2025-11-28)
- **[Phase 3]** `git log --oneline -20 --grep="mute LED"`: multiple
  similar quirk commits in tree
- **[Phase 3]** `ded801af28a99` had `Cc: stable@vger.kernel.org`
  (precedent)
- **[Phase 4]** Fetched lore mbox via curl: patch content matches;
  Takashi Iwai replied "Applied now."
- **[Phase 4]** b4 dig on HEAD returned unrelated commit (commit not in
  local tree yet)
- **[Phase 5]** Grep `ALC245_FIXUP_HP_MUTE_LED_COEFBIT`: 15+ uses in
  `alc269.c`
- **[Phase 5]** Confirmed `snd_hda_pick_fixup()` call at line 8471
- **[Phase 6]** Grep `0x8a50`: **not present** in local tree
  (bug/omission confirmed)
- **[Phase 6]** Grep `0x8a4f`: present at line 6859 (insertion neighbor
  confirmed)
- **[Phase 6]** Grep `ALC245_FIXUP_HP_MUTE_LED_COEFBIT` fixup
  definition: present at lines 6315–6317
- **[Phase 8]** Failure mode: mute LED nonfunctional, severity LOW;
  hardware quirk exception applies

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index df2d597bcf95e..c7c8c59745a3a 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6882,6 +6882,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8a34, "HP Pavilion x360 2-in-1 Laptop 14-ek0xxx", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8a3d, "HP Victus 15-fb0xxx (MB 8A3D)", ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8a4f, "HP Victus 15-fa0xxx (MB 8A4F)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
+	SND_PCI_QUIRK(0x103c, 0x8a50, "HP Victus 15-fa0xxx (MB 8A50)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8a6e, "HP EDNA 360", ALC287_FIXUP_CS35L41_I2C_4),
 	SND_PCI_QUIRK(0x103c, 0x8a74, "HP ProBook 440 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a75, "HP ProBook 450 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
-- 
2.53.0

