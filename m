Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039429;
	b=LIUt0yIZzbWGDbGs9OwzFHoh8glZuUaaFru4SKznMBVvulqHFe11QQPZm8D8L2FoE3wk
	 9610cn5u7X0iCUPT6T5JbBkOnpjJryFgHswwDc8ebPPtZLLrwsSJyimIyP7wPl6/6mtzh
	 5f08b01Zj2XBrDg0iPs/gIkkKI+OkrwqMuh9m3ETk5KsBXwYMAgTtRMKRJEOS6KSjqTuY
	 TDhYLYBxdsOYUoR82OUHApcvu7wly+JvF2UIk7HVTjbsjqKbOmEMZ/JK3rlXVyBTNRlzG
	 BPy3rs2coHFKXZQmHapJZRx2C0t3wAGJgLYx4QJP9wEAHp2o7IR2Mia+Wg6X1r0SyHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039429;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TnVKgooZVg0v2e0ABGqtKJtLynD/obqgjYutcz4Lhic=;
	b=zqHxYjoLUJQZGmcC5C9jZnB6DbWd9r/CnunwiyrrCVUErjzhG6nOSFgUI8cQXo2k3vB8
	 ABH6xCuudoTPr0hcuIfalOPetGJaZ0FZ64MxO+C+5l2D3fVuqhAwK3Vk3gcRFiZTlLZqw
	 VuNfpxxn1Gcpr40ZyAeVmQoPTlRNnib2b6nh8vycIFDnxFe6KaD6H2n01LjDGYp8KXcfr
	 EEcgpENDQpxk2gdzVMkK/Le2elHK1rAYptvp6IZ4SDLgit64uZvYujBE66lTtGcCMO5Ps
	 V7uYP8jgY6pmir1J26jjQkRagPWNeF8GzXPNx/kYjerZCWTj7ZXsP8ECs4PgNuelT2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KQqqeIGO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67991606A31C;
	Wed, 18 Nov 2026 22:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KQqqeIGO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B561F000C5;
	Wed, 18 Nov 2026 22:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039429;
	bh=TnVKgooZVg0v2e0ABGqtKJtLynD/obqgjYutcz4Lhic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KQqqeIGOlJVHkbzP+BpP8gxfvNUI+/590lq3bSdyZaDxEBnT91WaCdQ287M/gO+Yv
	 1VlLM5CZWBJoAY9k51/8K5jgxInPYEc0eqDZeSZ3ECiEOIZQFlw0SE0JFxLenp09ez
	 cCy/T/XzLSaOtzKPaSs9C2JdHdPidBl8CQVS1tZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2056/3318] regulator: mp886x: fix vsel_mask
Date: Wed, 18 Nov 2026 15:44:38 +0100
Message-ID: <20261118150423.742908789@linuxfoundation.org>
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

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 24fa0eadc2e3c7e9397924197dca7777ec08b8d7 ]

The MP886X vsel is 7bits, fix the vsel_mask.

Fixes: 97be82880b61 ("regulator: add support for MP8869 regulator")
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Link: https://patch.msgid.link/20260901043123.5401-2-jszhang@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/mp886x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/mp886x.c b/drivers/regulator/mp886x.c
index 9911be2e6baca..fbc0f726faaa9 100644
--- a/drivers/regulator/mp886x.c
+++ b/drivers/regulator/mp886x.c
@@ -267,7 +267,7 @@ static int mp886x_regulator_register(struct mp886x_device_info *di,
 	rdesc->min_uV = 600000;
 	rdesc->uV_step = 10000;
 	rdesc->vsel_reg = MP886X_VSEL;
-	rdesc->vsel_mask = 0x3f;
+	rdesc->vsel_mask = 0x7f;
 	rdesc->ramp_reg = MP886X_SYSCNTLREG1;
 	rdesc->ramp_mask = MP886X_SLEW_MASK;
 	rdesc->ramp_delay_table = di->ci->slew_rates;
-- 
2.53.0



