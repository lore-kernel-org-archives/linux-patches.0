Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016550;
	b=tKrLPYruL6aNij7zoO+Sr+cxpnm4sgAR+X71Ar17cdU2zZXsGzn6G6oS22ZtNAqsnk0T
	 UilVe6QWrgupvKdQXlTj2iEcBETVTk/Dog49pYFP1RDprTfh/jnimyTNIN9hZaNqYDbWl
	 nFiB3amhV1B59g7/lB38CEBfaqqHPopPAf4oKMFBs92L9805Fke8NSBKePpqfHHtkyzdy
	 HkD9Qte8OfqX07rwLeZ5l5b9bXZ0+6E36Xu9SCrtp+/Z+HU8zCoNAWN8QF43oP+rHi5sl
	 TaEMjoj2DEI0ICREm6rx4lVv/mnGnaaoaynlzY1xDYOSDk+M4kFUKH54AyFBmsL6LyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016550;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X8LSnUl++ySvlYrWoxGkviymI0EDO6u8qNhu3h7jMZ8=;
	b=jtQVD1qh0lkee7fOEDC3Ff3KWlsEdSQqhXOk3RYLhAC/eedt9KrXteQL4e8CbXaagXkb
	 j+BE4ssMU9O+7STtO6+glGw0QZgman9HpkOq+FHNgSDr93YI80QP/RngknbHganm+QwuG
	 YnYq5OmzWpQ2i73ApfXi+q7fVRY8cdCrdV5GCF1MDNYA+6tsJb9SDqKyFkGU++OO7mNXa
	 OyIg1kvwsrzAZhT1Pon9g78mcifbH7xxZJ4sFl26/sa+64lNnP5FSKPBHTs48HCh8BCoJ
	 hkiLg4dTWjs3Qr58IpEHFij9V7xdXmkM+wvjcMvH/LC7/drM+WRiPMYBrae6AyyyWhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eDTIUWVV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060AA606A335;
	Wed, 18 Nov 2026 15:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eDTIUWVV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584401F000C4;
	Wed, 18 Nov 2026 15:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016549;
	bh=X8LSnUl++ySvlYrWoxGkviymI0EDO6u8qNhu3h7jMZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eDTIUWVV9Qh5pjETe8koWCYfGE0TYQ3bD2q8ebIXAkJaVtFxpmw3ko+arN25oMfzo
	 9FxrY6rMj3R8UuDZG/JfzP/YWKOTvK+EJDDAfRNT5pHX3Z2QQCMquskdD/FZHT3/UM
	 xqyR6nQOvplJczzcN6aXxi3YYOLatNvimclcLKrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaliy Sochnev <sochnev.v.74@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0569/2651] thermal/drivers/airoha: Request the EN7581 IRQ after zone registration
Date: Wed, 18 Nov 2026 15:30:09 +0100
Message-ID: <20261118150308.222468784@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/airoha_thermal.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/thermal/airoha_thermal.c b/drivers/thermal/airoha_thermal.c
index 77b3a1af271fd..ea3e2649c280c 100644
--- a/drivers/thermal/airoha_thermal.c
+++ b/drivers/thermal/airoha_thermal.c
@@ -528,7 +528,7 @@ static int en7581_thermal_probe(struct platform_device *pdev,
 	struct device_node *chip_scu_np;
 	struct device *dev = &pdev->dev;
 	void __iomem *base;
-	int i, irq, ret;
+	int i;
 
 	base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(base))
@@ -567,16 +567,6 @@ static int en7581_thermal_probe(struct platform_device *pdev,
 	of_address_to_resource(chip_scu_np, 0, &priv->scu_adc_res);
 	of_node_put(chip_scu_np);
 
-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0)
-		return irq;
-
-	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
-					en7581_thermal_irq, IRQF_ONESHOT,
-					pdev->name, priv);
-	if (ret)
-		return ret;
-
 	en7581_thermal_setup_monitor(priv);
 	en7581_thermal_setup_adc_val(dev, priv);
 
@@ -586,6 +576,18 @@ static int en7581_thermal_probe(struct platform_device *pdev,
 static int en7581_thermal_post_probe(struct platform_device *pdev)
 {
 	struct airoha_thermal_priv *priv = platform_get_drvdata(pdev);
+	int irq, ret;
+
+	/* After zone registration: the handler uses priv->tz */
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
+
+	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+					en7581_thermal_irq, IRQF_ONESHOT,
+					pdev->name, priv);
+	if (ret)
+		return ret;
 
 	/* Enable LOW and HIGH interrupt (if supported) */
 	regmap_write(priv->map, EN7581_TEMPMONINT,
-- 
2.53.0



