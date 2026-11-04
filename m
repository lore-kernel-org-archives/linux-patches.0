Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831945;
	b=cBL1PnKKSoPlCRWGGVZJi+g9cD4gRuYcBTNxJB+a6738l5yoyzxrtkAxGDSSmtMB++wb
	 xbwIGUZD6E4co4pGp4WQ9lQnpxKupkPBp1t1YDwFYahsYDVVaVuSOZZ23nEJM8VYUtrcR
	 p11n5Cp9HY2XfLUyEE0pLQbQt7ob7Yfow74cdU2o0soq/4IQ+oIn0przbGjnAM4n0GD3X
	 oqpGfLIVp3tzqcNbfb8wk/albRAbFGvE580vuwbpppbf2TtvHaXz3Mt7rI94f12gEFs3j
	 wZm1Oduh3QdI6LS4rYANCMNi6XQDcuFX8z0OwYv2oYRrgaC1L31MeOxYI6V8ZqyQJdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831945;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uWO2r3F28oD1Ygoub2GqJv+lDrDzwSb0Lin1kGIiJbE=;
	b=lRNBWWCYM1LgSfygUMuNEEPzpeorUTn6rrYPZZ/uybPi2GymlVzj32E3Gm0SPpYnVw3N
	 FdspiqooTXI9qj3OwaBwEsIESeHr1fz0jZV7eujehCD+mbkxuIDFXPnhTWhVWWjQFUW/s
	 AXUPmKmSudOR+GPILtkJkl221uSm4F6KCViMuKm1rCV0z0lQYTsvaTnjwI1hcWOd7TUhz
	 ZCHKCJFBxXpJczsqTQ83EgKZDzrt9kgnZQuqva6w6cI6NbKYfZNdOm0WVnG755mmWIGfn
	 92eIqLIx4vifkCYXNg7myKKthcchJ6QSzmR6bF3cLLSNI6a3M2aGGUH916/3lAncPCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bUuMlqTe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48505606A335;
	Wed,  4 Nov 2026 22:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bUuMlqTe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3BE21F00919;
	Wed,  4 Nov 2026 22:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831945;
	bh=uWO2r3F28oD1Ygoub2GqJv+lDrDzwSb0Lin1kGIiJbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bUuMlqTewzQC3iPqplDxWwAuN2nyIB37zGa65yRSODPNd990yTWsGOr+1vAW1cSt8
	 BQeTfJ7hBuwFhYncrPE5Y8zVfLfDq2JOEsZFHwNtDZX1g5FFAtp85cyGROdw6cFIv+
	 b2wLy01rOLvwhnXNLkkKx6kOmYv8Gaa1t0WgWHeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Gauche <scott-dev@scottgauche.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 1005/1005] ALSA: hda/realtek: Fix audio after Windows reboot on ASUS Q423SA
Date: Wed,  4 Nov 2026 16:12:18 -0500
Message-ID: <20261104211111.168806158@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Scott Gauche <scott-dev@scottgauche.com>

commit 8acd6469f42784f38872ad83b14c41152d986b63 upstream.

The ASUS Vivobook S 14 Q423SA-U5512 (DMI family S5406SA) with the
ALC294 codec has working analog audio when booted directly after a full
shutdown. After a warm reboot from Windows 11, audio works briefly during
Linux startup, then both the internal speakers and headphones become
silent. PCM playback continues without errors.

Coefficient 0x1b is 0x4e4b on a direct cold boot, but 0x4a4b after the
Windows warm reboot. Restoring bit 10 changes it back to 0x4e4b and
immediately enables both analog outputs. Speaker playback, headphone
playback, jack switching, cold boot, and suspend/resume were tested
successfully. The same 0x4a4b state and immediate recovery with 0x4e4b
were independently confirmed on another S5406SA with subsystem 1043:10c4.

The same coefficient write is already used by
ALC294_FIXUP_ASUS_COEF_1B for the ASUS UX431DA. That fixup cannot be
reused here because it chains to ALC289_FIXUP_ASUS_GA401 and applies
unrelated DAC routing and microphone pin configuration.

Add a model-specific fixup for subsystem 1043:10c4 and chain it to the
existing ALC2XX_FIXUP_HEADSET_MIC fixup instead.

Link: https://github.com/thesofproject/sof/issues/11051
Fixes: f2d08f3651fb ("ALSA: hda/realtek: Fix headset mic on ASUS Vivobook S14 S5406SA")
Signed-off-by: Scott Gauche <scott-dev@scottgauche.com>
Link: https://patch.msgid.link/20261005154017.1164657-1-scott-dev@scottgauche.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3842,6 +3842,7 @@ enum {
 	ALC294_FIXUP_ASUS_I2C_HEADSET_MIC,
 	ALC294_FIXUP_ASUS_SPI_HEADSET_MIC,
 	ALC294_FIXUP_ASUS_SPK,
+	ALC294_FIXUP_ASUS_Q423SA,
 	ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE,
 	ALC285_FIXUP_LENOVO_PC_BEEP_IN_NOISE,
 	ALC255_FIXUP_ACER_HEADSET_MIC,
@@ -5263,6 +5264,17 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC294_FIXUP_ASUS_HEADSET_MIC
 	},
+	[ALC294_FIXUP_ASUS_Q423SA] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			/* Restore bit 10 lost after reboot from Windows */
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x1b },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x4e4b },
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC2XX_FIXUP_HEADSET_MIC,
+	},
 	[ALC295_FIXUP_CHROME_BOOK] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc295_fixup_chromebook,
@@ -7161,7 +7173,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1043, 0x10a1, "ASUS UX391UA", ALC294_FIXUP_ASUS_SPK),
 	SND_PCI_QUIRK(0x1043, 0x10a4, "ASUS TP3407SA", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x1043, 0x10c0, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
-	SND_PCI_QUIRK(0x1043, 0x10c4, "ASUS Vivobook S14 S5406SA", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1043, 0x10c4, "ASUS S5406SA/Q423SA", ALC294_FIXUP_ASUS_Q423SA),
 	SND_PCI_QUIRK(0x1043, 0x10d0, "ASUS X540LA/X540LJ", ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x10d3, "ASUS K6500ZC", ALC294_FIXUP_ASUS_SPK),
 	SND_PCI_QUIRK(0x1043, 0x1154, "ASUS TP3607SH", ALC287_FIXUP_TAS2781_I2C),


