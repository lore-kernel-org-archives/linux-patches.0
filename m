Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6611DEFC9;
	Tue,  8 Oct 2024 13:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392421; cv=none; b=M9k4urwdB3vlDZzU3OdhrXRH0Qv1k0uC0Go6zvF4dc14B+dKTydDvYrxpQW5NPKYXKwlwZ4+q7C2dcwfmEc2gAxdVzQBLKpCWeg9t6tz3j6yoAfI4Pz+T3BzulkvOOBpDtv7v1A5nWX13MiKmQWr6R8yg6+V41PJzS8YPwjDOrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392421; c=relaxed/simple;
	bh=9JWPpWbAtaPXIIu+cTle2eryI2eWMN+AW3Y/Ccsm5G0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J1CnB+Hv8DCTAPVWy5jjEd35W50ixBPdtyjlPoLRinJYijDdk1423UZMv2GlpBiK2PWS7efdSoHVwq+me2vgb9sDUGgvWtk3oBBZA3y9tz1D340SfOJkNeD+a97DRz08acGBcSiwCWtIY+qckKei5Lk1bogzHbFT9J7MTabEREk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dS/zYcCO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dS/zYcCO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA791C4CECC;
	Tue,  8 Oct 2024 13:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392421;
	bh=9JWPpWbAtaPXIIu+cTle2eryI2eWMN+AW3Y/Ccsm5G0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dS/zYcCOQrPoL1KBYWuDhuD0IqltwLtrvEbw2h+2tjNOPQpM9RB1la8XZEDAr3pIb
	 To4ne9c2vWuqWHUpl5hK/jVOyl6s9bVAajslXePmcrCkZHEcEv1osYWBr5iM+lhL1u
	 VKxx85bMG/U7WK7YX0f4KsdsXZFZpg48tSDVGqY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhishek Tamboli <abhishektamboli9@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.11 379/558] ALSA: hda/realtek: Add a quirk for HP Pavilion 15z-ec200
Date: Tue,  8 Oct 2024 14:06:49 +0200
Message-ID: <20241008115717.205662414@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhishek Tamboli <abhishektamboli9@gmail.com>

commit d75dba49744478c32f6ce1c16b5f391c2d5cef5f upstream.

Add the quirk for HP Pavilion Gaming laptop 15z-ec200 for
enabling the mute led. The fix apply the ALC285_FIXUP_HP_MUTE_LED
quirk for this model.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=219303
Signed-off-by: Abhishek Tamboli <abhishektamboli9@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240930145300.4604-1-abhishektamboli9@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10388,6 +10388,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8896, "HP EliteBook 855 G8 Notebook PC", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8898, "HP EliteBook 845 G8 Notebook PC", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x103c, 0x88d0, "HP Pavilion 15-eh1xxx (mainboard 88D0)", ALC287_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x88dd, "HP Pavilion 15z-ec200", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8902, "HP OMEN 16", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x890e, "HP 255 G8 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8919, "HP Pavilion Aero Laptop 13-be0xxx", ALC287_FIXUP_HP_GPIO_LED),


