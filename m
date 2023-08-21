Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8B81171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C34BC433C8;
	Mon, 21 Aug 2023 20:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648160;
	bh=zM6sEFZHUh9bMFffGMgPAawBChpPLljlwB1ajwysIuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ymy3g7IVAIeUjA2hbnjrU3wcw7Y07Uso4Yh6+z+aJUatc/TIomU0t0zYz1s0vlLKG
	 z/wUs7NJ3K5FHdB2JyhpOvaR3OYt1XgFq+tOgH9rlNgysMz/G/Fr5Qy0Ngx/ECI8E3
	 QpPjG3j8zgoqegnmYyUyyjD9n9qMhIsi2tWZKl8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luke D. Jones" <luke@ljones.dev>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 077/234] ALSA: hda/realtek: Amend G634 quirk to enable rear speakers
Date: Mon, 21 Aug 2023 21:40:40 +0200
Message-ID: <20230821194132.163490259@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luke D. Jones <luke@ljones.dev>

[ Upstream commit b759a5f097cd42c666f1ebca8da50ff507435fbe ]

Amends the last quirk for the G634 with 0x1caf subsys to enable the rear
speakers via pincfg.

Signed-off-by: Luke D. Jones <luke@ljones.dev>
Link: https://lore.kernel.org/r/20230704044619.19343-4-luke@ljones.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 2e0c822d1b5d0..1d0f43017f255 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7081,6 +7081,7 @@ enum {
 	ALC285_FIXUP_SPEAKER2_TO_DAC1,
 	ALC285_FIXUP_ASUS_SPEAKER2_TO_DAC1,
 	ALC285_FIXUP_ASUS_HEADSET_MIC,
+	ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS,
 	ALC285_FIXUP_ASUS_I2C_SPEAKER2_TO_DAC1,
 	ALC285_FIXUP_ASUS_I2C_HEADSET_MIC,
 	ALC280_FIXUP_HP_HEADSET_MIC,
@@ -8075,6 +8076,15 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC285_FIXUP_ASUS_SPEAKER2_TO_DAC1
 	},
+	[ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x14, 0x90170120 },
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC285_FIXUP_ASUS_HEADSET_MIC
+	},
 	[ALC285_FIXUP_ASUS_I2C_SPEAKER2_TO_DAC1] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc285_fixup_speaker2_to_dac1,
@@ -9647,7 +9657,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1c23, "Asus X55U", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x1043, 0x1c62, "ASUS GU603", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1c92, "ASUS ROG Strix G15", ALC285_FIXUP_ASUS_G533Z_PINS),
-	SND_PCI_QUIRK(0x1043, 0x1caf, "ASUS G634JYR/JZR", ALC285_FIXUP_ASUS_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1043, 0x1caf, "ASUS G634JYR/JZR", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
 	SND_PCI_QUIRK(0x1043, 0x1ccd, "ASUS X555UB", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1d1f, "ASUS ROG Strix G17 2023 (G713PV)", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1d42, "ASUS Zephyrus G14 2022", ALC289_FIXUP_ASUS_GA401),
-- 
2.40.1



