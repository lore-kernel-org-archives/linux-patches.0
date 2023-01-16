Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFCC6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:58:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB49CC433EF;
	Mon, 16 Jan 2023 16:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888306;
	bh=uioeIRNv3gz/wnm13kQ1MEbYzTcaEKm+K6LLWmx3RP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nBIKXPdVu16gXqXCMo8Y6KzkBMf/DPUEz25Tu1DuK+RJIZyM6pDO+1VX7HnYXR2AK
	 D26d2J7A23pPCuUeYiuqM+4qAcADfr6sbsw2kzBscwnZda41NtKYavrafHbV60JZd3
	 LBalApJLObYQ6yY/xU8Ym4Sxcu48r+mBUiZXbZpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian-Hong Pan <jian-hong@endlessm.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 478/521] ALSA: hda/realtek - Enable the headset of Acer N50-600 with ALC662
Date: Mon, 16 Jan 2023 16:52:20 +0100
Message-Id: <20230116154908.575975858@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jian-Hong Pan <jian-hong@endlessm.com>

[ Upstream commit a124458a127ccd7629e20cd7bae3e1f758ed32aa ]

A headset on the desktop like Acer N50-600 does not work, until quirk
ALC662_FIXUP_ACER_NITRO_HEADSET_MODE is applied.

Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200317082806.73194-3-jian-hong@endlessm.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 4bf5bf54476d ("ALSA: hda/realtek: Add quirk for Lenovo TianYi510Pro-14IOB")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 024a7e473e11..bb0917b9e68f 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8648,6 +8648,7 @@ enum {
 	ALC669_FIXUP_ACER_ASPIRE_ETHOS_HEADSET,
 	ALC671_FIXUP_HP_HEADSET_MIC2,
 	ALC662_FIXUP_ACER_X2660G_HEADSET_MODE,
+	ALC662_FIXUP_ACER_NITRO_HEADSET_MODE,
 };
 
 static const struct hda_fixup alc662_fixups[] = {
@@ -9014,6 +9015,16 @@ static const struct hda_fixup alc662_fixups[] = {
 		.chained = true,
 		.chain_id = ALC662_FIXUP_USI_FUNC
 	},
+	[ALC662_FIXUP_ACER_NITRO_HEADSET_MODE] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x1a, 0x01a11140 }, /* use as headset mic, without its own jack detect */
+			{ 0x1b, 0x0221144f },
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC662_FIXUP_USI_FUNC
+	},
 };
 
 static const struct snd_pci_quirk alc662_fixup_tbl[] = {
@@ -9025,6 +9036,7 @@ static const struct snd_pci_quirk alc662_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x0349, "eMachines eM250", ALC662_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x1025, 0x034a, "Gateway LT27", ALC662_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x1025, 0x038b, "Acer Aspire 8943G", ALC662_FIXUP_ASPIRE),
+	SND_PCI_QUIRK(0x1025, 0x123c, "Acer Nitro N50-600", ALC662_FIXUP_ACER_NITRO_HEADSET_MODE),
 	SND_PCI_QUIRK(0x1025, 0x124e, "Acer 2660G", ALC662_FIXUP_ACER_X2660G_HEADSET_MODE),
 	SND_PCI_QUIRK(0x1028, 0x05d8, "Dell", ALC668_FIXUP_DELL_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x05db, "Dell", ALC668_FIXUP_DELL_MIC_NO_PRESENCE),
-- 
2.35.1



