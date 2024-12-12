Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2C32163AE;
	Thu, 12 Dec 2024 15:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016127; cv=none; b=dJeermP1+MQcZeGNsaonYFiKWOUy7J10d2QkmjXWROGS6t9D/40QGlJSlS+vNPFHiwCl/SqMg0FRa84HJuWio07KeLSJUrjaxs9Q4+mtzxyGItT7AqpKazapZpjiz2TS8TTtyhlV2kGk5l0Z4D+bJcL3vkyS9qTzkHJweIvj6Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016127; c=relaxed/simple;
	bh=36mHpZBBx/wMcySCv3vi0o3fzA7kouqU5APaxlK+8M8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dcNDDVgjnDZ1TkR3IE4TO0rqt+6WbhXKtrAWW6ze4GYWPGGMLyVJ0/IjlL5+uq9TNUWkdnfIdLvWeZOundjPvbxDunpTOCAHj3596Mvw2hmjPftT8+vN+Afd6WMGIkIJDnl2kmVz8Ovm3zeV0aNsh+lCBiIWc4ZIWflfxs5S4WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FW8y0L7+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FW8y0L7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E700C4CECE;
	Thu, 12 Dec 2024 15:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016127;
	bh=36mHpZBBx/wMcySCv3vi0o3fzA7kouqU5APaxlK+8M8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FW8y0L7+fJSbH6IQgOKDw1n5WDV0/oARjGivwVPJ3waoRT2qa+jN/G2MQT66FyMsf
	 yGH15Lr+ZDhsdWgumMlYspd+0laNcZKX5wKZ2ec4aSKk5WJY00DowTTxgOCl6iKOin
	 dEoay8cjAIT2/OzzZHjYDhD1ZNA92r0KBjmE5bdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Chiu <chris.chiu@canonical.com>,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 141/466] ALSA: hda/realtek: fix micmute LEDs dont work on HP Laptops
Date: Thu, 12 Dec 2024 15:55:10 +0100
Message-ID: <20241212144312.368157526@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Chiu <chris.chiu@canonical.com>

commit 0d08f0eec961acdb0424a3e2cfb37cfb89154833 upstream.

These HP laptops use Realtek HDA codec ALC3315 combined CS35L56
Amplifiers. They need the quirk ALC285_FIXUP_HP_GPIO_LED to get
the micmute LED working.

Signed-off-by: Chris Chiu <chris.chiu@canonical.com>
Reviewed-by: Simon Trimmer <simont@opensource.cirrus.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241202144659.1553504-1-chris.chiu@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10592,7 +10592,13 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8cdf, "HP SnowWhite", ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ce0, "HP SnowWhite", ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8cf5, "HP ZBook Studio 16", ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8d01, "HP ZBook Power 14 G12", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8d84, "HP EliteBook X G1i", ALC285_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8d91, "HP ZBook Firefly 14 G12", ALC285_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8d92, "HP ZBook Firefly 16 G12", ALC285_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8e18, "HP ZBook Firefly 14 G12A", ALC285_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8e19, "HP ZBook Firelfy 14 G12A", ALC285_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8e1a, "HP ZBook Firefly 14 G12A", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
 	SND_PCI_QUIRK(0x1043, 0x106d, "Asus K53BE", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),


