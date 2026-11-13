Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585890;
	b=bLYCGRs1AqXxUfn0XoFW0URUUuYFPEzHJX4uhjnuEy3Wu8Bxd4WPWi8USwhtfA2jd2LN
	 jiftSulS6JebUPAFHzPCbsG+Bhhs8nxlZs9y6AGWcbUAL7BrT3B2s7CXNhCr93os3Iyj2
	 z7TiraauoxT4mXvjTiEpxGAEst1CPGKR4eUHvdi/NuZBmgLJdJzr3BFfbKQYaM/mZBEdO
	 bKPCi62ytx7JXKs9coCCekY8K0oTc6HHyFqYv1aKLaldu+607BV4xcOV4ptVk02f4U4j0
	 URjHI6b+rBxPbNH90vwcsGrjKDXtaSxq9GYscrO9ej0jC9MH+7NOJPTKBshBOv9DgdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585890;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E/XmuQ7CskDnuS7FWDlMVl9XdE8uneTcC/Oh4v4fNYc=;
	b=XbYiHyxlpvzXU9WlNprlSUhfaWiadTfUDMleS4Ysttb8uDaeTgrClOVcT+ATKKS1oltF
	 GRX95f0RPMXh0GaKGuDdJ98tYMMwrgy4dnBoAIVKHBJwWHVLq4wHnKHEgfpT5BMHN3aln
	 otKJUWV7w8zI+ARpoUkgck1pJoEzrZCB7jA9r2XjGDXnhjj06LDGuu49GNIzP+Q7AipQ/
	 bFdB61dFnyCB2FcNhKsG4b6licZpDVzm232f87Uf4CPQMPlos6RHqDuVE688LYIZ1criv
	 gG7Oq0ZYLF6VEIKaxeleml5GfjtpXINuYMBWVioHsCJlW4Pdgvsj87HnBGZkGv9DsiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yium3z8p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED89F606EA9D;
	Fri, 13 Nov 2026 16:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yium3z8p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A15F1F000C4;
	Fri, 13 Nov 2026 16:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585889;
	bh=E/XmuQ7CskDnuS7FWDlMVl9XdE8uneTcC/Oh4v4fNYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yium3z8por9KFPwx3jCwNjCpoKEzMuzeUbdgZG8seRN9ydP4qw/PVlK+XwIyy7Bu/
	 qzYcjzEU1c2PqTXsF1unk1/SGC13Z90ik9XghNUZwMPkuajks8S2aMdezAJsyyqDey
	 B7Jb1NhCXVV6e2wc59AnO7pegVNpSvVljcrJPKhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jared Wuerzburger <jwuerz@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 455/507] ALSA: hda/realtek: Fix internal mic on Minisforum V3 and V3 SE
Date: Fri, 13 Nov 2026 10:52:39 -0500
Message-ID: <20261113153812.147260676@linuxfoundation.org>
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

From: Jared Wuerzburger <jwuerz@gmail.com>

[ Upstream commit 72107104d4f522405c9dfdfbaeb230e371c295ee ]

On the Minisforum V3 and V3 SE (ALC245, PCI SSID 1f4c:e001) the
internal digital microphone array never produces any audio. The DMIC
pin 0x12 is parsed correctly ("Internal Mic=0x12"), but the headset mic
jack pin 0x19 (BIOS pin config 0x04a19050, jack detect enabled) has no
presence detect wired on these boards: reading GET_PIN_SENSE on 0x19
always returns "present" (as it does on the unused, unconnected pin
0x18), while the headphone jack 0x21 reports correctly.

The generic parser therefore sets up auto-mic switching and, believing
an external mic is always plugged in, permanently routes the ADC to the
empty jack (mixer 0x23 input 0x19 unmuted, input 0x12 muted). The
"Mic Jack" kcontrol reports "on" with nothing plugged in.

Mark pin 0x19 as having no presence detect. The parser then stops
auto-switching and exposes a normal "Capture Source" (Internal Mic /
Mic) control, which desktop audio stacks drive from their Internal
Microphone / Microphone ports. The existing bass speaker DAC routing is
kept by chaining to ALC245_FIXUP_BASS_HP_DAC.

Tested on both models with the same pin config applied through a
snd-hda-intel patch firmware ([pincfg] 0x19 0x04a19150):
 - V3 SE (Ryzen 7 7735U, BIOS 1.03), kernel 7.2.6
 - V3 (Ryzen 7 8840U, BIOS 1.06), kernel 7.2.7
Both boards report the same codec SSID and the same 0x19 default. On
both, the internal mic records at a normal level, headphone jack
detection on 0x21 still switches output, and the bass routing is
retained (DAC1/DAC2 Playback Volume controls present). A headset mic
on the combo jack was not tested (none available); with this change it
has to be selected manually. V3 users already report that the jack mic
gets no input [1], which is the other symptom of the same broken
presence detect.

The patched alc269.c was build-tested with W=1 on tiwai/sound.git
for-linus (7.3-rc3) without new warnings.

The diagnosis, the fixup and this changelog were written with the help
of an AI coding assistant; I reviewed them and tested the change on the
hardware listed above.

Fixes: e34743018249 ("ALSA: hda/realtek: Add quirk for Minisforum V3 SE")
Link: https://github.com/mudkipme/awesome-minisforum-v3/issues/14 [1]
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Jared Wuerzburger <jwuerz@gmail.com>
Link: https://patch.msgid.link/20260928152925.69032-1-jwuerz@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 03f03080bbeb5..49c4d01759b06 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -4413,6 +4413,7 @@ enum {
 	ALC287_FIXUP_YOGA9_SPEAKER2_TO_DAC1,
 	ALC256_FIXUP_IPASON_SMARTBOOK_S1,
 	ALC256_FIXUP_ASUS_SPEAKER_COEFS,
+	ALC245_FIXUP_MINISFORUM_V3_MIC_NO_PRESENCE,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -7236,6 +7237,15 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC256_FIXUP_ASUS_MIC_NO_PRESENCE,
 	},
+	[ALC245_FIXUP_MINISFORUM_V3_MIC_NO_PRESENCE] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x19, 0x04a19150 }, /* headset mic jack, no presence detect */
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC245_FIXUP_BASS_HP_DAC
+	},
 };
 
 static const struct hda_quirk alc269_fixup_tbl[] = {
@@ -8475,7 +8485,8 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1ee7, 0x2081, "HONOR MRB-XXX M1020", ALC256_FIXUP_HONOR_MRB_XXX_M1020_AUDIO),
 	SND_PCI_QUIRK(0x1f4c, 0xb020, "Minisforum AI X1 Pro",
 		      ALC245_FIXUP_MINISFORUM_JACK_DETECT),
-	SND_PCI_QUIRK(0x1f4c, 0xe001, "Minisforum V3 (SE)", ALC245_FIXUP_BASS_HP_DAC),
+	SND_PCI_QUIRK(0x1f4c, 0xe001, "Minisforum V3 (SE)",
+		      ALC245_FIXUP_MINISFORUM_V3_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1f66, 0x0105, "Ayaneo Portable Game Player", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x2014, 0x800a, "Positivo ARN50", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x2039, 0x0001, "Inspur S14-G1", ALC295_FIXUP_CHROME_BOOK),
-- 
2.53.0



