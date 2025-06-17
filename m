Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FB62F198E;
	Tue, 17 Jun 2025 16:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177819; cv=none; b=MG5PGa/w9Kr6dJgbxTB1YrJ7AaDKNwmTNRU3FfbhEhPo2F1bAWpBRHEEOSW3aPp9otU7N9Tg7Sjyr95uc1kfPeHirM3OF1v3w8mGV5s3Mqcf3L7IKgUNco8vq6FXNOG/lTsoRUs9j8jAxA/p1LWo9RI9C5vahsDzk02RGsrtjOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177819; c=relaxed/simple;
	bh=1tdV5u4ezSsLj3uj6lsuBuu+np3b8PZquSUXsWczfcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rSeotpjb/TzYDOdYhZaJzlw+cuTginXZ8wm59L3epLDMqC4Tyqz37tzyIDKo6ppAWBM3NYKsRFfyotuAQDrZANG9sPa33za3P1UseDrG/mZiO8ilkkqiZaWSDQfDFTdKloagoEnV/sXvM1kzeYKEthed1Gn1yuor1RFlBJkdn04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P/SNM2g5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P/SNM2g5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3DBC4CEE3;
	Tue, 17 Jun 2025 16:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177819;
	bh=1tdV5u4ezSsLj3uj6lsuBuu+np3b8PZquSUXsWczfcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P/SNM2g52m31zewWFxbAT02gxzmQvbifHS+bKYwDLmyZMGclaUYdnoizZUa2vWtdR
	 X3xHQs4zOzrhL2qc7zannpz7vr2whiZCPrmAAf/oReby+0Tvo3MQNIbGiss9AnvcQB
	 RvcnTH/HlT6ohdm5zc7clgj/Th+p84YEvqneojYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Chiu <chris.chiu@canonical.com>,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 401/512] ALSA: hda/realtek: fix micmute LEDs on HP Laptops with ALC3247
Date: Tue, 17 Jun 2025 17:26:07 +0200
Message-ID: <20250617152435.835242305@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Chiu <chris.chiu@canonical.com>

[ Upstream commit 78f4ca3c6f6fd305b9af8c51470643617df85e11 ]

More HP EliteBook with Realtek HDA codec ALC3247 with combined CS35L56
Amplifiers need quirk ALC236_FIXUP_HP_GPIO_LED to fix the micmute LED.

Signed-off-by: Chris Chiu <chris.chiu@canonical.com>
Reviewed-by: Simon Trimmer <simont@opensource.cirrus.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250321104914.544233-2-chris.chiu@canonical.com
Stable-dep-of: f709b78aecab ("ALSA: hda/realtek - Add new HP ZBook laptop with micmute led fixup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10779,6 +10779,11 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8d90, "HP EliteBook 16 G12", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8d91, "HP ZBook Firefly 14 G12", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8d92, "HP ZBook Firefly 16 G12", ALC285_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8dec, "HP EliteBook 640 G12", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8dee, "HP EliteBook 660 G12", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8df0, "HP EliteBook 630 G12", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8dfc, "HP EliteBook 645 G12", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8dfe, "HP EliteBook 665 G12", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8e14, "HP ZBook Firefly 14 G12", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8e15, "HP ZBook Firefly 14 G12", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8e16, "HP ZBook Firefly 14 G12", ALC285_FIXUP_HP_GPIO_LED),


