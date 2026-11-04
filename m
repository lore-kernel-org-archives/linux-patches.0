Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831007;
	b=TStBprX4hiO0a/nA8VI3PS4BZWvXavHMMVdpG6aoty3FQOuWoTmmD5TouJkmCovi/RSW
	 Q6DvDKRqSrncGkwSBgwzeP4Akuj61NY3ya0Wyy1OGWW5V0X3PmFwVsjt01W0atxA0rAXc
	 8IuOFBqQ1DEopBjY8DlvT5+MDWONAicr3hJGk9SVOzeHCjZADGTMkCcjHixyRBk4j12dU
	 N8d3ZQYMb94oOo3X5TfKTF4pJ+ur01A8vVAQKYbdewoBWXeHAP058u7ILtmPvYybZY3Ya
	 IEBQsdGAiRiytzjnB6Bb6zoyg2CzVkbqvv8jp4Q/E0Dh5WTPM/fu5FDgTQXzOsMkdZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831007;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4J6Q7cDh7YYODSdKGEvXyitA1Ywj0IjlSN5miJu+fBc=;
	b=jGm1gELu80mZQ0imyjsUniQvbrw9aEtdaRJqRd6eEUgtIfi+U2GAz6zsFpcNBZNZdodn
	 1Tboxc37fWKFucQLtH+iFI9whqJ9S0fXDGwMkmxOCApWqJWrVQ7LsB9/AWr+9Fp67dSPY
	 F62fw7HFZE+bV1XVwnFSQKqKQTpsUQCbDyRfyW3Bva2EUpJxq1rlW5QlpCzKQgdfqLz7E
	 DpEnxGjMS++JB4uqnlpfAchOJwE9xto/RTDcN7cTkBwP8sllRoft6BlLFS6FROrWn66Zh
	 lLVWEd6qMEje5lVW7sI9ZdaR+VJrow3FPDPaAM9I2GrfHRHEluUAYLgfGb2W4iBVIRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dWqIzm4r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B10C606AB22;
	Wed,  4 Nov 2026 22:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dWqIzm4r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFB91F000C1;
	Wed,  4 Nov 2026 22:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831007;
	bh=4J6Q7cDh7YYODSdKGEvXyitA1Ywj0IjlSN5miJu+fBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dWqIzm4rXs8y2BRB/NyE0PyVCdrTxtuBKKbFAjsBAhgsXIUajwntaGKNm+CZftlDc
	 Pqa6crxQsGnHnIGd6vyHXmoePOE9Ot9T+yVbBQTc6qFapSUrIJi6e3WiflHdEK/VGM
	 qeRWiWgz4FmGN5Po22a34OLFIDIHawCjsHDS2txg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Csaba Budai <ilyr73@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0452/1005] ALSA: hda/realtek: Fix ALC700 audio on Intel Hades Canyon
Date: Wed,  4 Nov 2026 16:03:05 -0500
Message-ID: <20261104211056.705692818@linuxfoundation.org>
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

From: Csaba Budai <ilyr73@gmail.com>

[ Upstream commit 1fcccdc20a76b4639b00124cf2a379b837bd2bf7 ]

On Intel Hades Canyon systems with an ALC700 codec, analog audio can
become unusable after rebooting from Windows into Linux.

The affected system uses codec subsystem ID 8086:2073. In the broken
state, Realtek coefficient 0x1b has value 0x4a4b. Setting bit 0x0400
changes it to 0x4e4b and immediately restores normal analog playback.

The BIOS also sets this bit after disabling and re-enabling onboard
audio, while Windows may leave it cleared. Linux currently does not
restore it during codec initialization.

Add a machine-specific fixup for Intel Hades Canyon which sets only
bit 0x0400 of coefficient 0x1b during HDA_FIXUP_ACT_INIT.

The fix has been verified across Windows -> Linux reboots on an Intel
NUC8i7HNB with an ALC700 codec.

Signed-off-by: Csaba Budai <ilyr73@gmail.com>
Link: https://patch.msgid.link/20260821102514.11194-1-ilyr73@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index bc33930e83b9f..8196235c31d2b 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3820,6 +3820,7 @@ enum {
 	ALC225_FIXUP_DELL_WYSE_MIC_NO_PRESENCE,
 	ALC225_FIXUP_S3_POP_NOISE,
 	ALC700_FIXUP_INTEL_REFERENCE,
+	ALC700_FIXUP_INTEL_HADES_CANYON,
 	ALC274_FIXUP_DELL_BIND_DACS,
 	ALC274_FIXUP_DELL_AIO_LINEOUT_VERB,
 	ALC298_FIXUP_TPT470_DOCK_FIX,
@@ -4040,6 +4041,19 @@ static void alc287_fixup_lenovo_yoga_book_9i(struct hda_codec *codec,
 	__snd_hda_apply_fixup(codec, id, action, 0);
 }
 
+static void alc700_fixup_intel_hades_canyon(struct hda_codec *codec,
+					    const struct hda_fixup *fix,
+					    int action)
+{
+	/*
+	 * Windows may leave coef 0x1b bit 0x0400 cleared, causing broken
+	 * analog playback after rebooting into Linux.  Restore the bit
+	 * during codec initialization.
+	 */
+	if (action == HDA_FIXUP_ACT_INIT)
+		alc_update_coef_idx(codec, 0x1b, 0x0400, 0x0400);
+}
+
 static const struct hda_fixup alc269_fixups[] = {
 	[ALC233_FIXUP_WUJIE_SPEAKERS] = {
 		.type = HDA_FIXUP_PINS,
@@ -5092,6 +5106,10 @@ static const struct hda_fixup alc269_fixups[] = {
 			{}
 		}
 	},
+	[ALC700_FIXUP_INTEL_HADES_CANYON] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc700_fixup_intel_hades_canyon,
+	},
 	[ALC274_FIXUP_DELL_BIND_DACS] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc274_fixup_bind_dacs,
@@ -7653,6 +7671,8 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x2782, 0xa128, "Positivo N15RPE-S", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x2782, 0xa212, "Lunnen Ground 14", ALC269VC_FIXUP_LUNNEN_GROUND_14),
 	SND_PCI_QUIRK(0x7017, 0x2014, "Star Labs StarFighter", ALC233_FIXUP_STARLABS_STARFIGHTER),
+	SND_PCI_QUIRK(0x8086, 0x2073, "Intel NUC 8 Hades Canyon",
+		      ALC700_FIXUP_INTEL_HADES_CANYON),
 	SND_PCI_QUIRK(0x8086, 0x2074, "Intel NUC 8", ALC233_FIXUP_INTEL_NUC8_DMIC),
 	SND_PCI_QUIRK(0x8086, 0x2080, "Intel NUC 8 Rugged", ALC256_FIXUP_INTEL_NUC8_RUGGED),
 	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", ALC256_FIXUP_INTEL_NUC10),
-- 
2.53.0



