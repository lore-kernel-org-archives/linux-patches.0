Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18501C3027;
	Mon, 14 Oct 2024 15:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919195; cv=none; b=UpWSYMBUL/66H5LDPM2gfrp6rrVEAUqzUFNDEwaZY99AlZ1JLSrmQjLRefGSywacM497kyga+zcP9hOj8Rk+C1k7B1fCa5k0kHCdhWFMrnqVRJdXqciyKnKMUVYsr60Tr3ywZUoZg4Z4HXuRFj8N5ZWbvZlljtWlInnELxgx6rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919195; c=relaxed/simple;
	bh=YV+m1uzXUGW4oXl8+Xmu/sgfQlynzzYvUf0XE7xMBx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QjK/Ld2PKkK425W8gp6DARb+Z2gH+uGxoRley4FyE0tlZWbYxyQvPl8Ilsdk465F6PgcvWOQ0se/6e35skgOi6B6UlAqciTBmtsOSbzU+kR8Ck9SOkV+C5+UCj3YzqqgANk1PwQLLZW7VMoc7RpGdbsTXRMf9ketSjHYjQq9RPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RTznoF1o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RTznoF1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402F5C4CEC3;
	Mon, 14 Oct 2024 15:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919195;
	bh=YV+m1uzXUGW4oXl8+Xmu/sgfQlynzzYvUf0XE7xMBx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RTznoF1o4jHGJnC5xue6ibBkDBZ2/s1RWwL80aoBFo0GS3uMOjHbSu3IVIJL6nILB
	 +aIHw3wpLN3MtJ+qITPwjTj1yD+B/HwLxJ/WfrqWT75fpdPww+p9YriRxWZxYtdm/d
	 bsjesz8N/vdJrW5dzMRBfITVEfKdpOp+ndR9iDls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhishek Tamboli <abhishektamboli9@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 540/798] ALSA: hda/realtek: Add a quirk for HP Pavilion 15z-ec200
Date: Mon, 14 Oct 2024 16:18:14 +0200
Message-ID: <20241014141239.214349472@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -9767,6 +9767,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8896, "HP EliteBook 855 G8 Notebook PC", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8898, "HP EliteBook 845 G8 Notebook PC", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x103c, 0x88d0, "HP Pavilion 15-eh1xxx (mainboard 88D0)", ALC287_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x88dd, "HP Pavilion 15z-ec200", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8902, "HP OMEN 16", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x890e, "HP 255 G8 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8919, "HP Pavilion Aero Laptop 13-be0xxx", ALC287_FIXUP_HP_GPIO_LED),


