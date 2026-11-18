Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024046;
	b=rR/1efFm+ugOf2wEv2TbqiZf6yUVcfYOkKStwMIAkJhhpWKj7RIoOPyfbqmtvkzL4KFP
	 ziHxOQP60o3jO6cFSwvxUUs5IviKUprjmPZVHAt8F2YHJZ51mvgCk3Ich889UzBqQx2S/
	 rD2YU1bec1j/EdmLY1UP5CW5oo42j1XI7DWrfMDKQeyuHDIM3RVOWcH6i4LLZDzI55IVi
	 VTMEqK2LoW9PRSEK2SOmnejUeDZHT7dsICcnxS+8NAv+JFQ1+v+eghuHbla/ATirDkJBd
	 DtI5G+BguH+X4jFAnB+DHxqNMmjiGd98QHnYkB7t4cKo2xFSQW4XEY2TRxSqE9sWbOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024046;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WwJlSqW1XESLBrF+qYn6en6HYH7tyjM+w0UUub+fbjk=;
	b=O0KeLgTpwVBJ7UH0AsCNyg2DVukpQA5eOx/lVm3+DFkza39LDZ7w3lCqzRvmFYVaShwO
	 24L5ky3mV8IC48U1GGUF1si2mQCffM3/j3wjZySQYLzGap7462tAduwHbUABGSQwiqLNR
	 3mB0ip+RdR+iG8aF9GYLixXQNJFyp/DZsH5GlasrQwb3Cn+bOSJDCX4Kj+4wrHK/S5Jna
	 K5NpCWYYyPZGaYfZXv6InF/vBL5xE9xyADZ9zzlngr0KIDAxeRdwM82wd9NGiMnbhnmWS
	 wOKGYb959XJDcrR3fTw0zsXqxW3jwijHjegWE1gihyf8BAindNUztdwO9UhVQQ57vuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AuJH3qI2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3751606A325;
	Wed, 18 Nov 2026 17:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AuJH3qI2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26311F000C4;
	Wed, 18 Nov 2026 17:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024046;
	bh=WwJlSqW1XESLBrF+qYn6en6HYH7tyjM+w0UUub+fbjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AuJH3qI2o8xjtO/UvE7uvuUwOLWlLHPKyoEkl4+OsIrwtsAbT1q9RIL1nxbkcAo9P
	 nZYuMy8hRo0nH2roh67I0eP4PbLxll0ITi5JBWg6xOGqm6S96Z25V/Dj926oGpC45t
	 Q7qp8WxILXCKSMfbXVriYxoMEWsSEk+fltrHgwBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0586/2151] leds: lm3692x: Fix regulator/gpio leak and wrong enabled state on last write failure
Date: Wed, 18 Nov 2026 15:38:41 +0100
Message-ID: <20261118150143.299840170@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Nguyen <congnt264@gmail.com>

[ Upstream commit 145ca6bca2cc5fd8d9c7af216df58a9c75c0e84c ]

Every write in lm3692x_leds_enable() checks its return and jumps to
out: on failure -- except the last one, which falls through and sets
led->enabled = true regardless of whether it actually succeeded. Leaks
the regulator on a failing probe, and short-circuits later
brightness_set() calls without retrying.

Route it through out: like every other write here, and only set
enabled = true once it succeeds.

Fixes: 260718b3a35d ("leds: lm3692x: Disable chip on brightness 0")
Assisted-by: Claude:claude-opus-4
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Link: https://patch.msgid.link/20260915034515.4147981-1-congnt264@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-lm3692x.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/leds-lm3692x.c b/drivers/leds/leds-lm3692x.c
index c319ff4d70b2a..03f2196836751 100644
--- a/drivers/leds/leds-lm3692x.c
+++ b/drivers/leds/leds-lm3692x.c
@@ -274,9 +274,11 @@ static int lm3692x_leds_enable(struct lm3692x_led *led)
 
 	ret = regmap_update_bits(led->regmap, LM3692X_EN, LM3692X_ENABLE_MASK,
 				 enable_state | LM3692X_DEVICE_EN);
+	if (ret)
+		goto out;
 
 	led->enabled = true;
-	return ret;
+	return 0;
 out:
 	dev_err(&led->client->dev, "Fail writing initialization values\n");
 
-- 
2.53.0



