Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831094;
	b=LOq+tZ+T+ghNmUqApLVW4Y7BvrPM4iZL1Auv/kW6/MijNpx381HzJlC6DWzrRHTxS+bs
	 x54usWXTIv9zbpRdcEty+218EHO3baTraEAGYvV2fja7GSw2KWvcEnPmoOsbrCVYg4gG4
	 Q8jI9CyUvgblVogmh19fXXkYEbLH5LcJt2+ZeuyZsEP3zMcz0GhOpKG7n8O+FLNSspYoL
	 l+kkbL3SyEyDOQYjtJ98uNKvFxBK+G374cJ1AYNhi7+TZWaq4ZS5jwABIAju5hY+/B666
	 Dti6P6jGH6Ev889fMGm1wvxDEUv7Yd1W4ouG9pjtBpiVezXTz/4T4VHXJDNTeP1+NfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831094;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oSMhyXnF0hHe4HAQzx1Rv2gdVZt07ML///pX8D4gTIE=;
	b=CQxjmI7NSHVMpVbKQWaeCh/KykI+xIFy4l7yriCazTDE9mZe/DntgsVYwHu9JdeMuxmr
	 E6fSHdaXI4FBYQ88J1zBPSEObMfAUy2FTrFP/gYrr44wQXeaePlgkjSKFdQFTK4vgnO5C
	 NFscUokq+YXKNK1GvI5hXKduILfbGItfh2neTYttp3/LSygiwe3aKkg6h8AGTnnjZyINn
	 k20iqt4tR/kQl43pB4068m/TkP1RhQM9GbNd9Az9q2MAMsTbunfYbOD4Ku63DuHjAgUAv
	 K2xuvl8K61g8Kd5TCQlu+ej4dLyOqT1Yxptj1nWhCCOgPgNoGgNuyZ7Qh2/BQRRaG5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZHFrFG5t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CEC606AC36;
	Wed,  4 Nov 2026 22:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZHFrFG5t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B171F000C1;
	Wed,  4 Nov 2026 22:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831094;
	bh=oSMhyXnF0hHe4HAQzx1Rv2gdVZt07ML///pX8D4gTIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZHFrFG5tw5Nua2LIssWtJF4QoPRLynB/xzTaR0GIPuq7rowdOfkbg+FwrUdVoT+eL
	 QQ3DvQIjqE+DNLyT7tRRr9HR32fgVFpYStCA4UDo3uTl9aAh/qBrK422KH5pTDU/cL
	 YGz0Zj6UPCJzkKExa1PuJn/UqCnd9Ncx1S3iSLkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhtasham Nawr al-Mahmud <muhtaseem2005@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0500/1005] ALSA: hda/realtek: Fix speakers on ASUS PM3406CHA
Date: Wed,  4 Nov 2026 16:03:53 -0500
Message-ID: <20261104211057.952652328@linuxfoundation.org>
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

From: Muhtasham Nawr al-Mahmud <muhtaseem2005@gmail.com>

[ Upstream commit 0eee030c2c09c7a44be778de5f451d9e7a2f09c1 ]

The ASUS ExpertBook PM3406CHA uses an ALC256 codec with subsystem
ID 1043:1664. On Linux boot, the internal speakers are silent even
though playback is routed to the codec and the speaker pin is
configured for output.

The codec starts with coefficient 0x10 set to 0x1d20. Writing 0x7f20
to coefficient 0x10 immediately restores internal speaker output.

This was reproduced on the affected hardware from a fresh boot using
hda-verb. Reducing a larger initialization sequence showed that this
coefficient write alone is sufficient; no GPIO, EAPD, pin-control, or
other coefficient changes are required. After applying the coefficient
in userspace, speaker output also remains functional across suspend
and resume.

Add a machine-specific HDA fixup that writes the required coefficient.

The fixup has been compile-tested, but could not be boot-tested because
the affected hardware is no longer available.

Closes: https://bugs.launchpad.net/ubuntu/+source/alsa-driver/+bug/2162718
Signed-off-by: Muhtasham Nawr al-Mahmud <muhtaseem2005@gmail.com>
Link: https://patch.msgid.link/20260924144512.3989-1-muhtaseem2005@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index fa5bc54ff083d..a40b85fbaf393 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3678,6 +3678,7 @@ enum {
 	ALC269_FIXUP_SONY_VAIO,
 	ALC275_FIXUP_SONY_VAIO_GPIO2,
 	ALC269_FIXUP_DELL_M101Z,
+	ALC256_FIXUP_ASUS_PM3406CHA,
 	ALC269_FIXUP_SKU_IGNORE,
 	ALC269_FIXUP_ASUS_G73JW,
 	ALC269_FIXUP_ASUS_N7601ZM_PINS,
@@ -4089,6 +4090,14 @@ static const struct hda_fixup alc269_fixups[] = {
 			{}
 		}
 	},
+	[ALC256_FIXUP_ASUS_PM3406CHA] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x10 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x7f20 },
+			{}
+		}
+	},
 	[ALC269_FIXUP_SKU_IGNORE] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc_fixup_sku_ignore,
@@ -7184,6 +7193,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1652, "ASUS ROG Zephyrus Do 15 SE", ALC289_FIXUP_ASUS_ZEPHYRUS_DUAL_SPK),
 	SND_PCI_QUIRK(0x1043, 0x1662, "ASUS GV301QH", ALC294_FIXUP_ASUS_DUAL_SPK),
 	SND_PCI_QUIRK(0x1043, 0x1663, "ASUS GU603ZI/ZJ/ZQ/ZU/ZV", ALC285_FIXUP_ASUS_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1043, 0x1664, "ASUS ExpertBook PM3406CHA", ALC256_FIXUP_ASUS_PM3406CHA),
 	SND_PCI_QUIRK(0x1043, 0x1683, "ASUS UM3402YAR", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x16a3, "ASUS UX3402VA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x16b2, "ASUS GU603", ALC289_FIXUP_ASUS_GA401),
-- 
2.53.0



