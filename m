Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3A13D5236;
	Fri, 24 Apr 2026 13:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038166; cv=none; b=MToqIebEeqJDySVL8koAjhaB7gkIePAvVHUOFV5p4hhxtKhlaSijyog/0yaCBuQop2zphcMoCGY+AlPFFzeio5fxF3Gg7RvgBWfxhoCJ0zDJ88ZD3C+v6GTWavE+v6vWFGCLgOIXO81T2Zge3IHOVfDGUdEijvdZQXar/jtWZhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038166; c=relaxed/simple;
	bh=r3yID7qQ7l+18jaXAxuChErPNrLiHfutU6gmwj2eLm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cn5iMJM6a2ZlIPhNB1o/9fU1zzHptjmdfVSk2RMVsMpncRpDUUKiJwonoW3XfH0WCnaXEOJY+ULDzbwEsf7h9OwTMliY3AgZDvUC1RWa9DYr9fSnik07FLKt8X1iLltB3Zw54kzqv7kk8Sy/S+PhsRfJRJQCvmIjmmS20JGDAdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dpVCsHLa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dpVCsHLa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C3BC19425;
	Fri, 24 Apr 2026 13:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038166;
	bh=r3yID7qQ7l+18jaXAxuChErPNrLiHfutU6gmwj2eLm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dpVCsHLabaDgWqO12hbOd1AeI7Jp483nDx7jdv4yP1oabpWO/1VaOIAxlQZ3PgvHn
	 8CMAIeEMWYp1fN4lDsHBrognmVHUCT0F9x+bgnrgwuBlaRxiJSiOZFPkga02iobaL2
	 SndzuG5aZeuWVsKr4idgBKmTGEYtPWBGf2ronIOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Naim <dnaim@cachyos.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 49/55] ALSA: hda/realtek: Add quirk for Legion S7 15IMH
Date: Fri, 24 Apr 2026 15:31:28 +0200
Message-ID: <20260424132440.264243063@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
References: <20260424132430.006424517@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Naim <dnaim@cachyos.org>

commit 67f4c61a73e9b17dc9593bf27badc6785ecadd78 upstream.

Fix speaker output on the Lenovo Legion S7 15IMH05.

Cc: stable@vger.kernel.org
Signed-off-by: Eric Naim <dnaim@cachyos.org>
Link: https://patch.msgid.link/20260413154818.351597-1-dnaim@cachyos.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7392,6 +7392,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x17aa, 0x3801, "Lenovo Yoga9 14IAP7", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	HDA_CODEC_QUIRK(0x17aa, 0x3802, "DuetITL 2021", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3802, "Lenovo Yoga Pro 9 14IRP8", ALC287_FIXUP_TAS2781_I2C),
+	SND_PCI_QUIRK(0x17aa, 0x3811, "Legion S7 15IMH05", ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3813, "Legion 7i 15IMHG05", ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3818, "Lenovo C940 / Yoga Duet 7", ALC298_FIXUP_LENOVO_C940_DUET7),
 	SND_PCI_QUIRK(0x17aa, 0x3819, "Lenovo 13s Gen2 ITL", ALC287_FIXUP_13S_GEN2_SPEAKERS),


