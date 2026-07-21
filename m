Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6114746A5E5;
	Tue, 21 Jul 2026 15:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648808; cv=none; b=Gcru9KL40UEaEVq2pW+I5KLS/Z2vhVVTDVWpLa6XEUys7SV+wk0pP6PIvAL6Lh43ouHWrUUI9HVYkIZWcHhQlT2sgrIisK2PQVeUHZaVcalJNSei+Wnmdf/gp6B2/KJrtjVwVPww/5zkVqwFtYiyyMlJPn4AJnGutvdq4spJvb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648808; c=relaxed/simple;
	bh=5d0nhUnmaV5e7K/YfFE7bm55b6P342WOedK1Percv/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CDvqJ4Pyboa9v1ap7Fdig5vbN2MNyZjfhkFkUIcgTcK0LatreEV3v2dGOJCIQQxVsWWwy0KyQby2jChZbQ9yznoKUpJpuVTpLDBg4S+NngWTKCK9NyhXrv+wmzeiM8FOqut9FKyl+h9pm9BSbdNSg9OwHD3IDCq6dNlRfMzUr2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iDr6dfhG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iDr6dfhG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DBD1F000E9;
	Tue, 21 Jul 2026 15:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648807;
	bh=TCINsxkeVLoojur5gSnyRPNGPnieR1xZcLr6oKBYn6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iDr6dfhGp02XQYhBdATAz7n8t+nyktZDjcn7WM0bQ5iadY1cohcDSVX1kbf2FaLoR
	 +tyyiscb4EAg7/zpav/SHS/cmwaIqUslQl0BhTanKPlJR1c1sT8U+7f/trpzjhoSZo
	 n+qLpsTjYTfxT3LEqIqfHdOtuTTg3JAo7WglAVfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackie Dong <xy-jackie@139.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0339/2077] ALSA: hda/realtek:ALC269 fixup for Yoga Pro 7 15ASH11 mic mute LED
Date: Tue, 21 Jul 2026 17:00:12 +0200
Message-ID: <20260721152600.679451949@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -4076,6 +4076,7 @@ enum {
 	ALC287_FIXUP_YOGA7_14ITL_SPEAKERS,
 	ALC298_FIXUP_LENOVO_C940_DUET7,
 	ALC287_FIXUP_LENOVO_YOGA_BOOK_9I,
+	ALC287_FIXUP_LENOVO_YOGA_PRO7,
 	ALC287_FIXUP_13S_GEN2_SPEAKERS,
 	ALC256_FIXUP_SET_COEF_DEFAULTS,
 	ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE,
@@ -6101,6 +6102,13 @@ static const struct hda_fixup alc269_fix
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
@@ -7771,7 +7779,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x17aa, 0x38df, "Y990 YG DUAL", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38f9, "Thinkbook 16P Gen5", ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD),
 	SND_PCI_QUIRK(0x17aa, 0x38fa, "Thinkbook 16P Gen5", ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD),
-	SND_PCI_QUIRK(0x17aa, 0x38fc, "Lenovo Yoga Pro 7 15ASH11", ALC245_FIXUP_BASS_HP_DAC),
+	SND_PCI_QUIRK(0x17aa, 0x38fc, "Lenovo Yoga Pro 7 15ASH11", ALC287_FIXUP_LENOVO_YOGA_PRO7),
 	SND_PCI_QUIRK(0x17aa, 0x38fd, "ThinkBook plus Gen5 Hybrid", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
 	SND_PCI_QUIRK(0x17aa, 0x390d, "Lenovo Yoga Pro 7 14ASP10", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),


