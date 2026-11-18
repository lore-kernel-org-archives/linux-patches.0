Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019638;
	b=LfWvKMdki3DdPta82XwNmuffCInKBJTtYAqTcAx9kwy5hRhxn2WPilbwvceZlMIjZNE8
	 DqKhXmQNlsF+Q3dcFP2/zsnok3HU0kRg1dw2kef33w9vXWpKv5gCVxvxN/1sw7Vl6bWh8
	 FNl7tj5gkBc5Jl1nnm1DwIJohvyjLTO5Hsb1vd68vixO0Xg0zvuKn6NzhGfjmNQctST82
	 c3HSPT3kToGjSA/GsxzOVh8MV9rskG+YKCNMsb1lbACGbKzeNzFVY5OwFMqh/ZxDvptrm
	 f+DfJwrE+t1Y1IX0uocG/SPPSZuDs4j9VGHZDivOO88tkPcnh9bnkggpbdJyyYYLEqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019638;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=74X4L8BT+6ryJpHoCe3ugzmi1LKqJu6FTdKah7DZGlA=;
	b=Vr0GBKSrb+0/sYzBi1cmpjCwCLPSx4o9oN+kcQpMLGoHvvAZLM9n6xXawyx+PYaVkt6i
	 SnSiWvefKFJEOIa5SwmQX7PeVJC7bVpCdiiXn9BFFfg3eO3Xq+DWN9ocomkpmqV+aAYHh
	 cC8Ky1JDncmcr+d3yP20NLdRPNQGQFW1SZoY3oxwxzCbDbyK4altvnocHi2oCyjK1WOss
	 ywQ914gxCZK46e8GHmhFG4ldL/ZH+msQ5dQty6B5tJeuwp0R6jVnvoNkuf/mFkB6dTEKL
	 Xe2te6SeNe3u53s2m8cevdK328I6IqTcX8mSjGPAKnMyOFvl59/VdWFa3FCpY19OH2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qrd7GqLr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75974606A333;
	Wed, 18 Nov 2026 16:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qrd7GqLr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC8511F000C8;
	Wed, 18 Nov 2026 16:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019638;
	bh=74X4L8BT+6ryJpHoCe3ugzmi1LKqJu6FTdKah7DZGlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qrd7GqLr4kUjyvpReMr4uCOneW2x0T3MYTgaaoEf9I65d1jeSPi4T0Tt+Wp8864uz
	 OiFXmACTUIGqlwGY/BRtmi4v1JruAlqK0PinuKHIaAFtfZ1IDMS0tVkKuEukObFpN7
	 Nkvcr1c88aSsr73rAW5PojE7OlfhjuNE2kgyRpNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	=?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin.sipraga@analog.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1668/2651] ASoC: codecs: rt5659: propagate GPIO errors
Date: Wed, 18 Nov 2026 15:48:28 +0100
Message-ID: <20261118150347.755589511@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 915b6b4b2630a..47f0c7e097a88 100644
--- a/sound/soc/codecs/rt5659.c
+++ b/sound/soc/codecs/rt5659.c
@@ -4111,10 +4111,14 @@ static int rt5659_i2c_probe(struct i2c_client *i2c)
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
 
 	/* Sleep for 300 ms minimum */
 	msleep(300);
-- 
2.53.0



