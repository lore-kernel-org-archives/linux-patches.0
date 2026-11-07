Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064273;
	b=k/e/Ta72ZN9LtZD9HuJZeiwlJ9CCpvgdjU5Tb+fiJWYjDkpGB/BtehqO6V9WUTzaCduL
	 RYJyzCl6KaRvG+6S3GYRgJdCohEUAXMGs4shPRVMU84ofCyKcCPwMWNWjprvNUZr5c3jV
	 YSZhNvARrOOmiTRZ+Ja8y5H92eKNSt2X/aejxKrt2nxeICXVbB8TJzNGdCL3QzwfmX5K2
	 /pj4C5KPNO1nfx31/hM/UTWtDogI20nNmb8kCgib1wP/xl+wkMTDpF2GEHFoQ3KgkeWJ3
	 Xas+ctj76RPDb6RyPrYZdcCqLnghNPiuMHk/pUk2nhFWMfIOnl7qMaBkGxTJuBgDx1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064273;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4dEl7wKfZvxclUkia0UWSYTBge/cuNnX5/qlzkWJ9cM=;
	b=ca7A2OXs0n75MZCmtaiwkgfNBJE3p/kDIVqsQrpl+geJDDTvQzyeZA2Tru2BA9hwAcoz
	 nuikx4O7u4rKvMgO83rKmQC4Zp0iRAqgm4VJj4ltj0+u3KBXwBkp8XliwaRPwlFJnKr+Y
	 efrDfHGcJ4aOJa6kKD6tUiFItZXWEScZXMCDwqOf72qukpUfNvS8jfspRxBgdNJe23niU
	 Hjqp5xfcMRF6pNyoSx3aCUq/3/LqOyO/ZcIVM4NG+HggDbLYOHfx5feUDP0SAvTcSbfAo
	 dhHGuhqm3kGgXn+qQi5Rylm8RbpF5MnAb/wzjTizpOE8/0usRwjh9z3NL3vDAxpXOYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fAUh4l5g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B343606A334;
	Sat,  7 Nov 2026 15:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fAUh4l5g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8CF1F0089F;
	Sat,  7 Nov 2026 15:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064273;
	bh=4dEl7wKfZvxclUkia0UWSYTBge/cuNnX5/qlzkWJ9cM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fAUh4l5gPCWkbyN+0Au/Jy7pCl5CHuaWETeQd1iFUrL7ZsKny+AYAHSdnkl+bXpbL
	 ZiqHYrG1yYCu0GI5IzgJWQUfvuKEpXIKT5re1yUlaX/rzWLUgOCd5b/3WnWFD6UJGs
	 O/XVztamWqLqJvuGAz0lzuqf+FW0U3xvkDgKj5HM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0369/1257] ALSA: sgio2audio: Only free successfully requested IRQs
Date: Sat,  7 Nov 2026 08:44:25 -0500
Message-ID: <20261107134949.756388560@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 497d84cff12f3..35648b0b97b90 100644
--- a/sound/mips/sgio2audio.c
+++ b/sound/mips/sgio2audio.c
@@ -742,7 +742,8 @@ static struct {
 
 /* ALSA driver */
 
-static int snd_sgio2audio_free(struct snd_sgio2audio *chip)
+static int snd_sgio2audio_free(struct snd_sgio2audio *chip,
+			       unsigned int irq_count)
 {
 	int i;
 
@@ -752,7 +753,7 @@ static int snd_sgio2audio_free(struct snd_sgio2audio *chip)
 	writeq(0, &mace->perif.audio.control);
 
 	/* release IRQ's */
-	for (i = 0; i < ARRAY_SIZE(snd_sgio2_isr_table); i++)
+	for (i = 0; i < irq_count; i++)
 		free_irq(snd_sgio2_isr_table[i].irq,
 			 &chip->channel[snd_sgio2_isr_table[i].idx]);
 
@@ -768,7 +769,7 @@ static int snd_sgio2audio_dev_free(struct snd_device *device)
 {
 	struct snd_sgio2audio *chip = device->device_data;
 
-	return snd_sgio2audio_free(chip);
+	return snd_sgio2audio_free(chip, ARRAY_SIZE(snd_sgio2_isr_table));
 }
 
 static const struct snd_device_ops ops = {
@@ -819,7 +820,7 @@ static int snd_sgio2audio_create(struct snd_card *card,
 				0,
 				snd_sgio2_isr_table[i].desc,
 				&chip->channel[snd_sgio2_isr_table[i].idx])) {
-			snd_sgio2audio_free(chip);
+			snd_sgio2audio_free(chip, i);
 			printk(KERN_ERR "sgio2audio: cannot allocate irq %d\n",
 			       snd_sgio2_isr_table[i].irq);
 			return -EBUSY;
@@ -843,13 +844,13 @@ static int snd_sgio2audio_create(struct snd_card *card,
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



