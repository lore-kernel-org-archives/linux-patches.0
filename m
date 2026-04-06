Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54236330B29;
	Mon,  6 Apr 2026 11:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775473600; cv=none; b=C6eC5xU7LdtAIUomiXecOWIuQ5suJPDmBr/Q7MOCHnO2AumdhPVgvqgsfUqf4plTsSluLTgd0LsTo53O36i5L6oZ+rMbZIE4F4FWqftLcj8NJUFFvO6aVKzrP/fPUPaZlYXgVgtvUGD6jrQyOCdnG5u66bYM3+TD2H6BVJYIXOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775473600; c=relaxed/simple;
	bh=tlMz9JcqivmJKnCnmPCL0aF83JfpT6hSy90H5YINPc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SSxz4ehRWopSsoAgU2aMThxWcxh8gwh5OXZKxXeXYjIXwOWMSHBP7ASe2dvVVhOeWC3LXOoXI6Rou2vkDwVYUEGWbMzdUShIky/MkBQc95yLLuD5I6FA4KfrUjKW53f+WG0QaFUqL6ibKNl3zEEl+D/ht2DbtxoIPxOXErowYgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JBu1sfPe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JBu1sfPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2742AC2BC9E;
	Mon,  6 Apr 2026 11:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775473600;
	bh=tlMz9JcqivmJKnCnmPCL0aF83JfpT6hSy90H5YINPc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JBu1sfPeX0x9SIwTi5BmVUwDj2KIj4qlB8cUOmqgK5+BE6P0IRDbPrLULUvU+276b
	 z2p24xA4biZ4jDFF4E1zYkTUSdRb308YB2bP0b6CtqunKzVYfLAfXZ8jrvlX0xYTkW
	 tjN75lX7MI88dOjY19mE0X694Lmm+q4x423gwXXXkLPnPqcI4XNIKK5UI0w1nFyBKO
	 scdr76wlpeRfuZmoOocajK7AvnFL2Gm7i88ps/Ohc2l/1U3NGfZAZ/viv3Hw0SyXWk
	 oH19LtJ/jxnO2p0q2Il9cNulFPg4A6OMEOsmUINoz9rnoTjhvBh1uEZN6flWjPpbVR
	 46x+UJkqoIoVA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: songxiebing <songxiebing@kylinos.cn>,
	Garcicasti <andresgarciacastilla@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] ALSA: hda/realtek: Add quirk for Lenovo Yoga Slim 7 14AKP10
Date: Mon,  6 Apr 2026 07:05:43 -0400
Message-ID: <20260406110553.3783076-9-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406110553.3783076-1-sashal@kernel.org>
References: <20260406110553.3783076-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.11
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: songxiebing <songxiebing@kylinos.cn>

[ Upstream commit e6c888202297eca21860b669edb74fc600e679d9 ]

The Pin Complex 0x17 (bass/woofer speakers) is incorrectly reported as
unconnected in the BIOS (pin default 0x411111f0 = N/A). This causes the
kernel to configure speaker_outs=0, meaning only the tweeters (pin 0x14)
are used. The result is very low, tinny audio with no bass.

The existing quirk ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN (already present
in patch_realtek.c for SSID 0x17aa3801) fixes the issue completely.

Reported-by: Garcicasti <andresgarciacastilla@gmail.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=221298
Signed-off-by: songxiebing <songxiebing@kylinos.cn>
Link: https://patch.msgid.link/20260331033650.285601-1-songxiebing@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The fixup is well-established and used by 7+ other Lenovo models
already.

**Step 3.1-3.5 Summary:**
Record: [The fixup ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN is well-
established, used by 7+ other Lenovo models] [No dependencies]
[Standalone single-line addition] [Accepted by subsystem maintainer
Takashi Iwai]

## PHASE 4: EXTERNAL RESEARCH (abbreviated — clear-cut case)

The bugzilla link (bug 221298) and the Reported-by tag confirm this is a
real user-reported issue on a shipping Lenovo laptop.

Record: [Real user bug report on bugzilla.kernel.org] [Accepted by ALSA
maintainer]

## PHASE 5: CODE SEMANTIC ANALYSIS

The change is a single quirk table entry. The SND_PCI_QUIRK macro
matches on vendor/subsystem ID and applies the specified fixup. No new
functions, no logic changes.

Record: [Pure data table addition, no code flow analysis needed]

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1:** The `ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN` fixup has
existed since the Yoga 9 14IAP7 support was added. It's present in
stable trees.

**Step 6.2:** This is a single-line table insertion — it will apply
cleanly to any stable tree that has the surrounding entries. The
neighboring entries (0x390d and 0x3913) may or may not be present in
older stable trees, but the quirk table is order-independent for
matching, so minor conflicts are trivially resolvable.

Record: [Should apply cleanly or with trivial context adjustment] [The
referenced fixup exists in stable trees]

## PHASE 7: SUBSYSTEM CONTEXT

- Subsystem: ALSA/HDA (sound) — IMPORTANT level, affects laptop users
- Maintainer: Takashi Iwai (SUSE) — one of the most experienced and
  careful maintainers
Record: [ALSA/HDA] [IMPORTANT — audio on laptops] [Accepted by Takashi
Iwai]

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1:** Affects users of the Lenovo Yoga Slim 7 14AKP10 laptop.
**Step 8.2:** Triggers on every boot — the bass speakers simply don't
work without this quirk.
**Step 8.3:** Failure mode: degraded audio (no bass, tinny sound) —
MEDIUM severity but HIGH user impact since the laptop's speakers are
essentially broken.
**Step 8.4:**
- Benefit: HIGH — makes bass speakers work on a current Lenovo laptop
- Risk: VERY LOW — single table entry, only affects this specific SSID,
  uses proven fixup
Record: [Benefit: HIGH] [Risk: VERY LOW] [Excellent ratio]

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence FOR backporting:**
- Fixes real hardware issue (no bass speakers) on a shipping Lenovo
  laptop
- Real user bug report on bugzilla.kernel.org
- Single-line quirk table addition — zero regression risk
- Reuses existing, proven fixup used by 7+ other models
- Accepted by ALSA subsystem maintainer Takashi Iwai
- Falls squarely in the "hardware quirk" exception category

**Evidence AGAINST:** None.

**Step 9.2: Stable Rules Checklist:**
1. Obviously correct? YES — single SND_PCI_QUIRK entry reusing existing
   fixup
2. Fixes real bug? YES — bass speakers don't work
3. Important? YES — hardware broken without it
4. Small and contained? YES — 1 line
5. No new features/APIs? YES — just a quirk table entry
6. Can apply to stable? YES — trivial

**Step 9.3: Exception Category:** Hardware quirk/workaround — automatic
YES category.

**Step 9.4: Decision:** Clear YES.

## Verification

- [Phase 1] Parsed tags: Reported-by from real user, Link to bugzilla
  #221298, signed-off by Takashi Iwai (ALSA maintainer)
- [Phase 2] Diff analysis: +1 line, single SND_PCI_QUIRK entry in quirk
  table
- [Phase 3] Grep confirmed ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN exists
  at line 6355 and is used by 7+ other Lenovo models
- [Phase 3] git log confirmed recent active development on alc269.c
- [Phase 5] Pure data table entry, no code flow changes
- [Phase 6] The fixup definition exists in stable trees; single-line
  addition should apply cleanly
- [Phase 8] Failure mode: broken bass speakers on Lenovo laptop,
  severity MEDIUM-HIGH, risk VERY LOW

**YES**

 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 1e10af67fdb04..e55f57cca883a 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7633,6 +7633,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
 	SND_PCI_QUIRK(0x17aa, 0x390d, "Lenovo Yoga Pro 7 14ASP10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3913, "Lenovo 145", ALC236_FIXUP_LENOVO_INV_DMIC),
+	SND_PCI_QUIRK(0x17aa, 0x391a, "Lenovo Yoga Slim 7 14AKP10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x391f, "Yoga S990-16 pro Quad YC Quad", ALC287_FIXUP_TXNW2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3920, "Yoga S990-16 pro Quad VECO Quad", ALC287_FIXUP_TXNW2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3929, "Thinkbook 13x Gen 5", ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD),
-- 
2.53.0

