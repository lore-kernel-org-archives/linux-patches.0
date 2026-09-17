Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F214B49D5AF;
	Thu, 17 Sep 2026 18:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668566; cv=none; b=eiIewmjcsaj2ZCJxxDzRp8pO+F+BK3K04XfAp7E4N9AQF2jnDmKuCRFsfDmqiRoIF7gBxiKUWuv5STZ2xubIhUpZTtYy8c3LbN7alWom5TjhmRWABne1k3AgS3OUkqenevDOO07jx/5VjpKS0C+9lYh0m6NFkkR/fLtnhl2QfxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668566; c=relaxed/simple;
	bh=uWPbL0JVdbO80wxDXVIT8zB9n402TbAwZ8qO0oPUgy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PYUQoImPv+d/feZX8bxlcxLrOJjwlc8itncNjNSUWOLMmoQWkq41Hq/WLkNHLijhhDrV8e0++LaX13C+UmLvGlCijoSWU2IpP2ONJNIrSHTebNkXerDGjI9yQc+Xgio1enyVODOq7cCThD6cYfRIZklfIJUF5Ae84xUsi9fyJg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EXWOAN41; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EXWOAN41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0C41F00898;
	Thu, 17 Sep 2026 18:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668564;
	bh=p0J03HYsMkKNuOqsfOfC/QTp/iSEHqdpHYx+MbSnbbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EXWOAN41fKaFAUbPHAApnedVdd86smoHZLlj2UGqyUfP8tEs3eNjw8DsqD9rX9oww
	 NZZOOZ0KDEJH52GND/Su24CA8VLF6ps0+QeIhY47oXYmtHh+61Q0LmPzveRrrUuyyN
	 9G/6Pe32OYPLfEVvKUkVKKiU97Kes4J3hDvuh6SQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohit Sinha <rohitsinha12043@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0407/1102] ALSA: hda/realtek - Add quirk for HP Victus 15-fa0xxx (MB 8A50)
Date: Thu, 17 Sep 2026 16:05:50 +0100
Message-ID: <20260917151549.881398431@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rohit Sinha <rohitsinha12043@gmail.com>

[ Upstream commit 5c3f4b583c25911fad9890b463632761291f65ab ]

The mute LED on HP Victus 15-fa0xxx (board ID 8A50) uses ALC245 but
requires a quirk to work. This patch enables the existing
ALC245_FIXUP_HP_MUTE_LED_COEFBIT quirk for the device.

Tested on my HP Victus 15-fa0xxx. The LED behaviour works as intended.

Signed-off-by: Rohit Sinha <rohitsinha12043@gmail.com>
Link: https://patch.msgid.link/20260706211834.384022-1-rohitsinha12043@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 632d52a9aec98..74768dd0a0e7c 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10999,6 +10999,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8a30, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8a31, "HP Envy 15", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8a4f, "HP Victus 15-fa0xxx (MB 8A4F)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
+	SND_PCI_QUIRK(0x103c, 0x8a50, "HP Victus 15-fa0xxx (MB 8A50)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8a6e, "HP EDNA 360", ALC287_FIXUP_CS35L41_I2C_4),
 	SND_PCI_QUIRK(0x103c, 0x8a74, "HP ProBook 440 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a78, "HP Dev One", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),
-- 
2.53.0



