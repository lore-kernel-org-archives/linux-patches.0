Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064421;
	b=Zm1lJ/sHLsAsNfBmLFhEzEcLpDxU09IH80+MLA3a2OYVgijK2YCaGnaJDJoJ4liYRR18
	 XjyLkkc2uPmxX9RCqCvu3zL+QFlg9MGQDv5l0woazFsezSgxTOL7ut2Eewdpy407A72ie
	 RtBFioOgE1z5WQiNCGOSs3X8CJR4qjPxguFnd4jURvCZ34aIJ4ogA0VZeK4X3/vEvqPQZ
	 oSMGmBKYH7wSF+sD9slgNONqBFWy1oBBUIEJqpalT1Keav1YOJpbBCHv5McrV0N3OLL4l
	 1zokiQnSZFHRQyb8TDkojgvi6CI2cD5TH/RPuvtl3eceSpwudukuGcR/f3jmQIpAo3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064421;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JUKxUo6i2QP3V2BNsxrSyBDr3bqDOF28W9azZfoOa6k=;
	b=sMaS7AYVJLBMKFYvjuU+ktPbeknbG9NLGSfdZnJR1gdRst7i8GA7wrdWjZw1QiS6C9SK
	 3xKUDs06N5wYIhtelgB4eJd/Mty4BT6ZB+irLY+nxdCw0Bpa69YiiYBS/ToHaZpPG398N
	 ClPx07ABaNQurjJRHYCuckHS0095RQvMP0Hy0503I1qjKcDogRd0AYtoipHgjj1QUFxy1
	 defdZ3IDeODkV989a4bUdX6t9o8gjRtyAIuXVc0srU9yA90UfAzthZzr+IslRJ/Wj2xMH
	 3wDWhUvTOinL3vik201YFozkWfojN+QGmkA5QeuSEUgp11wmDJO+PrdHZ/kw67moZkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fth7MWBM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5453606A9C1;
	Sat,  7 Nov 2026 15:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fth7MWBM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C011F0089F;
	Sat,  7 Nov 2026 15:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064420;
	bh=JUKxUo6i2QP3V2BNsxrSyBDr3bqDOF28W9azZfoOa6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fth7MWBM58GwW5bB4ivsTut/UmWCL2n/R25dPVrIZ82OmERUzI+X4/gwT/JqKDpDJ
	 96Kb3iD0BZydvtVW8wav+nACSDuOtxtqthCUQK6vG+uz39IWw3xN559ygX5hTS+nw8
	 g616MCdUTG3uApiiSHQURErMNZt6qMz8REsHtWB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0471/1257] power: supply: ltc2941: Fix of_node reference leak in ltc294x_i2c_probe()
Date: Sat,  7 Nov 2026 08:46:07 -0500
Message-ID: <20261107134952.464432732@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ltc2941-battery-gauge.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/ltc2941-battery-gauge.c b/drivers/power/supply/ltc2941-battery-gauge.c
index d1be314f36a09..6ebb555f203d3 100644
--- a/drivers/power/supply/ltc2941-battery-gauge.c
+++ b/drivers/power/supply/ltc2941-battery-gauge.c
@@ -464,9 +464,11 @@ static int ltc294x_i2c_probe(struct i2c_client *client)
 	/* r_sense can be negative, when sense+ is connected to the battery
 	 * instead of the sense-. This results in reversed measurements. */
 	ret = of_property_read_s32(np, "lltc,resistor-sense", &r_sense);
-	if (ret < 0)
+	if (ret < 0) {
+		of_node_put(np);
 		return dev_err_probe(&client->dev, ret,
 			"Could not find lltc,resistor-sense in devicetree\n");
+	}
 	info->r_sense = r_sense;
 
 	ret = of_property_read_u32(np, "lltc,prescaler-exponent",
@@ -477,6 +479,8 @@ static int ltc294x_i2c_probe(struct i2c_client *client)
 		prescaler_exp = LTC2941_MAX_PRESCALER_EXP;
 	}
 
+	of_node_put(np);
+
 	if (info->id == LTC2943_ID) {
 		if (prescaler_exp > LTC2943_MAX_PRESCALER_EXP)
 			prescaler_exp = LTC2943_MAX_PRESCALER_EXP;
-- 
2.53.0



