Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC2E26B96A;
	Tue,  8 Apr 2025 12:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115038; cv=none; b=hZfejul6uWHyJ+ntd5cBzXBBSkhHIvVBIrowIc9wlsViVv0y5O5mmuTq2ZJ24tNi+sMcbNaSximHFQH2akHvY1t7MK2EyUXqlZb+rSeU+iHTNs8Y6GQtSdkUYbpuY+khIuwdulyuB/zfNLQSoLnr9edY7KMw9p7js8oYK9KpZ1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115038; c=relaxed/simple;
	bh=sFMHuKynNrsXGJHv8eiqpCfGYBgYGQ/MLNnMhwJNa8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JtW4D6mjMwZ9CLWbnt1uRFHDHxROd6B8CfpFAA8PLneKofz5VT2cwlRLLm9b2tU1t4pZATaxC3uG3XR75mTYYenc9U2S1K4djwtxYuvahNy1FuhIczo5hpQHW7rXk5T1XHswvwMfy0474qatY5KI3cTlfzDoQ831rROdrRC7MGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FlMbX/3C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FlMbX/3C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03C2C4CEE5;
	Tue,  8 Apr 2025 12:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115038;
	bh=sFMHuKynNrsXGJHv8eiqpCfGYBgYGQ/MLNnMhwJNa8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FlMbX/3C6DIuh7hZ8+HucgzeHcFB3moEpWzeICi6ZKq2bUwB3hVSZZADJbtV+EtSq
	 YfCpd2WjXZc4CK84ch51JXy05IIuWEAszc2C+4zQbiU6cBzrpl67c6YZR+tAvHsZJw
	 F2mp6uPsN4mv9k5B3xPRlHrcTa5M6wsCERscfOOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 325/499] ALSA: hda/realtek: Add support for ASUS ROG Strix G614 Laptops using CS35L41 HDA
Date: Tue,  8 Apr 2025 12:48:57 +0200
Message-ID: <20250408104859.330882248@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit 9120b2b4ad0dad2f6bbb6bcacd0456f806fda62d ]

Add support for ASUS G614PH/PM/PP and G614FH/FM/FP.

Laptops use 2 CS35L41 Amps with HDA, using Internal boost, with I2C

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250305170714.755794-4-sbinding@opensource.cirrus.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index c4e01becdb625..1b216e8fa4046 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10651,7 +10651,9 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8e1a, "HP ZBook Firefly 14 G12A", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
+	SND_PCI_QUIRK(0x1043, 0x1054, "ASUS G614FH/FM/FP", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x106d, "Asus K53BE", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
+	SND_PCI_QUIRK(0x1043, 0x1074, "ASUS G614PH/PM/PP", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x10a1, "ASUS UX391UA", ALC294_FIXUP_ASUS_SPK),
 	SND_PCI_QUIRK(0x1043, 0x10a4, "ASUS TP3407SA", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x1043, 0x10c0, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
-- 
2.39.5



