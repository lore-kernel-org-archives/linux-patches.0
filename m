Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29DEEEC8;
	Tue,  8 Oct 2024 12:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390539; cv=none; b=IYu/hy1Mq5wdujRuOJz7vEzZYyyUGwahpDK+hV2EAWJeFwuDntF/KJCcqcRlg7GoVK9rfrEQWWuyHbXno68ICNIvZsxudlVCT7nSO2kylbMUUUR2RdHS7/O2wWpO1GCF4sXJ9jSd5GYEz26ECJ2L3/XPXkHZLf1JAG3aM46z4Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390539; c=relaxed/simple;
	bh=vXH9GDz6+kZo62ig/I7nLYXWrYdzkAWzbwAJOO1paQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lel22hGvCvEZkZzqhPFniojecnb7tBk9hvbp76ZpcY91HTeRtOutIWyZt15TfwEnhpsnN2XfOiISK9yfv+CyTn9jLWjjcC5IoIq60AqyIz52EZEvOK+jiyYLUJ26Wt1LlYfUYaD5ReXkB18fFR8AcMJqLyTGsO6RCiMZF6Jn8cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IE3bwGzp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IE3bwGzp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1E8C4CECC;
	Tue,  8 Oct 2024 12:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390539;
	bh=vXH9GDz6+kZo62ig/I7nLYXWrYdzkAWzbwAJOO1paQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IE3bwGzpO54kizZPp5jLUPFluPegvl9VBQRJrhNTJgnYa+xx27h40N2cuWfACGu4K
	 7J6lcUeC9yYgX7w0Z1ioDITqEu30Rl1XmM/e8axfeCpS4n6dgPk1YgXWhNn/B2G5/H
	 xJxDQhcdMKZ8OQZfH3ehuTRgX38l1AbePxUTwW7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolai Afanasenkov <nikolai.afanasenkov@hp.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.10 319/482] ALSA: hda/realtek: fix mute/micmute LED for HP mt645 G8
Date: Tue,  8 Oct 2024 14:06:22 +0200
Message-ID: <20241008115700.984343916@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

From: Nikolai Afanasenkov <nikolai.afanasenkov@hp.com>

commit cb2deca056d579fe008c8d0a4ceb04d2b368fe42 upstream.

The HP Elite mt645 G8 Mobile Thin Client uses an ALC236 codec
and needs the ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF quirk
to enable the mute and micmute LED functionality.

This patch adds the system ID of the HP Elite mt645 G8
to the `alc269_fixup_tbl` in `patch_realtek.c`
to enable the required quirk.

Cc: stable@vger.kernel.org
Signed-off-by: Nikolai Afanasenkov <nikolai.afanasenkov@hp.com>
Link: https://patch.msgid.link/20240916195042.4050-1-nikolai.afanasenkov@hp.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10303,6 +10303,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8ca2, "HP ZBook Power", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ca4, "HP ZBook Fury", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ca7, "HP ZBook Fury", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8caf, "HP Elite mt645 G8 Mobile Thin Client", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8cbd, "HP Pavilion Aero Laptop 13-bg0xxx", ALC245_FIXUP_HP_X360_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x8cdd, "HP Spectre", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8cde, "HP Spectre", ALC287_FIXUP_CS35L41_I2C_2),


