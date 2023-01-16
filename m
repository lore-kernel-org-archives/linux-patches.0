Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7191F6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:58:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7B0C433D2;
	Mon, 16 Jan 2023 16:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888316;
	bh=/jdDzNxf2EfgrBR95ZmhjsKxwx5O23L9vRmTZ0YUSvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0eG+JnAGCYXpKotwswE++ESLqDk5Ci2Yx4Z3krARak08OEP7kgBVsB7PMGUjnAHH2
	 kA3T8PxpxIUup99tknSRvJ4SrcrbmanURgCnOCdpldP9D9BkKt/an4QyuhVwBcwJWd
	 NNrvF+ZMErnbLbw2x/DXyc++jcrsTqqGZkmlfnok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 482/521] ALSA: hda/realtek - ALC897 headset MIC no sound
Date: Mon, 16 Jan 2023 16:52:24 +0100
Message-Id: <20230116154908.754393430@linuxfoundation.org>
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

From: Kailang Yang <kailang@realtek.com>

[ Upstream commit fe6900bd8156467365bd5b976df64928fdebfeb0 ]

There is not have Headset Mic verb table in BIOS default.
So, it will have recording issue from headset MIC.
Add the verb table value without jack detect. It will turn on Headset Mic.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/719133a27d8844a890002cb817001dfa@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 4bf5bf54476d ("ALSA: hda/realtek: Add quirk for Lenovo TianYi510Pro-14IOB")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index f0cf3e23d355..0a2cf8ca2812 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8675,6 +8675,7 @@ enum {
 	ALC668_FIXUP_MIC_DET_COEF,
 	ALC897_FIXUP_LENOVO_HEADSET_MIC,
 	ALC897_FIXUP_HEADSET_MIC_PIN,
+	ALC897_FIXUP_HP_HSMIC_VERB,
 };
 
 static const struct hda_fixup alc662_fixups[] = {
@@ -9087,6 +9088,13 @@ static const struct hda_fixup alc662_fixups[] = {
 		.chained = true,
 		.chain_id = ALC897_FIXUP_LENOVO_HEADSET_MIC
 	},
+	[ALC897_FIXUP_HP_HSMIC_VERB] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x19, 0x01a1913c }, /* use as headset mic, without its own jack detect */
+			{ }
+		},
+	},
 };
 
 static const struct snd_pci_quirk alc662_fixup_tbl[] = {
@@ -9111,6 +9119,7 @@ static const struct snd_pci_quirk alc662_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x0698, "Dell", ALC668_FIXUP_DELL_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x069f, "Dell", ALC668_FIXUP_DELL_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x1632, "HP RP5800", ALC662_FIXUP_HP_RP5800),
+	SND_PCI_QUIRK(0x103c, 0x8719, "HP", ALC897_FIXUP_HP_HSMIC_VERB),
 	SND_PCI_QUIRK(0x103c, 0x873e, "HP", ALC671_FIXUP_HP_HEADSET_MIC2),
 	SND_PCI_QUIRK(0x1043, 0x1080, "Asus UX501VW", ALC668_FIXUP_HEADSET_MODE),
 	SND_PCI_QUIRK(0x1043, 0x11cd, "Asus N550", ALC662_FIXUP_ASUS_Nx50),
-- 
2.35.1



