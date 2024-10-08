Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477A31C2443;
	Tue,  8 Oct 2024 12:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390554; cv=none; b=OkhtCu5x8gcHPSGie1oSqN9p2oEuAHk8wBsFwMx6JdfeRENvWFFw0GOM/mtATOrD8nybzqHhHpHly0IQo2gysOgXIYI5zoBBaFCCzpruLrPmlyruaHOGhS4jh961kmPrB5PF23MKebFpLwlHeQpYqf7jY17jk+Kd2Q9oG2SsAnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390554; c=relaxed/simple;
	bh=stVwMCxGnZuHwB1GibRBQV9WTVGB3zeo/aeYp6W/TpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EVbSvquubDPygL8KMHo1uLpN4/IFNxSG8cJpEfmgAv+1d7LGBwLwuMu2oaZKSr4Q93XYoTrQ6RZjbBw89PaNwDMMm+lWNSmm3u6b9yXBfMUsrCleOIjPoaQkgJMy3DcM3r8S1xXbc8terSMXLMTsAdYNod6DlHHIUvBBa5k5YzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AXE/MwI5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AXE/MwI5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA96C4CECC;
	Tue,  8 Oct 2024 12:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390554;
	bh=stVwMCxGnZuHwB1GibRBQV9WTVGB3zeo/aeYp6W/TpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AXE/MwI5oYIZHP+Bf9GTVwZpOdoyT/U62rUfZvWnnwbYVzXazM1uNP9qK17V/CBDb
	 R60b4oJpgrznNCgQvdzc5J+3sMur+XK2eEjJAXDmXWbdtpcexK2BbPrj1VvX8Ln5Vr
	 +Ef8aJKtdLjVq50yuos7UzuDUT5TS3AD/HCvqvZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhishek Tamboli <abhishektamboli9@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.10 321/482] ALSA: hda/realtek: Add a quirk for HP Pavilion 15z-ec200
Date: Tue,  8 Oct 2024 14:06:24 +0200
Message-ID: <20241008115701.061332679@linuxfoundation.org>
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
@@ -10162,6 +10162,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8896, "HP EliteBook 855 G8 Notebook PC", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8898, "HP EliteBook 845 G8 Notebook PC", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x103c, 0x88d0, "HP Pavilion 15-eh1xxx (mainboard 88D0)", ALC287_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x88dd, "HP Pavilion 15z-ec200", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8902, "HP OMEN 16", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x890e, "HP 255 G8 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8919, "HP Pavilion Aero Laptop 13-be0xxx", ALC287_FIXUP_HP_GPIO_LED),


