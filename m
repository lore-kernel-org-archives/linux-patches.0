Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061450;
	b=ROuWCT2xmyETLuRPm6jTZ/z/p04viYA2U/3PowfsPJEsYHdqEZ4SfAC21wxhCDhVuti0
	 2ofYYktw2jHdb5qlO7UY/ATD3HJYHDZyZ6L8WgHHAfhQYRz001QTIaTlNcZlCZb10D/IK
	 q7FBeG+X3vF0tgzRrXYkd2SF/1UjTC82VajyWyyVQxcTgRaWqh5v1eLEKBmw87MpA6WFs
	 0sm5uyYIA/6Yf880ghmg9k5VtIR4cnqiiWj4I20IMGrX3LM12R8QEmpRCHHuHAkR4xurw
	 rfggeDfG6FBjdxjXmM20e226aXiLEtXeqI1QRKVS4SiaSX44gstA9EONBbK0Rq0/CPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061450;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Oh86IPqe5b7vDgCJfdp+k1EjqirV5Dme90wpxqx63Zw=;
	b=oxnZfY86WicKWjGU3pcG3uE2i4ADPe8TUTAev8kaPX5JEUuBy3Uu73OUpuG2ivfUMHec
	 rmhQrPMQKBO6y4fvZMH1MavFovIRW8Eij+D36O2g/nkZ9h2bRcs5TbL2PKiaB00o4LLmn
	 vJV4/4yehBc5m28QLvlHthFdPe/OwaEP67H9PLtVoTdlBQqf2ZmV211ARkG4VvpXzcJ0D
	 VW3fpYk4qXGUosJsux6SlHMGecaeDVh8Fze5ZDOwOYIfemhWdAv+zmeT2lPdHN0YWxAQS
	 TYO8e5nuBpRT2KR9w+fJd8SoXAqZ79LYnIyIOjfAE13ss0LehHfokAB18YYGlyCiobg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lbzSZrFe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD205606A331;
	Sat,  7 Nov 2026 14:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lbzSZrFe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA2C1F0089F;
	Sat,  7 Nov 2026 14:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061449;
	bh=Oh86IPqe5b7vDgCJfdp+k1EjqirV5Dme90wpxqx63Zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lbzSZrFe50idwHjPrAS+9Bh+wgTFr/MgjGcIEDn+aB2Z/KeDvLNSXNTN056pzRJ+x
	 RZTERnFZt0aiKkpMTHza3ECV00pELX/DypF/55tzALamdRnr2y6D73dvDbX6Z9E1Tp
	 dUIz1FVsApx/1lWEC4VuFqAwADxYla8jv/6icinM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu-Hsiang Tseng <asas1asas200@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0538/1536] ALSA: hda/realtek: Fix silent speaker on Higole F9B
Date: Sat,  7 Nov 2026 08:42:34 -0500
Message-ID: <20261107135012.708152596@linuxfoundation.org>
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

From: Yu-Hsiang Tseng <asas1asas200@gmail.com>

[ Upstream commit 2a8ee6897302ca12ff39e8eb180503956797c60c ]

The Higole F9B is an Alder Lake-N mini PC with a 7" touchscreen and an
ALC269VC codec (subsystem ID 0x10ec111e). Its DMI strings are all
"Default string", so the SSID is the only way to identify it.

The internal speaker is silent out of the box. The generic parser
assigns DAC 0x03 to the speaker pin 0x14 and DAC 0x02 to the headphone
pin 0x15, but the speaker only reproduces what DAC 0x02 plays, whatever
its connection selection says. Checked one path at a time, only the
gain of DAC 0x02 and the mute of pin 0x14 change what comes out of the
speaker. User space only knows the path it was told the speaker uses,
so selecting the speaker turns the path that actually reaches it all
the way down.

Route both 0x14 and 0x15 through mixer 0x0c (DAC 0x02), which is what
ALC290_FIXUP_MONO_SPEAKERS already does. Tested on the device: the
speaker plays.

Cc: <stable@vger.kernel.org>
Assisted-by: LLM
Signed-off-by: Yu-Hsiang Tseng <asas1asas200@gmail.com>
Link: https://patch.msgid.link/20260923141344.1543158-1-asas1asas200@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 1a39c59a79ea5..fb79b82e2ea6e 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11408,6 +11408,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x10cf, 0x1757, "Lifebook E752", ALC269_FIXUP_LIFEBOOK_HP_PIN),
 	SND_PCI_QUIRK(0x10cf, 0x1845, "Lifebook U904", ALC269_FIXUP_LIFEBOOK_EXTMIC),
 	SND_PCI_QUIRK(0x10ec, 0x10f2, "Intel Reference board", ALC700_FIXUP_INTEL_REFERENCE),
+	SND_PCI_QUIRK(0x10ec, 0x111e, "Higole F9B", ALC290_FIXUP_MONO_SPEAKERS),
 	SND_PCI_QUIRK(0x10ec, 0x118c, "Medion EE4254 MD62100", ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE),
 	SND_PCI_QUIRK(0x10ec, 0x119e, "Positivo SU C1400", ALC269_FIXUP_ASPIRE_HEADSET_MIC),
 	SND_PCI_QUIRK(0x10ec, 0x11bc, "VAIO VJFE-IL", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
-- 
2.53.0



