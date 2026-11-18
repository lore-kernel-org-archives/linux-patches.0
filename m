Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020708;
	b=V4l6LeahQqUBU2k3c/7CZqh8rL0TZ4szBjdiTWb2/BybAT+Cp2/VnKdSFXNF9JCgezBw
	 LqtJSwpF5tXL1lkncBLHtJiG/S10J7GmWYqNkAPMB+Zb2Bm6OMcrhMgkizOePFDxc5qkH
	 AGXWs9qUjfVGXRcmtpEA43o/fa+oc8NU0FqdIZbSOd7oGUPM35PKadyOwa6yuopSwXnT2
	 FF/cKPS3OeXiaIn5D1JKIF6O7A0G4CRavkQSLnsuqb+ma2Ptu+NN8lFzQ/w+9EQcB7MDu
	 7wt1jODXe1gBO24C8k1WSElhLx7GIRMeMlNTNtF66o7LUGriETXlMzrb0uyi5eYGE6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020708;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=akuctfXcWrADZwWQKF3DAjsqYMtjcGkSGaLH2IcJa4o=;
	b=C2QC9ZebRiIfOIARxWdk4gYmRN0ekoL/Iuinsecu/0JfOjM+Jtr56L4sSXpEGAKe1Q3D
	 E6Qa48NbTW07+tHVT6p7Jy7+mDlm0ReGy3mhmz2hszW9+S1taOCRDOtpiLLhMkLSRvW/K
	 1tRDTv/7ex8KmVSUXsS6PwEfpV2wLu8ng88VBM6NuI4twdU6mbH4GJf0z84SKruWNRKmi
	 AFceGt3z94DBaQ+B/MDyPJXwI1QG1nE605IFWf0v4UvY/AIJT1DnEceo7upmEl86aa3Jk
	 v7hak7GAW40bCyJpQqQ/sCrD5AzFbGX3ggKFB1uHvYml+U2j2cqaIvGDYKnT5mBbyBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fHNrCMoc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C5160A3816;
	Wed, 18 Nov 2026 16:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fHNrCMoc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F0E1F000C8;
	Wed, 18 Nov 2026 16:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020708;
	bh=akuctfXcWrADZwWQKF3DAjsqYMtjcGkSGaLH2IcJa4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fHNrCMocZ0KU/2R6+zjQcHOl3NAiX7F2YPyyf4Foz/5kTn7Xj6ZmooXHNVQHrIeuG
	 TC/f0pCnSxp7ZNCKjeJEG/vMgHXFy5ie9EDMNPJrj5ohxPOjVCTQgQVyfQV0cfgQu0
	 mktSOHqT8xn2ACpfn5f4ItZx0sdvuTG3lelFtHz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viktor Menshin <ripeeerr@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2047/2651] ALSA: hda/realtek: Fix hiss/crackle on Lenovo Xiaoxin 14 GT (17aa:3912)
Date: Wed, 18 Nov 2026 15:54:47 +0100
Message-ID: <20261118150359.774303360@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Viktor Menshin <ripeeerr@gmail.com>

[ Upstream commit 2fc28b1186d6fce8b046e6118072cf3ca32f2960 ]

Commit 3a3e810e9108 ("ALSA: hda/realtek: Add quirk for Lenovo Xiaoxin
14 GT") added a quirk mapping SSID 17aa:3912 to
ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN, chosen by analogy with
neighboring SSIDs (0x390d, 0x3911, 0x391a) without being verified on
hardware, as noted in that commit's own message.

I have since tested it on the actual hardware (Lenovo Xiaoxin Pro 14
ASP10, same 17aa:3912 SSID) and confirmed it does not fix the reported
issue. ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN only repoints pin 0x17
and the preferred DAC pairs for the bass speaker; it does not touch
the codec's vendor processing coefficients. The actual symptom -
constant electrical hiss/crackle on both the headphone jack and the
internal speakers, independent of volume - is unrelated to pin/DAC
routing and is also present on stock Windows before the Realtek
driver is installed, which points at those coefficients being left
at their power-on default.

To find the correct values, I passed the physical HD Audio controller
through to a Windows 10 VM (VFIO, with QEMU patched to log CORB verb
traffic) and captured the coefficient writes the vendor Realtek driver
performs at init. Replaying a single one of them on Linux via hda-verb
reproducibly eliminates the headphone jack noise:

    hda-verb /dev/snd/hwC#D0 0x20 SET_COEF_INDEX 0x36
    hda-verb /dev/snd/hwC#D0 0x20 SET_PROC_COEF  0x77d7

This has held up across reboots and kernel updates for several weeks
(applied via a small systemd oneshot unit while testing).

Add a dedicated fixup that performs this coefficient write and chains
it with the existing ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN (which may
still be relevant for the bass speaker pin wiring on this board), and
point the 17aa:3912 quirk entry at it instead.

Honesty note: this fixes the headphone jack. The internal speakers
still have noise under certain conditions (notably worse on AC power)
that I have not been able to isolate via coefficient-table replay;
that part remains open. Sending what is verified to work rather than
holding this back.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221203
Fixes: 3a3e810e9108 ("ALSA: hda/realtek: Add quirk for Lenovo Xiaoxin 14 GT")
Signed-off-by: Viktor Menshin <ripeeerr@gmail.com>
Link: https://patch.msgid.link/20261015132157.57198-1-ripeeerr@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index e61cb50a8de97..30417b1b050cb 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3682,6 +3682,28 @@ static void alc287_fixup_yoga9_14iap7_bass_spk_pin(struct hda_codec *codec,
 	}
 }
 
+/*
+ * The Lenovo Xiaoxin 14 GT (SSID 17aa:3912) uses the same bass-speaker
+ * pin wiring as its 0x390d/0x3911/0x391a siblings, but on this board the
+ * codec's vendor processing coefficients (node 0x20) are left at their
+ * power-on default instead of being programmed the way the vendor
+ * (Windows) driver programs them. That leaves audible hiss/crackle on
+ * both the headphone jack and the internal speakers, independent of
+ * volume, regardless of which pin/DAC routing is used.
+ *
+ * This single coefficient write was captured from the vendor driver's
+ * own init sequence (via a VFIO pass-through of the physical codec to a
+ * Windows VM) and confirmed to eliminate the headphone jack noise.
+ */
+static void alc287_fixup_lenovo_xiaoxin_14gt_hp_noise(struct hda_codec *codec,
+						       const struct hda_fixup *fix, int action)
+{
+	if (action != HDA_FIXUP_ACT_INIT)
+		return;
+
+	alc_write_coef_idx(codec, 0x36, 0x77d7);
+}
+
 static void alc_fixup_yoga_pro7_audio(struct hda_codec *codec,
 				      const struct hda_fixup *fix, int action)
 {
@@ -4343,6 +4365,7 @@ enum {
 	ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK,
 	ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN,
 	ALC287_FIXUP_YOGA9_14IMH9_BASS_SPK_PIN,
+	ALC287_FIXUP_LENOVO_XIAOXIN_14GT_HP_NOISE,
 	ALC295_FIXUP_DELL_INSPIRON_TOP_SPEAKERS,
 	ALC236_FIXUP_DELL_DUAL_CODECS,
 	ALC287_FIXUP_CS35L41_I2C_2_THINKPAD_ACPI,
@@ -6844,6 +6867,12 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC287_FIXUP_CS35L41_I2C_2,
 	},
+	[ALC287_FIXUP_LENOVO_XIAOXIN_14GT_HP_NOISE] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc287_fixup_lenovo_xiaoxin_14gt_hp_noise,
+		.chained = true,
+		.chain_id = ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN,
+	},
 	[ALC295_FIXUP_DELL_INSPIRON_TOP_SPEAKERS] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc295_fixup_dell_inspiron_top_speakers,
@@ -8402,7 +8431,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	HDA_CODEC_QUIRK(0x17aa, 0x3907, "Legion Pro 7i 16IAX10H / Y9000P IAX10", ALC287_FIXUP_LENOVO_LEGION_AW88399),
 	SND_PCI_QUIRK(0x17aa, 0x390d, "Lenovo Yoga Pro 7 14ASP10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN_HEADSET),
 	SND_PCI_QUIRK(0x17aa, 0x3911, "Lenovo Yoga Pro 7 14IAH10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
-	SND_PCI_QUIRK(0x17aa, 0x3912, "Lenovo Xiaoxin 14 GT", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
+	SND_PCI_QUIRK(0x17aa, 0x3912, "Lenovo Xiaoxin 14 GT", ALC287_FIXUP_LENOVO_XIAOXIN_14GT_HP_NOISE),
 	SND_PCI_QUIRK(0x17aa, 0x3913, "Lenovo 145", ALC236_FIXUP_LENOVO_INV_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x391f, "Yoga S990-16 pro Quad YC Quad", ALC287_FIXUP_TXNW2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3920, "Yoga S990-16 pro Quad VECO Quad", ALC287_FIXUP_YOGA9_SPEAKER2_TO_DAC1),
-- 
2.53.0



