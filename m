Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7333ACEEA;
	Sat, 30 May 2026 17:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161941; cv=none; b=Rt59N3sYDq9mqlCvxr0vjWMDRvmuncL8l8lR7cHYwmo192guvNU3s5pLXlaarWn+TzMfdF4X4CRbD8u84YOlKQ/FRXnksKMNVbsIDcYpR4bQqqDkIEByZI86+4zs0cWuNk2ENDWgp+6ZL5HYDWTDLiPnolM8oUDhDsib3Bk8Yrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161941; c=relaxed/simple;
	bh=USePpIzmNBtnY/ihBJLxqD8s9i+i5gD0SgObkk6y+Q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptPotMWqivxImbMzAGL0GF220IE16cYJWMxofZNNO7Qj9zGpn+/z3y/T0aUsK2LJ52cAqHRR9q1Wu5Kjom3nOzBTTOHhXmDjVauoetcYcKjrwMqX2PAd1/P8397H+BhNSTYpvD7+nDeGSmvFfsnzUnNNwneIjwQiG4+OQZ2wFoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jI46h5jM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jI46h5jM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C051F00893;
	Sat, 30 May 2026 17:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161938;
	bh=mnEdN45WTgN/laSDiuIFq3YRIfb33lrRbTSmCNMPnXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jI46h5jMz7VMuyPTkZmmugII7wQQTlZBbJopZYVnZBlr+ihGMHr6BN781y1Li5cZl
	 jpbUX3o2I3wBO927XAJi+/Ovqj/tuWFoNliExJwFzh+n8Q239yXTH1y0nESMGQLjNq
	 GwHDUfokU1MutTg6uM7gcwXDJDtEO8kZ+YJay0Xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 773/969] ALSA: hda/conexant: Renaming the codec with device ID 0x1f86 and 0x1f87
Date: Sat, 30 May 2026 18:04:57 +0200
Message-ID: <20260530160321.929171881@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wangdicheng <wangdicheng@kylinos.cn>

[ Upstream commit 7f4c540e0859e2025675d2c5c5c6ab88eaf817e2 ]

Due to changes in the manufacturer's plan, all 0x14f11f86 will be
named CX11880, and 0x14f11f87 will be named SN6140

Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
Link: https://patch.msgid.link/20250616074331.581309-1-wangdich9700@163.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: b0e2333a2311 ("ALSA: hda/conexant: Fix missing error check for jack detection")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_conexant.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 394932123b51d..7aeaccc9189c8 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -42,7 +42,7 @@ struct conexant_spec {
 	unsigned int gpio_led;
 	unsigned int gpio_mute_led_mask;
 	unsigned int gpio_mic_led_mask;
-	bool is_cx8070_sn6140;
+	bool is_cx11880_sn6140;
 };
 
 
@@ -195,7 +195,7 @@ static int cx_auto_init(struct hda_codec *codec)
 	cxt_init_gpio_led(codec);
 	snd_hda_apply_fixup(codec, HDA_FIXUP_ACT_INIT);
 
-	if (spec->is_cx8070_sn6140)
+	if (spec->is_cx11880_sn6140)
 		cx_fixup_headset_recog(codec);
 
 	return 0;
@@ -247,7 +247,7 @@ static void cx_update_headset_mic_vref(struct hda_codec *codec, struct hda_jack_
 {
 	unsigned int mic_present;
 
-	/* In cx8070 and sn6140, the node 16 can only be configured to headphone or disabled,
+	/* In cx11880 and sn6140, the node 16 can only be configured to headphone or disabled,
 	 * the node 19 can only be configured to microphone or disabled.
 	 * Check hp&mic tag to process headset plugin & plugout.
 	 */
@@ -1210,11 +1210,11 @@ static int patch_conexant_auto(struct hda_codec *codec)
 	codec->spec = spec;
 	codec->patch_ops = cx_auto_patch_ops;
 
-	/* init cx8070/sn6140 flag and reset headset_present_flag */
+	/* init cx11880/sn6140 flag and reset headset_present_flag */
 	switch (codec->core.vendor_id) {
 	case 0x14f11f86:
 	case 0x14f11f87:
-		spec->is_cx8070_sn6140 = true;
+		spec->is_cx11880_sn6140 = true;
 		snd_hda_jack_detect_enable_callback(codec, 0x19, cx_update_headset_mic_vref);
 		break;
 	}
@@ -1302,7 +1302,7 @@ static int patch_conexant_auto(struct hda_codec *codec)
  */
 
 static const struct hda_device_id snd_hda_id_conexant[] = {
-	HDA_CODEC_ENTRY(0x14f11f86, "CX8070", patch_conexant_auto),
+	HDA_CODEC_ENTRY(0x14f11f86, "CX11880", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f11f87, "SN6140", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f12008, "CX8200", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f120d0, "CX11970", patch_conexant_auto),
-- 
2.53.0



