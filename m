Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD171F8907;
	Tue,  3 Dec 2024 16:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242586; cv=none; b=MnQwZt7WuGk9vriB0d0utaiwBiS5zCBRYqxmnbcR8wxI5I7V+G7lQRhZ5pE4bXrhgOUgvH0DMJlrqQnPBvbySWC+dXwM3Yi863kOkgvznIRxO2MmIINUuceR8ujmwwlr6BQMRsL5HZrsxGvmoYGgWWtXvM91yY7nm/3gfb4OvhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242586; c=relaxed/simple;
	bh=LPdv59JMtj56EpbGdiZmMTT0Fqu4D6rNgzRsvavmcig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRqSi/Ptium7+cFLz2G0nTOGBjI12BHYhiA5BA/QDNi9mIEVXIFDkfGNLC8ZwAwiq4DjG33RsLJX3RgLFk/ecoazotjMT2wCriIpUNCPwidMd7tVXbEj0cxabbXRORHaptURpW7lrjatstZeKPqL9Uj7R7dPGJp5Y5Z7VJMSgWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Bn9mWTb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Bn9mWTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1FE2C4CECF;
	Tue,  3 Dec 2024 16:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242586;
	bh=LPdv59JMtj56EpbGdiZmMTT0Fqu4D6rNgzRsvavmcig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Bn9mWTb3DgNTd2JKK+589gXxp2qF9z/E1p8rVg6LutzuS5gPHm9Xih6dwvJXC1b8
	 i7I9ShSh+dH8jfpMvIQDrKN+YzMPIv6iYUJ6NisjHzCmCHoyPzoiuZbVwMgKDxpP+Y
	 h6zEHwqXPiP5j8fZbJvUygRZecGOzRVn9kX5mkEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dirk Su <dirk.su@canonical.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 747/826] ALSA: hda/realtek: fix mute/micmute LEDs dont work for EliteBook X G1i
Date: Tue,  3 Dec 2024 15:47:54 +0100
Message-ID: <20241203144812.904332878@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

From: Dirk Su <dirk.su@canonical.com>

commit 7ba81e4c3aa0ca25f06dc4456e7d36fa8e76385f upstream.

HP EliteBook X G1i needs ALC285_FIXUP_HP_GPIO_LED quirk to
make mic-mute/audio-mute working.

Signed-off-by: Dirk Su <dirk.su@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241126060531.22759-1-dirk.su@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10592,6 +10592,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8cdf, "HP SnowWhite", ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ce0, "HP SnowWhite", ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8cf5, "HP ZBook Studio 16", ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8d84, "HP EliteBook X G1i", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
 	SND_PCI_QUIRK(0x1043, 0x106d, "Asus K53BE", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),


