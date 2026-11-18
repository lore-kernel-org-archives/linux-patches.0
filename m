Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059517;
	b=5Ke7/G0JEcyMicphgwl+lf6WCeroNNRo2l2o9ihCjUh9OPl1rmpCsuGFiMhFoG77+UnE
	 b13X3PNYdJSvkD6f0KqiiRCBkTVhbLGw1m58/rI3x/LEE1Z+EEUKYaGnOC1pgtRQZinQI
	 K00HCsGvIxjN1NmhQPze0qgjCb9ouY5co/IWf6ZfYnBh5Sm+zpMWsljzh/Wzho7HdB/NV
	 GIrRKfqP4FwIEnwrRk5tTLqKldk3nwpM+ODh63tUCKhfFoMZdWTiNNyuecInw21tQZp4k
	 7ueDpXnTBlAQ1vT0FClQ6+TxYXTPpDaOe2cqhgfpaJ8cSUOKS5POouE9zTG4fYYYJrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059517;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=onC3pjdXlkDzSXPWeAvi7Xudd8zi7ByjTMlogqq53eo=;
	b=oy9mtDoqCbbATSs6bWQmENz6OheMBfcFfB5MZ5G7xWhnY5ScBo1nY3lWhwGkdEgFF12z
	 kSFCyfDr2Rx/EcA+Xwuq9ForIIYAYZZxTlsBFH+jJpHp5bT1QnOnvoSnUQ9vfoPUG9RTO
	 e2cmmTNBTvzmVCmW04ib+cPmO1WWbvQ108eg5qNHXjAUJKUiNmmZuWA0nEWFVz/wi+lQN
	 cL08eT6w1lQei7IjshS4zKjsOZcHlhd5FAapOUfOx0ZTuESGQIBanKNKpLC2sc8uIQF83
	 lM7HbrppcjTJIr40RWPXQqbE4vxuG5h7FqmqXCC81eoF4SLYRJSo5P+HXddzwBMFbdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZfciMPD1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA33606A325;
	Thu, 19 Nov 2026 03:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZfciMPD1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69BAB1F000C9;
	Thu, 19 Nov 2026 03:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059517;
	bh=onC3pjdXlkDzSXPWeAvi7Xudd8zi7ByjTMlogqq53eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZfciMPD1nUQ41fpokS5imbZg4f4vxh5sB8/L7sIuivMluTHbnInoF8lRD8v1kRbZd
	 V+BunFgj6JOqWeiyjqfgMA0eL2kgt1Vb8OytyWtFLeDu8oVxhPuQiDvNvX7QcEcFns
	 mV+8beO9Y/jurQQCjSacGpiRgoSE3Ie3Z73ybMj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0870/1848] ASoC: stm: stm32_i2s: request IRQ after regmap initialization
Date: Wed, 18 Nov 2026 15:48:28 +0100
Message-ID: <20261118145952.872382764@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Removed the unused ret declaration from stm32_i2s_parse_dt() because the newer clock setup code is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/stm/stm32_i2s.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/sound/soc/stm/stm32_i2s.c b/sound/soc/stm/stm32_i2s.c
index 4a6869d535d4f..63fde986018c7 100644
--- a/sound/soc/stm/stm32_i2s.c
+++ b/sound/soc/stm/stm32_i2s.c
@@ -810,7 +810,6 @@ static int stm32_i2s_parse_dt(struct platform_device *pdev,
 	const struct of_device_id *of_id;
 	struct reset_control *rst;
 	struct resource *res;
-	int irq, ret;
 
 	if (!np)
 		return -ENODEV;
@@ -849,16 +848,6 @@ static int stm32_i2s_parse_dt(struct platform_device *pdev,
 		return dev_err_probe(&pdev->dev, PTR_ERR(i2s->x11kclk),
 				     "Could not get x11k parent clock\n");
 
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
@@ -884,7 +873,7 @@ static int stm32_i2s_probe(struct platform_device *pdev)
 {
 	struct stm32_i2s_data *i2s;
 	u32 val;
-	int ret;
+	int irq, ret;
 
 	i2s = devm_kzalloc(&pdev->dev, sizeof(*i2s), GFP_KERNEL);
 	if (!i2s)
@@ -910,6 +899,15 @@ static int stm32_i2s_probe(struct platform_device *pdev)
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



