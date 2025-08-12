Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AB021ABD0;
	Tue, 12 Aug 2025 18:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023167; cv=none; b=oIca+lOOeQpVION52UyybNtOqY/C2nxVH11Zb1xFP7ZeWWxB3Ihn04PC2Vq4llBwF9T6iHb/LqVyRkN2wkypulax5YWg3NjSvOSMQ0Dao4J5x8fIV+tm4Cyh26XYH7rP8gEzo17VlOqqAHrb8y1Obp8LccR6Mh4flG0eWEovV5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023167; c=relaxed/simple;
	bh=e1yqi0xYdgf8Du7DRM+4O9/wXsjGeBWkoMHdmNRy+Vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rg15w86DzxjK/MDFhwtsNaFkZBifYPtuhVSgnQc1+ZIwJbV0ZMjgNvzm5KdKwbPQDfTDKuvirs3jDbkU6wPjIUpzJyt82s8sSSgag3PH3DkQEaUj7qYHmiOQM0DQWXU/rojrpem+jDNqRjQg2mNF7oTdr5vXcBj6z1VoA07D0HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cRovOT22; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cRovOT22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C302C4CEF0;
	Tue, 12 Aug 2025 18:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023167;
	bh=e1yqi0xYdgf8Du7DRM+4O9/wXsjGeBWkoMHdmNRy+Vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cRovOT22IXK/O+OOeNAA70ruumGb5Cw4e/I+8lH+prqbJy5ggtNjoz/ZT/jqPjJYf
	 BNeHP8FGNd8aaILxaS8s0g02zme4kYstt2wWPFa1acB5gmsvleKwD0bYRO0UzD4Z02
	 TsZidGyRSDHiGv6kHwhqtKdK96KEBx2OQyg4y6js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edip Hazuri <edip@medip.dev>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 355/369] ALSA: hda/realtek - Fix mute LED for HP Victus 16-r1xxx
Date: Tue, 12 Aug 2025 19:30:52 +0200
Message-ID: <20250812173030.048681562@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

commit bd7814a4c0fd883894bdf9fe5eda24c9df826e4c upstream.

The mute led on this laptop is using ALC245 but requires a quirk to work
This patch enables the existing quirk for the device.

Tested on Victus 16-r1xxx Laptop. The LED behaviour works
as intended.

Cc: <stable@vger.kernel.org>
Signed-off-by: Edip Hazuri <edip@medip.dev>
Link: https://patch.msgid.link/20250725151436.51543-2-edip@medip.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10788,6 +10788,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8c91, "HP EliteBook 660", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c96, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8c97, "HP ZBook", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8c99, "HP Victus 16-r1xxx (MB 8C99)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8c9c, "HP Victus 16-s1xxx (MB 8C9C)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8ca1, "HP ZBook Power", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ca2, "HP ZBook Power", ALC236_FIXUP_HP_GPIO_LED),


