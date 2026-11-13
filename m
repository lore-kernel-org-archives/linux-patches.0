Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585808;
	b=otfDKX+MvsCGx9WkqSqyP8QHtvixWpOGQEdyI8RS1eGGa1Pq/hJc+HBKD5aqb2QhfQPB
	 JW5L9Of6wMGQ+UR5+sLGqe3mHdj3pm1ig18nO5vy0DwDUn5WySyvk+9A9wK5O2DrQi9Wl
	 bJCQWTB4hHvrCs45wWitjVOh0sxDeVHd3q7kvdBUKv7SKhq/0n94jCUUQGrbSl14pOwJv
	 g486R2t4/8ID+GV2KTTT3YFNbzp+7MS075TtNimMHkpJJzPYv8+2x7SAlyoDojuM0cHx/
	 jmrZUTOb3t3iwOCaJJWsYy+1nGZt7dgvloAQLonIxxqvDRp6cRIk+Cb3sGIovbxXnYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585808;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CyjR70/8JfVe1onDd8LmBvckpePHZArUUQtrW8KC1e8=;
	b=wLj8AWQ/9pSw0bkYS0bdXhfKaDx38t5b8fz7r4mrna9N2aBMtZfDg+VoFebizHCLRZc1
	 db/hdC+oJpiDAgYJ9xvjTFFHz7l/zx1rKQdzV1fSmFc7hOvKaFGlu6tTabZ0QORCmKxNb
	 eGb0QXe9+CLSfOVbbW9sG2arllTFf6vk6MuplbtTJCii98LANq2F8HPEcf4DE5Lv9RlwY
	 tjD42H9bGr1qOLEzdM2744hMMKOholuj6D+Bt+TRwUpv+LO/QoJj8S2z7GygzOTyXyl6x
	 nqGpHbsRCTCJS3aptINjkhaRlsbt68H8Nyny3Wd7KN/ognKrN06fmzw54xW0Uc62R9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QfLUx9ga;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3272606C545;
	Fri, 13 Nov 2026 16:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QfLUx9ga
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862DF1F000C5;
	Fri, 13 Nov 2026 16:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585807;
	bh=CyjR70/8JfVe1onDd8LmBvckpePHZArUUQtrW8KC1e8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QfLUx9ga5QqJ4lxtBJ/C05yB49L/zx2eZP61UWYDUMzVshE129SBtrEeayB7zwXo2
	 R1HlnTHTZSXlwJpEoMLqcPz4G6ZzenJt8aq+EZ5SpI7E2pr3QUEepi+ezXO0hKM7Pw
	 wKyS/DLCRbN5bZ5Rwk9CkdWUe4rQQagPLvgExSxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Simpson <chris@nilk.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 392/507] ALSA: hda/realtek: Enable bass speakers on Alienware m17 R3
Date: Fri, 13 Nov 2026 10:51:36 -0500
Message-ID: <20261113153810.049569291@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index 68650004ce0f9..1288b180df752 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7335,6 +7335,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x097e, "Dell Precision", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x098d, "Dell Precision", ALC233_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x09bf, "Dell Precision", ALC233_FIXUP_ASUS_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1028, 0x09d1, "Alienware m17 R3", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x0a2e, "Dell", ALC236_FIXUP_DELL_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0a30, "Dell", ALC236_FIXUP_DELL_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0a38, "Dell Latitude 7520", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE_QUIET),
-- 
2.53.0



