Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30270175A6B;
	Sat, 30 May 2026 18:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164712; cv=none; b=WqtjLaxGynVZwL7lgWMKnNC8tZeVrsZl5HymfLLT8pSiUxWaubUJWHRgV8PjnL7EnIvzprZv/JrmLRFqf+7bDr1J9cd85WrwJ1li3mmRA1otGen806b3P4syOjzfLYQJx6egL+WzJTqJvD+HLJGp6m4oJzbNcqUj1mdIEn3rGO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164712; c=relaxed/simple;
	bh=U4TTpc84OLmTlELeqUIdSu0YAybjaDhiZJ6ENJDJKnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cj4tWP0+9u4WCHpQ+Almy28PCkPkLkPXeWeV6nLP8drMCxWLmNzbDL+pbKPVFcVTi4z4ZdyWx15YXMmFAbZSPqWcDZRxBgKvyeSIX+S7urwWoJphsnCEdsNTXKzCsXzbjffelo/Q/nJQmX+1gC5uMOeqGUiCfwRZZBIZDt7Vu7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SI6unTUZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SI6unTUZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 742281F00893;
	Sat, 30 May 2026 18:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164711;
	bh=8hC6fhg3BmQkO1/hKAEL5fl0/wBIQ26MQoLZWv1xo80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SI6unTUZFZSEr/ehihuAM5JriGdW4kBW8NhErGu8+mmW5DwuRpi2TIqY8FOVf49wH
	 zo5m1FeEpDJZOlyBTVs3DihQQpXieiYD40c5tLXzt/6jFyB26NQrazg0/c+Wa/Jh7x
	 YiqLWiIhVUgyWQJoc1ZkFjngy4j1kHm5ggYaoklw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 637/776] ALSA: hda/conexant: Renaming the codec with device ID 0x1f86 and 0x1f87
Date: Sat, 30 May 2026 18:05:51 +0200
Message-ID: <20260530160256.421897110@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



