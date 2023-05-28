Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC70B611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:20:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7733CC433D2;
	Sun, 28 May 2023 19:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301600;
	bh=ZxajpR2NaS6bOi1gqQ9o6wQfddd8Na34fmAjVLgTNco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bkuSIVn88e1roA4/r/XmWN01fcJoTHZEI2GtK7pcOhVCc/1fBWD5qMitJMD5szLIs
	 Ear8Zk9WAmccU/+aHNPNgF3R1yqeXRB/ZYjxA9m6OI01If7gwjAVO6EsRAteH1MpEE
	 mB1zKNAD8RAUmg3GzfUywnxLkvpAkew13/RfkN2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 094/132] ALSA: hda/realtek - ALC897 headset MIC no sound
Date: Sun, 28 May 2023 20:10:33 +0100
Message-Id: <20230528190836.512102078@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190833.565872088@linuxfoundation.org>
References: <20230528190833.565872088@linuxfoundation.org>
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
Stable-dep-of: 90670ef774a8 ("ALSA: hda/realtek: Add a quirk for HP EliteDesk 805")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 564851086125f..cf76c3159d584 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8676,6 +8676,7 @@ enum {
 	ALC668_FIXUP_MIC_DET_COEF,
 	ALC897_FIXUP_LENOVO_HEADSET_MIC,
 	ALC897_FIXUP_HEADSET_MIC_PIN,
+	ALC897_FIXUP_HP_HSMIC_VERB,
 };
 
 static const struct hda_fixup alc662_fixups[] = {
@@ -9088,6 +9089,13 @@ static const struct hda_fixup alc662_fixups[] = {
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
@@ -9112,6 +9120,7 @@ static const struct snd_pci_quirk alc662_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x0698, "Dell", ALC668_FIXUP_DELL_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x069f, "Dell", ALC668_FIXUP_DELL_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x1632, "HP RP5800", ALC662_FIXUP_HP_RP5800),
+	SND_PCI_QUIRK(0x103c, 0x8719, "HP", ALC897_FIXUP_HP_HSMIC_VERB),
 	SND_PCI_QUIRK(0x103c, 0x873e, "HP", ALC671_FIXUP_HP_HEADSET_MIC2),
 	SND_PCI_QUIRK(0x1043, 0x1080, "Asus UX501VW", ALC668_FIXUP_HEADSET_MODE),
 	SND_PCI_QUIRK(0x1043, 0x11cd, "Asus N550", ALC662_FIXUP_ASUS_Nx50),
-- 
2.39.2



