Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043950;
	b=zbMMrTiatUdQ2wi2tLJRkwT49lII7UUUFx1tATNz0JyjLw2RKOhznoED2eSPJ5PSA9HW
	 xeP6NhqeZ1I1rgKvB+wj/g4JepAw3Rg34a2ed6Wc5Z0qIAAiEbj9MR1LKMxG0b8x/B3jt
	 QE8Za/KsMDrDAxXrS9WqeYIQ4iDa4CdzMkxGyvpXhBUSb8XQSWq0beX/O5ceyeUQzoXfO
	 QvCme3VZ8MaZk4u/6FFZbejaMfyd9DxIp3RWtG91MIf1AXwUghBVCetDWAwONUkP1w5at
	 UrZ0ewIq52wLFzyM9RWkOrnP6SWFz0twa8R2WdiFgnr6YA4xPclO1WA05KMEBzp1e+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043950;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0ExsT1eotpmkCh8BE08agkHVJkKYMW3LE8oGgHBPoTI=;
	b=KyT7bbXO4+C7iLc2B3GN3WdBvOUAE5gEWTY9xLFyttX1a7Dt1q3wzoUAz1NDNuOeedhn
	 aSRvvOniaTTmUsi04e5jzdDBaBr+nRRBpfGkoRGNowFcERJXO/BHHN2CgRQSt4AHVHoA3
	 3cNbV5TyQr+fEI4OOQyeg3hPCicB36hUUOM9oCcJETf5SA0vbhmLs58IBD8XGdbk4qItm
	 dlfDrjoTAsb76BbNgU2dfBPFyKhqh0qjxybllRgz6tuHFByvH1zGKVN/+n6N9T3++ySHG
	 lyCW4SYk/gJJr8IriNwv+MFcqb/GEIQS4ofGw/tgDcWkuR0maXcRLVgAxWUDOSeXt2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MswB+Lkq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23838606A337;
	Wed, 18 Nov 2026 23:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MswB+Lkq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714881F000C4;
	Wed, 18 Nov 2026 23:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043950;
	bh=0ExsT1eotpmkCh8BE08agkHVJkKYMW3LE8oGgHBPoTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MswB+LkqpTzxiKckLTt3fHr1Z3qLGvXgWnFlPAIXq4W9lwl8uivxhIa4O/3nM3gaX
	 bijtb06ActYMgqDBKH5CjQlK465H4kFIpEJWgVyMbNubqGpTPSSmRlG219xgOcTxQD
	 EnH8uwh0rV8lf6NZgZ5SpB7WlgcXal6NCzrfxGYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eckhart Mohr <e.mohr@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0366/2857] ALSA: hda/realtek: Add quirk for TongFang X6xx45xU
Date: Wed, 18 Nov 2026 15:23:20 +0100
Message-ID: <20261118150214.602235674@linuxfoundation.org>
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

[ Upstream commit d595255241e5fec0c94adeebf2565524398e37c5 ]

Fix microphone detection on built in headphone jack for some devices.

Signed-off-by: Eckhart Mohr <e.mohr@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20260708132135.102680-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: e72d5659a260 ("ALSA: hda/realtek: Add quirk for TongFang XxAF5xxx")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index e201c9705fb14..4fe56d6b6d7ad 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10495,6 +10495,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1d05, 0x300f, "TongFang X6AR5xxY", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x3019, "TongFang X6FR5xxY", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x3031, "TongFang X6AR55xU", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d05, 0x3034, "TongFang X6xx45xU", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d17, 0x3288, "Haier Boyue G42", ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS),
 	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1701, "XiaomiNotebook Pro", ALC298_FIXUP_DELL1_MIC_NO_PRESENCE),
-- 
2.53.0



