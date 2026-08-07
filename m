Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8034746AB;
	Fri,  7 Aug 2026 14:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114787; cv=none; b=IknnLW7YZ6G26SowvbRwNbyYAeGLFxINf6eKMCl8uK04OtZZw5ErgLE7sKTh8TPrmtjk0+xRzEbCWz3QRg0q6SGiDN/yYK5LJ+hnvTKDO8vtu3c193fhFuvSpb4s1MWMJ4cbk5SPmA+06UiYqZJto5jrrlhVxkfnMmXeXjMLTHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114787; c=relaxed/simple;
	bh=85VHiLC1P8hqiWlTMgrNYr2oBv95Sgv3yQQDJHLXIGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IRnBsJYU6wz6v19rjqRu/GZwa56mE+hHlDKDUn8IB7yD6lb/4B1Y8IDPS1mKRHyNCsA3Sr3VS+7nXSJs1yiF7T96KRxzHOaQNEjBd1VJKMsTCCmtOk0DVRTnseKc3970/AEnsV21wZv5a2Wo6qJzphaHkGou9jmfnyHzTpUIvXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jLiYwve8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jLiYwve8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265E51F000E9;
	Fri,  7 Aug 2026 14:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114786;
	bh=v760BbY5w0Fkv1AE0K72PCmu08SrYiXyOyJ74zWbQjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jLiYwve8ZarPKGBOZTNoxe7W9kk8/JFdpJeZXZWUtVng+0vOSAXz0TgHDEBeMFZpS
	 IdLQ9ShIB2NagGfSt5EN7GhwwfciiRrFDOeJtA+kGmu5Jy6EBmEAPNKCNZ2KYibeIp
	 jh1AKE8dNs5rEfn3Rza4BpiZF1x+rGjY6sL5zvHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabian Lippold <fabianlippold1184@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 007/396] ALSA: hda/realtek: add quirk for HP Dragonfly Folio G3 2-in-1
Date: Fri,  7 Aug 2026 16:32:47 +0200
Message-ID: <20260807143424.432297330@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabian Lippold <fabianlippold1184@gmail.com>

[ Upstream commit 0a10faad5ca58332ad70f7663ba82611f4daf736 ]

Add PCI quirk for HP Dragonfly Folio G3 (PCI ID 103c:8a06) to select the
CS35L41 SPI4 & GPIO LED fixup variant.

Signed-off-by: Fabian Lippold <fabianlippold1184@gmail.com>
Link: https://patch.msgid.link/20260526154418.1850568-3-fabianlippold1184@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 40a75d72f712..d84d17c6e049 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6839,6 +6839,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x89d3, "HP EliteBook 645 G9 (MB 89D2)", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x89da, "HP Spectre x360 14t-ea100", ALC245_FIXUP_HP_SPECTRE_X360_EU0XXX),
 	SND_PCI_QUIRK(0x103c, 0x89e7, "HP Elite x2 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8a06, "HP Dragonfly Folio G3 2-in-1", ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a0f, "HP Pavilion 14-ec1xxx", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a1f, "HP Laptop 14s-dr5xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8a20, "HP Laptop 15s-fq5xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
-- 
2.53.0



