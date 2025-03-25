Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00151265CA1;
	Tue, 25 Mar 2025 12:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905580; cv=none; b=GbxSuD0iD7qiYWtpU++2Ssq+a7WwUpILuuB9cX7WF0FjvtocqMeksNFddujPkZ66APIa1179lQSLOc+a5CusQrhw77NPKE5lxlTmNUUn97qtgx8oI5xpD7txf8LV4aPiZF42IRcFp093fKUsv91OViqBf/eddCs4utJQJjQAxCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905580; c=relaxed/simple;
	bh=XUeoSaC4ebgms/CYfMkI9g1r3iw+8/Kysa80R22eVfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jrPBZybRJyyE64Ftu02vC9x+VPfF/TaUJ600p96e7z8/Uc60VR+9McwTR0sMaNvJEuSQYmeKW5j/wDtgZxKzqm9Gh/BKTyKF1KIClnwnwdmKzn1LdzEvDJB5NfFUacNvZH4XAFPGodwoHTDanCnpSM1k9YoHCYagJ3HwdGrHUxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sg6LXBXU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sg6LXBXU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A78EBC4CEE4;
	Tue, 25 Mar 2025 12:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905579;
	bh=XUeoSaC4ebgms/CYfMkI9g1r3iw+8/Kysa80R22eVfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sg6LXBXU6hBj1eUwc5S0wnqcLQU9bJhpfnbYy8y2snN7mQWznoGgZPrm3Vz5d1pet
	 FBsx/zv33eTmEc3yLINqEJjrySGeF6Cj00XlXLDxBuB0hptYaDPeFZXqedoRj9IaLJ
	 ReEh306+Cm7PoKSQD8x37mQanGmL5wvWyXBGTLSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edson Juliano Drosdeck <edson.drosdeck@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/198] ALSA: hda/realtek: Limit mic boost on Positivo ARN50
Date: Tue, 25 Mar 2025 08:20:14 -0400
Message-ID: <20250325122158.001137295@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Edson Juliano Drosdeck <edson.drosdeck@gmail.com>

[ Upstream commit 76b0a22d4cf7dc9091129560fdc04e73eb9db4cb ]

The internal mic boost on the Positivo ARN50 is too high.
Fix this by applying the ALC269_FIXUP_LIMIT_INT_MIC_BOOST fixup to the machine
to limit the gain.

Signed-off-by: Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
Link: https://patch.msgid.link/20250201143930.25089-1-edson.drosdeck@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index e5e222e74d783..102af43f74423 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10333,6 +10333,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1d72, 0x1945, "Redmi G", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1947, "RedmiBook Air", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1f66, 0x0105, "Ayaneo Portable Game Player", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x2014, 0x800a, "Positivo ARN50", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x2782, 0x0214, "VAIO VJFE-CL", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x2782, 0x0228, "Infinix ZERO BOOK 13", ALC269VB_FIXUP_INFINIX_ZERO_BOOK_13),
 	SND_PCI_QUIRK(0x2782, 0x0232, "CHUWI CoreBook XPro", ALC269VB_FIXUP_CHUWI_COREBOOK_XPRO),
-- 
2.39.5



