Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027134;
	b=LV6CSV6Koj3lIXNlMz3S8Wd0v8n9hV+R078HdAsNP7I9qDRAlimTQuOnIXk+bLmWxyF4
	 hQGAFWQ7OParbgh5yE0cMKkiOaAmu3Ne1pih95eJcgGyp6qM6besrRm/DfRrT/2Z2dpX+
	 BTMGy1aTjVjzvPyuWcNxHLhAHymOeeoN/hw3AK/N4oZGPmiRGGIpMF/AsO1gWFx8cQfZC
	 U/zHr0rLnLvR7Bf8yYfg43fxWJugB6QfhofobFmiOO2n8W6o3yYAXgH+0T1FqzTuGHjMl
	 sdsMmb9W4kw/ZuJGOFFV3lCDJAul4Cwh9gnfQrUn0bY8nJ+j6GximCuJEAHjO+uULrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027134;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qGJIB1QFpb0BTauau94X0KE3v3F9R3eCRNbPqs674Yg=;
	b=KI8WNGNxCDAwSrFnWslzugUAfy1YCEXLNsRqcMU6uN8ozIouGtL973HH9QI929opkTIM
	 BCkp/hGteouEc+J5gIW6KtOwmYllM7vEdwUUHbtoJrp5An/PTOrQ8BfNkbQMFSFpE4xjM
	 ljwUqV97TWrNIWcBUgkOUNpiEWt4818A7sgBrZseplKovJZeYuqLeXK3VNbOsFmrEk2Lr
	 O2tiuTSGDweFCf1+4DYeqXQkuBrJd7OhMmUACfoCo9RQ4uHmpFk+M1kDqjV7upZNMTcR4
	 UimtU8C/9h4SJiaAdCjUKqQvFv2TgwjgthXRdca0e83AJ71VGOhkBtHh9lrbKB7vtHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b6As4PAd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2458606A31C;
	Wed, 18 Nov 2026 18:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b6As4PAd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214C41F000C4;
	Wed, 18 Nov 2026 18:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027134;
	bh=qGJIB1QFpb0BTauau94X0KE3v3F9R3eCRNbPqs674Yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b6As4PAdhUxaD+xHrwJOWLyTU+bbK/JWR2NWOV1e5qHEGTeJvz99gwtIzY/Cs0aik
	 4LeRFxB4x6wy6bPjQv73MBqcy6qFxr+DC5N4aai+dxehwf5puuexYaXR0fbOHfpd8L
	 wfKbKKqLHuX0u8NZ9ajA5lKLJ4Ynlw1GQxgLHZrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackie Dong <xy-jackie@139.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1681/2151] ALSA: hda/realtek:ALC269 fixup for Yoga Pro 7 15ASH11 mic mute LED
Date: Wed, 18 Nov 2026 15:56:56 +0100
Message-ID: <20261118150223.064981740@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Jackie Dong <xy-jackie@139.com>

[ Upstream commit 17065203e1bc7e7f2786998d532cd93a06265156 ]

Lenovo Yoga Pro 7 15ASH11 with AMD RYZEN AI MAX+ 388 (Strix Halo, ACP
7.0) uses Realtek ALC287 series codec. The ALC269_FIXUP_LENOVO_XPAD_ACPI
in alc269_fixup_vendor_tbl[] can load lenovo_wmi_hotkey_utilities module
by default in this laptop, but the driver doesn't control mic mute LED.

If users run below command and the mic mute LED can work normally.

$sudo echo 'Capture Switch' >/sys/class/sound/ctl-led/mic/card1/attach

After added the SND_PCI_QUIRK quirk special for Lenovo Yoga Pro 7
15ASH11, the mic mute LED works well.

Fixes: 83dca2530fb3 ("ALSA: hda/realtek: ALC269 fixup for Lenovo Yoga Pro 7 15ASH111 audio")
Signed-off-by: Jackie Dong <xy-jackie@139.com>
Link: https://patch.msgid.link/20260527130353.5658-1-xy-jackie@139.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 2fc28b1186d6 ("ALSA: hda/realtek: Fix hiss/crackle on Lenovo Xiaoxin 14 GT (17aa:3912)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 303bff47ad610..1f65e80b23163 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3941,6 +3941,7 @@ enum {
 	ALC287_FIXUP_YOGA7_14ITL_SPEAKERS,
 	ALC298_FIXUP_LENOVO_C940_DUET7,
 	ALC287_FIXUP_LENOVO_YOGA_BOOK_9I,
+	ALC287_FIXUP_LENOVO_YOGA_PRO7,
 	ALC287_FIXUP_13S_GEN2_SPEAKERS,
 	ALC256_FIXUP_SET_COEF_DEFAULTS,
 	ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE,
@@ -6068,6 +6069,13 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC285_FIXUP_THINKPAD_HEADSET_JACK,
 	},
+	[ALC287_FIXUP_LENOVO_YOGA_PRO7] = {
+		.type = HDA_FIXUP_FUNC,
+		/* Reuse the DAC routing selected for ThinkPad X1 Gen7 */
+		.v.func = alc285_fixup_thinkpad_x1_gen7,
+		.chained = true,
+		.chain_id = ALC269_FIXUP_LENOVO_XPAD_ACPI,
+	},
 	[ALC623_FIXUP_LENOVO_THINKSTATION_P340] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc_fixup_no_shutup,
@@ -7663,7 +7671,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x38df, "Y990 YG DUAL", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38f9, "Thinkbook 16P Gen5", ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD),
 	SND_PCI_QUIRK(0x17aa, 0x38fa, "Thinkbook 16P Gen5", ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD),
-	SND_PCI_QUIRK(0x17aa, 0x38fc, "Lenovo Yoga Pro 7 15ASH11", ALC245_FIXUP_BASS_HP_DAC),
+	SND_PCI_QUIRK(0x17aa, 0x38fc, "Lenovo Yoga Pro 7 15ASH11", ALC287_FIXUP_LENOVO_YOGA_PRO7),
 	SND_PCI_QUIRK(0x17aa, 0x38fd, "ThinkBook plus Gen5 Hybrid", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
 	SND_PCI_QUIRK(0x17aa, 0x390d, "Lenovo Yoga Pro 7 14ASP10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
-- 
2.53.0



