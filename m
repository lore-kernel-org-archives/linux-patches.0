Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061358;
	b=QIKDLbHAoPJnefJnk6kvB2i6t42kxMJ4nmgYBNCXXIa5V290fIfP4pX12UKVdUz30f0p
	 Sz4F3pc3z71kfOLdrSFU8V/LJ7pGxmJGvkEMfmtNo/49tkQvwMIxZl7Bfr/88XGulP1gk
	 9FXqpFgVbT3XsXJ94/CHu51zOmBMFtfoaZ4XSfv0QcKEJrU2Pv8CuJuVuaDftqwV9m+Fg
	 gnYuhqimp5oDymgUgtOEUvO1jL+uTchZXdCbKqjvN3ebmCVsp16ghubs7eXjkKWX3veXh
	 LNt5VssUrUb+EqTRIYb+jzmQBY8+dKP8oZCKK3xg7ivc+vXUAH46133r0dqV6qdHubA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061358;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0PlNr39AlRDHivpcDVPcZW/Wcy93Gu6RZJfyJNh6QGk=;
	b=JDWnbLmR955pwTXW8Tu6R32xxw92uFAhOLjVdRll6b00Pli6UVc2uEwUJZtWILiYHkfv
	 ixsSb0cJHLWk8U6KVqQollc4J16kvWbrx7qXb/4F5P1xepgVM5AQb3Lvrom8si+XyhnmP
	 rjJl5wT29IKg+BdFG1kKSbYEf4yFYUxTQ8slQsg2yZXW8RLumZoKGSLcj/DJMxf8tq/GX
	 FQs5rHUh3wg6jPGjktHJWM7jzoazYOTnDLOb2nB9W6sU7473OBKAADSC5VvtaldPVOMKI
	 mG6qtApLTlfBJGelrc7LiZiCzOjldQpBksKYXbFXsZMHix9AEpIaBTqiVvg3mKyocYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JLDjlT5Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CBD606A326;
	Sat,  7 Nov 2026 14:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JLDjlT5Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3AAF1F008A7;
	Sat,  7 Nov 2026 14:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061358;
	bh=0PlNr39AlRDHivpcDVPcZW/Wcy93Gu6RZJfyJNh6QGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JLDjlT5ZM8om5t+j7ycSeMeqglFMUgv62RqYZt3Wa4F8GAKw88tXvV28/AQroqcwR
	 3NTFzpz8XqAHW5S6A5fsqWULdErX7FofyoV6GTVL/v2r2ovVvfcLF60x0qZ59R1dmR
	 iN84lGt/JcW9KhH0ot5BjZf0hyLVZ2Eximwnmw9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Batishchev <ii343hbka@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0483/1536] ALSA: hda/realtek: Enable micmute LED on HP EliteBook 6 G1a p/n: AD3Q9ET#UUG
Date: Sat,  7 Nov 2026 08:41:39 -0500
Message-ID: <20261107135011.053109376@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Batishchev <ii343hbka@gmail.com>

[ Upstream commit e7da28b820d12927de30abf554c727a319f80359 ]

The HP EliteBook 6 G1a (SSID 103c:8e0d) uses a Realtek ALC236 codec.
Without a quirk no fixup is selected and the mic-mute LED stays off.
It needs the same ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF quirk as the
already-supported 14" variant (SSID 103c:8dfb), so add it.

Signed-off-by: Denis Batishchev <ii343hbka@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260810151440.2306217-2-ii343hbka@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index ca556753f0661..159e9a6db49e8 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11216,6 +11216,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8df0, "HP EliteBook 630 G12", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8dfc, "HP EliteBook 645 G12", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8dfe, "HP EliteBook 665 G12", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8e0d, "HP EliteBook 6 G1a 14 (AD3Q9ET#UUG)", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8e11, "HP Trekker", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8e12, "HP Trekker", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8e13, "HP Trekker", ALC287_FIXUP_CS35L41_I2C_2),
-- 
2.53.0



