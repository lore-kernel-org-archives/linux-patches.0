Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44700627654;
	Mon, 19 Oct 2026 14:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418699; cv=none; b=kk271SLcNUj9ftGK20a1XaQEh44ymFrmv/7RUU/Ulmd3SO0INgDkd/DZFJMkxqSph33hTDPg6CYqusc5+gvoCq+rGdRU0Phoox15ym348nBCmBwJiJcTEC/r6EvGiHl6kh4Yl4YarmJ631Y6O/TYlOFuA7gAIBJQyCULbuThBQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418699; c=relaxed/simple;
	bh=fdclUztKHOxysPsqPkNKnP+Nnp3EMrRE7VdWbokhunU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ErM0SU/E3oKcGYUf7SvgGOI9dXMOb/zBNKn4wWQ7DhRp2CA4ywcvnDw/WC2FQm0Kam8eBnEvGOO07jieC8wzqCYp07WBUp/ugwBOlOMjCg8cJBQPcxQU3AloG+y5323lVReoDICvDdvI9MQY/z1xnOGrtfdXBsoF957gs5f74mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TWjF38Ox; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TWjF38Ox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7AB1F000C4;
	Mon, 19 Oct 2026 14:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418695;
	bh=4AdxQeZ+LnvU8WG+89zA2z/g+W4O/ODmeHPECJ2OOj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TWjF38Oxj+ZWdJDkGG0+Rp75ZS7mzKC/RwUUJImuzmSRAea/usPmJT2cXgwtEZZrX
	 f7OqZd0kdUYxd0NS72Uqi8IPVva8a5tYalCXHsoBWSupHL3mNWE+IK+QgrXHOP7mlj
	 GDGlijnsNnJ/u0nuKufyasKNXbSHKs8nOwroE9J2w7i1lJEmyQPz8o6/SsVVUyIq7R
	 ieaMwb0RxMELfwew6RIVNhby+bcLTsUDmNun6Oq1KGVw+F/5yVJWNwwTZUz/ksjrSy
	 TrYwo7ZI7lE2Ro8zhVvcS+mtpcho4AhPHHwwc2WOCaD821J0gSW/yo5zKPXaQhLSdV
	 v0ED0rKlqz2jA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: KIM MinWoo <phrimm136@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ALSA: hda/realtek: Add quirk for Lenovo ThinkBook 16p Gen 3 ARH (21EK)
Date: Mon, 19 Oct 2026 09:52:02 -0400
Message-ID: <20261019135441.1420968-431-sashal@kernel.org>
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

From: KIM MinWoo <phrimm136@gmail.com>

[ Upstream commit 3867e38b2d4b844d89076f988c7b9741c87a9858 ]

The ThinkBook 16p Gen 3 ARH (SSID 17aa:3871) has a TI TAS2563
amplifier device on I2C, exposed by ACPI as INT8866, the same
arrangement as the Yoga 7 14ARB7 (SSID 17aa:3870). Without a quirk,
the codec falls back to the vendor-wide Lenovo quirk
(ALC269_FIXUP_LENOVO_XPAD_ACPI), the amplifier is never bound, and the
internal speakers stay silent while the headphone output works.

Reuse the Yoga 7 14ARB7 fixup, which binds the INT8866 device as a side
codec. ALC287_FIXUP_TAS2781_I2C does not work on this machine because it
looks for a TIAS2781 device.

Assisted-by: LLM
Signed-off-by: KIM MinWoo <phrimm136@gmail.com>
Link: https://patch.msgid.link/20260923013756.106033-1-phrimm136@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a one-line Realtek HDA quirk for ThinkBook 16p Gen 3 ARH. The
Yoga 7 INT8866 fixup already exists in this 6.18.57 tree; without the
new SSID the machine falls through to the Lenovo vendor quirk and
internal speakers stay silent.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: [ALSA hda/realtek] [Add] [PCI/codec SSID quirk for Lenovo
ThinkBook 16p Gen 3 ARH (21EK), SSID 17aa:3871]

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- Assisted-by: LLM
- Signed-off-by: KIM MinWoo <phrimm136@gmail.com> (author)
- Link:
  https://patch.msgid.link/20260923013756.106033-1-phrimm136@gmail.com
- Signed-off-by: Takashi Iwai <tiwai@suse.de> (ALSA maintainer; applied
  the patch)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable (absence expected)
- Ignore: `[ Upstream commit 3867e38b2d4b844d89076f988c7b9741c87a9858 ]`
  and `Signed-off-by: Sasha Levin` (pipeline markers)

Notable: ALSA maintainer SOB; hardware-tested in the mailing-list cover
(see Phase 4). LLM assistance is disclosed; maintainer still applied it.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: ThinkBook 16p Gen 3 ARH (SSID 17aa:3871) has a TI TAS2563 amp on
  I2C, ACPI HID INT8866 — same as Yoga 7 14ARB7 (17aa:3870).
- Symptom: internal speakers silent; headphone jack works.
- Root cause: no machine-specific quirk, so the codec falls back to
  vendor-wide `ALC269_FIXUP_LENOVO_XPAD_ACPI`; the amp is never bound.
- Fix: reuse `ALC287_FIXUP_YOGA7_14ARB7_I2C` (binds INT8866 as a side
  codec). `ALC287_FIXUP_TAS2781_I2C` is the wrong HID (TIAS2781).
- Version info: none in the commit body; author tested on 7.2.6-arch2-1
  (BIOS KCCN40WW) per mailing-list text.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. Explicit hardware quirk for silent speakers. Classic
stable exception (quirks/workarounds).

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `sound/hda/codecs/realtek/alc269.c` (+1 / −0)
- Function/table: `alc269_fixup_tbl[]`
- One `SND_PCI_QUIRK(0x17aa, 0x3871, "Lenovo ThinkBook 16p Gen 3 ARH",
  ALC287_FIXUP_YOGA7_14ARB7_I2C)` next to the existing 0x3870 Yoga 7
  entry
- Scope: single-file surgical quirk addition

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- Before: 17aa:3871 is unmatched in `alc269_fixup_tbl`.
  `snd_hda_pick_fixup()` then hits `alc269_fixup_vendor_tbl`
  `SND_PCI_QUIRK_VENDOR(0x17aa, ..., ALC269_FIXUP_LENOVO_XPAD_ACPI)`.
  That only runs `alc_fixup_ideapad_acpi` + ThinkPad ACPI; it does not
  bind INT8866. Speakers stay silent.
- After: 17aa:3871 selects `ALC287_FIXUP_YOGA7_14ARB7_I2C` →
  `yoga7_14arb7_fixup_i2c()` → `comp_generic_fixup(..., "i2c",
  "INT8866", ...)`. Chained to `ALC285_FIXUP_THINKPAD_HEADSET_JACK`.
- Path: probe/init only, one SSID.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: [Hardware workaround / missing quirk]
Mechanism: companion TAS2563 never bound without a matching SSID. Fix
reuses the existing INT8866 bind path. Confirmed:
`ALC287_FIXUP_TAS2781_I2C` uses `tas2781_fixup_tias_i2c()` → HID
`TIAS2781`; this machine is `INT8866`.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: one table entry, existing fixup, adjacent to
  17aa:3870.
- Minimal; no API/structure change.
- Regression risk very low: only SSID 17aa:3871. No other `0x3871` quirk
  in this file. Distinct from ThinkBook 16P 17aa:38a9/38ab (CS35L41).
- Caveat (not a kernel regression): author notes `TAS2XXX3871.bin` is
  not in linux-firmware; speakers worked after symlink to Yoga
  `TAS2XXX3870.bin`. The quirk is still required for component bind;
  firmware is a separate userspace/linux-firmware issue.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Neighbor 17aa:3870 Yoga 7 14ARB7: present since `b5cb53fd32779`
  (“ALSA: hda/tas2781: add fixup for Lenovo 14ARB7”, 2024-01-02, in
  v6.8-rc2 era).
- Fixup `ALC287_FIXUP_YOGA7_14ARB7_I2C` / `yoga7_14arb7_fixup_i2c()`
  present in this tree (moved into `alc269.c` by `aeeb85f26c3bb`,
  2025-07).
- 3871 line is the candidate itself. Bug is missing table entry, not bad
  logic, and has existed since the Yoga 7 path landed.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No Fixes: tag. Expected. Buggy “code” is the vendor fallback for
unmatched Lenovo SSIDs, which is in this tree at
`alc269_fixup_vendor_tbl`.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Yoga 7 14ARB7 quirk is already here (`SND_PCI_QUIRK(0x17aa, 0x3870,
  ...)`).
- TAS2781 I2C side codec with INT8866 ACPI ID is already here
  (`tas2781_hda_i2c.c`).
- Standalone one-liner; not part of a numbered series.
- Recent `alc269.c` history is other machine quirks; no prerequisite
  refactor needed on this tree.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Only this commit under `--author="KIM MinWoo"` in `sound/`. Not
the subsystem maintainer. Applied by Takashi Iwai (ALSA maintainer).
Recipients included TI TAS2781 contact Shenghao Ding.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record:
- Needs `ALC287_FIXUP_YOGA7_14ARB7_I2C`, `yoga7_14arb7_fixup_i2c()`,
  `comp_generic_fixup()`, and INT8866 in `snd_hda_scodec_tas2781_i2c`.
  All present in v6.18.57.
- `git merge-base --is-ancestor b5cb53fd32779 v6.18.57` → yes.
- Can apply standalone. No series dependency.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 3867e38b2d4b844d89076f988c7b9741c87a9858` →
  https://patch.msgid.link/20260923013756.106033-1-phrimm136@gmail.com
- `b4 dig -a`: single v1 series; no later revision.
- Thread (mbox): author tested on hardware. Without patch: `ALC287:
  picked fixup for PCI SSID 17aa:0000`. With patch: `picked fixup for
  codec SSID 17aa:3871` and `bound i2c-INT8866:00 (ops
  tas2781_hda_comp_ops)`. Wrong TAS2781 fixup left component “not
  bound”. Headphones, mics, mute/volume keys still worked.
- Takashi Iwai 2026-09-28: “Applied now. Thanks.” No NAK, no stable
  discussion.
- Author cites Fang Junhua alsa-devel 2026-03-04:
  “[ALSA][ALC287][TAS2781] Lenovo 21EK speakers silent on Linux,
  headphones work”, codec dump SSID 17aa:3871. Original Fang mail not
  independently fetched (lore HTTP 403).

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): KIM MinWoo; linux-sound@vger.kernel.org;
tiwai@suse.com; perex@perex.cz; shenghao-ding@ti.com. Right lists and
maintainers. Applied by Takashi Iwai; no separate Reviewed-by.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: Cover letter is the primary report (silent speakers, kernel
logs, TAS2781-I2C mismatch). Second user (Fang Junhua, machine type
21EK) cited; that lore fetch is UNVERIFIED beyond the cover letter.
Symptom matches.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone v1. Reuses Yoga 7 14ARB7 fixup already in this tree.
Not the Yoga Pro 9 16IMH9 TAS2781 PCI/codec collision (different SSID).

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: UNVERIFIED (lore.kernel.org/stable HTTP 403). Thread itself has
no stable nomination or rejection.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: No function body change. Adds a row in `alc269_fixup_tbl[]`.
Runtime path: `snd_hda_pick_fixup()` → `ALC287_FIXUP_YOGA7_14ARB7_I2C` →
`yoga7_14arb7_fixup_i2c()` → `comp_generic_fixup()` /
`hda_component_manager_init()`.

**Step 5.2: TRACE CALLERS**
Record:
- `alc269_probe`-style init calls `snd_hda_pick_fixup(codec,
  alc269_fixup_models, alc269_fixup_tbl, alc269_fixups)` then vendor
  table if unmatched (`alc269.c` ~8557–8572).
- Probe/enumeration, not IRQ/hot path.
- Impact: only SSID 17aa:3871. `snd_hda_pick_fixup()` matches PCI SSID
  first, then codec SSID (`auto_parser.c` 1066–1087). Author’s PCI SSID
  17aa:0000 still matches via codec SSID 17aa:3871.

**Step 5.3: TRACE CALLEES**
Record: `yoga7_14arb7_fixup_i2c` → `comp_generic_fixup(..., "INT8866")`
→ `hda_component_manager_init`. TAS2781 I2C driver matches ACPI
`{"INT8866", 0}` and treats it as HDA_TAS2563.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: User-reachable on this laptop at codec probe (boot / module
load). Unprivileged users get silent speakers, not a crash. Headset path
already works.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same table is full of Lenovo `SND_PCI_QUIRK` / `HDA_CODEC_QUIRK`
amp-bind entries. 17aa:3870 is the sibling. TAS2781-I2C entries use
TIAS2781; this machine must not use those.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- Local tree: VERSION 6.18.57, `git describe HEAD` =
  `v6.18.57-155-gcdf239ca885b2`.
- `make kernelversion` = 6.18.57.
- In **v6.18.57** (without this candidate): 17aa:3870 Yoga 7 entry
  exists; **17aa:3871 does not**. Vendor Lenovo XPAD fallback exists.
  INT8866 TAS2563 side-codec exists.
- `git merge-base --is-ancestor 2a2ad57597a9e v6.18.57` → not an
  ancestor (candidate is not in the 6.18.57 baseline).
- Bug exists here: unmatched 17aa:3871 → silent speakers.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply. File path `sound/hda/codecs/realtek/alc269.c`
already used (HDA split `aeeb85f26c3bb` is in v6.18.57). Context around
3870 matches. Expected difficulty: clean apply.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: Yoga 7 14ARB7 (3870) is here. No other 3871 quirk. ThinkBook 16P
38a9/38ab is a different SSID/amp (CS35L41). No substitute fix for 21EK.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: [sound/hda Realtek codec quirks] [IMPORTANT] — common laptop
audio, machine-specific. Not core mm/fs, but silent internal speakers is
a real user-facing bug.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: High activity; `alc269.c` regularly gets SSID quirks. Mature
table, well-understood pattern. Takashi Iwai maintains ALSA.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver/platform-specific: Lenovo ThinkBook 16p Gen 3 ARH (21EK),
SSID 17aa:3871. CONFIG_SND_HDA_CODEC_REALTEK plus TAS2781 I2C side codec
(already used for Yoga 7 14ARB7).

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Every boot on that machine. Not a race. Not unprivileged-
exploit. Author plus cited 21EK report.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Internal speakers silent (headphones work). Severity MEDIUM–HIGH
for those users (device unusable for speaker audio), not
panic/corruption. Standard stable quirk class.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- Benefit: high for 21EK owners on 6.18.y; existing fixup already
  shipped for Yoga 7.
- Risk: very low (1 line, SSID-scoped, maintainer-applied, hardware-
  tested).
- Ratio: strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real hardware bug: silent internal speakers on ThinkBook 16p Gen 3
  ARH.
- Hardware quirk exception in stable rules.
- 1-line reuse of fixup already in v6.18.57.
- Yoga 7 14ARB7 / INT8866 / TAS2563 path already present.
- Author kernel logs; ALSA maintainer applied v1; TI TAS2781 list CC’d.
- Applies cleanly; no new API/driver.

AGAINST:
- Affects one laptop SSID, not all users.
- `TAS2XXX3871.bin` may still be missing from linux-firmware (author
  used 3870 symlink). Does not make the quirk wrong or unsafe.
- Author is not the maintainer; LLM-assisted. Offset by hardware test
  and maintainer apply.

UNRESOLVED:
- Fang Junhua lore thread not independently fetched (403).
- No stable@ discussion found (lore 403).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? [PASS — 1-line table add; tested on
   21EK; maintainer applied]
2. Fixes a real bug that affects users? [PASS — silent speakers]
3. Important issue? [PASS — hardware workaround / silent speakers;
   stable quirk exception]
4. Small and contained? [PASS — +1 line, one file]
5. No new features or APIs? [PASS — existing fixup, new SSID only]
6. Can apply to the local tree? [PASS — v6.18.57 has the file, fixup,
   and INT8866 driver]

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Hardware quirk/workaround (HDA `SND_PCI_QUIRK`). Qualifies
automatically when the driver/fixup already exist.

**Step 9.4: MAKE YOUR DECISION**
Backport. The v6.18.57 tree already has the Yoga 7 INT8866 fixup and
TAS2563 side codec; it lacks only SSID 17aa:3871, so this machine hits
the Lenovo vendor fallback and never binds the amp. One matching table
line is the correct, low-risk stable fix.

Verification:
- [Phase 1] Parsed tags: author SOB, Link to msgid, Takashi Iwai SOB; no
  Fixes/Cc:stable (expected)
- [Phase 2] Diff: +1 `SND_PCI_QUIRK(0x17aa, 0x3871, ...,
  ALC287_FIXUP_YOGA7_14ARB7_I2C)` in `alc269_fixup_tbl`
- [Phase 2] `ALC287_FIXUP_TAS2781_I2C` → `tas2781_fixup_tias_i2c()` HID
  TIAS2781; Yoga fixup HID INT8866 — mismatch confirmed in code
- [Phase 2] Vendor fallback `SND_PCI_QUIRK_VENDOR(0x17aa, ...,
  ALC269_FIXUP_LENOVO_XPAD_ACPI)` confirmed at alc269.c:7739
- [Phase 3] `git describe HEAD` / `make kernelversion`:
  v6.18.57-155-gcdf239ca885b2 / 6.18.57
- [Phase 3] `git merge-base --is-ancestor 2a2ad57597a9e v6.18.57`: not
  in 6.18.57 baseline
- [Phase 3] v6.18.57 has 17aa:3870 and `ALC287_FIXUP_YOGA7_14ARB7_I2C`;
  does not have 17aa:3871
- [Phase 3] Yoga 7 fixup from `b5cb53fd32779` (2024-01-02) is ancestor
  of v6.18.57
- [Phase 3] INT8866 in `tas2781_hda_i2c.c` present in v6.18.57 (ACPI
  match + HDA_TAS2563)
- [Phase 4] `b4 dig -c 3867e38b2d4b...`: lore msgid
  20260923013756.106033-1-phrimm136@gmail.com
- [Phase 4] `b4 dig -a`: v1 only; `b4 dig -w`: linux-sound, tiwai,
  perex, shenghao-ding@ti.com
- [Phase 4] mbox: hardware logs; Takashi “Applied now”; Fang Junhua 21EK
  citation
- [Phase 4] lore.kernel.org WebFetch 403 — stable@ search UNVERIFIED
- [Phase 5] `snd_hda_pick_fixup()` PCI then codec SSID; 17aa:0000 PCI
  still matches codec 17aa:3871
- [Phase 6] Clean apply on this tree’s `alc269.c` path; no 3871
  collision
- [Phase 8] Failure: silent internal speakers on 21EK; not crash; quirk-
  scoped
- UNVERIFIED: Fang Junhua original mail body; linux-firmware
  TAS2XXX3871.bin status; stable@ archive

The patch is a one-line SSID quirk, reuses a fixup this tree already
ships, and restores speaker amp bind on a real Lenovo model with
maintainer ack.

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 10d930d8fed72..b1cb93922c3bc 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7527,6 +7527,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	HDA_CODEC_QUIRK(0x17aa, 0x38a7, "Legion Pro 7 16ARX8H", ALC287_FIXUP_TAS2781_I2C), /* this must match before PCI SSID 17aa:386f below */
 	SND_PCI_QUIRK(0x17aa, 0x386f, "Legion Pro 7i 16IAX7", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3870, "Lenovo Yoga 7 14ARB7", ALC287_FIXUP_YOGA7_14ARB7_I2C),
+	SND_PCI_QUIRK(0x17aa, 0x3871, "Lenovo ThinkBook 16p Gen 3 ARH", ALC287_FIXUP_YOGA7_14ARB7_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3874, "Legion 7i 16IAX7", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3877, "Lenovo Legion 7 Slim 16ARHA7", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3878, "Lenovo Legion 7 Slim 16ARHA7", ALC287_FIXUP_CS35L41_I2C_2),
-- 
2.53.0

