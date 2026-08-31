Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF1C592D2A;
	Mon, 31 Aug 2026 13:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184265; cv=none; b=o0Tq3t/l2gT9kv4tRsv9arU7H/5zlr2arL8HOHKQRvN6W80DSDGXMaAAZP4n31RTRtO3vYngXxuTkBJZwxjLSCTeEFJu7XJnkrXFUXkvZJidPnLlYdE0u82BaXRK/AxWErXRKLUNPWQpqvUZH2GkA3h4vExKJgMHWy3Js+e0tlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184265; c=relaxed/simple;
	bh=yxqkIkNzBeXbzEpMTSYg/M2+18HCXWAGMciGKgJmASk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a2x7mkPwyXM+ZsUj/3lDRH1QKxZKmwhv9VIxSaRb5hvixpzkg54rk5hzHvj7oAbA2nWqYI47CqDoPDV65MIQokmdehU1Aoszl/CGAgggB1cxYBqnubIUIej2l2Cv4GzkXLKdr/WFipIwGjNCwKOi2YlFt85kGpKmhhLx3JmQU6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EJuHqBHC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EJuHqBHC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D971F00A3E;
	Mon, 31 Aug 2026 13:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184261;
	bh=61M7A9M45q/4EFC9xsc0Tf/RGm1cpKzoAjzhET2BHsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EJuHqBHCYBejhqSe8q8BEzAXg2s1j7Bec5SWD/avF2Zfv9VzTpxy14/HI6MC6/+yA
	 OQV3KN7zb8eYT1eOAlyUzC4PD/Vn4G86uAcw9xeLAfuPVSwGjE2+uijz4K53e4H4re
	 IAGrbzgBr2Q8DPnaj1IbkABv7kRYfGPvuU+uM+aYWGPK/2E+F6SQAwd22z2aZUZ5i8
	 ED799a9frnk/WM0BhXVaBt4Nvvuj4NaHRDlpf4OPuXW7iL8eTt4z3cInELnuSstxOg
	 /WbMCtYCXvaQA4s57NDHI1FZqMTFRdV4M091SXCByn87BEjkY21fnBNGZ7W50VWeuL
	 o8k2j64Yzamzw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shubham Nayak <shubhamnayak392reborn@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ALSA: hda/realtek: Add quirk for HP Victus 16-e0xxx (88EE) to enable mute LED
Date: Mon, 31 Aug 2026 09:30:16 -0400
Message-ID: <20260831133314.4125787-588-sashal@kernel.org>
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

From: Shubham Nayak <shubhamnayak392reborn@gmail.com>

[ Upstream commit 6c18817c01f6f76d9e2739903abde4d69397f2c6 ]

The mute LED on the HP Victus 16-e0xxx (board ID 88EE, ALC245 codec)
does not function by default. Add the ALC245_FIXUP_HP_MUTE_LED_COEFBIT
quirk to enable it. Tested on my HP Victus 16-e0xxx with kernel 7.1.2.

Signed-off-by: Shubham Nayak <shubhamnayak392reborn@gmail.com>
Link: https://patch.msgid.link/20260629-hp-victus-16-mute-led-v1-1-ab0f4a8a533b@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ALSA hda/realtek HP Victus 16-e0xxx (88EE)
mute LED quirk

**Local tree:** Linux **6.18.44** (`v6.18.44-1-g2736c32da98b9`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[ALSA: hda/realtek]` `[Add]` — Add quirk for HP Victus
16-e0xxx (88EE) to enable mute LED

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Shubham Nayak (author), Takashi Iwai (ALSA
  maintainer)
- **Link:** https://patch.msgid.link/20260629-hp-victus-16-mute-
  led-v1-1-ab0f4a8a533b@gmail.com
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Cc:
  stable@vger.kernel.org

Notable: Maintainer (Takashi Iwai) Signed-off-by is a strong quality
signal. Author reports hardware testing on kernel 7.1.2.

### Step 1.3: Body analysis
**Record:**
- **Bug:** Mute LED on HP Victus 16-e0xxx with board ID 88EE and ALC245
  codec does not function by default.
- **Symptom:** Keyboard mute LED does not toggle with microphone mute
  state.
- **Root cause:** Missing PCI subsystem ID quirk entry; hardware needs
  `ALC245_FIXUP_HP_MUTE_LED_COEFBIT` to configure coefficient-bit-based
  mute LED control.
- **Version info:** Tested on kernel 7.1.2; no crash or corruption
  described.

### Step 1.4: Hidden bug fix?
**Record:** Not a hidden crash/leak fix. This is an explicit hardware
quirk addition for a non-functional mute LED — a well-known Realtek HDA
pattern in this driver.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `sound/hda/codecs/realtek/alc269.c` (+1 line)
- **Change:** One `SND_PCI_QUIRK` table entry
- **Scope:** Single-file, surgical hardware quirk addition

### Step 2.2: Code flow
**Record:**
- **Before:** HP Victus 16-e0xxx with SSID `0x103c:0x88ee` matches no
  quirk; mute LED coefficients are never configured.
- **After:** Matching hardware gets `ALC245_FIXUP_HP_MUTE_LED_COEFBIT`,
  which runs `alc245_fixup_hp_mute_led_coefbit()` at probe time to set
  coefficient index/mask/on/off values and register the mute LED cdev.
- **Path:** Codec probe → `snd_hda_pick_fixup()` → quirk table lookup →
  fixup applied at `HDA_FIXUP_ACT_PRE_PROBE`.

### Step 2.3: Bug mechanism
**Record:** **[h] Hardware workaround** — Missing PCI SSID-to-fixup
mapping for a variant of an already-quirked laptop family. The sibling
entry `0x88eb` uses `ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT` (different
coefficient bits); `0x88ee` needs the older
`ALC245_FIXUP_HP_MUTE_LED_COEFBIT` variant.

### Step 2.4: Fix quality
**Record:**
- Obviously correct: one-line quirk using an existing, well-tested fixup
  already applied to many other HP Victus models in this tree.
- Minimal scope; no logic changes.
- Regression risk: negligible — only affects systems with exact PCI SSID
  `0x103c:0x88ee`. Wrong fixup on wrong hardware would only affect LED
  behavior, not audio playback.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- Insertion point is between `0x88eb` (added by `9745c2561e55f`, Jan
  2026) and `0x8902` (present since Realtek driver split
  `aeeb85f26c3bbe`, Jul 2025).
- `ALC245_FIXUP_HP_MUTE_LED_COEFBIT` and
  `alc245_fixup_hp_mute_led_coefbit()` introduced in `aeeb85f26c3bbe`
  (Jul 2025, driver split from monolithic `patch_realtek.c`).

### Step 3.2: Fixes: tag
**Record:** Not applicable — no Fixes: tag present.

### Step 3.3: Related file history
**Record:**
- `9745c2561e55f` — added `0x88eb` quirk for same laptop model with
  `ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT` (already in this tree).
- Multiple similar mute LED quirk commits in 6.18.y: `89ed38540e6be`,
  `7556bd5cd8ef3`, `a424946e00f2e`, etc.
- Standalone one-line patch; no series dependency.

### Step 3.4: Author context
**Record:** Shubham Nayak is a hardware reporter/contributor. Takashi
Iwai (ALSA/HDA maintainer) accepted the patch. Pattern consistent with
community-submitted HP quirk reports.

### Step 3.5: Dependencies
**Record:** No dependencies. Requires only
`ALC245_FIXUP_HP_MUTE_LED_COEFBIT` fixup enum, its fixup function, and
`alc269_fixup_tbl[]` — all verified present in 6.18.44. Applies
standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** Lore/patch.msgid.link fetch blocked by Anubis bot
protection. `b4 dig -c` could not be run (commit hash not in this tree).
Could not read review thread directly.

### Step 4.2: Reviewers
**Record:** UNVERIFIED via b4 dig -w. Takashi Iwai maintainer SOB
confirms acceptance.

### Step 4.3: Bug report
**Record:** Author self-reported on own hardware. No syzbot, bugzilla,
or multi-user reports. Severity: cosmetic/UX (mute LED non-functional).

### Step 4.4: Related patches
**Record:** Directly related to `9745c2561e55f` (0x88eb, same model,
different motherboard, different fixup variant). This patch completes
coverage for another MB variant.

### Step 4.5: Stable list
**Record:** UNVERIFIED — lore.kernel.org inaccessible. However,
`9745c2561e55f` (related Victus 16-e0xxx quirk) is already in this
6.18.y tree, establishing precedent.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `alc269_fixup_tbl[]` (modified),
`alc245_fixup_hp_mute_led_coefbit()` (existing, invoked via fixup),
`snd_hda_pick_fixup()` (caller at probe).

### Step 5.2: Callers
**Record:** `snd_hda_pick_fixup()` called from Realtek codec probe path
in `alc269.c` (~line 8471) during HDA codec initialization at
boot/module load. Every Realtek HDA codec goes through this, but the
quirk only activates on SSID match.

### Step 5.3: Callees
**Record:** Fixup sets `spec->mute_led_coef` fields and calls
`snd_hda_gen_add_mute_led_cdev()` to wire LED control to mute state.

### Step 5.4: Reachability
**Record:** Triggered automatically at codec probe on matching HP Victus
16-e0xxx (MB 88EE) hardware. Not userspace-triggerable beyond owning the
hardware. Common laptop audio path.

### Step 5.5: Similar patterns
**Record:** At least 12 other HP Victus models in this tree already use
`ALC245_FIXUP_HP_MUTE_LED_COEFBIT` (e.g., `0x8a25`, `0x8a26`, `0x8c99`,
`0x8dcd`). Same pattern, different SSID.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy code exists?
**Record:** **YES.** `0x88eb` quirk exists at line 6809, but `0x88ee` is
**absent** — confirmed by grep. Users with MB 88EE get no mute LED
quirk. `ALC245_FIXUP_HP_MUTE_LED_COEFBIT` infrastructure has been
present since Jul 2025.

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** Single-line insertion after
`0x88eb` entry. No refactoring conflicts in recent `alc269.c` history.

### Step 6.3: Related fixes already present?
**Record:** `0x88eb` quirk (`9745c2561e55f`) already in tree. No
duplicate `0x88ee` entry. This is the missing complementary quirk for a
different motherboard variant.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `sound/hda/realtek` — IMPORTANT (audio driver, affects
laptop users with this specific HP hardware). Not CORE, but widely
deployed.

### Step 7.2: Subsystem activity
**Record:** Actively maintained — frequent HP mute LED quirk additions
in 6.18.y (10+ in recent history). Standard maintenance pattern for
Realtek HDA.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** HP Victus 16-e0xxx laptops with PCI SSID `0x103c:0x88ee` and
ALC245 codec. Driver-specific, hardware-specific population.

### Step 8.2: Trigger conditions
**Record:** Every boot/probe on matching hardware. Automatic, not
privilege-dependent. Very likely for affected owners (100% on matching
hardware).

### Step 8.3: Failure mode severity
**Record:** Mute LED does not reflect microphone mute state. Audio
itself works; only the LED indicator is broken. **Severity: LOW**
(cosmetic/UX). No crash, corruption, security, or deadlock.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** LOW-MEDIUM — restores expected laptop mute LED behavior
  for affected HP Victus owners.
- **Risk:** VERY LOW — one-line SSID-specific quirk using existing
  fixup; cannot affect other hardware.
- **Ratio:** Favorable. Matches established stable practice for HP
  Realtek mute LED quirks.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Hardware quirk exception category (audio codec quirk for broken LED
  behavior)
- One-line, surgical, uses existing fixup — zero new code paths
- Hardware-tested by reporter; maintainer (Iwai) Signed-off-by
- All prerequisites present in 6.18.44
- Direct precedent: related `0x88eb` quirk already in this stable tree
- Many identical-pattern HP Victus mute LED quirks already in 6.18.y
- Clean apply expected

**AGAINST backport:**
- Not a crash, security, corruption, or deadlock fix
- Low severity (cosmetic mute LED only)
- Single reporter, no syzbot/fuzzer signal
- Mailing list discussion not verified

**UNRESOLVED:**
- Full lore review thread inaccessible
- No explicit stable nomination found in review

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — one-line quirk, hardware-
   tested, maintainer-approved
2. Fixes real bug affecting users? **PASS** — mute LED non-functional on
   real hardware
3. Important issue? **PASS (via quirk exception)** — not crash-level,
   but hardware quirk fixes for broken laptop features are standard
   stable material in this subsystem
4. Small and contained? **PASS** — 1 line
5. No new features/APIs? **PASS** — existing fixup enum/function only
6. Can apply to local tree? **PASS** — all infrastructure present, clean
   insertion point verified

### Step 9.3: Exception category
**Record:** **Hardware quirk / audio codec quirk** — adding PCI SSID
entry to enable mute LED on specific HP laptop motherboard variant.

### Step 9.4: Decision rationale

This commit adds a single `SND_PCI_QUIRK` entry for HP Victus 16-e0xxx
motherboard 88EE, mapping it to the already-present
`ALC245_FIXUP_HP_MUTE_LED_COEFBIT` fixup. The sibling variant `0x88eb`
is already quirked in 6.18.44 with a different fixup (`V2_COEFBIT`),
confirming this is a multi-motherboard laptop family needing per-SSID
tuning.

While mute LED failure is low severity (no audio breakage, no crash),
the Linux stable trees routinely accept these HP Realtek HDA quirk
additions. The fix is trivial, hardware-specific, uses no new code, and
carries essentially zero regression risk. It directly benefits 6.18.y
users with this laptop who currently have a non-functional mute LED.

---

## Verification

- **[Phase 1]** Parsed commit message: subject, SOB tags (Nayak, Iwai),
  Link tag; no Fixes/Reported-by/Cc:stable
- **[Phase 2]** Diff analysis: +1 line `SND_PCI_QUIRK(0x103c, 0x88ee,
  ...)` in `alc269_fixup_tbl[]`
- **[Phase 2]** Read `alc245_fixup_hp_mute_led_coefbit()` at lines
  1566–1580: configures coef 0x0b bits for mute LED
- **[Phase 3]** `git describe HEAD`: v6.18.44-1-g2736c32da98b9; `make
  kernelversion`: 6.18.44
- **[Phase 3]** `git blame -L 6807,6812`: 0x88eb from `9745c2561e55f`,
  surrounding entries from Jul 2025 split
- **[Phase 3]** `git log -S ALC245_FIXUP_HP_MUTE_LED_COEFBIT`: fixup
  present since `aeeb85f26c3bbe` (Jul 2025)
- **[Phase 3]** `git log -S 0x88ee`: no results — entry not yet in tree
- **[Phase 3]** `git show 9745c2561e55f`: related 0x88eb quirk already
  in 6.18.y
- **[Phase 4]** WebFetch lore/patch.msgid.link: BLOCKED (Anubis bot
  protection)
- **[Phase 4]** `b4 dig`: could not match commit (not in tree); URL form
  not accepted
- **[Phase 5]** `grep alc269_fixup_tbl`: table at line 6510, used at
  line 8471 via `snd_hda_pick_fixup()`
- **[Phase 5]** Grep: 12+ existing HP Victus entries using
  `ALC245_FIXUP_HP_MUTE_LED_COEFBIT`
- **[Phase 6]** Grep `0x88ee`: not present; `0x88eb` present at line
  6809
- **[Phase 6]** Read lines 6807–6812: confirmed insertion point and
  neighbor quirks
- **[Phase 6]** Verified `ALC245_FIXUP_HP_MUTE_LED_COEFBIT` enum, fixup
  struct, and function all exist
- **[Phase 7]** `git log --oneline -20 --grep="mute LED"`: 10+ similar
  quirk commits in tree history
- **[Phase 8]** Failure mode assessed as LOW severity (LED only, no
  audio impact)
- **UNVERIFIED:** Full mailing list review thread and any explicit Cc:
  stable nomination in review

**YES**The analysis is complete for the HP Victus 16-e0xxx (88EE) mute
LED quirk on **Linux 6.18.44**.

**Verdict: YES** — backport to this stable tree.

It’s a one-line hardware quirk that maps PCI SSID `0x103c:0x88ee` to the
existing `ALC245_FIXUP_HP_MUTE_LED_COEFBIT` fixup. The related `0x88eb`
variant is already quirked in this tree; this adds the missing
motherboard variant. Risk is very low, and it matches the usual pattern
for HP Realtek mute LED fixes in stable.

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index a06acaf9ba6a0..36d5dfa9e1db8 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6807,6 +6807,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x88d1, "HP Pavilion 15-eh1xxx (mainboard 88D1)", ALC245_FIXUP_HP_MUTE_LED_V1_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x88dd, "HP Pavilion 15z-ec200", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x88eb, "HP Victus 16-e0xxx", ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT),
+	SND_PCI_QUIRK(0x103c, 0x88ee, "HP Victus 16-e0xxx (MB 88EE)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8902, "HP OMEN 16", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x890e, "HP 255 G8 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8919, "HP Pavilion Aero Laptop 13-be0xxx", ALC287_FIXUP_HP_GPIO_LED),
-- 
2.53.0

