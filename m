Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034863;
	b=Uwk1JxE3axUNMbMYhHlCuXYYrVD7LvnzEntiqlBn/+vH6wquvu2WYBaCOJIROzNpz6f8
	 TCFGTqPTjYbev6aNVgwkCPErIa09dytUSBl+ojPIZnoIDVLhfv6oGVN+VDQCOjkRmgzat
	 bdPxtiNkHRtBAWHskM7uvMBXgATMGo114HbMY3tw5TjHMx3WqjEPQW0AzWy1Yvd5XXqdF
	 sSmvqtGUzhY5W5ZpbhjAGdffINEkLIG07ZrLgGmptthMMs3xg8l3/bc9kg5plfAirxOwe
	 oIU5vmc0cEaAoPow/fCed3qLFtAHcQUrQTgDewcnLk2qrGFb8obxwg/K2ujnOrPmfGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034863;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GAOtAMxe/1vQuFqaHJmdSuXJ03vIM3QtE1T0hUILri4=;
	b=MiB3Xny7wJn9/TNeNsZ4v2Ilo2Z8QRh16XNz8o4E6Q/8tseLdt730fvnQAJIAWCrFKl9
	 fzAzTfvBUtTd8Cj9ctw+XoypjC0vxaZTQ8f/kmNL2+C0Y4P5q6rBTX71egr2GlkTbDwzB
	 1MQ3ugKHXVWRo7uDKYhjfgq0Nfvre4epdDnq6GLbEas4DiClfqecMQS1X1Mg8BTKQV7WK
	 lxQKb/HqeflBaUnmkcwlYWuF0dDSc6hwFlMu6b54ORhDCn1QzsK7rn+L9f56SW98Q/2pc
	 pbUb1UP4E6bQwJnAKi4rYY2fyFHWTvDjas7FN2HNqZFHSU+YBqlmoUo20LNNOLX1MwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gAZ1JJiJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43B8606A325;
	Wed, 18 Nov 2026 20:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gAZ1JJiJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190D11F000C4;
	Wed, 18 Nov 2026 20:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034863;
	bh=GAOtAMxe/1vQuFqaHJmdSuXJ03vIM3QtE1T0hUILri4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gAZ1JJiJEQ2JneQAPORJGPKXmeqGGCnK9zD3iE4YMDPXHJIAxdyXStsZMMdeOII8c
	 9qijjdn+pJdDGZzH7HT3/oqGNsgOS1z4qd/uDfOmrL859plyqPXOMErL8BDiaurn2+
	 G9F9yPGpepo19PJfWHGuQg8LjF1ldlRB+DW9Qlm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu-Hsiang Tseng <asas1asas200@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0520/3318] ALSA: hda/realtek: Fix silent speaker on Higole F9B
Date: Wed, 18 Nov 2026 15:19:02 +0100
Message-ID: <20261118150332.770866326@linuxfoundation.org>
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
index 24c7ce5f08660..8ebbbc731f8ac 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10460,6 +10460,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x10cf, 0x1757, "Lifebook E752", ALC269_FIXUP_LIFEBOOK_HP_PIN),
 	SND_PCI_QUIRK(0x10cf, 0x1845, "Lifebook U904", ALC269_FIXUP_LIFEBOOK_EXTMIC),
 	SND_PCI_QUIRK(0x10ec, 0x10f2, "Intel Reference board", ALC700_FIXUP_INTEL_REFERENCE),
+	SND_PCI_QUIRK(0x10ec, 0x111e, "Higole F9B", ALC290_FIXUP_MONO_SPEAKERS),
 	SND_PCI_QUIRK(0x10ec, 0x118c, "Medion EE4254 MD62100", ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE),
 	SND_PCI_QUIRK(0x10ec, 0x119e, "Positivo SU C1400", ALC269_FIXUP_ASPIRE_HEADSET_MIC),
 	SND_PCI_QUIRK(0x10ec, 0x11bc, "VAIO VJFE-IL", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
-- 
2.53.0



