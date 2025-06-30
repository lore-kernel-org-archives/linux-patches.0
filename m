Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14A2280338;
	Mon, 30 Jun 2025 21:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751317206; cv=none; b=fCNtwYt+suLa7ZinTGCJEJ1SFvbVN6gkpHuTkLlW78f7bpf7HL0Th0jfcrbSL1rgdRxsB+eSQT1f/G7rFrM4qKpnUrCHNErUcM2CzM+oDsgjLjH62GPAW3c2emyvMKg/WGy0wtNizElGBVgy1QzP1MQgUaPgp3uXFIZMh7JAVLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751317206; c=relaxed/simple;
	bh=4QAnkKLTjEMNBWIwLiImIR4HAW7z87Q/ql2uxfDu+Pg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=L0fJTvy1KUIliXcLca9CQh+Q7CtAhmkEAhaAwicSoP3WgFHP3V7izb8w/ZfTE0JxbvKg8T3TjRxR0PfJt8DcHtWrc/RGzvqRur68hS6sID/IR30AtQqr58W8eXZfDAWWsdm/7K9H+z+uVDowkgfDO1dIBbXaDDJXX8UFWVVQl2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f/yUebMv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f/yUebMv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE62C4CEEB;
	Mon, 30 Jun 2025 21:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751317206;
	bh=4QAnkKLTjEMNBWIwLiImIR4HAW7z87Q/ql2uxfDu+Pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f/yUebMvW9l7QNdh1teNfzADQiCk3JuwdKuoTyAhgnngJ4XwL8+rcYEKkrF8BHt12
	 H1LeJKoMsmKwY5eABbn7ekv5vM5jm9ZOTj1evi5/C7gnhuThw2TNmqe7ZMy3QB5XiZ
	 ffys0VPUfUCKlYgD7VZIk3ktv7CnP3s3hnSmE1kSEIfZ+MpWK5J3yzxkif+sSgAdha
	 0S5TXBSdrWPCkwq7y5gwDFjoNAYnVPNHu0tkXwV5WBb0KK9EIayAYGHghmZg4/0UOQ
	 P7HIV5S2NuK82lTBuGtAEkcqzgCWJKShoG2dw8JUgpIfNAh/ZnayyZTHW46l1sGtP7
	 gxwzNlqJHfg0A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tim Crawford <tcrawford@system76.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	kailang@realtek.com,
	sbinding@opensource.cirrus.com,
	chris.chiu@canonical.com,
	simont@opensource.cirrus.com,
	josh@joshuagrisham.com
Subject: [PATCH AUTOSEL 6.12 10/21] ALSA: hda/realtek: Add quirks for some Clevo laptops
Date: Mon, 30 Jun 2025 16:45:25 -0400
Message-Id: <20250630204536.1358327-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250630204536.1358327-1-sashal@kernel.org>
References: <20250630204536.1358327-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.35
Content-Transfer-Encoding: 8bit

From: Tim Crawford <tcrawford@system76.com>

[ Upstream commit e41687b511d5e5437db5d2151e23c115dba30411 ]

Add audio quirks to fix speaker output and headset detection on the
following Clevo models:

- V350ENC
- V350WNPQ
- V540TU
- X560WNR
- X580WNS

Signed-off-by: Tim Crawford <tcrawford@system76.com>
Link: https://patch.msgid.link/20250620204329.35878-1-tcrawford@system76.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Commit Analysis

This commit adds audio quirks for five Clevo laptop models to fix
speaker output and headset detection issues. The changes are:

1. **For ALC1220 codec** (in `alc882_fixup_tbl[]`):
   - `SND_PCI_QUIRK(0x1558, 0x5802, "Clevo X58[05]WN[RST]",
     ALC1220_FIXUP_CLEVO_PB51ED_PINS)`
   - This covers models X580WNR and X580WNS

2. **For ALC256/ALC245 codecs** (in `alc269_fixup_tbl[]`):
   - `SND_PCI_QUIRK(0x1558, 0x35a1, "Clevo V3[56]0EN[CDE]",
     ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE)`
   - `SND_PCI_QUIRK(0x1558, 0x35b1, "Clevo V3[57]0WN[MNP]Q",
     ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE)`
   - `SND_PCI_QUIRK(0x1558, 0x5700, "Clevo X560WN[RST]",
     ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE)`
   - `SND_PCI_QUIRK(0x1558, 0xa743, "Clevo V54x_6x_TU",
     ALC245_FIXUP_CLEVO_NOISY_MIC)`
   - These cover models V350ENC, V350WNPQ, V540TU, and X560WNR

## Reasons for Backporting

1. **Essential Hardware Enablement**: Without these quirks, audio
   functionality (speakers and headset) won't work properly on these
   laptop models. This severely impacts user experience.

2. **Minimal Risk**: The changes only add new PCI ID entries to existing
   quirk tables. They don't modify any core logic or affect other
   hardware models. Each quirk only activates when the specific PCI ID
   is detected.

3. **Follows Established Pattern**: All five similar historical commits
   for Clevo audio quirks were backported to stable, including:
   - Commits for L240TU, PE60SNE-G, V350SNEQ (Similar Commit #1)
   - Commits for L140PU, L140AU (Similar Commits #2, #3)
   - Commits for PC70HS, PD70PNT (Similar Commits #4, #5)

4. **Small, Contained Changes**: The patch adds only 5 lines of code,
   all following the standard `SND_PCI_QUIRK` macro pattern already used
   extensively in the file.

5. **Meets Stable Criteria**: According to stable kernel rules, this
   qualifies as:
   - A real bug fix (broken audio)
   - Obviously correct and tested
   - Small change (< 100 lines)
   - Fixes a problem that bothers people

6. **No Architecture Changes**: The commit uses existing fixup
   mechanisms (`ALC1220_FIXUP_CLEVO_PB51ED_PINS`,
   `ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE`,
   `ALC245_FIXUP_CLEVO_NOISY_MIC`) without introducing new
   functionality.

## Technical Details

The quirks apply model-specific fixes:
- `ALC1220_FIXUP_CLEVO_PB51ED_PINS`: Configures pin settings for proper
  speaker output on ALC1220-based models
- `ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE`: Fixes headset detection on
  ALC256-based models
- `ALC245_FIXUP_CLEVO_NOISY_MIC`: Addresses microphone noise issues on
  ALC245-based models

These are well-tested fixups already used by other Clevo models,
reducing the risk of unexpected behavior.

 sound/pci/hda/patch_realtek.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index e6eb01d8e35a8..695b84abd985d 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2658,6 +2658,7 @@ static const struct hda_quirk alc882_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x147b, 0x107a, "Abit AW9D-MAX", ALC882_FIXUP_ABIT_AW9D_MAX),
 	SND_PCI_QUIRK(0x1558, 0x3702, "Clevo X370SN[VW]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x50d3, "Clevo PC50[ER][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
+	SND_PCI_QUIRK(0x1558, 0x5802, "Clevo X58[05]WN[RST]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x65d1, "Clevo PB51[ER][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x65d2, "Clevo PB51R[CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x65e1, "Clevo PB51[ED][DF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
@@ -11044,6 +11045,8 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1558, 0x14a1, "Clevo L141MU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x2624, "Clevo L240TU", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x28c1, "Clevo V370VND", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1558, 0x35a1, "Clevo V3[56]0EN[CDE]", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0x35b1, "Clevo V3[57]0WN[MNP]Q", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x4018, "Clevo NV40M[BE]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x4019, "Clevo NV40MZ", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x4020, "Clevo NV40MB", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
@@ -11071,6 +11074,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1558, 0x51b1, "Clevo NS50AU", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x51b3, "Clevo NS70AU", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x5630, "Clevo NP50RNJS", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0x5700, "Clevo X560WN[RST]", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x70a1, "Clevo NB70T[HJK]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x70b3, "Clevo NK70SB", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x70f2, "Clevo NH79EPY", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
@@ -11110,6 +11114,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1558, 0xa650, "Clevo NP[567]0SN[CD]", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0xa671, "Clevo NP70SN[CDE]", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0xa741, "Clevo V54x_6x_TNE", ALC245_FIXUP_CLEVO_NOISY_MIC),
+	SND_PCI_QUIRK(0x1558, 0xa743, "Clevo V54x_6x_TU", ALC245_FIXUP_CLEVO_NOISY_MIC),
 	SND_PCI_QUIRK(0x1558, 0xa763, "Clevo V54x_6x_TU", ALC245_FIXUP_CLEVO_NOISY_MIC),
 	SND_PCI_QUIRK(0x1558, 0xb018, "Clevo NP50D[BE]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0xb019, "Clevo NH77D[BE]Q", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
-- 
2.39.5

