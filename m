Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECADC469855;
	Mon, 31 Aug 2026 13:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183294; cv=none; b=XGKRgH6XFYYv/BTtMnl5ce0woYari3Xdt8Lev9ohZWRbRAdPF3kIGLmJJx/xBxRCw5l3EFwtRsJy8RbUs+bYDOIfuwZD+0Av3ui65dptQL9ouxcuGff7N9OXXHcG1jLiR8Do7gNFfYW/URapk+fwGncgIGKbWRTkWS6bCnnEL+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183294; c=relaxed/simple;
	bh=pY6oZyil6X72ogphhbf5fgHGa/BIOUFgikVKfvisMl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L9hKjSL+IYNrrcTkHrURkd+edkdhuDPvafOPFOxLgJx6s1ebCNrtKIhW7ukQdBrPJYJPUdiWx7SQYwwCQeG7xPRplHRU4HxEx2vcGPrM9xH2BhjN64nA0tLqQbIG3ATqa3ENHa+YnyXA2/6sB6/dKxq4bAdIW2HSsVk/tWzvxm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A//w0OUh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A//w0OUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0601F00A3F;
	Mon, 31 Aug 2026 13:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183291;
	bh=40BT4Xcte5wJP6zPSe0nFxczfcaDOItBpRR5JXW1bCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A//w0OUhcDXx3DsR3YNmkxS/LI6K1zulRgNey2INW0iFvGuJUHtT9I/DrTomi+8D/
	 IE3DRC6z5XBNir2AjAmCy7z3wY3Yke4L1YdlHIv492AfBRhVnKGFkc3qCs47+R/43s
	 vMexJMvEQOIdzRSMbv2NHd+RGUPLDmzmfj7ewUT+6Nh8FN1Xq8sTuCkKC38D7qdqua
	 p9pZHe/I3dHA5okD8cCSOHf0+KgO5JRVNs3cPBnB28nDqt9qE3PEntj460IquebHkp
	 ok0PDqTlG1nKfKGltoMQtpt4bqj3kczlXJvD/ORnMz0dM5hNeVaU6dPeH8PzZ4Af+H
	 vTruguEjt48hA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Furst Blumier <seal@furst.blue>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] ALSA: hda/realtek: Add quirk for HP 255 15.6 inch G9 Notebook PC
Date: Mon, 31 Aug 2026 09:21:29 -0400
Message-ID: <20260831133314.4125787-61-sashal@kernel.org>
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

From: Furst Blumier <seal@furst.blue>

[ Upstream commit 98e157916f83c26a41448267180944048d2f1460 ]

The HP 255 15.6 inch G9 Notebook PC (PCI SSID 103c:8a1b) uses the
ALC236 codec but lacks an entry in the quirk table, causing the kernel
to fall back to a null SSID match (103c:0000) and skip the necessary
fixup. Add a quirk entry using ALC236_FIXUP_HP_MUTE_LED_COEFBIT2,
matching the HP 255 G8 which uses the same codec and fixup. This fixes
the mute-button LED and fixes an issue with unplugging and replugging a
headset jack not being recognized as an audio sink.

Signed-off-by: Furst Blumier <seal@furst.blue>
Link: https://patch.msgid.link/20260609201706.502075-1-seal@furst.blue
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ALSA HDA Realtek HP 255 G9 Quirk

**Local tree:** Linux **6.18.44** (`git describe HEAD` → `v6.18.44`,
Makefile `VERSION/PATCHLEVEL/SUBLEVEL` = 6/18/44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[ALSA: hda/realtek]` `[Add]` — Add quirk for HP 255 15.6
inch G9 Notebook PC (PCI SSID quirk table entry).

### Step 1.2: Parse all commit message tags
**Record:**
- **Signed-off-by:** Furst Blumier `<seal@furst.blue>` (author)
- **Link:**
  https://patch.msgid.link/20260609201706.502075-1-seal@furst.blue
- **Signed-off-by:** Takashi Iwai `<tiwai@suse.de>` (ALSA/HDA
  maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable@vger.kernel.org`
- Notable: maintainer sign-off present; no syzbot/fuzzer report

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** HP 255 15.6 inch G9 (PCI SSID `103c:8a1b`) uses ALC236 codec
  but has no quirk entry.
- **Mechanism:** Kernel falls back to a generic/null SSID match
  (`103c:0000`) and skips the needed fixup.
- **Symptoms:** Broken mute-button LED; unplugging/replugging a headset
  jack is not recognized as an audio sink.
- **Fix approach:** Add quirk using `ALC236_FIXUP_HP_MUTE_LED_COEFBIT2`,
  same as HP 255 G8.
- **Version info:** None stated in commit message.

### Step 1.4: Detect hidden bug fixes
**Record:** Not disguised — this is an explicit hardware quirk fix. It
is not a crash/security fix, but it fixes real, user-visible audio
behavior on a specific laptop model.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **Files:** `sound/hda/codecs/realtek/alc269.c` (+1 line)
- **Functions modified:** None directly; change is in static
  `alc269_fixup_tbl[]`
- **Scope:** Single-file, single-line surgical quirk addition

### Step 2.2: Code flow change
**Record:**
- **Before:** `103c:8a1b` has no entry in `alc269_fixup_tbl[]`; probe
  falls through to a generic HP fixup (vendor table
  `ALC269_FIXUP_HP_MUTE_LED` at line 7652) or no specific ALC236
  coefbit2 fixup.
- **After:** Exact SSID match selects
  `ALC236_FIXUP_HP_MUTE_LED_COEFBIT2` during `snd_hda_pick_fixup()` in
  codec probe.
- **Path affected:** Codec initialization / probe path (boot and module
  load).

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Hardware workaround / audio codec quirk (HDA
  pin/LED/jack configuration).
- **Mechanism:** Missing PCI SSID → wrong fixup applied → incorrect
  mute-LED coefficient setup and headset jack behavior for ALC236 on
  this board.

### Step 2.4: Fix quality assessment
**Record:**
- **Quality:** High — one-line addition, reuses an existing fixup
  already applied to HP 255 G8 (`0x890e`) and HP 255 G10 (`0x8b2f`) in
  this tree.
- **Regression risk:** Very low — no logic changes, no new APIs, no
  structural changes.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame the changed lines
**Record:** Insertion point is between lines 6843–6844 (after `0x8a0f`,
before `0x8a1f`). Neighbor entries added in commits like `bee43f7b9bc62`
(HP 14s-dr5xxx, `0x8a1f`) and `aeeb85f26c3bb` (Realtek driver split,
July 2025). The *absence* of `0x8a1b` is the bug — not a recently
introduced regression in existing code.

### Step 3.2: Follow Fixes: tag
**Record:** N/A — no `Fixes:` tag in commit message.

### Step 3.3: Related file history
**Record:** This tree regularly backports similar HDA Realtek quirk
commits (e.g. `bee43f7b9bc62` HP 14s-dr5xxx mute LED quirk,
`302eb87651326` HP Dragonfly Folio G3). Standalone one-liner; not part
of a multi-patch series.

### Step 3.4: Author's other commits
**Record:** No prior commits from Furst Blumier in
`sound/hda/codecs/realtek/` in this tree. Patch carries Takashi Iwai
maintainer sign-off.

### Step 3.5: Prerequisites / dependencies
**Record:**
- `ALC236_FIXUP_HP_MUTE_LED_COEFBIT2` enum, fixup table entry, and
  `alc236_fixup_hp_mute_led_coefbit2()` all exist in this tree (lines
  3875, 5552–5554, 1551–1563).
- HP 255 G8 (`0x890e`, line 6811) and HP 255 G10 (`0x8b2f`, line 6874)
  already use the same fixup.
- **Can apply standalone:** Yes.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:** Could not retrieve — `b4 dig` requires a commit hash (not
provided); no matching mbox in workspace. `patch.msgid.link` and
`lore.kernel.org` blocked by Anubis bot protection.

### Step 4.2: Reviewers from b4 dig -w
**Record:** N/A — b4 dig not run (no commit hash available).

### Step 4.3: Bug report
**Record:** No external bug report linked beyond the patch submission
message-id. Author-reported hardware issue on HP 255 G9.

### Step 4.4: Related patches / series
**Record:** Same fixup pattern as HP 255 G8/G10 and multiple other HP
ALC236 laptops in `alc269_fixup_tbl[]`. Standalone patch.

### Step 4.5: Stable mailing list history
**Record:** UNVERIFIED — could not search lore stable list due to bot
protection.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** Indirectly affects `alc269_probe()` → `snd_hda_pick_fixup()`
→ `alc236_fixup_hp_mute_led_coefbit2()` via fixup table selection.

### Step 5.2: Callers
**Record:** `snd_hda_pick_fixup()` called from `alc269.c` probe at lines
8471–8486 during HDA codec initialization (device probe at boot/module
load). Common path for all Realtek HDA laptops using this driver.

### Step 5.3: Callees
**Record:** Selected fixup `alc236_fixup_hp_mute_led_coefbit2()`
configures mute-LED coefficient registers (`spec->mute_led_coef.idx =
0x07`, etc.) and registers mute-LED cdev via
`snd_hda_gen_add_mute_led_cdev()`.

### Step 5.4: Call chain / reachability
**Record:** Triggered automatically at audio codec probe on affected
hardware — no userspace syscall needed. Every boot on HP 255 G9 without
this quirk gets wrong fixup.

### Step 5.5: Similar patterns
**Record:** At least 15 other machines in this tree use
`ALC236_FIXUP_HP_MUTE_LED_COEFBIT2`, including HP 255 G8 (`0x890e`) and
HP 255 G10 (`0x8b2f`). Same-generation G9 (`0x8a1b`) is the obvious
missing sibling.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Does the buggy code exist?
**Record:** **Yes.** `0x8a1b` is absent from `alc269_fixup_tbl[]` in
v6.18.44. Confirmed by grep (no matches) and `git log -S "0x8a1b" --
sound/hda/` (empty). Adjacent entries `0x8a0f` and `0x8a1f` are present
at lines 6843–6844.

### Step 6.2: Backport complications
**Record:** **Clean apply expected** — single-line insertion in sorted
quirk table between existing HP entries. No structural divergence around
insertion point.

### Step 6.3: Related fixes already present?
**Record:** No prior fix for `103c:8a1b`. Related sibling quirks for HP
255 G8/G10 already present with same fixup type.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `sound/hda/codecs/realtek` — **IMPORTANT** (laptop audio;
affects users of specific HP hardware, not universal).

### Step 7.2: Subsystem activity
**Record:** Actively maintained in 6.18.y — numerous recent Realtek
quirk backports in `git log --oneline -20 -- sound/hda/codecs/realtek/`.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of **HP 255 15.6 inch G9 Notebook PC** (PCI SSID
`103c:8a1b`) with ALC236 codec and `CONFIG_SND_HDA_CODEC_REALTEK`.

### Step 8.2: Trigger conditions
**Record:** Every boot / audio driver probe on affected hardware. Not
timing-dependent; deterministic. Unprivileged users cannot trigger the
fix, but all users of this laptop are affected without it.

### Step 8.3: Failure mode severity
**Record:**
- Mute LED does not work correctly
- Headset jack replug not recognized as audio sink
- **Severity: MEDIUM** — functional audio regression, not kernel crash,
  data corruption, or security issue

### Step 8.4: Risk-benefit ratio
**Record:**
- **Benefit:** Restores correct audio jack detection and mute LED on a
  real laptop model; matches established pattern for G8/G10 in same
  product line.
- **Risk:** Minimal — one table entry, existing fixup, maintainer-
  reviewed.
- **Ratio:** Favorable for stable backport under the hardware-quirk
  exception.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence compile

**FOR backporting:**
- Fixes real hardware bug on HP 255 G9 (mute LED + headset jack)
- One-line, obviously correct quirk using proven existing fixup
- Same fixup as HP 255 G8 already in this tree
- ALC236 fixup infrastructure fully present in 6.18.44
- Takashi Iwai (maintainer) signed off
- Hardware quirk — explicit stable exception category
- This tree routinely takes similar HDA Realtek quirk patches
- Missing quirk confirmed in v6.18.44

**AGAINST backporting:**
- Not a crash, security, or data-corruption issue
- Affects only one specific laptop model
- No independent test report or syzbot validation

**UNRESOLVED:**
- Mailing list review thread content (blocked)
- Whether reviewers explicitly nominated for stable

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — mirrors HP 255 G8;
   maintainer SOB; standard quirk pattern.
2. Fixes a real bug affecting users? **PASS** — mute LED and headset
   jack on real hardware.
3. Important issue? **PASS (borderline)** — not crash/security, but real
   user-visible hardware malfunction; quirk exception applies.
4. Small and contained? **PASS** — 1 line, 1 file.
5. No new features or APIs? **PASS** — table entry only, reuses existing
   fixup.
6. Can apply to local tree? **PASS** — prerequisites present; clean
   insertion.

### Step 9.3: Exception category
**Record:** **Hardware quirk/workaround** — adding PCI SSID entry to
existing Realtek HDA driver quirk table. This is one of the explicitly
allowed stable exceptions.

### Step 9.4: Decision rationale

For Linux **6.18.44**, owners of the HP 255 15.6 inch G9 hit wrong HDA
fixup behavior because `103c:8a1b` is missing from the quirk table while
the needed `ALC236_FIXUP_HP_MUTE_LED_COEFBIT2` fixup and sibling entries
(HP 255 G8/G10) are already present. The patch is a minimal, maintainer-
approved hardware quirk of the kind routinely accepted into stable
trees. Severity is functional rather than catastrophic, but the stable-
kernel rules explicitly welcome such quirks, and the risk of regression
is negligible.

---

## Verification

- **[Phase 1]** Parsed subject, tags, and body from provided commit
  message.
- **[Phase 1]** Confirmed Takashi Iwai maintainer sign-off; no
  syzbot/Fixes: tags.
- **[Phase 2]** Diff: +1 line `SND_PCI_QUIRK(0x103c, 0x8a1b, ...)` in
  `alc269_fixup_tbl[]`.
- **[Phase 2]** Read `alc236_fixup_hp_mute_led_coefbit2()` at lines
  1551–1563.
- **[Phase 3]** `git blame -L 6840,6846`: neighbors from commits
  `302eb87651326`, `bee43f7b9bc62`, `aeeb85f26c3bb`.
- **[Phase 3]** `git log -S "ALC236_FIXUP_HP_MUTE_LED_COEFBIT2"`: fixup
  present since driver split and earlier quirk commits.
- **[Phase 3]** `git log -S "0x8a1b" -- sound/hda/`: empty — quirk never
  added to this tree.
- **[Phase 4]** UNVERIFIED: `b4 dig` not run (no commit hash provided).
- **[Phase 4]** UNVERIFIED: lore.kernel.org and patch.msgid.link blocked
  by Anubis.
- **[Phase 5]** Read `snd_hda_pick_fixup()` in
  `sound/hda/common/auto_parser.c` lines 1006–1103.
- **[Phase 5]** Read probe call sites at `alc269.c` lines 8471–8486.
- **[Phase 5]** Grep: `ALC236_FIXUP_HP_MUTE_LED_COEFBIT2` used by HP 255
  G8 (`0x890e`, line 6811) and G10 (`0x8b2f`, line 6874).
- **[Phase 6]** `git describe HEAD` → `v6.18.44`; Makefile confirms
  6.18.44.
- **[Phase 6]** Grep for `0x8a1b` / `HP 255 15.6 inch G9`: no matches in
  tree.
- **[Phase 6]** Read insertion area lines 6840–6846: gap between
  `0x8a0f` and `0x8a1f` confirmed.
- **[Phase 7]** `git log --oneline -20 -- sound/hda/codecs/realtek/`:
  active quirk backport activity.
- **[Phase 8]** Failure mode assessed as functional audio (MEDIUM), not
  crash/security.

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 0c23eb601ecaa..0ef5468b0701a 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6841,6 +6841,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x89e7, "HP Elite x2 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a06, "HP Dragonfly Folio G3 2-in-1", ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a0f, "HP Pavilion 14-ec1xxx", ALC287_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8a1b, "HP 255 15.6 inch G9 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8a1f, "HP Laptop 14s-dr5xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8a20, "HP Laptop 15s-fq5xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8a25, "HP Victus 16-d1xxx (MB 8A25)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
-- 
2.53.0

