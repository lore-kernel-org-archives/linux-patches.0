Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061368;
	b=mtkssKwQV4bl+3fHsDb6ELFXjXUly1gdIaCGkurmFTIJe3EY7bSm+RBRG7nU5cBzxsDD
	 uozzGSeb9jEipWsivb36L1yno5bXw2jwGjP2QWY46Y8ZPSqNbz3QHLMioRTmQ1P7olmJz
	 qaOhgfxH+AajwavR9wkXlgQQLAzQcjMVPzvs155FbFI16wiNz66yuNZIKvDWX3mqe7elM
	 QTk68p/S5XJEoOLG3GPHxYvBy2wPWNTtd1P/DLHrK6Ox485+9qt+CEP2kwdv1MzLY/Aw4
	 y9NnQ9rtd+JJbNecb3OmqkK9so+jDMUIZRN4HQH9bah5nN8Wt0IvQ/Hd2r9W8XZsktg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061368;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f2IlX4YOFRrQo2t9vGAiukKPsY3CRzsOYCQWCikbo/8=;
	b=1v3Yfllgx4ag7IQM2U3ukt9jCpKPg6I+nf3HTesWbdlJmD5fckV+TGBfqcJO1B60raG5
	 lnKQjk0WQoy09ZRIKKmNBBTs3NyYIVggMEZWR7WFQZ3dLIsonjaGQISiCXo9vSgL3fu43
	 uLzTR767fosGmuDTR2MRIkklAge8YRB9meE7U9SX4KYBiOQRInNRmxxIHRtVbIt+EhSXY
	 KW72VfUMUiyaE1pkivNRbJy42pV3bmcvvDAM9uRTmJTKCHpYoSFJU04gBhNqpfzeAlqh0
	 1Dhhug83tkBkeLBg/wVXaXbWF3MaVzsXEp6RrOUX3o1XcsnqO+TyAGPtGn0KV4d/jCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u4HUVJpN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E23606D802;
	Sat,  7 Nov 2026 14:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u4HUVJpN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFEF51F008A3;
	Sat,  7 Nov 2026 14:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061368;
	bh=f2IlX4YOFRrQo2t9vGAiukKPsY3CRzsOYCQWCikbo/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u4HUVJpNeITuPC8U3J0v+CYE/n6R4nvUw5OuJp/OSg54uwOfo9oj6B+0Vv1A8S8vN
	 XgQP8NEJeAsHMw35dum+e97uvWlNcEx74wcudPaKta9FOzRs7RoTcKCjdVNwp9QgxM
	 wxdhPN5jD5OpTZVtfN9SLP2KdD0m9TmNKQjHvhJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eckhart Mohr <e.mohr@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0491/1536] ALSA: hda/realtek: Add quirk for TongFang XxAF5xxx
Date: Sat,  7 Nov 2026 08:41:47 -0500
Message-ID: <20261107135011.261242346@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eckhart Mohr <e.mohr@tuxedocomputers.com>

[ Upstream commit e72d5659a2606056a0c34af212b46a3275a55bbf ]

Fix microphone detection on built in headphone jack for some devices

Signed-off-by: Eckhart Mohr <e.mohr@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20260821144437.27233-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 2eeb199f3bc95..1a39c59a79ea5 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11751,6 +11751,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1d05, 0x3031, "TongFang X6AR55xU", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x3033, "TongFang X6SP45xU", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x3034, "TongFang X6KK45xU", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d05, 0x30ba, "TongFang XxAF5xxx", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d17, 0x3288, "Haier Boyue G42", ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS),
 	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1701, "XiaomiNotebook Pro", ALC298_FIXUP_DELL1_MIC_NO_PRESENCE),
-- 
2.53.0



