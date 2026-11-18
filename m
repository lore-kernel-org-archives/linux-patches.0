Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058445;
	b=LMvuxt+kHIc7D3L26YD+V2Cd4qkPrxbzqJuCSq1nWwflek+r7K89/W8EcpSwSclcaGqb
	 SPwgNKSaM+2MFin9tNnIocMFrPXJVUkqTEWhIvYe1+WCVBxJ7Qi8R6Lh/wDcZ8RhB+1Dh
	 QRrgGtizu1+gHG2gFw/Pa932LMoPXxvRMXUWtw08WCi/WimwXeL4IMdN2HCN/nYuEqtcK
	 cjIKwF6gCdBGInsUQ9OBEHfPcekbY4OIduj8xUDFSFdHqaEh4tEgkriLWyVhejCp+OMjZ
	 geKc2VbO/RwFrWGDy52JMLsyMvvnNYhcsW/uadmJhkYVZcQ+/d1gPbRrysnHDLguQdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lQO5R2D2d5gBs2mdQ7Qfrwrwa+aizFgO/5T23dgUgFQ=;
	b=RzV6dFRAg/mqUs+DWceDRU9i6a/C6eOP5UI/JawP2MeUifv/rTmfMfmi+vT7af21HJbq
	 DgnUGNfzriU1CPl1ttftSf9Yry1JL4k8pJeWvOqp81wdYvrVH9NXYjCLSt6NlXueuOwTq
	 GY1xDjyc9RNDPKNb/ccx/p98j/EUo/Je2pr2AhpSoUwjdZI5/KfnlMZFhK9ttf0Fnrt8X
	 koitfWAkPME5UJ+/HJp+SlHmOtRlyUO16N7XNoiB2kz8sgzlIOaJ7hcolyGFlxHLRv/tj
	 jUYdnUrf0L+syoquOljPXICiBiAUFBkxxioEUOpxRiZXMj7g+Pn4wleJiBZSHISWkTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W9TLixJi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC75606A31C;
	Thu, 19 Nov 2026 03:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W9TLixJi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62411F000C4;
	Thu, 19 Nov 2026 03:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058445;
	bh=lQO5R2D2d5gBs2mdQ7Qfrwrwa+aizFgO/5T23dgUgFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W9TLixJi3GCOiVCQw/4gGytV9GBWNUeFs2PEbUmstnb5HVmiXnCkLtIzarhy+1cbs
	 QpHAzKJbHIMsU5Z74FOghQ/FZhrEY9Hfx670aYn9HpblQikmUj1e2m+jeJBbXZ1OjE
	 FevVxRCXMmDsW8+ItapgdJgG7ns86ICjTORc7PrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0446/1848] ALSA: sgio2audio: Only free successfully requested IRQs
Date: Wed, 18 Nov 2026 15:41:24 +0100
Message-ID: <20261118145933.009994449@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5bf1ea150f264..e29887be686bf 100644
--- a/sound/mips/sgio2audio.c
+++ b/sound/mips/sgio2audio.c
@@ -752,7 +752,8 @@ static struct {
 
 /* ALSA driver */
 
-static int snd_sgio2audio_free(struct snd_sgio2audio *chip)
+static int snd_sgio2audio_free(struct snd_sgio2audio *chip,
+			       unsigned int irq_count)
 {
 	int i;
 
@@ -762,7 +763,7 @@ static int snd_sgio2audio_free(struct snd_sgio2audio *chip)
 	writeq(0, &mace->perif.audio.control);
 
 	/* release IRQ's */
-	for (i = 0; i < ARRAY_SIZE(snd_sgio2_isr_table); i++)
+	for (i = 0; i < irq_count; i++)
 		free_irq(snd_sgio2_isr_table[i].irq,
 			 &chip->channel[snd_sgio2_isr_table[i].idx]);
 
@@ -778,7 +779,7 @@ static int snd_sgio2audio_dev_free(struct snd_device *device)
 {
 	struct snd_sgio2audio *chip = device->device_data;
 
-	return snd_sgio2audio_free(chip);
+	return snd_sgio2audio_free(chip, ARRAY_SIZE(snd_sgio2_isr_table));
 }
 
 static const struct snd_device_ops ops = {
@@ -829,7 +830,7 @@ static int snd_sgio2audio_create(struct snd_card *card,
 				0,
 				snd_sgio2_isr_table[i].desc,
 				&chip->channel[snd_sgio2_isr_table[i].idx])) {
-			snd_sgio2audio_free(chip);
+			snd_sgio2audio_free(chip, i);
 			printk(KERN_ERR "sgio2audio: cannot allocate irq %d\n",
 			       snd_sgio2_isr_table[i].irq);
 			return -EBUSY;
@@ -853,13 +854,13 @@ static int snd_sgio2audio_create(struct snd_card *card,
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



