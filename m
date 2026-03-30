Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C4A3D6CC9;
	Mon, 30 Mar 2026 12:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774874361; cv=none; b=uJ8GWdajbFZ9qJNfTBxyi+xWsMvMUJ3ClsStFsAnnzrYAyDMS0blhqUawCTD9zmW/MlS29MBLOoRtLy3hT9hsKrD55Z1s0VSWTVHBckqNmX5BB9BBnEBuUTmnI33+tnHMS0bXp8fyfeQdz1PwsjNMG9THmwQvGva36A7peH8Wes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774874361; c=relaxed/simple;
	bh=5Pdd8yLOMv3471im8UggH0DhOwKraODQLUn4mNiK+FY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b1p2OgWDR0hsxW52FT/fXzN9XPXKk2OT0QHqg4040K9qF1P8eJMW0L+kdmFnFDP2LdzIRtendrU/lA/b9eAqUXjV7Yam3QL626kzROu0988S+B8/GdpN/+Rg14z/9WClBG3G8Htmnu/9uWb3Uni9TZITHQC3CvGi09E4Ndb7WD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EBJdlRx+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EBJdlRx+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D4FC2BCB1;
	Mon, 30 Mar 2026 12:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774874360;
	bh=5Pdd8yLOMv3471im8UggH0DhOwKraODQLUn4mNiK+FY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EBJdlRx+KIut49PKUA6TsdKWnecAngw7WCJ0M7YMwOhF1lfuwxT+4+H4KQx8v2RXr
	 85GRAJ8IeAgzNuKwtd2q5W33aMSNmYDtmDKf3cPDxGWEl2zFeLcOlYm8cd3gVCP1Mq
	 uwXPGuETB5z/Y4euS4nNrjjd2/S1xTjDuGqw6WJFW7hPJK0ycxfqAdUCu1iDM2i7aR
	 MIWnOIgkQN0flrl7VHeKMCZdrJoMGg/Fj5BT8YS9Umjmuh3zA6Vozz+BXu3z67QKQr
	 wkaTZ4y/h0pTOZ0jz6GwkO6CZk6Dajzzf/QIWgQjcdLcnDkJKGEGHtOwRqIpSXpKmq
	 ej4jJlVB8Xt8g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Matthew Schwartz <matthew.schwartz@linux.dev>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.6] ALSA: hda/realtek: Add quirk for ASUS ROG Flow Z13-KJP GZ302EAC
Date: Mon, 30 Mar 2026 08:38:39 -0400
Message-ID: <20260330123842.756154-26-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330123842.756154-1-sashal@kernel.org>
References: <20260330123842.756154-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.10
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matthew Schwartz <matthew.schwartz@linux.dev>

[ Upstream commit 59f68dc1d8df3142cb58fd2568966a9bb7b0ed8a ]

Fixes lack of audio output on the ASUS ROG Flow Z13-KJP GZ302EAC model,
similar to the ASUS ROG Flow Z13 GZ302EA.

Signed-off-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Link: https://patch.msgid.link/20260313172503.285846-1-matthew.schwartz@linux.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: No function bodies modified. The change is purely data — one
entry in the `alc269_fixup_tbl[]` static quirk table.

**Step 5.2: TRACE CALLERS**
Record: `alc269_fixup_tbl[]` is consumed by `snd_hda_pick_fixup()`
during `alc269_probe()`, which is the `.probe` callback in
`alc269_codec_ops`. This runs during HDA codec initialization — a
standard device-probe path.

**Step 5.3: TRACE CALLEES**
Record: `[ALC287_FIXUP_CS35L41_I2C_2]` at line 6200 maps to
`cs35l41_fixup_i2c_two()` (line 3231), which calls
`comp_generic_fixup(cdc, action, "i2c", "CSC3551",
"-%s:00-cs35l41-hda.%d", 2)` — initializing two CS35L41 companion
amplifiers over I2C.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: HDA codec driver registration → `alc269_probe()` →
`snd_hda_pick_fixup(... alc269_fixup_tbl ...)` → SSID match selects
fixup → `snd_hda_apply_fixup(HDA_FIXUP_ACT_PRE_PROBE)` →
`cs35l41_fixup_i2c_two()` → `comp_generic_fixup()` →
`hda_component_manager_init()` for two CSC3551 amps. This is reached
automatically during boot on affected hardware — not an obscure or debug
path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: `ALC287_FIXUP_CS35L41_I2C_2` appears 113 times in this file. The
sibling ASUS ROG Flow Z13 GZ302EA at line 7284 uses the exact same fixup
(`0x1043:0x1fb3 → ALC287_FIXUP_CS35L41_I2C_2`). This is a thoroughly
proven pattern.

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

**Step 6.1: DOES THE BUGGY CODE EXIST IN STABLE TREES?**
Record: Verified via `git grep`:
- **v6.6**: `ALC287_FIXUP_CS35L41_I2C_2` exists in
  `sound/pci/hda/patch_realtek.c` — applicable
- **v6.1**: `ALC287_FIXUP_CS35L41_I2C_2` exists in
  `sound/pci/hda/patch_realtek.c` — applicable
- **v5.15**: `ALC287_FIXUP_CS35L41_I2C_2` does NOT exist — **not
  applicable** without prerequisite work

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Mainline has moved the code from `sound/pci/hda/patch_realtek.c`
to `sound/hda/codecs/realtek/alc269.c` (file split). Backports to v6.6
and v6.1 will need a trivial path adjustment. The actual change is still
a single `SND_PCI_QUIRK` line insertion in the same quirk table — only
context lines and file path differ. Expected difficulty:
**minor/trivial**.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY IN STABLE**
Record: The `0x1514` SSID entry does not exist in the current tree
(confirmed by grep). The sibling `0x1fb3` (GZ302EA) commit
`12784ca33b62f` is also not in v6.6, v6.1, or v5.15.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: Subsystem: sound/HDA/Realtek codec. Criticality: IMPORTANT —
audio is a core laptop function. While hardware-specific, this affects
all users of this specific ASUS model.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Highly active — the recent 20 commits are exclusively quirk
additions and small fixes. This is normal and expected for the Realtek
HDA quirk table.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Owners of ASUS ROG Flow Z13-KJP GZ302EAC laptops using in-kernel
HDA Realtek audio. Hardware-specific / driver-specific population.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Every boot — the missing quirk causes incorrect codec
initialization automatically during probe. No special user action
required. Deterministic on affected hardware.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Complete lack of audio output on the affected laptop. Severity:
**HIGH** for affected users — a core hardware function
(speakers/headphones) is entirely non-functional. Not a crash or
security issue, but a complete functional failure of essential hardware.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit**: HIGH for affected users — restores audio functionality on
  a real, shipping laptop
- **Risk**: NEAR-ZERO — one line, SSID-gated (only matches
  0x1043:0x1514), reuses a well-established fixup used by 113 entries
- **Ratio**: Strongly favorable

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

Evidence FOR backporting:
- Fixes complete lack of audio output on a real shipping laptop
- Falls into the explicit "Audio Codec Quirks" exception category —
  automatic YES
- One line added — minimal possible change
- Uses existing, heavily-tested fixup (`ALC287_FIXUP_CS35L41_I2C_2`, 113
  occurrences)
- Sibling model (GZ302EA) uses identical fixup, establishing the pattern
- Accepted by subsystem maintainer Takashi Iwai
- Included in the sound fixes pull for 7.0-rc6
- Applicable to v6.6 and v6.1 stable trees (prerequisite support
  verified)

Evidence AGAINST backporting:
- Not applicable to v5.15 (missing prerequisite fixup infrastructure)
- File path has changed between mainline and stable (minor backport
  friction)
- No explicit Tested-by in this commit (though the sibling commit
  `12784ca33b62f` had one)

Unresolved:
- Takashi Iwai's exact reply content (could not fetch)
- Whether any stable reviewer has already discussed this patch

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. **Obviously correct and tested?** YES — trivial table entry matching
   established pattern, maintainer-accepted
2. **Fixes a real bug that affects users?** YES — no audio output on
   affected hardware
3. **Important issue?** YES — total loss of audio on a laptop
4. **Small and contained?** YES — 1 line, 1 file, data-only change
5. **No new features or APIs?** YES — quirk table entry only, no
   behavioral changes outside targeted SSID
6. **Can apply to stable trees?** YES for v6.1+ and v6.6+ (with path
   adjustment); NO for v5.15

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **Hardware quirk / Audio Codec Quirk** — `SND_PCI_QUIRK` entry
in the Realtek HDA codec quirk table. This is explicitly in the
automatic YES exception category.

**Step 9.4: MAKE YOUR DECISION**
This is a textbook stable backport candidate. It is a single-line audio
codec quirk addition that restores audio output on a specific ASUS
laptop model using an existing, widely-deployed fixup. It carries near-
zero regression risk and falls squarely into the hardware quirk
exception category.

## Verification

- [Phase 1] Parsed subject/body/tags from the provided commit message;
  found Signed-off-by (author + maintainer) and Link; no Fixes/Reported-
  by/Cc:stable — expected
- [Phase 2] Diff is exactly +1 line: `SND_PCI_QUIRK(0x1043, 0x1514,
  "ASUS ROG Flow Z13 GZ302EAC", ALC287_FIXUP_CS35L41_I2C_2)`
- [Phase 2] Confirmed `ALC287_FIXUP_CS35L41_I2C_2` appears 113 times in
  `alc269.c` — well-established fixup
- [Phase 3] `grep -n '0x1514'` returned no matches — SSID not yet in
  tree
- [Phase 3] `grep -n '0x1fb3'` confirmed sibling GZ302EA at line 7284
  uses identical fixup
- [Phase 3] `git log --follow -S'0x1fb3'` traced sibling to commit
  `12784ca33b62f` ("Fix Asus Z13 2025 audio")
- [Phase 3] `git show 12784ca33b62f` confirmed it adds 0x1043:0x1fb3 →
  ALC287_FIXUP_CS35L41_I2C_2, with Tested-by tag
- [Phase 3] `git log --author="Matthew Schwartz" -10 -- sound/` found
  one related commit (`b7e26c8bdae70`)
- [Phase 4] yhbt.net mirror confirmed standalone [PATCH] posted
  2026-03-13, Takashi Iwai replied 2026-03-14, included in sound fixes
  pull 2026-03-27
- [Phase 4] lore.kernel.org blocked by Anubis; used yhbt.net mirror as
  alternative
- [Phase 5] Verified `[ALC287_FIXUP_CS35L41_I2C_2]` at line 6200 maps to
  `cs35l41_fixup_i2c_two()` → `comp_generic_fixup(... "i2c", "CSC3551",
  ..., 2)`
- [Phase 5] Traced call chain: `alc269_probe()` → `snd_hda_pick_fixup()`
  → `snd_hda_apply_fixup()` → `cs35l41_fixup_i2c_two()`
- [Phase 6] `git grep` against v6.6: `ALC287_FIXUP_CS35L41_I2C_2`
  present in `sound/pci/hda/patch_realtek.c`
- [Phase 6] `git grep` against v6.1: `ALC287_FIXUP_CS35L41_I2C_2`
  present in `sound/pci/hda/patch_realtek.c`
- [Phase 6] `git grep` against v5.15: `ALC287_FIXUP_CS35L41_I2C_2`
  **absent** — not applicable to this tree
- [Phase 6] Identified file path change: mainline uses
  `sound/hda/codecs/realtek/alc269.c`, stable uses
  `sound/pci/hda/patch_realtek.c`
- [Phase 8] Failure mode: complete loss of audio output — severity HIGH
  for affected hardware users
- UNVERIFIED: Exact content of Takashi Iwai's reply (message not
  fetchable from mirrors)
- UNVERIFIED: Whether stable mailing list has prior discussion of this
  specific commit

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index b83f0c4bec142..75f880efdeaf1 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7206,6 +7206,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x14e3, "ASUS G513PI/PU/PV", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x14f2, "ASUS VivoBook X515JA", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1503, "ASUS G733PY/PZ/PZV/PYV", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x1043, 0x1514, "ASUS ROG Flow Z13 GZ302EAC", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1517, "Asus Zenbook UX31A", ALC269VB_FIXUP_ASUS_ZENBOOK_UX31A),
 	SND_PCI_QUIRK(0x1043, 0x1533, "ASUS GV302XA/XJ/XQ/XU/XV/XI", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1573, "ASUS GZ301VV/VQ/VU/VJ/VA/VC/VE/VVC/VQC/VUC/VJC/VEC/VCC", ALC285_FIXUP_ASUS_HEADSET_MIC),
-- 
2.53.0

