Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061149;
	b=qTk+m8ReSX+rv4faDIc/g1BtuVqUsuAPJj2pjAJiBGdCRaOp3FW5Wxd7fYrao9c0SQpZ
	 760h+8/ymtvnBhaab7Ci2B+X7yiQwht8+hjQt+3DEeXW5n25uQbljEmEDQ4IuJaBVJ37L
	 09FmxkCPmi4ezNK3XCxUjSXcFbs9T7GWENkTPAMoPOtgYqydEOCKa/+MTjbvruMVfHxcZ
	 w8YUSUIuIOsfODHChjfHoH4ZTDSzh2bINgBORPRebBSYnh8jqvM2i8Tbh1lOzRTuJyAwf
	 cWN3UW6xZEQZP5pjGVdbX458pygst0SK7C8hqzoju0bSM+EXTCvRL9za6qY8gKMS9jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061149;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aotcY4wm5HosZxVjUd962hhzVp0sm+I1CqcpwhulqcE=;
	b=w0O+v508fRktQYRxBM3rS8OAegikVpH78kkrrLy1RCarTGb7KmPepcVSer13CIsQZZrs
	 thjBsSlBV50LFNFHx3ZevsC0YV25yjkAbAxoXEqB8WeZvkF73+R9yuaXsSW8umS2rsnQ2
	 H9hkiiq/4ckmNvKSFEaaDgJTOkLIgZQ2920qyPIBp1jNiDuIDkiqBVsXAebE1/GXz/GeJ
	 4jYpwxhjokHTzdRHQJ2e5KZhG7r6FeX/HLS61LGVyIU6BqH4VHGoY9a4cwdrgcewkph7U
	 VgiWnYWZP5nrbe0EecQ1b/fKlRc+R7fQ7L+JGwyBdg3D7mCYKlm9NPNSaBrv9hRyVhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Ysc/VElw";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D1C606A33E;
	Sat,  7 Nov 2026 14:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ysc/VElw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C69E1F0089F;
	Sat,  7 Nov 2026 14:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061148;
	bh=aotcY4wm5HosZxVjUd962hhzVp0sm+I1CqcpwhulqcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ysc/VElw1wMIdCaYWKG3xERWM0rcZ43nT7qkl2r85ZMQzouDFSIiZqZl6ELeN6pUb
	 2C8Q5HyiNPLnKSBz4RC2w9xUznO8EUq93Ws88gktiEB+deaxU2V8PvFVGqppgfb05o
	 I43EM44JP50AwhiSbwgY4ofKvv8uJJZzOtt6L2gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tarun Noonemunthala <ntarun2000@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0417/1536] ALSA: hda/realtek: Add quirk for HP ENVY 13-aq1xxx
Date: Sat,  7 Nov 2026 08:40:33 -0500
Message-ID: <20261107135009.289606525@linuxfoundation.org>
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

From: Tarun Noonemunthala <ntarun2000@gmail.com>

[ Upstream commit a01a223bd685be42e908d970de32eeb3646097f3 ]

The HP ENVY Laptop 13-aq1xxx (PCI SSID 103c:86ad) uses an ALC285 codec
with two speaker pairs: front (pin 0x14) and bottom (pin 0x17).

The BIOS leaves pin 0x14 as [N/A] ("not connected"), so the generic
parser never enables the front pair and only the bottom speakers are
audible.  The vendor driver (RTKVHD64.sys) programs that pin with the
value 0x90170150 and runs the HP amplifier initialization, which is
already implemented in the driver as ALC285_FIXUP_HP_GPIO_AMP_INIT.

Add a board fixup that applies the pin configuration for 0x14 and chains
to the existing amplifier init fixup.

The pin value was recovered from the vendor driver's own configuration
data.  The patch and this changelog were prepared with an AI coding
assistant (see the Assisted-by tag below); the change was reviewed and
tested by the submitter on the affected machine.

Tested on an HP ENVY 13-aq1xxx by rebuilding snd-hda-codec-alc269 from
the Fedora 7.1.10 source and loading it: the codec now reports
"line_outs=2 (0x14/0x17)", pin 0x14 comes up as an output (Pin-ctls
0x40) with its amplifier unmuted, and both speaker pairs play.

Assisted-by: OpenCode:deepseek-v4.1-flash checkpatch
Signed-off-by: Tarun Noonemunthala <ntarun2000@gmail.com>
Link: https://patch.msgid.link/20260923094014.58867-1-ntarun2000@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 41c8d0fe7aa06..7d89c5c90d2d1 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8038,6 +8038,7 @@ enum {
 	ALC285_FIXUP_HP_SPECTRE_X360_EB1,
 	ALC285_FIXUP_HP_SPECTRE_X360_DF1,
 	ALC285_FIXUP_HP_ENVY_X360,
+	ALC285_FIXUP_HP_ENVY_13AQ,
 	ALC288_FIXUP_DELL_HEADSET_MODE,
 	ALC288_FIXUP_DELL1_MIC_NO_PRESENCE,
 	ALC288_FIXUP_DELL_XPS_13,
@@ -10188,6 +10189,15 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC285_FIXUP_HP_GPIO_AMP_INIT,
 	},
+	[ALC285_FIXUP_HP_ENVY_13AQ] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x14, 0x90170150 }, /* front speakers */
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC285_FIXUP_HP_GPIO_AMP_INIT,
+	},
 	[ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc285_fixup_ideapad_s740_coef,
@@ -10930,6 +10940,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x861f, "HP Elite Dragonfly G1", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x864f, "HP Laptop 15-dy0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x86ad, "HP ENVY 13-aq1xxx", ALC285_FIXUP_HP_ENVY_13AQ),
 	SND_PCI_QUIRK(0x103c, 0x86c1, "HP Laptop 15-da3001TU", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x86c7, "HP Envy AiO 32", ALC274_FIXUP_HP_ENVY_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x86c8, "HP Laptop 14s-dr1xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
-- 
2.53.0



