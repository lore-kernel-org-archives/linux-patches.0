Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043668;
	b=TJuuAtfmQ/uV5q6GBr2J7/WqzS/5EvSLzvPBlZZv2OyQ5ANzBRKtPA+YRrgE7UU5f+o3
	 BS+CxndGlxf/noSsoa3lEGfgHET1FrP8nqQJgIaItCTJ6XxpkIjtVI5JiGPI7e25ZyXLN
	 8QFkZYVfG/J7iySTNjsMOLPbjoLf7Mu0i5Bgbkfn/8i7+ppax86NFNfPQLx/rO0IfQ+XQ
	 UTIJ0snkVYV73sUfSKMVAZoOAjcch0P6+WZtuS30+2Ybwqj4u+leOa9/VAXrb65Y+zk0/
	 ieFOybZit1LxpwQqt3g7izJ39hVzasgmk0w0Hvsz+M8preDe4VujGeOK3+JQSo2bAVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043668;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OjUbdBSFGbl/oNC7dyhrGL9+jc4H+CMdNWA6PN13bS0=;
	b=HHSylOU8ZnpjMMuP8UqsR1FfV5EtvvyO17TIm16dmRZ9drjl+b6MiqgAsUUu4sJenIln
	 LM7OXwDtSHo1upPU61oNQTDwL4vZ4gzFo/Ed63GcxgjsBUrtqIAGFn4P0MyndomYSzigH
	 VViOKIPFYNbWtSLt6Rx+0vxSE4/n23lK9UwJ8HrKXF1ogT6+XKWLapQUofpcupiUTMhuH
	 yLMUIrmA2ecjtKLJrF7VgCVQvBWUZs62Q9om1xDII7DzEM85Be6mVqnsT60BUa0XlzGj2
	 dZjv75h4zQ9Yd/r19jYrcafRAgOO8qh0bbce1VH9C0LkrX2DrOyWL3ULeOyJvlSq3ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hV1oeAyZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18F9606A320;
	Wed, 18 Nov 2026 23:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hV1oeAyZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9CC1F000C4;
	Wed, 18 Nov 2026 23:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043668;
	bh=OjUbdBSFGbl/oNC7dyhrGL9+jc4H+CMdNWA6PN13bS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hV1oeAyZS3sekFcALO+wDYz2p18pptAC34NBsgy443H7DT0L8PTTN5PqCFpUWtZw0
	 /GnKvfOx1nZjf5DRxuxNHOv81vqiWDtAjJ/JKMvhTwF9HFkgb5v6KgLP9pTG4x+egd
	 yRyfjdo6+7/kALDqj+Jvb/3GFL56kfOHIsE55qxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Banha <luisbanha26@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0293/2857] ALSA: hda/realtek: Add mute LED quirk for HP Pavilion 15-ec1xxx
Date: Wed, 18 Nov 2026 15:22:07 +0100
Message-ID: <20261118150211.966884134@linuxfoundation.org>
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

From: Luis Banha <luisbanha26@gmail.com>

[ Upstream commit 775aa96c310d59f3d15a6e5a9bd1796fd1ba95ec ]

The mute LED on the HP Pavilion Gaming Laptop 15-ec1xxx (103c:87b2)
does not work automatically. Add the ALC285_FIXUP_HP_MUTE_LED quirk
to fix this behavior.

Signed-off-by: Luis Banha <luisbanha26@gmail.com>
Link: https://patch.msgid.link/20260921230105.16844-1-luisbanha26@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index f2450c59e661c..0d8ddcf43c66f 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9972,6 +9972,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8786, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8787, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8788, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x87b2, "HP Pavilion Gaming Laptop 15-ec1xxx", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x87b7, "HP Laptop 14-fq0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87c8, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87cb, "HP Pavilion 15-eg0xxx", ALC287_FIXUP_HP_GPIO_LED),
-- 
2.53.0



