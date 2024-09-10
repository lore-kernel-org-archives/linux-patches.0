Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30F814B06C;
	Tue, 10 Sep 2024 10:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964000; cv=none; b=I2ZfA35qadU68cfQbiOWtZTtdgBwYEYnSqNg25N27adi8Fv2/tRavfhyzXD/LoVDJIqE5eJhNhdYceYcjzITihTtMaiT0bSGT5fnLWnF7iiN+5LM4HsjfezzyDrHwjaS+yXUbjNslhP59uBOdkvaAQ2y7mTCeUoU1WmFwaOJfjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964000; c=relaxed/simple;
	bh=t3/Xj+ET0mZZjlzm76vGxaMqbA2aN1L2mRKCEWYg6dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SxMPwWRN336F2vsmjxAXzw0XxYMEwW6l7AU/b0LZZFxoal5I974RJhoYVfx3id+D6FvbwUaqSdgCNtrmfb3h/P2FyX2eVLHb9EwpIzv/9B6XopgPW+4lJyEiyocnGwVjv+4UoXG57jiIJYT3i4uh93+mmV2sssFSHdqOFMw+Bho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SG7CklFg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SG7CklFg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69FAEC4CEC3;
	Tue, 10 Sep 2024 10:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963999;
	bh=t3/Xj+ET0mZZjlzm76vGxaMqbA2aN1L2mRKCEWYg6dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SG7CklFgWgETT4sp9nTkiPwvK97L8m8rvvc4w53m8QQr/ckHbcAao5wcMtZI24JBf
	 T6gVX8+AsCxLn2Kxzs+9PGLAYFEBBPYoDHaoe3Pll6YWZT/4DkrRHCTzF6wt+4BCN6
	 2qrmKm1YiVygJKqZpM4B/Okw+J2IgJ5Ty9EBJge0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilien Perreault <maximilienperreault@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 009/269] ALSA: hda/realtek: Support mute LED on HP Laptop 14-dq2xxx
Date: Tue, 10 Sep 2024 11:29:56 +0200
Message-ID: <20240910092608.575996241@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maximilien Perreault <maximilienperreault@gmail.com>

commit 47a9e8dbb8d4713a9aac7cc6ce3c82dcc94217d8 upstream.

The mute LED on this HP laptop uses ALC236 and requires a quirk to function. This patch enables the existing quirk for the device.

Signed-off-by: Maximilien Perreault <maximilienperreault@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240904031013.21220-1-maximilienperreault@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9873,6 +9873,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x87f5, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87f6, "HP Spectre x360 14", ALC245_FIXUP_HP_X360_AMP),
 	SND_PCI_QUIRK(0x103c, 0x87f7, "HP Spectre x360 14", ALC245_FIXUP_HP_X360_AMP),
+	SND_PCI_QUIRK(0x103c, 0x87fd, "HP Laptop 14-dq2xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87fe, "HP Laptop 15s-fq2xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8805, "HP ProBook 650 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x880d, "HP EliteBook 830 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),


