Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585888;
	b=QBeO7J+SOdrMIz/UaPZ7NP9IlC4HCFMxQz+7i8BWfL9iTy5Nq4zVwdf5B5FXJvKN+aic
	 vbd5yjgJseXB6GbE7oPGDgzWHCDsd/3up0k+l4zMjX+g1m4h7RT+Lz7MpZLag9pykxGsV
	 vT/yRXngYDZMcNtThpbxJUrqvkIi8AsImYkrVzgBrB3zlk6KrUrnrn8DKtJ+X43tmWL0f
	 +ZLWf0faW/y+cF5yl6H2cSr/OKkFTsWPee9bYJGQ1iOpP7sid44LRBl6mvJQvhcJY0qvO
	 9oKgcTxBPBB4KAhzimGvlMzehYhPRZYV6j+01ypfQRsvpmns1nUkthuXEj/zzi7Q1dA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585888;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aW614efi0mHPwNVMvuoEFUxXEFQoY6y4L6pBFcJnwbI=;
	b=wpdGnXWUFEFlVKWoRwBrufiXtj7vWol2JI+BEEWfgIvRLMX5c17lJjKfQLftfkRolqG2
	 +UFWt0n3oUacKOE5pLe5xx4LyAYathY8AYKRo5ZIeC9SrmNGtRYY8BXh937ysutH11PNY
	 UdKhOS1UQbhnv3WJM7UywgDxKD6DNwgemddsmkPlwXp8foe5I26U0X6mfWtZmiuh+Naw+
	 LJebfvRDjCakZ/9JP/qLYaW3LbILrCg+K8Ofrsx7RRf78EYTu6M8wrIIXjw+U9JYO92If
	 lGBZbbXb656QSUnl/c7pAV3fTIi9ebiAWYKXanKwx6CcoajGEc0Ly4KEv9z65s/DHHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zahkWs7e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7655606EAAC;
	Fri, 13 Nov 2026 16:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zahkWs7e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B6E1F000C4;
	Fri, 13 Nov 2026 16:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585888;
	bh=aW614efi0mHPwNVMvuoEFUxXEFQoY6y4L6pBFcJnwbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zahkWs7e2nm9K9oCgJYxmD1i+bSAHa6U2R/CpWXwZ6QGDuyUkGZgi3Ys27llXw0zL
	 sc0AobXBnyjXixjnydTz8WXGPZE+mFUOC5KqWxc5Ob3+FjkT8uvf0wjbYSS8nxyKml
	 GfVCdhxvMjsXGPe9P/CeHjPjjnoUzjx29UXvo5J0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saim Masood <s.m.saim074@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 454/507] ALSA: hda/realtek: Fix speakers on ASUS ExpertBook PM3606CHA
Date: Fri, 13 Nov 2026 10:52:38 -0500
Message-ID: <20261113153812.114834540@linuxfoundation.org>
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

From: Saim Masood <s.m.saim074@gmail.com>

[ Upstream commit 556cca74b6ec6f0bc6a3dc27473487de3cc8c8fe ]

The internal speakers of the ASUS ExpertBook PM3606CHA (Realtek ALC256,
PCI SSID 1043:3501) stay silent with the default codec setup, and the
headphone jack is not detected either.  The codec needs COEF values that
differ from its power-on defaults: COEF 0x10, 0x16, 0x35, 0x37 and 0x57
on NID 0x20 have to be set to the values used by the Windows driver.
Toggling the codec GPIOs, and the existing ALC256 fixups alone, make no
difference.

Apply the COEFs from a new fixup at the INIT action, so that they are
restored after resume as well.  Chain to ALC256_FIXUP_ASUS_MIC_NO_PRESENCE
to keep the headset mic and the jack detection working, which the
fallback pin quirk provided before for this machine.

The COEF values were found by the reporter of the Ubuntu bug below, who
compared the codec state against the one under the Windows driver.

Tested on an ASUS ExpertBook PM3606CHA (BIOS PM3606CHA.304) with the
change applied to v7.2.5: with this fixup alone, the speakers, the
headphones with jack detection, and the headset mic all work, also
after suspend and resume.

Link: https://bugs.launchpad.net/bugs/2167288
Signed-off-by: Saim Masood <s.m.saim074@gmail.com>
Link: https://patch.msgid.link/065927dd-cabf-449a-992d-64887eedda01@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 72107104d4f5 ("ALSA: hda/realtek: Fix internal mic on Minisforum V3 and V3 SE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index dd3466c3129d7..03f03080bbeb5 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3537,6 +3537,27 @@ static void alc233_fixup_no_audio_jack(struct hda_codec *codec,
 	alc_process_coef_fw(codec, alc233_fixup_no_audio_jack_coefs);
 }
 
+static const struct coef_fw alc256_asus_speaker_coefs[] = {
+	WRITE_COEF(0x10, 0x7f20), WRITE_COEF(0x16, 0x0c50), WRITE_COEF(0x35, 0x8d6a),
+	WRITE_COEF(0x37, 0xfe06), WRITE_COEF(0x57, 0x7f7f),
+	{}
+};
+
+static void alc256_fixup_asus_speaker_coefs(struct hda_codec *codec,
+					    const struct hda_fixup *fix,
+					    int action)
+{
+	/*
+	 * The internal speakers of the ASUS ExpertBook PM3606CHA stay silent
+	 * with the default COEF values. These are the values set by the
+	 * Windows driver. They are applied on every init so that they are
+	 * restored after resume, too.
+	 */
+	if (action != HDA_FIXUP_ACT_INIT)
+		return;
+	alc_process_coef_fw(codec, alc256_asus_speaker_coefs);
+}
+
 static void alc256_fixup_mic_no_presence_and_resume(struct hda_codec *codec,
 						    const struct hda_fixup *fix,
 						    int action)
@@ -4391,6 +4412,7 @@ enum {
 	ALC285_LENOVO_DAC_RENAME,
 	ALC287_FIXUP_YOGA9_SPEAKER2_TO_DAC1,
 	ALC256_FIXUP_IPASON_SMARTBOOK_S1,
+	ALC256_FIXUP_ASUS_SPEAKER_COEFS,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -7208,6 +7230,12 @@ static const struct hda_fixup alc269_fixups[] = {
 			{ }
 		},
 	},
+	[ALC256_FIXUP_ASUS_SPEAKER_COEFS] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc256_fixup_asus_speaker_coefs,
+		.chained = true,
+		.chain_id = ALC256_FIXUP_ASUS_MIC_NO_PRESENCE,
+	},
 };
 
 static const struct hda_quirk alc269_fixup_tbl[] = {
@@ -7991,6 +8019,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x31e1, "ASUS B5605CCA", ALC294_FIXUP_ASUS_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x31f1, "ASUS B3605CCA", ALC294_FIXUP_ASUS_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x3391, "ASUS PM3606CKA", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x1043, 0x3501, "ASUS PM3606CHA", ALC256_FIXUP_ASUS_SPEAKER_COEFS),
 	SND_PCI_QUIRK(0x1043, 0x3601, "ASUS PM5406CGA", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x3611, "ASUS PM5606CGA", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x3701, "ASUS P5406CCA", ALC245_FIXUP_CS35L41_SPI_2),
-- 
2.53.0



