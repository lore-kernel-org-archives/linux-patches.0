Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537FE344DBB;
	Sat, 30 May 2026 16:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780157849; cv=none; b=FD7OH/fgesG0Ft4d2ecBAn+X7dT88/mtjLVDr0L0DWpdOfLq1cgh2abLuo/iZdThuWoUlmMyZPWC8junlSO2oqXnAY/tKSoy9QngvhVCDFs/YKc1f7EUCJkZKIP2Dk77lB0LjWTgAeibQfPKHU7fgUOF6SwIZdoR3nVpzxbB3TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780157849; c=relaxed/simple;
	bh=bgw3f38TNlhjbSmBVkQ3/gMpvJE4g9iZCBG0Y8D6fpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YSt/+GKQhllDUjc9Jl1vHVhkR96XHYPTtHenMF7h0mgy0d7WgeDFRYXKoPw3tsibus2L3vi0NdGa0dbZYxkewkERUT6QzIjTIgY2ibaAcjPfw+Psshm3q78CutliIv22b7O1eCCbFTxYu53FdZ1Twg078LXKDWiD4iT+J9WmzP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dASO9Hhy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dASO9Hhy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6221F00893;
	Sat, 30 May 2026 16:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780157847;
	bh=sUcT3ALUaYDJ9AjehzREr3Nb6yVKtcm1ACKgJ/5Oi7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dASO9HhyY5E9piKA0H1iuEfNXzwenQy0DuzsesMrsnoFaBnWSKeLM81GVsRJMZ8IA
	 KnBd9ySQCw+NFCO8fb6kprijIKWpv+FXfIZIDwosW6ecp+aqDkjbiE5uz5EZE4HaXT
	 lfQWJSkmRvr+M1OX2NgKGVUQgP2LMAUbLrEcLnjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A9sar=20Montoya?= <sprit152009@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/776] ALSA: hda/realtek: Add mute LED quirk for HP Pavilion 15-eg0xxx
Date: Sat, 30 May 2026 17:55:19 +0200
Message-ID: <20260530160240.384004100@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: César Montoya <sprit152009@gmail.com>

[ Upstream commit 2f388b4e8fdd6b0f27cafd281658daacfd85807e ]

The HP Pavilion 15-eg0xxx with subsystem ID 0x103c87cb uses a Realtek
ALC287 codec with a mute LED wired to GPIO pin 4 (mask 0x10). The
existing ALC287_FIXUP_HP_GPIO_LED fixup already handles this correctly,
but the subsystem ID was missing from the quirk table.

GPIO pin confirmed via manual hda-verb testing:
  hda-verb SET_GPIO_MASK 0x10
  hda-verb SET_GPIO_DIRECTION 0x10
  hda-verb SET_GPIO_DATA 0x10

Signed-off-by: César Montoya <sprit152009@gmail.com>
Link: https://patch.msgid.link/20260321153603.12771-1-sprit152009@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 38fda5dbd75ba..9cb5705577f72 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9354,6 +9354,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8788, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x87b7, "HP Laptop 14-fq0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87c8, "HP", ALC287_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x87cb, "HP Pavilion 15-eg0xxx", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87cc, "HP Pavilion 15-eg0xxx", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87d3, "HP Laptop 15-gw0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87df, "HP ProBook 430 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
-- 
2.53.0



