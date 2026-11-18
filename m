Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049707;
	b=IId72s8mJ49cYYGngTdQdUUMd9DNB8vKO7Xc2WRZkWTTfZ0/OKA3yHLT7TDjaqgk8Lim
	 KnuRAEtE2sG4Ob5FsD+gRtSMLjTRSH4nJjUFjGMvQBm9VrLnp/wlum8RFzl5jJDU3SkDm
	 TNFaF810YZp8A72OlbPMYAPWkpmc3/VHMVrNz57gi1D968TMHB1sg6YWmUcCM6jQlR/8/
	 qYo31GZrYrJg9SE2XxCvdv/VYZRy7dazsXag20rSeFPVwfNAPJbFqIRugiTliK7OJmoJ2
	 RXg12ItoL6Jnbs/JmLgjYKvvT9siDOY0FUl/zeaBpRfCOdN85+zplEI+ULOCPFtzdTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049707;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O1Sh5sJFhAMPymQ+D265FuC7xRtAnr4czWyES59oI9Y=;
	b=J+fLB2pX1tMZPq/BPx/F2aH3ygEQwiNGHtg2wqBz1TQlW1Q0jH87PUNPKLH3at/BErgv
	 YzdPPYK7nzEgNrJoyOaJfB+YFAwGA6Rx4Aan6Sxi1mBGx9luBszmafdNnNwvnpWAKaQ//
	 Ad2nlw6XZMeLegerHx7fWKa5IbjdADmX0MiS6N3VKi8d03yFsVp5X5DK24gHtyigT1SPJ
	 cSA+LK6JtjqmHg5XtaMOUvH3Y4Tvr8VcrD1hhnSIJzyo/LosaZMurvwo75rzT+7SBcDOa
	 FBRf9svcvE4c/87Vqh1STiN4Ue8P2iJJjx/pS4VjkWPnaSUgKeiB4Nrx2stMrmliNiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IUr0O1Qt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE449606A325;
	Thu, 19 Nov 2026 00:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IUr0O1Qt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41BCF1F000C4;
	Thu, 19 Nov 2026 00:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049707;
	bh=O1Sh5sJFhAMPymQ+D265FuC7xRtAnr4czWyES59oI9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IUr0O1QtaS631oloxPiuXwGnHhybLX0Zt9kiV+fcGaFaFt2MgjvKAbF7/dKDu18wu
	 k7s+7WT9UB4qmwHRNrqm1Gh24l9S/ONeQNnbe7Hng12we+QeXRB+rr1+qhvplQCGbo
	 D9aDpfm1uYT9FdzVKc0e46QY6AZJO4PqRudO/z0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2446/2857] ASoC: atmel-i2s: fix MCK generator error handling
Date: Wed, 18 Nov 2026 15:58:00 +0100
Message-ID: <20261118150329.638650204@linuxfoundation.org>
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
index 5e43ff0b537a3..7e48dd40a13a3 100644
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



