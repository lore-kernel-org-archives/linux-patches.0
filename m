Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053778;
	b=xJsE/VvGmQHsCWZgKJtEIUNsi5zEpYhDD0Z6cg7i3IdXMWpouO+axTjgNO0wy+KhTSUL
	 G0u4pQqcF0UT47ZpyXs9c9C/P0veObQPgB4+hbwzxhlxIuOQ28F3I4ZIUwOyJ1fG8fApg
	 or/xr6vSf9Yr+BafTsZFUB5afqS6PwibWd8IEeHf1gvivFCQse81G4zo33K7/OyS+22J2
	 BpZ7EHx32pcOIgZYJr3ynahJRinIijca9VxEalnGYFW61RAGURcxbmk3Hs1VtmaK1H7YV
	 nb7xEuu/zvK9PviCFOHDXRnYF2ZRGU2v3C+Giuk73W0ilRopPLD5SxPNVepzuZnLr5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053778;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8YL/xAfPcYHgNhl9wsm0baSJ63APoOnu9XbBT+S/UsM=;
	b=opNsoWHQSaC1gnabvEe7dWCTkwADsGB/+16S0tGdWnz0mx4V1JDAnk9f3tDv9Coxbze1
	 LyXiLZeI5mPQ0lrVIsZnM3FYzFxrONHbBkq6mu1hUPDBUE1uCDsnU4PoAoGvbo5ctxdOB
	 G+myk+ODmvC9DXf2z9HDVp543X1T4m7SpZufJvBBh8tntlJQV4BHVPBbRHc4+ZQ6Gm5X3
	 phLsGQJXn1w1rLfHvskh7JLxQVigMj/C9rbt/2c+cE6CpetsGQJVNzVo0KF5PmrAE66D4
	 tGRc7oN5nBnT7xI/FBCPaor00ViA5fGUGivcDmlplmvZHyd3FpHF7528y3pV34n9Qag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wcGsBmc8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC69606A31C;
	Thu, 19 Nov 2026 02:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wcGsBmc8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D751F000C4;
	Thu, 19 Nov 2026 02:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053777;
	bh=8YL/xAfPcYHgNhl9wsm0baSJ63APoOnu9XbBT+S/UsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wcGsBmc8mo91TK8XHb0Ws82TpN3NFIiY/hFt5Kv9IRbEV4qX/f1V23fuGoAPAw3nD
	 0DCIdZ072Uvq9Xd85x8xhu2EKHPJVg9BdmsUEq+GIYb5VzROu9ith7rnxAYw+kYqqx
	 S5RKh3ItmHH8EYMWdIBR/+1D4a3SS4lLvCnvMOOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1040/2214] ASoC: stm: stm32_i2s: request IRQ after regmap initialization
Date: Wed, 18 Nov 2026 15:45:16 +0100
Message-ID: <20261118150053.955462394@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 1b207c85551fd74854d632116849295b2305245f ]

The ISR accesses the managed regmap, but probe requests the IRQ before
creating it. An early interrupt can reach an uninitialized regmap.
Reverse-order cleanup can free the regmap while the IRQ remains active.

Request the IRQ after regmap initialization so probe unwind and
removal free and synchronize it before releasing the regmap.

The teardown ordering issue was found by static analysis.

Fixes: e4e6ec7b127c ("ASoC: stm32: Add I2S driver")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20261004043451.1138613-1-mhun512@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/stm/stm32_i2s.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/sound/soc/stm/stm32_i2s.c b/sound/soc/stm/stm32_i2s.c
index 2f277e5390ddd..d47f47f505acc 100644
--- a/sound/soc/stm/stm32_i2s.c
+++ b/sound/soc/stm/stm32_i2s.c
@@ -1025,7 +1025,7 @@ static int stm32_i2s_parse_dt(struct platform_device *pdev,
 	const struct of_device_id *of_id;
 	struct reset_control *rst;
 	struct resource *res;
-	int irq, ret;
+	int ret;
 
 	if (!np)
 		return -ENODEV;
@@ -1070,16 +1070,6 @@ static int stm32_i2s_parse_dt(struct platform_device *pdev,
 			return ret;
 	}
 
-	/* Get irqs */
-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0)
-		return irq;
-
-	ret = devm_request_irq(&pdev->dev, irq, stm32_i2s_isr, 0,
-			       dev_name(&pdev->dev), i2s);
-	if (ret)
-		return ret;
-
 	/* Reset */
 	rst = devm_reset_control_get_optional_exclusive(&pdev->dev, NULL);
 	if (IS_ERR(rst))
@@ -1105,7 +1095,7 @@ static int stm32_i2s_probe(struct platform_device *pdev)
 {
 	struct stm32_i2s_data *i2s;
 	u32 val;
-	int ret;
+	int irq, ret;
 
 	i2s = devm_kzalloc(&pdev->dev, sizeof(*i2s), GFP_KERNEL);
 	if (!i2s)
@@ -1131,6 +1121,15 @@ static int stm32_i2s_probe(struct platform_device *pdev)
 		return dev_err_probe(&pdev->dev, PTR_ERR(i2s->regmap),
 				     "Regmap init error\n");
 
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
+
+	ret = devm_request_irq(&pdev->dev, irq, stm32_i2s_isr, 0,
+			       dev_name(&pdev->dev), i2s);
+	if (ret)
+		return ret;
+
 	ret = snd_dmaengine_pcm_register(&pdev->dev, &stm32_i2s_pcm_config, 0);
 	if (ret)
 		return ret;
-- 
2.53.0



