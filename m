Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034387;
	b=ORRisC8gUryr9fBQXnYepaWVgTKAP6bUaJBpJo1wRSDTgnhpse1ZMSBNyg8VDXsdyVQV
	 Hxzx4h04CNFJQAoEe/bp8sqatVAH6r+lsQOfLUxNf2WzX1qJcEURJbtmVQlQMzf8S7pzB
	 Sq4vk77Tgz+EvRcMQMoQ/EFRNW7XlmtxNlTClJ33oiK9W1WaHC1NJlOkktX/L5GR7RQno
	 DTs86ZOBaDmMmZ2iPnzlreAUNLePkvFfwCNsfUAn6nR6PTL3AGS3JVKcf8hKcgNjkoTT3
	 d6NMHmQfvSCR4l6h481ajvTigViTIsL+C9LrqedQAmvO+eYy8MLpYPAe8f/Nrk65jqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034387;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=04WK48u1ATdMqXDKtUYfibQuhYnDoAz2FEmOZCdVDX8=;
	b=Ndm761ADhLiafKNrxsrSYcZ3Mtl5T3N0tPm+Ie9mxRVPbjYSlMmDcUdp1GhfoF+sdKVG
	 txpwKeIqRvpINIcmEPOyl4dVQKhe89QFGTabgz76F4l6cBQsASm/igs21Wueu/R+luxZ9
	 Ew8U9tZGeYSCwclfY6g+vzIzLJg5al0bbOyBQWM/1WMBPejcZQYHtT8ZBLsmQIbXhR+Hs
	 AsU26pZQUhIijor57Z64yg+3qPnf5kVuX8uXaSFk4VFQBjVF5lbEFRezpIgjfgPbt5Lx1
	 fh+Zx4GwzYqXmDbliCX7YKR514/AHWWoDVnlj86Sm5MHsZpU8JWeCcFGfZZOzXi79kA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ai0RUVcV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55051606A320;
	Wed, 18 Nov 2026 20:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ai0RUVcV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1391F000C4;
	Wed, 18 Nov 2026 20:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034387;
	bh=04WK48u1ATdMqXDKtUYfibQuhYnDoAz2FEmOZCdVDX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ai0RUVcVBYzYeP3PLQlTK66tSdCHEyVhcQP2seCGAybSkHVtQ6SF6i9a+/RqSSSgE
	 6oSbrZK1ICbFWCduxIP810POp+VKftHQOK3wzeAmExCwNqpxQww+jCTqKRPj1McY/v
	 UB92/w+ZtTj50wVWWDQVlarOUnLNTFMY5xTNWjB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eckhart Mohr <e.mohr@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0351/3318] ALSA: hda/realtek: Add quirk for ASRock NUC BOX-358H
Date: Wed, 18 Nov 2026 15:16:13 +0100
Message-ID: <20261118150326.591946906@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ce5c948802307..9a57e073fab11 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10709,6 +10709,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x9e56, "Lenovo ZhaoYang CF4620Z", ALC286_FIXUP_SONY_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1849, 0x0269, "Positivo Master C6400", ALC269VB_FIXUP_ASUS_ZENBOOK),
 	SND_PCI_QUIRK(0x1849, 0x1233, "ASRock NUC Box 1100", ALC233_FIXUP_NO_AUDIO_JACK),
+	SND_PCI_QUIRK(0x1849, 0x6256, "ASRock NUC Box 358H", ALC233_FIXUP_NO_AUDIO_JACK),
 	SND_PCI_QUIRK(0x1849, 0xa233, "Positivo Master C6300", ALC269_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x19e5, 0x3204, "Huawei MACH-WX9", ALC256_FIXUP_HUAWEI_MACH_WX9_PINS),
 	SND_PCI_QUIRK(0x19e5, 0x320f, "Huawei WRT-WX9 ", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
-- 
2.53.0



