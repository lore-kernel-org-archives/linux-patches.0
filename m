Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451301171B
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:01:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88DCBC433C7;
	Mon, 11 Sep 2023 15:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444518;
	bh=0jq6EymE4j5nZ/ujdiZI/a1l3W6pnpkV+Adb/Xst/X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GOrj/3giFIUP80njQXGsMqeGvX/ALhMSk5XsvLimUXX9+bwiapFzwQOTswTZHnQXT
	 gE3WUBChtgfcZ5RCnbkef3Gqlie0b7rHg0zTVsQ45SvrKBzObGeRECqbQSpmo0E0TT
	 1tZB3myaVvxIOho0ByWjT1S/iEtcBcfUQ3FUULUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Chiu <chris.chiu@canonical.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/600] ALSA: hda/realtek: Enable 4 amplifiers instead of 2 on a HP platform
Date: Mon, 11 Sep 2023 15:40:39 +0200
Message-ID: <20230911134633.809143335@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Chiu <chris.chiu@canonical.com>

[ Upstream commit b752a385b584d385683c65cb76a1298f1379a88c ]

In the commit 7bb62340951a ("ALSA: hda/realtek: fix speaker, mute/micmute
LEDs not work on a HP platform"), speakers and LEDs are fixed but only 2
CS35L41 amplifiers on SPI bus connected to Realtek codec are enabled. Need
the ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED to get all amplifiers working.

Signed-off-by: Chris Chiu <chris.chiu@canonical.com>
Fixes: 7bb62340951a ("ALSA: hda/realtek: fix speaker, mute/micmute LEDs not work on a HP platform")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230606145747.135966-1-chris.chiu@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index aa475154c582f..f70e0ad81607e 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9591,7 +9591,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8b8a, "HP", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b8b, "HP", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b8d, "HP", ALC236_FIXUP_HP_GPIO_LED),
-	SND_PCI_QUIRK(0x103c, 0x8b8f, "HP", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8b8f, "HP", ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b92, "HP", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b96, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8b97, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
-- 
2.40.1



