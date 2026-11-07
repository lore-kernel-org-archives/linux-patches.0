Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064433;
	b=O7ydQQz/PjgcZHyYi/CFYiYFktDzdEJH5ukintULn+w1yRxno+BdE0gHBQdY0eej6V+8
	 67a0+Dxp6J+iOY/GDnWKWMTpnIBQ2JgFszCXnwQlh2VtsdAqIA/sXFknZpMy3GpsQlgkU
	 yVBX0Bn6J/gredFCuUjOWxLiE1TV0Y2ej1hzaMCP5I+CMUmMRkWLnPmA4qs8tPxAxlWh0
	 dR7P+oUuD+LoO2IXx7E1eiHNX76FgM12u14soyQyBM85WEYImMJnKAUYagcLMVh5Wu6r9
	 UEEQUbn/wgbPF/jqywNPVInhbknvs42kqHa0rfsZbGrK2OLsXWXBo2PMEyNE6C3OmNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064433;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=egVZ9hUkjBeDX9Ra9ZPZsxl40D9O8q9JDRjM4K+6/4w=;
	b=5WB5lyYPhY+MxeANBMCyGiIARHjYkALfVAT3lViEJN2g1uzG2sf7O1NUHBqkJP4q9rXF
	 zukNBgYdPBxpXVpWOm6k5/la8timgOU68SKX3gKbCcO/JFIgq3Kl8KB3V5+5b2q7GXqeb
	 2R5KoyHG3w2xo4JBhVCVHKLfzkRL6apvPxfo39HmrvCKPGQJ4q41+hMyKz6nyWa1Zxef4
	 Ut9PuqTOQm2sBuLW1OH6q7A+G/mrlE8wTCwqIVJrZIR9pplQTeDW3P7XDhyFyea1z62gz
	 rL1DnQjTqXgV1bOf5HwymgWAI7kdMCwIm33IxZ1J57EAuhPb0t+5C2KLggvZbwok5VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E3kZSh6C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA29606A9C9;
	Sat,  7 Nov 2026 15:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E3kZSh6C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74AF31F0089F;
	Sat,  7 Nov 2026 15:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064432;
	bh=egVZ9hUkjBeDX9Ra9ZPZsxl40D9O8q9JDRjM4K+6/4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E3kZSh6CGlVNwM0oPvgonetACvxgLBa+K5bU2gpycWmW1U+vcHwxVXF8H23zyWncj
	 645S1F7LVXYysJg0Vk8OBBcN3kuyv8fWIPvN4FhXGV4IOmz3Xm/f4q2rmv+LlV0QNT
	 ucJfeje0q64mXpXlVT/I6xxHVmz1S7+Q/XK2QNZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0480/1257] ASoC: stm: stm32_i2s: request IRQ after regmap initialization
Date: Sat,  7 Nov 2026 08:46:16 -0500
Message-ID: <20261107134952.706821988@linuxfoundation.org>
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
index 83b51893b37c8..7fcf23bd0aff2 100644
--- a/sound/soc/stm/stm32_i2s.c
+++ b/sound/soc/stm/stm32_i2s.c
@@ -1185,7 +1185,7 @@ static int stm32_i2s_parse_dt(struct platform_device *pdev,
 	struct device_node *np = pdev->dev.of_node;
 	struct reset_control *rst;
 	struct resource *res;
-	int irq, ret;
+	int ret;
 
 	if (!np)
 		return -ENODEV;
@@ -1231,16 +1231,6 @@ static int stm32_i2s_parse_dt(struct platform_device *pdev,
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
@@ -1265,7 +1255,7 @@ static int stm32_i2s_probe(struct platform_device *pdev)
 {
 	struct stm32_i2s_data *i2s;
 	u32 val;
-	int ret;
+	int irq, ret;
 
 	i2s = devm_kzalloc(&pdev->dev, sizeof(*i2s), GFP_KERNEL);
 	if (!i2s)
@@ -1291,6 +1281,15 @@ static int stm32_i2s_probe(struct platform_device *pdev)
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



