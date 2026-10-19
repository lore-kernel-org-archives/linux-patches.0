Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8DB56E045;
	Mon, 19 Oct 2026 13:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418128; cv=none; b=anRj7wuQ1j2OxawZVr2iPjp+FNsEwO23cskmkxL4xE2TDLzwSvJvOFflcKvxkyhSVGWWoUyDk8MkT3wcKEvZLukcyCPl1Pkv4NZEmIejYMavuul4fXhK4UGD8gyvrECDyyg6KxvwoZfXzzVsXbQnNL5eYbT4NP2zWjMtVJy548Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418128; c=relaxed/simple;
	bh=5PbSTlNx6dI5Ow8wQzNDxyEZ9+IAiyfk7cPCqXnxNYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dY+4yhkA1ttofkeh5Q2vxfGRxa0l+ZgVGQDLddSEM5RLikdJ4wdrn3hQ2ZSyzlqoBYNO+isw+eYGZOsaI03JCbPkRKjLnwC5DklrtTlztrxsFwDiwTbHDt2HeFWA8E/uef0aZQBSXoT4C5RycduxW0z6ckNmgNG5KeYMs7labPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eV9YawV8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eV9YawV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552E61F000C7;
	Mon, 19 Oct 2026 13:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418126;
	bh=kBWpndAyTXbxFhapypn51h9xHXBNXXjBylJW4ghExU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eV9YawV8WKJCCmij2uBsQ5V3/1qKwEpg2KZUmBCAme1kQbwhSx/XF9MvpgiY+baWb
	 ArCQslTfOzW8HlqZ11ZDk2Q+Y+KQwcsCbG0O8lFINr/w/RPOXH80/fcOCFOLTIa7kA
	 qSlEHCJSrOKtp84xRBbJGyjqfBx1XLB86yG8VxOsldV5YjAefBjMD6yuqwvdK8wY/Z
	 WnJHeK/xwDxHUbqv/+DJdnQWzvX5T3pww0onH4TGiMHL/cDCUcWrnKkEkdCWr/kvUN
	 3UE6MfTtQxDCkokDuXbdUZm/xgIs8SlYyjxQk0NjCco634QE+2vnfM2rXKVww6QK5I
	 FtwjnPOt1uZMg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Luca Castaldini <luca.castaldini96@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ALSA: hda/realtek: Add mute LED support for HP Pavilion 15-eh2xxx
Date: Mon, 19 Oct 2026 09:45:21 -0400
Message-ID: <20261019135441.1420968-30-sashal@kernel.org>
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

From: Luca Castaldini <luca.castaldini96@gmail.com>

[ Upstream commit daf55a381dca9bda12cc8c3a47605698f2d560e9 ]

Add the subsystem ID 103c:8a0e to the ALC287 HP GPIO LED quirk
table so the mute LED follows the speaker mute state.

Tested on HP Pavilion Laptop 15-eh2xxx with ALC287 codec.
The mute LED now follows the speaker mute state.

Signed-off-by: Luca Castaldini <luca.castaldini96@gmail.com>
Link: https://patch.msgid.link/20260805122907.52302-1-luca.castaldini96@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: this is a one-line HP mute-LED quirk, the
`ALC287_FIXUP_HP_GPIO_LED` helper already exists in 5.10, and this tree
already takes the same class of Realtek ID additions.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE

Record: [ALSA: hda/realtek] [Add] [mute LED support for HP Pavilion
15-eh2xxx by adding PCI subsystem ID 103c:8a0e to an existing GPIO LED
quirk table]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS

Record:
- Fixes: none (expected for this review pipeline)
- Reported-by: none
- Tested-by: none as a tag; the body states the author tested it on the
  target laptop
- Reviewed-by: none
- Acked-by: none
- Link: https://patch.msgid.link/20260805122907.52302-1-
  luca.castaldini96@gmail.com
- Cc: stable@vger.kernel.org: absent (expected; not a negative signal)
- Signed-off-by: Luca Castaldini <luca.castaldini96@gmail.com> (author)
- Signed-off-by: Takashi Iwai <tiwai@suse.de> (ALSA maintainer; applied
  the patch)
- Ignore any Sasha Levin SOB if present in candidate packaging

Step 1.3: ANALYZE THE COMMIT BODY TEXT

Record:
- Bug description: HP Pavilion Laptop 15-eh2xxx (ALC287) mute LED does
  not follow speaker mute because subsystem ID 103c:8a0e is missing from
  the ALC287 HP GPIO LED quirk table.
- Symptom/failure mode: mute LED stays out of sync with speaker mute
  (LED does not work as users expect). Audio playback itself is not
  described as broken.
- Version information: none in the message. Hardware is a 2021–2022
  Pavilion (linux-hardware.org year 2021; retail listings 2022).
- Root cause: missing SND_PCI_QUIRK entry; the existing
  ALC287_FIXUP_HP_GPIO_LED fixup already implements GPIO mute LED
  control.

Step 1.4: DETECT HIDDEN BUG FIXES

Record: Not a hidden bug fix. It is an explicit hardware quirk / device-
ID addition. The subject says "Add" rather than "fix", but this is the
documented stable exception for audio codec quirks (SND_PCI_QUIRK for a
specific laptop).

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES

Record:
- Files: sound/hda/codecs/realtek/alc269.c (+1 / -0)
- Function/table: alc269_fixup_tbl[] (static const struct hda_quirk /
  snd_pci_quirk)
- Scope: single-file, one-line surgical quirk addition
- Added line: SND_PCI_QUIRK(0x103c, 0x8a0e, "HP Pavilion Laptop
  15-eh2xxx", ALC287_FIXUP_HP_GPIO_LED)

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE

Record:
- Before: codec probe for PCI SSID 103c:8a0e does not match a quirk, so
  GPIO mute LED is not hooked to speaker mute.
- After: snd_hda_pick_fixup() matches 0x103c/0x8a0e and applies
  ALC287_FIXUP_HP_GPIO_LED, which calls alc287_fixup_hp_gpio_led() →
  alc_fixup_hp_gpio_led(..., mute_mask=0x10, micmute_mask=0), wiring
  GPIO bit 4 (0x10) as the mute LED.
- Path affected: HDA codec probe / LED classdev registration for this
  one SSID only.

Step 2.3: IDENTIFY THE BUG MECHANISM

Record:
- Bug category: hardware workaround / audio codec quirk (SND_PCI_QUIRK)
- Mechanism: laptop mute LED is GPIO-driven; without the quirk the LED
  is not bound to mute state. The fix only adds the SSID to the existing
  table. No new fixup function.

Step 2.4: ASSESS THE FIX QUALITY

Record:
- Obviously correct: one ID, existing enum, existing function. Same
  pattern as many quirks already in this tree (e.g. 0x87cb/0x87cc
  Pavilion 15-eg0xxx).
- Minimal: one line, no unrelated changes, no API change.
- Regression risk: very low. Only machines with SSID 103c:8a0e are
  affected. Wrong GPIO would misdrive that laptop's LED, but the author
  tested ALC287 on this model and nearby Pavilion 14-ec1xxx (0x8a0f)
  uses the same fixup in mainline.
- Red flags: none (no new APIs, no locking, no refcount, no series
  dependency).

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES

Record:
- This tree does not have alc269.c; equivalent table is
  sound/pci/hda/patch_realtek.c.
- ALC287_FIXUP_HP_GPIO_LED and alc287_fixup_hp_gpio_led() were
  introduced by a0ccbc5319d57 ("ALSA: hda/realtek - Add supported mute
  Led for HP", Kailang Yang, 2020-11-06). That commit is an ancestor of
  HEAD.
- First table users of that fixup in this tree: 0x87f4/0x87f5 (same
  commit), later 0x87c8 (3e1bcaebe8b10, 2020-12), 0x87cc (d7e11de23f197,
  2025-07), 0x87cb (471db5addec8c, 2026-03).
- 0x8a0e is not present in this checkout.

Step 3.2: FOLLOW THE FIXES: TAG

Record: No Fixes: tag. The "bug" is a missing quirk for hardware that
shipped after 5.10's original release, not a regression from a specific
earlier commit.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES

Record:
- Recent patch_realtek.c history on this branch includes many mute-LED
  ID additions (4a660d1dc6a0f 14s-dr1xxx, 471db5addec8c 15-eg0xxx,
  d391901abfc67 15s-eq1xxx, etc.).
- Neighbor ID 0x8a0f ("HP Pavilion 14-ec1xxx") is in the candidate hunk
  context but is not in this 5.10 table.
- Related mainline commit 068641bc9dc3d adds 15-eh1xxx with a different
  codec/fixup (ALC245 / ALC245_FIXUP_HP_MUTE_LED_V1_COEFBIT). Not a
  prerequisite; different board (88D1 vs 8A0E). Not in this tree.
- Standalone: not patch X/Y.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS

Record: git log --author='Luca Castaldini' on this tree's sound/pci/hda/
returned no commits. First-time contributor for this ID. Maintainer
Takashi Iwai applied it the same day.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS

Record:
- Required symbols exist here: ALC287_FIXUP_HP_GPIO_LED enum,
  alc287_fixup_hp_gpio_led(), alc_fixup_hp_gpio_led(), alc269_fixup_tbl,
  snd_hda_pick_fixup() in alc269 probe.
- No new functions or structs.
- Path differs (mainline split Realtek into
  sound/hda/codecs/realtek/alc269.c; 5.10 still uses
  sound/pci/hda/patch_realtek.c). Standalone conceptually; apply needs a
  path/context tweak, not extra commits.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION

Record:
- Commit on all-next: daf55a381dca9bda12cc8c3a47605698f2d560e9 (not an
  ancestor of this HEAD).
- b4 dig -c daf55a381dca9: lore.kernel.org patch-id search errored;
  author/subject match succeeded.
- Lore/msgid: https://patch.msgid.link/20260805122907.52302-1-
  luca.castaldini96@gmail.com
- Mirrors: https://lkml.iu.edu/hypermail/linux/kernel/2608.0/08604.html
  (patch), .../09065.html (Iwai reply)
- b4 dig -a: single v1 series, 2026-08-05. No v2/v3.
- Reviewer: Takashi Iwai applied to for-next the same day: "Applied to
  for-next branch now. Thanks." No NAK, no stable discussion, no risk
  flags.

Step 4.2: CHECK WHO REVIEWED THE PATCH

Record: b4 dig -w recipients: Luca Castaldini, tiwai@suse.com,
perex@perex.cz, linux-sound@vger.kernel.org, linux-
kernel@vger.kernel.org. Correct ALSA maintainers and lists. Applied by
Takashi Iwai.

Step 4.3: SEARCH FOR THE BUG REPORT

Record:
- No bugzilla or syzbot link.
- Author tested on HP Pavilion Laptop 15-eh2xxx with ALC287.
- linux-hardware.org probe 0510a78cfe confirms Pavilion Laptop
  15-eh2xxx, motherboard 8A0E, PCI SSID 103c:8a0e, Ryzen HD Audio
  (snd_hda_intel), year ~2021, Ubuntu 22.04 / kernel 6.5 in that probe.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES

Record: Standalone v1. Related but independent: 15-eh1xxx quirk
(068641bc9dc3d) uses ALC245, not this fixup. 14-ec1xxx (0x8a0f) is the
table neighbor in mainline; not required here.

Step 4.5: CHECK STABLE MAILING LIST HISTORY

Record: lore.kernel.org/stable fetch returned 403. Web search did not
find a stable-list thread for 15-eh2xxx / 8a0e. UNVERIFIED that nobody
requested or rejected it on stable@; no evidence of a NAK.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF

Record: No function body edited. Table alc269_fixup_tbl[]. Runtime
target: ALC287_FIXUP_HP_GPIO_LED → alc287_fixup_hp_gpio_led() →
alc_fixup_hp_gpio_led().

Step 5.2: TRACE CALLERS

Record:
- alc269_fixup_tbl is passed to snd_hda_pick_fixup() from the
  ALC269-family probe in patch_realtek.c (around line 10471).
- alc287_fixup_hp_gpio_led is only referenced as that fixup's .v.func.
- Context: HDA codec probe (device enumeration), not IRQ/hot path.
  Userspace mute then drives the LED via the registered mute LED cdev.

Step 5.3: TRACE CALLEES

Record (this tree, alc_fixup_hp_gpio_led at 4431–4449):
- alc_fixup_gpio(codec, action, mute_mask | micmute_mask)
- On PRE_PROBE, if mute_mask: set spec->gpio_mute_led_mask and
  snd_hda_gen_add_mute_led_cdev(codec, gpio_mute_led_set)
- ALC287 variant uses mute_mask 0x10, micmute_mask 0

Step 5.4: FOLLOW THE CALL CHAIN

Record: PCI HDA probe → Realtek ALC269/ALC287 patch →
snd_hda_pick_fixup(SSID) → GPIO LED hook. Reachable on this laptop
whenever the HDA codec probes. Unprivileged users can toggle mute; they
cannot widen the quirk to other SSIDs.

Step 5.5: SEARCH FOR SIMILAR PATTERNS

Record: Same ALC287_FIXUP_HP_GPIO_LED already used here for 0x87c8,
0x87cb, 0x87cc, 0x87f4, 0x87f5. This tree has a long history of HP mute-
LED ID additions. Systematic, established pattern.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?

Record:
- Local tree: pending-5.10, git describe p-5.10-2-g5aaf1e4e5aa4d, make
  kernelversion 5.10.270.
- Missing ID 103c:8a0e: confirmed (no 0x8a0e, no 15-eh2xxx, no 0x8a* HP
  entries at all).
- Fixup and driver: present. Without the ID, 5.10 will not enable the
  mute LED on this laptop.
- Introduced: missing-ID class; hardware ~2021–2022. 5.10 still ships
  this driver and already backports later Pavilion LED quirks.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS

Record: Expected difficulty: minor conflicts / path remap, not rework.
- Mainline file sound/hda/codecs/realtek/alc269.c does not exist; use
  sound/pci/hda/patch_realtek.c.
- Hunk context (0x8a05/0x8a06/0x8a0f) is absent. Insert one
  SND_PCI_QUIRK among the 0x103c HP entries (table currently jumps
  0x89aa → 0x8e1d).
- No structural conflict with ALC287_FIXUP_HP_GPIO_LED.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE

Record: 0x8a0e not present. No 15-eh2xxx/15-eh1xxx quirk. Similar
Pavilion 15-eg0xxx IDs (0x87cb/0x87cc) already backported. This ID is
new.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY

Record: [sound/pci/hda Realtek codec / ALSA HDA] [IMPORTANT for laptop
audio; this change is laptop-specific, not core MM/net]

Step 7.2: ASSESS SUBSYSTEM ACTIVITY

Record: Mature, still active on this 5.10 branch. Recent mute-LED quirks
continue to land (2025–2026). MAINTAINERS: SOUND — Jaroslav Kysela,
Takashi Iwai.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED

Record: Driver-specific / platform-specific: only HP Pavilion 15-eh2xxx
(PCI SSID 103c:8a0e). 5.10 users of that laptop (Debian 11-class LTS,
appliances, custom 5.10 images) benefit. Everyone else unchanged.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS

Record: Trigger is codec probe on that SSID, then mute/unmute. Common
for owners of that model. Unprivileged users can toggle mute; not a
security trigger.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY

Record: Mute LED does not track speaker mute. Not panic/UAF/corruption.
Severity LOW–MEDIUM functionally, but this is the documented hardware-
quirk exception (broken LED on a real laptop).

Step 8.4: CALCULATE RISK-BENEFIT RATIO

Record:
- Benefit: mute LED works on this Pavilion series; matches many quirks
  already accepted on this branch.
- Risk: very low (one SSID, existing fixup, author-tested, maintainer-
  applied).
- Ratio: high benefit for those users vs negligible regression risk.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE

FOR backporting:
- Explicit stable exception: audio codec SND_PCI_QUIRK / hardware quirk
  for an existing driver.
- One-line addition; ALC287_FIXUP_HP_GPIO_LED already in 5.10 since
  a0ccbc5319d57 (v5.10 era, Cc: stable originally).
- Real hardware, author-tested; SSID 103c:8a0e confirmed on linux-
  hardware.org.
- Applied by ALSA maintainer; no NAK.
- This 5.10 tree already backports the same class of HP mute-LED IDs.

AGAINST:
- Not a crash, UAF, or data-corruption fix (LED-only).
- Mainline path differs; hunk context IDs missing (trivial remap).
- Laptop postdates original 5.10 (2021–2022); still relevant because
  this LTS keeps taking such quirks.
- First-time author; mitigated by maintainer apply + identical existing
  fixup.

UNRESOLVED:
- lore.kernel.org/stable search 403; no confirmed stable-list thread.
- Could not confirm from this checkout whether every 15-eh2xxx SKU uses
  GPIO 0x10; author test and 14-ec1xxx using the same fixup support that
  choice.

Step 9.2: APPLY THE STABLE RULES CHECKLIST

1. Obviously correct and tested? PASS — one ID, existing fixup, author
   tested, maintainer applied.
2. Fixes a real bug that affects users? PASS — mute LED does not follow
   mute on this laptop.
3. Important issue? PASS under the hardware-quirk exception (not a
   panic). Severity: broken LED on a specific model.
4. Small and contained? PASS — +1 line.
5. No new features or APIs? PASS — enables existing GPIO LED fixup for
   one SSID; no new userspace API.
6. Can apply to the local tree? PASS — equivalent table and fixup exist
   in patch_realtek.c; needs path/context adjustment only.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES

Record: Hardware quirk / audio codec SND_PCI_QUIRK for an existing
Realtek HDA driver. This is the category the rules call out as
appropriate for stable.

Step 9.4: MAKE YOUR DECISION

This should be backported to this 5.10.270 tree. It is a one-line PCI
quirk onto a fixup that already exists here, it fixes real mute-LED
behavior on HP Pavilion 15-eh2xxx, and it matches quirks this branch
already carries. Apply it in sound/pci/hda/patch_realtek.c's
alc269_fixup_tbl[] as:

SND_PCI_QUIRK(0x103c, 0x8a0e, "HP Pavilion Laptop 15-eh2xxx",
ALC287_FIXUP_HP_GPIO_LED),

placed among the other 0x103c HP entries (for example after 0x89aa,
before 0x8e1d).

Verification:
- [Phase 1] Parsed tags: Link msgid
  20260805122907.52302-1-luca.castaldini96@gmail.com; SOB Luca
  Castaldini + Takashi Iwai; no Fixes/Reported-by/Cc:stable
- [Phase 1] Body: missing 103c:8a0e; mute LED should follow speaker
  mute; tested on Pavilion 15-eh2xxx ALC287
- [Phase 2] Diff: +1 SND_PCI_QUIRK in alc269_fixup_tbl;
  ALC287_FIXUP_HP_GPIO_LED
- [Phase 3] git describe HEAD: p-5.10-2-g5aaf1e4e5aa4d; make
  kernelversion 5.10.270; branch pending-5.10
- [Phase 3] glob: no alc269.c; equivalent sound/pci/hda/patch_realtek.c
- [Phase 3] git merge-base --is-ancestor a0ccbc5319d57 HEAD: YES (fixup
  introduced 2020-11-06)
- [Phase 3] git merge-base --is-ancestor daf55a381dca9 HEAD: NO (this ID
  not in 5.10 yet)
- [Phase 3] grep 0x8a0e / 15-eh2xxx / 0x8a0f: no matches in this tree
- [Phase 3] blame alc287_fixup_hp_gpio_led: a0ccbc5319d57; table already
  has 0x87cb/0x87cc/0x87c8/0x87f4/0x87f5
- [Phase 3] git log --author='Luca Castaldini' -- sound/pci/hda/: empty
  on this tree
- [Phase 4] b4 dig -c daf55a381dca9: msgid match; v1 only; Iwai applied
  same day
- [Phase 4] b4 dig -w: tiwai, perex, linux-sound, linux-kernel
- [Phase 4] lkml.iu.edu 08604/09065: patch + "Applied to for-next"; no
  NAK
- [Phase 4] linux-hardware.org probe 0510a78cfe: 103c:8a0e Pavilion
  15-eh2xxx, board 8A0E
- [Phase 4] lore.kernel.org WebFetch 403; stable-list discussion
  UNVERIFIED
- [Phase 5] alc269_fixup_tbl used at patch_realtek.c:10471 via
  snd_hda_pick_fixup; alc_fixup_hp_gpio_led uses mute_mask 0x10
- [Phase 6] Insertion point: after 0x89aa / before 0x8e1d in
  alc269_fixup_tbl; path remap required
- [Phase 6] Related 15-eh1xxx 068641bc9dc3d not in this tree and uses a
  different fixup; not a dependency
- [Phase 7] SOUND maintainers Takashi Iwai / Jaroslav Kysela; this
  branch already lands mute-LED quirks
- [Phase 8] Failure mode: mute LED desync, not crash; quirk exception
  applies
- UNVERIFIED: GPIO 0x10 for every 15-eh2xxx SKU beyond the author's
  test; no stable@ thread due to 403

The patch is a one-line hardware quirk for an existing Realtek HDA
fixup, it matches stable policy, and it applies to this 5.10 tree with
only a path/context adjustment.

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 4cadbad99537a..68d5e5aa7f62d 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6881,6 +6881,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x89e7, "HP Elite x2 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a05, "HP Dragonfly Folio G3 2-in-1", ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a06, "HP Dragonfly Folio G3 2-in-1", ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8a0e, "HP Pavilion Laptop 15-eh2xxx", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a0f, "HP Pavilion 14-ec1xxx", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a1b, "HP 255 15.6 inch G9 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8a1f, "HP Laptop 14s-dr5xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
-- 
2.53.0

