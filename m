Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9BF577E3E;
	Mon, 31 Aug 2026 13:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184152; cv=none; b=kQnm0GVSJ9dPBrj4mBvyrAVg8lVb3nDv0B0vkNd6WN3wI4sV94MlCYQo7YHGVDKrytWe7qovl5+ogZ71eWHYZxUM1jIewrfcd3OnpQ/ciHq6drb/iH6hubCkglFMapM196PFLL4Ru6HCgR9psWCwdZ2hm8evwm2cvLwfOV21fr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184152; c=relaxed/simple;
	bh=Clif3bi8a2lRrhuJsOGOpsR6MekCuHfCt6K8xCxehDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BeLKATZsoP+h2/I3mhsCB3rGlVUsNGdDK8mJ1zRHGFg7TIxA4+y1Igk0P5R7UM2bpa2bhAh7ftFKtYm4w9YIWgREUpLqnfjCXNqmBEGeb7IEDJqvSkcpvkSm9WfkqrIKK8YClof579/jyGFUQUnmxxpuArTZevGTYSyG7uzG+I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wgt57QES; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wgt57QES"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D611F00A3F;
	Mon, 31 Aug 2026 13:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184150;
	bh=kwIr7DFE5DIUwoHkfFtN91T2UNmCduYY1HrF+s3/kVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wgt57QESucSMloknkYzfakH6NeKR9q9uoI0jloy1DNHKqnOr5s+hQwW05O4/yyCj+
	 GuBtdda5Go1jxBqjK8b2Mzw4tDEuvOaHdQhgf8hkmvvgtaxLl+eoxgODthe8/Hqw0q
	 mAwB4szGnf/AByGMVV4QMtA11/PBiaPxV6rgrhYsR/SyzRaIqsDgppI++RjCQynNDC
	 WqwAR0L9EaX947wEbALDZ5tytlXdjl9VkuKTf6Jrg0WlmyvPne3vxCUtbjH1ATfDxr
	 phQxR4RBqDeJ4fvSKD9peAHjChofvPlFL+9UJgcCSNG26jpYIhjcM2SZTJsvqD/gdI
	 RV3HPviFHy0Gw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Pragosa?= <pragosa512@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ALSA: hda/realtek: Add mute LED quirk for HP Victus 16-e0xxx (MB 88ED)
Date: Mon, 31 Aug 2026 09:29:09 -0400
Message-ID: <20260831133314.4125787-521-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: André Pragosa <pragosa512@gmail.com>

[ Upstream commit 630c45e92db44b738d1e9224c5f3c032c76a33ca ]

Add subsystem ID 103c:88ed to the existing HP Victus 16-e0xxx
mute LED quirk list.

The HP Victus 16-e0xxx with subsystem ID 103c:88ed uses the same
mute LED coefficient configuration as the already supported
103c:88eb variant.

The mute LED was verified by manually toggling coefficient index
0x0b (bit 3) using hda-verb. After adding the quirk, the LED is
registered as hda::mute and follows the audio mute state.

Signed-off-by: André Pragosa <pragosa512@gmail.com>
Link: https://patch.msgid.link/20260728221129.14680-2-pragosa512@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ALSA hda/realtek HP Victus 16-e0xxx (MB
88ED) mute LED quirk

**Local tree:** Linux **6.18.44** (`git describe HEAD` →
`v6.18.44-2-g1b9e1abadee04`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[ALSA: hda/realtek] [Add] mute LED quirk for HP Victus
16-e0xxx (MB 88ED)`

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** André Pragosa `<pragosa512@gmail.com>` (author)
- **Link:**
  `https://patch.msgid.link/20260728221129.14680-2-pragosa512@gmail.com`
- **Signed-off-by:** Takashi Iwai `<tiwai@suse.de>` (ALSA maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable@vger.kernel.org`
- Notable: maintainer sign-off from Takashi Iwai; no syzbot or user bug
  reports

### Step 1.3: Body analysis
**Record:**
- **Bug:** HP Victus 16-e0xxx with subsystem ID `103c:88ed` does not get
  the mute-LED quirk; the F-key mute LED does not track audio mute
  state.
- **Symptom:** Mute LED stays non-functional; audio mute itself is
  unaffected.
- **Root cause:** Missing `SND_PCI_QUIRK` table entry for this mainboard
  variant.
- **Fix approach:** Reuse `ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT` (same as
  `103c:88eb`).
- **Verification:** Author tested coefficient index `0x0b` bit 3 via
  `hda-verb`; after quirk, LED registers as `hda::mute` and follows mute
  state.
- **Version info:** None in message.

### Step 1.4: Hidden bug fix?
**Record:** Not a crash/leak/race fix. This is an explicit **hardware
quirk / device-ID extension** for mute-LED support on a specific laptop
SKU. Classified as hardware enablement, not disguised cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `sound/hda/codecs/realtek/alc269.c` only (+2 lines, minor
  formatting)
- **Functions modified:** None; only `alc269_fixup_tbl[]` quirk table
- **Scope:** Single-file, surgical quirk-table addition

### Step 2.2: Code flow change
**Record:**
- **Before:** `snd_hda_pick_fixup()` during codec probe finds no match
  for SSID `103c:88ed` → no mute-LED fixup applied.
- **After:** SSID `103c:88ed` maps to
  `ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT` →
  `alc245_fixup_hp_mute_led_v2_coefbit()` runs at
  `HDA_FIXUP_ACT_PRE_PROBE`, configures coef `0x0b` bit 3, registers
  `hda::mute` LED class device.
- **Path affected:** HDA codec probe for matching HP Victus hardware
  only.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Hardware workaround (audio codec quirk)
- **Mechanism:** Missing PCI subsystem ID in quirk table prevents
  existing, correct fixup from being selected.

### Step 2.4: Fix quality
**Record:**
- **Quality:** Obviously correct — identical fixup to already-supported
  `103c:88eb` sibling variant; manually verified.
- **Regression risk:** Very low — adds one table row, no logic changes.
- **Red flags:** None.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- Adjacent entry `0x88eb` introduced in commit `9745c2561e55f`
  (2026-01-13, Bharat Dev Burman): *"add HP Victus 16-e0xxx mute LED
  quirk"*
- That commit also introduced `ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT` and
  `alc245_fixup_hp_mute_led_v2_coefbit()`.
- `0x88ed` is absent from this tree (confirmed via grep).

### Step 3.2: Fixes: tag
**Record:** No `Fixes:` tag present; not applicable.

### Step 3.3: Related file history
**Record:**
- Multiple similar mute-LED quirk commits already in this 6.18.y tree,
  including:
  - `9745c2561e55f` — Victus 16-e0xxx (`0x88eb`) + V2 fixup
    (prerequisite)
  - `a424946e00f2e`, `7556bd5cd8ef3`, `8db3663d3c3e2`, `bee43f7b9bc62`,
    `3210077ed2648` — other HP mute-LED quirks
- Standalone one-liner; not part of a multi-patch series.

### Step 3.4: Author context
**Record:** André Pragosa has no prior commits in
`sound/hda/codecs/realtek/` in this tree. Takashi Iwai (maintainer)
signed off.

### Step 3.5: Dependencies
**Record:**
- **Requires:** `ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT` and
  `alc245_fixup_hp_mute_led_v2_coefbit()` — **both present** (from
  `9745c2561e55f`, confirmed ancestor of HEAD).
- **Standalone:** Yes; only adds a quirk-table entry.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c <commit>` not possible — commit hash not in local
tree. `b4 dig` with patch URL failed (wrong invocation).
Lore/patch.msgid.link blocked by bot protection (Anubis).
**UNVERIFIED:** full review thread content.

### Step 4.2: Reviewers
**Record:** **UNVERIFIED** via b4 `-w`. Commit message shows Takashi
Iwai maintainer sign-off.

### Step 4.3: Bug report
**Record:** No external bug report linked. Author self-reported hardware
issue and manual verification.

### Step 4.4: Related patches
**Record:** Part of ongoing HP Victus mute-LED quirk pattern; sibling
`0x88eb` fix already in this tree. Commit message references `0x88eb` as
the matching configuration.

### Step 4.5: Stable list history
**Record:** **UNVERIFIED** — lore.kernel.org inaccessible. Precedent in
this tree: similar mute-LED quirks already backported.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** No functions modified. Affected data: `alc269_fixup_tbl[]`.
Selected fixup: `alc245_fixup_hp_mute_led_v2_coefbit()`.

### Step 5.2: Callers
**Record:** `snd_hda_pick_fixup(codec, alc269_fixup_models,
alc269_fixup_tbl, alc269_fixups)` called from codec init at line 8471
during HDA probe. Standard path for every Realtek ALC269-family codec
load.

### Step 5.3: Callees
**Record:** Fixup calls `snd_hda_gen_add_mute_led_cdev(codec,
coef_mute_led_set)` which hooks LED brightness to codec coefficient
updates.

### Step 5.4: Reachability
**Record:** Triggered at boot/module load when HDA codec probes on
hardware with SSID `103c:88ed`. Not userspace-triggerable after probe;
affects only matching HP Victus 16-e0xxx machines.

### Step 5.5: Similar patterns
**Record:** Many adjacent `SND_PCI_QUIRK` entries for HP mute LEDs in
the same table, including `0x88eb` (same fixup) and `0x8a3d` (Victus 15,
same V2 fixup).

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** **Yes.** `0x88eb` is supported but `0x88ed` is missing
(`grep 0x88ed` → no matches). Affected hardware on 6.18.44 gets no mute-
LED fixup. Prerequisite V2 fixup infrastructure has been in tree since
`9745c2561e55f`.

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** Insert one `SND_PCI_QUIRK` line
after existing `0x88eb` entry at line 6809. Mainline diff references
`0x88ee` entry not yet in 6.18.44; no conflict — patch simply adds
`0x88ed` after `0x88eb`.

### Step 6.3: Related fixes already present?
**Record:** Prerequisite commit `9745c2561e55f` (88eb + V2 fixup) is in
tree. No duplicate `0x88ed` entry. No alternate fix found.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **sound/ALSA hda/realtek** — IMPORTANT (laptop audio/LED
UX), PERIPHERAL for users without this exact hardware.

### Step 7.2: Subsystem activity
**Record:** Active — frequent HP mute-LED quirk commits in recent
`alc269.c` history; this file is actively maintained for new laptop
SKUs.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Owners of HP Victus 16-e0xxx laptops with mainboard SSID
`103c:88ed` and Realtek ALC245 codec. Driver-specific, hardware-specific
population.

### Step 8.2: Trigger conditions
**Record:** Every boot/probe on matching hardware. Common for affected
owners; zero impact on all other systems. Unprivileged users cannot
trigger; not a security issue.

### Step 8.3: Failure mode severity
**Record:** Mute LED does not reflect audio mute state. Audio function
unaffected. **Severity: LOW** (UX/cosmetic indicator). Not crash,
corruption, deadlock, or security.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Enables expected F-key mute LED behavior on an additional
  Victus SKU; matches established stable practice for HP HDA quirks in
  this tree.
- **Risk:** Minimal — 2-line table addition, existing fixup, maintainer-
  reviewed.
- **Ratio:** High benefit for affected users, negligible risk for
  everyone else.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Hardware quirk / device-ID extension (explicit stable exception
  category)
- Trivial, surgical 2-line change
- Reuses proven fixup already in tree for sibling `0x88eb` variant
- Manually verified by author; Takashi Iwai sign-off
- Prerequisite infrastructure present (`9745c2561e55f` is ancestor of
  HEAD)
- Multiple analogous HP mute-LED quirk commits already backported to
  this 6.18.y tree
- Clean apply expected

**AGAINST backport:**
- Not a crash, security, corruption, or deadlock fix
- Does not meet strict "important issue" wording in stable rules if
  quirks exception is not applied
- No syzbot/user bugzilla report
- Lore review thread not accessible for independent verification

**UNRESOLVED:**
- Full mailing-list review discussion (lore blocked)
- Whether reviewers explicitly nominated for stable

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — same fixup as `0x88eb`, hda-
   verb verified, maintainer SOB
2. Fixes a real bug? **PASS** — mute LED non-functional on matching
   hardware
3. Important issue? **PASS (via quirk exception)** — LOW severity UX
   bug; qualifies under audio codec quirk / hardware workaround
   exception routinely accepted for stable
4. Small and contained? **PASS** — 2 lines, one table entry
5. No new features/APIs? **PASS** — quirk table extension only; no new
   fixup type or userspace API
6. Can apply to local tree? **PASS** — prerequisites present, clean
   insert after `0x88eb`

### Step 9.3: Exception category
**Record:** **Hardware quirk / device ID addition** — `SND_PCI_QUIRK`
entry for existing `ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT` fixup on HP
Victus 16-e0xxx (MB 88ED).

### Step 9.4: Decision rationale

For **Linux 6.18.44**, this commit should be backported. The missing
quirk leaves mute LED broken on a specific HP Victus SKU while audio
works; the fix is a two-line table entry reusing an already-present,
maintainer-accepted fixup (`9745c2561e55f`). This matches the
established pattern of HP mute-LED quirk backports already present in
this stable tree. Risk is negligible; benefit is real for affected
laptop owners.

---

## Verification

- **[Phase 1]** Parsed subject, tags, and body from user-provided commit
  message
- **[Phase 2]** Diff analysis: +2 lines to `alc269_fixup_tbl[]`, no
  function changes
- **[Phase 3]** `git describe HEAD` → v6.18.44; `make kernelversion`
  equivalent via Makefile → 6.18.44
- **[Phase 3]** `git log -S "0x88eb"` → prerequisite `9745c2561e55f`
- **[Phase 3]** `git log -S "ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT"` →
  introduced in `9745c2561e55f`, `2e8194b4fdee7`
- **[Phase 3]** `git merge-base --is-ancestor 9745c2561e55f HEAD` →
  prerequisite is in tree
- **[Phase 3]** `git blame -L 6809` → `0x88eb` line from `9745c2561e55f`
- **[Phase 3]** `grep 0x88ed` → not in tree (bug present)
- **[Phase 3]** `grep 0x88ee` → not in tree (mainline context differs;
  no apply conflict)
- **[Phase 4]** `b4 dig -c` → not run (commit not in tree)
- **[Phase 4]** `b4 dig <url>` → failed (incorrect usage)
- **[Phase 4]** WebFetch lore/patch.msgid.link → blocked by Anubis bot
  protection
- **[Phase 4]** curl lore → blocked by Anubis
- **[Phase 5]** Read `alc245_fixup_hp_mute_led_v2_coefbit()` at lines
  1598–1612
- **[Phase 5]** Read `snd_hda_pick_fixup()` call at line 8471
- **[Phase 5]** `grep alc269_fixup_tbl` → table at 6510, used at 8472
- **[Phase 6]** Confirmed `ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT` enum,
  fixup struct, and function all exist
- **[Phase 6]** Confirmed `0x88eb` at line 6809, `0x88ed` absent
- **[Phase 7]** `git log --grep="mute LED"` → multiple similar quirk
  commits in tree including `9745c2561e55f`, `a424946e00f2e`
- **[Phase 8]** Failure mode assessed as non-crash LED indicator issue,
  LOW severity
- **UNVERIFIED:** Mailing-list reviewer feedback and explicit stable
  nominations

**YES**

 sound/hda/codecs/realtek/alc269.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index a010c444b9f10..2a0a1891ac423 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6856,6 +6856,8 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x88d1, "HP Pavilion 15-eh1xxx (mainboard 88D1)", ALC245_FIXUP_HP_MUTE_LED_V1_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x88dd, "HP Pavilion 15z-ec200", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x88eb, "HP Victus 16-e0xxx", ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT),
+	SND_PCI_QUIRK(0x103c, 0x88ed, "HP Victus 16-e0xxx (MB 88ED)",
+		      ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x88ee, "HP Victus 16-e0xxx (MB 88EE)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8902, "HP OMEN 16", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x890e, "HP 255 G8 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
-- 
2.53.0

