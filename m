Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065040;
	b=rPrW5BsHaMcuFdkTVibq6dZ9Lc6XzYBi+2Qp17tVq3BLKLNCMKad6qHGOu4qXpg5QC2L
	 SkoqR0vG9StdDeyf/bXqdvnfYDdmBisOkMKW+nOuu5wtxhofhqqikeBZcdtjSfz6c/Tll
	 YcW5ChbXEmRZlO1h18ugX5S7p16ms53QFYLZw/SDWPSqsysfq/332iG5q4zI8BNgfsx/N
	 Q+/e5470NO2IFkSwTJnznlmdSf82QO6epsmPwyxAf8MaEY/++e2WmeVDAsUy0Xu9aOxPG
	 8dE+RstOmBNZYVUVAnEVdSExOaCszZ4EkkT9y95cy1jlYui5gc8Zea05HC0SIS+08Sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065040;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=olex/Zqbn56TYLhqeXeSOcF4tIAAvl86Z4DnL5TqM7E=;
	b=Et3WySSNbUMxmt4SdezcSKK9GnFQIUFMtBBJQjJUHtC93fJWyMfFTmjr+0h8CaOobF3s
	 EaDzZxoOhp4FrWo5Rz0v7sYvz22gfVdAy209FQf6woQhbXtxGDiUPHz997Ca2LY0itXcL
	 XMbx/WdDB0WC7JFdwLUImzDrihq2xCXT+hc/r/ZVFAxXsFAS+f7svYE8EmzIfcaZxHf4Q
	 VHOqygMN7QyYZegokguWpSTEO6wUaR6CPQf5Ocrib/3DNNchgx3M8CsQfhKA8qZJ59Njg
	 fcdw2EbOlRu38c9MlLFeo6a8OquZG11zeCm/MCopoVzIXNFfjJqPlxKMPsqPqJMiPQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U34y2rFN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C938A606A9C1;
	Sat,  7 Nov 2026 15:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U34y2rFN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708A51F0089F;
	Sat,  7 Nov 2026 15:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065039;
	bh=olex/Zqbn56TYLhqeXeSOcF4tIAAvl86Z4DnL5TqM7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U34y2rFN/BbJUIc7O+wQLExtUnjHwul0165UtMvM1X0aDAbFuxDhFvMOynYWOrO7D
	 l1RPbYJ4jr5kUcNmiNqesWoGoq0PZ8ipIo4I17qI56gU1x7kzBQVjtaIO7H01mEAmt
	 zbmYxKKJYUpmjzL3SPhoq5SqGZRcan1M2mf+aMao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Christidis <gxristidis@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0877/1257] ALSA: hda/realtek: Fix headset mic on ASUS Zenbook 14 UX3402VA
Date: Sat,  7 Nov 2026 08:52:53 -0500
Message-ID: <20261107135003.547267695@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Christidis <gxristidis@gmail.com>

[ Upstream commit 40409fa23d32c8ed51e832031daa6decd9d6fd11 ]

The UX3402VA (1043:16a3) BIOS leaves pin 0x19 unconfigured, so the
headset mic does not work. Use ALC294_FIXUP_ASUS_SPI_HEADSET_MIC like
the UX3405MA, it sets up the mic and keeps the CS35L41 speaker fixup.

Tested on a UX3402VA: headset mic, internal mic and speakers work.

Fixes: 07058dceb038 ("ALSA: hda/realtek: Splitting the UX3402 into two separate models")
Cc: stable@vger.kernel.org
Signed-off-by: George Christidis <gxristidis@gmail.com>
Link: https://patch.msgid.link/20261018-for-linus-v1-1-4d8e9ff27d89@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index e71f78b13a277..68650004ce0f9 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7907,7 +7907,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1663, "ASUS GU603ZI/ZJ/ZQ/ZU/ZV", ALC285_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1664, "ASUS ExpertBook PM3406CHA", ALC256_FIXUP_ASUS_PM3406CHA),
 	SND_PCI_QUIRK(0x1043, 0x1683, "ASUS UM3402YAR", ALC287_FIXUP_CS35L41_I2C_2),
-	SND_PCI_QUIRK(0x1043, 0x16a3, "ASUS UX3402VA", ALC245_FIXUP_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1043, 0x16a3, "ASUS UX3402VA", ALC294_FIXUP_ASUS_SPI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x16b2, "ASUS GU603", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x16d3, "ASUS UX5304VA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x16e3, "ASUS UX50", ALC269_FIXUP_STEREO_DMIC),
-- 
2.53.0



