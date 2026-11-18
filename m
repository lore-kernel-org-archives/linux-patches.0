Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047281;
	b=r/PvGvkJFSTVx60HrZYCyO0xdgW7M+aFwZ9yVFqj9cdK9axA3zBD/mN9NqX+wzf8dD7X
	 q1f65pWypoF6EJdhkrOhLwrannTpImoMi2OjCns73+0uV9Df1v+u1CFo+FNU/gN2vFvkU
	 y7BsIKwjELXr8WuVO1y7xkF+SAUEijgtBaJrZLS+8zUHJWEE0DSMaJp/3dEf5z2npmNvW
	 GD0CMyKi6mpcV6VH83B4zSWTUI5gCxAO4qfkaP55o4TDUEfh/YqW/aTD90s325IL2NjGP
	 fm7muq3vX9vN4r0bL1qpz5S+3KfhPTDdPL+sR1AqrmZqwe8oyOvk4+bvBExUit3G+mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047281;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nlOcbehXtfmiGWlACK3sW4Lx9S/J9xyT/DgGeORK5Co=;
	b=XoYe8xrA1L8wxxyPVF6Yf7GI6sS8RuUb5ulNayX5XWt1lwXVN0NFsCF9TPyArMYdviG2
	 E0IcremDAZrwUbn55No0mljR07e8QZ41N7iWwxqTcFaaD4+M+7lEVkUSbLUs17Y+uRMAZ
	 b3wIHVoMbwNKHyClhXcJUY+L3EQNcro1SZJDXto6ZyculSqNXIRe+SMIm4gWV9Blab9tq
	 WNfxdgvdJyuXtqkk8D7yA79jzbq248kDx47LyHLpzrYgzhzI3LL40SoGQ+/y0sP+lZVYd
	 AMsz3R2WqXtdaeaaYzOk5U+evyk5M6b3/ytAxF8dzE2AUGn/yGX/4e+ovYkJOGmd84w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="VUCiks/B";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B75606A320;
	Thu, 19 Nov 2026 00:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VUCiks/B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39FA1F000C4;
	Thu, 19 Nov 2026 00:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047281;
	bh=nlOcbehXtfmiGWlACK3sW4Lx9S/J9xyT/DgGeORK5Co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VUCiks/BXa7JU6f7yP5KcEkheV3zUk4CPRLRtihvcWAVlRsUZtsGzr1qBCipcyME4
	 0My9zW4dtK5XEJ6DxH7dlpCR6ANB2+gWacFrMBDsLG8Z3aMk0QrVh06KW/Ol18AuWp
	 rhnhS3yY37Wr9A8EbCWA306jRQ/V9o+96jvue15E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1582/2857] power: supply: ltc2941: Fix of_node reference leak in ltc294x_i2c_probe()
Date: Wed, 18 Nov 2026 15:43:36 +0100
Message-ID: <20261118150258.334845946@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 09a29213bf15630e85a375478832b074b2cfc5c8 ]

ltc294x_i2c_probe() takes a reference on the device node with
of_node_get(), but never drops it, so the reference leaks on every
return path, including the success path.

The node is only used to read the battery properties and to set
info->supply_desc.name, so release it after its last use and also on
the lltc,resistor-sense error path.

Fixes: 085bc24d1553 ("Add LTC2941/LTC2943 Battery Gauge Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260917142127.2156568-1-vulab@iscas.ac.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
[ sashal: adjusted context for of_property_read_u32() instead of of_property_read_s32() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ltc2941-battery-gauge.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/ltc2941-battery-gauge.c b/drivers/power/supply/ltc2941-battery-gauge.c
index 657305214d68d..9c18352f1adee 100644
--- a/drivers/power/supply/ltc2941-battery-gauge.c
+++ b/drivers/power/supply/ltc2941-battery-gauge.c
@@ -465,9 +465,11 @@ static int ltc294x_i2c_probe(struct i2c_client *client,
 	/* r_sense can be negative, when sense+ is connected to the battery
 	 * instead of the sense-. This results in reversed measurements. */
 	ret = of_property_read_u32(np, "lltc,resistor-sense", &r_sense);
-	if (ret < 0)
+	if (ret < 0) {
+		of_node_put(np);
 		return dev_err_probe(&client->dev, ret,
 			"Could not find lltc,resistor-sense in devicetree\n");
+	}
 	info->r_sense = r_sense;
 
 	ret = of_property_read_u32(np, "lltc,prescaler-exponent",
@@ -478,6 +480,8 @@ static int ltc294x_i2c_probe(struct i2c_client *client,
 		prescaler_exp = LTC2941_MAX_PRESCALER_EXP;
 	}
 
+	of_node_put(np);
+
 	if (info->id == LTC2943_ID) {
 		if (prescaler_exp > LTC2943_MAX_PRESCALER_EXP)
 			prescaler_exp = LTC2943_MAX_PRESCALER_EXP;
-- 
2.53.0



