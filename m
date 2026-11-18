Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056065;
	b=41wOR4B3dGg5qm6WDtA2J8K54zBLjqCarqoCYYxIBY/ySbuo/sX8Ey+QsEo3N4S9dP80
	 3GvykMGNSbFDl0orvdxUtVIUBqG2rkufqJyDlIvhFKUnIJW55xArjc/ro6a/yGYZSFLPm
	 9G5imUQztkoiZNfqjLXT7uirkzFwG31WJfdesxsvDZCqzXCY4CbbWKkD6wVvwFkMLNmmg
	 q0Ey5y1HTW+tGnbpNEB83GtUpiahBkUogHqhOsSsSmcv3J4aQ+lKOKyd5hEg8+tyVH1Y4
	 3sKzDGdsO7iZY7XRqN2pmRu6VYfWBmx3Iv/vS4MK0IOU/zXM21c7x4bA5bgrNy85E4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056065;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=avARsu8+X+xCp+UInXTu8OBuN1kuvMDpYhS2hxGRw4k=;
	b=2BQdU6wNi8i6z062nCW67dZsEqnC4+TvOzBXyxENoJ6LoEPBgbvpx/TOuD0L6G6PKMBq
	 fdF8iPQEiyngiLViLoDij/ATxjIIIj6oG9Vkj1csm1rL3AkpTvNQ1O+3HSstxsex5Ag+I
	 iJ0nVa1Cd7vqRXpkrjRZLlsOIgscYi/WYkBLVzKuPajhCXAC/yMQZpr8dj2CqPW8XvOAc
	 SRGe3c+rTuNEYkcqgCRS0oVVcup3tlHgfuKt82nSZTSRHnZhQGl/iezaKWIllaiMAaX87
	 /POrWWLxqd6Q4isdAxYn8BRnPxUIYzdJgTYjLP57UUAU0eBQgEY7NLbNK5ie9XGHnwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hNuPtLpa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFDD606A31C;
	Thu, 19 Nov 2026 02:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hNuPtLpa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C6E1F000C4;
	Thu, 19 Nov 2026 02:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056065;
	bh=avARsu8+X+xCp+UInXTu8OBuN1kuvMDpYhS2hxGRw4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hNuPtLpaqtbXcGe1chnoLYPNA4TPB+9GZNKPk4MGycRMweHbDM0stbPQmGNWwXHWD
	 BnKwxM+WXiNqCUhfgtw8jU6TLFPJqooe1k/RNbCMrT4AydWhvDGGbN+MpBfGyHzoFT
	 YOdJ3sBjheLLYYynpserE7CL3Hw0vbiOrgzkuV7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	=?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin.sipraga@analog.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1853/2214] ASoC: codecs: rt5659: propagate GPIO errors
Date: Wed, 18 Nov 2026 15:58:49 +0100
Message-ID: <20261118150125.499640539@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6a85157456d70..21a3e17a19d01 100644
--- a/sound/soc/codecs/rt5659.c
+++ b/sound/soc/codecs/rt5659.c
@@ -4115,10 +4115,14 @@ static int rt5659_i2c_probe(struct i2c_client *i2c,
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



