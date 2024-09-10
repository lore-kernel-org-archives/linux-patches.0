Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1C118B498;
	Tue, 10 Sep 2024 09:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961291; cv=none; b=JJCYCCwxxWPviabyrsaVX5KohndfJAHhWbrWrM5BNC89U+J5n+vzxzMNlmhFwDCunaTiHnnxLSGk8jJIvsbUIdx6vrd1HWe0LovuFMkU+OVdL61mV4eSA7e0sRA1174iXJzCz1xuehlc4CXXioui660dxV6TcbJvwJsUAMb9V8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961291; c=relaxed/simple;
	bh=ZsQrJoiZOshdDmUUejzvy+/2zy1Dl8RF/Su/QJ5Vohs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BW0NUAapHFWHeGnN7EcKVy+Xxwm3UIM+lOX4fiTelc1NMCkz6E90lRc6zdp1RDBRHoDWmrXzEyOBxuvE9VxQv6mkmn/y0F5CewRS3Kyo4aLVP0QXwCiQdzm+Yc6Xy1ZgXQuycF4BDIuj76L4crr0dzOvkt95jcbDRlFZc7XX0NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jdM/VmI/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jdM/VmI/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DCAC4CEC6;
	Tue, 10 Sep 2024 09:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961291;
	bh=ZsQrJoiZOshdDmUUejzvy+/2zy1Dl8RF/Su/QJ5Vohs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jdM/VmI/3DFRPprFpVrzsy60mos9U239lMQ9wxq4Iy3L0mfwv8SgI7kSn8uLapkoN
	 rhKQWs3F1ShE0b66YIfyiDAux/jNr0B6urVJQVZwgKbRZlFVnOmd/xKeU/D9kQbDbD
	 4h6osnpcIJyGH2FBVG0hzGZcAG/BkmqPhcYvqpUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Queler <queler+k@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.10 013/375] ALSA: hda/realtek: Enable Mute Led for HP Victus 15-fb1xxx
Date: Tue, 10 Sep 2024 11:26:50 +0200
Message-ID: <20240910092622.708751980@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Queler <queler+k@gmail.com>

commit b474f60f6a0c90f560190ac2cc6f20805f35d2c1 upstream.

The mute led is controlled by ALC245. This patch enables the already
existing quirk for this device.

Signed-off-by: Adam Queler <queler+k@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240903202419.31433-1-queler+k@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10229,6 +10229,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8c16, "HP Spectre 16", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8c17, "HP Spectre 16", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8c21, "HP Pavilion Plus Laptop 14-ey0XXX", ALC245_FIXUP_HP_X360_MUTE_LEDS),
+	SND_PCI_QUIRK(0x103c, 0x8c30, "HP Victus 15-fb1xxx", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8c46, "HP EliteBook 830 G11", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c47, "HP EliteBook 840 G11", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c48, "HP EliteBook 860 G11", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),


