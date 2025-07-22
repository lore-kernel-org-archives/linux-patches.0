Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFBF2EACE8;
	Tue, 22 Jul 2025 13:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192299; cv=none; b=i8fsfoCTHBL5RqRqdiA1/pV9Zqc0OM1eYYQV74Hg6snXa8vmCYp7eVsaScYNI+ICSa+7tFMnPk8Uqy2l7dU97MsGp7u0O/rZqiX0tKamd636cgPY94AaoOGGrPg/3MdT/n+dKXOC4wa8VblZyJyPXABGR8snD91UmguUpNY2XtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192299; c=relaxed/simple;
	bh=WEzvyWoYscKeYFlIyoudNASbW7Ho5YrHiohVrkaMoLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jE+CyAMcBBltalB+5VPzcPf5C4tIeVL+C1TergUwQ5ufYqi3lHQv7p4e0BHvUTAqROGV5nW+gqP6uYNKBVBvDkaejRX+avVPWCCyVuNSt3IQbZ9/OOA2g8+AeZARpDF3f7BaLi/Hu3/1oz+HOWyp7qcK0fU7l+kN88DMhZUQjGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nXi5Yiup; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nXi5Yiup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5186C4CEEB;
	Tue, 22 Jul 2025 13:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192299;
	bh=WEzvyWoYscKeYFlIyoudNASbW7Ho5YrHiohVrkaMoLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nXi5YiupuHWv8wqZ9kHGZegUFFcJwHuRHCZN/52EqegZxkYluedgO4B2/Zki/fzuI
	 vC+AMTHK+sPI5T6imR9gPpWZZClgZOEX/zK9y+fPhBbn6GxPjl3WX/sG5Wrk9AEs/3
	 gi+vMp0mUbGSEMUesNqtBIY964JkXit1eVL7Mpx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 024/111] ALSA: hda/realtek: Add quirk for ASUS ROG Strix G712LWS
Date: Tue, 22 Jul 2025 15:43:59 +0200
Message-ID: <20250722134334.300342430@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -10303,6 +10303,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1043, 0x1a13, "Asus G73Jw", ALC269_FIXUP_ASUS_G73JW),
 	SND_PCI_QUIRK(0x1043, 0x1a63, "ASUS UX3405MA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1a83, "ASUS UM5302LA", ALC294_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x1043, 0x1a8e, "ASUS G712LWS", ALC294_FIXUP_LENOVO_MIC_LOCATION),
 	SND_PCI_QUIRK(0x1043, 0x1a8f, "ASUS UX582ZS", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1b11, "ASUS UX431DA", ALC294_FIXUP_ASUS_COEF_1B),
 	SND_PCI_QUIRK(0x1043, 0x1b13, "Asus U41SV", ALC269_FIXUP_INV_DMIC),


