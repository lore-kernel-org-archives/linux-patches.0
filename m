Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590475;
	b=Myi0hp1NmKjJcVsUiJYmvkvIsOiGi9ni+A8ns9W6GAOrd0oKjq3I+a8It+es4E6BEZEh
	 MDZSBnkdrMn/gtdOMEc5IV6NZkuq5U06pYBK7GfYcYFK6ukJe9mtxs2/byIVXbhgdDY+8
	 YetGzMmIgJpukiKm3rR0ubwtja0A0d2yEOCuRQhXa2zjhs2XPmgDyJFQAOAA4JO6C5Nsr
	 A1z2L7YaZR3qoDF65FLiJ3jv07LWGSsNOi6HrIZFqsr/6EKTjtbmqEWklm5TEfK5AB3YP
	 LNQcWcIBZWPFWlHOSy3M6Ha1cJ917uT7dsbSrwuid1luOUd2eHt3NSwWMqw6NTmLFsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590475;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8p/6rQfj3o/iVNG5t7sjh7tjIx2LkTEZ1C2x0mLI66k=;
	b=2vCJ+HBrR1OB4oS+go1cSfoEskQ3BFypk3UdxijpzTXy3HOr03XmamOY3xbJy5+MBIMU
	 ym8f2wuv4y9TEaWmsyA23B69ssYNjKuwN1tQZcAezObGWokGLmLBKogJGGpjhLRbBBYMk
	 jEkpkYluhMboL3Pcg6Vhhm5/RlJlQkwFdrtqOYjYgM1oSzN8Zc+2Qdmb193nY8r98IHhq
	 ShSchWycaBr2zflJIIUrpBvcEKVNVASmtBdZ7RoIX657HNCvabaegDWtXOgpl4FQiOf0/
	 SaYsOdvLVi6e14ZtYLbk9jj6fHVUvYojirpzhJwZtxDW8u6CYm2MdyzWVARLUaz1m2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x9TnZTSv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E57606B818;
	Fri, 13 Nov 2026 17:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x9TnZTSv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F491F000C6;
	Fri, 13 Nov 2026 17:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590475;
	bh=8p/6rQfj3o/iVNG5t7sjh7tjIx2LkTEZ1C2x0mLI66k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x9TnZTSvZS2S1RIfzK4sVGsWGUa9uT1qrW7JtH5LjZ4ODEtOypMDD40pHsnOPVanR
	 HFwwOvE6OyAGNi2Q9XHpjec91YSMp3ZTJU0OuLgsgPOW0UiRXggLrtD6oIivFVvK7V
	 oODPGHyV+V6DVKYTeLTaHIuQwOLRZV557xt8F+Q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Simpson <chris@nilk.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 428/686] ALSA: hda/realtek: Enable bass speakers on Alienware m17 R3
Date: Fri, 13 Nov 2026 10:49:21 -0500
Message-ID: <20261113153835.432092709@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 404a93f552cb4..99d3fda16f3a2 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6710,6 +6710,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x097e, "Dell Precision", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x098d, "Dell Precision", ALC233_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x09bf, "Dell Precision", ALC233_FIXUP_ASUS_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1028, 0x09d1, "Alienware m17 R3", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x0a2e, "Dell", ALC236_FIXUP_DELL_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0a30, "Dell", ALC236_FIXUP_DELL_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0a38, "Dell Latitude 7520", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE_QUIET),
-- 
2.53.0



