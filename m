Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619349;
	b=wGN3dMcF2R5HZiuFJCFhP7G0e1FdrWU3LldtC1Hmtk6qrxbfzYbw0x6v9IXJRUBQytyg
	 yshDTG2mijfu/vkQO76U5diy4yOyGJktt1fQm2qTOc/UB7K17LZcc1Apl5p/EpXrn825o
	 4XAagMUETsDIBU2DKMeg6Cbul4OJpb9H1L2BSzWXZdK5kI7zroSpWwuECIE0gS+2jq5Kc
	 /bU7L5l/wzqpEBiGWjuAR/wWPK5eVqqmVJO7eqdLVvn8g2li+I36IoFbSwK/nUTltVoKs
	 m/3I7im2rc4ETGedbXKoF8liL2NPnbGPbdtSDrtlc4oJek27EVhsizKNvpqApmGL36A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619349;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jB3EH4RYoveUx8Ht/T5czR5TntNE5O5/BOoO4zpaSN0=;
	b=10eWYukOOkjKYzFvcJK4AU/9fZGigjqBjETds9gmw03TQ+ym115Wgdp0jaf29q0e1Spq
	 MdT2fgFZ/qDqAIOAiu3Af9pB2D1IIrl+QXnuTHCz1VQxcwElt8Iv9jyW7dAEiXZOgS+ch
	 5D/ma3XpoKuyBfk5r74UbE88roM+2pCjMHCCQnVm6MaYsLW7WQpxLjmNkpCfsffuyOoeB
	 g4mNstdNyo3DHvpFYge/8JIluv/Nbh5kDmb9XgRuIEZfoEiYy0md8Z9ncvI5reT7ivCKp
	 kl8taXGFhdOgmZpbiTBarGYc3DSBu1LGEUI65UCxU5i2KmlMU6AMhyK+0fIwrTmLigw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HW9ThjnU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58311606A326;
	Wed, 25 Nov 2026 15:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HW9ThjnU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444EB1F000D8;
	Wed, 25 Nov 2026 15:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619348;
	bh=jB3EH4RYoveUx8Ht/T5czR5TntNE5O5/BOoO4zpaSN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HW9ThjnU4D6OFvZ4M/gXyY85/pj74es1948KbfY+DdjomNHMO7xAYkHjcd0eQcBqd
	 HOsZWoXntClKrVTErXOA3SbtY7sCWifcDp5p0Pw0Zw/ZO5qXOFrngRjSVtVjOlXu1g
	 o6HgrWMUaEZe6d9alK2zWJuM2zAyO6CfH9jsnVYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Angel J <iamanaws@httpd.dev>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.3 0568/1005] ALSA: hda/realtek: Fix the Dell XPS 8940 headset microphone
Date: Wed, 25 Nov 2026 15:31:46 +0100
Message-ID: <20261125143835.058680578@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Angel J <iamanaws@httpd.dev>

commit ae28ba98f55a2f30fed57371899b8cecd7cbde64 upstream.

The Dell XPS 8940 (1028:09c5) has an ALC3861 codec (0x10ec0899).
Its BIOS marks the headset microphone pin at NID 0x19 as disconnected
(0x411111f0). With no external microphone input in the pin configuration,
the generic parser creates a shared headphone/mic input on NID 0x1b
instead. Headphone playback works, but the headset microphone is silent.

Override NID 0x19 as a front microphone without independent presence
detection. This gives the generic parser the dedicated microphone
input and preserves NID 0x1b for simultaneous headphone playback.

I encountered this issue on my XPS 8940. Similar symptoms were also
reported by a user on Ubuntu:
https://bugs.launchpad.net/bugs/1971232

Cc: stable@vger.kernel.org
Assisted-by: Codex (GPT-6.1 Sol)
Signed-off-by: Angel J <iamanaws@httpd.dev>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20261103150336.507675-1-iamanaws@httpd.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc882.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/sound/hda/codecs/realtek/alc882.c
+++ b/sound/hda/codecs/realtek/alc882.c
@@ -50,6 +50,7 @@ enum {
 	ALC889_FIXUP_MP41_VREF,
 	ALC882_FIXUP_INV_DMIC,
 	ALC882_FIXUP_NO_PRIMARY_HP,
+	ALC898_FIXUP_DELL_XPS8940_MIC,
 	ALC887_FIXUP_ASUS_BASS,
 	ALC887_FIXUP_BASS_CHMAP,
 	ALC1220_FIXUP_GB_DUAL_CODECS,
@@ -507,6 +508,13 @@ static const struct hda_fixup alc882_fix
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc882_fixup_no_primary_hp,
 	},
+	[ALC898_FIXUP_DELL_XPS8940_MIC] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x19, 0x02a19130 }, /* headset mic, no separate jack detect */
+			{}
+		},
+	},
 	[ALC887_FIXUP_ASUS_BASS] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -610,6 +618,8 @@ static const struct hda_quirk alc882_fix
 	SND_PCI_QUIRK(0x1025, 0x0259, "Acer Aspire 5935", ALC889_FIXUP_DAC_ROUTE),
 	SND_PCI_QUIRK(0x1025, 0x026b, "Acer Aspire 8940G", ALC882_FIXUP_ACER_ASPIRE_8930G),
 	SND_PCI_QUIRK(0x1025, 0x0296, "Acer Aspire 7736z", ALC882_FIXUP_ACER_ASPIRE_7736),
+	SND_PCI_QUIRK(0x1028, 0x09c5, "Dell XPS 8940",
+		      ALC898_FIXUP_DELL_XPS8940_MIC),
 	SND_PCI_QUIRK(0x1043, 0x13c2, "Asus A7M", ALC882_FIXUP_EAPD),
 	SND_PCI_QUIRK(0x1043, 0x1873, "ASUS W90V", ALC882_FIXUP_ASUS_W90V),
 	SND_PCI_QUIRK(0x1043, 0x1971, "Asus W2JC", ALC882_FIXUP_ASUS_W2JC),


