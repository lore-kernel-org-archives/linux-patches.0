Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4B01917E3;
	Tue, 22 Jul 2025 14:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192822; cv=none; b=R9kmaKK975QymzUN0dIsbfqe91Kh871Es6cA5Ltm0+3P/+6YMVSImBGQ8Egh4SLICWTguigRvT5jAW00V3vS7L4b7WlvWst7TgHO2+W+WwdeKQUOTDQ6XYWLq8bguUkvt9XkGjozn+VtCC52ykEIJGqGGN42Zuw3Awi41yZn6b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192822; c=relaxed/simple;
	bh=lV92N7JJfrUQd24BxatfmPxy+1YpjXl5FFAHKRfIB70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+NO/gkuLArKf1XErRWzs7A+SVnGImYJINOWa6bERhkJmSw3+mhGKR9q2PJ9D4AnCgFTMJesNjOEkAMvVmzJ1/BW9IhjxdSOCoT6m9NzGD/fZDMWZT1uj5wLAPjlpflLNNyQrehTiEJmc/XQWECgBKu9Yd/18MoRkx+jw0sDh28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vGk7nR8B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vGk7nR8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB83C4CEEB;
	Tue, 22 Jul 2025 14:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192822;
	bh=lV92N7JJfrUQd24BxatfmPxy+1YpjXl5FFAHKRfIB70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vGk7nR8BulCUiSyg35WWXWbiRyeL8A2cOOzvxGdyNyWeXjAxgGWm3yBAMEQZEDe5Q
	 nOzK40GQ9L2HZcY+QXYYmEtLz5ulsWx6MCAymU8EKIHkTnRgX6KrbSSSPPZY4Xaocb
	 Uu0xtn46kRwrKjzNervhsXbLhnbFfklZwq5ER4uM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 034/158] ALSA: hda/realtek: Add quirk for ASUS ROG Strix G712LWS
Date: Tue, 22 Jul 2025 15:43:38 +0200
Message-ID: <20250722134342.022618716@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit e201c19ddeed6b37f05617e529d8efa079657ed7 upstream.

ASUS ROG Strix G712LWS (PCI SSID 1043:1a83) requires the quirk for
ALC294 headset mode in order to make the speaker and headset I/O
working properly.

Cc: <stable@vger.kernel.org>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220334
Link: https://patch.msgid.link/20250715062906.11857-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10913,6 +10913,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1043, 0x1a13, "Asus G73Jw", ALC269_FIXUP_ASUS_G73JW),
 	SND_PCI_QUIRK(0x1043, 0x1a63, "ASUS UX3405MA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1a83, "ASUS UM5302LA", ALC294_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x1043, 0x1a8e, "ASUS G712LWS", ALC294_FIXUP_LENOVO_MIC_LOCATION),
 	SND_PCI_QUIRK(0x1043, 0x1a8f, "ASUS UX582ZS", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1b11, "ASUS UX431DA", ALC294_FIXUP_ASUS_COEF_1B),
 	SND_PCI_QUIRK(0x1043, 0x1b13, "ASUS U41SV/GA403U", ALC285_FIXUP_ASUS_GA403U_HEADSET_MIC),


