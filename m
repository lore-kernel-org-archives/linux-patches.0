Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043980;
	b=FDkkfkOQvaDTL4RwsUA7sSNumRLkrdYk/ya1ylIPWHThnDEpZNckWL+X3sQOdw5MPMBV
	 vXJcZ1ilDcEMTnQoI4ACV+WDDnzaKKAPKYMJtUUPXh8ueRKZe1n0LrACKyCTG9N3XdLn/
	 fgLw+gNvOBKmS4/LMh/S3/AjWWSiIqoX0CusbY0W4w8KK3LhxpXCkLgk+5uie29pgp0Ty
	 dwPM0E2rhjRdFNm9SB+AawYzyGHuH5QXubsCkztQnDjU3ogU30BuE+rByYlOn2mz8S4Ds
	 4QH6ngV5mZVff5HCtYTt+38nWuzzAhyhWYvRcf7ms2HqADeyFH1Czr5J2KVDe0yXwAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043980;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3yptGjeVwjon9QoNhvK9epNB19vWHxZS32w4vGj+2nY=;
	b=tNiWEXoA8jiEizKyZyEJXBf/rSlUN+U10TW/DPeTw+uZsMnhGf7rcMM15A0Z5hja7jdP
	 XxH0SLpSkfZJR3EbAOfGlanvFQNjROL/PSx8rHdAwEtvqmxLtkKVLnQd8/WpJ4n7k4ckb
	 Kc48nAsVJV5NRY9WjXHmaqAR2ywdeYp7HzIajpEVcQMnzclmcr0vlmU1ChcU5FJbfqt2P
	 Z+4mdM4taxt3JhBXVZwmcJxPI35DOFScNH9kFMLgY+OT4H9LSfoAZIfki+AUR4aoeVlki
	 zpB8PoRiwONvi/thUNYsIQjo7HcPXQeAY6PxsSNpm/jH5yVKslNl95ZeG5sO1N0UHyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RJqh0fQj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8472606A31C;
	Wed, 18 Nov 2026 23:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RJqh0fQj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09EF01F000C4;
	Wed, 18 Nov 2026 23:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043980;
	bh=3yptGjeVwjon9QoNhvK9epNB19vWHxZS32w4vGj+2nY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RJqh0fQjTw0fKb5XbqQdGC9wmjUcn63mXkRr78PWLIY2AXqc3Lbbq9DqONTPtEtzA
	 TZd+tFvcu4I8ppQkqT87wvmgAlZasxF5dJ3thUoWNGgXoV1XAABuAwFvYuRDgiywt3
	 dgB04gEYY/CXgxJYDg0140S8i+2O9nHp3KSvK2eI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eckhart Mohr <e.mohr@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0367/2857] ALSA: hda/realtek: Add quirk for TongFang X6SP45xU
Date: Wed, 18 Nov 2026 15:23:21 +0100
Message-ID: <20261118150214.635857664@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eckhart Mohr <e.mohr@tuxedocomputers.com>

[ Upstream commit 26a94400ffa4fcbeff32e23abebb83a1a20eb401 ]

TongFang X6KK45xU and X6SP45xU have actually different PCI IDs. This patch
Adds the missing PCI ID to fix headphone detection and clarifies the
naming.

Fixes: d595255241e5 ("ALSA: hda/realtek: Add quirk for TongFang X6xx45xU")
Signed-off-by: Eckhart Mohr <e.mohr@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20260724190109.169889-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: e72d5659a260 ("ALSA: hda/realtek: Add quirk for TongFang XxAF5xxx")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 4fe56d6b6d7ad..4b489e7ad7f3b 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10495,7 +10495,8 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1d05, 0x300f, "TongFang X6AR5xxY", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x3019, "TongFang X6FR5xxY", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x3031, "TongFang X6AR55xU", ALC2XX_FIXUP_HEADSET_MIC),
-	SND_PCI_QUIRK(0x1d05, 0x3034, "TongFang X6xx45xU", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d05, 0x3033, "TongFang X6SP45xU", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d05, 0x3034, "TongFang X6KK45xU", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d17, 0x3288, "Haier Boyue G42", ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS),
 	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1701, "XiaomiNotebook Pro", ALC298_FIXUP_DELL1_MIC_NO_PRESENCE),
-- 
2.53.0



