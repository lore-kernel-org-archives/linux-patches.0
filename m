Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE9613C816;
	Thu, 25 Jul 2024 14:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919183; cv=none; b=jBsBE+2508a3XFI+QZ3dT0u7yWnwSeB9iSaKQv4MaibT4XrXE57j1jAu+DYMoTNtYgNg7xYULRyyS0HK3P8FEr++QnW/bxvTrTuCOahlDbarARpG5nbEocLrVdyDhvPiOb/xLbsyeadgO0gmhryaS9ox/z4EeORvC85EU0q0sOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919183; c=relaxed/simple;
	bh=yRuGTfBhPrGR2FyzomJQzE4er2iXZWb6rR+5A89w3+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tVfQsIjyNWlfHQTceCylZEN3QFDmafHtUFBVpfTK4dc8WtwCBmr7KoS6tp5p/gTGdgFaerX1j+BEYLI+x5aLJiEjF7HNv9kbZt28XxUk9H4mATVDPd/Bj52hafZhtH4B2wjiT2paYrlMfvHRVrlK9rLP7bdipn0/2ujvnwoJDVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RyGT5qQv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RyGT5qQv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D663EC116B1;
	Thu, 25 Jul 2024 14:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919183;
	bh=yRuGTfBhPrGR2FyzomJQzE4er2iXZWb6rR+5A89w3+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RyGT5qQvQw3n1dK5aIpiuKsGCrS76Ez3J4P94kiSG8s/wXk3dM4Nx4RWvH84Zk3PY
	 1XG2SUWyA5vxeiveSso3wISHz6QWu8I0xrzELGv3m83c+qiwK+UNW15ma/LKXljZKu
	 8dPOvAHTXyXhBfZxMGeVwV0SjflaZOHU6BgsQSh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aivaz Latypov <reichaivaz@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 49/87] ALSA: hda/relatek: Enable Mute LED on HP Laptop 15-gw0xxx
Date: Thu, 25 Jul 2024 16:37:22 +0200
Message-ID: <20240725142740.283640392@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index aeecc208e7fa0..afc9f1cd9647c 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9161,6 +9161,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8788, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x87b7, "HP Laptop 14-fq0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87c8, "HP", ALC287_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x87d3, "HP Laptop 15-gw0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87e5, "HP ProBook 440 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87e7, "HP ProBook 450 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87f1, "HP ProBook 630 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
-- 
2.43.0



