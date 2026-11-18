Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038287;
	b=C9MMFvbzjrM5HElEep5TqBTTrBQXsJXyrSjIZwIrLcApyQsGKMwODKMSRNZpTfa5f6le
	 S9jYHHJIxeXEzD8kImYVl23gLKgn27vtrgIxKVjDG/xf9O8V2IaZbUpOt9GEnYhy02Cbu
	 NOqsGsxUfQPMKwXM1VMDKJZesF7NmtdST2Gho227PrjQDkgz/UOCb0Zl41AlK3l0brHsR
	 ZVvUao8nevbUZyTB28qO1XdL80VutVbkKkpZgGAUGB199OEvYWUBxnEzBNmC8+9BoiSyg
	 w0Bs+aZkp7ofbrVaHSMblpQ2KmB5kF3Tu/gcbSqmBLFszjEvrAHcU4UC72Njr2V/gXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038287;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4739ACt6mmhDzVThY3ctI/XLx1mUtQt58zf6x/gsyMQ=;
	b=MbajeIJg8V243ddqYWp/nM2sTUtPed8OaB6egiKqyxREjvVCVPSoDJwbMS+UyJrC6Gaq
	 Xvxx2jDbFkA/RySvVzaF0eXIsNYF64qePbkBUL4ymihBskNO3eSxCqKvqnXtV/nW8MJYW
	 JST4friyrT40ZMlhyiroAgGazSK1hicqicXGHofdK9akiCYPZDwESdHfMfLuYZjI9iCRh
	 KIuYxud6tSPCcQ5SZRFiKWcOSXa8n7sndBvn0bKkxIyydoP9r1EBcCBLc35X4MTL7L1Ak
	 0PMCdf3HK7mN/RLjA3x+gYKHfKJVR1whPOQGvlmWKT5VuFdiCSWPjgeHu3FDC7csBAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ciFQIcWV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ECD7606A325;
	Wed, 18 Nov 2026 21:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ciFQIcWV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744A51F000C4;
	Wed, 18 Nov 2026 21:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038287;
	bh=4739ACt6mmhDzVThY3ctI/XLx1mUtQt58zf6x/gsyMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ciFQIcWVt33iD0NdVz7DP2lQz830sks+fB9f1nV7mXCKnsfts92r0nTfVn5dnkMxf
	 m5vmmRgcs2NnfkyvP9tFzI9qV+Q4gKTol1Tl4OBTKijaujRZ0s8xnkq2coX7i/Hh+k
	 zVgzPxNrygFDXUAZlaVLnPeKWlTmhs6voWWcr/cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1689/3318] ASoC: stm: stm32_i2s: request IRQ after regmap initialization
Date: Wed, 18 Nov 2026 15:38:31 +0100
Message-ID: <20261118150412.496674311@linuxfoundation.org>
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
index 4e4d8d0ed7bd7..2da8aeb256bcb 100644
--- a/sound/soc/stm/stm32_i2s.c
+++ b/sound/soc/stm/stm32_i2s.c
@@ -1027,7 +1027,7 @@ static int stm32_i2s_parse_dt(struct platform_device *pdev,
 	const struct of_device_id *of_id;
 	struct reset_control *rst;
 	struct resource *res;
-	int irq, ret;
+	int ret;
 
 	if (!np)
 		return -ENODEV;
@@ -1072,16 +1072,6 @@ static int stm32_i2s_parse_dt(struct platform_device *pdev,
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
@@ -1106,7 +1096,7 @@ static int stm32_i2s_probe(struct platform_device *pdev)
 {
 	struct stm32_i2s_data *i2s;
 	u32 val;
-	int ret;
+	int irq, ret;
 
 	i2s = devm_kzalloc(&pdev->dev, sizeof(*i2s), GFP_KERNEL);
 	if (!i2s)
@@ -1132,6 +1122,15 @@ static int stm32_i2s_probe(struct platform_device *pdev)
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



