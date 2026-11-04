Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831084;
	b=MPLH8kqOUE1hqVatjSKfvaQdxSV/ClUITuKOouSl8kS+nQCokAly3A3Wsjq6/rNQnZmD
	 ldoAAQJTsqjinbYdhsCmG2PY73jEOaD0Hi8/UZ6twNe4nPqreEIPxFPn1BIQTco9VY1Uq
	 bPeg7AT+CdTfIqeOZBtMRudPUA3qTEhw6ICxo5nASu7sLFYMdi8xYgi4tbe1VMI1RlV0m
	 PMTwohUMm8zrS7M02QYWMW/NGOfpUIHDmceJcPP5oKq/O4Eb68+2L/DDf/8PYGvL9KuN2
	 HxXu9DNdDUvHg/0v9EG3QhjVfM3yrCBxstHSWkDGy+m+dsRsb0VNTplq1XaCSuxd7uQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831084;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fs/k/1745fUP0ITiSnVhbQfcuuvbcdbWsJiHomAjUAQ=;
	b=PYyBXkvuzmWpTdK3SYVMk5+q5uoA8Z7oLH/abol9cbNPc+6Z/m7w6rLXmIKFP0yccPfL
	 UVE7988gostF6qMoh5vGtS4lEKaTYp/7oPWKdvFoVeuhnwH57vTea0EhrgzT+1nw6G06A
	 LTdLdEQRVMI3LoU6fjpNSTAgsEUTYvYRAvkvNJovZI1RIwWdczSEPQXUntXkiuqB6vnGJ
	 FtRgnrpVc/PJAAbm2JN3MV4yj8ZX+aGOCHvFnrMGkniMMHc23LNMZoP4YHkH5LTcFQtXe
	 4/PaYmgy0ldWeGo1IkMPwXTkrW1Y51KU2iSUq07/MgYjrpkwt9N3Jy++Ca7NEK9J6Zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZgCKui1D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4E4606AC29;
	Wed,  4 Nov 2026 22:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZgCKui1D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98881F00A16;
	Wed,  4 Nov 2026 22:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831084;
	bh=fs/k/1745fUP0ITiSnVhbQfcuuvbcdbWsJiHomAjUAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZgCKui1DGEQU4UHppXP2fZlVQC8wmjOUxsGufabANuooTIq+EiKQA2FZEaojdxjTp
	 LW2TuYdQg1XDrzfxoeqczRsir4j33gQJl0LPF4OFt+qd+nOLy5XdnvkilrTR7tHL07
	 KsnHucQVyZSocK62CHHhKyWLlywrcTYgH/0nELOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0495/1005] ALSA: hda/realtek: Add quirk for Lenovo ThinkBook G8+
Date: Wed,  4 Nov 2026 16:03:48 -0500
Message-ID: <20261104211057.826717542@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit 4322ac247f4ce7932edbd46aa37f3dae62cde424 ]

Fix Bass Speaker volume control on Lenovo ThinkBook G8+ by adding
quirk 17aa:38dc with ALC285_FIXUP_SPEAKER2_TO_DAC1.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221799
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260921124450.639601-1-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index b1cb93922c3bc..6afb35769f746 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7572,6 +7572,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x38d5, "Yoga S990-16 Pro IMH YC Quad", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38d6, "Yoga S990-16 Pro IMH VECO Quad", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38d7, "Lenovo Yoga 9 14IMH9", ALC287_FIXUP_YOGA9_14IMH9_BASS_SPK_PIN),
+	SND_PCI_QUIRK(0x17aa, 0x38dc, "Lenovo ThinkBook G8", ALC285_FIXUP_SPEAKER2_TO_DAC1),
 	SND_PCI_QUIRK(0x17aa, 0x38df, "Yoga Y990 Intel YC Dual", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38e0, "Yoga Y990 Intel VECO Dual", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38f8, "Yoga Book 9i", ALC287_FIXUP_TAS2781_I2C),
-- 
2.53.0



