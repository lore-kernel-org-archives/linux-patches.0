Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F0F508800;
	Mon, 19 Oct 2026 14:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418629; cv=none; b=ekvQzMaZaBlt78p4HETNlWSrNAXF/YvxP+0EFXwpwKXtvp0J8xm/uzbz5YmqApFkFY4nkPOWI8OqJGkQuX0CFni8dF7tXTaKoFfRviyLpXdOzkuNl0AZSHJiOjeVNVmkX09q4QANLuMlrfgWezQNz1KTDuA/I3sTIvaU5DPUlh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418629; c=relaxed/simple;
	bh=bm9Gdpbxk1rse/hfQ6B+QQZK0vyyeVJszoacihvHotc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=haOWWj8i+0GP8mTjbsE14QezPuT0cLJNCax0I+TZHVPjQgYAzfTd45ONoqlj2iAV7e9Hk6Tis/xsiidPouWUyq+6hA115L65CmecD+pYat+3UhfrG/+ukf8AUMQGH5hfMOxGY+B334uqFiJBgNkNeYChvFwj/rgTxNzt+KC9FTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tyq6u8Xi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tyq6u8Xi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E515C1F000C4;
	Mon, 19 Oct 2026 14:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418626;
	bh=v6VJZysxWNqOdYvAuxEGLvWeQ2oCHmmcg+RKHXpH5v4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tyq6u8XiuXcV5JDNIbavLHwdO9l5eMmwTeSVLn54pTn/wYpk1zr/z7gVkaPIpU1S9
	 /F5AiISjs8adMVFPtVgTXylELbfwWEX5dIe9aY6dkrC4UQ5RLjyPtI8m4MYceVzFRj
	 M8HJp2Uke0BkaSE4xopm1Q+AGiJ4rmjzo3OJw4mcHt4F1Q6trsokyKcE9I6Quk7n53
	 evGfq9XOTRKE0sH8eebUwbqR1FRkGOx2FOuvDjXcDFFQYHyt2JcUbWFI5QHwruZq2i
	 bJAsEZQ/ZxNKeJiXQhdbAzQL+WDI30p22bxDA8JJURdDvpYDWIxcPAX6rfsYKZuzwO
	 hFmTbseXvkzpg==
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
Subject: [PATCH AUTOSEL 6.18] ALSA: hda/realtek: Add quirk for Acer Nitro ANV16-42 headset mic
Date: Mon, 19 Oct 2026 09:51:14 -0400
Message-ID: <20261019135441.1420968-383-sashal@kernel.org>
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

[ Upstream commit e00a6a89900dfa4cda3669558d2f3581cd41a656 ]

The Acer Nitro ANV16-42 (subsystem 0x1025:0x1909, Realtek ALC245)
does not detect the headset microphone jack. Adding the
ALC2XX_FIXUP_HEADSET_MIC quirk resolves the issue and restores
proper headset mic functionality.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221623
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260807125857.678297-1-zhangheng@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The locally checked-out tree at decision time is **pending-6.12**
(`p-6.12-3-g710455e2077bb`, kernel **6.12.111**). The candidate is
mainline `e00a6a89900dfa4cda3669558d2f3581cd41a656` and is not an
ancestor of `HEAD`.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
- Subsystem prefix: `ALSA: hda/realtek`
- Action verb: **Add** (quirk)
- Claimed intent: enable headset-mic detection on Acer Nitro ANV16-42
Record: [ALSA/hda/realtek] [add] [PCI quirk so ANV16-42 headset mic is
detected]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
- Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221623
- Signed-off-by: Zhang Heng \<zhangheng@kylinos.cn\> (author)
- Signed-off-by: Takashi Iwai \<tiwai@suse.de\> (ALSA/HDA maintainer,
  applied)
- Link:
  https://patch.msgid.link/20260807125857.678297-1-zhangheng@kylinos.cn
- No Fixes:, no Cc: stable, no Reported-by, no Tested-by, no Reviewed-
  by, no Acked-by
- (Ignore any Sasha Levin SOB / Upstream commit markers if present in
  candidates)
Record: [Closes bugzilla 221623] [author Zhang Heng] [maintainer SOB
Takashi Iwai] [msgid link] [no Fixes/Cc-stable — expected]

Step 1.3: ANALYZE THE COMMIT BODY TEXT
The Acer Nitro ANV16-42 (SSID 0x1025:0x1909, Realtek ALC245) does not
detect the headset microphone jack. `ALC2XX_FIXUP_HEADSET_MIC` restores
it.
Bugzilla 221623 (verified): reporter samuelrenault37, 2026-06-08; status
NEW; product Drivers / Sound(ALSA). Reporter states analog-input-
headset-mic does not appear without this quirk, points at the same table
line, cites sibling Acer Nitro entries, and says it was tested on Fedora
44, kernel 7.0.11. Zhang Heng replied 2026-08-06 that he would submit
the patch.
Record: [Bug: headset mic jack not enumerated] [Symptom: no analog-
input-headset-mic] [Root cause: missing PCI quirk for SSID 1025:1909]
[User-tested]

Step 1.4: DETECT HIDDEN BUG FIXES
Not hidden. Explicit hardware quirk matching the documented stable
exception for HDA codec quirks.
Record: [Not a disguised cleanup; it is a hardware quirk]

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Mainline diff: `sound/hda/codecs/realtek/alc269.c` +1 line.
This 6.12 tree uses the pre-split file `sound/pci/hda/patch_realtek.c`.
Function: `alc269_fixup_tbl[]` (one `SND_PCI_QUIRK` entry).
Record: [1 file, +1 line] [alc269_fixup_tbl] [single-file surgical
quirk]

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Before: SSID 0x1025:0x1909 has no table match; pin parse does not treat
the jack as a headset mic.
After: `snd_hda_pick_fixup()` in `patch_alc269()` selects
`ALC2XX_FIXUP_HEADSET_MIC`, which on this tree calls
`alc_fixup_headset_mic()` at `HDA_FIXUP_ACT_PRE_PROBE`.
That function (verified identical to later `alc2xx_fixup_headset_mic`):
- applies pin 0x19 config `0x03a1103c`
- updates coef 0x45
- sets `HDA_PINCFG_HEADSET_MIC`
Record: [probe-time pin/coef fixup for this SSID only]

Step 2.3: IDENTIFY THE BUG MECHANISM
Category (h): hardware workaround — PCI quirk table entry for a laptop
whose BIOS pin config omits the headset mic.
Record: [Hardware quirk] [SSID 1025:1909 → existing
ALC2XX_FIXUP_HEADSET_MIC]

Step 2.4: ASSESS THE FIX QUALITY
Obviously correct: same pattern already used in this tree for Acer Nitro
5 AN515-57/58 and AN517-55. Scope is one table row keyed by SSID, so it
cannot affect other machines. Regression risk is very low.
Record: [Surgical, matches existing Acer Nitro entries] [Regression
risk: very low]

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
There is no “buggy line” to blame. The gap is a missing SSID. The fixup
ID and function have been in this tree since `1c643c600407d` (“Add new
alc2xx-fixup-headset-mic model”, upstream 50db91fccea0, in 6.12.y as of
2025-01-09). `alc_fixup_headset_mic` dates to `c8c0a03ec1be6`.
Record: [Missing SSID, not a regression in existing code] [Fixup
infrastructure present since early 6.12.y]

Step 3.2: FOLLOW THE FIXES: TAG
No Fixes: tag. Expected. This is enablement for a specific machine, not
a revert of a bad commit.
Record: [No Fixes: tag; N/A]

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
This tree already contains the same class of backports:
- `db8799e80cb73` ALSA: hda/realtek: Enable headset mic for Acer Nitro 5
- `04818a914fdce` ALSA: hda/realtek: Add quirk for Acer Nitro AN517-55
Recent `patch_realtek.c` history is dominated by other one-line HDA
quirks.
Record: [Standalone] [Precedent: sibling Acer Nitro headset-mic quirks
already in 6.12.y]

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Zhang Heng has other Realtek quirk commits in this tree (e.g.
`2362e35c63cae` Samsung 750XBE/730XBE, `63a5bca438cfb` ASUS UM6702RC).
Regular HDA quirk contributor. Applied by Takashi Iwai.
Record: [Regular quirk contributor] [Maintainer applied]

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Submitted as patch 1/4 with three unrelated quirks (Acer Gadget E10
speaker, ASUS Vivobook S5406SA mic, Huawei Matebook Conexant). No shared
code. On 6.12, `ALC2XX_FIXUP_HEADSET_MIC` already exists and points at
`alc_fixup_headset_mic`, whose body matches mainline
`alc2xx_fixup_headset_mic`. ALC245 (`0x10ec0245`) is already handled in
`patch_alc269()`.
Record: [Standalone] [No missing prerequisites in this tree]

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
`b4 dig -c e00a6a89900dfa4cda3669558d2f3581cd41a656` matched
https://patch.msgid.link/20260807125857.678297-1-zhangheng@kylinos.cn
`b4 dig -a`: only v1 (`[PATCH 1/4]`). Thread saved to mbox.
Takashi Iwai reply (`874ih5bxrt.wl-tiwai@suse.de`): “Applied all four
patches now. Thanks.” No NAK, no requested changes, no Cc: stable
discussion.
Record: [lore/msgid above] [v1 only, applied as submitted] [maintainer
applied] [no NAKs]

Step 4.2: CHECK WHO REVIEWED THE PATCH
`b4 dig -w`: To tiwai@suse.com; Cc linux-sound@vger.kernel.org, linux-
kernel@vger.kernel.org.
Record: [ALSA maintainer was the To: recipient and applied the patch]

Step 4.3: SEARCH FOR THE BUG REPORT
Bugzilla 221623 fetched (HTTP 200 XML). Real user report, codec dump
attached (dump itself is only the HDMI codec; the text still names
ALC245 / 1025:1909). Author confirmed intent to patch. Reporter claimed
the quirk works on their machine.
Record: [One user + author] [Severity: headset mic missing] [Tested by
reporter]

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Series 1–4 are independent device quirks. This commit does not need
2/4–4/4.
Record: [Standalone despite 1/4 numbering]

Step 4.5: CHECK STABLE MAILING LIST HISTORY
lore.kernel.org/stable search returned HTTP 403.
Record: [UNVERIFIED: no stable-list discussion retrieved]

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: [alc269_fixup_tbl entry only] [runtime: alc_fixup_headset_mic
via ALC2XX_FIXUP_HEADSET_MIC]

Step 5.2: TRACE CALLERS
`patch_alc269()` (`sound/pci/hda/patch_realtek.c:12416`) calls
`snd_hda_pick_fixup(..., alc269_fixup_tbl, alc269_fixups)` then
`snd_hda_apply_fixup(..., HDA_FIXUP_ACT_PRE_PROBE)`. That is the
ALC269-family probe path, which includes ALC245 (`0x10ec0245` at line
445).
Record: [Codec probe / device enumeration] [Only SSID 1025:1909]

Step 5.3: TRACE CALLEES
`alc_fixup_headset_mic` → `snd_hda_apply_pincfgs`,
`alc_update_coef_idx`, set `spec->parse_flags |= HDA_PINCFG_HEADSET_MIC`
(defined in `sound/pci/hda/hda_auto_parser.h`).
Record: [Pin override + headset-mic parse flag]

Step 5.4: FOLLOW THE CALL CHAIN
Userspace does not trigger a special syscall; plugging a headset on this
laptop hits the already-probed HDA jack path. Without the quirk the
headset mic control never appears.
Record: [Reachable on this laptop at codec probe] [User-visible audio
input]

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Same SSID vendor 0x1025 already has three `ALC2XX_FIXUP_HEADSET_MIC`
Acer Nitro rows in this tree (0x1539, 0x159c, 0x1597).
Record: [Systematic Acer Nitro headset-mic pin-config bug; this is
another SSID]

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Yes, functionally: quirk table + `ALC2XX_FIXUP_HEADSET_MIC` + ALC245
support are in `sound/pci/hda/patch_realtek.c`. The 0x1909 row is absent
(`git grep 0x1909` on that file: no match). `git merge-base --is-
ancestor e00a6a89900df HEAD` failed.
Record: [Bug/gap exists here] [Introduced as missing hardware
description, not by a post-6.12 commit]

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Mainline path is `sound/hda/codecs/realtek/alc269.c` (post-split). 6.12
still has `sound/pci/hda/patch_realtek.c`. Insertion context also
differs: 6.12’s last Acer 0x1025 rows are 0x1597 / 0x169a, then Dell
0x1028:0x0470; mainline inserts after 0x1844 Helios ZPS. Needs a trivial
path + context backport, not a semantic rework. Exact insert in this
tree: after the 0x169a Acer Swift SFG16 line, before Dell M101z.
Record: [Minor conflicts: file path + nearby rows] [Otherwise clean one-
liner]

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
No 0x1909 / ANV16-42 entry. Sibling Nitro quirks are present; they do
not cover this SSID.
Record: [No existing fix for 1025:1909]

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: [ALSA HD-audio Realtek codec] [IMPORTANT: common laptop audio;
quirk is machine-specific]

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
`patch_realtek.c` is actively receiving quirk backports on this branch
(HP mute LED, Samsung, Victus, etc.). Mature table, high quirk churn by
design.
Record: [Mature driver, active quirk additions — expected for stable]

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: [Driver-specific / DMI-SSID-specific: Acer Nitro ANV16-42 only]

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: [Every boot/probe on that laptop with a headset jack] [Common
for owners of that model] [Unprivileged users hit it via
Pulse/PipeWire/ALSA]

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Not a panic. Headset microphone is missing/unusable. That is a real
functional regression versus Windows/firmware intent for that SKU.
Severity MEDIUM for the platform, HIGH for affected users (basic audio
input broken).
Record: [Failure: headset mic not detected] [Severity: MEDIUM (important
hardware bug, not crash)]

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Benefit: restores headset mic on a shipping Acer Nitro using an
existing, tested fixup. Risk: one SSID-keyed table entry; no API, no
lock, no parser change for other IDs.
Record: [Benefit: high for that SKU] [Risk: very low] [Favor backport]

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Documented user bug (bugzilla 221623) with claimed test of this exact
  quirk
- Textbook hardware quirk / PCI ID exception for stable
- One line, existing `ALC2XX_FIXUP_HEADSET_MIC` /
  `alc_fixup_headset_mic`
- ALC245 already supported; sibling Acer Nitro quirks already in 6.12.y
- Applied by ALSA maintainer; no review objections
- Independent of the rest of the 4-patch series
AGAINST:
- File path/context need a trivial backport (driver split after 6.12)
- Bugzilla codec attachment is only HDMI (incomplete dump);
  identification still given in the report text
- lore.kernel.org/stable search was blocked (403)
UNRESOLVED:
- Could not read stable mailing-list archives (HTTP 403)

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — same fixup as other Nitro
   rows; reporter tested; maintainer applied
2. Fixes a real bug that affects users? **PASS** — headset mic not
   enumerated
3. Important issue? **PASS** — hardware unusable (mic), not a crash;
   still the documented quirk exception
4. Small and contained? **PASS** — +1 line
5. No new features or APIs? **PASS** — existing quirk ID on existing
   driver
6. Can apply to the local tree? **PASS** — needs path/context adjustment
   only; semantics exist here

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: [Hardware quirk/workaround — SND_PCI_QUIRK in Realtek HDA table]

Step 9.4: MAKE YOUR DECISION
This is a one-line Realtek HDA PCI quirk for a user-reported broken
headset mic, using a fixup already in 6.12.y. It should be backported to
this tree.

Verification:
- [Phase 1] Subject/tags: Closes bugzilla 221623; SOB Zhang Heng +
  Takashi Iwai; msgid 20260807125857.678297-1; no Fixes/Cc-stable
- [Phase 1] Bugzilla XML HTTP 200: reporter samuelrenault37, ALC245
  1025:1909, claimed test on Fedora 44 / 7.0.11
- [Phase 2] Diff: +1 `SND_PCI_QUIRK(0x1025, 0x1909, ...,
  ALC2XX_FIXUP_HEADSET_MIC)`
- [Phase 2] 6.12 fixup at patch_realtek.c:10552 uses
  `alc_fixup_headset_mic`; body matches later `alc2xx_fixup_headset_mic`
  (pin 0x19, coef 0x45, HDA_PINCFG_HEADSET_MIC)
- [Phase 3] `git merge-base --is-ancestor e00a6a89900df HEAD` → not in
  this tree
- [Phase 3] `git grep 0x1909 -- sound/pci/hda/patch_realtek.c` → no
  match
- [Phase 3] ALC2XX_FIXUP_HEADSET_MIC present; sibling Nitro quirks
  0x1539/0x159c/0x1597 present
- [Phase 3] `1c643c600407d` already in 6.12.y (alc2xx-fixup-headset-mic
  model)
- [Phase 3] ALC245 `0x10ec0245` handled in patch_realtek.c:445
- [Phase 4] `b4 dig -c e00a6a89900df` →
  patch.msgid.link/20260807125857.678297-1; v1 only
- [Phase 4] `b4 dig -w`: To tiwai@suse.com, Cc linux-sound
- [Phase 4] mbox: Iwai “Applied all four patches now”; series 2/4–4/4
  are unrelated machines
- [Phase 4] lore.kernel.org and patch.msgid.link HTTP 403 from
  curl/WebFetch; used b4 mbox instead
- [Phase 4] UNVERIFIED: stable@ lore search (HTTP 403)
- [Phase 5] Caller: `patch_alc269()` → `snd_hda_pick_fixup(...,
  alc269_fixup_tbl, ...)`
- [Phase 6] `git describe HEAD` / Makefile: pending-6.12, 6.12.111; file
  is patch_realtek.c not alc269.c
- [Phase 6] Insertion point: after 0x169a Acer Swift SFG16, before Dell
  0x1028:0x0470
- [Phase 8] Failure mode: missing headset mic on one laptop SKU, not a
  panic
- UNVERIFIED: bugzilla attachment is HDMI-only, so pin dump for ALC245
  was not independently re-checked from that file

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 05e7fcc2f67e6..9ec18f779a700 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6595,6 +6595,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x1826, "Acer Helios ZPC", ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1025, 0x182c, "Acer Helios ZPD", ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1025, 0x1844, "Acer Helios ZPS", ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x1025, 0x1909, "Acer Nitro ANV16-42", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0470, "Dell M101z", ALC269_FIXUP_DELL_M101Z),
 	SND_PCI_QUIRK(0x1028, 0x053c, "Dell Latitude E5430", ALC292_FIXUP_DELL_E7X),
 	SND_PCI_QUIRK(0x1028, 0x054b, "Dell XPS one 2710", ALC275_FIXUP_DELL_XPS),
-- 
2.53.0

