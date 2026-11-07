Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063042;
	b=AMkWefjYw7APSJVlWNEvHGZWRe3poEBbMjZM4DgW7qPsfAueuFweB4K1WaAqA+5sPStK
	 TF4Y13n7r8CXM33gi7Pp5OT9fsg4ifmsJtoeKDVHpFHUXpQEsJVEWUbOavkXDBVrxeTLJ
	 DIY7ixQh1rMdB8/6CQu7DCDGEyEDJD/+zpif9tCJAzkQIGMV4grlzLYyM6ySnzFV9Vl85
	 NXejlzEZs3YQ46OOXlgKrH7RgY8jPOc8k/hrJ+gfUaAhLm+vpBBF8PO6oR4LqqGBB+Igj
	 LbAat1Dw7CeV3OzNFxvo/CglxVV94+SfNWkcqgoQ3hLjTrdkViksQ0ztDY5Fm51hvGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B4+3flQhngaf6/GbsHnNByUWAT+DlpN2Pm/BYCZqgjY=;
	b=g8CqmHMSo05bEJCbfDdT0b1g6OrAk1ZdMYpsTzhOKRmeBq5lf7wxV19LW8aIYAqFJAKx
	 qY84M8/51P8bzsAacX/sBDx1Ni5vZVud/p8IBMfn2rYadHrecHsnWWzCmYGO6clwknhzz
	 vsB+b1nMOG5VKUnWRV4UnybLoFEJhaGlrSSAzLAt6zuPvJ+1GURqPJF4Z4FIPDxooN9A4
	 VturK/AsxBLfLWa0dS3i/yocthaKBGpRQjzaU8koeBoz5LECcEMtHSOqOsmFjNPxsXnWQ
	 s0q8Xd4AtYVCntPu9tEHsoyCmJaoXMbYNICgbJL6d2Z7YByRWsGLC0iG3mabqxGM2pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="lWeY/DFc";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4A5606D805;
	Sat,  7 Nov 2026 14:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lWeY/DFc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565BA1F008A1;
	Sat,  7 Nov 2026 14:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063042;
	bh=B4+3flQhngaf6/GbsHnNByUWAT+DlpN2Pm/BYCZqgjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lWeY/DFcdRB/QFp8r6ZwHu6irol/NFYX7yFM+45DcYOGBzPmj5Xz9Hs60M+v5JMBi
	 FDQCZ3Q4/RtP7bFmOIA1Qs1OfZf6Yy2nkreHOmCa5Jz1CxRJNwCH0loTbbwuJwz4tp
	 kuf65S3Q0BD4PzC/4cptyEZ/L9ER+cj9D0G6y9fI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 289/869] ALSA: sgio2audio: Only free successfully requested IRQs
Date: Sat,  7 Nov 2026 08:49:31 -0500
Message-ID: <20261107134901.640756599@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 077fdf2181c15..e3480f23f7f3c 100644
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



