Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5634DCB2A;
	Mon, 19 Oct 2026 13:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418336; cv=none; b=RSoWSOqPTt7pBwFOPqyHSS29+xD8vjbescO21FGWNEO8qCpSWX0N2XASKCMBi+1HgxFMtoVEq56ccnuxz3nQHOX0rk9QHMj+r5YlDhyu5ebDJ4ejOwXdy0NQJAPeYcyQ3Gy99NYutFvSESQ3Vii8h8P1fLnoB2Eymi7p5vg5Cv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418336; c=relaxed/simple;
	bh=MxbhZWYHOavEXJYGWMsUHj2asa8Y4naKaJ4sl7L+QuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RPM1ekng+u8CVhCaWP+bRzXav3YKpopqlapk+pKfRuCN19C1187t2GM17IwGzHycsKRd00Ty+GVEBxrSd+PmyoVhGMBRKuILh7hjzAubDexT04cGq7lqgrHBOAgOlK8UvciaRJM91Qrx0HZf0ehdqov4PCui/xpyaajgFc+sOKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MY662OyQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MY662OyQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C4D1F000C6;
	Mon, 19 Oct 2026 13:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418333;
	bh=CXXmyIGEgU20Zu/avjRGxBpyCBsYo2diibyVB8dXzoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MY662OyQWhKAPHhG72wgkTf/bs2VtR1c95jXslGicv86ClBK8lCL11IDBARqJevJ2
	 yi8nHMAsL1NrXsZRXzIZP4ou0rjjilIe2gCcCvqHwCitGgDYkaS2tjxLGTHJ/t0/Cg
	 5ANorBzN88HnQ27jTKFt0PNJDmTzXEuNdu8kwS6yz0SPCIEoKCCf2SIQoj6Szzj9pK
	 Fg0sGBQwMetOHS/iSUX/IebKmzeZ/HTUnbLUFrTxHDYSkAHSl8lHFmphwaCXcUr+I5
	 Gi/wrdYR2HPUSHBiZiblVpjhiEsl36OwuWWlXubfOtALCO4medYujlZ8acRYvt6+lu
	 sdFXHw6EPPcvA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] ALSA: hda/realtek: Add quirk for Acer Nitro AN515-45
Date: Mon, 19 Oct 2026 09:47:44 -0400
Message-ID: <20261019135441.1420968-173-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit 0d90a929836344f1d3b39f22f08ccecc62378a59 ]

The Acer Nitro AN515-45 requires ALC2XX_FIXUP_HEADSET_MIC to make the
headset microphone work properly.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221925
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260921124450.639601-2-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a one-line Realtek HDA hardware quirk for Acer Nitro AN515-45.
The local tree is **6.18.57** (`v6.18.57-155-gcdf239ca885b2`). The
existing `ALC2XX_FIXUP_HEADSET_MIC` path is already in this tree; the
SSID `1025:151e` is not in `v6.18.57`.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: `[ALSA/hda/realtek] [Add] quirk for Acer Nitro AN515-45` — add
an existing headset-mic fixup for one laptop SSID.

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- `Link: https://bugzilla.kernel.org/show_bug.cgi?id=221925` — user bug
  report
- `Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>` — author
- `Link:
  https://patch.msgid.link/20260921124450.639601-2-zhangheng@kylinos.cn`
  — patch 2/2
- `Signed-off-by: Takashi Iwai <tiwai@suse.de>` — ALSA maintainer
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Cc: stable` (absence is
  expected)
- Ignore pipeline `[ Upstream commit ... ]` and `Signed-off-by: Sasha
  Levin`

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: headset microphone on Acer Nitro AN515-45 does not work
- Symptom: combo-jack mic not detected / not created as an input
- Root cause (from bugzilla, not the short commit body): BIOS leaves pin
  0x19 as N/A (`Pin Default 0x411111f0`); no headset-mic path is parsed
- Fix: apply existing `ALC2XX_FIXUP_HEADSET_MIC` for PCI/codec SSID
  `1025:151e`

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a disguised cleanup. This is an explicit hardware quirk to
make a broken jack work.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `sound/hda/codecs/realtek/alc269.c` (+1 / −0)
- Function/table: `alc269_fixup_tbl[]`
- Scope: single-file, one-line table addition

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: SSID `0x1025:0x151e` has no dedicated entry, so probe does not
  apply the headset-mic pincfg
- After: that SSID maps to `ALC2XX_FIXUP_HEADSET_MIC`
- Path: codec probe / pin parse (`alc269_probe` → `snd_hda_pick_fixup`)
- Not an error path or API change

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- Category: hardware workaround (quirk table entry)
- Mechanism: `alc2xx_fixup_headset_mic()` at pre-probe sets pin 0x19 to
  `0x03a1103c`, updates coef 0x45, and sets `HDA_PINCFG_HEADSET_MIC` so
  the combo-jack mic is parsed

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Minimal, same pattern as AN515-57 / AN515-58 / AN517-55 already in
  this tree
- Only the matching laptop is affected
- Regression risk is low; remaining auto-mic source-switch behavior is
  existing generic parser behavior, not introduced here

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Neighboring Acer entries come from `aeeb85f26c3bbe` (Realtek codec
  split, 2025-07-09) and later sibling quirks
- The missing-SSID bug is “no quirk for this board,” not a recently
  introduced logic bug
- `ALC2XX_FIXUP_HEADSET_MIC` itself dates to 2024 (`5a69e3d0a1b0` /
  `50db91fccea0` era) and is present in v6.18.57

Step 3.2: FOLLOW THE FIXES: TAG
Record: No `Fixes:` tag. Not applicable.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- Sibling: `a9584e9e46448` “Enable headset mic for Acer Nitro 5”
  (AN515-57) is already in v6.18.57
- Same file routinely receives one-line `SND_PCI_QUIRK` additions
- Series is `[PATCH 2/2]`; patch 1/2 is an unrelated Lenovo ThinkBook
  G8+ quirk (`17aa:38dc`) and is not a prerequisite

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Zhang Heng submitted two independent one-line quirks. Takashi
Iwai applied both. Author is a contributor; maintainer sign-off is the
stronger signal.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: Standalone. Needs only `alc269_fixup_tbl` and
`ALC2XX_FIXUP_HEADSET_MIC`, both present in this 6.18.y tree.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c 0d90a929836344f1d3b39f22f08ccecc62378a59` matched `[PATCH
  2/2]`
- Lore/msgid: `https://patch.msgid.link/20260921124450.639601-2-
  zhangheng@kylinos.cn`
- Only v1; no later revision
- Takashi Iwai: “Applied both patches. Thanks.” No NAK, no stable
  objection

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): To `tiwai@suse.com`; Cc `linux-
sound@vger.kernel.org`, `linux-kernel@vger.kernel.org`. Subsystem
maintainer applied it.

Step 4.3: SEARCH FOR THE BUG REPORT
Record (bugzilla 221925, fetched via curl; WebFetch returned 403):
- Title: `ALC295 / Acer Nitro AN515-45 (1025:151e): headset mic not
  detected, BIOS disables pin 0x19`
- Reporter: Rishikesh Jha, 2026-08-26, hardware AMD AN515-45, codec
  ALC295 `0x10ec0295`, subsystem `0x1025151e`
- Symptom: speakers/headphones/internal mic work; combo-jack headset mic
  is not created
- Reporter verified a firmware pincfg plus `headset-mode`
- Zhang Heng asked for `model=alc2xx-fixup-headset-mic`; reporter
  confirmed the headset mic works
- Remaining userspace auto-mic mux limitation is explained as generic
  parser behavior, not a reason this quirk is wrong

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Patch 1/2 is a different machine/SSID/fixup. This commit does
not depend on it.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: No useful `lore.kernel.org/stable` hit for this model. The
original AN515-58 headset-mic quirk (`5a69e3d0a1b0`) was `Cc: stable`.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: Table `alc269_fixup_tbl[]` only. Consumed fixup:
`alc2xx_fixup_headset_mic()`.

Step 5.2: TRACE CALLERS
Record:
- `alc269_probe()` calls `snd_hda_pick_fixup(..., alc269_fixup_tbl,
  alc269_fixups)`
- That matches PCI SSID, then codec SSID
- Probe path for ALC269-family codecs including ALC295 (`0x10ec0295`)

Step 5.3: TRACE CALLEES
Record: `alc2xx_fixup_headset_mic()` → `snd_hda_apply_pincfgs()`,
`alc_update_coef_idx()`, `spec->parse_flags |= HDA_PINCFG_HEADSET_MIC`

Step 5.4: FOLLOW THE CALL CHAIN
Record: Reachable on boot when this laptop’s HD-audio codec is
enumerated. Userspace sees the missing capture device without the quirk.
Not a syscall crash path; it is a real device-enablement path.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same fixup already used in this tree for AN515-57 (`0x1539`),
AN515-58 (`0x159c`), AN517-55 (`0x1597`), plus other vendors.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. v6.18.57 has `sound/hda/codecs/realtek/alc269.c`,
`ALC2XX_FIXUP_HEADSET_MIC`, and sibling Nitro entries, but **no**
`0x1025, 0x151e` / AN515-45 line. Headset mic stays broken on this model
here.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Clean apply. Insert point is identical: after `0x1466` Aspire
A515-56, before `0x1534` Predator PH315-54.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: Sibling Nitro headset-mic quirks are present. There is no
earlier AN515-45-specific fix. (Ignore candidate-prep cherry-pick on
current HEAD.)

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: ALSA HD-audio Realtek codec driver. Criticality: IMPORTANT for
users of this common laptop audio stack; board-specific impact.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Mature, actively receiving per-board quirks. This is the normal
stable-safe pattern, not a new subsystem.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver-specific / hardware-specific: Acer Nitro AN515-45, SSID
`1025:151e`, Realtek ALC295.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Every boot / every headset plug on that machine. Unprivileged
user cannot crash the kernel; they just cannot use the headset mic.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: Functional hardware failure (headset capture missing). Severity
MEDIUM as a crash, HIGH as user-visible hardware breakage. Stable
routinely takes these quirks.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: high for owners of this 2021-era Nitro 5; restores combo-jack
  mic
- Risk: very low (one table row, existing fixup, SSID-matched)
- Ratio: strongly favors backport

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real user bug (bugzilla 221925) with alsa-info and codec dump
- Reporter confirmed `alc2xx-fixup-headset-mic` makes the headset mic
  work
- One-line `SND_PCI_QUIRK` using a fixup already in 6.18.y
- Same fix already shipped here for sibling Nitro 5 models
- ALSA maintainer applied it; no NAK
- Explicit stable exception: hardware quirk for an existing driver

AGAINST:
- Not a crash/security/corruption fix
- Bugzilla still lists leftover auto-mic source-switch UX after the mic
  appears
- Patch 2/2 of a series (other patch is unrelated, not required)

UNRESOLVED:
- WebFetch of lore/bugzilla returned 403; bugzilla content was verified
  with curl instead

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — existing fixup; reporter tested
   the model; maintainer applied
2. Fixes a real bug that affects users? PASS — headset mic not detected
3. Important issue? PASS under the hardware-quirk exception (device does
   not work correctly)
4. Small and contained? PASS — +1 line
5. No new features or APIs? PASS — table entry only
6. Can apply to the local tree? PASS — clean insert into
   `alc269_fixup_tbl` on 6.18.y

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Hardware quirk / workaround for a broken BIOS pin config on
existing hardware. This is a standard YES for stable.

Step 9.4: MAKE YOUR DECISION
Backport. This tree already has the Realtek driver and
`ALC2XX_FIXUP_HEADSET_MIC`. Adding SSID `1025:151e` is the same class of
fix already present for AN515-57/58.

What it solves for 6.18.y users: on Acer Nitro AN515-45 the BIOS marks
headset-mic pin 0x19 as N/A, so the kernel never creates a headset
capture device. The quirk applies the existing pincfg/coef fixup so the
combo jack mic works.

Risk vs benefit: one SSID-guarded line, reused fixup, verified on the
machine. Benefit is real hardware enablement; regression surface is that
one laptop.

Verification:
- [Phase 1] Parsed tags: bugzilla 221925, msgid `...639601-2...`, SOB
  Takashi Iwai; no Fixes/Cc stable
- [Phase 2] Diff: +1 `SND_PCI_QUIRK(0x1025, 0x151e, "Acer Nitro
  AN515-45", ALC2XX_FIXUP_HEADSET_MIC)` in `alc269_fixup_tbl`
- [Phase 2] Read `alc2xx_fixup_headset_mic()`: sets pin 0x19
  `0x03a1103c`, coef 0x45, `HDA_PINCFG_HEADSET_MIC`
- [Phase 3] `make kernelversion` / `git describe HEAD`: 6.18.57 /
  `v6.18.57-155-gcdf239ca885b2`
- [Phase 3] No Fixes tag to follow
- [Phase 3] Sibling AN515-57 quirk `a9584e9e46448` is ancestor of
  `v6.18.57`
- [Phase 3] Series patch 1/2 is unrelated ThinkBook G8+ quirk
- [Phase 4] `b4 dig -c 0d90a9298363`: matched patch 2/2; only v1
- [Phase 4] `b4 dig -w`: To tiwai, Cc linux-sound
- [Phase 4] mbox: Takashi “Applied both patches”
- [Phase 4] curl bugzilla 221925: ALC295, SSID 1025:151e, pin 0x19 N/A;
  `alc2xx-fixup-headset-mic` confirmed working
- [Phase 4] lore/bugzilla WebFetch: 403 (used curl/b4 instead)
- [Phase 5] `alc269_probe()` → `snd_hda_pick_fixup()` uses this table on
  codec enumeration
- [Phase 6] `git grep 0x151e v6.18.57 --
  sound/hda/codecs/realtek/alc269.c`: no match
- [Phase 6] `git grep ALC2XX_FIXUP_HEADSET_MIC v6.18.57 --
  .../alc269.c`: present, including AN515-57/58
- [Phase 6] v6.18.57 insert point between `0x1466` and `0x1534` matches
  the patch
- [Phase 8] Failure mode: headset mic missing on that laptop, not a
  kernel oops
- UNVERIFIED: live reproduction on AN515-45 hardware (not available
  here)

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 4eefd5d87f04b..fa5bc54ff083d 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6615,6 +6615,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x142b, "Acer Swift SF314-42", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1430, "Acer TravelMate B311R-31", ALC256_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1466, "Acer Aspire A515-56", ALC255_FIXUP_ACER_HEADPHONE_AND_MIC),
+	SND_PCI_QUIRK(0x1025, 0x151e, "Acer Nitro AN515-45", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1534, "Acer Predator PH315-54", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1539, "Acer Nitro 5 AN515-57", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x159c, "Acer Nitro 5 AN515-58", ALC2XX_FIXUP_HEADSET_MIC),
-- 
2.53.0

