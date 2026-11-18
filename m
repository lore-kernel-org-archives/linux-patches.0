Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031507;
	b=c43XRLZAVR6N3X8zr2ctscP5CCjp+yu8H67segoo+aoLqKfRzW9MeomJn1KS6XPGNuDk
	 1vOaQ8k0AcQGzQFXsr0i2zkz/gdxxpvzoNsA+//FjEendTgiSQLHpiEKOoou8TsC6p1qS
	 DROl55faEYHDoFqiVWmhN/CSeCjRn4BBntT5ldaAWGRF+MHUVJsEUb9aEYMFHXSP9kQv2
	 RMI2WtM4xAaOnSbumKNcQLxv+8LfAYHbc5X1aWM/XfROZEDmn58aUqTpq0LDe6UL8Jt8K
	 61prJuXgJ8J6qC8uKZiEBO/VqpUS/RGc6qx9Kydi0t7NyL+aabwTR+uu3USJpxra4AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031507;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=XpNWKUWbGYnFtCpUtY19EPfTVewlgQikB0y8x8Jep2I=;
	b=K6lD4IJ97sxf4d042M6sfaRW/GjBA48tIrpi+yqSM5X3ebYp3OYaAxT8WInXHKJLea1V
	 cDLTlsQIVB+Enj0HaIno4B3vunrow9udcogB0U6Y8WrBmccHxJKlkKeTn3vv9hWHrenPF
	 bA4s8/8jYRJMvWebOJdzgKK3XXrIr4lTggcT9Y9sfsVIAUs4iy+oCW8Miz1e6B+w2ooB/
	 J/zBtN/bInlTpHPvGsKzuMKMEH/tHsFy+Iv8RLsFtCuQFvJgH7/6IBeGX219jxV2BNlZN
	 b+ZhCsjJ16woFXKBUdjHMQZtekMrTlYNLRq93hQCBNok526y8ff1r7KuHIX1TlEVrAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JLy1r7+C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63737606A325;
	Wed, 18 Nov 2026 19:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JLy1r7+C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 642A41F000C4;
	Wed, 18 Nov 2026 19:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031506;
	bh=XpNWKUWbGYnFtCpUtY19EPfTVewlgQikB0y8x8Jep2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JLy1r7+Cs6jzJZnfGQwtXPFSmaPzOWMlbW0rdiM8Yq8JkEO4TLVt8+WTyWkaelI60
	 pRkGwHwKFgi4HET4yBDgurkr562nIUsPk4NeZbKnlskZPWU/+MnX6zoXw+OSy2Vuk/
	 VNWqQw47NKbwTVoMQsZ6zqxphK/kIzt/YMEsIxiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	=?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin.sipraga@analog.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1083/1756] ASoC: codecs: rt5659: propagate GPIO errors
Date: Wed, 18 Nov 2026 15:53:30 +0100
Message-ID: <20261118150053.317296314@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d2944a43c205a..9ca71edc19dee 100644
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



