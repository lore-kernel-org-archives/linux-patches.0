Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057635;
	b=ZvwfqAS1r/FAqDuhP5PG4eIRMjSFBvqNHqMOiNho/hdit2U6lGjdfnliAVunko9P3ICa
	 jefCNepYE6s3AnUSiTs3fyPnIvZ3kwJHJ/iaX5Gv37L9npgI21f2Z9sZ3/ZEafIOJbSpQ
	 9de2pPEEt78cIfy22JoZe84335+izVbbjwVr8hWKsHnuXBqpwOisByL4a/b0qW4ocHO7e
	 7UPbF74OnGxmD1glpT4PFq2Umop8CR2uBsq9P5vqxPyj2UA23uUy4snlgnxVnpSzyWa4n
	 SpRcc5wXK2BxEFL3SXiYogYIwVE2a5JsKFFYQ7orT32eWNQGhOjmuYm0GeTSx12VuQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057635;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aWKLoE+4B5/MqnAy26uTOrY644s081VVTRQ2GhN653k=;
	b=SjjFF8P3pknOomJEw1Q1dOW+eZL43MFVMgtSmS12tcNsdC9mRmJ0L029TQUz42tHTzZh
	 wTIvasWN6XBbFfrTzgykgB46FxEUjP+nNHnkeFh79lnmWOi/KyDwvI+a6MEluUl1Hj1TT
	 sIopaEhykupCiipAziBQW7gZ4dQWg6tVTymDi0fd3+NpCppGnLdcoYTCM9Duj/eHIMEmo
	 tMlQwzKQIDrK3lBf52j4HxDKzXAHpHVbNh7KHVmGQvLCMklKjJMpnaZ/DmrJhsWqlfXxF
	 qpQ2tWfHqiwQuLI9nzUt2AsKEgzBftAV+TNQh4hR7GiXG93GG5MWAuoamV+TCWn6kiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZvxAIU97;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF3A60A2603;
	Thu, 19 Nov 2026 03:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZvxAIU97
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6971F000C4;
	Thu, 19 Nov 2026 03:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057635;
	bh=aWKLoE+4B5/MqnAy26uTOrY644s081VVTRQ2GhN653k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZvxAIU97wiktSmbau59YUyDG32lg+VFY8WncCbhOOReX/L3Q58kKeMr1FMXH61qMc
	 Dp1VQUugvRNFEchsEESXkbgmS18QE/1EZkehjIGYck7sasc+CHWGBueEXF3FAmUB8g
	 G8xkxUaqQCgCNFgMiyotHHCvf6PvMwESrKaokISc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Banha <luisbanha26@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0200/1848] ALSA: hda/realtek: Add mute LED quirk for HP Pavilion 15-ec1xxx
Date: Wed, 18 Nov 2026 15:37:18 +0100
Message-ID: <20261118145920.187022504@linuxfoundation.org>
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
index 69f59dceb6b59..52a4433686313 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9292,6 +9292,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8786, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8787, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8788, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x87b2, "HP Pavilion Gaming Laptop 15-ec1xxx", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x87b7, "HP Laptop 14-fq0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87c8, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87cb, "HP Pavilion 15-eg0xxx", ALC287_FIXUP_HP_GPIO_LED),
-- 
2.53.0



