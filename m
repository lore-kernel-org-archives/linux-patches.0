Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027132;
	b=g+Xr0Dthviipt5MAIFHT9J778lMtYMbTlm2b/s5BAukNCXw+rypSJU71FfIat1zK0IVo
	 LcMrfaVblbxV9liNIhigfMm2rELnMgChd1SRKQ/sMCk5U5QvVgMY7+Cx9wERKRYRnqDr9
	 tfHChTgcSeJ61hzGhCfBT5Qljkn6zUrLhO8aEfwsK2UBrcls+UNBANs9ru49t+pV382Ma
	 zJTIJr36I/+XsTYIVEn9/ZW8tHbL9YnOT/cU67bw6YzqtzSCvsaOEES57QLZ3dKG2nAvh
	 g+sMvj+IUC7ZUHtJS5BGw7S+unabgpqjCwwutRpC7LspuGy0UMx3/4V5MfFDnIpMwaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027132;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v6e/z06efzuIrID2mtGIqg8tNTw5NnPYdZhROe/iGQs=;
	b=FWZ/w2fWBgqVm4Txh9L/XYqyMNGuPk3nhTdNPGP7PYYexkwOadUhTYlTM7no5EsaXoJk
	 IvbdwlryaBT2Qa8Qm4DH9jajsc/UFGkKp4IdEDAasqQt3GzKa/FcbMVazHfOTSFsw6kuI
	 S7U1rufGbnJ0BDlb8qwuiYTMHBRGzHVYVsO0CWZ4Y3KiEA6I5XsH/loY5D6Ctubzmv/1/
	 ShhMVwdECr2J7ZelipSTzOBfuBvyrMu7V8f9WOCQM+z1u6U5VowJJGFmahGsri37B49/T
	 4maJoTyV2Gd7Tco4NSYOInrn82MSUea+e0CVL8pvZc+jv42eu6jebVefA5du+P1oYzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uo+7TTCy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4B8606A325;
	Wed, 18 Nov 2026 18:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uo+7TTCy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602311F000C4;
	Wed, 18 Nov 2026 18:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027131;
	bh=v6e/z06efzuIrID2mtGIqg8tNTw5NnPYdZhROe/iGQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uo+7TTCyLmcV6mFqA8w3S9W7xlu/kDZ8AaPCsRpcogfS3Wh7w57dXUyozpSyB3Vj/
	 ZktWf/1IDdLuZOyC92EMZyb+wFM079dwvNG9pMSx4g4YgwKNBNC9rLmynLdPeolU7/
	 AE0HqfQ/gBRzfKDyWCrti0qRGl7XCo15xsb4vWrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackie Dong <xy-jackie@139.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1680/2151] ALSA: hda/realtek: ALC269 fixup for Lenovo Yoga Pro 7 15ASH111 audio
Date: Wed, 18 Nov 2026 15:56:55 +0100
Message-ID: <20261118150223.025571825@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jackie Dong <xy-jackie@139.com>

[ Upstream commit 83dca2530fb3ba63f47bad339d890bc30aa06ab5 ]

Volume control for the speakers on the Lenovo Yoga Pro 7 15ASH11 laptop
doesn't work.
The DAC routing is the same as on the ThinkPad X1 Gen7 function, so reuse
the alc285_fixup_thinkpad_x1_gen7 to get it working.

Signed-off-by: Jackie Dong <xy-jackie@139.com>
Link: https://patch.msgid.link/20260514153940.7320-1-xy-jackie@139.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 2fc28b1186d6 ("ALSA: hda/realtek: Fix hiss/crackle on Lenovo Xiaoxin 14 GT (17aa:3912)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 224eff304473e..303bff47ad610 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7663,6 +7663,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x38df, "Y990 YG DUAL", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38f9, "Thinkbook 16P Gen5", ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD),
 	SND_PCI_QUIRK(0x17aa, 0x38fa, "Thinkbook 16P Gen5", ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD),
+	SND_PCI_QUIRK(0x17aa, 0x38fc, "Lenovo Yoga Pro 7 15ASH11", ALC245_FIXUP_BASS_HP_DAC),
 	SND_PCI_QUIRK(0x17aa, 0x38fd, "ThinkBook plus Gen5 Hybrid", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
 	SND_PCI_QUIRK(0x17aa, 0x390d, "Lenovo Yoga Pro 7 14ASP10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
-- 
2.53.0



