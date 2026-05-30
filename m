Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3C131F98D;
	Sat, 30 May 2026 18:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164708; cv=none; b=KTuDHZrOtXJqDKEtkFLBLwzd3llC//euEFfh+Ay3K4hljcpG87xNrMek6OR6nZrX8Mq7StrEJdwXzBIqx+saMnxrBO4sytwjrt9I9qUkBTgsrviJ0D1L8yYADoUTmr2MhT/RFVi6fSTztXuRI8o2YNQYB3FYP0YMAN5toEYwGDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164708; c=relaxed/simple;
	bh=W+a6uX8yfsW1EZJr5ADf7xe3Rp5BVzxAwC9voXKM3/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ql5mvfzQWRWxh5usw+lbwsKv6nY9kfINE90jEY99yOPfj916mEPpHnJGtJfOohfxm+F587eYpFzMF9jLHYIT8BArpIK/cFZ3E7bWtsoh/emqbmvXNtSSp4iWcx5g/OW6Fl8gRuAKHiyYSl3Er9bFLwTMMhV0EG7md4lFfBfCc+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BGe08dGR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BGe08dGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E8E1F00893;
	Sat, 30 May 2026 18:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164707;
	bh=E/ad5hDs0Dy+SVJ7SVVNgvqQo7cnfBAkPp/YF9o9XLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BGe08dGRtVeNJGdRDGgtuADyquQOCcq8bANemjgrwm8BQUJ86+h1L0UgCkcX8NA+m
	 uReMPop6j5fp9Uw9Jcsz63IyRWbF9Q3CNX54t/ljtgm5jWs4CYI2rdnWbUHlplDjLT
	 FImc7lXSdd1+tEeWJq1WsD+JkfCBKOOHm0t9bFVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oldherl Oh <me@oldherl.one>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 636/776] ALSA: hda/conexant: fix some typos
Date: Sat, 30 May 2026 18:05:50 +0200
Message-ID: <20260530160256.396853352@linuxfoundation.org>
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

From: Oldherl Oh <me@oldherl.one>

[ Upstream commit 73253f2fd1d0a44708735c842e37163712e3f03b ]

Fix some typos in patch_conexant.c

Signed-off-by: Oldherl Oh <me@oldherl.one>
Link: https://patch.msgid.link/20240930084132.3373750-1-me@oldherl.one
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: b0e2333a2311 ("ALSA: hda/conexant: Fix missing error check for jack detection")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_conexant.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index e5837e47aa227..394932123b51d 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -166,18 +166,18 @@ static void cxt_init_gpio_led(struct hda_codec *codec)
 
 static void cx_fixup_headset_recog(struct hda_codec *codec)
 {
-	unsigned int mic_persent;
+	unsigned int mic_present;
 
 	/* fix some headset type recognize fail issue, such as EDIFIER headset */
-	/* set micbiasd output current comparator threshold from 66% to 55%. */
+	/* set micbias output current comparator threshold from 66% to 55%. */
 	snd_hda_codec_write(codec, 0x1c, 0, 0x320, 0x010);
-	/* set OFF voltage for DFET from -1.2V to -0.8V, set headset micbias registor
+	/* set OFF voltage for DFET from -1.2V to -0.8V, set headset micbias register
 	 * value adjustment trim from 2.2K ohms to 2.0K ohms.
 	 */
 	snd_hda_codec_write(codec, 0x1c, 0, 0x3b0, 0xe10);
 	/* fix reboot headset type recognize fail issue */
-	mic_persent = snd_hda_codec_read(codec, 0x19, 0, AC_VERB_GET_PIN_SENSE, 0x0);
-	if (mic_persent & AC_PINSENSE_PRESENCE)
+	mic_present = snd_hda_codec_read(codec, 0x19, 0, AC_VERB_GET_PIN_SENSE, 0x0);
+	if (mic_present & AC_PINSENSE_PRESENCE)
 		/* enable headset mic VREF */
 		snd_hda_codec_write(codec, 0x19, 0, AC_VERB_SET_PIN_WIDGET_CONTROL, 0x24);
 	else
@@ -247,9 +247,9 @@ static void cx_update_headset_mic_vref(struct hda_codec *codec, struct hda_jack_
 {
 	unsigned int mic_present;
 
-	/* In cx8070 and sn6140, the node 16 can only be config to headphone or disabled,
-	 * the node 19 can only be config to microphone or disabled.
-	 * Check hp&mic tag to process headset pulgin&plugout.
+	/* In cx8070 and sn6140, the node 16 can only be configured to headphone or disabled,
+	 * the node 19 can only be configured to microphone or disabled.
+	 * Check hp&mic tag to process headset plugin & plugout.
 	 */
 	mic_present = snd_hda_codec_read(codec, 0x19, 0, AC_VERB_GET_PIN_SENSE, 0x0);
 	if (!(mic_present & AC_PINSENSE_PRESENCE)) /* mic plugout */
-- 
2.53.0



