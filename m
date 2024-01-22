Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48DC657BD;
	Tue, 23 Jan 2024 01:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971628; cv=none; b=NtPsiB3dXAneobYpD50zg7U7jtC3T+pNCnOSD7t60rEw5COPiCjJpwRBHQTQoO+iu3eMmI+fQ6B7+XYbrUmYN7gMGNCFTiaGUg2Csb0sKg1aHBd5KUDLPQtelYqCfAfGVaiWuZCgF820HJi9eEBMVR/tUXCwu/gd5PsYYIaFbU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971628; c=relaxed/simple;
	bh=qFZVtGIpI2vOrd+6MmIGVm3L5m8b320V5W7u7fXg0tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PzvcfDRz1s0dxfMkfyTkEvtBFG7coa+w7WvUyc7sWi4Hm+CS1lGxg1BGvqQQeCFEOfS6eJwjeDgI+4lGsI2ypu96ADAncD/O9uyKncd6/7b2tJN0OdCrJqp5ufo8WFgICRpG3M1oFq8cne3EIQow1hKD36TDDqEEGuV3DOCoBIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YIhEpaAH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YIhEpaAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B35C433C7;
	Tue, 23 Jan 2024 01:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971628;
	bh=qFZVtGIpI2vOrd+6MmIGVm3L5m8b320V5W7u7fXg0tM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YIhEpaAHk70RdDQ3wfVpMzmpV0N+ZO9zP6EsVqngPCJSgmCRi93oHGt1iSzNOaQcg
	 9z4NZAwswwKNq624CyfsEU2jSUTDSnSpGqkVfdxPYlcOmC8+kt2+7vEF4T6yyqi1Ck
	 cLO+NdoDiyeQX6UkuyxbcspVU4dy6wxj6bUxO7PI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yo-Jung Lin <leo.lin@canonical.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 281/417] ALSA: hda/realtek: Enable mute/micmute LEDs and limit mic boost on HP ZBook
Date: Mon, 22 Jan 2024 15:57:29 -0800
Message-ID: <20240122235801.572902023@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yo-Jung Lin <leo.lin@canonical.com>

commit b018cee7369896c7a15bfdbe88f168f3dbd8ba27 upstream.

On some HP ZBooks, the audio LEDs can be enabled by
ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF. So use it accordingly.

Signed-off-by: Yo-Jung Lin <leo.lin@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240116020722.27236-1-leo.lin@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9721,6 +9721,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8c71, "HP EliteBook 845 G11", ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c72, "HP EliteBook 865 G11", ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c96, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8c97, "HP ZBook", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8ca4, "HP ZBook Fury", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ca7, "HP ZBook Fury", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8cf5, "HP ZBook Studio 16", ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED),


