Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045247;
	b=r/f90ZzlQK6bmFbXiJkKJFgS3Nwh/VXRq3TFeIXpT4asODb3w0bQ56RuyllPwM8SShGb
	 ceTm51Nigj/jypCSVzaOO48wHJQS9rfr3jsKG9KlHnfWNH5ueCPtBI5b8vMtQBKFvfqCG
	 pe322WpCdpkN3ktmKmR8/DFlXOs/gvglbviJx0Eq538wC2TbhsUApXkvuW4lcf9hlRhhu
	 80SihQEcPHpXjjJHJhP1qAs5nqReUtnxV/XzEG1HgEGzkm3VczGGW5Yp7+IjaC+3FFQEq
	 Rqv/BT7mGHVsiHYD00gOgj1v2vPhLa3uQPG5e5aYcjm785vWpG8DuQW4U8Fxgk8rngQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045247;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nREUwKt+dz0DHIDr60jHNAV3kiillSJS4biqGAMSTuc=;
	b=XsPUEe5xWYXozmT6lAiCCC1RYHLfxC+FIO/ur44/CMQnEB5X72qoGtaMZyMjbPYAM0uH
	 JpJbemTSxAzbMWaV+MtihDNtWuaydsd9Vu/jXdKGBuBJqJwzcpnaD3AbO8r4azOHWjBuT
	 rgC4nxj+rAExcfuNsjjv02447GfDoPXTElImMcgOxWQXfRKQMAALmBRtKjufTDPdKiWCf
	 jxKTGAqc9QWPiuTCnuh/OQo4TwApvEU6lMuKS04AmZim2V+Ad+3CFfS1rs7fCEdNg45uz
	 8LoveZyGJYmKaSjtyltmGDUzsFeHLD/TdpcVFvdqhfzssQ4boxsGb4tvc731gyDVW+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FGLPHf0o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DED2606A31C;
	Wed, 18 Nov 2026 23:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FGLPHf0o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA83F1F000C4;
	Wed, 18 Nov 2026 23:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045247;
	bh=nREUwKt+dz0DHIDr60jHNAV3kiillSJS4biqGAMSTuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FGLPHf0oOFG7rJhb8wXULK/Tvg1RgfHZd1fX0YqvPEwQyTm7mAHy4CeZgq2GF9BZW
	 42/I2wfFAGi2kjGroUlQVP4UORyJDDmdCUPbIcuGN8m8H1ToWCfjsYpLTKEqX3W0pG
	 kCLdh0q6/yO3x4n+s+ERA+RTfco0uFDPYpeTBSO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0838/2857] ALSA: sgio2audio: Only free successfully requested IRQs
Date: Wed, 18 Nov 2026 15:31:12 +0100
Message-ID: <20261118150231.747157441@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit af3d225b639c6f9fb8fd5e1e27f11672d56724b6 ]

snd_sgio2audio_create() calls snd_sgio2audio_free() when an IRQ
request fails. The cleanup helper currently walks the complete IRQ table,
including entries whose request_irq() calls have not been attempted yet.
free_irq() then receives an IRQ and dev_id pair that was never registered.

Pass the number of successfully requested IRQs to the cleanup helper on
the request failure path, while retaining the full-table cleanup for
teardown after all requests have succeeded.

Fixes: 862c2c0a61c5 ("ALSA: ALSA driver for SGI O2 audio board")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260929084540.2065213-1-runyu.xiao@seu.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/mips/sgio2audio.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/sound/mips/sgio2audio.c b/sound/mips/sgio2audio.c
index 989f656e2de7d..5bcfe8516f22b 100644
--- a/sound/mips/sgio2audio.c
+++ b/sound/mips/sgio2audio.c
@@ -751,7 +751,8 @@ static struct {
 
 /* ALSA driver */
 
-static int snd_sgio2audio_free(struct snd_sgio2audio *chip)
+static int snd_sgio2audio_free(struct snd_sgio2audio *chip,
+			       unsigned int irq_count)
 {
 	int i;
 
@@ -761,7 +762,7 @@ static int snd_sgio2audio_free(struct snd_sgio2audio *chip)
 	writeq(0, &mace->perif.audio.control);
 
 	/* release IRQ's */
-	for (i = 0; i < ARRAY_SIZE(snd_sgio2_isr_table); i++)
+	for (i = 0; i < irq_count; i++)
 		free_irq(snd_sgio2_isr_table[i].irq,
 			 &chip->channel[snd_sgio2_isr_table[i].idx]);
 
@@ -777,7 +778,7 @@ static int snd_sgio2audio_dev_free(struct snd_device *device)
 {
 	struct snd_sgio2audio *chip = device->device_data;
 
-	return snd_sgio2audio_free(chip);
+	return snd_sgio2audio_free(chip, ARRAY_SIZE(snd_sgio2_isr_table));
 }
 
 static const struct snd_device_ops ops = {
@@ -828,7 +829,7 @@ static int snd_sgio2audio_create(struct snd_card *card,
 				0,
 				snd_sgio2_isr_table[i].desc,
 				&chip->channel[snd_sgio2_isr_table[i].idx])) {
-			snd_sgio2audio_free(chip);
+			snd_sgio2audio_free(chip, i);
 			printk(KERN_ERR "sgio2audio: cannot allocate irq %d\n",
 			       snd_sgio2_isr_table[i].irq);
 			return -EBUSY;
@@ -852,13 +853,13 @@ static int snd_sgio2audio_create(struct snd_card *card,
 	/* initialize the AD1843 codec */
 	err = ad1843_init(&chip->ad1843);
 	if (err < 0) {
-		snd_sgio2audio_free(chip);
+		snd_sgio2audio_free(chip, ARRAY_SIZE(snd_sgio2_isr_table));
 		return err;
 	}
 
 	err = snd_device_new(card, SNDRV_DEV_LOWLEVEL, chip, &ops);
 	if (err < 0) {
-		snd_sgio2audio_free(chip);
+		snd_sgio2audio_free(chip, ARRAY_SIZE(snd_sgio2_isr_table));
 		return err;
 	}
 	*rchip = chip;
-- 
2.53.0



