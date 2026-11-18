Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026255;
	b=EGbIZ4CEIAhTNqTwk0otr+xpWN0Ck3hoOTA2Cqr3+IhSFIrReKLJBlPzfsN8q9hY0Utl
	 UhM+O42Lq+pOTJ3bRMuMGz/y7J346wm/MJxWGHClaQ3eeULVn1nabOZ7hASNYr18jsIDG
	 cJ79YqmQnoAsPqif3XJqaFlwP/a78RM/1d+9RmXqPbeXHpGGLZsa7TKbxb8hK9QUaWjs1
	 NJSxtNYxaxMrsH/ULp69pIEEvOnNEjH3hVfULtGvGxgcrCp5AzCU7FRiL9B6NWkCFMjXO
	 yn+ppnayMr2Eae+p2LhjiDx8YClMLJWZuu8hGHwHtnd460NqON2t5ObGm2LCK44U7WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026255;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=bKpWf7iHlcernLhGGgAgLe1UEhR6Y2sG7osYCZ3mBdQ=;
	b=1wkmSsmEiwdDEQaRHx9hIDSP05c0hf1OmmdHlTJteIr3L8DmfsGI0L95eO2LvVdFaQgb
	 xhUpCG36cX225bbiKdiUqImMy0JkV3LqwBvpq+EdrTzU8Dd5FprNrzpLCgZP5+gqfAocK
	 M6CO42IGTU84TUWZ4eBBMODZo5GhCvOE5EDsxW5Hw0vvlQuETYQk8/2OnowkFqKdfUyyp
	 wRbPJCMwcmBwZ4ucGCk4Rwpr8fcQrHIUvDn8qSWLZYQKGG21Vh6uQVmeMFk2VE3WrMYxI
	 oUbejCePGRNokVLMr50hH6AoUGdxLwCYMM/a7U1lzjGQnk5tV4xfMInbY93+SnE8XSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0VLGF2rx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EE0606A320;
	Wed, 18 Nov 2026 18:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0VLGF2rx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E89E1F000C4;
	Wed, 18 Nov 2026 18:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026254;
	bh=bKpWf7iHlcernLhGGgAgLe1UEhR6Y2sG7osYCZ3mBdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0VLGF2rx19pP547MObYKVxrq3EFIqhi8/36RpKvFKhEq9aXD9U7r2kockUUBqvba7
	 oDys7w7P3uA2y3T2HIHsSqaKBKmcxtguztIVxLKnEJGOlWkZwEAgTCe2p0EN+ucPIZ
	 G4W1AVLLG9DdvMWrRqTfI7MyqemQYGzjnzbrUhaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	=?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin.sipraga@analog.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1369/2151] ASoC: codecs: rt5659: propagate GPIO errors
Date: Wed, 18 Nov 2026 15:51:44 +0100
Message-ID: <20261118150211.890005884@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 805898547025d..760b1a14ce35e 100644
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



