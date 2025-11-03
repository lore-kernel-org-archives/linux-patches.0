Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D747631D384;
	Mon,  3 Nov 2025 18:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762193000; cv=none; b=ephbMnfhE8RcczBSNWJCXKTgfYn6cb/VF2RDBRnuNoqhmb4dYGCLPjVo05reEQGVfek1GBqNRVPZoGZYrKDhDrI0i3hwPMmqXOm9G8N9rU/e1O2XmWZIM0HpsfG8MUjpNB5IwIi9l5LyA9efHuA9BVJkvcfxsaBf8ijrm72yRcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762193000; c=relaxed/simple;
	bh=KHG12lkQ137rzYx9xJBzwHxsq4Stjb3+pgvjt5F9Ee0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OJKxbJ3YkN/VN8J5af7Y0qNt5HljURMXUdswm0PllehvEQfwtEzuf80rjMq/OhDjlpfM2vMzb8+t0fVXABM2de1xs63ym7R5zfn8M9387xjdtechoZMB+FOxWoGY+eEZHdClAGdmvOLq3JMT41X1mU3LynALymwQ93Fm67+UOWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B8n8CrIr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B8n8CrIr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCBD2C4CEE7;
	Mon,  3 Nov 2025 18:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762193000;
	bh=KHG12lkQ137rzYx9xJBzwHxsq4Stjb3+pgvjt5F9Ee0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B8n8CrIryp8UaZf95wV2IIV1p7AabLklH3HXD6qzaC0WxHqoOVm3FrGjwBRNufQiw
	 8DO1Hf0LEH6z2YTMQO09A+FXJkjgoXhy3EjrCH68RmNbII638mS2GBDXt7e5LU30tx
	 knlUTlaBs34NPPsEZds+3nHYgdMgGuNAYJ4rMB1ydqNPel+V/YDGt3rEcVmN84qRpV
	 ZkZcGoscxa+PBqxBtpdR2gRX3FbObcdYT+ZcjQkGxXeJiiRc6cCr/UYf6R12WyQkUN
	 sG6dEbGj5rQ08H91WYHpKPEAKXk1aAxU4OnYmeoo2qt6w8kFiyqsxz6T++po6e0jEZ
	 mZAXmdpVoY8EA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Eren Demir <eren.demir2479090@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	kailang@realtek.com,
	sbinding@opensource.cirrus.com,
	chris.chiu@canonical.com,
	edip@medip.dev
Subject: [PATCH AUTOSEL 6.17] ALSA: hda/realtek: Fix mute led for HP Victus 15-fa1xxx (MB 8C2D)
Date: Mon,  3 Nov 2025 13:02:29 -0500
Message-ID: <20251103180246.4097432-16-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251103180246.4097432-1-sashal@kernel.org>
References: <20251103180246.4097432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eren Demir <eren.demir2479090@gmail.com>

[ Upstream commit 28935ee5e4789ad86c08ba9f2426edd6203d13fa ]

The quirk for Victus 15-fa1xxx wasn't working on Victus 15-fa1031nt due to a different board id. This patch enables the existing quirk for the board id 8BC8.

Tested on HP Victus 15-fa1031nt (MB 8C2D). The LED behaviour works as intended.

Signed-off-by: Eren Demir <eren.demir2479090@gmail.com>
Link: https://patch.msgid.link/20251027110208.6481-1-eren.demir2479090@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## BACKPORT ANALYSIS COMPLETE

**RECOMMENDATION: YES**

### Summary
This commit should be backported to stable kernel trees (v6.15 and
later).

### Detailed Analysis

#### 1. SEMANTIC CODE ANALYSIS PERFORMED

**Tools Used:**
- `mcp__semcode__find_function`: Located the
  `alc245_fixup_hp_mute_led_coefbit` function
  (sound/hda/codecs/realtek/alc269.c:1524-1538)
- `mcp__semcode__find_callers`: Found 3 functions that call this fixup
- `mcp__semcode__find_calls`: Verified it only calls
  `snd_hda_gen_add_mute_led_cdev`
- `mcp__semcode__grep_functions`: Confirmed the quirk table usage
- `Read` and `Grep`: Examined the quirk table structure and fixup
  implementation
- `git log` and `git show`: Traced the history of the fixup and related
  commits

**Findings:**
- The fixup function `alc245_fixup_hp_mute_led_coefbit` was introduced
  in v6.15 (commit 22c7f77247a8)
- It's a simple function that configures mute LED coefficient values
  during HDA_FIXUP_ACT_PRE_PROBE
- The function has been stable and well-tested across multiple HP Victus
  laptop models

#### 2. CHANGE SCOPE ANALYSIS

**Code Changes:**
- **Location**: sound/hda/codecs/realtek/alc269.c:6578
- **Change**: Adds ONE line to the quirk table:
  ```c
  SND_PCI_QUIRK(0x103c, 0x8c2d, "HP Victus 15-fa1xxx (MB 8C2D)",
  ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
  ```
- **Pattern**: Follows established pattern used for 10+ other HP Victus
  models (0x8bbe, 0x8bc8, 0x8bd4, 0x8c30, 0x8c99, 0x8c9c, 0x8d07, etc.)

#### 3. IMPACT ANALYSIS

**Affected Hardware:**
- Only affects HP Victus 15-fa1031nt laptops with motherboard ID 8C2D
  (PCI ID 0x103c:0x8c2d)
- Zero impact on other hardware

**User-Visible Impact:**
- **Without patch**: Mute LED indicator does not work on this specific
  laptop model
- **With patch**: Mute LED functions correctly as intended

**Call Graph Analysis:**
- The quirk is processed during `alc269_probe()` at device
  initialization
- Uses existing, stable fixup infrastructure
- No new code paths introduced

#### 4. DEPENDENCY ANALYSIS

**Required Dependencies:**
- ✅ `alc245_fixup_hp_mute_led_coefbit` function (available since v6.15)
- ✅ `snd_hda_gen_add_mute_led_cdev` function (available since v6.15)
- ✅ Quirk table infrastructure (available for many years)
- ✅ `coef_mute_led_set` callback (available since v6.15)

**Minimum Kernel Version:** v6.15 (when the fixup function was
introduced)

#### 5. RISK ASSESSMENT

**Risk Level: VERY LOW**

Justification:
1. **Isolated change**: Only one line added to a static quirk table
2. **Hardware-specific**: Only affects one laptop model variant
3. **Proven pattern**: Same fixup used successfully for 10+ similar HP
   models
4. **No architectural changes**: Uses existing infrastructure
5. **Well-tested**: Author tested on actual hardware (HP Victus
   15-fa1031nt)
6. **No side effects**: Change cannot affect other hardware

#### 6. STABLE TREE COMPLIANCE

✅ **Fixes important bug**: Mute LED not working is a user-visible
regression
✅ **Small and self-contained**: One-line change
✅ **No new features**: Just enables existing functionality for new
hardware
✅ **No architectural changes**: Pure quirk addition
✅ **Low regression risk**: Hardware-specific, well-tested pattern
✅ **Already upstream**: Merged in v6.18-rc4
❌ **Cc: stable tag**: Not present in commit message (minor issue)

#### 7. SIMILAR COMMITS

Recent similar commits that were backported:
- `a9dec0963187`: Fix mute LED for HP Victus 16-d1xxx (MB 8A26)
- `956048a3cd9d`: Fix mute LED for HP Victus 16-s0xxx (MB 8BD4)
- `bd7814a4c0fd`: Fix mute LED for HP Victus 16-r1xxx (MB 8C99)

All follow the same pattern and demonstrate this is a well-established
practice.

### CONCLUSION

This commit is an **excellent candidate for backporting** to stable
kernel trees (v6.15+). It fixes a real user-facing bug (non-functional
mute LED) with minimal code change, zero risk to other systems, and
follows an established pattern that has been successfully used for
numerous similar laptop models.

**Suggested stable kernel targets:** v6.15.x, v6.16.x, v6.17.x

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index a3764d71b5fcc..de69332ced8e3 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6570,6 +6570,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8c16, "HP Spectre x360 2-in-1 Laptop 16-aa0xxx", ALC245_FIXUP_HP_SPECTRE_X360_16_AA0XXX),
 	SND_PCI_QUIRK(0x103c, 0x8c17, "HP Spectre 16", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8c21, "HP Pavilion Plus Laptop 14-ey0XXX", ALC245_FIXUP_HP_X360_MUTE_LEDS),
+	SND_PCI_QUIRK(0x103c, 0x8c2d, "HP Victus 15-fa1xxx (MB 8C2D)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8c30, "HP Victus 15-fb1xxx", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8c46, "HP EliteBook 830 G11", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c47, "HP EliteBook 840 G11", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
-- 
2.51.0

