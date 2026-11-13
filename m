Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591235;
	b=JGLU5J6hEJ+I+A3GAYFNKZOuXbqBGC5scWznvz2TnLswzRGV236l8N6GLTed8jX9Ca2B
	 NodpOtjZ4TpJSolMVl74nNb7iRqEP9AOsyqz5KzIee5sNVCXvMePsYS4YsH5G2cdemtE1
	 4EfiM+7d46j2NobGAzA9Q6YM27wYlrnVKfp60BHbr3Pf9bzPhJb4VrNX/9s2ENT+lIhJ8
	 jF2ejcrd9yP+0RTyk+5fuS4V7ejnYj7VX3J2yA8oUT8dUebz4ScsEhe1QliwnjYN+TTex
	 EmOII6HO5dc0i8gLsBYavJazXWFYXVB+8rF9pRSNx5D8qjRI5DXBygYm/TVyA/gvKzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591235;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bT1DcNPYFYTWUphxZ9seCiPqqk2fTY2ueyQMrZyNruY=;
	b=LqZ7odXajLsLm7Tvob9yqWyA6pXtzHHmlYpYK+EaCqcK1iMozIJmjx5aluc9HcFtOc7q
	 oEH825bJOL2DBl3wmsx1gOU2B1PuwQQ0pCw4kp0XRjV67xRCFPXSgiFZ+dtcrTjJ8rpRT
	 9ejQHQnpwRnA7oMe8c5LLdUXpYtngQtLQh1+Ds5ri0AsQ/7bDDftyphkQW0HzqlGMyGTa
	 wqJ7OvIaoabM3xPeKMtHfsCTatKdXGFj21E/wAF22nJviQ1NIZQ/5Xkaxd6GYOWzekiaS
	 /Ra6JtL/YsAKufQzrGTHkhZLftb+8cu4uUObV+GsHGcywtpUmzDCEr9/DNSh2g6NlGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Tacu/oN1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF01060A2603;
	Fri, 13 Nov 2026 17:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tacu/oN1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE771F000C5;
	Fri, 13 Nov 2026 17:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591235;
	bh=bT1DcNPYFYTWUphxZ9seCiPqqk2fTY2ueyQMrZyNruY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tacu/oN1DTA8H0MxpQW1UnVuX7zfIFhOtFIXY8gsqH25igveDFF0Z+/+OvrL/tA43
	 bUopLiKbS5njo2HQooTjNoHF2nDLOrjEZ453eSj+IycckUVNJbw/FRJUuBRDMRsZIz
	 d0Hf0TIbOiUHj5182x3AC99sNQJ4PK7YnFSbZ1qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Simpson <chris@nilk.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 364/670] ALSA: hda/realtek: Enable bass speakers on Alienware m17 R3
Date: Fri, 13 Nov 2026 10:48:48 -0500
Message-ID: <20261113153824.142989956@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Chris Simpson <chris@nilk.net>

[ Upstream commit eb296114d5ba4d335a640dbbbbc9618fded0ffe7 ]

The Alienware m17 R3 (ALC289, PCI SSID 1028:09d1) has a second speaker
pair, the bass speakers, on pin 0x17, which the BIOS leaves unconnected
(0x411111f0). No PCI SSID quirk matches the machine, so it gets
ALC269_FIXUP_DELL4_MIC_NO_PRESENCE from the fallback pin quirk table,
and only the speakers on pin 0x14 play.

Use ALC289_FIXUP_DUAL_SPK, as on the Alienware x16 R2 and Dell XPS 15
9510/9520: it sets pin 0x17 up as a speaker on DAC 0x02, so one volume
control covers both pairs, and chains to
ALC269_FIXUP_DELL4_MIC_NO_PRESENCE, so the headset mic setup is
unchanged.

Tested on an Alienware m17 R3 (BIOS 1.38.0), Linux 7.3 with this change
applied: the bass speakers play, and volume and mute cover both pairs,
also after suspend and resume. Headphones and a headset mic were not
tested.

I used Claude Code (Claude Opus 5.5) to find the unused pin, pick the
existing fixup and write this patch and changelog; I did the listening
tests myself.

Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Chris Simpson <chris@nilk.net>
Link: https://patch.msgid.link/20261029-alc289-m17r3-v1-1-5d3eac605e7a@nilk.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 0b370a9eb9f2d..6f5fa76b78f11 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10835,6 +10835,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x097e, "Dell Precision", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x098d, "Dell Precision", ALC233_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x09bf, "Dell Precision", ALC233_FIXUP_ASUS_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1028, 0x09d1, "Alienware m17 R3", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x0a2e, "Dell", ALC236_FIXUP_DELL_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0a30, "Dell", ALC236_FIXUP_DELL_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0a38, "Dell Latitude 7520", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE_QUIET),
-- 
2.53.0



