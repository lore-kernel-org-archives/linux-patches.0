Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE98A2F198B;
	Tue, 17 Jun 2025 16:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177825; cv=none; b=OVm3oGi/GtUekHGBgmYLsqe+a29SZagHPDPdBZ2qAAisuG9/4Iweewj4bZArYffz9EhwJYiQ0x9Y2w1tOJBWnn8AR6vD6UCyIEW3ruyFobE8BPVzVOYgR3IkuTUuqBTHpyrni94/7gGN9mU987dxhKyZgoMl+To4fOYYnJTbSlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177825; c=relaxed/simple;
	bh=kZhtddC7Ec93BKfBKv+mF9YzMpJBc+nmqcuFNcx1E3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GFCab3kAqjvpt/MUpZRTdBIdfnIewH9hETbp6kmpc2ZBVvXaXlY7ScCoKJ6KBtsnNP429Bny6lUMvvRKbm9TqTzINFiwEXGL8BbFF0LDlLqiufF5hUOG/wug06FADVvlsV7/GWN6iMZChBJw4rcYez732jN55kt3NTdLX3hsEPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tb3tn79h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tb3tn79h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E677C4CEF0;
	Tue, 17 Jun 2025 16:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177825;
	bh=kZhtddC7Ec93BKfBKv+mF9YzMpJBc+nmqcuFNcx1E3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tb3tn79hbYWs5g5hi8AYsnnCFqKiOyVatHWwWPv+rD6+fENcRh9vWRdcsrJSQVQrU
	 yMThzPgZKgQp3p3yrCaPR+JPw/eh3qAJ6ikRWHX698iRQKUrVx/aWsX5ITngmSf5np
	 /3L9z7izl/Y6EyfNMve0SyyQkFkm0zr0gxbhNLL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 402/512] ALSA: hda/realtek: Add support for various HP Laptops using CS35L41 HDA
Date: Tue, 17 Jun 2025 17:26:08 +0200
Message-ID: <20250617152435.873777784@linuxfoundation.org>
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

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit 29951021367f3a6f10e5b7a11c666fc914746f0c ]

Add support for HP Cadet, Clipper OmniBook, Turbine OmniBook, Trekker,
Enstrom Onmibook, Piston Omnibook

Laptops use 2 CS35L41 Amps with HDA, using Internal boost, with I2C

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Link: https://patch.msgid.link/20250321231717.1232792-1-sbinding@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: f709b78aecab ("ALSA: hda/realtek - Add new HP ZBook laptop with micmute led fixup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10779,11 +10779,23 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8d90, "HP EliteBook 16 G12", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8d91, "HP ZBook Firefly 14 G12", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8d92, "HP ZBook Firefly 16 G12", ALC285_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8d9b, "HP 17 Turbine OmniBook 7 UMA", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8d9c, "HP 17 Turbine OmniBook 7 DIS", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8d9d, "HP 17 Turbine OmniBook X UMA", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8d9e, "HP 17 Turbine OmniBook X DIS", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8d9f, "HP 14 Cadet (x360)", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8da0, "HP 16 Clipper OmniBook 7(X360)", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8da1, "HP 16 Clipper OmniBook X", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8da7, "HP 14 Enstrom OmniBook X", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8da8, "HP 16 Piston OmniBook X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8dec, "HP EliteBook 640 G12", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8dee, "HP EliteBook 660 G12", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8df0, "HP EliteBook 630 G12", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8dfc, "HP EliteBook 645 G12", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8dfe, "HP EliteBook 665 G12", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8e11, "HP Trekker", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8e12, "HP Trekker", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8e13, "HP Trekker", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8e14, "HP ZBook Firefly 14 G12", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8e15, "HP ZBook Firefly 14 G12", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8e16, "HP ZBook Firefly 14 G12", ALC285_FIXUP_HP_GPIO_LED),
@@ -10794,6 +10806,11 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8e1b, "HP EliteBook G12", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8e1c, "HP EliteBook G12", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8e2c, "HP EliteBook 16 G12", ALC285_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8e36, "HP 14 Enstrom OmniBook X", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8e37, "HP 16 Piston OmniBook X", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8e60, "HP Trekker ", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8e61, "HP Trekker ", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8e62, "HP Trekker ", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
 	SND_PCI_QUIRK(0x1043, 0x1054, "ASUS G614FH/FM/FP", ALC287_FIXUP_CS35L41_I2C_2),


