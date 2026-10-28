Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210698;
	b=my7rZg5dNJI3revEx17FyNg4mdQlZUbEdPit/fuF23IBkOeFPdqB+at9P86eAoWeF9kN
	 fsG8NxRxEbJ0V+CwY6KYiulkGA63oSphfQhmXr8UJ74tybMbjOC1BOJThH3D0o2001UXQ
	 q+4jPNllIqxu/n1XcJ0xiwzHp2tUGFHZOa+eI4q7SimY6X7elKOSTRVshShQpWlplesUg
	 t3yGTZwRTtaS4xHagv8GRUrm8qD6g4klkLA1POTrVa7jEAD9OwznB48Arn1yCGKh99MOr
	 Uv0VkTXADFYKjWHjyyqIn2i92dMluKfrDrAU1g2Na3Ae4tPfl81QQbBJijSumvMFrHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210698;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LOo8FIGIRtbR4g8nLVw4EBZhqTW2Altb+cCYxs6Kd3k=;
	b=h0rRdc9XRB9ozOLI3JcXVt3SsOGhD35K+2TrEp7e8iOE+0C94Lln+8flK19tFLd7aHaC
	 J4aSpofEuc0L3dlKzkoeAi3OCqsORjyZoDTljpPUFCbmrVaAE9lPFlkDPr7qlYVFfdkYy
	 mdeHFomyIRgxR5yOo5xqy9b9vIzl52cmq4HFPGiXL5FoR+3FE/GD4N7kALCpNI0PhwHt8
	 myGuW/Gj0HdTtpNRLECKsCoVqnQ15MelauejEVLqR1EhWDC8unZ/jw65IUNJxLC1U/fqh
	 Dhu2n9r0FPPd8BnfnIg0bpJz/9oDDxlLCPfeXkEowA1g2dRv9ZbbBQmrOew4o3OhlIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qfdfGYRs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F170E606A31A;
	Wed, 28 Oct 2026 18:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qfdfGYRs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CAEA1F01825;
	Wed, 28 Oct 2026 18:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210697;
	bh=LOo8FIGIRtbR4g8nLVw4EBZhqTW2Altb+cCYxs6Kd3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qfdfGYRswMPtTGwrQ4eat7tuC7Aa0iA/aJoULV47DHVz2ogqxdS1Yw79+L8vbbvfo
	 MSFqM6cQyLfQkac8hOtXnp1WGOjJYi316yGOuVUF+tzjoe8w8qzEX06iGLzl7QixlP
	 KupOsUe3eZXHKnpvaUFdS02KuVDxxxU+ukof1jC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Jianzheng <wangjianzheng@vivo.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 116/571] pinctrl: sunxi: Use devm_clk_get_enabled() helpers
Date: Wed, 28 Oct 2026 17:54:23 +0100
Message-ID: <20261028170010.772557632@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Wang Jianzheng <wangjianzheng@vivo.com>

[ Upstream commit 7dc92ece32ed87a352e285e3d9f0d392b61443e2 ]

sunxi sunxi_pinctrl_init_with_variant get, enable clk and
deinit_device disable and unprepare it.

This simplifes the code and avoids the calls to
clk_disable_unprepare().

Signed-off-by: Wang Jianzheng <wangjianzheng@vivo.com>
Link: https://lore.kernel.org/20240829064737.16169-1-wangjianzheng@vivo.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: a13f7f5d14af ("pinctrl: sunxi: keep a shadow copy of the data register output latches")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sunxi/pinctrl-sunxi.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.c b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
index f384bfec6c393..7c895ddcb970a 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
@@ -1577,30 +1577,26 @@ int sunxi_pinctrl_init_with_variant(struct platform_device *pdev,
 	}
 
 	ret = of_clk_get_parent_count(node);
-	clk = devm_clk_get(&pdev->dev, ret == 1 ? NULL : "apb");
+	clk = devm_clk_get_enabled(&pdev->dev, ret == 1 ? NULL : "apb");
 	if (IS_ERR(clk)) {
 		ret = PTR_ERR(clk);
 		goto gpiochip_error;
 	}
 
-	ret = clk_prepare_enable(clk);
-	if (ret)
-		goto gpiochip_error;
-
 	pctl->irq = devm_kcalloc(&pdev->dev,
 				 pctl->desc->irq_banks,
 				 sizeof(*pctl->irq),
 				 GFP_KERNEL);
 	if (!pctl->irq) {
 		ret = -ENOMEM;
-		goto clk_error;
+		goto gpiochip_error;
 	}
 
 	for (i = 0; i < pctl->desc->irq_banks; i++) {
 		pctl->irq[i] = platform_get_irq(pdev, i);
 		if (pctl->irq[i] < 0) {
 			ret = pctl->irq[i];
-			goto clk_error;
+			goto gpiochip_error;
 		}
 	}
 
@@ -1611,7 +1607,7 @@ int sunxi_pinctrl_init_with_variant(struct platform_device *pdev,
 	if (!pctl->domain) {
 		dev_err(&pdev->dev, "Couldn't register IRQ domain\n");
 		ret = -ENOMEM;
-		goto clk_error;
+		goto gpiochip_error;
 	}
 
 	for (i = 0; i < (pctl->desc->irq_banks * IRQ_PER_BANK); i++) {
@@ -1643,8 +1639,6 @@ int sunxi_pinctrl_init_with_variant(struct platform_device *pdev,
 
 	return 0;
 
-clk_error:
-	clk_disable_unprepare(clk);
 gpiochip_error:
 	gpiochip_remove(pctl->chip);
 	return ret;
-- 
2.53.0



