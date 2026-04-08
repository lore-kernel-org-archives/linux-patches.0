Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D34537F01B;
	Wed,  8 Apr 2026 18:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674726; cv=none; b=B/aYP/Vvm5A0tMVbw4Qv6+9Xcj+X3HaI51O9xvBvVYR6ZQtZuY7S6avdGA4xFhvihWS7bt42dbAp3Nz74jwAENU0fp4aDEC3UUjYlFu7QC1TBcft46Cr6x7r+IiHK/SF1ZjIlJUai4Qy3WYwTYOVcTD6s+lyGsxeOsMDwY2/B0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674726; c=relaxed/simple;
	bh=qiVhjvyaBQC2mt1uTEJ6cPZ6OE/XqN+9n3Eo1QJEnss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V8k300yu6Xw9G2Ok1vrWmmHDyS5kmzSoWANOAO2plzYpKiGOqUMCk2axPOTy8iVhg9c6jue/6mKXxZBfj5q4lNOxcrvBTvJyZ413WfyF5TJKPYPRvcN1+FZSraJVeonCvQDkTDdbdOWl0K6iEBZ97jKU8ahBSyUHOyXY/DjBJY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qfVbvJeW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qfVbvJeW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B6BC19421;
	Wed,  8 Apr 2026 18:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674726;
	bh=qiVhjvyaBQC2mt1uTEJ6cPZ6OE/XqN+9n3Eo1QJEnss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qfVbvJeWx8okpTpgt1F3cOGaluzNO8S9JTZq0gUG7Lq+cb7L5W0V0kIJweEEwqhyb
	 QGWUv4E9mk53wbfITdBhfHq1QgEdwJRMrv4PoiXeDcuejeQITUJb4Zg3CYQ64LOK1C
	 K2+RDqfJ8TwN1bJOx4IZWn3sELeymZc29Wtp913U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Artem S. Tashkinov" <aros@gmx.com>,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.19 177/311] ALSA: hda/realtek: change quirk for HP OmniBook 7 Laptop 16-bh0xxx
Date: Wed,  8 Apr 2026 20:02:57 +0200
Message-ID: <20260408175946.014740056@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

commit 73ff3916d803f7ca3a4325af649e46ff89d6c3a7 upstream.

HP OmniBook 7 Laptop 16-bh0xxx has the same PCI subsystem ID 0x103c8e60,
and the ALC245 on it needs this quirk to control the mute LED.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221214
Cc: <stable@vger.kernel.org>
Tested-by: Artem S. Tashkinov <aros@gmx.com>
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260327101215.481108-1-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -4102,6 +4102,7 @@ enum {
 	ALC233_FIXUP_LENOVO_GPIO2_MIC_HOTKEY,
 	ALC245_FIXUP_BASS_HP_DAC,
 	ALC245_FIXUP_ACER_MICMUTE_LED,
+	ALC245_FIXUP_CS35L41_I2C_2_MUTE_LED,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -6631,6 +6632,12 @@ static const struct hda_fixup alc269_fix
 		.v.func = alc285_fixup_hp_coef_micmute_led,
 		.chained = true,
 		.chain_id = ALC2XX_FIXUP_HEADSET_MIC,
+	},
+	[ALC245_FIXUP_CS35L41_I2C_2_MUTE_LED] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc245_fixup_hp_mute_led_coefbit,
+		.chained = true,
+		.chain_id = ALC287_FIXUP_CS35L41_I2C_2,
 	}
 };
 
@@ -7156,7 +7163,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8e37, "HP 16 Piston OmniBook X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8e3a, "HP Agusta", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8e3b, "HP Agusta", ALC287_FIXUP_CS35L41_I2C_2),
-	SND_PCI_QUIRK(0x103c, 0x8e60, "HP Trekker ", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8e60, "HP OmniBook 7 Laptop 16-bh0xxx", ALC245_FIXUP_CS35L41_I2C_2_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8e61, "HP Trekker ", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8e62, "HP Trekker ", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8e8a, "HP NexusX", ALC245_FIXUP_HP_TAS2781_I2C_MUTE_LED),


