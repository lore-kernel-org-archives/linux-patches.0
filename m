Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051547;
	b=uCfajfzXxxA9ROLkCZqpdK8sh9wSbGpWja2w5gsudsyylpLJplGNmmdnPb6O6lsgvgdm
	 vTL13lGBAKH5N9CjIB7WwAowYffrmqSMias2Mjke78SeXJV0vmzz9f5dcbE/JVHSu/DKr
	 IlPpwqt1LB0zFf3c4hj3165YWC23fpPIXrdKsDaDUo8LqhdmoHyME4MF35gvc2R3iBns3
	 IGQQmxlT8jftEHZgVjN/z7YOQXM2vMG5Uxdh/FFTUXKfZzxTiJmxvnlAxw5P07jfHkXhp
	 agOXg0UT3ISe3+ut4Xob8SBUkxIemAIRpdlfanEVGtlCgNdRfZ2yR7DeW21XGZWJR+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051547;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rHsVq4CnbUDsrZ8+uDGBsuh7+wrcKsz5hcGAItchO5w=;
	b=064jfrwjCB+4sZjMlhpfXRhPiU+AAVM2G/y8Tem4wXDrF1mIR1tNOJcjmM5xYztTupmF
	 lFVYwS1dS29r4vMc/BAIkwMiDiSccCVbu4t5NBONwXoSg/RUQG3yg65jkOOpvln+S02f5
	 cEg8g8uynk/iZ1G+4O4ZdMMjQ2w3gPzaVJzJzXjcmA7nm3poaZEiKBbpXvRI3v/yRd+Jn
	 GpIscf3Zzzcm6DXPI9yYMam4QnIjIM6TCu4jUlokZkJMjgBUvcpnyhGEq8ikgL3j+wBJf
	 +LhJFgFAalraia3KSubun0MBpik6/Jw8VW+00Tg0igfNKtH8TKugst2yQAIgtpdcKLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="05uz/7fv";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB06B606A320;
	Thu, 19 Nov 2026 01:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=05uz/7fv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D2A1F000C4;
	Thu, 19 Nov 2026 01:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051547;
	bh=rHsVq4CnbUDsrZ8+uDGBsuh7+wrcKsz5hcGAItchO5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=05uz/7fvmVitJ214+e3qpCknbIfUqTagzVQQ7KG8CaIK/puWVi06BURtCrH9WiWxl
	 2mheuLXK/M1z0gSObp2W3zpyCdNZgEMtIAsprVI4gls4ZRgoU9/EM1PV4d9F7FZ36W
	 QwwHdpCzFPFk7aCLOA31helOBOwdAMAVGam3gZ44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Banha <luisbanha26@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0246/2214] ALSA: hda/realtek: Add mute LED quirk for HP Pavilion 15-ec1xxx
Date: Wed, 18 Nov 2026 15:32:02 +0100
Message-ID: <20261118150020.008029871@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b1ab622c8c569..44f32f919eea7 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9361,6 +9361,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8786, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8787, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8788, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x87b2, "HP Pavilion Gaming Laptop 15-ec1xxx", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x87b7, "HP Laptop 14-fq0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87c8, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87cb, "HP Pavilion 15-eg0xxx", ALC287_FIXUP_HP_GPIO_LED),
-- 
2.53.0



