Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064802;
	b=wvN0m95do6gzHZ3LTZDhB21D4dwrhZYZnZvLGZHEjnvlW50hsU7wTsn++vKa+PEb5gj6
	 LMvq5mtg6K3IVTQvdj9u7DoVoI/okeIUoJwt346agXKUtvM4jb9oyCNeEWKCwIS27nHwm
	 oYNckUkbUs0AVTSMaMtv1kLR20xm6fH2aoWzk5lt2wWmYjy8duJn2iyn8ME1snUZzv6ul
	 2AsyJJDmuhzS3ZSUIxEID8tESGTpJgvfgDMoCknRPR7xjDGBY/daC5Cwe0YHMz8y5CZod
	 JmrsjWcPeoobe2hz3LIi9UI/FJhhAqMz7T+mNzj/0iA/5LAEq5RMvCdTLvn2YurHTTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064802;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Ayi/+ER7ZdFPDJDPuosiVAvdNKMWpHJgJnolEXOyaLM=;
	b=IClHowpPW4r/WZKahbkfsb+9MI1QvHqakv1IEjdwex7IcQmqu77UXtCiKVZnEfQPmEra
	 Bye9nus6EbDaCiCTt2OaqBJUsOMFjZawkFn/uH0ju8jYMyPtE7tQNaPI1j6Ig3ijWbrBc
	 jaTfnOufZjsMi5CJvfDB5WUi/7ASurb444NFdd2Xqvt58zNwYiriOMl1OIJPQ9jsxKv6o
	 7WecU6V0poFYM5KikfiXAzpoNgcn1TT+oiseNBZmbMzGtbRRhdSIV19etUWzITt8hKkL6
	 zbAgiMg3RtwEX4upRG1xfrM2n1LWKSoQgZYFcPS5COqo6QhA2ZOqHjYwzr6gt6JQ+wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nxxt8hXq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3BE606C021;
	Sat,  7 Nov 2026 15:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nxxt8hXq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7ACD1F008A4;
	Sat,  7 Nov 2026 15:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064802;
	bh=Ayi/+ER7ZdFPDJDPuosiVAvdNKMWpHJgJnolEXOyaLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nxxt8hXqxg5xiFnzPxXrElVFaEJtUcSFl2nDwy3+m1lFuoko5EZLAtB3rGUaWIGJF
	 Crmo4FPOON8EU7qlN/itZDNgx9o/sIzpt8THupDy1LzrOId3ot8XHdgZPva7OqCrQI
	 +sAPN/Meszcys9NDQ8nk6mdlPuByhoH/+6u5ulGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Iv=C3=A1n=20Ezequiel=20Rodriguez?= <ivanrwcm25@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0743/1257] ALSA: hda/realtek: keep headset mic on Acer SSID 0x1640
Date: Sat,  7 Nov 2026 08:50:39 -0500
Message-ID: <20261107134959.808860580@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>

[ Upstream commit b23012149ca8e7a9c7c72e93b7639ca2a282d6b1 ]

The micmute-LED quirk for the Aspire A315-44P matches PCI SSID
1025:1640 before the Acer ALC256 pin fallback. The Aspire Go 15
AG15-42P shares that SSID and leaves nid 0x19 as 0x411111f0, so
selecting the LED-only fixup drops the headset-mic pin remap that
the fallback would have applied.

Chain ALC2XX_FIXUP_HEADSET_MIC before the GPIO3 micmute LED on that
SSID. Leave the Swift SFG16 entry (0x169a) unchanged.

Tested on Acer Aspire AG15-42P (Callisto_BCU): PCI pick 1025:1640,
Headset Mic=0x19, GPIO3 enabled with no physical micmute LED, speaker
and capture paths functional.

Fixes: d830631a128b ("ALSA: hda/realtek: Add micmute LED quirk for Acer Aspire A315-44P")
Cc: stable@vger.kernel.org
Signed-off-by: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
Link: https://patch.msgid.link/20261013204219.9649-1-ivanrwcm25@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 980e5029b2dbf..94593267a5b82 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -4344,6 +4344,7 @@ enum {
 	ALC2XX_FIXUP_HEADSET_MIC,
 	ALC289_FIXUP_DELL_CS35L41_SPI_2,
 	ALC256_FIXUP_ACER_SFG16_MICMUTE_LED,
+	ALC256_FIXUP_ACER_HEADSET_MICMUTE_LED,
 	ALC256_FIXUP_HEADPHONE_AMP_VOL,
 	ALC245_FIXUP_HP_SPECTRE_X360_EU0XXX,
 	ALC245_FIXUP_HP_SPECTRE_X360_16_AA0XXX,
@@ -6934,6 +6935,13 @@ static const struct hda_fixup alc269_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc256_fixup_acer_sfg16_micmute_led,
 	},
+	[ALC256_FIXUP_ACER_HEADSET_MICMUTE_LED] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc256_fixup_acer_sfg16_micmute_led,
+		.chained = true,
+		.chained_before = true,
+		.chain_id = ALC2XX_FIXUP_HEADSET_MIC,
+	},
 	[ALC256_FIXUP_HEADPHONE_AMP_VOL] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc256_decrease_headphone_amp_val,
@@ -7264,7 +7272,13 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x160e, "Acer PT316-51S", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1616, "Acer Aspire A515-57", ALC256_FIXUP_ACER_COLDBOOT),
 	SND_PCI_QUIRK(0x1025, 0x161f, "Acer S40-54", ALC256_FIXUP_ACER_MIC_NO_PRESENCE),
-	SND_PCI_QUIRK(0x1025, 0x1640, "Acer Aspire A315-44P", ALC256_FIXUP_ACER_SFG16_MICMUTE_LED),
+	/*
+	 * Shared SSID: A315-44P needs GPIO3 micmute LED; AG15-42P needs
+	 * the headset pin remap (BIOS leaves 0x19 as 0x411111f0). One
+	 * entry applies both. GPIO3 is unused on AG15.
+	 */
+	SND_PCI_QUIRK(0x1025, 0x1640, "Acer Aspire A315-44P / AG15-42P",
+		      ALC256_FIXUP_ACER_HEADSET_MICMUTE_LED),
 	SND_PCI_QUIRK(0x1025, 0x166c, "Acer Predator PH16-71", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1679, "Acer Nitro 16 AN16-41", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x169a, "Acer Swift SFG16", ALC256_FIXUP_ACER_SFG16_MICMUTE_LED),
-- 
2.53.0



