Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB90362143;
	Wed, 20 May 2026 16:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295496; cv=none; b=QAqd6JBdZXnYfKxy1WAg/yOlr1T4hWinfX4yTEVGpLTEkBqtmwx2J3TQaPZybc4Eo56hL6BSBZSGGUZzGp+AXELCQL69b1T+r7ApVoQWAARKNkxzzNLg99KVy/f/BD4AFb9ebJtU6D/8GzsBOz3ubmZMe2IrIuya6Zwt0PIlbDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295496; c=relaxed/simple;
	bh=yMm0f0CcqQ7zdzxDUfUoVLW/5gVlZbWa0LaFRG4fHP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfh16FUPIDYn144QFBfLrD0WwrPJ+G9mYLQUHCO6Hjbl6FjKUyVRRMKP8Qaq3O9vAMOaMeST1qUUPr9ikd9hg9XGkMtwpX7LAbD1dTHKP2iv0QYp0RJ6mD8FOPcaGVTCkAZbC5pr3YMccL76shPENs9Jvv4vFLZFq6LwnJz2sfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qavqq+Oq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qavqq+Oq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C469D1F000E9;
	Wed, 20 May 2026 16:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295495;
	bh=nzTnR8EYHZi5GRcG27SVx3/rcvAxIvhJmfAuFU4Te6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qavqq+Oq0syD1LsWJiB0NtKGRmvmnzTZ+FrKoNtpOH6AhqYAkBzw4I6je4csPKagW
	 nrnwgIPhEn+ctO6sUCirC2S/ahJE1wNyplHkk5TpCgQsOcr3rQlZz/T3VOe2Mkif56
	 rBSnH823hasUzvagWNatMeBbaL7DhmlrL58vrx2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	Jeremy Bethmont <jeremy.bethmont@gmail.com>
Subject: [PATCH 7.0 0442/1146] ALSA: hda/realtek - fixed speaker no sound update
Date: Wed, 20 May 2026 18:11:32 +0200
Message-ID: <20260520162158.201449940@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

[ Upstream commit 46c862f5419e0a86b60b9f9558d247f6084c99f9 ]

Fixed speaker has pop noise on Lenovo Thinkpad X11 Carbon Gen 12.

Fixes: 630fbc6e870e ("ALSA: hda/realtek - fixed speaker no sound")
Reported-and-tested-by: Jeremy Bethmont <jeremy.bethmont@gmail.com>
Closes: https://lore.kernel.org/CAC88DfsHrhyhy0Pn1O-z9egBvMYu=6NYgcvcC6KCgwh_-Ldkxg@mail.gmail.com
Signed-off-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index cbc24d71a1115..d8698c20a3cae 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3674,22 +3674,11 @@ static void alc287_alc1318_playback_pcm_hook(struct hda_pcm_stream *hinfo,
 				   struct snd_pcm_substream *substream,
 				   int action)
 {
-	static const struct coef_fw dis_coefs[] = {
-		WRITE_COEF(0x24, 0x0013), WRITE_COEF(0x25, 0x0000), WRITE_COEF(0x26, 0xC203),
-		WRITE_COEF(0x28, 0x0004), WRITE_COEF(0x29, 0xb023),
-	}; /* Disable AMP silence detection */
-	static const struct coef_fw en_coefs[] = {
-		WRITE_COEF(0x24, 0x0013), WRITE_COEF(0x25, 0x0000), WRITE_COEF(0x26, 0xC203),
-		WRITE_COEF(0x28, 0x0084), WRITE_COEF(0x29, 0xb023),
-	}; /* Enable AMP silence detection */
-
 	switch (action) {
 	case HDA_GEN_PCM_ACT_OPEN:
-		alc_process_coef_fw(codec, dis_coefs);
 		alc_write_coefex_idx(codec, 0x5a, 0x00, 0x954f); /* write gpio3 to high */
 		break;
 	case HDA_GEN_PCM_ACT_CLOSE:
-		alc_process_coef_fw(codec, en_coefs);
 		alc_write_coefex_idx(codec, 0x5a, 0x00, 0x554f); /* write gpio3 as default value */
 		break;
 	}
@@ -3712,10 +3701,15 @@ static void alc287_fixup_lenovo_thinkpad_with_alc1318(struct hda_codec *codec,
 		WRITE_COEF(0x24, 0x0013), WRITE_COEF(0x25, 0x0000), WRITE_COEF(0x26, 0xC301),
 		WRITE_COEF(0x28, 0x0001), WRITE_COEF(0x29, 0xb023),
 	};
+	static const struct coef_fw dis_coefs[] = {
+		WRITE_COEF(0x24, 0x0013), WRITE_COEF(0x25, 0x0000), WRITE_COEF(0x26, 0xC203),
+		WRITE_COEF(0x28, 0x0004), WRITE_COEF(0x29, 0xb023),
+	}; /* Disable AMP silence detection */
 
 	if (action != HDA_FIXUP_ACT_PRE_PROBE)
 		return;
 	alc_update_coef_idx(codec, 0x10, 1<<11, 1<<11);
+	alc_process_coef_fw(codec, dis_coefs);
 	alc_process_coef_fw(codec, coefs);
 	spec->power_hook = alc287_s4_power_gpio3_default;
 	spec->gen.pcm_playback_hook = alc287_alc1318_playback_pcm_hook;
-- 
2.53.0



