Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063531;
	b=hixpq1BBPxqbeOKAxQB6FxD6iJfXttJT/q50mTtSrlvRgYL40IwSo8EBuZqxVlMj4GMV
	 VJSSVFBBkehps3q/nK6TjhVQB8G4MYCD2ZOXOjf3Nw+d5puq1vPhGiooJlJjf0sle/1xf
	 70PCmZ51C4n5oWZOo5uqCPd7UfWkjXQEAX1oO3YEYyL+kPFA0LoNvNOJT17mLu+QfUb7E
	 bG6IUTJ4DU2JfnBj6kjE0QeC0Kc/4ki5ud5gYDSuoada1UdbPbl3A1lhLETykVu3xIgtb
	 9kLKDwfqRTuowZzr0QvE2Kz/3+kKWKJJ5LQ1FNEzfOsEJcYjUKVbbuImj7/SH0N9Z6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063531;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zKiCuSCwrq1zp4Ya2w3Y4d26+ebgtG/liTpplMvy5D0=;
	b=0MeILICe9cJJnCrwM5FzJlb7KqpGxkVMyCbGjpqJ11+33LrBlGCLGOvjr592ONhly5z4
	 YIEL3V4V6/DBQJF2exsablOKRIw1wveSp18MfoT+mmzdpSWpZyK9++BJQqzxbY7kHW0x/
	 E2Zw7PbGi/EbWMr82cEjGttccOKPcoZAAhAOo59XYJUhf72w0dWZUiDgpYqHmBfK8Cq2I
	 abMHLpht9SytC9WgR65qzdxJIRIzZXurmEPPjhLun6LbmfQQPBIfWvcTDp7nLJvNqx1cO
	 cJFdUkQrWUhsrXvoT/lD+aXCHTnbuvZS0IAnzp65StFKJZH13FMrh+1Waza2GsVxzlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xjk9bBTD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0803606EEB4;
	Sat,  7 Nov 2026 14:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xjk9bBTD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4A31F008A3;
	Sat,  7 Nov 2026 14:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063530;
	bh=zKiCuSCwrq1zp4Ya2w3Y4d26+ebgtG/liTpplMvy5D0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xjk9bBTDWVL2Me/Nebne4mt1pxpqRAHiYC45DODfYT3GUDy/4TO4Zh1Dx6MrQlgWC
	 D12rsWNDgvwxx2RP7d/b4rLfldNr4OEvlFi3Lu4xffD+G25SKuLjnaxotuFVAtMdAm
	 0rQqnNxmXrVHscU3GqYp9lL+TjZoKVIsbqANasok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Christidis <gxristidis@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 642/869] ALSA: hda/realtek: Fix headset mic on ASUS Zenbook 14 UX3402VA
Date: Sat,  7 Nov 2026 08:55:24 -0500
Message-ID: <20261107134914.679308479@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c81ecda4e7b6e..404a93f552cb4 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7222,7 +7222,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
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



