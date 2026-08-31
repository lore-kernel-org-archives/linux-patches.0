Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D9042376A;
	Mon, 31 Aug 2026 13:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184027; cv=none; b=j5kuHDIr0+CHk/Tm7tE/KzV5aL+KFY9N3eyv095rszn2fVmY1Hwm6rBfr1+WUExRLLaw3megbpkFWHaLhtVV4q1EGJnbLmUYH/dqyJ+BmRr6pTf82KoJp9GBsciTpbRcAvzuz/E6ual85WYBUFItmceSmuax1xcfLi//4XWQuB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184027; c=relaxed/simple;
	bh=vk6TDT4IXwsl8J2mrFv6SDNmrW+ZQGixsh65xfz8kBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OWKfuSpR/HLFj+EloTILbIOqkTz4eaCUfJvUi5sEmqQcTnOtcxOhhPs32UO1lO+/xtYTfn5cQaljST9LqSNvfU561RFU8yUO8uBeTk5t/Dikf5Fg5eepFZNichL8gePfu5rsbG+NUDDG1PJgBk3WLtG7ayHFtCKwFJijm1VDzo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UD9fM3zO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UD9fM3zO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8167B1F00ADE;
	Mon, 31 Aug 2026 13:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184023;
	bh=SC3qTD2eqmYaKWyZPKFPXbeK4KOaikQ9S2F0cZlVcZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UD9fM3zODM3B1MCkTIgVDl5WDumGCDpQzoyLLR5RdTZDA0z1H397xiyVnqP7K0OHz
	 F9nIaySXC/wuJWV6BlhtX8VNBD+++AbZ0r82yVvLD0oIaSai84gKgDMp8PQ6OMzBAj
	 fmpN8PvS6c+Bl57GKlyqlOp+9Go2Lzpm5rKzFfAiDHVLzixFs9nIi5fpkuknYSYahM
	 mHWZjyjlygyNJBs4UPJzif/+ZtP+x/dr73aB8g7wwXHdNlEYXjRj4ZCGIOFIOX5ur5
	 LXKGDgofIzYSAsY8yGKaYvWLAEFQz4hwenX3N2HqfR0mSwzL5h949KPg81zdcPaJuG
	 RbvNMNnYgNZ6A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhang Heng <zhangheng@kylinos.cn>,
	Caio Ramos <caioramos97@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] ALSA: hda/realtek: Add HDA_CODEC_QUIRK for Samsung 750XBE/730XBE
Date: Mon, 31 Aug 2026 09:27:52 -0400
Message-ID: <20260831133314.4125787-444-sashal@kernel.org>
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

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit 740b3c6780ec1f65aba2bc99a3f41d70bdb13477 ]

Add a codec SSID quirk for Samsung ELECTRONICS 750XBE/730XBE using
HDA_CODEC_QUIRK() instead of SND_PCI_QUIRK(), because the alsa-info
report from this device does not expose a PCI subsystem ID, only the
HDA codec subsystem ID (0x144d:0xc824) is available.

This applies ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET to fix sound
being very low and distorted on the headphone jack of this system.

Reported-by: Caio Ramos <caioramos97@gmail.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=208663
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260720123702.799474-1-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[ALSA: hda/realtek]` `[Add]` — Add an HDA codec SSID quirk
for Samsung 750XBE/730XBE laptops.

### Step 1.2: Commit Message Tags
**Record:**
- **Reported-by:** Caio Ramos `<caioramos97@gmail.com>` — real user
  report
- **Link:** https://bugzilla.kernel.org/show_bug.cgi?id=208663 — kernel
  bugzilla entry
- **Signed-off-by:** Zhang Heng `<zhangheng@kylinos.cn>` — author
- **Link:**
  https://patch.msgid.link/20260720123702.799474-1-zhangheng@kylinos.cn
  — mailing list submission
- **Signed-off-by:** Takashi Iwai `<tiwai@suse.de>` — ALSA/HDA
  maintainer
- No `Fixes:`, `Cc: stable`, `Tested-by:`, or `Reviewed-by:` tags
- Notable: maintainer (Takashi Iwai) signed off and applied; user bug
  report with long-standing bugzilla thread

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** Headphone jack audio on Samsung 750XBE/730XBE is very low and
  distorted
- **Symptom:** Unusable headphone output; user filed bugzilla in 2020
  (kernel 5.4.52)
- **Root cause:** Device exposes only HDA codec subsystem ID
  `0x144d:0xc824`, not a PCI subsystem ID, so existing `SND_PCI_QUIRK()`
  entries cannot match
- **Fix:** Add `HDA_CODEC_QUIRK(0x144d, 0xc824, ...)` applying existing
  `ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET`
- **Version info:** Bugzilla reports kernel 5.4.52; fix committed to
  mainline July 2026

### Step 1.4: Hidden Bug Fix Detection
**Record:** Not disguised as cleanup — this is an explicit hardware
quirk fix. It enables an existing, proven fixup for a device that
previously had no matching quirk entry.

---

## Phase 2: Diff Analysis

### Step 2.1: Change Inventory
**Record:**
- **Files:** `sound/hda/codecs/realtek/alc269.c` — +1 line, 0 removals
- **Function/table:** `alc269_fixup_tbl[]` quirk table
- **Scope:** Single-file, single-line surgical addition

### Step 2.2: Code Flow Change
**Record:**
- **Before:** At codec probe, `snd_hda_pick_fixup()` walks
  `alc269_fixup_tbl[]`. Samsung 750XBE/730XBE (codec SSID
  `0x144d:0xc824`) matches no entry → no headphone fixup applied →
  broken audio
- **After:** Same probe path matches the new `HDA_CODEC_QUIRK` entry
  (via `match_codec_ssid = true`) → applies
  `ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET` → sets pin widget control
  verb `{ 0x1a, AC_VERB_SET_PIN_WIDGET_CONTROL, 0xc5 }`
- **Path affected:** Device probe / codec initialization (one-time per
  boot)

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Hardware quirk / logic correctness fix
- **Mechanism:** Missing quirk table entry for a device whose
  identification requires codec SSID matching rather than PCI SSID
  matching. The fixup infrastructure and verb sequence already exist;
  only the device ID mapping was missing.

### Step 2.4: Fix Quality
**Record:**
- Obviously correct: identical pattern to other Samsung headphone quirks
  already in the tree (e.g. `0x144d:0xca06` using the same
  `ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET`)
- Minimal: one line
- Regression risk: very low — only affects devices with exact codec SSID
  `0x144d:0xc824`
- No API, locking, or structural changes

---

## Phase 3: Git History Investigation

### Step 3.1: Blame / Introduction
**Record:**
- `ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET` definition present since
  base merge `5d324e5159d9e` (v6.18.0, Nov 2025)
- `HDA_CODEC_QUIRK` macro present in `sound/hda/common/hda_local.h` in
  this tree
- The missing quirk entry `0xc824` was never present in 6.18.y — this is
  a coverage gap, not a regression from a recent commit

### Step 3.2: Fixes: Tag
**Record:** N/A — no `Fixes:` tag in commit message.

### Step 3.3: Related File History
**Record:** Recent stable backports in this tree include:
- `651760f57fe0f` — Samsung Galaxy Book5 360 headphone quirk (Cc:
  stable, backported by Greg K-H)
- `b98ecc1c60ad7` — Lenovo Yoga Pro 7 using `HDA_CODEC_QUIRK` for codec
  SSID matching
- Same author (Zhang Heng) submitted other `HDA_CODEC_QUIRK` entries
  already in 6.18.y
- Standalone single-patch series (v1 only)

### Step 3.4: Author Context
**Record:** Zhang Heng is an active Realtek HDA contributor with
multiple quirk patches already backported to 6.18.y. Takashi Iwai
(subsystem maintainer) committed to mainline.

### Step 3.5: Dependencies
**Record:**
- **Required in tree:** `HDA_CODEC_QUIRK` macro — **present**
- **Required in tree:** `ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET`
  fixup — **present**
- **Required in tree:** `match_codec_ssid` logic in `auto_parser.c` —
  **present**
- **Can apply standalone:** Yes — verified with `git cherry-pick --no-
  commit 740b3c6780ec1` (auto-merged cleanly)

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Patch Discussion
**Record:**
- **b4 dig URL:**
  https://patch.msgid.link/20260720123702.799474-1-zhangheng@kylinos.cn
- **Series:** v1 only (no revisions)
- **Maintainer response:** Takashi Iwai: "Applied now. Thanks." — no
  objections or concerns

### Step 4.2: Reviewers
**Record:** CC'd: `tiwai@suse.com`, `linux-sound@vger.kernel.org`,
`linux-kernel@vger.kernel.org`, reporter Caio Ramos. ALSA maintainer
reviewed and applied.

### Step 4.3: Bug Report
**Record:**
- **Bugzilla 208663:** "[750XBE/730XBE, Realtek ALC256] Sound very low
  and distorted on headphone jack"
- Reported 2020-07-22, last modified 2026-07-20
- User attached alsa-info dumps and a firmware patch workaround
- Severity: functional audio defect on real hardware (not a crash)

### Step 4.4: Related Patches
**Record:** Part of ongoing Samsung headphone quirk series. Same fixup
already used for Galaxy Book3 360 (`0xca06`) via `SND_PCI_QUIRK`. This
patch extends coverage to a device identifiable only by codec SSID.

### Step 4.5: Stable List Discussion
**Record:** No stable-specific discussion found. Commit lacks explicit
`Cc: stable`, but similar Samsung headphone quirk (`651760f57fe0f`) was
explicitly nominated and backported to this tree.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `alc269_fixup_tbl[]` (quirk table), `snd_hda_pick_fixup()`
(called from Realtek codec probe)

### Step 5.2: Callers
**Record:** `snd_hda_pick_fixup()` called during `alc269` codec probe
init (`alc269.c` line ~8471). Runs once per HDA codec bind at
boot/module load. All Realtek ALC269-family devices traverse this path.

### Step 5.3: Callees
**Record:** Quirk matching in `sound/hda/common/auto_parser.c` checks
`q->match_codec_ssid` and matches against codec vendor/device ID when
PCI SSID is unavailable or `HDA_CODEC_QUIRK` is used.

### Step 5.4: Reachability
**Record:** Triggered automatically on every boot for Samsung
750XBE/730XBE systems with this codec. No userspace action needed beyond
normal audio subsystem loading. Common laptop hardware path.

### Step 5.5: Similar Patterns
**Record:** 11 existing `HDA_CODEC_QUIRK` entries in `alc269.c` in this
tree; multiple Samsung entries using
`ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET` and
`ALC256_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET` via `SND_PCI_QUIRK`.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code in Tree
**Record:**
- **Local tree:** Linux **6.18.44** (`git describe HEAD` →
  `v6.18.44-2-g1b9e1abadee04`)
- **Bug present:** Yes — `0x144d:0xc824` quirk entry is **absent** (grep
  confirmed no match)
- **Commit `740b3c6780ec1`:** On `master`, **not** an ancestor of
  current HEAD (`merge-base --is-ancestor` exit code 1)
- All fixup infrastructure the patch depends on **is** present

### Step 6.2: Backport Complications
**Record:** Clean apply verified. Line numbers differ (mainline ~7656 vs
stable ~7243) but context matches; auto-merge succeeded.

### Step 6.3: Related Fixes Already Present
**Record:** No duplicate fix for `0xc824`. Related Samsung headphone
quirks for other models are already in tree. The underlying fixup
`ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET` is present and used by
`0xca06`.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem Criticality
**Record:** `sound/hda` — ALSA HD-audio codec driver. **IMPORTANT**
subsystem; affects laptop audio for specific hardware. Not core-kernel-
wide, but affects all users of this Samsung model.

### Step 7.2: Subsystem Activity
**Record:** Actively maintained in 6.18.y — 20+ realtek quirk commits in
recent stable history. Quirk additions are routine stable backport
material in this subsystem.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Owners of Samsung 750XBE/730XBE laptops with Realtek codec
SSID `0x144d:0xc824`. Driver-specific, config-independent (HDA/Realtek
is standard on these machines).

### Step 8.2: Trigger Conditions
**Record:** Every boot with headphone use. 100% reproducible on affected
hardware. Not security-related; not privilege-dependent.

### Step 8.3: Failure Mode Severity
**Record:** Very low/distorted headphone audio — functional defect,
effectively broken headphone output. **Severity: MEDIUM** (not
crash/corruption, but real user-visible hardware malfunction).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Restores working headphone audio on affected Samsung
  laptops; long-standing bugzilla report
- **Risk:** Minimal — one-line quirk entry, device-specific ID match,
  reuses proven fixup
- **Ratio:** Strongly favorable. Matches established stable pattern for
  HDA codec quirks.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real hardware bug with user report (bugzilla since 2020)
- One-line hardware quirk — textbook stable exception category
- All prerequisites present in 6.18.44
- Patch applies cleanly
- Maintainer-reviewed and applied to mainline
- Identical pattern already backported to this tree (`651760f57fe0f`,
  `b98ecc1c60ad7`)
- Reuses existing `ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET` — no new
  APIs or features

**AGAINST backport:**
- Not a crash, security, or data-corruption issue (functional audio
  only)
- No explicit `Cc: stable` tag (expected for manual review pipeline)

**Unresolved:** None affecting the decision.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — maintainer applied; pattern
   proven on sibling Samsung models
2. Fixes a real bug affecting users? **PASS** — bugzilla #208663, user-
   reported
3. Important issue? **PASS** — hardware non-functionality on affected
   laptops (MEDIUM severity, quirk exception applies)
4. Small and contained? **PASS** — 1 line, 1 file
5. No new features or APIs? **PASS** — maps existing fixup to new device
   ID
6. Can apply to local tree? **PASS** — clean cherry-pick verified

### Step 9.3: Exception Category
**Record:** Hardware quirk / codec SSID quirk — automatic stable
qualification per established HDA Realtek quirk backport practice in
this tree.

### Step 9.4: Decision Rationale
This commit adds a missing codec SSID quirk entry for Samsung
750XBE/730XBE laptops, enabling an existing headphone fixup that is
already used for other Samsung models in Linux 6.18.44. The bug is real,
the fix is minimal and device-specific, all infrastructure exists in
this tree, and the patch applies cleanly. This is standard stable
material for the Realtek HDA driver.

---

## Verification

- [Phase 1] Parsed subject, tags, body; found Reported-by, bugzilla
  link, maintainer SOB
- [Phase 2] Diff: +1 line in `alc269_fixup_tbl[]`, adds
  `HDA_CODEC_QUIRK(0x144d, 0xc824, ...)`
- [Phase 3] `git describe HEAD`: v6.18.44; commit `740b3c6780ec1` on
  master, not in HEAD
- [Phase 3] `git merge-base --is-ancestor 740b3c6780ec1 HEAD`: exit 1
  (not in tree)
- [Phase 3] `git cherry-pick --no-commit 740b3c6780ec1`: auto-merged
  cleanly
- [Phase 3] Grep `0x144d, 0xc824`: no matches in tree (quirk absent)
- [Phase 3] Grep `ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET`: present
  (enum, fixup def, used by `0xca06`)
- [Phase 3] Grep `HDA_CODEC_QUIRK`: macro in `hda_local.h`, 11 uses in
  `alc269.c`
- [Phase 4] `b4 dig -c 740b3c6780ec1`: found lore thread
- [Phase 4] `b4 dig -a`: v1 only, no revisions
- [Phase 4] `b4 dig -w`: CC'd tiwai, linux-sound, reporter
- [Phase 4] Mbox: Takashi Iwai "Applied now. Thanks."
- [Phase 4] Bugzilla 208663 fetched: user report from 2020, headphone
  distortion
- [Phase 5] `snd_hda_pick_fixup()` called at codec probe (~line 8471)
- [Phase 5] `match_codec_ssid` logic verified in `auto_parser.c:1069`
- [Phase 6] Tree is 6.18.44; prerequisites present; quirk entry missing
- [Phase 6] Similar backport `651760f57fe0f` confirmed in tree with Cc:
  stable
- [Phase 8] Failure mode: broken headphone audio, MEDIUM severity

**YES****Backport recommendation: YES** for Linux 6.18.44.

This is a one-line `HDA_CODEC_QUIRK` for Samsung 750XBE/730XBE (codec
SSID `0x144d:0xc824`) that applies the existing
`ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET` fixup for very low/distorted
headphone audio. The fix is on mainline (`740b3c6780ec1`) but not in
this tree yet; all prerequisites are present and the patch applies
cleanly. Same pattern as other Samsung headphone quirks already
backported to 6.18.y.

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index f1e6557847a85..de604ab8625a0 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7286,6 +7286,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x144d, 0xc1a6, "Samsung Galaxy Book Pro 360 (NP930QBD)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc740, "Samsung Ativ book 8 (NP870Z5G)", ALC269_FIXUP_ATIV_BOOK_8),
 	SND_PCI_QUIRK(0x144d, 0xc812, "Samsung Notebook Pen S (NT950SBE-X58)", ALC298_FIXUP_SAMSUNG_AMP),
+	HDA_CODEC_QUIRK(0x144d, 0xc824, "Samsung ELECTRONICS (750XBE/730XBE)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
 	SND_PCI_QUIRK(0x144d, 0xc830, "Samsung Galaxy Book Ion (NT950XCJ-X716A)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc832, "Samsung Galaxy Book Flex Alpha (NP730QCJ)", ALC256_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
 	SND_PCI_QUIRK(0x144d, 0xc876, "Samsung 730QED (NP730QED-KA2US)", ALC256_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
-- 
2.53.0

