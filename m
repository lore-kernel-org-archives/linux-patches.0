Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043688;
	b=E6mSCvBgqk+LlEUCMsV6HOvhVB2aROGOyzeMMfiS/B7XHtwcp4xsLl7bKY8gWmx+M+QE
	 hGALq4SvVgyLDl+Afv8iS1BKivNWkoj3lSdYjlyr/y72i8aDgtZfnyHNsQajidBWnhMdn
	 22bNvW2pu7+wR3bfEEPxTqTkd3NA3Jzosjjdc4FJi9X4qcLeuXoDGfRAsI0VD9h7eONUi
	 LIOJANPnv+4P88RHtNkTyANWqLpDM/b5hIUz++uyy6WzMhbLxRNsK3BTpvcV6Un0aDpKL
	 Ud0/Gr0Qyqm/PRUA5MxDErGAs98cYNgaA6x4mqFGUNioGl6maUnAHDoGWitZ1FCReJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043688;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xoayPLyDomb09Ph7KUOM7/4l4+V/H4XXhwCA0e5o7RA=;
	b=YUboosjpXQhgU4owM868Afn3/FXgMXL/6OBbWbkdpl135NspdLJuWxBZHRDNRa/s/TWw
	 yV6xOpczqe1Lw8zkoCarf3UXAEBNIXBlySqk7cmMzSmrvcXeHhH6MuQzyXzhcPfoNLDfF
	 HYOjdHK3EY99Ts7pKwMC6COiRf2ZgMBA8XooiW9Da9TEyNEDtcZ7m27JE6eB0g/LZKErl
	 6GBDMy4nqlB5z/WdTCZ6KpWRFaQA0vuQO1gFXS7eRvhj5gcf9Q4COMVC4OAWvrJOH7jnY
	 mgze8Yg7dgfEBTtWNsMxJG5VRn+HCD+oe3uh+Zp6G9H7HSCMUFsQePV1yqgeeo4qaiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T1Lt8xTb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA22606A325;
	Wed, 18 Nov 2026 23:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T1Lt8xTb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7DF1F000C4;
	Wed, 18 Nov 2026 23:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043688;
	bh=xoayPLyDomb09Ph7KUOM7/4l4+V/H4XXhwCA0e5o7RA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T1Lt8xTb/ID4PubdLvulw3j9PTZfMsrYN5iNRSqIt/5PN050plaUZSCS2fD9nIAhm
	 kViCXYE+srBbR3Ui+sYpsAPHy5JqP93tGhqGunWy4i95CssjGI+k4e5onxaVqUulz1
	 ZoMi/OLrXvnr1TMXyAZEgCD1KYuj5ByJgDZXs1WQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eckhart Mohr <e.mohr@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0299/2857] ALSA: hda/realtek: Add quirk for ASRock NUC BOX-358H
Date: Wed, 18 Nov 2026 15:22:13 +0100
Message-ID: <20261118150212.185016831@linuxfoundation.org>
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
index 3d140bc5eb7bd..920d2d65b0be7 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10467,6 +10467,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x9e56, "Lenovo ZhaoYang CF4620Z", ALC286_FIXUP_SONY_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1849, 0x0269, "Positivo Master C6400", ALC269VB_FIXUP_ASUS_ZENBOOK),
 	SND_PCI_QUIRK(0x1849, 0x1233, "ASRock NUC Box 1100", ALC233_FIXUP_NO_AUDIO_JACK),
+	SND_PCI_QUIRK(0x1849, 0x6256, "ASRock NUC Box 358H", ALC233_FIXUP_NO_AUDIO_JACK),
 	SND_PCI_QUIRK(0x1849, 0xa233, "Positivo Master C6300", ALC269_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x19e5, 0x3204, "Huawei MACH-WX9", ALC256_FIXUP_HUAWEI_MACH_WX9_PINS),
 	SND_PCI_QUIRK(0x19e5, 0x320f, "Huawei WRT-WX9 ", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
-- 
2.53.0



