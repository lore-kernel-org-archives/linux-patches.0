Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039365;
	b=eOz7zZH1lwqVIg86gLQUhnCZPvkN8h/3h/mCaJhP+Qc66nBbuY9/PKfA/RQmOGrPdHrl
	 2IBJj6nDWSaALJnnCLmVaDtHHVr8MoXGK0nP7DkF/wtmDxIgFQmEZ+PTEPX6NWDqM/Aeb
	 PrdN9Qja0TXudsjFDPLUmZUk+FGV0CBBQvw9S8JdfaGhFyVbnbPIbI3gjzgJaRzVaQAJ2
	 66NVVtqa4wt3A7ieROYCfO4sIGHwZxRpJ9+Zs4VBsEDUbOZG9Jcd0Oo/SiHL3rmb5SPl2
	 ULQMYOPjGes3x0mfp/H0Z6KK/+iMgqquVqknn/P2vjHevD24/Pp+spf4Mc4OnQFLHgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039365;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9vz6stw5P3BGdyKTAMhaiUllC/OOJT3C0MLmyp+ZHm0=;
	b=370BR8RJKsJ1gjimTlMjE+ARG3lebWBkzqkdDwoQ8HISWGrGc3RAYU4Fhm+0e1tMfrU+
	 XzamYliphyoZrbr91Fah8RNnRWMwCBqkZBVJPNFhRuzGX3/kWudcMhRFkdPPQnmG0nwiT
	 vF2fw5ak99r1heGcFxhYrAgwz0kF/FFnxmg8EVK1IC6k3f0mKgrSh3smM0/0xr5w+9xau
	 +NyCKQ5lM10UtI5bs+DST6w9EJ3af5AI3ov/lWuldErJBaIHtrVqoyq48641cGJzcYD4+
	 4zE6KYb8x/42LPSxTkr8yUxC2Jy9SfXjPePhAnNf0o8pRY8WKEONf7WJIlRRiY237qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eqxPncsZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40571606A325;
	Wed, 18 Nov 2026 22:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eqxPncsZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92AAF1F000C5;
	Wed, 18 Nov 2026 22:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039365;
	bh=9vz6stw5P3BGdyKTAMhaiUllC/OOJT3C0MLmyp+ZHm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eqxPncsZ2tv5dR6/DTLIzW0Oifw41dGUzV/f6QlWoe21aLzhi9uzp9PWHVJkYEtoe
	 CM+Zf8pMnrWDHP8bGCfwZ7EeEIJAdeJXY5mUGKB1/VKBFaPtbYio4m7xIROyqZhDYU
	 Ek/twnCtFCrz0AYOpJ3ZfIIobBrMPi4up6QRXGkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <zhangyi@everest-semi.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2074/3318] ASoC: codecs: ES8326: Minimize the pop noise
Date: Wed, 18 Nov 2026 15:44:56 +0100
Message-ID: <20261118150424.304106615@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <zhangyi@everest-semi.com>

[ Upstream commit 7e7dbdee96cbc660e7e8d3d9d7a512acaa6ca69d ]

Executing regcache_sync at initialization, we can hear a gentle pop
noise. So we created es8326_init for initialization instead of
executing es8326_resume

Signed-off-by: Zhang Yi <zhangyi@everest-semi.com>
Link: https://patch.msgid.link/20240624030607.4307-4-zhangyi@everest-semi.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 349e94679968 ("ASoC: es8326: report resume restore errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8326.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/es8326.c b/sound/soc/codecs/es8326.c
index 11c86694be45c..1d9d4c81f39e3 100644
--- a/sound/soc/codecs/es8326.c
+++ b/sound/soc/codecs/es8326.c
@@ -775,14 +775,10 @@ static int es8326_calibrate(struct snd_soc_component *component)
 	return 0;
 }
 
-static int es8326_resume(struct snd_soc_component *component)
+static void es8326_init(struct snd_soc_component *component)
 {
 	struct es8326_priv *es8326 = snd_soc_component_get_drvdata(component);
 
-	regcache_cache_only(es8326->regmap, false);
-	regcache_sync(es8326->regmap);
-
-	/* reset internal clock state */
 	regmap_write(es8326->regmap, ES8326_RESET, 0x1f);
 	regmap_write(es8326->regmap, ES8326_VMIDSEL, 0x0E);
 	regmap_write(es8326->regmap, ES8326_ANA_LP, 0xf0);
@@ -836,7 +832,6 @@ static int es8326_resume(struct snd_soc_component *component)
 	es8326_enable_micbias(es8326->component);
 	usleep_range(50000, 70000);
 	regmap_update_bits(es8326->regmap, ES8326_HPDET_TYPE, 0x03, 0x00);
-	regmap_write(es8326->regmap, ES8326_INT_SOURCE, ES8326_INT_SRC_PIN9);
 	regmap_write(es8326->regmap, ES8326_INTOUT_IO,
 		     es8326->interrupt_clk);
 	regmap_write(es8326->regmap, ES8326_SDINOUT1_IO,
@@ -852,6 +847,28 @@ static int es8326_resume(struct snd_soc_component *component)
 			   ES8326_MUTE);
 
 	regmap_write(es8326->regmap, ES8326_ADC_MUTE, 0x0f);
+	regmap_write(es8326->regmap, ES8326_CLK_DIV_LRCK, 0xff);
+
+	msleep(200);
+	regmap_write(es8326->regmap, ES8326_INT_SOURCE, ES8326_INT_SRC_PIN9);
+}
+
+static int es8326_resume(struct snd_soc_component *component)
+{
+	struct es8326_priv *es8326 = snd_soc_component_get_drvdata(component);
+	unsigned int reg;
+
+	regcache_cache_only(es8326->regmap, false);
+	regcache_cache_bypass(es8326->regmap, true);
+	regmap_read(es8326->regmap, ES8326_CLK_RESAMPLE, &reg);
+	regcache_cache_bypass(es8326->regmap, false);
+	/* reset internal clock state */
+	if (reg == 0x05)
+		regmap_write(es8326->regmap, ES8326_CLK_CTL, ES8326_CLK_ON);
+	else
+		es8326_init(component);
+
+	regcache_sync(es8326->regmap);
 
 	es8326->jack_remove_retry = 0;
 	es8326->hp = 0;
@@ -922,7 +939,7 @@ static int es8326_probe(struct snd_soc_component *component)
 	}
 	dev_dbg(component->dev, "interrupt-clk %x", es8326->interrupt_clk);
 
-	es8326_resume(component);
+	es8326_init(component);
 	return 0;
 }
 
-- 
2.53.0



