Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049522;
	b=VPYmgt9XprVFN4ewCyS800dAt+4iEj9wWl4KucWLMUQvWAInT7Imj4Msce0sB7+lTFLi
	 rXLJ3y9joc4/c9wrvcUqLRnXeCRkhlsbzM0kqNYn1hvP3z8fpBjZ1o4CVAMX8Q/y8pbAd
	 bWH6wILJjHtQNDCHovHGSqK1AjHFtbNLV6fyfRymLdhNIxO1pQw74YwS5ojtlAubd3YDe
	 nuKASoDoqxzSS15oihZ0CMOwMy8uGC3Bxg4e2PoFwuuOXx1pABXBkiO/XAl7NSTm/jDaF
	 JinrCdY2t66QZrK1nPe7FNBRgqKR6NHbJYhxU5kElAySKEWrB8bKOrbNTFH698DUl5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049522;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=F7aWg7jKjRDz7/q8sY8zqECSu4m0YO+Z6HBAm+1QKUw=;
	b=hACOghTr+SG52y2ZhfF4NrNyyY3UYSOW/kYOx+s0GK8skemnsBfZgHq6hdJNl6mRZelA
	 ZVoseitA+8D/7aMudyum0OzQI8l38t6mEGCICecZSrgw6eZ7O/ypd8VsOMZbwdKbckFU0
	 C5x31zO+4MDQJGLfgCRxzfFjWfgH7DI9Nu/tqS2Li+aKFzpEk5I2VSTGuIxa5K7H4kPFb
	 sghcvJ6r0vinNnfiEnwctOzDQ0PSM0Lv1jLGl3C5H7XHANTxrlI6X7FO6qCDB8TfupvKr
	 PbAgHYNhmLxBfLVnVLY3JDwpOTNVD7JlIoLCDxvRJdmgPJM7cQnbawDx3wif8IH9e9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k8kq+S5U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF001606A31C;
	Thu, 19 Nov 2026 00:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k8kq+S5U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CDB21F000C4;
	Thu, 19 Nov 2026 00:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049521;
	bh=F7aWg7jKjRDz7/q8sY8zqECSu4m0YO+Z6HBAm+1QKUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k8kq+S5UD3oK54WRQxVHs1btkOG8lvIzXvVwoQWFYbuUlL3TIcCfEKPivbVmAZQzU
	 J7ReF8Z3ESNgH9OM1cFN1a7usd+KiK7BUvucEQadbmC8uTEPkXo1hQ7eFBo/R1jsyN
	 oYorP8ak/C82tWtb18atu4DCRyQEj45wYgyHgYeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	=?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin.sipraga@analog.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2381/2857] ASoC: codecs: rt5659: propagate GPIO errors
Date: Wed, 18 Nov 2026 15:56:55 +0100
Message-ID: <20261118150327.256845300@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e7567140406b0..ae80fb327ce83 100644
--- a/sound/soc/codecs/rt5659.c
+++ b/sound/soc/codecs/rt5659.c
@@ -4113,10 +4113,14 @@ static int rt5659_i2c_probe(struct i2c_client *i2c)
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



