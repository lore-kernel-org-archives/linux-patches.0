Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9418D5D5DB7;
	Mon, 19 Oct 2026 14:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418509; cv=none; b=MVSk86Kik1w0vapwF4Da0iAhVYQ9/3GAPEcok/WEsR3gUXs9BCYEzu6yGz5hOQKZvfBcWXgR7FLQj0bwfZvFse3SgKiGH6lVKhRrs/RajH5TIxgkk1iiKoy+d12l9VTJAch6qWLI8UrNjEL30A18o8hjT0YavuKlV3S+NQN+2Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418509; c=relaxed/simple;
	bh=KbXQMy/Q1xqXOI4xI0aYi99h7GRPx0ATf1Fku2rGguE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lz4iGOWqdkiAeNKYX40aZllWzng/qxYwmBkDICewhVQ57L8iuk6za8KZnGA/PA6wXPDfWW9cOWvPbkexiOiE3v65jaQ1D3KjYNBfm/997IsFs9SisHfTDR4ElCIf+Vxs1dGxiO/korirNIZYTVC1I7tbBzwC/tlJrQ0v98F0Tm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZN60bu7/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZN60bu7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7339C1F000C4;
	Mon, 19 Oct 2026 14:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418506;
	bh=Gc/uY6TCcnVW+UyLBbh5C0QYATKOMm7aAOb9j2sCFQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZN60bu7/l0JrtnAbv+trQ2PGjUU6aGIK37Y2Pap/KoPhxAo2675dzZ6L14fA9fVqK
	 f9GjXlwqW8klWmOHOwrV95RXmPMFazzzmlHaq7NF7srLwdKOyw4Yrk5NY0OMvHWoZV
	 7G0vVYVI31qzrbaydbeXTxeXy6Pd+QSMjxFJR8fX3a6JseQjkb23MT7OpjeAPmyTZt
	 yx3tj1RsSdmsHHzQPqQaHLmWazkaprY6hMwbK6+7+nQ+NKNBTTRQyRdxRg6J9yW3ie
	 zF2YX6IgHwsWgctA4tw51p4v6WMttaSzIdJ+c/BvWOTlfvp20Hoo1m2xEMdR2M3s7O
	 hBhGuxXZWi0Fg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Krish Gulati <krishgulati7@gmail.com>,
	erph.briones27@gmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ALSA: hda/realtek: Add mute LED quirk for HP Victus 15-fb2xxx
Date: Mon, 19 Oct 2026 09:49:48 -0400
Message-ID: <20261019135441.1420968-297-sashal@kernel.org>
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

From: Krish Gulati <krishgulati7@gmail.com>

[ Upstream commit c748c42abb9b549fc79c41ea55e1f220eadb60ec ]

The HP Victus 15-fb2xxx (PCI SSID 103c:8c2f) with the ALC245 codec
does not turn on the mute LED when audio is muted.
Add a quirk entry to enable it.

Reported-by: erph.briones27@gmail.com
Link: https://bugzilla.kernel.org/show_bug.cgi?id=221946
Signed-off-by: Krish Gulati <krishgulati7@gmail.com>
Tested-by: Raphael Briones <erph.briones27@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260921131728.8999-1-krishgulati7@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a one-line HP Realtek mute-LED quirk for an existing fixup. The
local tree is **6.18.57** (`v6.18.57-155-gcdf239ca885b2`). The bug
exists here: SSID `103c:8c2f` is not in `v6.18.57`, while
`ALC245_FIXUP_HP_MUTE_LED_COEFBIT` and sibling Victus entries already
are.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[ALSA: hda/realtek]** **[Add]** one-line PCI SSID quirk so the
HP Victus 15-fb2xxx mute LED works.

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- **Reported-by:** erph.briones27@gmail.com (real user hit it)
- **Link:** https://bugzilla.kernel.org/show_bug.cgi?id=221946 (user bug
  report)
- **Link:**
  https://patch.msgid.link/20260921131728.8999-1-krishgulati7@gmail.com
  (submission)
- **Tested-by:** Raphael Briones \<erph.briones27@gmail.com\> (reporter
  verified the fix)
- **Signed-off-by:** Krish Gulati \<krishgulati7@gmail.com\> (author)
- **Signed-off-by:** Takashi Iwai \<tiwai@suse.de\> (ALSA maintainer)
- No **Fixes:** tag (expected)
- No original **Cc: stable** (expected; not a negative)
- Pipeline `[Upstream commit c748c42abb9b549fc79c41ea55e1f220eadb60ec]`
  and Sasha Levin SOB ignored per instructions

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** HP Victus 15-fb2xxx, PCI SSID `103c:8c2f`, ALC245 codec, mute
  LED stays off when audio is muted.
- **Symptom:** mute LED does not light (hardware indicator broken; audio
  itself is not described as broken).
- **Root cause (author):** this SSID is missing from the Realtek quirk
  table, so the existing ALC245 mute-LED coefbit fixup is never
  selected.
- **Version info:** none in the message. Reporter later said they tested
  on kernel 7.2.6-1-cachyos (from the lore thread, not the commit body).

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a hidden fix. It is an explicit hardware quirk. Same class
as the documented stable exception for `SND_PCI_QUIRK` / HDA codec
quirks.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- **File:** `sound/hda/codecs/realtek/alc269.c` (+1 / −0)
- **Function/data:** `alc269_fixup_tbl[]` only
- **Scope:** single-file, surgical, one table entry

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- **Before:** `snd_hda_pick_fixup()` walks `alc269_fixup_tbl` at
  ALC269-family probe. SSID `103c:8c2f` does not match, so no mute-LED
  coefbit setup runs.
- **After:** that SSID maps to `ALC245_FIXUP_HP_MUTE_LED_COEFBIT`, which
  calls `alc245_fixup_hp_mute_led_coefbit()` on
  `HDA_FIXUP_ACT_PRE_PROBE` and registers the mute LED cdev via
  `snd_hda_gen_add_mute_led_cdev()`.
- **Path:** device probe / codec init only, and only for this SSID.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- **Category:** hardware workaround / existing-driver quirk (h)
- **Mechanism:** ALC245 mute LED on this HP board is driven by codec
  coef 0x0b bits, not the generic path. Without the quirk, the LED never
  turns on. The patch does not invent that logic; it reuses
  `alc245_fixup_hp_mute_led_coefbit()` already used by nearby Victus IDs
  (`0x8c30` 15-fb1xxx, `0x8c2d` 15-fa1xxx, `0x8d07` another 15-fb2xxx
  board).

Verified fixup body in this tree:

```1566:1579:sound/hda/codecs/realtek/alc269.c
static void alc245_fixup_hp_mute_led_coefbit(struct hda_codec *codec,
                                          const struct hda_fixup *fix,
                                          int action)
{
        struct alc_spec *spec = codec->spec;

        if (action == HDA_FIXUP_ACT_PRE_PROBE) {
                spec->mute_led_polarity = 0;
                spec->mute_led_coef.idx = 0x0b;
                spec->mute_led_coef.mask = 3 << 2;
                spec->mute_led_coef.on = 2 << 2;
                spec->mute_led_coef.off = 1 << 2;
                snd_hda_gen_add_mute_led_cdev(codec, coef_mute_led_set);
        }
}
```

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: one `SND_PCI_QUIRK(0x103c, 0x8c2f, ...,
  ALC245_FIXUP_HP_MUTE_LED_COEFBIT)` in SSID order between `0x8c2d` and
  `0x8c30`.
- `SND_PCI_QUIRK` uses `_SND_PCI_QUIRK_ID(vend, dev)` with
  `subdevice_mask = 0xffff`, so it matches only this exact SSID.
- Regression risk is very low: no locking, no API, no shared-path logic
  change. Wrong-board risk is limited to `103c:8c2f`. Reporter tested
  both hardware mute key and software mixer.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Insertion sits between existing HP entries. Neighbor `0x8c30` “HP
  Victus 15-fb1xxx” comes from `b474f60f6a0c9` (“Enable Mute Led for HP
  Victus 15-fb1xxx”, 2024-09-04), present in this tree.
- Mute-LED coefbit helper itself dates to `22c7f77247a84` (“Support mute
  led function for HP platform”, 2025-04-02), ancestor of `v6.18.57`.
- This is long-lived driver infrastructure, not post-6.18 code.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No `Fixes:` tag. Not applicable. The “bug” is a missing SSID for
hardware that already existed; there is no introducing-commit in the
usual sense.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- Related: `ce174b48aebb3` “Add mute LED support for HP Victus
  15-fb2xxx” added **`0x8d07`** (MB 8D07), not `0x8c2f`. That earlier
  patch even had `Cc: stable@vger.kernel.org`. Same product line,
  different motherboard SSID.
- `v6.18.57` already has `0x8d07` and `0x8c30`. `0x8c2f` is the missing
  sibling.
- Standalone: not patch X/Y. One table line, no series.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Krish Gulati has this one Realtek commit in this tree. Not the
subsystem maintainer. Weight comes from Takashi Iwai applying it and
from the reporter’s `Tested-by`.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record:
- Needed pieces in `v6.18.57`: `alc269.c`, `alc269_fixup_tbl`, enum
  `ALC245_FIXUP_HP_MUTE_LED_COEFBIT`,
  `alc245_fixup_hp_mute_led_coefbit()`, `snd_hda_pick_fixup()`.
- Confirmed present via `git grep` on `v6.18.57`.
- Can apply standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c c748c42abb9b549fc79c41ea55e1f220eadb60ec` →
  https://patch.msgid.link/20260921131728.8999-1-krishgulati7@gmail.com
- `b4 dig -a`: **v1 only**, 2026-09-21. No later revision.
- Thread:
  1. Krish Gulati submits the one-line quirk.
  2. Raphael Briones (reporter): applied on HP Victus 15-fb2xxx, ALC245,
     SSID `103c:8c2f`, kernel 7.2.6-1-cachyos; mute LED works with
     hardware key and software mixer. `Tested-by` given.
  3. Takashi Iwai (2026-09-28): “Applied now. Thanks.” No NAK, no stable
     objection.
- Lore HTML fetch returned 403 (Anubis). Thread recovered via `b4 dig
  -m`.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): To/Cc included Jaroslav Kysela, Takashi Iwai,
linux-sound, Realtek’s Kailang Yang, and the reporter. Maintainer
applied it. No NAK.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: Bugzilla 221946 is cited. Direct HTTP fetch was blocked by
Anubis (403). Primary evidence of user impact is the lore `Tested-by` on
the exact SSID, which is verified.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone v1. Precedent: `ce174b48aebb3` did the same for
15-fb2xxx SSID `0x8d07` and nominated stable.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable HTML search also 403. UNVERIFIED whether
stable@ discussed this exact `0x8c2f` patch. The sibling `0x8d07` change
was explicitly Cc’d to stable, which is verified from git.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: No function body changed. Data: `alc269_fixup_tbl[]`. Runtime
path: `snd_hda_pick_fixup()` → `ALC245_FIXUP_HP_MUTE_LED_COEFBIT` →
`alc245_fixup_hp_mute_led_coefbit()`.

Step 5.2: TRACE CALLERS
Record:
- `alc269_fixup_tbl` is passed from ALC269-family probe in `alc269.c`
  (`snd_hda_pick_fixup(codec, alc269_fixup_models, alc269_fixup_tbl,
  alc269_fixups)` around line 8557).
- Called during HD-audio codec probe, not IRQ/hot path.
- Impact surface is this one PCI subsystem ID.

Step 5.3: TRACE CALLEES
Record: `alc245_fixup_hp_mute_led_coefbit()` writes `spec->mute_led_*`
and calls `snd_hda_gen_add_mute_led_cdev(codec, coef_mute_led_set)`.
Existing, already used by many HP entries in this tree.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Userspace-reachable on machines with this laptop: codec probe at
boot, then mute LED updates when the user mutes. Not a syscall crash
path. Real user-visible hardware behavior.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same `ALC245_FIXUP_HP_MUTE_LED_COEFBIT` already used for many HP
Victus SSIDs in `v6.18.57` (`0x88ee`, `0x8a25`, `0x8a26`, `0x8a4f`,
`0x8a50`, `0x8bbe`, `0x8bc8`, `0x8c2d`, `0x8c30`, `0x8d07`, …). This is
the established pattern, not a one-off experiment.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record:
- Local tree: **Linux 6.18.57** (`git describe HEAD` =
  `v6.18.57-155-gcdf239ca885b2`, `VERSION/PATCHLEVEL/SUBLEVEL` =
  6/18/57).
- `v6.18.57` **does not** contain `0x8c2f` (`git grep 0x8c2f v6.18.57 --
  sound/hda/codecs/realtek/alc269.c` empty).
- `v6.18.57` **does** contain the insertion neighbors `0x8c2d` and
  `0x8c30`, and the fixup enum/function.
- Bug is a missing quirk for hardware that this driver already supports.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record:
- Mainline context after the new line includes `0x8c3f`, which is
  **not** in `v6.18.57` (8c2d is immediately followed by 8c30).
- Applying to `v6.18.57` is a trivial one-line insert between those two
  existing entries (minor context fuzz, not a semantic conflict).
- File path `sound/hda/codecs/realtek/alc269.c` already exists here
  (Realtek split commit `aeeb85f26c3bbe` is in 6.18).

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: `0x8d07` “HP Victus 15-fb2xxx (MB 8D07)” is already in
`v6.18.57`. That does **not** cover `0x8c2f`. No other fix for this SSID
in 6.18.57.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: **ALSA HD-audio / Realtek codec** (`sound/hda/codecs/realtek/`).
**IMPORTANT** for laptop audio, not core mm/scheduler. Quirk tables in
this driver are a standard stable target.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Actively receiving similar one-line HP mute-LED quirks
(Pavilion, Victus, EliteBook). Mature table, same pattern repeated. This
is not experimental code.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver/config-specific: `CONFIG_SND_HDA_CODEC_REALTEK` users
with PCI audio SSID **103c:8c2f** (HP Victus 15-fb2xxx). No effect on
other machines.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Every boot on that laptop: mute LED stays dark when mute is
engaged. Unprivileged users notice it; not a security trigger. Reporter
reproduced it on real hardware.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: Mute LED does not light. **MEDIUM** functionally (broken
hardware indicator, not oops/corruption). Still qualifies under the
**hardware quirk exception**, which stable explicitly takes.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- **Benefit:** high for owners of this common HP gaming laptop; restores
  LED using the same path already shipping for sibling Victus boards.
  Precedent: 8d07 was sent to stable.
- **Risk:** very low (1 line, exact SSID match, existing fixup).
- **Ratio:** strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
**FOR:**
- Real user bug + Tested-by on the exact SSID
- Maintainer applied (Takashi Iwai)
- One-line `SND_PCI_QUIRK` — classic stable exception
- Fixup and neighboring Victus entries already in 6.18.57
- Sibling 15-fb2xxx `0x8d07` quirk was Cc:stable
- No new API, no new function, no shared-path logic change

**AGAINST:**
- Not a crash/security/corruption fix (mute LED only)
- Mainline context line `0x8c3f` is absent here (trivial fuzz)

**UNRESOLVED:**
- Bugzilla 221946 page body (HTTP 403)
- Whether stable@ already discussed this exact hash (HTTP 403)

Those gaps do not change the decision: lore + git already show a tested,
maintainer-accepted quirk whose prerequisites are in this tree.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — 1-line SSID add; reporter
   tested; maintainer applied
2. Fixes a real bug that affects users? **PASS** — mute LED broken on HP
   Victus 15-fb2xxx `103c:8c2f`
3. Important issue? **PASS** under hardware-quirk exception (severity
   MEDIUM as a crash class, but explicit stable exception)
4. Small and contained? **PASS** — +1 line, one table
5. No new features or APIs? **PASS** — enables existing fixup for one
   more ID
6. Can apply to the local tree? **PASS** — file, table, and fixup exist
   in `v6.18.57`; insert between `0x8c2d` and `0x8c30`

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: **Hardware quirk / SND_PCI_QUIRK for an existing HDA Realtek
driver.** This is the documented YES class (audio codec quirks for
specific laptop models).

Step 9.4: MAKE YOUR DECISION
Backport. The 6.18.y driver already has the mute-LED machinery and other
Victus SSIDs; this only names the missing `103c:8c2f` board.

What problem it solves: on HP Victus 15-fb2xxx (`103c:8c2f`, ALC245) the
mute LED never turns on because the SSID is absent from
`alc269_fixup_tbl`. Adding the existing
`ALC245_FIXUP_HP_MUTE_LED_COEFBIT` entry enables the LED. That matters
to stable users of this laptop and does not change any other machine.

Risk vs benefit: benefit is restoring a user-visible LED on a current HP
model; risk is a single exact-SSID table line. Neighbor `0x8d07` for the
same product name already went to stable.

Concerns: apply context may need dropping the mainline `0x8c3f` line;
that is a one-line mechanical insert, not a semantic dependency.

Verification:
- [Phase 1] Parsed tags: Reported-by, Tested-by (same user), bugzilla
  221946, maintainer SOB Takashi Iwai
- [Phase 2] Diff: +1 `SND_PCI_QUIRK(0x103c, 0x8c2f, ...
  ALC245_FIXUP_HP_MUTE_LED_COEFBIT)` in `alc269_fixup_tbl`
- [Phase 2] `SND_PCI_QUIRK` uses `subdevice_mask = 0xffff`
  (`include/sound/core.h`) — exact SSID only
- [Phase 2] Read `alc245_fixup_hp_mute_led_coefbit()` at alc269.c:1566 —
  existing coef 0x0b LED setup
- [Phase 3] `git describe HEAD` / Makefile: this tree is 6.18.57
- [Phase 3] `git merge-base --is-ancestor 22c7f77247a84 v6.18.57` —
  fixup helper is in 6.18.57
- [Phase 3] `git grep 0x8c2f v6.18.57 --
  sound/hda/codecs/realtek/alc269.c` — empty; bug present
- [Phase 3] `git grep` on v6.18.57: `0x8c2d`, `0x8c30`, `0x8d07`,
  `ALC245_FIXUP_HP_MUTE_LED_COEFBIT` all present
- [Phase 3] `ce174b48aebb3` is a different SSID (`0x8d07`) for the same
  product line, Cc:stable
- [Phase 4] `b4 dig -c c748c42...`: lore
  https://patch.msgid.link/20260921131728.8999-1-krishgulati7@gmail.com
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] `b4 dig -w`: linux-sound + Takashi Iwai + Jaroslav Kysela
- [Phase 4] mbox: reporter Tested-by on 103c:8c2f; Iwai “Applied now”;
  no NAK
- [Phase 4] UNVERIFIED: bugzilla HTML and stable@ lore (HTTP 403 /
  Anubis)
- [Phase 5] `alc269_fixup_tbl` selected from codec probe via
  `snd_hda_pick_fixup()` (alc269.c ~8557)
- [Phase 6] v6.18.57 table has 8c2d then 8c30; 8c3f not in this series —
  trivial context adjust
- [Phase 8] Failure mode: mute LED dark; severity MEDIUM; quirk
  exception applies

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 0a3df8b78aae6..4eefd5d87f04b 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7004,6 +7004,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8c17, "HP Spectre x360 2-in-1 Laptop 16-aa0xxx", ALC245_FIXUP_HP_SPECTRE_X360_16_AA0XXX),
 	SND_PCI_QUIRK(0x103c, 0x8c21, "HP Pavilion Plus Laptop 14-ey0XXX", ALC245_FIXUP_HP_X360_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x8c2d, "HP Victus 15-fa1xxx (MB 8C2D)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
+	SND_PCI_QUIRK(0x103c, 0x8c2f, "HP Victus 15-fb2xxx", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8c30, "HP Victus 15-fb1xxx", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8c3f, "HP Victus 15-fa1xxx (MB 8C3F)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8c46, "HP EliteBook 830 G11", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
-- 
2.53.0

