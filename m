Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B063641288;
	Mon, 19 Oct 2026 14:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418774; cv=none; b=tEEJf1Cg8YJfbYsrKHqLaHKpHZb1OV0BaePJI8r4kO//g1IXbyc0R5XWK/hFexSS9nI1b4ycL5f3bgCkGxXce7nZBuwJ+J550KVNwRsij9T5F0+u4xCOv+zoPd//2fGiCDDZXeGxMNX5wcYb1PV9jty6MKWPkgqqj1owlnCvePM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418774; c=relaxed/simple;
	bh=oe6hVInF5aLxtdWXAIN49eG/HWZpwC2kv6SsCUy4m0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aFKkG+Paaq9SXHMTtPvoIJrO5PmXkzqYjS6jecn2DaxpQZhH9FmU8qYS9rB/ks0gnel97NIgz1sJ4QmKRACOA+uvjSS1eJFfd0KCyjwDRyozlxLACgi1zvneI0bIotIgpO3eN6iDY8JRP4HgTwRYfzfJflgSj/c/Hw1DLCLYsRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DF0XqVbh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DF0XqVbh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 685AA1F000C8;
	Mon, 19 Oct 2026 14:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418771;
	bh=pHMYaTG+i0R8a6QfGfVBBIxsW7wzkijgDYrGOyUsDjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DF0XqVbhpPinEoWy1xidJzeGr4qff+ET//kGMIekGJfKjKR4Vb8KRAaPc6D27X53g
	 sZ1I04RiAJJJw5wNXjRJDQ18y2MdCYKEuDPR+0tqykVgbig2AOfmV3aapqXqxSFpki
	 JGOpL2yzh89YpRr3x/hU+fLyBO6RHi7K4pkFuf4STTjnog1y1NeWTomkMzlytv6OfV
	 i181cvjEpcln7ihtzfF2wOsnAko8LnIK9YvT92kVjhCDKPHm/JIe5C7ATK4Et/+G3J
	 nl+XvGAp0sBo9DlIyrtzCfxKkTWtkijE/1re62dlXOcmJ3jKQ3or/d5znTwj/HX2Ea
	 fX7F5sc33gTPw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mauricio Orozco <maudob@live.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] ALSA: hda/realtek: Add quirk for ASUS VivoBook M515DA/X515DAP
Date: Mon, 19 Oct 2026 09:52:55 -0400
Message-ID: <20261019135441.1420968-484-sashal@kernel.org>
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

From: Mauricio Orozco <maudob@live.com>

[ Upstream commit a9fa2a016e805504223abf8c9b373ac9f7bfb9b3 ]

The ASUS VivoBook M515DA/X515DAP (subsystem ID 1043:1e3e)
requires the ALC256_FIXUP_ASUS_MIC_NO_PRESENCE fixup to
enable the internal microphone.

Without this quirk, the internal microphone captures only
silence under Linux, while it works correctly under Windows.

The fix has been verified on real hardware.
Tested on an ASUS VivoBook M515DA/X515DAP running Linux Mint
22.3 with Ubuntu HWE kernel 7.0.0-28.

Signed-off-by: Mauricio Orozco <maudob@live.com>
Link: https://patch.msgid.link/20260730033506.8958-1-mauoro3@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a one-line ALSA Realtek SSID quirk for a 2020 ASUS VivoBook. The
local tree is **5.15.221** (`pending-5.15`). The Realtek table lives at
`sound/pci/hda/patch_realtek.c` here, not the later `alc269.c` path, but
the same fixup and quirk table already exist.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [ALSA hda/realtek] [add] [SSID quirk so ASUS VivoBook
M515DA/X515DAP internal mic works]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Mauricio Orozco <maudob@live.com> (author)
- Link: https://patch.msgid.link/20260730033506.8958-1-mauoro3@gmail.com
- Signed-off-by: Takashi Iwai <tiwai@suse.de> (ALSA maintainer)
- No Fixes: tag (expected)
- No Cc: stable (expected)
- No Reported-by / Tested-by / Reviewed-by / Acked-by
- Ignore any pipeline "Upstream commit" / "Signed-off-by: Sasha Levin"
  markers; they are not evidence of selection

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: ASUS VivoBook M515DA/X515DAP, PCI/codec SSID **1043:1e3e**,
  internal mic records silence on Linux; works on Windows.
- Symptom: functional capture failure (silent input), not a crash.
- Root cause implied: BIOS pin config does not describe the mic; needs
  existing `ALC256_FIXUP_ASUS_MIC_NO_PRESENCE`.
- Version info: tested on Linux Mint 22.3 with Ubuntu HWE kernel
  7.0.0-28 on real hardware.
- Author explains the needed fixup and the user-visible failure; does
  not claim a new API.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a disguised cleanup. This is an explicit hardware quirk: add
one `SND_PCI_QUIRK` so an existing pin fixup is applied.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File in the candidate: `sound/hda/codecs/realtek/alc269.c` (+1 line)
- Function/table: `alc269_fixup_tbl[]`
- Scope: single-file, one-line surgical table addition
- This 5.15 tree: that path does **not** exist; equivalent is
  `sound/pci/hda/patch_realtek.c`

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: SSID 1043:1e3e is not in `alc269_fixup_tbl`, so
  `snd_hda_pick_fixup()` does not apply this MIC_NO_PRESENCE pin
  rewrite.
- After: that SSID matches and applies
  `ALC256_FIXUP_ASUS_MIC_NO_PRESENCE`.
- Path: codec probe / initialization, not a hot path or error path.
- In this tree, `alc269_probe()` calls `snd_hda_pick_fixup(...,
  alc269_fixup_tbl, alc269_fixups)` then pin-fallback tables. A PCI-SSID
  hit sets `codec->fixup_id`, so later `snd_hda_pick_pin_fixup()`
  returns immediately.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- Category: **hardware workaround / audio codec quirk**
- Mechanism: remap NID 0x19 to `0x04a11120` (headset mic, no jack
  detect) and chain `ALC256_FIXUP_ASUS_HEADSET_MODE` →
  `alc_fixup_headset_mode`. Without that, auto-parse leaves the internal
  mic unusable (silence).
- Same pattern already used in this tree for other ASUS machines
  (X430UN, X509DAP, pin-quirk ASUS ALC256 entries).

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: one table entry, existing fixup, SSID-gated.
- Regression risk: confined to 1043:1e3e. Wrong-SSID collision would
  only affect that ID; ASUS SSIDs are SKU-specific. No locking, alloc,
  or API change.
- Upstream insert is slightly unsorted (0x1e3e placed after 0x1e10,
  before 0x1e11). Lookup is linear in `snd_pci_quirk_lookup_id()`, so
  order is not a functional issue.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- `ALC256_FIXUP_ASUS_MIC_NO_PRESENCE` introduced in `e1037354a0a75a`
  (Jian-Hong Pan, 2019-03-22), contained in **v5.1-rc3**, ancestor of
  this HEAD.
- Nearby 0x1e11 entry blamed to `4b43d05a1978a9` (2020-07-24).
- Bug is missing table row, not a later regression. Hardware is ~2020
  VivoBook 15 (Ryzen 3000).

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Not applicable. The "bug" is incomplete BIOS pin
config, not a prior kernel commit.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- This tree already backported the same class of fix: `82199bb33185f`
  "ALSA: hda/realtek: Add quirk for ASUS VivoBook X509DAP" (also
  `ALC256_FIXUP_ASUS_MIC_NO_PRESENCE`).
- Many other "Add quirk" commits on `patch_realtek.c`.
- Standalone; not patch X/Y.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record:
- Mauricio Orozco has no prior commits under `sound/pci/hda/` in this
  tree.
- Applied by Takashi Iwai (ALSA maintainer). Weight comes from
  maintainer acceptance plus hardware test, not author history here.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record:
- Needs `ALC256_FIXUP_ASUS_MIC_NO_PRESENCE`, `alc269_fixup_tbl`,
  `SND_PCI_QUIRK`, ALC256 in `alc269` probe. All present.
- Does not need later-only IDs (`ALC245_FIXUP_CS35L41_SPI_2`,
  `HDA_CODEC_QUIRK`, etc.).
- Can apply standalone after rewriting the path/context.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- b4 mbox msgid `20260730033506.8958-1-mauoro3@gmail.com`: 2 messages.
- Submission: https://lists.openwall.net/linux-kernel/2026/07/30/304
  (also lkml.iu.edu).
- Single v1; no v2/v3.
- Reply: Takashi Iwai 2026-08-03: "Applied to for-next branch now.
  Thanks." No NAK, no requested changes.
- lore.kernel.org WebFetch returned 403 (Anubis). Thread recovered via
  b4 + openwall/lkml mirrors.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record:
- To: tiwai@suse.com, perex@perex.cz
- Cc: linux-sound, linux-kernel, maudob@live.com
- Appropriate maintainers were on the original mail. Maintainer applied
  it. No extra Reviewed-by.

Step 4.3: SEARCH FOR THE BUG REPORT
Record:
- No bugzilla/syzbot link. Evidence is the author's hardware test
  (silent mic vs Windows).
- No additional independent public reports found beyond this patch
  thread.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone 1/1 patch. Closest sibling already in this tree:
VivoBook X509DAP MIC_NO_PRESENCE quirk.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: No stable@ discussion found for M515DA/X515DAP. No recorded
reason to exclude it. This tree's `stable-kernel-rules.rst` line 24:
"New device IDs and quirks are also accepted."

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: No function body change. Data: `alc269_fixup_tbl[]`. Consumers:
`snd_hda_pick_fixup()` from `alc269_probe()`; applied fixup
`ALC256_FIXUP_ASUS_MIC_NO_PRESENCE` → `alc_fixup_headset_mode`.

Step 5.2: TRACE CALLERS
Record:
- `alc269_probe()` in `patch_realtek.c` (~10555) calls
  `snd_hda_pick_fixup(..., alc269_fixup_tbl, ...)`.
- ALC256 (`0x10ec0256`) is handled in that probe (`spec->codec_variant =
  ALC269_TYPE_ALC256` at ~10475).
- Trigger: HDA codec probe at boot / module load for that laptop. Not
  IRQ/syscall hot path.

Step 5.3: TRACE CALLEES
Record: `snd_hda_pick_fixup` → `snd_pci_quirk_lookup` /
`snd_pci_quirk_lookup_id` (linear SSID match in `sound/core/misc.c`).
Then pin overwrite + `alc_fixup_headset_mode`.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Userspace capture (PulseAudio/PipeWire/arecord) uses the HDA PCM
created at probe. Unprivileged users on this laptop hit the silent-mic
bug. Reachable and user-visible.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Multiple `ALC256_FIXUP_ASUS_MIC_NO_PRESENCE` entries already in
this tree (X430UN 0x1271, X509DAP 0x197e, three ASUS pin quirks, Huawei
WRT-WX9). Systematic ASUS ALC256 BIOS-pin problem; this is another SSID.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record:
- Local: **5.15.221**, branch `pending-5.15`, `git describe`
  `p-5.15-2-g6703e5d2f3a29`.
- Quirk table: `alc269_fixup_tbl` at
  `sound/pci/hda/patch_realtek.c:9132`.
- SSID **0x1e3e is absent** (`grep` over `sound/pci/hda` found no
  match).
- Fixup exists at enum line 7146 and table 8393–8401.
- Insertion point: around the existing 0x1e11 Zephyrus G15 entry (line
  9449). 0x1e10 X507UAR is not in 5.15.
- Bug is missing hardware enablement, present since the driver shipped
  without this SSID.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: **Minor context/path rewrite, not a semantic rework.** Upstream
file was split later to `sound/hda/codecs/realtek/alc269.c`. Same one-
line add used for X509DAP (`82199bb33185f` → `patch_realtek.c`).
Surrounding mainline-only quirks are not required.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No M515DA/0x1e3e entry. Pin quirks for other ASUS ALC256 pin
maps exist, but this machine still needs the SSID quirk (author: mic is
silent without it). `snd_hda_pick_pin_fixup` only runs if no SSID fixup
matched; it did not save this SKU.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: [sound/pci/hda Realtek codec] [IMPORTANT for laptop audio;
PERIPHERAL as a single SKU]. Affects owners of this ASUS model only.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Mature, actively patched in 5.15-stable with many quirk
backports. This is long-lived Realtek HDA code, not a post-5.15
subsystem.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver-specific / platform-specific: ASUS VivoBook
M515DA/X515DAP (SSID 1043:1e3e), ALC256. Ubuntu 22.04-class 5.15 users
still run these 2020 machines.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Every boot / every capture on that laptop. Not a race.
Unprivileged user can trigger (open the mic). Common for that hardware,
zero impact elsewhere.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: Internal microphone captures silence. Not panic/corruption.
Severity **MEDIUM** functionally, but it is a real hardware-broken-on-
Linux bug. Audio codec quirks are an explicit stable exception.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: restores internal mic on a real, still-deployed VivoBook;
  same class as quirks already in 5.15.y.
- Risk: very low (one SSID-matched line, existing fixup).
- Ratio: high benefit for those users, negligible risk to everyone else.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE

FOR backporting:
- Real user-visible bug: internal mic silent on Linux, works on Windows.
- Verified on real hardware; ALSA maintainer applied v1 with no
  objections.
- One-line `SND_PCI_QUIRK` using a fixup present since v5.1.
- Stable rules in this tree explicitly allow new device IDs and quirks.
- Identical VivoBook ALC256 MIC_NO_PRESENCE quirk already backported
  here (X509DAP).
- Hardware (2020) is in the 5.15 user population.
- No new APIs, no refactor, no series dependencies.

AGAINST:
- Not a crash/security/corruption issue (quirk exception covers this).
- Upstream path differs; needs a one-line backport to `patch_realtek.c`.
- No extra independent reporters beyond the author.
- Tested on kernel 7.0, not 5.15 — unverified on this exact series, but
  the missing SSID and the fixup are the same.

UNRESOLVED:
- Could not fetch lore.kernel.org HTML (403). Thread contents confirmed
  via b4 mbox and public mirrors.
- Could not confirm codec pin dump for this SKU beyond the author's SSID
  + chosen fixup.
- No stable@ thread found.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — one SSID line; tested on
   hardware; maintainer applied.
2. Fixes a real bug that affects users? **PASS** — silent internal mic.
3. Important issue? **PASS** under the quirk exception (and "oh, that's
   not good" hardware breakage); not CRITICAL crash.
4. Small and contained? **PASS** — +1 line.
5. No new features or APIs? **PASS** — existing fixup, new ID only.
6. Can apply to the local tree? **PASS** — table and fixup exist;
   path/context rewrite only.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: **Hardware quirk / audio codec quirk** (`SND_PCI_QUIRK` in
Realtek HDA). Also treated like a device-ID addition to an existing
driver.

Step 9.4: MAKE YOUR DECISION
This should be backported to this 5.15 tree. It is the standard Realtek
laptop microphone quirk: small, SSID-scoped, already-used fixup, real
hardware confirmation, and this tree already takes the same kind of
patch.

What it solves for stable users: 5.15 LTS systems on ASUS VivoBook
M515DA/X515DAP currently get a dead internal mic. The quirk applies
`ALC256_FIXUP_ASUS_MIC_NO_PRESENCE` so capture works.

Risk vs benefit: one table entry vs restoring mic on that SKU. Backport
adjustment is the file path (`alc269.c` → `patch_realtek.c`) and
inserting next to the existing 0x1e11 ASUS entry.

Verification:
- [Phase 1] Parsed tags: author SOB, Link msgid, Takashi Iwai SOB; no
  Fixes/Cc-stable/Reported-by
- [Phase 2] Diff: +1 `SND_PCI_QUIRK(0x1043, 0x1e3e, ...,
  ALC256_FIXUP_ASUS_MIC_NO_PRESENCE)` in `alc269_fixup_tbl`
- [Phase 2] Read fixup at `patch_realtek.c:8393-8401`: pin 0x19 →
  0x04a11120, chained to `ALC256_FIXUP_ASUS_HEADSET_MODE`
- [Phase 2] Read `alc_fixup_headset_mode` chain at 8101–8104
- [Phase 3] `git describe HEAD` / Makefile: 5.15.221, `pending-5.15`,
  `p-5.15-2-g6703e5d2f3a29`
- [Phase 3] `git blame` fixup: `e1037354a0a75a`, `git merge-base --is-
  ancestor` of HEAD, `git describe --contains` → v5.1-rc3
- [Phase 3] `git log --grep=M515DA` / `0x1e3e` on `patch_realtek.c`:
  empty
- [Phase 3] Precedent: `82199bb33185f` X509DAP same fixup already in
  HEAD
- [Phase 4] `b4 mbox` msgid: v1 patch + Takashi "Applied to for-next";
  no NAK
- [Phase 4] Openwall/LKML mirrors match that thread
- [Phase 4] lore WebFetch: 403; contents taken from b4 mbox instead
- [Phase 4] WebSearch stable@: no discussion of this SKU
- [Phase 5] `alc269_probe` at 10555 uses `alc269_fixup_tbl`; ALC256 case
  at 10475; pick_pin_fixup skips if SSID already matched (934–942)
- [Phase 5] `snd_pci_quirk_lookup_id` linear match in
  `sound/core/misc.c`
- [Phase 6] File `sound/hda/codecs/realtek/alc269.c` missing;
  `sound/pci/hda/patch_realtek.c` present;
  `ALC256_FIXUP_ASUS_MIC_NO_PRESENCE` present; 0x1e3e absent
- [Phase 6] `Documentation/process/stable-kernel-rules.rst` line 24:
  quirks accepted
- [Phase 8] Failure mode: silent internal mic, SSID-scoped, low
  regression risk
- UNVERIFIED: live pin dump for 1043:1e3e; lore HTML; runtime test on
  5.15 itself

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 3364f6ad91fcb..4cadbad99537a 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7196,6 +7196,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1264, "ASUS UM5606KA", ALC294_FIXUP_BASS_SPEAKER_15),
 	SND_PCI_QUIRK(0x1043, 0x1e02, "ASUS UX3402ZA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1e10, "ASUS VivoBook X507UAR", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1043, 0x1e3e, "ASUS VivoBook M515DA/X515DAP", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1e11, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA502),
 	SND_PCI_QUIRK(0x1043, 0x1e12, "ASUS UM3402", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1e1f, "ASUS Vivobook 15 X1504VAP", ALC2XX_FIXUP_HEADSET_MIC),
-- 
2.53.0

