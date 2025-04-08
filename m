Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638A226A1A3;
	Tue,  8 Apr 2025 12:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115879; cv=none; b=nBOlQhAuKs9UmTyr6xKnYYlv8D16rcN4+hKplEkHF7B3yo9wN2RASGR8tfkMMeM8TS7e6CNnxucPF6d6ndj3YKNI7vmBYHYPnDflIWJ1STqk+N1PvDxg0/jmTBPqadiowuJB6yXVs65nbpPINnYr7U5EaaF7RrVAZj6/SoyfLZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115879; c=relaxed/simple;
	bh=IyTzrGIxRqsz4vf5E/1xpuARLc5pfRH5XtjEFK6FlwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQuSRX9aodM8IyjzYJymMTCNh5mZyhrCCaZQZ+EYTGGOAmWnHbIsQkcmPaDp4qlUjeGWp8oT4Stk4HwhDEy8QVwwUoN2WTG79V8Lg6qnjT2FWICdpvRkyhIw0U1nrVlscSsT6CXXoMD/mslqWyAlFMz+u1OQ/VGK8Fn0t/Ih//w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dhqrtrbx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dhqrtrbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7921C4CEE5;
	Tue,  8 Apr 2025 12:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115879;
	bh=IyTzrGIxRqsz4vf5E/1xpuARLc5pfRH5XtjEFK6FlwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dhqrtrbxZedhODdcn5pd7m1wcQWjR8U2893cTlODJYX8Rdds6CFizilqQhUzhGo6h
	 KbJuV7zhXYt6Vb/Z5nBGQW5oq58ABeaTCOTpVV+IF+v8KYTk9IwahEb1o/g12iptLH
	 7y2LVaVyeIgaR2EBXyklnbePyHd/Ski6QbuMfacU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 138/204] ALSA: hda/realtek: Add support for ASUS ROG Strix G614 Laptops using CS35L41 HDA
Date: Tue,  8 Apr 2025 12:51:08 +0200
Message-ID: <20250408104824.346171417@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit 9120b2b4ad0dad2f6bbb6bcacd0456f806fda62d ]

Add support for ASUS G614PH/PM/PP and G614FH/FM/FP.

Laptops use 2 CS35L41 Amps with HDA, using Internal boost, with I2C

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250305170714.755794-4-sbinding@opensource.cirrus.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 55fc63472ddc2..841338c82e807 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9996,7 +9996,9 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8e1a, "HP ZBook Firefly 14 G12A", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
+	SND_PCI_QUIRK(0x1043, 0x1054, "ASUS G614FH/FM/FP", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x106d, "Asus K53BE", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
+	SND_PCI_QUIRK(0x1043, 0x1074, "ASUS G614PH/PM/PP", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x10a1, "ASUS UX391UA", ALC294_FIXUP_ASUS_SPK),
 	SND_PCI_QUIRK(0x1043, 0x10c0, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x10d0, "ASUS X540LA/X540LJ", ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),
-- 
2.39.5



