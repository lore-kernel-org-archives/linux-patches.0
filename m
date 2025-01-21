Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4A91F668A;
	Tue, 21 Jan 2025 18:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482434; cv=none; b=b+V1xh1DVLYxGhLLHeqRJMXhg0oAMSYlE7zpnET4WpERbUCXsm+sD7y+n/1GfLaOWgC4TO1sgEneUM5K4byHNqrvJ/V/SYPJqkZcJ82Ikfs8AaOL3gZvEGqDY+zp4xMhfnUGs/dR7HY1EVSPpKPRkF+ALzF2xLpZnKwEgQq7GwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482434; c=relaxed/simple;
	bh=lc4dfNYlW1Ny4wtk2Nce7cLiz7e94TszWyVSwBm9Xqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C86u8WUKa/BemKUC9HSbEeHbtZJCXKHc49mafTVq/ItOGtd4M30GVit4ac9wRG356fwXCzzZ+LQPp8l+Ihi8/D3iLHWMoKZ5ve7FQ54vJF8d8DEwqRIBpXrvMLnXbAb+bGmGqw5ehbKo7/FcYde71qc3ajMddM5BFAtXpeSYf4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u7pikory; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u7pikory"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E08C4CEDF;
	Tue, 21 Jan 2025 18:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482434;
	bh=lc4dfNYlW1Ny4wtk2Nce7cLiz7e94TszWyVSwBm9Xqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u7pikoryzM1bYxG0ljvEW84uZQ9e8LlqVk4h1saj8ASLeSi/nH9l7P5yVjxNNEo40
	 1bnXs5tlztfjEyWZR66xE8mN4wI/MKXMxEpV2DCB5S1EJHDKL4nv9OBvLWYKK0aDAd
	 I+EmO54Vf2puAln2sIVC50rzPwfPFxvTtQ21wecU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luke D. Jones" <luke@ljones.dev>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 076/122] ALSA: hda/realtek: fixup ASUS GA605W
Date: Tue, 21 Jan 2025 18:52:04 +0100
Message-ID: <20250121174535.937283607@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

From: Luke D. Jones <luke@ljones.dev>

commit f67b1ef261f4370c48e3a7d19907de136be2d5bd upstream.

The GA605W laptop has almost the exact same codec setup as the GA403
and so the same quirks apply to it.

Signed-off-by: Luke D. Jones <luke@ljones.dev>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250111022754.177551-1-luke@ljones.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10625,6 +10625,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1043, 0x1e1f, "ASUS Vivobook 15 X1504VAP", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1e51, "ASUS Zephyrus M15", ALC294_FIXUP_ASUS_GU502_PINS),
 	SND_PCI_QUIRK(0x1043, 0x1e5e, "ASUS ROG Strix G513", ALC294_FIXUP_ASUS_G513_PINS),
+	SND_PCI_QUIRK(0x1043, 0x1e83, "ASUS GA605W", ALC285_FIXUP_ASUS_GU605_SPI_SPEAKER2_TO_DAC1),
 	SND_PCI_QUIRK(0x1043, 0x1e8e, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1eb3, "ASUS Ally RCLA72", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x1043, 0x1ed3, "ASUS HN7306W", ALC287_FIXUP_CS35L41_I2C_2),


