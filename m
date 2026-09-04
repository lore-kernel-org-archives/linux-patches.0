Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3434137B2;
	Fri,  4 Sep 2026 05:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500090; cv=none; b=DH/68kYBryMui6+Ij4Ki/BF8GWL9NwwWFB9/D2qSdTIOmQ/Hk98T4vmOYNc1uYRuKIUJoM3tO0JdD6ccw+JZiyC8zKcDN7mvQHhISPOETAcXU3tvAXBaOZ2GaSsQ/WEfnvVkpH4l9fY1sFQoAez6fIQ7EscIz/E4lPfI2DSy/ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500090; c=relaxed/simple;
	bh=e5vK2+HLf2q0qFNASRw7ob/NGEhc77yVEVcq5P/esfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IWp3Z4AfFsq6x21M9BXvIV6GLYQ6Lriu4nPXp8fk3AInACpvq0yp5O0Ve2Cg+4+kRnQQOlhSHGXrbfD787XW6hScuEQguAOYO3Qfj3Mi87PynX9Uxgovh+O7Wywnt/zkuw0gHEpYOu6VlqGzqvUNBwJJQyjvQbgg8SS19rKpcZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f5b+NSM0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f5b+NSM0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD3B1F00A3D;
	Fri,  4 Sep 2026 05:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500089;
	bh=PQD6/jLAXuMBL/yLFL7CRxYLqJiR7GL4DLqmnIpirjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f5b+NSM0QESx1p3ajf1fzolTBAXzalopjNFl8ChD459cjo4FRPm0B0Ev/MGhNnJ80
	 OZlnXR+lFgnWuihivH+ly72XXooq3QH0Cg2Jv8lSAHkQYklnicQDKlr6uHvY0uJELm
	 SfMyZ7zMaGiS4TOI6hiPGDEr7o9nki2dtD8YVFCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Batishchev <ii343hbka@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.2 648/713] ALSA: hda/realtek: Enable micmute LED on HP EliteBook 6 G1a p/n: AD3Q9ET#UUG
Date: Fri,  4 Sep 2026 07:00:16 +0200
Message-ID: <20260904045818.359493377@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Batishchev <ii343hbka@gmail.com>

commit e7da28b820d12927de30abf554c727a319f80359 upstream.

The HP EliteBook 6 G1a (SSID 103c:8e0d) uses a Realtek ALC236 codec.
Without a quirk no fixup is selected and the mic-mute LED stays off.
It needs the same ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF quirk as the
already-supported 14" variant (SSID 103c:8dfb), so add it.

Signed-off-by: Denis Batishchev <ii343hbka@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260810151440.2306217-2-ii343hbka@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7442,6 +7442,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8dfc, "HP EliteBook 645 G12", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8dfd, "HP EliteBook 6 G1a 16", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8dfe, "HP EliteBook 665 G12", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8e0d, "HP EliteBook 6 G1a 14 (AD3Q9ET#UUG)", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8e11, "HP Trekker", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8e12, "HP Trekker", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8e13, "HP Trekker", ALC287_FIXUP_CS35L41_I2C_2),


