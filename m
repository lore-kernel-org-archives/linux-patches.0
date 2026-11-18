Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043671;
	b=kU6MFj5wmRjfMshW9yQepWobeywuA4IRZr1f3iuVD9gqJuXuRoDhwNw7MiKpm0hZLJ9f
	 nUABrDlFSegy4OKOljOnIaC3Mk1yRw/WKrL68MFLVmIEUvOehKYIws1zhsiuUFXBBkc/r
	 VIwYBQhgezB5a1x3yO35IK7UvB26u6YgFFfWm7qVyZ2gADrdzG1zcbFK7Gk6wK3jeK1VX
	 oHu7FPCjNDCLmqpg2t3EqS1Sf97GIOArCCgvOFPdapP5h2BkoYnm7GVyx1HxRkXPaKMlZ
	 7FPKVUlCbrlc55YzvzGiiOBNtonoUsZk6VJJf8N8bxWjJ6W42kgtf3gO1ol+CEhvVCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043671;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rUdQiUh4hJTu1CbNOWtfMvUIcv5GTjy9SUTOldCmIlA=;
	b=qx6zXj4vEVVYcmDt9l3InJ226+68C7OFDUO9JhcL+5i8ebxaSPhO1qA9I/u9o5txx7fa
	 c5J6bANWxtCJwK4EXH5nyjmTLWZPnXkSeIr2X33PdyGnoy4mgfiH99p6xcM5SNx07ETyC
	 XjvosUf684XpJCyHEgjC7i3ZDX4wRGWT++24JFeb2d0GKKlWax/Rb8yw4zeVaoGYIcp35
	 WW8yjeQmQN3lv1HWEmBYzTuwqqDRXfuPJFzjKsTGoAS8qRC1EG3xtw+TBqqYwVjO+tLaP
	 rEi7RLYy+hasnGFgPveQ5XE7SzysDdzuiWdpZLR45T8Ev8fLveAgc2W7CT1hsUHvEnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A8Td++vh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF58606A31C;
	Wed, 18 Nov 2026 23:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A8Td++vh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4081F000C4;
	Wed, 18 Nov 2026 23:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043671;
	bh=rUdQiUh4hJTu1CbNOWtfMvUIcv5GTjy9SUTOldCmIlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A8Td++vhUzSNthpna1uB/MwiTphstHWN9vlzssXf2nerJiKIBK0GEzgx5qKSmIvIA
	 y1KbbWecNDaHqjYvvjucHc2cNmFNpcdQOM1akxqA3kOKSoLQV+BmcaDQyglYDoARpX
	 soR0dhCMzQDuKSYFycLDnHPBhajQan86OFjTj0eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tarun Noonemunthala <ntarun2000@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0294/2857] ALSA: hda/realtek: Add quirk for HP ENVY 13-aq1xxx
Date: Wed, 18 Nov 2026 15:22:08 +0100
Message-ID: <20261118150212.003895528@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0d8ddcf43c66f..4fe3e5c7d77ed 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7375,6 +7375,7 @@ enum {
 	ALC285_FIXUP_HP_SPECTRE_X360_EB1,
 	ALC285_FIXUP_HP_SPECTRE_X360_DF1,
 	ALC285_FIXUP_HP_ENVY_X360,
+	ALC285_FIXUP_HP_ENVY_13AQ,
 	ALC288_FIXUP_DELL_HEADSET_MODE,
 	ALC288_FIXUP_DELL1_MIC_NO_PRESENCE,
 	ALC288_FIXUP_DELL_XPS_13,
@@ -9388,6 +9389,15 @@ static const struct hda_fixup alc269_fixups[] = {
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
@@ -9944,6 +9954,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x861f, "HP Elite Dragonfly G1", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x864f, "HP Laptop 15-dy0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x86ad, "HP ENVY 13-aq1xxx", ALC285_FIXUP_HP_ENVY_13AQ),
 	SND_PCI_QUIRK(0x103c, 0x86c1, "HP Laptop 15-da3001TU", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x86c7, "HP Envy AiO 32", ALC274_FIXUP_HP_ENVY_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x86c8, "HP Laptop 14s-dr1xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
-- 
2.53.0



