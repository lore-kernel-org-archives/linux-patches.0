Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C4B3BF696;
	Mon, 20 Apr 2026 13:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691041; cv=none; b=bFJAJqXUFnDC/6aWIvz8N7ZAjvNWzf0/1bZHyzhtVG6SfNbiD8/F8xxQWApX6ljcoxVE9Kt2JzTRcbqixI4bUPmla/fhgIsodEZdAX1Zx/0fNNIIHFjMEBEaF2DIIpdh3jiwSraZddtB/B69oQffuODbLIgKX1h5ybkhtmwSU7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691041; c=relaxed/simple;
	bh=4tFDEcsLoCEEi/4BsVW55gQThJ1sAmgtXnSARjAr/zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AcBcSc8H7TrpEbS3cCkriLCtYbXA6rbCNSO5F17KvkHLZKEqisTg4oeQrKWXw1D8o5GgUR3NaiXIVTNvmCTu9Tt6tRqT9KRCZkDT7BQaLs5hZkykdVa8ZbCNZSY8+Xnt/EfCqdk5IjbPwm3s9QiUxafd0P8Jm02KXDnNw1VkMyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bXKyVEne; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bXKyVEne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A5FC2BCB7;
	Mon, 20 Apr 2026 13:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691041;
	bh=4tFDEcsLoCEEi/4BsVW55gQThJ1sAmgtXnSARjAr/zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bXKyVEneyOeuC17CyrZPiWn7SNnvPCFbn7lD0jXr8cYUY5YxRZUEdPm22PzllvXKd
	 K6ygzkBPZ9tN0vmNKO68jxWn5RnfjxETBtB11YOYDjw2kSxArWaqwsB7FVKsVbnZBx
	 SshyUe3n81kAPynTnZImior812/NVp8hVVo4wBDbT1xoXNz8xjYDZV15Wqw1Y311lL
	 FLPUbWqVVNQ57l7/ddb/kyo209UyrGobLltGExLFvYHLUWpjSD5pTdivGh1fujhXUp
	 ERTWGA8QcgSLqp7NLDwelXNphAxNUXO/woYWCKsmSjPnGVEzVL7metBvIFIibXVE8B
	 bjNp/oD/DNK3Q==
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
Subject: [PATCH AUTOSEL 7.0-6.18] ALSA: hda/realtek: Add quirk for CSL Unity BF24B
Date: Mon, 20 Apr 2026 09:08:45 -0400
Message-ID: <20260420131539.986432-59-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit de65275fc94e2e0acc79bd016d60889bf251ccd9 ]

The CSL Unity BF24B all-in-one PC uses a Realtek ALC662 rev3 audio
codec and requires the correct GPIO configuration to enable sound
output from both the speakers and the headphone.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221258
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260409024028.1297587-1-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a comprehensive analysis. Let
me compile the findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `ALSA: hda/realtek`
- Action verb: "Add quirk" — this is adding a hardware-specific
  workaround
- Summary: Adding GPIO quirk for CSL Unity BF24B all-in-one PC to enable
  audio output
- Record: [ALSA/HDA/Realtek] [Add quirk] [GPIO config to enable
  speakers/headphone on CSL Unity BF24B]

**Step 1.2: Tags**
- Link: `https://bugzilla.kernel.org/show_bug.cgi?id=221258` — user-
  filed bug report
- Signed-off-by: Zhang Heng (author, regular Realtek quirk contributor)
- Link: patch.msgid.link (for tracking the patch)
- Signed-off-by: Takashi Iwai (ALSA subsystem maintainer — applied the
  patch)
- No Fixes: tag (expected — this is a quirk addition, not fixing a code
  defect)
- No Cc: stable (expected — this is why we're reviewing it)
- Record: Bugzilla report from real user. Signed off by the ALSA
  maintainer.

**Step 1.3: Commit Body**
- Bug: CSL Unity BF24B all-in-one PC has no sound output from speakers
  or headphones
- Codec: Realtek ALC662 rev3
- Root cause: GPIO configuration needed to enable the amplifier
- Record: Complete audio failure on specific hardware without GPIO
  toggle workaround.

**Step 1.4: Hidden Bug Fix Detection**
- This is not a hidden bug fix — it's an explicit hardware quirk
  addition. The device literally has no audio without it.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Files changed: 1 (`sound/hda/codecs/realtek/alc662.c`)
- Lines added: ~25 (new function + enum + fixup entry + quirk entry)
- Functions modified: none existing; one new function added
  (`alc662_fixup_csl_amp`)
- Scope: single-file, surgical, self-contained

**Step 2.2: Code Flow Change**
1. New function `alc662_fixup_csl_amp`:
   - `HDA_FIXUP_ACT_PRE_PROBE`: Sets GPIO mask and direction for bits
     0+1
   - `HDA_FIXUP_ACT_INIT`: Toggles GPIO 0+1 high, waits 100ms, then low
     — to enable the amplifier
2. New enum `ALC662_FIXUP_CSL_GPIO` added at end of existing enum
3. New fixup table entry linking enum to function
4. New quirk table entry: `SND_PCI_QUIRK(0x1022, 0xc950, "CSL Unity
   BF24B", ALC662_FIXUP_CSL_GPIO)`

**Step 2.3: Bug Mechanism**
- Category: Hardware workaround (h)
- The CSL Unity BF24B's amplifier requires a GPIO toggle pulse to
  enable. Without it, the amp stays off and no sound comes out.

**Step 2.4: Fix Quality**
- The pattern is nearly identical to `alc245_fixup_hp_x360_amp` in
  alc269.c (lines 1448-1465), which toggles GPIO0 similarly. This new
  one toggles GPIO0+GPIO1 (mask 0x03).
- Obviously correct — follows well-established patterns used dozens of
  times in this driver.
- Minimal regression risk — only affects devices with PCI SSID
  0x1022:0xc950.
- Takashi Iwai noted a minor inefficiency (extra GPIO write from
  `alc_auto_init_amp`) but accepted the patch as-is, planning cleanup
  later.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
- The ALC662 quirk infrastructure has been in the kernel for many years.
  The file was recently split from `sound/pci/hda/patch_realtek.c` in
  commit `aeeb85f26c3bb` (July 2025, kernel 7.0-rc cycle), which was
  itself moved from `sound/pci/hda/` to `sound/hda/codecs/` in
  `6014e9021b28e`.
- The ALC662 fixup enum and table existed in `patch_realtek.c` long
  before the split.

**Step 3.2: No Fixes: tag** — expected for a quirk addition.

**Step 3.3: File History**
- Recent changes are all quirk additions — this is a very common pattern
  for this file.
- The author (Zhang Heng) has contributed many similar quirks: Acer
  Swift, HP Laptop, ASUS ROG, Lenovo Yoga, etc.

**Step 3.4: Author**
- Zhang Heng is a prolific Realtek quirk contributor with 10+ similar
  commits in the tree.

**Step 3.5: Dependencies**
- This is fully standalone. Uses only existing APIs
  (`alc_update_gpio_data`, `alc_spec`).
- For stable trees (6.x), the patch would need to target
  `sound/pci/hda/patch_realtek.c` instead. The functions and structures
  are identical there (verified: `alc_update_gpio_data` appears 14 times
  in pre-split `patch_realtek.c`).

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: Patch Discussion**
- Found full discussion on patchew.org. Takashi Iwai reviewed the patch
  and asked about the necessity of setting `gpio_mask`/`gpio_dir` in
  `PRE_PROBE`. He proposed a cleaner GPIO helper approach.
- Despite reservations about minor inefficiency, Iwai explicitly stated:
  *"I'm going to take your patch for now, but we might need to
  reconsider the implementation"*.
- The patch was accepted as v1, no subsequent versions.

**Step 4.2: Reviewers**
- Takashi Iwai (ALSA subsystem maintainer) directly reviewed and applied
  it.

**Step 4.3: Bug Report**
- Bugzilla #221258 — user tested with `hda-verb` commands setting GPIO
  mask, direction, and data to confirm the workaround works. The user's
  manual commands were:
  - SET_GPIO_MASK 0x03, SET_GPIO_DIRECTION 0x03, SET_GPIO_DATA 0x03,
    then toggle

**Step 4.4: Series Context**
- Single standalone patch, not part of a series.

**Step 4.5: Stable Discussion**
- No explicit stable nomination found, but audio quirks are routinely
  backported.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions**
- New: `alc662_fixup_csl_amp` — only called via the fixup framework for
  matching PCI SSID
- Uses: `alc_update_gpio_data` (well-tested existing function, used 14+
  times across the driver)

**Step 5.2: Callers**
- Called only by the HDA fixup framework when a device with PCI SSID
  0x1022:0xc950 is detected.

**Step 5.3-5.5**: The function follows an identical pattern to
`alc245_fixup_hp_x360_amp`, which is well-established and proven.

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

**Step 6.1: Buggy Code in Stable**
- The ALC662 codec support exists in all stable trees. The
  `alc662_fixups[]` table and `alc662_fixup_tbl[]` quirk table have been
  present since early kernel versions.
- The functions used (`alc_update_gpio_data`, `msleep`, etc.) exist in
  all active stable trees.

**Step 6.2: Backport Complications**
- **Key issue**: In 7.0, the driver was split into
  `sound/hda/codecs/realtek/alc662.c`. In stable 6.x trees, the
  equivalent code lives in `sound/pci/hda/patch_realtek.c`. The patch
  will need path adjustment but the code structures are identical.
- Record: Minor mechanical adjustment needed for file path; code applies
  cleanly to older structure.

**Step 6.3: No related fixes already in stable.**

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1**: Subsystem is ALSA/HDA (audio). Criticality: IMPORTANT —
audio is essential for desktop/laptop users.

**Step 7.2**: Very actively developed — constant quirk additions for new
hardware.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Who is Affected**
- Users of CSL Unity BF24B all-in-one PCs. Without this quirk, they have
  **zero audio output**.

**Step 8.2: Trigger Conditions**
- Every boot, every resume from suspend. Audio is completely non-
  functional without the quirk.

**Step 8.3: Failure Mode Severity**
- Complete loss of audio functionality on the device. Severity: HIGH for
  affected users.

**Step 8.4: Risk-Benefit Ratio**
- BENEFIT: High — enables audio on a specific PC model that has zero
  sound without it
- RISK: Very low — 25 lines, only affects one PCI SSID, follows proven
  patterns, reviewed by subsystem maintainer
- Ratio: Strongly favorable

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence Summary**
- FOR: Hardware quirk for broken audio; user-filed bugzilla; subsystem
  maintainer reviewed and applied; follows identical pattern to existing
  quirks; small and surgical; standalone
- AGAINST: File path needs adjustment for stable (mechanical); Takashi
  noted minor inefficiency (but accepted anyway)
- UNRESOLVED: Could not access bugzilla directly (anti-bot protection),
  but bug context confirmed through mailing list discussion

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? **YES** — follows proven pattern,
   reviewed by maintainer, tested by user with hda-verb
2. Fixes a real bug? **YES** — zero audio output on specific hardware
3. Important issue? **YES** — complete loss of audio functionality
4. Small and contained? **YES** — 25 lines in one file
5. No new features or APIs? **YES** — only a device-specific workaround
6. Can apply to stable? **YES** — needs file path adjustment but code is
   compatible

**Step 9.3: Exception Category**
- This is a textbook **HARDWARE QUIRK/WORKAROUND** — explicitly listed
  as a YES exception for stable.

## Verification

- [Phase 1] Parsed tags: Link to bugzilla.kernel.org #221258, signed off
  by Takashi Iwai (ALSA maintainer)
- [Phase 2] Diff analysis: 25 lines added — new fixup function, enum
  entry, fixup table entry, quirk table entry
- [Phase 2] Pattern match: `alc662_fixup_csl_amp` is nearly identical to
  `alc245_fixup_hp_x360_amp` at alc269.c:1448-1465
- [Phase 3] git log: file split from `patch_realtek.c` in aeeb85f26c3bb
  (Jul 2025), previously moved in 6014e9021b28e
- [Phase 3] git log --author: Zhang Heng has 10+ similar quirk commits
  in this tree
- [Phase 3] Verified `alc_update_gpio_data` exists 14 times in pre-split
  `patch_realtek.c`
- [Phase 4] Patchew.org: full discussion retrieved; Takashi reviewed,
  questioned PRE_PROBE gpio_mask but accepted patch
- [Phase 4] Takashi Iwai explicitly stated: "I'm going to take your
  patch for now"
- [Phase 4] User tested with hda-verb commands confirming GPIO toggle
  enables audio
- [Phase 5] `alc_update_gpio_data` is a well-tested exported function
  used across the driver
- [Phase 6] ALC662 support and fixup infrastructure exist in all active
  stable trees
- [Phase 6] Backport needs path adjustment:
  `sound/hda/codecs/realtek/alc662.c` → `sound/pci/hda/patch_realtek.c`
- [Phase 8] Failure mode: complete audio loss on affected hardware,
  severity HIGH
- UNVERIFIED: Could not directly access bugzilla #221258 (anti-bot
  protection), but context confirmed via mailing list

This is a textbook hardware quirk addition — small, self-contained,
fixes complete audio failure on a specific device, follows proven
patterns, reviewed and signed off by the subsystem maintainer. It falls
directly into the "quirks and workarounds" exception category that is
automatically appropriate for stable.

**YES**

 sound/hda/codecs/realtek/alc662.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc662.c b/sound/hda/codecs/realtek/alc662.c
index 5073165d1f3cf..3abe41c7315c4 100644
--- a/sound/hda/codecs/realtek/alc662.c
+++ b/sound/hda/codecs/realtek/alc662.c
@@ -255,6 +255,25 @@ static void alc_fixup_headset_mode_alc668(struct hda_codec *codec,
 	alc_fixup_headset_mode(codec, fix, action);
 }
 
+static void alc662_fixup_csl_amp(struct hda_codec *codec,
+				 const struct hda_fixup *fix, int action)
+{
+	struct alc_spec *spec = codec->spec;
+
+	switch (action) {
+	case HDA_FIXUP_ACT_PRE_PROBE:
+		spec->gpio_mask |= 0x03;
+		spec->gpio_dir |= 0x03;
+		break;
+	case HDA_FIXUP_ACT_INIT:
+		/* need to toggle GPIO to enable the amp */
+		alc_update_gpio_data(codec, 0x03, true);
+		msleep(100);
+		alc_update_gpio_data(codec, 0x03, false);
+		break;
+	}
+}
+
 enum {
 	ALC662_FIXUP_ASPIRE,
 	ALC662_FIXUP_LED_GPIO1,
@@ -313,6 +332,7 @@ enum {
 	ALC897_FIXUP_HEADSET_MIC_PIN2,
 	ALC897_FIXUP_UNIS_H3C_X500S,
 	ALC897_FIXUP_HEADSET_MIC_PIN3,
+	ALC662_FIXUP_CSL_GPIO,
 };
 
 static const struct hda_fixup alc662_fixups[] = {
@@ -766,11 +786,16 @@ static const struct hda_fixup alc662_fixups[] = {
 			{ }
 		},
 	},
+	[ALC662_FIXUP_CSL_GPIO] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc662_fixup_csl_amp,
+	},
 };
 
 static const struct hda_quirk alc662_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1019, 0x9087, "ECS", ALC662_FIXUP_ASUS_MODE2),
 	SND_PCI_QUIRK(0x1019, 0x9859, "JP-IK LEAP W502", ALC897_FIXUP_HEADSET_MIC_PIN3),
+	SND_PCI_QUIRK(0x1022, 0xc950, "CSL Unity BF24B", ALC662_FIXUP_CSL_GPIO),
 	SND_PCI_QUIRK(0x1025, 0x022f, "Acer Aspire One", ALC662_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x1025, 0x0241, "Packard Bell DOTS", ALC662_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x1025, 0x0308, "Acer Aspire 8942G", ALC662_FIXUP_ASPIRE),
-- 
2.53.0

