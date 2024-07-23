Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B2813D896;
	Tue, 23 Jul 2024 18:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760146; cv=none; b=hZ2rJbzEbD635SBvmMLUlOlgvMADhAhY5nfFDgTsXfOoBtX46cokPTUJD2lWOgFcT0DXnr9kL1PaDatxoPItPR5XyzltfYHkMnhtPc1k3e3GT2YVx4026t1TqiW6AKDbOXdRWHLN2YqTk3ml2A3poQDWPAI0ywmpl95eIATJ3eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760146; c=relaxed/simple;
	bh=zA72B/I5cSMOGzJMPuQXB0tYnfmzyd1MWT4SFJLrvD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AKtaHhWInWEs0g4xe7GD5U4TqUua2P8NsSR4lhj+8FO0UC7WKeOyPgWktXtN41fewFtKqmEj0x3rBaNkXe7no+fK50nTYGQyfqbSVRErpUCNfOgPYoN30hDNR9cOvfjhpFs1Bmob3PcQc3Y4N5YfwVpDyx8ICIAscb0RtCIO3J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JwCC50Zc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JwCC50Zc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97DF7C4AF0A;
	Tue, 23 Jul 2024 18:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760146;
	bh=zA72B/I5cSMOGzJMPuQXB0tYnfmzyd1MWT4SFJLrvD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JwCC50ZcVt8qlRje/+TVhI75vl6iOTCmxG40/J8ggcG5KigSNDc+4P7D0Foe7ucXo
	 qjRY4UpAgAIunuqAHu+dNrMNfFOmciyxtotJi8tqet5Bq2BRwVODmc7Vm33vcYrrBZ
	 cLuF6yhH8QcMIkWarzigq+5WX9eUkG7dUZ5Q+i7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aivaz Latypov <reichaivaz@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 118/163] ALSA: hda/relatek: Enable Mute LED on HP Laptop 15-gw0xxx
Date: Tue, 23 Jul 2024 20:24:07 +0200
Message-ID: <20240723180148.033276247@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aivaz Latypov <reichaivaz@gmail.com>

[ Upstream commit 1d091a98c399c17d0571fa1d91a7123a698446e4 ]

This HP Laptop uses ALC236 codec with COEF 0x07 controlling
the mute LED. Enable existing quirk for this device.

Signed-off-by: Aivaz Latypov <reichaivaz@gmail.com>
Link: https://patch.msgid.link/20240625081217.1049-1-reichaivaz@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index a260dfb7fde0c..8a52ed9aa465c 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10039,6 +10039,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8788, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x87b7, "HP Laptop 14-fq0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87c8, "HP", ALC287_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x87d3, "HP Laptop 15-gw0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87e5, "HP ProBook 440 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87e7, "HP ProBook 450 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87f1, "HP ProBook 630 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
-- 
2.43.0



