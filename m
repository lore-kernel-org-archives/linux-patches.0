Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1675D400E0E;
	Wed, 20 May 2026 18:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302842; cv=none; b=BVJGUvjhAFBIdnZSUaG8axf94d1NtL0JhY2eE6gYiFrWP9nweJ0ETFoGIuN7GWCeJ8Wh7yr0z0e7lK9wZc2VHQ19PWHcqv6i7xM4q6wtrGA7CTLMWcHmbakOWLXZPkDRSGmQF2Uj3L7Yf7u84vK8g7V99x7rpxSnt++KVaNnX/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302842; c=relaxed/simple;
	bh=zxy0wanKzRcTktfoaTDKdqdeNWW8PFF7D2QEKMdkYjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DUISGrgsERAikjFUl7nWLHR7l5Er7iPLj7hjpKn7+2lei5yD4+aYb4NZnZCrPXZN8rb7eNOqkYbrWQWMBbOjjdZI1GBasbRzzB5iwTGCUACSGV5c3EdNzPYBrWxMYp79Frw0ic3cb0+FxxQAlk+tOhYc6/CxTKIc9r7S436Z9WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v2iM7tBu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v2iM7tBu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B9B1F000E9;
	Wed, 20 May 2026 18:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302840;
	bh=0+PLjhvBE+VW0R6h2JhoAkAdTgLhDu3bNuVmaRt2CsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v2iM7tBuKtsn23PReS2gpHgZqMBvNLfAep1fb0dSS/zh24mO73HdB/7/Eiw8XvMtr
	 CGmMtUzDFUqAqfq47z1P2qSiTQUPjE+IzuAFLL0MLklUkOBMxld8zsVtxjGKwHX8GJ
	 gQ1IHpkREqhZTjKT9HUuv3K+E3jYTnvJCtOvPw6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oldherl Oh <me@oldherl.one>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 419/508] ALSA: hda/conexant: fix some typos
Date: Wed, 20 May 2026 18:24:02 +0200
Message-ID: <20260520162107.685598785@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 355b26583eb4e..08e2c836fd07e 100644
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



