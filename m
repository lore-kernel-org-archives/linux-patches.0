Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F97171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:18:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9528DC4339B;
	Mon, 22 May 2023 19:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783133;
	bh=BxVVpe9on/m9ivgzYKkk8IGctjKWRugfjwJApp1qm24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CfVQZpEKWZwcTR3AFQx6MhR9dmE7tw/8XFTRTtTePA+4kAOiCMIMXk2KpVTyZsy2b
	 YngYEPfmXYswYzl20+kEbaDsFxzNTeA1d3DnqgxXBb1xfcscfrQ8yFdWTmkfk9X/lv
	 CF7RL+7erQUKunZ9tMQHnOJEiN1heRmXbocbIDew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Underwood <nemesis@icequake.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 122/203] ALSA: hda/realtek: Apply HP B&O top speaker profile to Pavilion 15
Date: Mon, 22 May 2023 20:09:06 +0100
Message-Id: <20230522190358.351764469@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ryan C. Underwood <nemesis@icequake.net>

[ Upstream commit 92553ee03166ef8fa978e7683f9f4af30c9c4e6b ]

The Pavilion 15 line has B&O top speakers similar to the x360 and
applying the same profile produces good sound.  Without this, the
sound would be tinny and underpowered without either applying
model=alc295-hp-x360 or booting another OS first.

Signed-off-by: Ryan Underwood <nemesis@icequake.net>
Fixes: 563785edfcef ("ALSA: hda/realtek - Add quirk entry for HP Pavilion 15")
Link: https://lore.kernel.org/r/ZF0mpcMz3ezP9KQw@icequake.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 86d07d06bd0cd..5d1ab9170361a 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9008,7 +9008,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x802f, "HP Z240", ALC221_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x8077, "HP", ALC256_FIXUP_HP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x103c, 0x8158, "HP", ALC256_FIXUP_HP_HEADSET_MIC),
-	SND_PCI_QUIRK(0x103c, 0x820d, "HP Pavilion 15", ALC269_FIXUP_HP_MUTE_LED_MIC3),
+	SND_PCI_QUIRK(0x103c, 0x820d, "HP Pavilion 15", ALC295_FIXUP_HP_X360),
 	SND_PCI_QUIRK(0x103c, 0x8256, "HP", ALC221_FIXUP_HP_FRONT_MIC),
 	SND_PCI_QUIRK(0x103c, 0x827e, "HP x360", ALC295_FIXUP_HP_X360),
 	SND_PCI_QUIRK(0x103c, 0x827f, "HP x360", ALC269_FIXUP_HP_MUTE_LED_MIC3),
-- 
2.39.2



