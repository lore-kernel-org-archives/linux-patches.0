Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7901C16D9BF;
	Mon, 23 Jun 2025 22:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717175; cv=none; b=sHwfF+CkQI00EOCxEq9iLqxcKIYJz05cMr6lntLepNtJJcsJ61ZjamqyrI7cBWRh5OeQhw4k9erfKm66ypBEdHu6Nq38KzOVP2tyARm0v188/gjSIFPaMcH/iSWnJeINdyoF7LCDvfAGNdNu15RliMcTrEAWHwn4WVV+mVuZj5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717175; c=relaxed/simple;
	bh=bKIMpNqjRFlc4LP6n4DFFVIci83B82mBxmelRliX2Xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GJj5sBv/YmLnZdkHSMnTw8yLovA/pC1FnMPZNXxxvuq8YwACFGHmq7+P6tyMN9PdfS6KugNxGBj6nKZnx/UOVTU3Fs3rBxfZwSKG1t/CszdsDT9QpqKv+xMJ84gFwfKL0qBCkVj/wRXt4whjiOBzmu/Vf8Nhmc0Qq8rX9jDa2Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xQjJ7pFU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xQjJ7pFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118B7C4CEEA;
	Mon, 23 Jun 2025 22:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717175;
	bh=bKIMpNqjRFlc4LP6n4DFFVIci83B82mBxmelRliX2Xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xQjJ7pFUdIccrr0uE2ttQ9KPWDDcCg0fyzJSKtkoz0ftIhIYhZzA+utFTtTiaQjGS
	 BYb2Y1BaRGX63ooYGvmD1irvaeYLEB+QHBQ1rUw5NSnP/jgzcL2B5yhK5D3VggoBp0
	 /qNYzcb8BW2oiV5HnnF0sEUlQHUzvcr/8eszGbmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edip Hazuri <edip@medip.dev>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 333/414] ALSA: hda/realtek - Add mute LED support for HP Victus 16-s1xxx and HP Victus 15-fa1xxx
Date: Mon, 23 Jun 2025 15:07:50 +0200
Message-ID: <20250623130650.311514320@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

From: Edip Hazuri <edip@medip.dev>

commit a0914bf56e26d2cf457690602883f9cd2ec2c646 upstream.

The mute led on those laptops is using ALC245 but requires a quirk to work
This patch enables the existing quirk for the devices.

Tested on my Victus 16-s1011nt Laptop and my friend's Victus
15-fa1xxx. The LED behaviour works as intended.

Cc: <stable@vger.kernel.org>
Signed-off-by: Edip Hazuri <edip@medip.dev>
Link: https://patch.msgid.link/20250609075943.13934-2-edip@medip.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10727,6 +10727,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8b97, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8bb3, "HP Slim OMEN", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8bb4, "HP Slim OMEN", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8bc8, "HP Victus 15-fa1xxx", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8bcd, "HP Omen 16-xd0xxx", ALC245_FIXUP_HP_MUTE_LED_V1_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8bdd, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8bde, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
@@ -10780,6 +10781,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8c91, "HP EliteBook 660", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c96, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8c97, "HP ZBook", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8c9c, "HP Victus 16-s1xxx (MB 8C9C)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8ca1, "HP ZBook Power", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ca2, "HP ZBook Power", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ca4, "HP ZBook Fury", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),


