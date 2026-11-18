Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059152;
	b=1J/e8W44eRr9dzaYF1POaUIuVv3O2ILzKq0Zfzbg8IF/GnsMz18Aa3akuPhzC1NXTtnl
	 AoxGLvTqHwZnEONG99VwUK0WiY1A6JWPjZ0beJab9OzXLili9SIEkonja3nfE6QtdEn+t
	 I71yU3ILWR4XJjm/0KG2N39nngpGovozi178vGm40AtxU1XoOYq/j/ROCFiHXEsoW5/8n
	 zNL46eQltj/PK2Eu/ahaFrSIauXXiYguAq4/8O1xAs/0/tdBxgTEUsjIcfamVjnZyJQD7
	 2vJTsvNu2ygDg/zzOOfylOlHxo6ZmN8UbWe99vZun0UFyszF6D3fETJ2bT+Lo5R+aFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059152;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6vWDSzBz6ylBGBbe4NFzq8HvDmzZKn8sozOwW/YvaCU=;
	b=Y4A6Xn6+v4ZPOoOoFlaCV3F2wJol564gjJ/OISDT7iHDRm/HOBi6jnhf8h/FCzSLZSQ+
	 WUXFhvdbzUcNVYGlAVw02u5vkIjb26+KfcTO21O8sFFdXcSobwfT8YNBKYC0MQ2CZI3s8
	 brkIkZCOCnMKVVXFCwP/VEkvUVI8D9KM6wjeO2pZqNi0HCr7gC8h+RfUbNclkErxbWN40
	 cMj0ivDIRQabg1phmDp0IWaoViRkHhtTWqSrEXm/LCnyir1GYQgkuBi4K8gUMZMB1oqkJ
	 E5EXHkR/jkULWyUsmTiVd001Mm8+hiK6Cbmx+B9TpoMZJcV4pcW+rjyowAjBJALwDzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W4AeGVtm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6413606A31C;
	Thu, 19 Nov 2026 03:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W4AeGVtm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F20191F000C4;
	Thu, 19 Nov 2026 03:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059151;
	bh=6vWDSzBz6ylBGBbe4NFzq8HvDmzZKn8sozOwW/YvaCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W4AeGVtmSEiWPvKJgaE51NdM/2AjmX0AWwCG+YIqVFhk2nAh4pensBJT9N2n9FHpO
	 Vyi/jBsAZJfjtyOraetMuh5jagGwoy7186+yt0+737HtpSYwCxNz2F1sac992mkWzJ
	 EFjaXeHll+4Cm7MYEGL6LabHZCJ9EGC8dGCGBUM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Simpson <chris@nilk.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0739/1848] ALSA: hda/realtek: Enable bass speakers on Alienware m17 R3
Date: Wed, 18 Nov 2026 15:46:17 +0100
Message-ID: <20261118145947.301311986@linuxfoundation.org>
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

From: Chris Simpson <chris@nilk.net>

[ Upstream commit eb296114d5ba4d335a640dbbbbc9618fded0ffe7 ]

The Alienware m17 R3 (ALC289, PCI SSID 1028:09d1) has a second speaker
pair, the bass speakers, on pin 0x17, which the BIOS leaves unconnected
(0x411111f0). No PCI SSID quirk matches the machine, so it gets
ALC269_FIXUP_DELL4_MIC_NO_PRESENCE from the fallback pin quirk table,
and only the speakers on pin 0x14 play.

Use ALC289_FIXUP_DUAL_SPK, as on the Alienware x16 R2 and Dell XPS 15
9510/9520: it sets pin 0x17 up as a speaker on DAC 0x02, so one volume
control covers both pairs, and chains to
ALC269_FIXUP_DELL4_MIC_NO_PRESENCE, so the headset mic setup is
unchanged.

Tested on an Alienware m17 R3 (BIOS 1.38.0), Linux 7.3 with this change
applied: the bass speakers play, and volume and mute cover both pairs,
also after suspend and resume. Headphones and a headset mic were not
tested.

I used Claude Code (Claude Opus 5.5) to find the unused pin, pick the
existing fixup and write this patch and changelog; I did the listening
tests myself.

Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Chris Simpson <chris@nilk.net>
Link: https://patch.msgid.link/20261029-alc289-m17r3-v1-1-5d3eac605e7a@nilk.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 25573c62e86d1..4edd1e022797d 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9170,6 +9170,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x097e, "Dell Precision", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x098d, "Dell Precision", ALC233_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x09bf, "Dell Precision", ALC233_FIXUP_ASUS_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1028, 0x09d1, "Alienware m17 R3", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x0a2e, "Dell", ALC236_FIXUP_DELL_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0a30, "Dell", ALC236_FIXUP_DELL_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0a58, "Dell", ALC255_FIXUP_DELL_HEADSET_MIC),
-- 
2.53.0



