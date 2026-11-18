Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044292;
	b=ymRgrGIUN7lsALQBF3G7B2ExK7qGTLwYPTpyJCb7+3BxxWCK9apSIjhCLoGGzXwsQzlI
	 57nk9Se8Ny3dyZyudBjhi/f6Qa2PQa22T+3lA9HKlS6xrGdzL/z60LLUvrvmtSLm68aub
	 U3VJM8/b23hkY3CnooDKoKeo0gBVAVQrfriaS2lSNoPXvMx5JWJZ0aSN1Wi0cbS60liVb
	 NKxCaXRaHWxhelmFUy6PmNtxaG12247Xqc1V3ysztEt3QxqGKXD8mFBa/odW+K4guGw2u
	 wkOJwHrf2dTG9fcFX/YRsQQXQtlFBtBgrfw2BnBKA5d/m1/MfD8Zs7iIRaYdOktRBdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044292;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=csoNCKFtoUrVfNipu1/zaa++1541JFnSPxjLfmamjdQ=;
	b=07XC4kvDnlNXMTCj0muPoC+lgBr6OsJecG1xbKpYDI0H2tRicKq1eAqAEjY/yS4l3+yz
	 FmnxzJCBtNFFM77Njv6YSrS3TpAcsGqjWby19ktqPqLN4nSxAn802ax1ILdj5FnZ4NkFP
	 lEVSleUujlkXvYAQ8tKUAhrVhrugUewlVOPdxkr7xUh7bHMlCwe12gmiR7IFb0KNegwOB
	 qpyBJyHP90WsRm4CwiPHuuzSnyuuZCxthniqQm1HP2zHHn2eei0HpgbgELKVp7iOUM/et
	 kGD6B+puCWDAaHLJAeyfrGuMH0QfkD8GWEVxrlIduwRC2HwYEMw1GGyg6f1c0eCbDgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pfU3P88B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F73B606A320;
	Wed, 18 Nov 2026 23:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pfU3P88B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497A01F000C4;
	Wed, 18 Nov 2026 23:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044291;
	bh=csoNCKFtoUrVfNipu1/zaa++1541JFnSPxjLfmamjdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pfU3P88BvF96sUa/ICdW/hmWZGj3fr4EHNUoj8qH+ce7aZ/rcPcr3eqvVsKW73ePX
	 /ycESqR70HEKcFQqNMg/Wr0sucBDoPXBxkksgQnAHtpFzTpbzypw6EKPjjSzj0QrEq
	 XkiydhcNaMN/rU7Xb9rkMvCvbmTjMK8CSEACZtgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu-Hsiang Tseng <asas1asas200@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0468/2857] ALSA: hda/realtek: Fix silent speaker on Higole F9B
Date: Wed, 18 Nov 2026 15:25:02 +0100
Message-ID: <20261118150218.302047676@linuxfoundation.org>
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
index 5d4b8ccc6cd08..a221568c08f25 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10247,6 +10247,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x10cf, 0x1757, "Lifebook E752", ALC269_FIXUP_LIFEBOOK_HP_PIN),
 	SND_PCI_QUIRK(0x10cf, 0x1845, "Lifebook U904", ALC269_FIXUP_LIFEBOOK_EXTMIC),
 	SND_PCI_QUIRK(0x10ec, 0x10f2, "Intel Reference board", ALC700_FIXUP_INTEL_REFERENCE),
+	SND_PCI_QUIRK(0x10ec, 0x111e, "Higole F9B", ALC290_FIXUP_MONO_SPEAKERS),
 	SND_PCI_QUIRK(0x10ec, 0x118c, "Medion EE4254 MD62100", ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE),
 	SND_PCI_QUIRK(0x10ec, 0x119e, "Positivo SU C1400", ALC269_FIXUP_ASPIRE_HEADSET_MIC),
 	SND_PCI_QUIRK(0x10ec, 0x11bc, "VAIO VJFE-IL", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
-- 
2.53.0



