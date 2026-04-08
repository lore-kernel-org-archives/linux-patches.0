Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18BC37F8C2;
	Wed,  8 Apr 2026 18:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671748; cv=none; b=HH/TDbBq/0OUrPzLfBsT1MPP7c+kfLZ+cL8ByIuPanIAkUrz0GvlssHPd6Zth//MfL59GbxpvUvj+CAYDRJUk1Lb3uKanH//mpIShS6hjAcaN7nOg848YQQC/pezkigzZhqnfCfsrIkBUfbugEvcBR9zIKQAXiNH6LfBg+Wvumc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671748; c=relaxed/simple;
	bh=SPFCWTdsWPwyxiBZi9LWkyVvd9YFrioaMxayBD5cbWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jb+rSaBvpc4rEo8wHnXkgUshz+vK2nnHw/hK2/zelE9jCHFc03AIeWC4U6jXJTkuvLlSj8fhuoLNAJ2IpLEdnjHdbXtNrh5sdrse15bBBREYTRDu99MQOSl+mNRrnRLCxd7JOO3EnX2D5goWgxhLZcJ0hlrZmKZ4bnOUWSxG/8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YCihl9Hn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YCihl9Hn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781C3C19421;
	Wed,  8 Apr 2026 18:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671747;
	bh=SPFCWTdsWPwyxiBZi9LWkyVvd9YFrioaMxayBD5cbWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YCihl9HnqEE+CcTST1HR5fapIOx/FzwASvBGd8T163f6bToud9DN1ADIpSvtdUhvw
	 zFpFtEIhTU89KD5UTobP3u2WjoByQN8tmgkaEdqDTqsZNBvCsxbMziYc7+UzePzRYl
	 ZKIN5wmTI1KRgxDPA0aHx8WFDHtL346+9W3lBPdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liucheng Lu <luliucheng100@outlook.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/312] ALSA: hda/realtek: add HP Laptop 14s-dr5xxx mute LED quirk
Date: Wed,  8 Apr 2026 19:58:57 +0200
Message-ID: <20260408175934.485142616@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liucheng Lu <luliucheng100@outlook.com>

[ Upstream commit 178dd118c0f07fd63a9ed74cfbd8c31ae50e33af ]

HP Laptop 14s-dr5xxx with ALC236 codec does not handle the toggling of
the mute LED.
This patch adds a quirk entry for subsystem ID 0x8a1f using
ALC236_FIXUP_HP_MUTE_LED_COEFBIT2 fixup, enabling correct mute LED
behavior.

Signed-off-by: Liucheng Lu <luliucheng100@outlook.com>
Link: https://patch.msgid.link/PAVPR03MB9774F3FCE9CCD181C585281AE37BA@PAVPR03MB9774.eurprd03.prod.outlook.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 89410d40561d7..1f069d7c3829f 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10019,6 +10019,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x89ca, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x89d3, "HP EliteBook 645 G9 (MB 89D2)", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8a0f, "HP Pavilion 14-ec1xxx", ALC287_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8a1f, "HP Laptop 14s-dr5xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8a20, "HP Laptop 15s-fq5xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8a25, "HP Victus 16-d1xxx (MB 8A25)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8a78, "HP Dev One", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),
-- 
2.51.0



