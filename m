Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AAB21DE3A8;
	Thu, 17 Apr 2025 18:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913409; cv=none; b=dDDX09DpRnJZI+G+Hci1iaCZNksRd1NLXXR+qy/kkJ/cwdtqgGZWU+NZvOUHUQPcW3bQyx/P+BSLLS0CIZ4vFsiFS/MiLU7dVNmY3+1O5axXTd9Xoo9pmXFbz1ANNzIZXtzEon8H/OOVtF6RubV0ImA7GU+4a1x4ccAA9vUG1zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913409; c=relaxed/simple;
	bh=Quxl/Ojp+aKmo5TbrVvgbj7E4LQIPInQqV4hOvNhnuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kp9kZQzPEhkgVtVSLGUgMIDtjq+2WFze3ioyTZfGG4OovpedZMyeFVYvUZu4XJqLhdTpNWE4HDbfzG8dRN2VQmNNKk8o8czXDxmOvb88Q3GhpjCmRlVpHB8CCz2nMwWR3RrgV+6K3wt/K1Wgx6ME7A2ktN0/CBHN8YACSFcMqg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yUMdnIEq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yUMdnIEq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884EFC4CEE4;
	Thu, 17 Apr 2025 18:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913409;
	bh=Quxl/Ojp+aKmo5TbrVvgbj7E4LQIPInQqV4hOvNhnuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yUMdnIEqcpyd5aQ7eCkP3KQb0F+SEvDWhT23Gv0skuJ14aPS9yNx76a9MnljUA9SU
	 v7wKUXpra/rhDzfW0pDcGFE6YsYZNGJ1QSWBoljAew60/lVdtJVGtaughYFfRs/mVY
	 o7R2b7qn5KVOqDWujxkttbFAGU27QdH2PyOj1eCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sharan Kumar M <sharweshraajan@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.14 300/449] ALSA: hda/realtek: Enable Mute LED on HP OMEN 16 Laptop xd000xx
Date: Thu, 17 Apr 2025 19:49:48 +0200
Message-ID: <20250417175130.169760445@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sharan Kumar M <sharweshraajan@gmail.com>

commit e5182305a5199246dbcb4053299dcb1c8867b6ff upstream.

This patch adds the HP OMEN 16 Laptop xd000xx to enable mute led.
it uses ALC245_FIXUP_HP_MUTE_LED_COEFBIT with a slight modification
setting mute_led_coef.off to 0(it was set to 4 i guess
in that function) which i referred to your previous patch disscusion
https://bugzilla.kernel.org/show_bug.cgi?id=214735 .
i am not sure whether i can modify the current working function so i
added another version calling
ALC245_FIXUP_HP_MUTE_LED_V1_COEFBIT. and both works for me.

Tested on 6.13.4-arch1-1 to 6.14.0-arch1-1

Signed-off-by: Sharan Kumar M <sharweshraajan@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250329154105.7618-2-sharweshraajan@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4742,6 +4742,22 @@ static void alc245_fixup_hp_mute_led_coe
 	}
 }
 
+static void alc245_fixup_hp_mute_led_v1_coefbit(struct hda_codec *codec,
+					  const struct hda_fixup *fix,
+					  int action)
+{
+	struct alc_spec *spec = codec->spec;
+
+	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
+		spec->mute_led_polarity = 0;
+		spec->mute_led_coef.idx = 0x0b;
+		spec->mute_led_coef.mask = 1 << 3;
+		spec->mute_led_coef.on = 1 << 3;
+		spec->mute_led_coef.off = 0;
+		snd_hda_gen_add_mute_led_cdev(codec, coef_mute_led_set);
+	}
+}
+
 /* turn on/off mic-mute LED per capture hook by coef bit */
 static int coef_micmute_led_set(struct led_classdev *led_cdev,
 				enum led_brightness brightness)
@@ -7885,6 +7901,7 @@ enum {
 	ALC245_FIXUP_TAS2781_SPI_2,
 	ALC287_FIXUP_YOGA7_14ARB7_I2C,
 	ALC245_FIXUP_HP_MUTE_LED_COEFBIT,
+	ALC245_FIXUP_HP_MUTE_LED_V1_COEFBIT,
 	ALC245_FIXUP_HP_X360_MUTE_LEDS,
 	ALC287_FIXUP_THINKPAD_I2S_SPK,
 	ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD,
@@ -10132,6 +10149,10 @@ static const struct hda_fixup alc269_fix
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc245_fixup_hp_mute_led_coefbit,
 	},
+	[ALC245_FIXUP_HP_MUTE_LED_V1_COEFBIT] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc245_fixup_hp_mute_led_v1_coefbit,
+	},
 	[ALC245_FIXUP_HP_X360_MUTE_LEDS] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc245_fixup_hp_mute_led_coefbit,
@@ -10626,6 +10647,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8b97, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8bb3, "HP Slim OMEN", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8bb4, "HP Slim OMEN", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8bcd, "HP Omen 16-xd0xxx", ALC245_FIXUP_HP_MUTE_LED_V1_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8bdd, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8bde, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8bdf, "HP Envy 15", ALC287_FIXUP_CS35L41_I2C_2),


