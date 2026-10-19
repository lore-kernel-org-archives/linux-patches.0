Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA855ABF7B;
	Mon, 19 Oct 2026 14:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418410; cv=none; b=NcHOm8SoCzqtoMZVBw0L98W4QUHOEFoApbgfhCidzB2jGlKIqB8KSE060YpdytOA6QvrPa3o8mgA5hVf8+ygGn384VcCbR0b5/821yc9DxQDu9rljgXj0qR5NJjCaIimmCIgR70IJJwqBtpx9svFDUB9Zzid1KHxVlS9WETGm48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418410; c=relaxed/simple;
	bh=QQb5amkX+AoAq9d9FpG+JxLlgkobSQTpCg30XPhuhWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RYbNpWf2CepVS+HI6G7miWYkkpdC3Fcf91yA+MBcldE8nt4+21ZH2hpRc35gv+esT3kTz2+4VoU0NH60axfIaWRCiE1YAbfsLrWqH49inZ8Nt4BfaWSMk7QqgAkiwbKX5xvjY9kT4vc7sYemBNg0wwizZIpVMAUtd5AihoSp7RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nAgK0xFI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nAgK0xFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A56D1F000C8;
	Mon, 19 Oct 2026 14:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418408;
	bh=xoTKV3M8GmmqDWmsLODWYpzc55wzjxje2rpf/1XPiWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nAgK0xFI7HrYYBkg+0FEKlN+nrNdP9hNcrA1ElvTAt7igYSoXnYvap2p9TUFEuEBy
	 faqaCq1aYr6Os1+Qk2D41A8P8TjNSWmhBRtWr69/aXooGkQhT7Qe78M4qnNN+plWBj
	 IaqTIga8XhqEYbdIuCuP0BasBW//It/RP1Wj+T7SESDU2AjUJg80ToPvmlAddKzNTF
	 ivso4etOdQoNhWZohEmyZC4HlTiM6kaTre2f5RDycYNKIYwz0sp9XEx8yNVOlemowt
	 Yr5Ky8Al3y8Il9oN9mAFTSWf0c6gDuibDjhQwmro63qGgfgIIyi08TTzUmkWYQZ4iO
	 btta96EY0mqMg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Eckhart Mohr <e.mohr@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ALSA: hda/realtek: Add quirk for ASRock NUC BOX-358H
Date: Mon, 19 Oct 2026 09:48:39 -0400
Message-ID: <20261019135441.1420968-228-sashal@kernel.org>
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

From: Eckhart Mohr <e.mohr@tuxedocomputers.com>

[ Upstream commit 9a44b828dd7c0be1d0d6d6cf178d9727ceb6da6e ]

Fix headphone jack detection for some devices

Signed-off-by: Eckhart Mohr <e.mohr@tuxedocomputers.com>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20261001183403.103990-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a one-line Realtek HDA hardware quirk for the ASRock NUC
BOX-358H. The local tree is **6.18.57**. The same jack-detect fixup
already exists here; only the new PCI SSID is missing.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[ALSA/hda/realtek] [Add] quirk for ASRock NUC BOX-358H`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Signed-off-by: Eckhart Mohr <e.mohr@tuxedocomputers.com>` (author)
- `Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>` (Tuxedo;
  submitted the patch)
- `Link: https://patch.msgid.link/20261001183403.103990-1-
  wse@tuxedocomputers.com`
- `Signed-off-by: Takashi Iwai <tiwai@suse.de>` (ALSA maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, or `Cc:
  stable` on the committed message
- Ignore pipeline tags (`[Upstream commit 9a44b828...]`, `Signed-off-by:
  Sasha Levin`)

Notable: no `Cc: stable` on the commit itself. That is expected for this
review queue. On-list, Werner later asked for stable (Phase 4).

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: headphone jack detection fails on some devices (the ASRock NUC
  BOX-358H)
- Symptom: jack not detected / audio jack unusable until the codec is
  quirked
- Version info: none in the message
- Root cause (from this message): not spelled out beyond “fix headphone
  jack detection”
- The sibling 2021 quirk for ASRock NUC Box 1100 (`174a7fb3859ae`)
  documents the mechanism: cold boot leaves COEF values that hide the
  jack; warm reboot from another OS preserves working COEF dumps. This
  commit reuses that same `ALC233_FIXUP_NO_AUDIO_JACK` for a new SSID.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. It is an explicit hardware quirk. The
“Add quirk” wording is the standard ALSA form for a real device bug.

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `sound/hda/codecs/realtek/alc269.c` (`+1 / -0`)
- Function/data: `alc269_fixup_tbl[]`
- Scope: single-file, one-line table entry

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- Before: PCI SSID `0x1849:0x6256` has no match in `alc269_fixup_tbl`,
  so `snd_hda_pick_fixup()` does not apply `ALC233_FIXUP_NO_AUDIO_JACK`
- After: that SSID maps to `alc233_fixup_no_audio_jack()`, which writes
  the existing COEF table via `alc_process_coef_fw()`
- Path: codec probe / init, not an error path

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- Category: **(h) Hardware workaround** — `SND_PCI_QUIRK` for ASRock
  (`0x1849`) product `0x6256`
- Mechanism: same COEF default programming already used for ASRock NUC
  Box 1100 (`0x1849:0x1233`)
- No leak, race, UAF, or locking change

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Quality: obviously correct as a SSID-scoped reuse of an existing fixup
- Minimal: one table line, no unrelated edits
- Regression risk: very low. `SND_PCI_QUIRK` matches PCI subsystem
  vendor/device only. `0x6256` does not appear on any other HDA quirk in
  this tree
- Residual (not a reason to reject): the 358H ships a Realtek ALC256;
  the fixup name is ALC233. That is pre-existing reuse of the 1100 COEF
  dump. Tuxedo submitted it and Takashi applied it with no objection

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Insertion sits next to the 1100 entry from `174a7fb3859ae` (Werner
  Sembach, 2021-11-12, `Cc: stable`)
- Surrounding table came into `alc269.c` via `aeeb85f26c3bb`
  (2025-07-11, “Split Realtek HD-audio codec driver”), which is an
  ancestor of `v6.18.57`
- The buggy *behavior* is missing SSID coverage, not a recently
  introduced logic bug. The 1100 workaround has been in-tree since
  v5.16-era (Nov 2021)

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Not applicable. The analogous original commit
is `174a7fb3859ae` (“Add quirk for ASRock NUC Box 1100”), present in
this tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Recent `alc269.c` history is full of similar one-line/small quirk
  additions (HP mute LEDs, ASUS speakers, Lenovo SSIDs, etc.), including
  several already in 6.18.y
- No later follow-up in this tree mentioning `358H` or `0x6256`
- Standalone, not `patch X/Y`

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record:
- Eckhart Mohr / Werner Sembach (Tuxedo Computers) regularly submit
  Realtek quirks
- Takashi Iwai applied this; he is the ALSA HD-audio maintainer
- Same authors shipped the 1100 quirk that this extends

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record:
- Needs `ALC233_FIXUP_NO_AUDIO_JACK`, `alc233_fixup_no_audio_jack()`,
  and `alc269_fixup_tbl` — all present on `v6.18.57` and on the
  candidate’s parent
- Parent of `8fa1cfe41877d` does **not** contain `0x1849, 0x6256`
- Applies standalone

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 8fa1cfe41877d`: match at https://patch.msgid.link/202610011
  83403.103990-1-wse@tuxedocomputers.com
- `b4 dig -a`: **v1 only**, no later revisions
- LKML: Takashi: “Applied now. Thanks.” (2026-10-03)
- Werner: “again i forgot to add cc stable can you add that in your
  branch?” (2026-10-03)
- Takashi: “Just send a post again to stable once when the commit is
  merged to Linus tree.” (2026-10-04)
- No NAKs, no risk flags
- lore.kernel.org direct fetches returned HTTP 403; thread recovered via
  `b4 dig` + lkml.iu.edu

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`):
- To/Cc: Werner Sembach, Eckhart Mohr, Jaroslav Kysela, Takashi Iwai,
  linux-sound, linux-kernel
- Right maintainers and list were on the original recipients
- Applied by Takashi Iwai

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record:
- No syzbot/bugzilla link
- Vendor hardware is real: ASRock Industrial NUC BOX-358H (Intel Core
  Ultra Series 3 / Panther Lake-H), front combo jack, Realtek ALC256
  (asrockind.com)
- ServeTheHome even has a photo titled around the 358H audio jack
- User impact is that specific mini-PC’s headphone/mic jack

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone v1. Only related in-tree work is the 2021 1100 quirk,
already present.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search did not turn up a dedicated stable
thread for this SSID. Absence of an auto `Cc: stable` is why this is in
manual review. The author still requested stable on the original thread.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: No function body changes. Data: `alc269_fixup_tbl[]`. Runtime
effect goes through existing `alc233_fixup_no_audio_jack()` →
`alc_process_coef_fw()`.

**Step 5.2: TRACE CALLERS**
Record:
- `alc269_fixup_tbl` is passed to `snd_hda_pick_fixup()` in the
  ALC269-family probe path (`alc269.c` ~8557)
- `snd_hda_pick_fixup()` matches PCI subsystem vendor/device first
  (`sound/hda/common/auto_parser.c`)
- Called at codec init for Realtek ALC269-family devices (includes
  ALC256, vendor id `0x10ec0256`)

**Step 5.3: TRACE CALLEES**
Record:
- `alc_process_coef_fw()` writes the COEF firmware table (`WRITE_COEF`
  for indices 0x1a, 0x1b, 0x37, 0x38, 0x45, 0x46, 0x49)
- No allocations, no locks added

**Step 5.4: FOLLOW THE CALL CHAIN**
Record:
- Reachable when this NUC’s HDA codec probes (boot / module load)
- Userspace does not need a special syscall; plugging headphones is the
  user-visible path
- Not a security/syzbot path; it is a device init quirk

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Identical pattern already used for `0x1849:0x1233` (NUC Box
1100). Many other `SND_PCI_QUIRK` rows in the same table. `0x6256` is
unique in ALSA HDA.

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- Local tree: `git describe HEAD` = `v6.18.57-155-gcdf239ca885b2`; `make
  kernelversion` = `6.18.57`
- `v6.18.57:sound/hda/codecs/realtek/alc269.c` has
  `ALC233_FIXUP_NO_AUDIO_JACK` and the 1100 SSID
- `v6.18.57` does **not** contain `0x1849, 0x6256`
- Context around the 1100 row on `v6.18.57` matches the patch (verified
  by string match)
- Candidate commit `8fa1cfe41877d` is an ancestor of current HEAD
  because this autosel checkout already contains evaluation commits;
  that is **not** treated as “already selected”

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Expected **clean apply** onto 6.18.57. File path and surrounding
table rows match. No refactor needed.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: The 1100 quirk is here. There is no alternate 358H fix. No
follow-up revert/correction in this tree.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record:
- Subsystem: ALSA HD-audio / Realtek codec (`sound/hda/codecs/realtek/`)
- Criticality: **IMPORTANT** for users of this hardware; **PERIPHERAL**
  for everyone else (SSID-gated)

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature, actively maintained quirk table. Frequent small
hardware-quirk backports in 6.18.y.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver-specific / platform-specific: ASRock NUC BOX-358H (`PCI
SSID 1849:6256`). Other machines unchanged.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record:
- Trigger: boot on that NUC, then use the front combo jack
- Common for owners of that box; zero for others
- Unprivileged users hit it (jack detect), but this is not an exploit

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record:
- Failure: headphone/headset jack not detected (broken analog audio I/O
  on a machine that has a jack)
- Severity: **MEDIUM** for functional impact (not a panic/UAF), **HIGH**
  for that device’s usability
- Matches the documented 1100 failure: jack dead on cold boot

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- Benefit: high for 358H users on 6.18.y (this series is still current
  as of Oct 2026; this is a 2026 Panther Lake NUC)
- Risk: very low (1 line, existing fixup, SSID-matched)
- Ratio: strongly favors backport

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Textbook stable exception: hardware quirk / PCI ID on an existing
  driver
- Real user-visible bug: jack detection
- 1-line, existing fixup, no new API
- Prerequisites present in 6.18.57; applies cleanly
- ALSA maintainer applied it
- Submitter explicitly asked for stable
- Same pattern as the 2021 1100 quirk, which was `Cc: stable`
- Tuxedo-tested on the named device

AGAINST:
- Short commit body
- No `Fixes:` / no sanitizer report (expected for a quirk)
- COEF table originally dumped for the 1100 (ALC233-named); 358H is
  ALC256 per vendor specs — accepted by maintainer, SSID-limited

UNRESOLVED:
- Could not fetch lore.kernel.org HTML (403); discussion recovered via
  `b4 dig` and LKML archives
- Did not independently dump COEFs on a 358H (not available)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — one SSID row; Tuxedo
   authors; maintainer applied
2. Fixes a real bug that affects users? **PASS** — jack detection on a
   shipping NUC
3. Important issue? **PASS** as a hardware quirk (broken jack; not a
   panic, but the documented exception class)
4. Small and contained? **PASS** — +1 line
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — clean on 6.18.57

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **Hardware quirk / PCI ID addition to an existing driver.**
Automatic YES class.

**Step 9.4: MAKE YOUR DECISION**
Backport. The 6.18.57 tree already has the fixup and the 1100 SSID; it
only lacks `0x1849:0x6256`. That is exactly the class of change stable
exists to take.

What it solves for stable users: on ASRock NUC BOX-358H, the Realtek
jack is not detected unless this COEF quirk runs. Without it, the combo
headphone/mic jack stays broken on cold boot.

Risk vs benefit: one SSID-matched table line, no structural change,
benefit is working analog audio on that NUC.

### Verification
- [Phase 1] Parsed tags: author Eckhart Mohr; SOB Werner Sembach,
  Takashi Iwai; Link msgid; no Fixes/Cc:stable on the commit
- [Phase 1] Ignored `[Upstream commit 9a44b828…]` and Sasha Levin SOB as
  pipeline markers
- [Phase 2] Diff: +1 line in `alc269_fixup_tbl[]` —
  `SND_PCI_QUIRK(0x1849, 0x6256, …, ALC233_FIXUP_NO_AUDIO_JACK)`
- [Phase 2] Confirmed fixup body at `alc233_fixup_no_audio_jack()`
  writes `alc233_fixup_no_audio_jack_coefs`
- [Phase 3] `git show 174a7fb3859ae`: 2021 1100 quirk, `Cc: stable`,
  same fixup; `git merge-base --is-ancestor` vs parent of candidate =
  present
- [Phase 3] `git log --author='Eckhart Mohr'` / Werner: regular Realtek
  quirk contributors
- [Phase 3] No follow-up `358H`/`0x6256` commits in this tree
- [Phase 4] `b4 dig -c 8fa1cfe41877d`: lore msgid
  `20261001183403.103990-1-wse@tuxedocomputers.com`
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] `b4 dig -w`: Takashi Iwai, Jaroslav Kysela, linux-sound
- [Phase 4] LKML: Takashi applied; Werner requested Cc:stable; Takashi
  said to send to stable after Linus merge
- [Phase 4] lore.kernel.org WebFetch: 403 (UNVERIFIED via direct lore
  HTML)
- [Phase 5] `snd_hda_pick_fixup()` matches PCI SSID; probe calls it with
  `alc269_fixup_tbl`
- [Phase 5] `git grep 0x6256` in HDA: only this new quirk
- [Phase 6] `git describe HEAD` / `make kernelversion`: 6.18.57
- [Phase 6] `git grep` on `v6.18.57`: 1100 quirk present, 358H SSID
  absent; insertion context matches
- [Phase 8] Vendor spec: NUC BOX-358H has a front combo jack and ALC256
- UNVERIFIED: independent COEF dump on 358H hardware; lore.kernel.org
  HTML body

This is a small, SSID-scoped hardware quirk that restores jack detection
on a real machine, with the required fixup already in 6.18.57.

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 2a466ef894697..0bfa64bee9d3b 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7640,6 +7640,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x9e56, "Lenovo ZhaoYang CF4620Z", ALC286_FIXUP_SONY_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1849, 0x0269, "Positivo Master C6400", ALC269VB_FIXUP_ASUS_ZENBOOK),
 	SND_PCI_QUIRK(0x1849, 0x1233, "ASRock NUC Box 1100", ALC233_FIXUP_NO_AUDIO_JACK),
+	SND_PCI_QUIRK(0x1849, 0x6256, "ASRock NUC Box 358H", ALC233_FIXUP_NO_AUDIO_JACK),
 	SND_PCI_QUIRK(0x1849, 0xa233, "Positivo Master C6300", ALC269_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1854, 0x0440, "LG CQ6", ALC256_FIXUP_HEADPHONE_AMP_VOL),
 	SND_PCI_QUIRK(0x1854, 0x0441, "LG CQ6 AIO", ALC256_FIXUP_HEADPHONE_AMP_VOL),
-- 
2.53.0

