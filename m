Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D75F2EACFF;
	Tue, 22 Jul 2025 14:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193265; cv=none; b=QsdvCbCOJ2fJfQYoH2FUBmCryDY/5kq7p+LRWh9uzR8fIk6ZU53FAqPGai9lPr0geehzM5nflbhltvww8c+f0T41N5w5iLbFeURDQeJuOVeJbYHNurm9VnEzqFoNwDS5wP7TnKoS8xMM593sCQ4dhKA1Px5i1KP4LkX3p8U1tzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193265; c=relaxed/simple;
	bh=nkfpQxysWk0/5zHi4GZqTCNAg6DhE97GEYOeGV/vib8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MD/+IEyZsS4zyo2J4TBhmmSHBBEtabRoLMXzxakXsf3CcumqEv+IVyRTFpDjS+FXiij9DjdlaY29cs/xl6AmmDHoHmnG7IgTURHluweO7fZCd0i/czECzEuef77GyQod+rf3grblK6N/h9VPsjZaLTc/MM0ENP4Vio6FqEbIBkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qmyYtium; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qmyYtium"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D1FC4CEEB;
	Tue, 22 Jul 2025 14:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193265;
	bh=nkfpQxysWk0/5zHi4GZqTCNAg6DhE97GEYOeGV/vib8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qmyYtiumskjfz2yEbQinvtdIEwJq+ns9lURPeYjwfEM/3f7nE2IVdOxzLXunXyfKP
	 3sNBGRYi7Qd/uElbyQaa8TSV0QJlHyUxEPMeT/9cz/QCDsUz1BDIubPsR5iYcRZ+Tb
	 h4IKE100fat3Gcrp7Iv5scKv5/h/usYu2n+Zx3H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.15 041/187] ALSA: hda/realtek: Add quirk for ASUS ROG Strix G712LWS
Date: Tue, 22 Jul 2025 15:43:31 +0200
Message-ID: <20250722134347.284515429@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -10983,6 +10983,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1043, 0x1a13, "Asus G73Jw", ALC269_FIXUP_ASUS_G73JW),
 	SND_PCI_QUIRK(0x1043, 0x1a63, "ASUS UX3405MA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1a83, "ASUS UM5302LA", ALC294_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x1043, 0x1a8e, "ASUS G712LWS", ALC294_FIXUP_LENOVO_MIC_LOCATION),
 	SND_PCI_QUIRK(0x1043, 0x1a8f, "ASUS UX582ZS", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1b11, "ASUS UX431DA", ALC294_FIXUP_ASUS_COEF_1B),
 	SND_PCI_QUIRK(0x1043, 0x1b13, "ASUS U41SV/GA403U", ALC285_FIXUP_ASUS_GA403U_HEADSET_MIC),


