Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590692;
	b=V45o5xjR5Oo3sk4iFHcEbV67uYtpgusKqBdxLNkhSDxanWA+tHMcXHissbJ7sXAgcLrm
	 RVID0FbsKa4GhlKVuhyNQOMyi2qBpWwnBTu/hps+W0E4i/8X4XH8kCdxUWwc8sDQ7qwV7
	 r6zBum+8+XZvcOHq8KCKzRk/wSK9va+8biUqBXGfqq1ce0DDPnVBSXMFeqDHCKhW3npIQ
	 Nv2qYyfbfhK2Wo6XqX2dwigM4+G1oUTFqrYp213M4yfa+EgoDap/hPS82QsuHy7NSCJq8
	 QwdOAeaxZBCk7f39eh0zyXBofSCjtQMUwavgfesgATg6T98rfiLNAC0/A2do5pnE6Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590692;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fZuTTkONEZKNFGQC+p1u7KEzYZFs23ZL7k9P451k7Do=;
	b=jjSEr7nvet12W5ELdQDy/2gvIlH27dEr0dbLLDI1U1c8+7XqPKJgMx6L/p9hAm0BF2tP
	 597/bhzbRqweGp2oZKDZAwNYgN7qiKbhQkhjlx5I5/lA0iF16WZcIfPvnHU6mQZtnYbNd
	 wdwq8G7ibU9gyXEw21Kzz0fCVXRYuBIdMBifBcRxnXGnJfao62+UqXgqUI2X2wCAl9pRh
	 ipDvSYENZSZGna4RqWAWl0uQ6a28g2KpzkKS7/m0mmEM/ep21tcmUIsQvcupOGhp0fAmI
	 shPC0+Mtu3UVppmlCFZtYCufGR5+JBqkTiJfM21Rdl0ny9EOhVZY4Q3ti1CZUD3gb6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OGnkVpYP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F889606CEE0;
	Fri, 13 Nov 2026 17:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OGnkVpYP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC8D1F000C4;
	Fri, 13 Nov 2026 17:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590692;
	bh=fZuTTkONEZKNFGQC+p1u7KEzYZFs23ZL7k9P451k7Do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OGnkVpYPFtMsRaUflAhB9XS5gY0feZWvyYGvhT/2il/gIlbl0gO4AsZL1pXOfeAMW
	 KLBftDjbith716FnjtD8YZtc0WTSFasECh/r8nPKtDk4LnPfDwuJkyt0vAkegrOaIs
	 /JhuEEeD91DW0nwISc8B27JDSNoHXb8+PNhF3N7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matej Sochan <matej.sochan@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 561/686] ALSA: hda/realtek: Fix silent speakers on Lenovo Legion S7 15IMH05
Date: Fri, 13 Nov 2026 10:51:34 -0500
Message-ID: <20261113153840.663763714@linuxfoundation.org>
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

From: Matej Sochan <matej.sochan@gmail.com>

[ Upstream commit 1c36207da79455402d981125fa09716991364e66 ]

The speakers on the Legion S7 15IMH05 (PCI SSID 17aa:3811, ALC287) stay
silent after a cold boot with the current quirk, which applies
ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS. They only start working after a
suspend/resume cycle.

The amplifier setup is sent through COEF 0x24/0x26 on NID 0x20. On this
machine the first pass of that sequence appears to only wake the
amplifiers. Sending the identical sequence a second time makes both
speakers work, provided the second write comes a few milliseconds after
the first: back-to-back writes leave the speakers silent, a 7 ms gap
makes only the right speaker work, and 8 ms or more is reliable. A dump
of all COEF registers of NID 0x20 taken before and after the second
write shows no difference.

Add a dedicated fixup that writes the sequence, waits 20 ms to keep a
margin over the measured minimum, and writes it again on every codec
init. It chains to the same AUTOMUTE fixup as before. To share the
sequence, move the verbs of ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS into a
named array; this has no functional change for the other users of that
fixup.

Fixes: 67f4c61a73e9 ("ALSA: hda/realtek: Add quirk for Legion S7 15IMH")
Cc: stable@vger.kernel.org
Link: https://github.com/CachyOS/linux-cachyos/issues/792
Signed-off-by: Matej Sochan <matej.sochan@gmail.com>
Link: https://patch.msgid.link/20261007-legion-s7-v1-1-8ea7fb7ee766@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 92 +++++++++++++++++++------------
 1 file changed, 56 insertions(+), 36 deletions(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index ed76281856b1c..68b5648d51119 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3937,6 +3937,7 @@ enum {
 	ALC236_FIXUP_HP_LIMIT_INT_MIC_BOOST,
 	ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS,
 	ALC287_FIXUP_LEGION_15IMHG05_AUTOMUTE,
+	ALC287_FIXUP_LEGION_S7_15IMH05_AMP,
 	ALC287_FIXUP_YOGA7_14ITL_SPEAKERS,
 	ALC298_FIXUP_LENOVO_C940_DUET7,
 	ALC287_FIXUP_LENOVO_YOGA_BOOK_9I,
@@ -4058,6 +4059,53 @@ static void alc700_fixup_intel_hades_canyon(struct hda_codec *codec,
 		alc_update_coef_idx(codec, 0x1b, 0x0400, 0x0400);
 }
 
+static const struct hda_verb legion_amp_verbs[] = {
+	/* left speaker */
+	{ 0x20, AC_VERB_SET_COEF_INDEX, 0x24 },
+	{ 0x20, AC_VERB_SET_PROC_COEF, 0x41 },
+	{ 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
+	{ 0x20, AC_VERB_SET_PROC_COEF, 0xc },
+	{ 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+	{ 0x20, AC_VERB_SET_PROC_COEF, 0x1a },
+	{ 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+	{ 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
+	{ 0x20, AC_VERB_SET_PROC_COEF, 0x2 },
+	{ 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+	{ 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+	{ 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+
+	/* right speaker */
+	{ 0x20, AC_VERB_SET_COEF_INDEX, 0x24 },
+	{ 0x20, AC_VERB_SET_PROC_COEF, 0x42 },
+	{ 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
+	{ 0x20, AC_VERB_SET_PROC_COEF, 0xc },
+	{ 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+	{ 0x20, AC_VERB_SET_PROC_COEF, 0x2a },
+	{ 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+	{ 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
+	{ 0x20, AC_VERB_SET_PROC_COEF, 0x2 },
+	{ 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+	{ 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
+	{ 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
+	{}
+};
+
+static void alc287_fixup_legion_s7_amp(struct hda_codec *codec,
+				       const struct hda_fixup *fix, int action)
+{
+	if (action != HDA_FIXUP_ACT_INIT)
+		return;
+
+	snd_hda_sequence_write(codec, legion_amp_verbs);
+	/*
+	 * The amplifiers accept the setup only a few ms after the first
+	 * write (8 ms is the measured minimum on the test machine), so
+	 * keep a margin.
+	 */
+	msleep(20);
+	snd_hda_sequence_write(codec, legion_amp_verbs);
+}
+
 static const struct hda_fixup alc269_fixups[] = {
 	[ALC233_FIXUP_WUJIE_SPEAKERS] = {
 		.type = HDA_FIXUP_PINS,
@@ -6054,41 +6102,13 @@ static const struct hda_fixup alc269_fixups[] = {
 	},
 	[ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS] = {
 		.type = HDA_FIXUP_VERBS,
-		//.v.verbs = legion_15imhg05_coefs,
-		.v.verbs = (const struct hda_verb[]) {
-			 // set left speaker Legion 7i.
-			 { 0x20, AC_VERB_SET_COEF_INDEX, 0x24 },
-			 { 0x20, AC_VERB_SET_PROC_COEF, 0x41 },
-
-			 { 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
-			 { 0x20, AC_VERB_SET_PROC_COEF, 0xc },
-			 { 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
-			 { 0x20, AC_VERB_SET_PROC_COEF, 0x1a },
-			 { 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
-
-			 { 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
-			 { 0x20, AC_VERB_SET_PROC_COEF, 0x2 },
-			 { 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
-			 { 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
-			 { 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
-
-			 // set right speaker Legion 7i.
-			 { 0x20, AC_VERB_SET_COEF_INDEX, 0x24 },
-			 { 0x20, AC_VERB_SET_PROC_COEF, 0x42 },
-
-			 { 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
-			 { 0x20, AC_VERB_SET_PROC_COEF, 0xc },
-			 { 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
-			 { 0x20, AC_VERB_SET_PROC_COEF, 0x2a },
-			 { 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
-
-			 { 0x20, AC_VERB_SET_COEF_INDEX, 0x26 },
-			 { 0x20, AC_VERB_SET_PROC_COEF, 0x2 },
-			 { 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
-			 { 0x20, AC_VERB_SET_PROC_COEF, 0x0 },
-			 { 0x20, AC_VERB_SET_PROC_COEF, 0xb020 },
-			 {}
-		},
+		.v.verbs = legion_amp_verbs,
+		.chained = true,
+		.chain_id = ALC287_FIXUP_LEGION_15IMHG05_AUTOMUTE,
+	},
+	[ALC287_FIXUP_LEGION_S7_15IMH05_AMP] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc287_fixup_legion_s7_amp,
 		.chained = true,
 		.chain_id = ALC287_FIXUP_LEGION_15IMHG05_AUTOMUTE,
 	},
@@ -7549,7 +7569,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	 */
 	HDA_CODEC_QUIRK(0x17aa, 0x38d6, "Lenovo Yoga Pro 9 16IMH9", ALC287_FIXUP_TAS2781_I2C),
 	HDA_CODEC_QUIRK(0x17aa, 0x3855, "Legion 7 16ITHG6", ALC287_FIXUP_LEGION_16ITHG6),
-	SND_PCI_QUIRK(0x17aa, 0x3811, "Legion S7 15IMH05", ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS),
+	SND_PCI_QUIRK(0x17aa, 0x3811, "Legion S7 15IMH05", ALC287_FIXUP_LEGION_S7_15IMH05_AMP),
 	SND_PCI_QUIRK(0x17aa, 0x3813, "Legion 7i 15IMHG05", ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3818, "Lenovo C940 / Yoga Duet 7", ALC298_FIXUP_LENOVO_C940_DUET7),
 	SND_PCI_QUIRK(0x17aa, 0x3819, "Lenovo 13s Gen2 ITL", ALC287_FIXUP_13S_GEN2_SPEAKERS),
-- 
2.53.0



