Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591486;
	b=yYm4OhO4csXOA0N+yicKZF34hj2IMRLacfneFJgVLBMuehfrKf4oYOluhh72m+VNZtd+
	 Cyb6dECBe3YtcpYuTuLWOSS5RUZcj2GhVyjtUAbIxlwW+z9JxLlwzpPbCDjdWbBxacsCL
	 OjC6V96nE5Q5DqAKm/RIpF4EA0JFXIeSFD9Mf81JHWzrfd1qOI5dQeBTqDqaaGQpfpW4X
	 fJTPP9LmLyjfph5KYI0rPKVcriiNFO0vIHzFSJwiKaVeEMuEBIMv5pdQRYA4kojUrD2NI
	 CpTVAeQqEKp76x5BQTkRGLetYcoZqQUDsePxUHEe3xhvhIXhL+qgU0Ky8Vl/Ad5Pcog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591486;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EE8Z/ggQhBt8bHI5q+9wlICx4PJCOtcmUis9HuQfLkw=;
	b=rXhkVirydcPzuYisCGe9zTznpel9EESHYNyE2VbRBflQfMtWrpm9eSE7iaeutkeaMJZo
	 gJ3KOvQ9frmnzM3VLCfyivd7/C9+yLR+5914CihVLUtqqSV1h6CdncRH0kdGoSrlt4cXn
	 zFQ7GnI7jptn/A4qG0SK3txlRoE0Odk23X24JHqf1mmqr9UuEYTAWBKM9agEx/6+dcs91
	 cRuX+FnfCxjzQHGPa8iLtLPva2sj5LgfxPmmK52ThXBhRABe44Dy4MH2sB764qKOQ25RB
	 ae/WoZoVoofELwpLg8GB+oQ8tXGzP9pzACUyLoXQlM3HXxRt+V02SxinlWNHABEv9ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z00hvaN9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E200607E060;
	Fri, 13 Nov 2026 17:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z00hvaN9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73AC51F000C7;
	Fri, 13 Nov 2026 17:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591485;
	bh=EE8Z/ggQhBt8bHI5q+9wlICx4PJCOtcmUis9HuQfLkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z00hvaN9h6Kni5DO+Ax1BWiFR23VDC4dCd0/rh6FYB2/Ge1Nb0U65qsmgxyLZfVH5
	 NcXJgrFwkE9n/Par4yPplndLONtkn32I80cGchKWiTX//aw5qAc9DbzY6xhvn2sgqH
	 PoVsF8f2SzhppnfMsgdfae8tx+/X91ME+99BMvdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 515/670] ASoC: stm: stm32_i2s: request IRQ after regmap initialization
Date: Fri, 13 Nov 2026 10:51:19 -0500
Message-ID: <20261113153829.391865292@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5b15b8fb87c39..d62802f4f12e3 100644
--- a/sound/soc/stm/stm32_i2s.c
+++ b/sound/soc/stm/stm32_i2s.c
@@ -1026,7 +1026,7 @@ static int stm32_i2s_parse_dt(struct platform_device *pdev,
 	struct device_node *np = pdev->dev.of_node;
 	struct reset_control *rst;
 	struct resource *res;
-	int irq, ret;
+	int ret;
 
 	if (!np)
 		return -ENODEV;
@@ -1069,16 +1069,6 @@ static int stm32_i2s_parse_dt(struct platform_device *pdev,
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
@@ -1103,7 +1093,7 @@ static int stm32_i2s_probe(struct platform_device *pdev)
 {
 	struct stm32_i2s_data *i2s;
 	u32 val;
-	int ret;
+	int irq, ret;
 
 	i2s = devm_kzalloc(&pdev->dev, sizeof(*i2s), GFP_KERNEL);
 	if (!i2s)
@@ -1129,6 +1119,15 @@ static int stm32_i2s_probe(struct platform_device *pdev)
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



