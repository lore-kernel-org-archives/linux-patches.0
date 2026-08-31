Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8602E5398BD;
	Mon, 31 Aug 2026 13:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183932; cv=none; b=lCcHHJ2oAxJqCjV39WgH4pBmPDQFRJJq9IEc0Ajtvrw9Q14bcaZp35Z21IUEeDyI5v0YDTbfteFyYAslHuE1eXEA91fOi3pkIXPNgbcETRuNzV7USp6G4QI+Ukiy1gh/ej6ivkBHTwM8zjk14dxMO5k3uMVDHrUfIHm5p51ip10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183932; c=relaxed/simple;
	bh=+nDScU1eHPo60mr2delHp+hvhWRAA+0kQm5o0DkMk0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q2kzkdFr6+xZ0A8SgeF/6oQVa3rbIMYp8spdUi+kMaWrMkBW/8p/6rHy+LU/xUanth6KUISlwrU2Kfg2bcCYHbWgj/6GM+Rxrb6Uz4CqDzW7JOeGEABV4xSj6bb7rc+dwZClum8zlSV2o7HjUMppJyd++0vVKZVd2o1Ti47/MHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m5KBTh4y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m5KBTh4y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E68D1F00ADB;
	Mon, 31 Aug 2026 13:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183929;
	bh=SR35+kLvZ+3Utg3Vi17q/I+FllLjkUg/cEsJJ/cXGFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m5KBTh4yL/HAMU08y9h3y70sXzPg7F+DBzsivwnv4ds6dTBCnEnVlm3rIx/L2A6P6
	 Nold3TJuEjzNSBRJYlxUAIISA34vcrhZYSYE8fWUWZiTAtgiFVdcayCixwTgxFBP9r
	 TkDnJNPn7PorPtxUnaHJBuDBKwDRbw0OPSDllujQnm7OyMEersQaE6j9Qyud90y9jR
	 Yt/6lKEL1GAWAAjCoKobV0ST46HAUbjio0qwJxsqIixE6UZYYHGU5tSjYq3+DZWzgK
	 jBKnUEu774q9obJtvBRz7aJjfk5tfE+GV5QD6oAg55CzbqOrZhDdfNBH0gGj6mJ8WC
	 1KFy3ZRwT/wwQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Madhavender Singh <madhav@disroot.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ALSA: hda/realtek: Add mute LED quirk for HP Laptop 14s-dr1xxx
Date: Mon, 31 Aug 2026 09:26:55 -0400
Message-ID: <20260831133314.4125787-387-sashal@kernel.org>
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

From: Madhavender Singh <madhav@disroot.org>

[ Upstream commit bf4fc9f33ec21595143132a3e7fb8b5d2c2261cd ]

This laptop with an ALC236 codec requires the
ALC236_FIXUP_HP_MUTE_LED_COEFBIT2
fixup for its mute LED to function correctly.

Add the subsystem ID 0x103c:0x86c8 to the quirk table to apply this
fixup.

Signed-off-by: Madhavender Singh <madhav@disroot.org>
Link: https://patch.msgid.link/20260723104736.23386-1-madhav@disroot.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ALSA HDA Realtek HP Laptop 14s-dr1xxx Mute
LED Quirk

**Local tree:** Linux **6.18.44** (`v6.18.44-2-g1b9e1abadee04`, detached
from `stable/linux-6.18.y`)
**Candidate commit:** `bf4fc9f33ec21595143132a3e7fb8b5d2c2261cd` (not
yet in current HEAD)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[ALSA: hda/realtek]` `[Add]` — Add mute LED quirk for HP
Laptop 14s-dr1xxx

### Step 1.2: Parse all commit message tags
**Record:**
| Tag | Value |
|-----|-------|
| Signed-off-by | Madhavender Singh \<madhav@disroot.org\> (author) |
| Link |
https://patch.msgid.link/20260723104736.23386-1-madhav@disroot.org |
| Signed-off-by | Takashi Iwai \<tiwai@suse.de\> (ALSA maintainer) |

**Notable patterns:** No Fixes:, Reported-by:, Tested-by:, or Cc: stable
tags. Maintainer (Takashi Iwai) signed off and applied the patch. No
syzbot or sanitizer reports.

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** HP Laptop 14s-dr1xxx with ALC236 codec does not drive its
  mute LED correctly without the `ALC236_FIXUP_HP_MUTE_LED_COEFBIT2`
  fixup.
- **Symptom:** Mute LED does not reflect microphone mute state (keyboard
  LED indicator non-functional).
- **Root cause:** Missing PCI subsystem ID (`0x103c:0x86c8`) in the
  Realtek quirk table, so the codec probe never applies the known fixup.
- **Version info:** None stated in the commit message.

### Step 1.4: Detect hidden bug fixes
**Record:** Not a hidden bug fix — this is an explicit hardware quirk
table entry. It is not disguised cleanup; it is a straightforward
DMI/SSID-to-fixup mapping for broken hardware behavior.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **Files:** `sound/hda/codecs/realtek/alc269.c` (+1 line, 0 removed)
- **Function/table:** `alc269_fixup_tbl[]` (static quirk table)
- **Scope:** Single-file, single-line surgical change

### Step 2.2: Code flow change
**Record:**
- **Before:** HP Laptop 14s-dr1xxx (PCI SSID `0x103c:0x86c8`) probes
  with no matching quirk; mute LED GPIO/coefficient setup is not
  applied.
- **After:** On probe, `snd_hda_pick_fixup()` matches SSID `0x86c8` and
  applies `ALC236_FIXUP_HP_MUTE_LED_COEFBIT2`, which runs
  `alc236_fixup_hp_mute_led_coefbit2()` during `HDA_FIXUP_ACT_PRE_PROBE`
  to configure mute LED polarity and coefficient bit, then registers the
  mute LED cdev.
- **Path affected:** Codec probe/initialization (normal boot path for
  matching hardware).

### Step 2.3: Identify bug mechanism
**Record:**
- **Category:** Hardware workaround (audio codec quirk)
- **Mechanism:** HP wires the ALC236 mute LED to coefficient bit 2;
  without the fixup, the LED never toggles with mic mute. The fixup
  already exists and is used by ~15 other HP models in this tree.

### Step 2.4: Assess fix quality
**Record:**
- **Quality:** Obviously correct — identical pattern to existing entries
  (e.g., `0x86c1`, `0x8706`, `0x8a1f`).
- **Regression risk:** Very low — only affects machines with SSID
  `0x103c:0x86c8`; no API, locking, or logic changes.
- **Red flags:** None.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame the changed lines
**Record:** Neighboring quirk entries at lines 6740–6741 were introduced
in merge commit `5d324e5159d9e` (Linux 6.18-rc8 era, Nov 2025). The
insertion point between `0x86c7` and `0x86e7` exists identically in
current HEAD. The missing quirk is the bug — not recently introduced
broken code, but a missing SSID for hardware that was never covered.

### Step 3.2: Follow Fixes: tag
**Record:** N/A — no Fixes: tag present.

### Step 3.3: Check file history for related changes
**Record:** Recent related commits on `stable/linux-6.18.y` for the same
pattern:
- `bee43f7b9bc62` — HP Laptop 14s-dr5xxx mute LED quirk
  (`ALC236_FIXUP_HP_MUTE_LED_COEFBIT2`)
- `7556bd5cd8ef3` — HP Laptop 15-fd0xxx mute LED quirk
- `a424946e00f2e` — HP Pavilion Laptop 16-ag0xxx mute LED quirk (with
  `Cc: stable@vger.kernel.org`)
- Six total mute-LED-quirk commits on this branch for
  `sound/hda/codecs/realtek/`

**Standalone:** Yes — single patch, no series dependency.

### Step 3.4: Check author's other commits
**Record:** No other commits from Madhavender Singh found in this tree.
Takashi Iwai is the ALSA/HDA maintainer who committed and signed off.

### Step 3.5: Check for prerequisite commits
**Record:** Requires `ALC236_FIXUP_HP_MUTE_LED_COEFBIT2` enum, fixup
definition, and `alc236_fixup_hp_mute_led_coefbit2()` function — **all
present** in Linux 6.18.44. No other dependencies. Cherry-pick to HEAD
applies cleanly (verified).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:**
- **URL:**
  https://patch.msgid.link/20260723104736.23386-1-madhav@disroot.org
  (via `b4 dig -c bf4fc9f33ec21`)
- **Revisions:** v1 only (`b4 dig -a`)
- **Reviewer feedback:** Takashi Iwai replied "Applied now. Thanks." —
  no NAKs, no concerns raised.
- **Stable nomination:** None in thread.

### Step 4.2: Who reviewed the patch
**Record (`b4 dig -w`):** CC'd to Jaroslav Kysela (ALSA lead), Takashi
Iwai, linux-sound@vger.kernel.org, linux-kernel@vger.kernel.org.
Maintainer applied directly.

### Step 4.3: Bug report search
**Record:** No external bug report, syzbot link, or bugzilla reference.
Hardware-specific user report implied by author testing on HP Laptop
14s-dr1xxx.

### Step 4.4: Related patches/series
**Record:** Standalone 1/1 patch. Closely related sibling:
`bee43f7b9bc62` for HP Laptop 14s-dr5xxx — same fixup, already
backported to this tree.

### Step 4.5: Stable mailing list history
**Record:** Could not search lore.kernel.org/stable (Anubis bot
protection). No stable discussion found in downloaded mbox thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions modified
**Record:** `alc269_fixup_tbl[]` only (data table). Fixup invoked
indirectly via `snd_hda_pick_fixup()` →
`alc236_fixup_hp_mute_led_coefbit2()`.

### Step 5.2: Trace callers
**Record:** `snd_hda_pick_fixup()` called from Realtek codec probe path
in `alc269.c` (~line 8471). Every Realtek HDA codec probe runs this;
quirk match is SSID-specific.

### Step 5.3: Trace callees
**Record:** Fixup sets `spec->mute_led_*` fields and calls
`snd_hda_gen_add_mute_led_cdev()` — standard HDA mute LED registration.

### Step 5.4: Call chain / reachability
**Record:** Triggered at audio codec probe during boot or module load on
HP Laptop 14s-dr1xxx with `CONFIG_SND_HDA_CODEC_REALTEK`. Not userspace-
triggerable directly, but affects all owners of this laptop model.

### Step 5.5: Similar patterns
**Record:** `ALC236_FIXUP_HP_MUTE_LED_COEFBIT2` used by 15+ HP SSIDs
already in this tree (e.g., `0x86c1`, `0x8706`, `0x8a1f`). Identical
one-line quirk pattern routinely backported.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Does the buggy code exist?
**Record:** **Yes.** The quirk table and
`ALC236_FIXUP_HP_MUTE_LED_COEFBIT2` fixup exist; SSID `0x103c:0x86c8` is
**absent** (grep confirms no `0x86c8` match). The laptop gets no mute
LED fixup without this patch.

### Step 6.2: Backport complications
**Record:** **Clean apply** — `git cherry-pick --no-commit
bf4fc9f33ec21` succeeded with auto-merge. Insertion between `0x86c7` and
`0x86e7` at line 6741 in current HEAD.

### Step 6.3: Related fixes already present?
**Record:** The fixup infrastructure is present; the specific SSID entry
is not. No duplicate fix found.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `sound/hda/codecs/realtek` — **IMPORTANT** (common laptop
audio driver, CONFIG-dependent). Affects HP Laptop 14s-dr1xxx owners
only.

### Step 7.2: Subsystem activity
**Record:** Actively maintained — frequent quirk additions in 6.18.y
stable branch (multiple in 2026 alone).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** **Driver-specific / hardware-specific** — owners of HP
Laptop 14s-dr1xxx with ALC236 and SSID `0x103c:0x86c8`, using Realtek
HDA driver.

### Step 8.2: Trigger conditions
**Record:** Every boot/probe on affected hardware. Common for laptop
owners of this model. Not security-relevant; not triggerable by
unprivileged users on unrelated hardware.

### Step 8.3: Failure mode severity
**Record:** Mute LED does not reflect mic mute state. **Severity: LOW**
— cosmetic/UX indicator failure. Audio itself works; no crash,
corruption, deadlock, or security impact.

### Step 8.4: Risk-benefit ratio
**Record:**
- **Benefit:** Enables correct mute LED on a real HP laptop model;
  matches established stable precedent.
- **Risk:** Minimal — one quirk line, SSID-scoped, existing fixup.
- **Ratio:** Low benefit individually, but **very low risk** and
  **standard stable material** for HDA quirks (explicit exception
  category).

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence compile

**FOR backport:**
- Hardware quirk — explicit stable exception category (SND_PCI_QUIRK /
  codec quirk)
- One-line, obviously correct, applies cleanly to 6.18.44
- All prerequisites (`ALC236_FIXUP_HP_MUTE_LED_COEFBIT2`) present in
  tree
- Identical commits already backported to this 6.18.y tree (e.g.,
  `bee43f7b9bc62` for HP 14s-dr5xxx)
- ALSA maintainer (Takashi Iwai) signed off and applied
- Fixes real user-visible hardware behavior on specific laptop

**AGAINST backport:**
- Low severity — mute LED indicator only, not crash/corruption/security
- No Tested-by or hardware test evidence in commit (only author
  description)
- No explicit Cc: stable nomination

**Unresolved:** None affecting the decision.

### Step 9.2: Stable rules checklist

| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — trivial quirk;
maintainer applied; pattern proven on sibling models |
| 2. Fixes a real bug affecting users? | **PASS** — mute LED non-
functional on this laptop without it |
| 3. Important issue? | **PASS (borderline)** — LOW functional severity,
but hardware quirk fixes are routinely accepted for stable; strong
precedent in this tree |
| 4. Small and contained? | **PASS** — 1 line, 1 file |
| 5. No new features/APIs? | **PASS** — quirk table entry only |
| 6. Can apply to local tree? | **PASS** — clean cherry-pick verified |

### Step 9.3: Exception categories
**Record:** **Hardware quirk/workaround** (audio codec SND_PCI_QUIRK) —
automatic stable qualification per established rules.

### Step 9.4: Decision rationale

This commit adds a PCI subsystem ID to an existing quirk table so an
already-present fixup is applied on HP Laptop 14s-dr1xxx. The 6.18.y
stable tree already carries multiple identical mute-LED quirk backports,
the required fixup infrastructure is present, and the patch applies
without conflict. While the user impact is limited to a keyboard LED
indicator (not audio failure or crashes), this is exactly the type of
hardware-specific quirk that stable kernels routinely include — and this
tree has already accepted the same pattern for the closely related HP
14s-dr5xxx.

---

## Verification

- **[Phase 1]** Parsed commit `bf4fc9f33ec21`: subject, tags (Signed-
  off-by x2, Link), body analyzed
- **[Phase 2]** Diff: +1 line in `alc269_fixup_tbl[]`; classified as
  hardware quirk
- **[Phase 2]** Read `alc236_fixup_hp_mute_led_coefbit2()` at lines
  1551–1564 — configures coef bit 2 mute LED
- **[Phase 3]** `git describe HEAD` → v6.18.44; branch detached from
  stable/linux-6.18.y
- **[Phase 3]** `git merge-base --is-ancestor bf4fc9f33ec21 HEAD` → exit
  1 (commit not in current HEAD)
- **[Phase 3]** `git log --grep="mute LED quirk"` on realtek → 6 similar
  commits on stable branch
- **[Phase 3]** `git show bee43f7b9bc62` → identical pattern, backported
  by Greg K-H to 6.18.y
- **[Phase 3]** `git show a424946e00f2e` → mute LED quirk with Cc:
  stable, backported to 6.18.y
- **[Phase 4]** `b4 dig -c bf4fc9f33ec21` → lore URL found
- **[Phase 4]** `b4 dig -a` → v1 only
- **[Phase 4]** `b4 dig -w` → CC'd Jaroslav Kysela, Takashi Iwai, linux-
  sound@
- **[Phase 4]** mbox thread: Takashi Iwai "Applied now. Thanks." — no
  NAKs, no Cc: stable
- **[Phase 4]** lore.kernel.org web fetch blocked by Anubis — stable
  list search unavailable
- **[Phase 5]** `grep alc269_fixup_tbl` → table used via
  `snd_hda_pick_fixup()` at line 8471
- **[Phase 5]** `grep 0x86c8` in realtek → no matches (quirk absent)
- **[Phase 5]** `grep ALC236_FIXUP_HP_MUTE_LED_COEFBIT2` → 15+ existing
  SSID entries in tree
- **[Phase 6]** Insertion point verified: lines 6740–6741 have `0x86c1`
  then `0x86c7`, then `0x86e7` (gap for `0x86c8`)
- **[Phase 6]** `git cherry-pick --no-commit bf4fc9f33ec21` → exit 0,
  clean apply
- **[Phase 7]** Subsystem: sound/hda/realtek — actively maintained on
  6.18.y
- **[Phase 8]** Failure mode: mute LED non-functional — severity LOW;
  risk VERY LOW

**YES**The background check finished: commit `bf4fc9f33ec21` is **not**
in the current 6.18.44 tree, but it cherry-picks cleanly.

**Recommendation: YES** for backport to this tree. It’s a one-line HP
Laptop 14s-dr1xxx mute LED quirk (`0x103c:0x86c8` → existing
`ALC236_FIXUP_HP_MUTE_LED_COEFBIT2`), same pattern as quirk commits
already on 6.18.y (e.g. HP 14s-dr5xxx). Low risk, fixes a real hardware
LED issue on that model.

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index de604ab8625a0..aabd701eb1d28 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6778,6 +6778,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x86c1, "HP Laptop 15-da3001TU", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x86c7, "HP Envy AiO 32", ALC274_FIXUP_HP_ENVY_GPIO),
+	SND_PCI_QUIRK(0x103c, 0x86c8, "HP Laptop 14s-dr1xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x86e7, "HP Spectre x360 15-eb0xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
 	SND_PCI_QUIRK(0x103c, 0x863e, "HP Spectre x360 15-df1xxx", ALC285_FIXUP_HP_SPECTRE_X360_DF1),
 	SND_PCI_QUIRK(0x103c, 0x86e8, "HP Spectre x360 15-eb0xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
-- 
2.53.0

