Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A0714BFA2;
	Sun,  7 Sep 2025 20:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276335; cv=none; b=OiQhzcV5IaLq2nW1aSrU4Ega7IbHX5qUrk64BcH8bv5/l9VNVLlGVsM/KCSsBu8GFqGVIaIRG/Vc7VwEZ8bhoSWavKmdN1pxdc9OEfW74LCjwD9evwmRDkQIioDlTjs0E9r03IubWEGPR/x5Dv1J8ts37mPCHOhIIYnxgqDb/TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276335; c=relaxed/simple;
	bh=eog5QtOE6vn1gtDT82hob6TFgRF+4ApKV07V6tqiF14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ivkCOkVOY8qKFBc2VHiiYwIImQU9xezg6/6NzN2wk5316Bsdj3LfynDy1as0O/fJOcUOVx6JNTk3qopkcrOBPcPtgA9HWkbzeYBDVYURz6v7+x+5gvPnHkzBd5L2NxV99Kgn7WqZfwEWbBg4wXyiroAoNbw9xrKtLTDl6gPPg4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQ5FuJek; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQ5FuJek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7836BC4CEF0;
	Sun,  7 Sep 2025 20:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276334;
	bh=eog5QtOE6vn1gtDT82hob6TFgRF+4ApKV07V6tqiF14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQ5FuJekPFW0MRbS2VFe+lbPFBsWIXWv0snmWl8bFbboQfCCIVe6AD08Imknljppn
	 SbjYK5iNVEVsgotMzIAvuUTc/LjsNKJQfe8oiZx7zKpFcjb3nM6t2tnMrZiBE+WhlS
	 ExPB7oOxzu7YR2hto+Wt6ApqyFmFTapRYl1SLnCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 073/104] ALSA: hda/realtek: Add support for HP Agusta using CS35L41 HDA
Date: Sun,  7 Sep 2025 21:58:30 +0200
Message-ID: <20250907195609.573658117@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit 7150d57c370f9e61b7d0e82c58002f1c5a205ac4 ]

Add support for HP Agusta.

Laptops use 2 CS35L41 Amps with HDA, using Internal boost, with I2C

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250520124757.12597-1-sbinding@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10094,6 +10094,8 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8e19, "HP ZBook Firefly 14 G12A", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8e1a, "HP ZBook Firefly 14 G12A", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8e1d, "HP ZBook X Gli 16 G12", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8e3a, "HP Agusta", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8e3b, "HP Agusta", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
 	SND_PCI_QUIRK(0x1043, 0x1054, "ASUS G614FH/FM/FP", ALC287_FIXUP_CS35L41_I2C_2),


