Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB432882A7;
	Thu, 27 Nov 2025 15:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255866; cv=none; b=OYl54XdgxnEIB2P71HY8PxrOd1byVMLrW9yivZhVXwihMAw4y22R8kfBTbZg5mD9+6Ix7ppZultynnMjeud7VjoHzvqYJqMD5FEn2UMugSeZ92fcEoyMMCcx44kBoLIZGdycqylBG3la1LRzCMalTauDaoMu8uD0Pzv1jAwMhnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255866; c=relaxed/simple;
	bh=R0/meJ9xwPI75SeFybDK1JUgAN3wTI5PiBZnB+L/ps4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqPM+hP20mFtES7PiTLHV6izxYtFf6EOKziGpCgVFiwn/z9v7gaQmVzkgNP/GkLK9vi1SCor2wxXcOP7NaS0pFKCenbAhsII3b4BuJ+ddUO+sMN4ornLUqn+4xmu6bIkXcLZLTUHZ4U5KYChVsF5LUPCH4sHzgwdGM2nM5E4rfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wqqq4vJs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wqqq4vJs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77601C4CEF8;
	Thu, 27 Nov 2025 15:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255865;
	bh=R0/meJ9xwPI75SeFybDK1JUgAN3wTI5PiBZnB+L/ps4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wqqq4vJsp+ID/aUXyktLiYnEd5MQwREgLcavIiF0I44O+D4FjGwVc41pLlmAHadbm
	 aWpIzn/WJz9slw23EOurs569xPe8HP48XsEuTpZ0dkEH4Dd5DVaMJT0BIlUbdQ7rNI
	 aDVKUycdTEJ6jz05M9PayP+NjFpstAcwDma4Rr2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eren Demir <eren.demir2479090@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 142/175] ALSA: hda/realtek: Fix mute led for HP Victus 15-fa1xxx (MB 8C2D)
Date: Thu, 27 Nov 2025 15:46:35 +0100
Message-ID: <20251127144048.144141557@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eren Demir <eren.demir2479090@gmail.com>

[ Upstream commit 28935ee5e4789ad86c08ba9f2426edd6203d13fa ]

The quirk for Victus 15-fa1xxx wasn't working on Victus 15-fa1031nt due to a different board id. This patch enables the existing quirk for the board id 8BC8.

Tested on HP Victus 15-fa1031nt (MB 8C2D). The LED behaviour works as intended.

Signed-off-by: Eren Demir <eren.demir2479090@gmail.com>
Link: https://patch.msgid.link/20251027110208.6481-1-eren.demir2479090@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 20f0ad43953f4..796f555dd381d 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6580,6 +6580,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8c16, "HP Spectre x360 2-in-1 Laptop 16-aa0xxx", ALC245_FIXUP_HP_SPECTRE_X360_16_AA0XXX),
 	SND_PCI_QUIRK(0x103c, 0x8c17, "HP Spectre 16", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8c21, "HP Pavilion Plus Laptop 14-ey0XXX", ALC245_FIXUP_HP_X360_MUTE_LEDS),
+	SND_PCI_QUIRK(0x103c, 0x8c2d, "HP Victus 15-fa1xxx (MB 8C2D)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8c30, "HP Victus 15-fb1xxx", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8c46, "HP EliteBook 830 G11", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c47, "HP EliteBook 840 G11", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
-- 
2.51.0



