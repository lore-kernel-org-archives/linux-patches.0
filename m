Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590668;
	b=xKFS+IHMfGTfQtzwQNAf+WD9CoC/AjeBr1g8WzVN02HVs5euTbbtagICwKkmSXcF0HgE
	 V4NBnRKT5R83gG/ujttOQWpadG34ZBJOONnloYR5251T3ZloZjedM/BvX/QIfe7oKM00Z
	 QI5cE80O1bek2f+306JAqL1xQyA97E2r3bBBvptPti39U4BNC5FysasVv8PuM1xCnxUf/
	 Jk/XvmfCepYu3LKzjlDnLAElSno3PuTae+ss++v4DyO+Wp2JpAs+YaC/0et5vKWrvFose
	 vaohciCwqTYxYozKX1jzqxbi16qI7YKG4CyrvEyY1BTWVmaXA8M8ILG6dNlTvVNRqSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590668;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WjTQXzdgGVw3NJ5/Ym8pdUbzOgp191HRzbCZfspPsnU=;
	b=u4d5UMxqBIkm+AnNl1ur3+fSKcT3ebGRONEyHvw3ae3q1ef4gcdR8aBzxX2fu0CyFk18
	 AMAVtvYJgp2bqcrE8I9dvDtTKqjehXyIfPPN3UfNkYc5RBJ7s1WOsM+5Uz1nigxiGru0C
	 WpRN/YFvote9vXT48XkouPbHJ0A3pPc48vI2X9/KpkQccv716sT+c83OP0Au/D31mwtny
	 g+ssFdX695IAZ4u1MBUGfgKH20FL8H4OVpz5Iy/aoVUPLbEYWZ1taqJN3exHYI9BlixoM
	 Ok5yWy7/+h24EzsY0/5wRNB01c6B4imm4j6emotYC1iHcUR3pCizkuIXmva51kgieTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C9ptT7pM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062EE606B212;
	Fri, 13 Nov 2026 17:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C9ptT7pM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A681F000C5;
	Fri, 13 Nov 2026 17:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590667;
	bh=WjTQXzdgGVw3NJ5/Ym8pdUbzOgp191HRzbCZfspPsnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C9ptT7pMUCMW6KnYvmgGwnw2Gf1Mm+SoIok+FJg/D9qhWoroOIaLOj7ontUt0uajC
	 uMr56VVf3qVgWDh/WGHRPN2mVVDL+SFACCgFxYUMS/TsUA9aySJNoU8YHhbC4P8Ize
	 +LshpG1i7K2mGXutrK3IgoOOQvPqwDq9p4pNmDn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 557/686] ASoC: stm: stm32_i2s: request IRQ after regmap initialization
Date: Fri, 13 Nov 2026 10:51:30 -0500
Message-ID: <20261113153840.460985972@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index 100a50a88d6d6..ab06d13a59b9f 100644
--- a/sound/soc/stm/stm32_i2s.c
+++ b/sound/soc/stm/stm32_i2s.c
@@ -1192,7 +1192,7 @@ static int stm32_i2s_parse_dt(struct platform_device *pdev,
 	struct device_node *np = pdev->dev.of_node;
 	struct reset_control *rst;
 	struct resource *res;
-	int irq, ret;
+	int ret;
 
 	if (!np)
 		return -ENODEV;
@@ -1238,16 +1238,6 @@ static int stm32_i2s_parse_dt(struct platform_device *pdev,
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
@@ -1272,7 +1262,7 @@ static int stm32_i2s_probe(struct platform_device *pdev)
 {
 	struct stm32_i2s_data *i2s;
 	u32 val;
-	int ret;
+	int irq, ret;
 
 	i2s = devm_kzalloc(&pdev->dev, sizeof(*i2s), GFP_KERNEL);
 	if (!i2s)
@@ -1298,6 +1288,15 @@ static int stm32_i2s_probe(struct platform_device *pdev)
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



