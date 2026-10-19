Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D708B5432C2;
	Mon, 19 Oct 2026 14:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418777; cv=none; b=TI6VDjZiPk8Q2rsQUgmI0Uzlzk/0C0vi+zTPX9Gs1ACYFeGKobXALKixD+b0zb83OFb+qaGJYIChmDOQxfyYA6dtYzDkcf2/A3JEZSKkEIi1PsWAWDZ17fmOlmYF8vZzwMrwBl//MDKAeV5xrtgKsGq6E4DLmkPSfY+o82PmjL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418777; c=relaxed/simple;
	bh=F011rrGwk/fAdzGLEfzIP+ZK7niA8zOqR3GB4Oq0AcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q9CTz1l8Pf0Sicxwvq/HYX7vIo2eJf3lUWddA0Xyu7wNeVeLXIsdFeKtFZGiQ5TBcqE2HcGwGreTTAiSZVY/x2Bl58geeDvlQIIEoktz2NODV7ILW3zWFK6ZX1q4k+JZ+ymZI/p19W+ZrntrdRZEL73AazD+Ez5WM32rqRIZGkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qch91keC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qch91keC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF2F1F000C6;
	Mon, 19 Oct 2026 14:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418773;
	bh=pV/PGsoDREG2Yx0sJy7RIYSvqH1/BNXYFkBey3XN0EU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qch91keCrYrSrfcsd2peD2Hm4U0BjVVsk0Xupi5/ZUL8hmCnWzVr9wMfVFI0ORMDy
	 1LzK7gHLhZ90+VUwhqoQWYR+ZTFTvQc66mHar4UmmLxRKhVayaIGTIQrTSHOVmKJlh
	 TVcNhSlwGLPPLQ+i1V7+F4n6aIFuEe4Nwwuxqpq73N6HdQvsQ/0MUi9UV3Wr27mvan
	 D6DxWuhHkSPzV+EczPTNkQ2CRcaXG3O5i1SjJbzKC2FQ3jZZYeVIHX+kLU7KMoqaqF
	 Fz7s4xqtVEf+o+5w8gh6pVfJex2Vs+xuASFBFR/ieQwLaoX6cY8Z91RTAH/RLYeezf
	 r+8f+vdh7ACEg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Luis Banha <luisbanha26@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ALSA: hda/realtek: Add mute LED quirk for HP Pavilion 15-ec1xxx
Date: Mon, 19 Oct 2026 09:52:57 -0400
Message-ID: <20261019135441.1420968-486-sashal@kernel.org>
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

From: Luis Banha <luisbanha26@gmail.com>

[ Upstream commit 775aa96c310d59f3d15a6e5a9bd1796fd1ba95ec ]

The mute LED on the HP Pavilion Gaming Laptop 15-ec1xxx (103c:87b2)
does not work automatically. Add the ALC285_FIXUP_HP_MUTE_LED quirk
to fix this behavior.

Signed-off-by: Luis Banha <luisbanha26@gmail.com>
Link: https://patch.msgid.link/20260921230105.16844-1-luisbanha26@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a one-line HP Realtek mute-LED quirk for PCI SSID `103c:87b2`.
The local tree is **6.18.57** (`v6.18.57-155-gcdf239ca885b2`). The
Realtek HDA driver, `alc269_fixup_tbl[]`, and `ALC285_FIXUP_HP_MUTE_LED`
are already present here; without this entry the Pavilion 15-ec1xxx mute
LED stays dead.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [ALSA/hda/realtek] [Add] [mute LED quirk for HP Pavilion
15-ec1xxx]
Subsystem prefix `ALSA: hda/realtek`. Action verb is **Add**, but the
object is a hardware quirk for a specific laptop, not a new feature/API.

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Luis Banha \<luisbanha26@gmail.com\> (author)
- Link:
  https://patch.msgid.link/20260921230105.16844-1-luisbanha26@gmail.com
- Signed-off-by: Takashi Iwai \<tiwai@suse.de\> (ALSA maintainer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable (absence is expected for this review)
- Pipeline-added markers ignored: `[ Upstream commit
  775aa96c310d59f3d15a6e5a9bd1796fd1ba95ec ]`, Signed-off-by: Sasha
  Levin

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: mute LED on HP Pavilion Gaming Laptop 15-ec1xxx (SSID 103c:87b2)
  does not work automatically
- Symptom: mute-key LED does not track mute state
- Version info: none stated
- Root cause implied: this SSID is missing from `alc269_fixup_tbl[]`, so
  the existing `ALC285_FIXUP_HP_MUTE_LED` path is never applied

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a disguised cleanup. It is an explicit hardware-quirk
addition. That is a documented stable exception, not a hidden leak/race.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `sound/hda/codecs/realtek/alc269.c` (+1 / -0)
- Function/table: `alc269_fixup_tbl[]`
- Scope: single-file surgical one-liner

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: SSID 0x103c:0x87b2 has no matching `SND_PCI_QUIRK`.
  `snd_hda_pick_fixup()` in `alc269_probe()` leaves the codec without
  this LED fixup.
- After: that SSID maps to `ALC285_FIXUP_HP_MUTE_LED`.
- Path affected: codec probe/init for this laptop only.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- Category: **hardware workaround / codec quirk**
- Mechanism: HP wired mute/mic-mute LEDs to Realtek COEF bits.
  `alc285_fixup_hp_mute_led()` already programs:
  - mute LED: COEF 0x0b bit 3 via `alc285_fixup_hp_mute_led_coefbit()`
  - mic-mute LED: COEF 0x19 bit 13 via
    `alc285_fixup_hp_coef_micmute_led()`
- The bug is a missing table entry, not missing driver logic. Same
  pattern as nearby HP OMEN 15 (`0x8786/0x8787/0x8788`) and Pavilion
  15z-ec200 (`0x88dd`).

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: one `SND_PCI_QUIRK` in PCI-ID order between
  `0x8788` and `0x87b7`.
- Minimal: no API, locking, or control-path changes.
- Regression risk: confined to 103c:87b2. Wrong LED polarity would at
  worst invert LEDs on that model; it cannot affect other machines.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- The new line is the candidate itself (`e0d12f383475a`, Luis Banha,
  2026-09-22).
- Surrounding HP ALC285 mute-LED entries come from the Realtek split
  `aeeb85f26c3bb` (2025-07-09) and older `patch_realtek.c` history.
- `ALC285_FIXUP_HP_MUTE_LED` has been used since at least
  `375f8426ed994` (“Add a quirk for HP OMEN 15 mute LED”, 2021-10-28,
  Cc: stable). That commit is an ancestor of this tree.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Not applicable. The “bug” is a missing per-
machine ID, not a regression from a specific earlier commit.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- Related: `d75dba4974447` “Add a quirk for HP Pavilion 15z-ec200” (same
  15-ec family, same `ALC285_FIXUP_HP_MUTE_LED`, Cc: stable). Present in
  this tree (`git merge-base --is-ancestor` exit 0).
- Many later HP mute-LED ID additions in the same table (15-eg0xxx,
  14-dv1001TU, Victus, etc.).
- Standalone: not “patch X/Y”. No prerequisites beyond the existing
  fixup enum/function, both already here.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Luis Banha has only this Realtek commit in this tree. Maintainer
Takashi Iwai applied it (SOB). Not the subsystem maintainer, but
maintainer-applied.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: None. Diff assumes `SND_PCI_QUIRK`, `ALC285_FIXUP_HP_MUTE_LED`,
and `alc269_fixup_tbl[]`, all present. Can apply standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c 775aa96c310d59f3d15a6e5a9bd1796fd1ba95ec` matched patch-id
  `0b68c9761ca63e73bd01063dba912b15105a26c8`
- Lore/msgid:
  https://patch.msgid.link/20260921230105.16844-1-luisbanha26@gmail.com
- `b4 dig -a`: single revision **v1** only; committed version is that v1
- Maintainer reply (Takashi Iwai, 2026-09-28): “Applied now. Thanks.” No
  NAK, no requested changes, no extra stable discussion
- msgid.link and lore.kernel.org returned 403; discussion recovered from
  LKML archive (https://lkml.iu.edu/2609.2/15241.html and
  https://lkml.iu.edu/2609.3/09057.html)

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): To/Cc were Luis Banha, tiwai@suse.com,
perex@perex.cz, linux-sound@vger.kernel.org, linux-
kernel@vger.kernel.org. Correct ALSA maintainers and list. Takashi
applied it.

Step 4.3: SEARCH FOR THE BUG REPORT
Record:
- No kernel.org bugzilla link in the commit
- Arch Linux forum thread “HP Pavilion Gaming Laptop 15-ec1xxx mute
  button led issue” (2024-06): OP plus a second user with the same
  model; `aplay -l` shows **ALC285 Analog**; existing `model=` strings
  including `hp-mute-led-mic1/2/3` did not help (those map to older
  `ALC269_FIXUP_HP_MUTE_LED_MICx`, not `ALC285_FIXUP_HP_MUTE_LED`)
- linux-hardware.org probe for Pavilion Gaming 15-ec1xxx confirms PCI
  subsystem **103c:87b2**
- Same-family 15z-ec200 already uses this exact fixup in-tree

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone v1. Not part of a multi-patch series. Sibling
15z-ec200 quirk already here.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable search for this subject/SSID returned no
relevant discussion (403 on direct lore fetch; web search of stable
archives found no prior NAK or exclusion). No evidence this was rejected
for stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: Table `alc269_fixup_tbl[]` only. Consumed by `alc269_probe()` →
`snd_hda_pick_fixup()`. Applied function: `alc285_fixup_hp_mute_led()`.

Step 5.2: TRACE CALLERS
Record:
- `alc269_probe()` (codec probe) calls `snd_hda_pick_fixup(...,
  alc269_fixup_tbl, alc269_fixups)`
- Match is PCI subsystem vendor/device
- Context: device enumeration / module load, not IRQ/hot path
- Impact surface: only machines with SSID 103c:87b2

Step 5.3: TRACE CALLEES
Record: `alc285_fixup_hp_mute_led()` → COEF setup +
`snd_hda_gen_add_mute_led_cdev()` /
`snd_hda_gen_add_micmute_led_cdev()`. Registers LED class devices so
userspace mute state drives the hardware LED.

Step 5.4: FOLLOW THE CALL CHAIN
Record: PCI HDA probe → Realtek ALC269-family probe → quirk pick →
PRE_PROBE fixup. Reachable on every boot of this laptop. Not a syscall
fuzzer path; it is normal hardware init.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Multiple HP machines already use `ALC285_FIXUP_HP_MUTE_LED` in
this file (`0x8603`, `0x877a`, `0x8786/87/88`, `0x8896`, `0x88dd`,
`0x8902`). This is the established pattern for ALC285 HP mute LEDs.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. Tree is 6.18.57. File `sound/hda/codecs/realtek/alc269.c`
exists. Parent of the candidate (`ce2e10f2403a4`) has no `0x87b2` entry
(`git show parent | rg 0x87b2` empty). `ALC285_FIXUP_HP_MUTE_LED` and
`alc285_fixup_hp_mute_led()` exist. Upstream SHA `775aa96c310d` is
**not** an ancestor of HEAD (expected: this is 6.18.y, patch is from
2026-09). The machine’s missing-ID bug exists here.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Clean apply. Context around `0x8788` / `0x87b7` matches the
submitted diff. No structural conflict with this 6.18 tree. Reverse of
the one-line patch applies cleanly on current HEAD.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No other `0x87b2` quirk anywhere in the tree. 15z-ec200
(`0x88dd`) is a related SKU, not a substitute for 15-ec1xxx.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: ALSA HD-audio Realtek codec (`sound/hda/codecs/realtek/`).
Criticality: **IMPORTANT** (very common laptop audio), but this change
is machine-specific.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Actively maintained; recent `alc269.c` history is mostly
additional `SND_PCI_QUIRK` mute-LED IDs. Mature driver, long-lived quirk
table. Takashi Iwai is the maintainer and applied this patch.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver-specific / hardware-specific. Only HP Pavilion Gaming
15-ec1xxx (PCI SSID 103c:87b2), typically ALC285. Requires
`SND_HDA_CODEC_REALTEK`.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Every boot/probe on that laptop. Unprivileged users cannot
exploit it; they just see a dead mute LED. Independent user reports
exist (Arch forum, 2024).

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: Mute (and mic-mute) LED does not follow mixer mute. No oops,
deadlock, or data corruption. Severity **MEDIUM** as a functional
hardware bug; still a real user-visible defect. Covered by the stable
**hardware quirk** exception.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: high for owners of this 2020-era HP gaming laptop; enables
  the LED that never worked on stock 6.18.
- Risk: very low (1 line, existing fixup, SSID-gated).
- Ratio: strongly favorable.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Hardware codec quirk (`SND_PCI_QUIRK`) on an existing driver —
  explicit stable exception
- Real user-visible bug on a specific, identified laptop
- Existing `ALC285_FIXUP_HP_MUTE_LED` already used by same-family
  15z-ec200 in this tree
- 1 insertion, no new APIs, no locking, no refactor
- Applied by ALSA maintainer Takashi Iwai
- Independent reports that 15-ec1xxx mute LED is broken on Linux/ALC285
- Applies cleanly to this 6.18.57 tree

AGAINST:
- Not a crash/security/corruption fix
- Author did not include Tested-by details or hda-verb dumps in the
  commit (unlike some sibling LED quirks)
- Arch users did not confirm this exact fixup (they never had a model
  string for it)

UNRESOLVED:
- Direct lore.kernel.org fetch was 403; discussion recovered via b4 +
  LKML
- Could not independently re-test LED polarity on hardware

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — one SSID mapped to a long-
   used HP ALC285 LED fixup; maintainer applied v1; same family already
   uses it
2. Fixes a real bug that affects users? **PASS** — mute LED does not
   work on 15-ec1xxx
3. Important issue? **PASS** under the hardware-quirk exception (codec
   LED workaround). Not a panic, but stable routinely takes these
4. Small and contained? **PASS** — +1 line, one table
5. No new features or APIs? **PASS** — ID added to existing quirk table
6. Can apply to the local tree? **PASS** — file, enum, and neighboring
   context all present on 6.18.57

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: **Hardware quirk / audio codec quirk** (`SND_PCI_QUIRK` in
Realtek HDA). Also analogous to “new device ID on an existing driver”:
the driver and fixup already exist; only the SSID is new.

Step 9.4: MAKE YOUR DECISION
This should be backported to this 6.18.57 tree. It is the standard
Realtek mute-LED ID addition: tiny, SSID-scoped, uses an existing fixup,
and restores hardware behavior for a real laptop that this tree already
supports.

===============================================================
What the commit solves, and why it matters here
===============================================================

On this 6.18 tree the Realtek ALC269-family driver already knows how to
drive HP ALC285 mute LEDs via COEF bits. The Pavilion Gaming 15-ec1xxx
simply was never listed, so probe never enables that path and the F-key
LED stays off. Adding `SND_PCI_QUIRK(0x103c, 0x87b2, ...,
ALC285_FIXUP_HP_MUTE_LED)` is the same class of stable backport as
USB/PCI/codec quirks: it does not add a driver or API, it only matches
known hardware to existing workaround code.

Risk is limited to that SSID. Benefit is restoring a user-visible LED on
a shipping laptop. The patch applies cleanly here.

Verification:
- [Phase 1] Parsed tags: author SOB Luis Banha; maintainer SOB Takashi
  Iwai; msgid.link present; no Fixes/Reported-by/Cc: stable
- [Phase 1] Ignored pipeline `[ Upstream commit 775aa96c310d... ]` and
  Sasha Levin SOB
- [Phase 2] Diff: +1 `SND_PCI_QUIRK` in `alc269_fixup_tbl[]` in
  `sound/hda/codecs/realtek/alc269.c`
- [Phase 2] Read `alc285_fixup_hp_mute_led()` at alc269.c:1679 — COEF
  mute + micmute LED setup
- [Phase 3] `git describe HEAD` / `make kernelversion`:
  v6.18.57-155-gcdf239ca885b2 / 6.18.57
- [Phase 3] `git merge-base --is-ancestor 775aa96c310d HEAD`: exit 1
  (upstream SHA not in this stable history, as expected)
- [Phase 3] Parent `ce2e10f2403a4` has no 0x87b2; has 15z-ec200 0x88dd
  with the same fixup
- [Phase 3] `git merge-base --is-ancestor d75dba4974447 HEAD` and
  `375f8426ed994 HEAD`: both 0 (related quirks exist here)
- [Phase 3] `git blame -L 6818,6822 HEAD`: 0x87b2 attributed to
  candidate; neighbors from aeeb85f26c3bb
- [Phase 4] `b4 dig -c 775aa96c310d`: matched lore msgid
  20260921230105.16844-1-luisbanha26@gmail.com
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] `b4 dig -w`: tiwai, perex, linux-sound Cc’d
- [Phase 4] LKML: Takashi “Applied now. Thanks.” No NAK
- [Phase 4] Arch bbs.archlinux.org/viewtopic.php?id=296366: two users,
  ALC285, dead mute LED
- [Phase 4] linux-hardware.org: 15-ec1xxx SSID 103c:87b2
- [Phase 4] lore.kernel.org direct fetch: 403; stable-list search: no
  prior rejection found
- [Phase 5] Call chain: `alc269_probe()` → `snd_hda_pick_fixup(...,
  alc269_fixup_tbl, ...)`
- [Phase 5] `git grep 0x87b2`: only this new quirk line
- [Phase 6] File/fixup/table all present; insertion context matches;
  reverse-apply of the one-liner is clean
- [Phase 7] Subsystem: ALSA HDA Realtek, maintainer-applied
- [Phase 8] Failure mode: dead mute LED, SSID-scoped, very low
  regression risk
- UNVERIFIED: hardware LED polarity not retested in this environment;
  original lore HTML not fetched (403)

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 6afb35769f746..1fcf2ba795e8a 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6822,6 +6822,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8786, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8787, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8788, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x87b2, "HP Pavilion Gaming Laptop 15-ec1xxx", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x87b7, "HP Laptop 14-fq0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87c8, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87cb, "HP Pavilion 15-eg0xxx", ALC287_FIXUP_HP_GPIO_LED),
-- 
2.53.0

