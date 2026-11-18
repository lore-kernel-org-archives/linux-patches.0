Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020121;
	b=V06UozIrpT3ECMbYSCFxKe3AWphkF2gO5CsSrtJP3CI2jxUiFsMOzavCLbcYK4hFUVrs
	 CfT7HbLRDGTLrlgPtPWDqnznn+PGyhcSLWpOTSkEZ5KJR9u5VgeUgFHzYPuhdItpXJpZu
	 /RY9kEVJrHPAH8Z5K+6sMhwn4A+HqZiK2LFpu9qSqTPdGjggtpfoB1Bi6DYR1TOKorq4q
	 H37DnY2Ub0AwljGwr9Lz8wu9/RXfoD/+VAE4UKXXSkRR1uBmNhKKcKoqX2tcC/FJ1eCsk
	 eYw5GODYuTFlVX/xh5dX88gd5wiaDTQf1HijSF1U4I6N8/xiXN58GfyaIGMXPSY0pPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020121;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yrQqPSQPu38Ytiq5FBfqNH8DJTlXYiIPU+rf9ehRDoU=;
	b=PmHBgjFbdODe58TRr2Nv4huNf0eZY05AJvzIPDBW6nT22FCNCGZtQ+RhmijHTRJL9qhB
	 6kbk/AxY7hAsZoMRjpF2WmdvSc6B2W8icvw7Hss3gZJISicUzU3p/A7v7g1I71MLc+Vf0
	 bd3B1pozxN/hZyYVfupNaH5SKQUnMVYbBqz/zWPyPKIrHsVlH22wL04Me6ukezIrMocJ5
	 BpK2HBxGTXipF2LroGZLGVI0yZ/iN+fnzBzZz5qyRsLrh4MsqVDYvBInOMPrGHzTX2AjN
	 DIg34YdV98OjijrNlbgPvemUhgDNmOhQnKEBEYQSNHT/gr69Wg8hCHWMwqFtI6YgITg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NA0d8IVk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6343D606A331;
	Wed, 18 Nov 2026 16:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NA0d8IVk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17821F000C4;
	Wed, 18 Nov 2026 16:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020121;
	bh=yrQqPSQPu38Ytiq5FBfqNH8DJTlXYiIPU+rf9ehRDoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NA0d8IVkceEy0eHjIVX0LxPnwZu+PWlkZIsB9AeNKngKKCXAyZik+3jQtqyvgeuvR
	 v37gr8yArsOE0RQ4D5I6gsIksHxihVbUBsp1L0ophynfxKZVhioLxT/37TnqM/87NQ
	 HPbZNb+oW75muDGfPkoQBJIbuGjLxdnMqrcnBvlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1788/2651] ASoC: atmel-i2s: fix MCK generator error handling
Date: Wed, 18 Nov 2026 15:50:28 +0100
Message-ID: <20261118150351.709324930@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 2e2da92de9bffd2cdbb9a2558fe60de7f1bb09e3 ]

Disable the gclk and reset the MCK configuration when an error occurs
while enabling the MCK generator.

This prevents the gclk from remaining enabled after a failed clock
configuration.

Fixes: 73ad0df57290 ("ASoC: atmel-i2s: Remove unnecessary audio PLL clock (aclk)")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261002043856.97295-2-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/atmel-i2s.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/sound/soc/atmel/atmel-i2s.c b/sound/soc/atmel/atmel-i2s.c
index d9ad262ec44de..f28808d980ce6 100644
--- a/sound/soc/atmel/atmel-i2s.c
+++ b/sound/soc/atmel/atmel-i2s.c
@@ -466,11 +466,21 @@ static int atmel_i2s_switch_mck_generator(struct atmel_i2s_dev *dev,
 	mr |= ATMEL_I2SC_MR_IMCKMODE_I2SMCK;
 	ret = regmap_update_bits(dev->regmap, ATMEL_I2SC_MR, mr_mask, mr);
 	if (ret)
-		return ret;
+		goto err_disable_gclk;
 
 	/* Finally enable the I2S Master Clock generator. */
-	return regmap_write(dev->regmap, ATMEL_I2SC_CR,
-			    ATMEL_I2SC_CR_CKEN);
+	ret = regmap_write(dev->regmap, ATMEL_I2SC_CR, ATMEL_I2SC_CR_CKEN);
+	if (ret)
+		goto err_reset_mr;
+
+	return 0;
+
+err_reset_mr:
+	regmap_update_bits(dev->regmap, ATMEL_I2SC_MR, mr_mask, 0);
+err_disable_gclk:
+	clk_disable_unprepare(dev->gclk);
+
+	return ret;
 }
 
 static int atmel_i2s_trigger(struct snd_pcm_substream *substream, int cmd,
-- 
2.53.0



