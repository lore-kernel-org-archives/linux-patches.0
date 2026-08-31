Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E130432304;
	Mon, 31 Aug 2026 13:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183507; cv=none; b=M+7IN0CUcnJwwWVa2Ks4cXvBMFMzFpAHfbPWyqbTV6mEyPZnIP2WOnooHTtpfLn4JGW3bPW618BuWqZ/lejpVc2AdLVWKjy3ITc0kOkuzoaYHBUWnwloiqjPely2QZnUrFPW4lC7z+Y6MA1OiQqvyunLLqDrdxrXmp5zdK4KSCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183507; c=relaxed/simple;
	bh=TFk6IgBlINeZD5hcBYd0BFi7pUcQlJJIVFfEXuKMWMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R1fulrUHVSlosD7ExG4klQBJqixh9TwRPzeJszBqEKbJ1IMy2dyHH3y67YB+gEFyP/D187KXqAyiCZvaaaZp9Ltjjwr4h400yzr2Gbp0RJX4ki7Ja18DDpukH54GuMo3eoDhvWc+tfMACI6+zGNEtlydt+lvElYxvUSnxdj5DDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UWs4Dg9w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UWs4Dg9w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13971F00A3E;
	Mon, 31 Aug 2026 13:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183505;
	bh=RiZ5Rq9O40CIw+PX0lyag+rbpp75xTzZWv0WhYpMaiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UWs4Dg9wzoqxw1Fp/ibk+l5LkZVcSzFmuHLZ5P/K88fj19cPpWkKM32/kS1BbDhGy
	 GkA+LU8C4sKT2QedaLS86V0K4FzukEBPLpplWyzW2vrzMHEtZCtislzrTKjdRh1etQ
	 iQ/Ms5v/CSVD737PSzSO4o5//9YVIjubg3cjWaL6L7kn16kvgSqTrRfA89PDVN+Ys7
	 44aQ0COYji6csQSGzXD6Kx0hKLOGD5H8kIxm3z1UK+zYSw86fGy0ARczrHfXVBqoxD
	 SLoI/vvQ9e3R41Hp+ZqZ7Q0vpd/J+vxmpawCWTiG3WEzedYmktd4lL3chF/LfDzysn
	 zXP0d1ch+T5gg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] ALSA: hda/realtek: Add quirk for HP Pavilion x360
Date: Mon, 31 Aug 2026 09:22:44 -0400
Message-ID: <20260831133314.4125787-136-sashal@kernel.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 02bbbf05d19f49c5cc9f249dd8844b2a7f2a2b8c ]

HP Pavilion x360 sets a bogus PCI SSID (103c:0000), hence the driver
picks up a wrong quirk entry, resulting in an almost silent output.
And yet, the existing quirk for x390 doesn't seem sufficing, and we
need the extra setup for the amp.

This patch adds the quirk entry for the codec SSID (103c:8486) to
initialize the amp via COEF verbs and chains to the existing quirk for
another x360 model to address the silent output.

Closes: https://lore.kernel.org/CAF2ktaUW2oaWwGazGtJQ3o1JyE2R4O2xPd-Dchr=qqi7_QRruQ@mail.gmail.com
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260716064916.540616-1-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ALSA: hda/realtek: Add quirk for HP Pavilion
x360

**Local tree:** Linux **6.18.44** (`v6.18.44-2-g1b9e1abadee04`,
`VERSION=6 PATCHLEVEL=18 SUBLEVEL=44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[ALSA: hda/realtek]` `[add]` — Add a hardware quirk for HP
Pavilion x360 audio.

### Step 1.2: Parse all commit message tags
**Record:**
- **Closes:**
  `https://lore.kernel.org/CAF2ktaUW2oaWwGazGtJQ3o1JyE2R4O2xPd-
  Dchr=qqi7_QRruQ@mail.gmail.com` (user bug report thread)
- **Reviewed-by:** Cezary Rojewski `<cezary.rojewski@intel.com>`
- **Signed-off-by:** Takashi Iwai `<tiwai@suse.de>` (ALSA/HDA
  maintainer)
- **Link:**
  `https://patch.msgid.link/20260716064916.540616-1-tiwai@suse.de`
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Cc:
  stable@vger.kernel.org`

Notable: maintainer-authored, Intel-reviewed; no syzbot/sanitizer
signals.

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** HP Pavilion x360 reports bogus PCI SSID `103c:0000`, so the
  Realtek driver matches the wrong quirk. Existing
  `ALC295_FIXUP_HP_X360` alone is insufficient; extra amplifier setup is
  required.
- **Symptom:** Almost silent speaker output.
- **Root cause:** Wrong quirk selection due to bogus PCI SSID; missing
  COEF-based amp initialization.
- **Fix:** Add `HDA_CODEC_QUIRK(0x103c, 0x8486, ...)` matching codec
  SSID, applying COEF verbs then chaining to `ALC295_FIXUP_HP_X360`.

### Step 1.4: Detect hidden bug fixes
**Record:** Not hidden — explicit hardware audio bug fix disguised as a
quirk addition. Classic ALSA HDA laptop quirk pattern.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **File:** `sound/hda/codecs/realtek/alc269.c` only
- **Scope:** ~14 lines added, 0 removed
- **Functions/structures modified:**
  - Fixup enum (adds `ALC295_FIXUP_HP_PAVILION_X360`)
  - `alc269_fixups[]` (new fixup entry)
  - `alc269_fixup_tbl[]` (new quirk table entry)
- **Classification:** Single-file, surgical hardware quirk

### Step 2.2: Code flow change
**Record:**
- **Hunk 1 (enum):** Adds new fixup ID before
  `ALC221_FIXUP_HP_HEADSET_MIC`.
- **Hunk 2 (fixups table):** New `ALC295_FIXUP_HP_PAVILION_X360` entry:
  - **Before:** No codec-SSID-specific handling for `103c:8486`.
  - **After:** On probe, sends COEF verbs to node `0x20` (indices
    `0x07`/`0x0d`, values `0x7770`/`0x3000`) to force amp
    gain/processing, then chains to `ALC295_FIXUP_HP_X360` →
    `alc295_fixup_hp_top_speakers` → `ALC269_FIXUP_HP_MUTE_LED_MIC3`.
- **Hunk 3 (quirk table):** Adds `HDA_CODEC_QUIRK(0x103c, 0x8486, "HP
  Pavilion x360", ALC295_FIXUP_HP_PAVILION_X360)` between existing
  `0x841c` and `0x8497` HP entries.
- **Path affected:** HDA codec probe / fixup application at driver load.

### Step 2.3: Bug mechanism
**Record:** **Category:** Hardware quirk / logic correctness.
- Bogus PCI SSID (`103c:0000`) prevents correct `SND_PCI_QUIRK`
  matching.
- `HDA_CODEC_QUIRK` matches on codec subsystem ID (`103c:8486`) instead.
- Missing amp COEF initialization leaves speakers nearly silent even if
  partial x360 fixup is reached.

### Step 2.4: Fix quality assessment
**Record:**
- Fix is minimal and follows established patterns (`HDA_FIXUP_VERBS` +
  chained fixups).
- Precedent in-tree: `ALC294_FIXUP_ASUS_SPK` uses the same COEF-verb
  pattern.
- **Regression risk:** Very low — only affects machines with codec SSID
  `103c:8486`.
- No API, locking, or structural changes.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame changed lines
**Record:**
- `ALC295_FIXUP_HP_X360` and its fixup entry blame to `5d324e5159d9e`
  (v6.18 merge, Nov 2025) — present in this tree.
- `hp_x360.c` helper included at line 3276 — present.
- The candidate commit itself is **not** in this tree (`0x8486`,
  `ALC295_FIXUP_HP_PAVILION_X360` absent).

### Step 3.2: Follow Fixes: tag
**Record:** N/A — no `Fixes:` tag. This is a hardware/firmware SSID
quirk issue, not a regression from a specific kernel commit.

### Step 3.3: Related file history
**Record:**
- Recent related stable commits in this tree:
  - `6b2c0cd5f9689` — Legion Pro 7 codec SSID quirk for silent speakers
    (`HDA_CODEC_QUIRK`, `Cc: stable`)
  - `ded801af28a99` — different HP Pavilion x360 mute-LED quirk
    (`0x103c:0x8a34`, ALC245)
- **Standalone:** Yes — no series dependency; self-contained quirk
  addition.

### Step 3.4: Author context
**Record:** Takashi Iwai is the ALSA/HDA maintainer. `Reviewed-by:
Cezary Rojewski` (Intel audio).

### Step 3.5: Prerequisites
**Record:**
- `ALC295_FIXUP_HP_X360` — **present** (line 3824, fixup at 5124–5129)
- `alc295_fixup_hp_top_speakers` via `hp_x360.c` — **present**
- `ALC269_FIXUP_HP_MUTE_LED_MIC3` — **present** (chain target)
- `HDA_CODEC_QUIRK` macro — **present** in `hda_local.h`, used 11 times
  in `alc269.c`
- `match_codec_ssid` logic in `auto_parser.c` — **present**
- **Can apply standalone:** Yes

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:** UNVERIFIED — `b4 dig -c <commit>` not possible (commit not
in local repo). `patch.msgid.link` and `lore.kernel.org` returned
403/Anubis bot protection. Could not read thread content.

### Step 4.2: Reviewers
**Record:** `Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>`
from commit message (unverified against lore thread).

### Step 4.3: Bug report
**Record:** `Closes:` links to a Gmail lore thread (user report).
UNVERIFIED — could not fetch. Commit message describes reproducible
silent-audio symptom on specific hardware.

### Step 4.4: Related patches/series
**Record:** Standalone 1/1 patch. Related but distinct: `ded801af28a99`
(HP Pavilion x360 14-ek0xxx mute LED, different SSID/codec).

### Step 4.5: Stable list history
**Record:** UNVERIFIED — lore stable search blocked. Similar Legion Pro
silent-speaker quirk (`6b2c0cd5f9689`) was explicitly nominated with
`Cc: stable` and is already in this 6.18.y tree.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions modified
**Record:** No functions modified. Data tables only: fixup enum,
`alc269_fixups[]`, `alc269_fixup_tbl[]`.

### Step 5.2: Callers
**Record:** Quirk tables consumed during HDA codec probe in
`sound/hda/common/auto_parser.c`:
- `snd_hda_pick_fixup()` iterates `alc269_fixup_tbl[]`
- For `HDA_CODEC_QUIRK` entries (`match_codec_ssid = true`), matches
  codec vendor/device ID
- Matched fixup applied during codec initialization on every boot for
  matching hardware

### Step 5.3: Callees
**Record:** New fixup sends standard HDA verbs
(`AC_VERB_SET_COEF_INDEX`, `AC_VERB_SET_PROC_COEF`), then chains to
`alc295_fixup_hp_top_speakers` and `alc269_fixup_hp_mute_led_mic3`.

### Step 5.4: Call chain / reachability
**Record:** Triggered automatically at HDA codec probe on affected HP
Pavilion x360 hardware. Not userspace-triggerable; affects all users of
that laptop model at boot.

### Step 5.5: Similar patterns
**Record:**
- `ALC294_FIXUP_ASUS_SPK` — COEF verb amp init, chained fixup (lines
  5195–5207)
- `6b2c0cd5f9689` — `HDA_CODEC_QUIRK` for silent speakers when PCI SSID
  is wrong
- `ALC285_FIXUP_HP_GPIO_AMP_INIT` — HP amp-init fixup family

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Does the buggy code exist?
**Record:** **Yes.** The tree has `ALC295_FIXUP_HP_X360` and HP x360 PCI
quirks (`0x820d`, `0x827e`) but **no** `HDA_CODEC_QUIRK(0x103c, 0x8486,
...)`. Machines with bogus PCI SSID `103c:0000` and codec SSID
`103c:8486` are affected in this tree today.

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** Insertion points verified in
current tree:
- Enum: `ALC295_FIXUP_HP_X360` at 3824, followed by
  `ALC221_FIXUP_HP_HEADSET_MIC`
- Fixups: `ALC295_FIXUP_HP_X360` at 5124–5129
- Quirk table: `0x841c` at 6723, `0x8497` at 6724 — matches diff context
  exactly

### Step 6.3: Related fixes already present?
**Record:** No equivalent fix for `103c:8486`. Different Pavilion x360
quirk (`0x8a34`, ALC245 mute LED) exists but addresses a different
machine/codec.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `sound/hda` — Realtek codec driver. **IMPORTANT** for
affected laptop users; peripheral globally but critical for those with
broken audio.

### Step 7.2: Subsystem activity
**Record:** Actively maintained — multiple HP/Lenovo quirk commits in
recent 6.18.y history.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** **Hardware-specific** — HP Pavilion x360 laptops reporting
codec SSID `103c:8486` with bogus PCI SSID `103c:0000`.

### Step 8.2: Trigger conditions
**Record:** Every boot / codec probe on affected hardware. Common path
for those machines. Not security-relevant; not user-triggerable beyond
owning the hardware.

### Step 8.3: Failure mode severity
**Record:** Near-silent speaker output — primary audio function broken.
**Severity: MEDIUM** (functional breakage, not
crash/corruption/security). For affected users, impact is severe.

### Step 8.4: Risk-benefit ratio
**Record:**
- **Benefit:** Restores usable speaker audio on affected HP Pavilion
  x360 laptops
- **Risk:** Very low — ~14 lines, codec-SSID-specific match, established
  quirk mechanism
- **Ratio:** Strongly favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence compiled

**FOR backport:**
- Real hardware bug: near-silent speakers on specific HP Pavilion x360
- Classic stable exception: hardware quirk/workaround
- Small, surgical, maintainer-authored, Intel-reviewed
- All prerequisites present in Linux 6.18.44
- Clean apply to current tree
- Direct precedent: `6b2c0cd5f9689` (codec SSID quirk for silent
  speakers, already in 6.18.y with `Cc: stable`)
- Low regression risk (SSID-specific matching)

**AGAINST backport:**
- Not a crash, security, or data-corruption issue
- Affects only one hardware variant
- No `Tested-by:` or `Cc: stable` in commit message (not disqualifying)
- Mailing list discussion unverified

**UNRESOLVED:**
- Could not verify lore thread or user bug report details (403 bot
  protection)

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — standard HDA quirk pattern;
   Reviewed-by from Intel; maintainer SOB
2. Fixes a real bug affecting users? **PASS** — silent/near-silent audio
   on specific laptop
3. Important issue? **PASS** — broken primary audio on affected hardware
   (hardware quirk exception)
4. Small and contained? **PASS** — ~14 lines, one file
5. No new features or APIs? **PASS** — quirk table entry only
6. Can apply to local tree? **PASS** — prerequisites present, clean
   apply expected

### Step 9.3: Exception category
**Record:** **Hardware quirk/workaround** — codec SSID quirk with COEF
amp initialization for broken/misreported PCI SSID.

### Step 9.4: Decision rationale
This commit fixes a real, user-visible audio failure on HP Pavilion x360
hardware where a bogus PCI SSID causes incorrect quirk matching. The fix
is a small, well-established HDA codec quirk that matches codec SSID
`103c:8486`, initializes the amplifier via COEF verbs, and chains to
existing x360 fixups already present in Linux 6.18.44. It fits the
stable kernel hardware-quirk exception category with minimal risk and
clear benefit for affected laptop owners.

---

## Verification

- [Phase 1] Parsed commit message: subsystem ALSA/hda/realtek, action
  "add quirk", tags Closes/Reviewed-by/Link/Signed-off-by
- [Phase 1] No Fixes:/Reported-by:/Cc: stable tags
- [Phase 2] Diff: 1 file, ~14 lines added, enum + fixup + quirk table
- [Phase 2] New fixup chains: PAVILION_X360 → HP_X360 → MUTE_LED_MIC3
- [Phase 2] COEF verbs: index 0x07/val 0x7770, index 0x0d/val 0x3000
- [Phase 3] `git describe HEAD`: v6.18.44-2-g1b9e1abadee04
- [Phase 3] `git blame` ALC295_FIXUP_HP_X360: present since
  5d324e5159d9e
- [Phase 3] `grep ALC295_FIXUP_HP_PAVILION_X360` / `0x8486` in alc269.c:
  not found — commit absent from tree
- [Phase 3] `6b2c0cd5f9689`: similar HDA_CODEC_QUIRK silent-speaker fix
  already in tree
- [Phase 3] `ded801af28a99`: different HP Pavilion x360 quirk (0x8a34,
  mute LED)
- [Phase 4] `b4 dig -c`: not run — commit not in local repo
- [Phase 4] lore.kernel.org / patch.msgid.link fetch: 403 Forbidden —
  UNVERIFIED
- [Phase 5] `grep match_codec_ssid` in auto_parser.c: codec SSID
  matching logic confirmed at lines 1067–1079
- [Phase 5] `HDA_CODEC_QUIRK` macro in hda_local.h: confirmed at lines
  314–320
- [Phase 5] `hp_x360.c` included at alc269.c:3276;
  `alc295_fixup_hp_top_speakers` exists
- [Phase 6] Insertion context verified: 0x841c/0x8497 neighbors at lines
  6723–6724
- [Phase 6] 11 existing `HDA_CODEC_QUIRK` entries in alc269.c
  (ASUS/Lenovo, no HP yet)
- [Phase 8] Failure mode: near-silent speakers, severity MEDIUM for
  affected hardware

**YES**The background search for `0x8486` finished: that codec SSID
quirk is **not** in this **6.18.44** tree yet, which matches the earlier
analysis.

**Verdict: YES** — backport this commit. It’s a small HP Pavilion x360
hardware quirk (`103c:8486`) that fixes near-silent speakers when the
machine reports a bogus PCI SSID (`103c:0000`). All prerequisites
(`ALC295_FIXUP_HP_X360`, `HDA_CODEC_QUIRK`, amp init chain) are already
present, and the patch should apply cleanly.

 sound/hda/codecs/realtek/alc269.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index b7dad90ac9cd4..f1e6557847a85 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3823,6 +3823,7 @@ enum {
 	ALC256_FIXUP_HUAWEI_MACH_WX9_PINS,
 	ALC298_FIXUP_HUAWEI_MBX_STEREO,
 	ALC295_FIXUP_HP_X360,
+	ALC295_FIXUP_HP_PAVILION_X360,
 	ALC221_FIXUP_HP_HEADSET_MIC,
 	ALC285_FIXUP_LENOVO_HEADPHONE_NOISE,
 	ALC295_FIXUP_HP_AUTO_MUTE,
@@ -5137,6 +5138,19 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC269_FIXUP_HP_MUTE_LED_MIC3
 	},
+	[ALC295_FIXUP_HP_PAVILION_X360] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			/* force amp gain and processing state */
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x07 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x7770 },
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x0d },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x3000 },
+			{}
+		},
+		.chained = true,
+		.chain_id = ALC295_FIXUP_HP_X360
+	},
 	[ALC221_FIXUP_HP_HEADSET_MIC] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -6744,6 +6758,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x82c0, "HP G3 mini premium", ALC221_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x83b9, "HP Spectre x360", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x841c, "HP Pavilion 15-CK0xx", ALC269_FIXUP_HP_MUTE_LED_MIC3),
+	HDA_CODEC_QUIRK(0x103c, 0x8486, "HP Pavilion x360", ALC295_FIXUP_HP_PAVILION_X360),
 	SND_PCI_QUIRK(0x103c, 0x8497, "HP Envy x360", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x84a6, "HP 250 G7 Notebook PC", ALC269_FIXUP_HP_LINE1_MIC1_LED),
 	SND_PCI_QUIRK(0x103c, 0x84ae, "HP 15-db0403ng", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
-- 
2.53.0

