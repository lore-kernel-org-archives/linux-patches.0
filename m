Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057646;
	b=e8lAc4/o80cKAgjJy0FQ4JObqDVF0/Bf4RR9qCwNepmOE2WYiCeybimAY+BJAGGTaSTa
	 sU5kanW4EdUTqvSzLl0OLFfbnLS/LYX8NrURZYWzSpbBJC/RuarsQurWIUrmdPPktD6r9
	 2wD0v1TvyuuKJC3LIerGySR6O/DBlPUSoW5T8+n4BYQvrmyyeqynXvtrEafIiKd5JpAEQ
	 06B8B//0jps5mNL6H2UHufc3SLlHcjN7HNhKA/2s/x94Xctn+ufjyOz+KDI08be6lUhSN
	 CBL4t2H/AkoVGuzoweiOe9V6tGmOe0G1uerLaAviDM+UQlmk7RfQt9h0t3fPD2KETDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057646;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5ndognTWvf1Ifq6Je15KApgUftykbf3MC+WNvHOgjqw=;
	b=2v1Ho6+Wy/0rTChf1gs/6alVL3LyLctry4Z230khrjDZE3MXPrO5v8gnD0I41mePeW3U
	 f7Gk8RPY6yGiJQoaw32d2ZYmXwDaK94e96XDJ4Q+ot2fPnVKU0tT2ZXoaMlWv+FQV1gRX
	 dtqn4dhSMTuR85x42bYn9+izl0CLBCFP5lBgf3eqz4k7eMxvcUjWl7P97dg5Tawvu6oiv
	 +HzVzJpZW+cAmXjWdvFKOUm7DkUAqjX+cehc7HogupcWcPEoL3/MuWmAih9AyXLk/8j4z
	 +GW/I5E3Be8aj4LGWYrZNbEDp4lVMaQt4+d3MKvF/CRk/wmAsJnmjVlcc3TZtPlcD8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o9ahHRHr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D5160A2600;
	Thu, 19 Nov 2026 03:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o9ahHRHr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B53941F000C4;
	Thu, 19 Nov 2026 03:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057646;
	bh=5ndognTWvf1Ifq6Je15KApgUftykbf3MC+WNvHOgjqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o9ahHRHrzeNXzh1rDsWBPLHllFcFKWwsB+IMV5kwmXAdfvawGRdDjq4Y69GryHVtG
	 XtBa2THLlYXDvsARQvQ2QIvJilJkjg1YH4WwaflkmL60dkPiDxl0tzj8nQ2MTmO4Lc
	 y4Q182ynxTkDVUbFiajX1hXiESD3iOsHL77xAsb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eckhart Mohr <e.mohr@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0204/1848] ALSA: hda/realtek: Add quirk for ASRock NUC BOX-358H
Date: Wed, 18 Nov 2026 15:37:22 +0100
Message-ID: <20261118145920.416647718@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eckhart Mohr <e.mohr@tuxedocomputers.com>

[ Upstream commit 9a44b828dd7c0be1d0d6d6cf178d9727ceb6da6e ]

Fix headphone jack detection for some devices

Signed-off-by: Eckhart Mohr <e.mohr@tuxedocomputers.com>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20261001183403.103990-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 2cc9d961b96be..25573c62e86d1 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9601,6 +9601,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x9e56, "Lenovo ZhaoYang CF4620Z", ALC286_FIXUP_SONY_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1849, 0x0269, "Positivo Master C6400", ALC269VB_FIXUP_ASUS_ZENBOOK),
 	SND_PCI_QUIRK(0x1849, 0x1233, "ASRock NUC Box 1100", ALC233_FIXUP_NO_AUDIO_JACK),
+	SND_PCI_QUIRK(0x1849, 0x6256, "ASRock NUC Box 358H", ALC233_FIXUP_NO_AUDIO_JACK),
 	SND_PCI_QUIRK(0x1849, 0xa233, "Positivo Master C6300", ALC269_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x19e5, 0x3204, "Huawei MACH-WX9", ALC256_FIXUP_HUAWEI_MACH_WX9_PINS),
 	SND_PCI_QUIRK(0x19e5, 0x320f, "Huawei WRT-WX9 ", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
-- 
2.53.0



