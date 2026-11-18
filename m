Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041422;
	b=FVJRrNYj2jU9Som52eTZ1YwJH3Mm6yLS4Lc69FB2keNXsnNtFaI+FkiK3m5aNJU8Jdx4
	 GePchhGdpIWezP0IfOS1swKvNWSzQa8yR8O7qHsk7Nr9fpR5EAPOEnUYT3lqlckLUKqx9
	 SyLGLCe0cSRkiNxriBtl+taD21B9mCxw4Od47BhrG2ye/VwaMcBqvKvDB6ZCK6eQq3Goi
	 W7e3Z2x4G219iN1jjmFXlnpPxeHw+1ZdiOegROIx2himkRZDP/DKyUdy2NCToAi59FPWL
	 VUYjnAN04JFPPdrWlSh8kgeRqfrU/R+1j4/ResGwQmfRJJ84p7jpKheKyrvh2e5P0Mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041422;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=dvKrGaoeQHIr5IlDTjzR/EONvR9eRTX/gxaIVw2k4KQ=;
	b=PXRikFTnVH4JhSUCjBkdXWZpvSAfc+lWEuPQseV//Eb6qbrH1AG2Sl48+bpl3RcsIid7
	 xF59ETKl/s9t8L+Aa2TAdhf7KPJia6qc22yTNFxyMUr0HKf+NCCtDr4cdLsPVRTfPy4z4
	 Muo9hI25a5z96NHwg1daAx3ppmWSmo5SJAukD/vqap+dtsIfXnuHQbPOmJYHPE2skbA//
	 mmihGytKUIszddhmC7nyTDPVB2GykmL+wCReYl4sR3Y1uy1XdYSUAsA/yPhlEmjdqvW4I
	 uwScvi1Q9HJmPm6fOuKIIoBiTbJbbNJ/ihMUj1Q3qF9ZFntLik3EmZbC9BLMXx8Qzuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tv0fKCGv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCBA606A31C;
	Wed, 18 Nov 2026 22:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tv0fKCGv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622B91F000C4;
	Wed, 18 Nov 2026 22:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041421;
	bh=dvKrGaoeQHIr5IlDTjzR/EONvR9eRTX/gxaIVw2k4KQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tv0fKCGvg6m+iE5sYfB8LGJqqHYESsE8jcM06wIW59MRPyGq/STZ7DEAqDlCkQmmp
	 +M+QPorqvYffFXkwMYMQhYPaE62S7fUA1nU2+v7gJP65L0k9HE9MlzVyz6opr8avIy
	 S00KvxARk7suSLmxj3ZVs6U6SLMdaJi2o6cmabmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	=?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin.sipraga@analog.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2757/3318] ASoC: codecs: rt5659: propagate GPIO errors
Date: Wed, 18 Nov 2026 15:56:19 +0100
Message-ID: <20261118150443.447612792@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit c1e321bd5ce6ae3702db65837cfe0c792634d603 ]

devm_gpiod_get_optional() may return an error pointer, including
-EPROBE_DEFER, but rt5659_i2c_probe() does not handle these errors
for the ldo1-en GPIO and does not check for errors for the reset GPIO.

Check the return values and propagate GPIO lookup errors.

Fixes: d3cb2de2479b ("ASoC: rt5659: add rt5659 codec driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Reviewed-by: Alvin Šipraga <alvin.sipraga@analog.com>
Link: https://patch.msgid.link/20261009112204.33199-2-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5659.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt5659.c b/sound/soc/codecs/rt5659.c
index 8b0691cd66bd9..ee1e3e3a3c8bf 100644
--- a/sound/soc/codecs/rt5659.c
+++ b/sound/soc/codecs/rt5659.c
@@ -4112,10 +4112,14 @@ static int rt5659_i2c_probe(struct i2c_client *i2c)
 	rt5659->gpiod_ldo1_en = devm_gpiod_get_optional(&i2c->dev, "ldo1-en",
 							GPIOD_OUT_HIGH);
 	if (IS_ERR(rt5659->gpiod_ldo1_en))
-		dev_warn(&i2c->dev, "Request ldo1-en GPIO failed\n");
+		return dev_err_probe(&i2c->dev, PTR_ERR(rt5659->gpiod_ldo1_en),
+				     "failed to get ldo1-en GPIO\n");
 
 	rt5659->gpiod_reset = devm_gpiod_get_optional(&i2c->dev, "reset",
 							GPIOD_OUT_HIGH);
+	if (IS_ERR(rt5659->gpiod_reset))
+		return dev_err_probe(&i2c->dev, PTR_ERR(rt5659->gpiod_reset),
+				     "failed to get reset GPIO\n");
 
 	/* Sleep for 300 ms miniumum */
 	msleep(300);
-- 
2.53.0



