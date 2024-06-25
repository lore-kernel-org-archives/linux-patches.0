Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588F01465A8;
	Tue, 25 Jun 2024 09:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309311; cv=none; b=icy/Edf0bFZmwv2DATSb3u1Tnd2w2bzCnqL1wxmEPTkuyw+jHK1qqHXLhxu7dpWSfD1TJxfsZcG+1C9ny6slynktXs4TAHRhzJsXvhT5e+4CGVeZAhWj4ZR+4aOnQiI3EiIwB9bjx6M5htN56KeZp8WpoFbZVID5rwmrVPLPeTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309311; c=relaxed/simple;
	bh=dg8tPLlAOpmp3cXTvClp0byHkNHKmO9BcBsKPmPQ1yQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ca29oSVslWcL7/mfMvJSdOAVAH0/Nawk31ReAbTHLWYYqHtnPgZtwI4TQutefQLtl1fHNv0l00VjSSbEc/UiGjI8yBVv4viCZqkmoz+qjbGd6LUlVB3wURc/X2hXBNUu77adbkFYyjxIo/8YuOHz9uH9WGZlhfx/+T7C3lAclc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=enpbCVqj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="enpbCVqj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4588C32781;
	Tue, 25 Jun 2024 09:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309311;
	bh=dg8tPLlAOpmp3cXTvClp0byHkNHKmO9BcBsKPmPQ1yQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=enpbCVqjnyk+Ac/Hqqwq9Ro8ZRgbdA8/Qq0MXGh7KNCEVasp0g7+JNuYTBr3ylT0f
	 9tkczOGozUdA8C96YiSu7g4cWXYxi31EFzMfvcMKnBgavDbtfbTb9ZjEWxpMvbeRec
	 cL3GPhQgSI93pXOAqIodsYS7taQLEmGvs/JPqWd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Chi <andy.chi@canonical.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 149/192] ALSA: hda/realtek: fix mute/micmute LEDs dont work for ProBook 445/465 G11.
Date: Tue, 25 Jun 2024 11:33:41 +0200
Message-ID: <20240625085542.878958110@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

From: Andy Chi <andy.chi@canonical.com>

commit ea5f8c4cffcd8a6b62b3a3bd5008275218c9d02a upstream.

HP ProBook 445/465 G11 needs ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF quirk to
make mic-mute/audio-mute working.

Signed-off-by: Andy Chi <andy.chi@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240605092243.41963-1-andy.chi@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9959,6 +9959,10 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8c70, "HP EliteBook 835 G11", ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c71, "HP EliteBook 845 G11", ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c72, "HP EliteBook 865 G11", ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8c7b, "HP ProBook 445 G11", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8c7c, "HP ProBook 445 G11", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8c7d, "HP ProBook 465 G11", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8c7e, "HP ProBook 465 G11", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8c89, "HP ProBook 460 G11", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c8a, "HP EliteBook 630", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c8c, "HP EliteBook 660", ALC236_FIXUP_HP_GPIO_LED),


