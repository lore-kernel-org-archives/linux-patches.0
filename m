Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96ECE35AC23;
	Tue, 10 Mar 2026 11:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141128; cv=none; b=fdc6YAvaiDOYgfNDYYZgeT+76+aLsJfq27lsC1K1ljjxlxTQyZQ4d9WeTBOQlylnYmtEfiL5GhY4cHRWKNUFqYcsNzMgT8ydl2svHg6eY1HQqzCC4+lFvi8Pcfj+B3L/LjlRnSQ5R4t0mgEwTI1RKOPrTBoNUx21EyhYGWVNY6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141128; c=relaxed/simple;
	bh=fTgaJ0vPMvl1bbxKci45yRiuMPUnOAREYX/fXD4G34g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvqapIy9S27nEcuz+ioRO+E7zvbW/6HnzAY5naTYX8Y14/1YczQD1H2/ksDK2fGIezb40rSafvgaQKT0DXzAr4VwYhNH/vPCGGH9/tvjdYlwlIrqpsLxR3g+no3Orh9grbXiS7u3ZRQ5OYBOX9T74c/8su7aajCU5uYapio7wTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ooDPdobU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ooDPdobU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37B7C2BC86;
	Tue, 10 Mar 2026 11:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141128;
	bh=fTgaJ0vPMvl1bbxKci45yRiuMPUnOAREYX/fXD4G34g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ooDPdobUNEEGtnZBBNKVKdq9h8MvuoQn5S3D6ahznLC/YqCIna3q+YC6yxUwJKtoG
	 SKa7Pk5KuYJnCiOiZvjyWTdbUkQ38/mfh1Xzto/99ZQQcw36ElM3+YxsDtieyigRW+
	 fksAZey5lH0QXuUNZ07EZxbSbmHw9KpHZb6LbqgG7GOVuOKc8BxIT9o6IOPNz9uv51
	 3XqHlmH6EuRy1S0MxPE09tFKY6Vs7CJYqzTyvG7OypXhaQg1BK85pemfZc18iZ+Fhc
	 f3Ce1OnIqS/QFAyBA33yXPy1pHCaN2L8thqYU0IYMw3auERGnybOimA+SvjullRi1t
	 hyyn0Grfpk4GA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 131/311] ALSA: hda/realtek: add quirk for Acer Nitro ANV15-51
Date: Tue, 10 Mar 2026 07:02:58 -0400
Message-ID: <464531966fe8e85d07ffcb748c5b23c20d7eea17.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Zhang Heng <zhangheng@kylinos.cn>

commit aa4876fe2d9fcbcaa0592b25f34ec6f6ea7876c1 upstream.

fix mute/micmute LEDs and headset microphone for Acer Nitro ANV15-51.

[ The headset microphone issue is solved by Kailang]

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220279
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260209134149.3076957-1-zhangheng@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 1b674b77da69b..f5719e630d28a 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -4056,6 +4056,7 @@ enum {
 	ALC236_FIXUP_HP_MUTE_LED_MICMUTE_GPIO,
 	ALC233_FIXUP_LENOVO_GPIO2_MIC_HOTKEY,
 	ALC245_FIXUP_BASS_HP_DAC,
+	ALC245_FIXUP_ACER_MICMUTE_LED,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -6576,6 +6577,12 @@ static const struct hda_fixup alc269_fixups[] = {
 		/* Borrow the DAC routing selected for those Thinkpads */
 		.v.func = alc285_fixup_thinkpad_x1_gen7,
 	},
+	[ALC245_FIXUP_ACER_MICMUTE_LED] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc285_fixup_hp_coef_micmute_led,
+		.chained = true,
+		.chain_id = ALC2XX_FIXUP_HEADSET_MIC,
+	}
 };
 
 static const struct hda_quirk alc269_fixup_tbl[] = {
@@ -6628,6 +6635,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x159c, "Acer Nitro 5 AN515-58", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1597, "Acer Nitro 5 AN517-55", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x169a, "Acer Swift SFG16", ALC256_FIXUP_ACER_SFG16_MICMUTE_LED),
+	SND_PCI_QUIRK(0x1025, 0x171e, "Acer Nitro ANV15-51", ALC245_FIXUP_ACER_MICMUTE_LED),
 	SND_PCI_QUIRK(0x1025, 0x1826, "Acer Helios ZPC", ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1025, 0x182c, "Acer Helios ZPD", ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1025, 0x1844, "Acer Helios ZPS", ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2),
-- 
2.51.0

