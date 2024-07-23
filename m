Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C533B13D600;
	Tue, 23 Jul 2024 18:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760083; cv=none; b=eDtkqZKTAxUI518Yh+hvnT4PwaPDfK7K8nJg17DvXusfiEwVSTzyOwTiPOGHEyq8PqqwqE6wpS4xq8jsxEFzgYGXQTL4YJoI8a3nJgNopUB/kveeP2jJWl9GEY3o6IO/MHfmcUjr3P8MdYNYuunybunBp5pt2Qfjbhx2BfTy+QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760083; c=relaxed/simple;
	bh=pDDBJv/FQ7tMWQ8UOoF29Eq5EKlZBEs6JzUxYXDE82U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lM6OEWve+Bqfj5epxfEiX3/M+Rw+IJwzfTNklX2RmL0xqIObr44iLV0shBEDhJj8ZARnyaMknQy4aHZ5UifBR7y5uOlJnhNdNgOEbn7pEpOfhnwj9eOQHeTOBffl/ui03iZ1qEA+GIqxHsplJAz+Cz2Bv68TBRfXtEWckoyVPnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QsNI0dk+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QsNI0dk+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D06C4AF09;
	Tue, 23 Jul 2024 18:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760083;
	bh=pDDBJv/FQ7tMWQ8UOoF29Eq5EKlZBEs6JzUxYXDE82U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QsNI0dk+fu+TO2X7Ekcu/nfIVdj4BW5KfxKZenbdtV1uesg335KoluxrHo9yu24wp
	 76T/Fg83ZdJ9oJg+y1EC2aGuS4YVmxVlcCN0oKMMqT5McnUsJUtL/ubUj4zyEOOMDo
	 QBZi0bOsyrQsjixW1Tsx2kWthgf+Dd6SVMgbGBEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 070/163] ALSA: hda/realtek: Support Lenovo Thinkbook 16P Gen 5
Date: Tue, 23 Jul 2024 20:23:19 +0200
Message-ID: <20240723180146.173387512@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit 75f2ea939b5c694b36aad8ef823a2f9bcf7b3d7d ]

Add support for this laptop, which uses CS35L41 HDA amps.
The laptop does not contain valid _DSD for these amps, so requires
entries into the CS35L41 configuration table to function correctly.

[ fixed to lower hex numbers in quirk entries -- tiwai ]

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20240606130351.333495-4-sbinding@opensource.cirrus.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 98f580e273e48..db28547f3c637 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10542,6 +10542,8 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x38cd, "Y790 VECO DUAL", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38d2, "Lenovo Yoga 9 14IMH9", ALC287_FIXUP_YOGA9_14IMH9_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x38d7, "Lenovo Yoga 9 14IMH9", ALC287_FIXUP_YOGA9_14IMH9_BASS_SPK_PIN),
+	SND_PCI_QUIRK(0x17aa, 0x38f9, "Thinkbook 16P Gen5", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x17aa, 0x38fa, "Thinkbook 16P Gen5", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
 	SND_PCI_QUIRK(0x17aa, 0x3977, "IdeaPad S210", ALC283_FIXUP_INT_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x3978, "Lenovo B50-70", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
-- 
2.43.0



