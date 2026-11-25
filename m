Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622384;
	b=i6BetK1Bq5XY7lVdFqqKlufmpe/GXlOJp+LQaMRwe5qdD+cXyYoG2aZ58HknS52WRgbZ
	 psQMe4rZF+ucm1SXnIBppfWPmZcRwOq16nkaOABdHKejnNtlqAm7J9++23vT+zOsIUTdj
	 R6NAWZGgogsYKYtm66n9lDnmhcjiqkFioBIHVU3fFAUYFap7KNYznqBdjHyYX9+KBY9yN
	 5cHoZ51QuPEG2GYoXpcYvVbtrkBUhx7hpB9onyde/gsK7anckY8+7wxFv23WM/EZK97cB
	 CRUpfSJ63+maMaQH3uMuKrXT662mD6uAbmde+JFAG7lID/ZJ26w+olIj2Y069DNKqlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622384;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jeOkO+Xu5B67TVCJC//Cj17OxSaqGgyzcXKxDZf075U=;
	b=An0QeVbKP6kreKmiO4tZzkZG7LPtRsiIm1mX6fl09xOyU/5pYBKY+E+ks9khL6qh28qG
	 11lry6WEa1Bf1wQLmpm6NuDVvaIKCsFBI52l3A1/DiZxH9W51StTtPVirNd1XHAae7E7L
	 v4kqNDllwNe4mbEa9YuFw3qDrhoQyrUmmbWZAdjyiZJOYj/BcPCRplJaki9bHYCA+Y1we
	 d41HSnaTT5dGqL9weVUymIZ97jSk3OM5ckp+cEaglm/1qz4/g6b4d+/sfUENIo4GPBkuW
	 BVCKp9J8QQfXPxrQnQfKF/cy6hLQ44PGnJpb/4zqwAJtrix8fGphTtHi4xnJtuOKs2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FPytR15i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4329606A321;
	Wed, 25 Nov 2026 15:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FPytR15i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16421F000C0;
	Wed, 25 Nov 2026 15:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622384;
	bh=jeOkO+Xu5B67TVCJC//Cj17OxSaqGgyzcXKxDZf075U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FPytR15iPrxB23uc6tvtmi/6Bhz4CNKUj8PEAKTrzvA4R8c4F1jq33SBTQzC20oEH
	 qsoyK8azasEoGBLmzyiHr+w7j5H49rF7mDLdZu2yCctWipP/E/h3KmOG+dMY8tGNgJ
	 7QQosKdDcXchga3hKHmGqYtyty5KNYFTOAbJlNLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaliy Sochnev <sochnev.v.74@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 520/990] thermal/drivers/airoha: Request the EN7581 IRQ after zone registration
Date: Wed, 25 Nov 2026 15:31:27 +0100
Message-ID: <20261125143834.276699857@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Vitaliy Sochnev <sochnev.v.74@gmail.com>

[ Upstream commit 7efceedd23678cd58e98b2c64d4b2b7be03f6cf9 ]

The EN7581 IRQ is requested before the thermal zone is registered, and
the handler passes priv->tz to thermal_zone_device_update(). Unbind
leaves the monitor interrupt enabled, so an interrupt pending on the
next bind fires while priv->tz is NULL. On a Nokia XG-040G-MD this
oopses in thermal_zone_device_update(). On unbind, devres also frees the
zone before the IRQ.

Request the IRQ in post_probe, after zone registration.

Fixes: 42de37f40e1b ("thermal/drivers: Add support for Airoha EN7581 thermal sensor")
Signed-off-by: Vitaliy Sochnev <sochnev.v.74@gmail.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Link: https://patch.msgid.link/20260915194128.42508-1-sochnev.v.74@gmail.com
[ sashal: Moved the IRQ request to after thermal zone registration in the single probe function, since this tree lacks the split post_probe and regmap code, keeping the local handler name and dev_err. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/airoha_thermal.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/thermal/airoha_thermal.c b/drivers/thermal/airoha_thermal.c
index 829a7327fc403..a971c0b986ac2 100644
--- a/drivers/thermal/airoha_thermal.c
+++ b/drivers/thermal/airoha_thermal.c
@@ -437,18 +437,6 @@ static int airoha_thermal_probe(struct platform_device *pdev)
 	of_address_to_resource(chip_scu_np, 0, &priv->scu_adc_res);
 	of_node_put(chip_scu_np);
 
-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0)
-		return irq;
-
-	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
-					airoha_thermal_irq, IRQF_ONESHOT,
-					pdev->name, priv);
-	if (ret) {
-		dev_err(dev, "Can't get interrupt working.\n");
-		return ret;
-	}
-
 	airoha_thermal_setup_monitor(priv);
 	airoha_thermal_setup_adc_val(dev, priv);
 
@@ -461,6 +449,19 @@ static int airoha_thermal_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, priv);
 
+	/* After zone registration: the handler uses priv->tz */
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
+
+	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+					airoha_thermal_irq, IRQF_ONESHOT,
+					pdev->name, priv);
+	if (ret) {
+		dev_err(dev, "Can't get interrupt working.\n");
+		return ret;
+	}
+
 	/* Enable LOW and HIGH interrupt */
 	writel(EN7581_HOFSINTEN0 | EN7581_LOFSINTEN0,
 	       priv->base + EN7581_TEMPMONINT);
-- 
2.53.0



