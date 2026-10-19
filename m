Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A57526597;
	Mon, 19 Oct 2026 14:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418573; cv=none; b=kk4cELhDuiolgN0dwbZBBmLILGRsKcV2we/y0eBq9aSfwq+oFVI7VuiVQmI/45rC5HmO7c0KyHVt9CgXAWcSx12eZe8PmieHKaCggpEOHjPPEv1EpOtoFN9DiaTdOIR6eMP2+vfNLqcFnj9awFXqT6064xD7p5IflHJY1dRPmYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418573; c=relaxed/simple;
	bh=QF1eQoIqa08aJYjuOaD3cOfQFUsXGmH5ogs9SHg25ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kBDyuupke+rkpxX5AUZ5bwT67uQ81WsyUrknJ7q8QvGvL0vHxr8wNFoqaPdvzqSeVGL2iEn4dTSexdwOnglzXZr+tVSLtiWrOZDb+VpjLk5lnDPgp8HKQG/B4J6LAyXNr1l26Bo2P/x7280s+O234bJh2UzIRqa5DPZLvIDcZaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F3ab/Beh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F3ab/Beh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 030591F000C9;
	Mon, 19 Oct 2026 14:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418569;
	bh=EXOEt8iWCksbEuOcUGPJXw9M2YosVwX4WoL1niqqiAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F3ab/BehDzOhAQAYE+CefBEKbWSvcwvuYFz0d8aLyr4q0mo/yt0fHDmXb2sHfLAC5
	 WHlyOUXIBtqFm3kQZpM/1EfxtprtibZHkGsNMj5ouzU3wTIvklm2996e3vPPxEEl3L
	 aULBWUh1caCYR7mzkDCHsrPgG+uWSpZz7GlUzCFfDm2HiBx8chAwGJUsVloZLnkbSR
	 pBS3umQ2a1ea9Yl6cSJncKV5m54O7ho1fg27USieI1t0GMlvf1bnOh1IeRWoYIOU6h
	 Q/rnKwFXxcH18fq3Yc4tqqd8dLk3CuJ6YxiADRlPXoRg0U/Q8VSFgYty2velSM2o/l
	 26GHB/oduPHPQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yashraj Ghule <yashrajghule.221@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ALSA: hda/realtek: Fix mute LED for HP Victus 15-fa1xxx (MB 8C3F)
Date: Mon, 19 Oct 2026 09:50:32 -0400
Message-ID: <20261019135441.1420968-341-sashal@kernel.org>
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

From: Yashraj Ghule <yashrajghule.221@gmail.com>

[ Upstream commit 19b02fecd8f857909af779afe3816e487ac10cd0 ]

The HP Victus 15-fa1xxx with motherboard 8C3F is missing the
existing mute LED quirk for ALC245 codecs.

Add the 103c:8c3f subsystem ID to the existing
ALC245_FIXUP_HP_MUTE_LED_COEFBIT quirk.

Tested on HP Victus 15-fa1xxx (MB 8C3F). The mute LED works
as intended.

Signed-off-by: Yashraj Ghule <yashrajghule.221@gmail.com>
Link: https://patch.msgid.link/20260816110655.11592-1-yashrajghule.221@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Confirmed: this is a one-line HDA subsystem-ID quirk, the existing
ALC245 mute-LED fixup is already in 6.12, and 0x8c3f is not. Writing the
full nine-phase analysis.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[ALSA: hda/realtek]** **[Fix]** mute LED for HP Victus
15-fa1xxx motherboard 8C3F by adding PCI/HDA subsystem ID `103c:8c3f` to
an existing quirk.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Fixes:** none (expected for this review pipeline)
- **Reported-by:** none
- **Tested-by:** none as a tag; the body states the author tested it on
  the matching machine
- **Reviewed-by:** none
- **Acked-by:** none
- **Link:** `https://patch.msgid.link/20260816110655.11592-1-
  yashrajghule.221@gmail.com`
- **Cc: stable:** none (expected; not a negative signal)
- **Signed-off-by:** Yashraj Ghule `<yashrajghule.221@gmail.com>`
  (author); Takashi Iwai `<tiwai@suse.de>` (ALSA maintainer)
- Ignore any Sasha Levin SOB if present in candidate packaging

Notable: ALSA maintainer SOB; author-tested; no syzbot/crash report (not
expected for a hardware quirk).

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** HP Victus 15-fa1xxx with motherboard ID 8C3F does not match
  the existing ALC245 mute-LED quirk, so the mute LED does not follow
  mute state.
- **Symptom:** mute LED stays wrong / does not work.
- **Version info:** none in the message.
- **Root cause:** missing `SND_PCI_QUIRK` for SSID `103c:8c3f`. Same
  product line already has other SSIDs (this tree already has
  `103c:8bc8` "HP Victus 15-fa1xxx").
- **Fix:** add that SSID to `ALC245_FIXUP_HP_MUTE_LED_COEFBIT`.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not a hidden fix. It is an explicit hardware quirk / device-ID
addition. The verb "Fix" is accurate: the LED hardware is already there;
the driver never maps this SSID onto the existing coefbit LED helper.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File in the candidate: `sound/hda/codecs/realtek/alc269.c` (+1 / −0)
- This 6.12 tree still uses `sound/pci/hda/patch_realtek.c` (codec split
  not present)
- Function/table: `alc269_fixup_tbl[]`
- Scope: single-file, one-line surgical quirk addition

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Before:** `snd_hda_pick_fixup()` during Realtek ALC269-family probe
  walks `alc269_fixup_tbl` by PCI SSID. `103c:8c3f` does not match.
  Probe then may fall through to pin fixups and the vendor-wide HP entry
  `SND_PCI_QUIRK_VENDOR(0x103c, "HP", ALC269_FIXUP_HP_MUTE_LED)`
  (`alc269_fixup_vendor_tbl`). That generic HP LED path is not the
  ALC245 coefbit path used by other Victus 15-fa/fb machines.
- **After:** SSID `103c:8c3f` matches
  `ALC245_FIXUP_HP_MUTE_LED_COEFBIT`, so
  `alc245_fixup_hp_mute_led_coefbit()` runs at `HDA_FIXUP_ACT_PRE_PROBE`
  and registers the mute LED via coef index 0x0b.
- Path affected: codec probe / mute-LED setup on that one HP SSID only.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- **Category:** hardware workaround / device ID addition (stable
  exception).
- **Mechanism:** HP reused the Victus 15-fa1xxx name across motherboard
  SSIDs (`8bc8` already in this tree; mainline also has `8c2d`, `8c3f`,
  and later `8bb1`). Quirk matching is exact vendor:device. Missing ID →
  LED not driven by the ALC245 coefbit helper.
- Not UAF, leak, race, or crash.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- Obviously correct: one `SND_PCI_QUIRK` using the same fixup already
  used by many Victus SKUs in this file (`8a4f`, `8a50`, `8bc8`, `8c30`,
  `8c99`, `8c9c`, …).
- Minimal; no unrelated edits.
- Regression risk is very low: the new entry is SSID-specific. Wrong
  SSID would not match. Same helper is already production-used on this
  tree.
- v2 reordering (SSID sort) does not change runtime (the table is a
  match list, not order-dependent beyond uniqueness).

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Insertion sits next to `SND_PCI_QUIRK(0x103c, 0x8c30, "HP Victus
  15-fb1xxx", ALC245_FIXUP_HP_MUTE_LED_COEFBIT)` — blamed to
  `b474f60f6a0c9` (Adam Queler, 2024-09-03), already in this tree,
  originally `Cc: stable`.
- The fixup enum/function `ALC245_FIXUP_HP_MUTE_LED_COEFBIT` /
  `alc245_fixup_hp_mute_led_coefbit()` exists here (`patch_realtek.c`
  around 4778 and 10522).
- Helper was brought in via `c4cc8f6c31263` ("ALSA: hda/realtek -
  Support mute led function for HP platform", upstream `22c7f77247a8`),
  ancestor of HEAD.
- Same product line: `96fe253552c26` already added `103c:8bc8` "HP
  Victus 15-fa1xxx" to this tree (upstream `a0914bf56e26`, `Cc:
  stable`).

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. N/A. The "bug" is a missing table entry, not a
regression from a specific prior commit.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record:
- This tree already contains many of the same class of patches (git log
  `--grep='mute LED' -- sound/pci/hda/patch_realtek.c` returned 166
  commits).
- Recent examples: Victus 16-e0xxx MB 88ED (`faee5b4612c26`), Victus
  15-fa0xxx MB 8A50 (`0ecc9d81b46b1`), Victus 16-s0xxx, 16-r0xxx,
  15-fb1xxx (`b474f60f6a0c9`).
- Mainline context line `103c:8c2d` "HP Victus 15-fa1xxx (MB 8C2D)" is
  **not** in this tree (`git log --grep='8C2D' --
  sound/pci/hda/patch_realtek.c` empty). That is neighboring context,
  not a functional prerequisite.
- Standalone: yes. Not patch X/Y.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: `git log --author='Yashraj Ghule' -- sound/pci/hda/` is empty in
this tree. Author is an end-user contributor, not the subsystem
maintainer. Weight comes from Takashi Iwai applying it, plus the well-
worn quirk pattern.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record:
- Needs `ALC245_FIXUP_HP_MUTE_LED_COEFBIT` and `alc269_fixup_tbl` — both
  present.
- Does **not** need the later `alc269.c` file split.
- Does **not** need the 8C2D quirk.
- Can apply standalone with path remap to
  `sound/pci/hda/patch_realtek.c` and insertion after the existing
  `0x8c30` line.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c <HEAD>` cannot match this commit; it is not in this
  checkout.
- `b4 mbox` on Message-ID
  `20260816110655.11592-1-yashrajghule.221@gmail.com` found **4
  messages**.
- Thread: v1 (15 Aug 2026) → Takashi review → v2 (16 Aug 2026) → Takashi
  "Applied now."
- v1 issues (not technical risk of the quirk): SOB must use a real name;
  table must stay in PCI SSID order (`8c3f` belongs after `8c30`, not
  before).
- v2 addressed both; that is the committed form.
- No NAK. No reviewer concern about the quirk itself. No `Cc: stable` in
  the thread.
- lore.kernel.org HTTP fetch returned 403; thread recovered from lore
  via `b4 mbox`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (from mbox, equivalent of `b4 dig -w`):
- To: Jaroslav Kysela `perex@perex.cz`
- Cc: Takashi Iwai `tiwai@suse.de`, `linux-sound@vger.kernel.org`
- Reviewer/applier: Takashi Iwai (ALSA/HDA maintainer)

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No bugzilla/syzbot link. Evidence of user impact is the author
test on HP Victus 15-fa1xxx (MB 8C3F). Same model family already needed
extra SSIDs (8bc8 here; 8C2D and 8BB1 in later/mainline discussion),
which matches HP shipping multiple board IDs under one marketing name.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Standalone v1→v2, not a multi-patch series. Related but
independent: 8C2D (Eren Demir) and 8BB1 (Krish Gulati / bugzilla 221982)
add other fa1xxx SSIDs. None of those replace 8C3F.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: No stable-list discussion found for 8C3F specifically. Closely
related 8bc8 and 8c30 quirks in this tree **did** carry `Cc: stable` and
were backported. That is the established policy for this exact pattern,
not evidence this commit was already selected.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: KEY FUNCTIONS**

Record: table `alc269_fixup_tbl`; runtime helper
`alc245_fixup_hp_mute_led_coefbit()` (unchanged); picker
`snd_hda_pick_fixup()`.

**Step 5.2: TRACE CALLERS**

Record:
- Realtek ALC269-family probe in `patch_realtek.c` (~12583) calls
  `snd_hda_pick_fixup(..., alc269_fixup_tbl, alc269_fixups)`.
- Then `snd_hda_apply_fixup(codec, HDA_FIXUP_ACT_PRE_PROBE)` (~12606).
- Context: codec probe (device enumeration), not IRQ/hot path.

**Step 5.3: TRACE CALLEES**

Record: `alc245_fixup_hp_mute_led_coefbit()` sets `spec->mute_led_coef`
(idx 0x0b, mask/on/off bits) and `snd_hda_gen_add_mute_led_cdev(codec,
coef_mute_led_set)`.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: userspace/hw mute → HDA mixer/LED classdev → coef write.
Reachable on this laptop at boot + mute key. Not a syscall security
path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: many `ALC245_FIXUP_HP_MUTE_LED_COEFBIT` rows for Victus SSIDs
already in this file (including `0x8bc8` 15-fa1xxx and `0x8c30`
15-fb1xxx). Same bug, different board ID — systematic HP SSID
fragmentation.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record:
- Tree: `pending-6.12` / `git describe` `p-6.12-3-gc504cf0baa3d8` /
  `make kernelversion` **6.12.111**.
- `sound/hda/codecs/realtek/alc269.c` does **not** exist.
- Equivalent table: `sound/pci/hda/patch_realtek.c` `alc269_fixup_tbl`.
- `0x8c3f` is **absent** (`grep` on that file: no match).
- `ALC245_FIXUP_HP_MUTE_LED_COEFBIT` **is** present.
- Nearby `0x8c30` **is** present (line 11088).
- Nearby mainline `0x8c2d` is **absent**.
- Bug is a missing ID, not a post-6.12 logic regression. The machine and
  the helper both exist for 6.12 users.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **minor path/context adjustment**, not a rework.
- Remap file to `sound/pci/hda/patch_realtek.c`.
- Insert after `0x8c30` (8c2d context from mainline is missing, so a
  verbatim git-apply of the mainline hunk may not be fully clean).
- No API/data-structure change.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: `0x8bc8` covers a different fa1xxx SSID, not 8C3F. Exact PCI
SSID match only. No substitute for this ID.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: SUBSYSTEM AND CRITICALITY**

Record: ALSA HD-audio / Realtek codec (`sound/pci/hda/`). **IMPORTANT**
for laptop audio users, **PERIPHERAL** in blast radius (one HP SSID).
Not mm/fs/net core.

**Step 7.2: SUBSYSTEM ACTIVITY**

Record: High churn of device quirks; this file is the standard place for
HP mute-LED IDs. Mature helper, incremental table growth.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: WHO IS AFFECTED**

Record: **driver-specific / hardware-specific** — only HP SSID
`103c:8c3f` (Victus 15-fa1xxx MB 8C3F). CONFIG_SND_HDA_CODEC_REALTEK
(standard laptop configs).

**Step 8.2: TRIGGER CONDITIONS**

Record: every boot + mute on that SKU. Not a race. Unprivileged user can
observe the LED; not a privilege-escalation path.

**Step 8.3: FAILURE MODE SEVERITY**

Record: mute LED does not track mute. **MEDIUM** functionally (no
oops/corruption). Still a real hardware bug. Stable rules explicitly
include device IDs and hardware quirks.

**Step 8.4: RISK-BENEFIT RATIO**

Record:
- **Benefit:** restores mute LED on a shipping HP Victus SKU for 6.12
  users; same class already backported here many times.
- **Risk:** very low (one SSID-guarded line, existing helper).
- **Ratio:** strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Stable rules: "fix a real bug … **or just add a device ID**" and
  "**hardware quirk**" (`Documentation/process/stable-kernel-rules.rst`
  lines 15–20).
- One-line addition to an existing driver/fixup.
- Target SSID missing; helper and table present in 6.12.111.
- Author tested on the exact machine; ALSA maintainer applied v2.
- Same Victus 15-fa1xxx family already has `8bc8` in this tree; 8C3F is
  another board ID.
- Dozens of identical mute-LED quirk backports already in this file.

AGAINST:
- Not a crash/security/data-corruption fix.
- Mainline path differs (`alc269.c` vs `patch_realtek.c`); 8c2d context
  line missing (trivial).
- No `Cc: stable` on the original (expected here; similar quirks often
  still go to stable).

UNRESOLVED:
- Direct lore.kernel.org HTTP was 403; discussion was recovered via `b4
  mbox`.
- Could not `b4 dig -c` an upstream SHA because that commit is not in
  this checkout.
- No independent bugzilla for 8C3F (author is the tester).

**Step 9.2: STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — one table entry; author
   tested; maintainer applied.
2. Fixes a real bug that affects users? **PASS** — mute LED dead on that
   SKU.
3. Important issue? **PASS** as hardware quirk / device ID (severity
   MEDIUM, allowed exception).
4. Small and contained? **PASS** — +1 line.
5. No new features or APIs? **PASS** — enables existing fixup for one
   SSID.
6. Can apply to the local tree? **PASS** — helper+table exist; needs
   path remap and insert after `0x8c30`.

**Step 9.3: EXCEPTION CATEGORIES**

Record: **Device ID addition to an existing driver** and **hardware
quirk/workaround** (HDA `SND_PCI_QUIRK`).

**Step 9.4: DECISION**

This should be backported to **this** 6.12 tree. The bug is present
(missing `103c:8c3f`), the fix is the standard Realtek mute-LED quirk,
and it is self-contained aside from a trivial file-path/context tweak.

What it solves for stable users: HP Victus 15-fa1xxx systems with
motherboard SSID 8C3F get a working mute LED, matching other
fa1xxx/fb1xxx board IDs already quirked here.

Risk vs benefit: one SSID-specific line vs a user-visible LED bug on a
current consumer laptop. Benefit dominates.

Concerns: apply to `sound/pci/hda/patch_realtek.c`, not `alc269.c`; do
not require the absent 8C2D row.

Verification:
- [Phase 1] Parsed subject/tags/body from the candidate message; Link
  msgid `20260816110655.11592-1-yashrajghule.221@gmail.com`; SOBs Ghule
  + Iwai; no Fixes/syzbot/stable Cc.
- [Phase 2] Diff is +1 `SND_PCI_QUIRK(0x103c, 0x8c3f, ...,
  ALC245_FIXUP_HP_MUTE_LED_COEFBIT)` in `alc269_fixup_tbl`.
- [Phase 3] `git describe HEAD` → `p-6.12-3-gc504cf0baa3d8`; `make
  kernelversion` → 6.12.111; branch `pending-6.12`.
- [Phase 3] `alc269.c` missing; quirk table in
  `sound/pci/hda/patch_realtek.c`.
- [Phase 3] `grep 0x8c3f` in that file: no match.
  `ALC245_FIXUP_HP_MUTE_LED_COEFBIT` present (enum ~8222, fixup ~10522,
  function ~4778).
- [Phase 3] `0x8c30` present (blame `b474f60f6a0c9`); `0x8bc8` present
  (`96fe253552c26`); `0x8c2d` absent.
- [Phase 3] `git merge-base --is-ancestor` for `b474f60f6a0c9` and
  `c4cc8f6c31263`: both ancestors of HEAD.
- [Phase 3] `git log --grep='mute LED' --
  sound/pci/hda/patch_realtek.c`: 166 commits of the same class.
- [Phase 4] `b4 mbox` on the msgid: v1, Takashi review (SOB name + SSID
  sort), v2, "Applied now."
- [Phase 4] Recipients: perex, tiwai, linux-sound. No NAK.
- [Phase 4] lore WebFetch 403; discussion taken from the saved mbox.
- [Phase 5] Probe path `snd_hda_pick_fixup` ~12583 →
  `snd_hda_apply_fixup` PRE_PROBE ~12606; vendor HP fallback
  `ALC269_FIXUP_HP_MUTE_LED` at `alc269_fixup_vendor_tbl`.
- [Phase 6] Backport difficulty: path remap + insert after 8c30 (8c2d
  context missing).
- [Phase 7] ALSA HDA Realtek; quirk-table activity high.
- [Phase 8] Failure: mute LED inoperative on one HP SSID; severity
  MEDIUM; risk very low.
- UNVERIFIED: upstream mainline SHA of this commit (not in this
  checkout; `b4 dig -c HEAD` cannot match it).

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 9ec18f779a700..bc33930e83b9f 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6974,6 +6974,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8c21, "HP Pavilion Plus Laptop 14-ey0XXX", ALC245_FIXUP_HP_X360_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x8c2d, "HP Victus 15-fa1xxx (MB 8C2D)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8c30, "HP Victus 15-fb1xxx", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
+	SND_PCI_QUIRK(0x103c, 0x8c3f, "HP Victus 15-fa1xxx (MB 8C3F)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8c46, "HP EliteBook 830 G11", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c47, "HP EliteBook 840 G11", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c48, "HP EliteBook 860 G11", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
-- 
2.53.0

