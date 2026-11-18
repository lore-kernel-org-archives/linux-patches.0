Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029895;
	b=y14JHF+vIUGSWbUBc/jMePisTXhuf9QsnpXlO9X4nUtWGUVFZF2GcYa1ZPbdhtjkI+7S
	 bBY+DN3ZE2g3slTgkQ2DbVCpacqFMRm8fhrrJVX/zASg+RFsHB7nJRW3vLbk9OKHxbyHQ
	 NZJItJI7PafFYJuz1cy7YRZnhlstmOVoRDdgSaRnQBcEq3jBlSL8giA3OkKVfh9QaPIvP
	 8uubLrKnRJ/ZWrTKScF2Ih4m/MP2lgb1s33s1F3J+U6pxOVIf9N8N1UJeT6Z16IlbhZ0S
	 pfYcD5DgoAJhD4fhBYyRWOCP5gEsd6qYOxP20TaFTSj72pvVeRA+LMWNJRCPNG3szug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029895;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=evY8JGrhC+iat87U9eg6KK6h3tkkB5Jujqrv/h/skEg=;
	b=i4smvIoBz64nBgzIg00O27d5+h7qlfY0wY/uZgBgssNv7xcdo07Um70C2SR7Nicxgvp3
	 3EYpDQBKOTlfx0NLRcElWn2PHW7q4ZMeKhBhgL9+Qw+23tlnYfUto006n7JvRyyabex7F
	 v/MqxJdop5VwQuhf7BWeViUrR95Mmc8QPI0A2n9v1nnCwv1D7KOgom/o4rjzC6zw3A7RG
	 wpLnPuxMM9eSviGmQbAqeuW8wjGXLJ0namBHmjPrHg0shDVRIFoLMP3Pb6Fi/y5BliyjN
	 d8Jo3xGXv8RyDKEhv623wD324N5s/n24CLtI0m5fQ5RNuGgXPcCEgrYc1uCrQiLHsZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CLFLDZ89;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB6A606A32C;
	Wed, 18 Nov 2026 19:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CLFLDZ89
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819BA1F000CB;
	Wed, 18 Nov 2026 19:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029895;
	bh=evY8JGrhC+iat87U9eg6KK6h3tkkB5Jujqrv/h/skEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CLFLDZ89JA0YyTtCuQxZNiXUcMTe75cHoBtJhubvESsXuDtRUJ1DoiZWrazNoY8iX
	 fjOqEwi/My2Q/agqvOAsXmugA9q2DdKR7BNGKWMFzWLXNSYInTn5UFYXHo68zvNJjK
	 nJAmoQNh3U/BCd0GRgt+05TN4B61juywX+Y1iN7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0510/1756] hwrng: starfive - propagate clock and reset errors
Date: Wed, 18 Nov 2026 15:43:57 +0100
Message-ID: <20261118150029.489406883@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit ace145efdd80cd2eb95e84b1087d0f1fc55bdc0d ]

The StarFive TRNG probe and resume paths ignore failures from their clock
and reset operations. That lets the driver register or resume while its
hardware access prerequisites were not established.

Check each transition, unwind only the previously enabled clock on failure,
and propagate the error to the probe or PM core.

Fixes: c388f458bc34 ("hwrng: starfive - Add TRNG driver for StarFive SoC")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/jh7110-trng.c | 39 +++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/char/hw_random/jh7110-trng.c b/drivers/char/hw_random/jh7110-trng.c
index 4712c3c530e42..6bfd52f5d1b1e 100644
--- a/drivers/char/hw_random/jh7110-trng.c
+++ b/drivers/char/hw_random/jh7110-trng.c
@@ -321,9 +321,17 @@ static int starfive_trng_probe(struct platform_device *pdev)
 		return dev_err_probe(&pdev->dev, PTR_ERR(trng->rst),
 				     "Error getting hardware reset line\n");
 
-	clk_prepare_enable(trng->hclk);
-	clk_prepare_enable(trng->ahb);
-	reset_control_deassert(trng->rst);
+	ret = clk_prepare_enable(trng->hclk);
+	if (ret)
+		return ret;
+
+	ret = clk_prepare_enable(trng->ahb);
+	if (ret)
+		goto disable_hclk;
+
+	ret = reset_control_deassert(trng->rst);
+	if (ret)
+		goto disable_ahb;
 
 	trng->rng.name = dev_driver_string(&pdev->dev);
 	trng->rng.init = starfive_trng_init;
@@ -343,13 +351,18 @@ static int starfive_trng_probe(struct platform_device *pdev)
 		pm_runtime_disable(&pdev->dev);
 
 		reset_control_assert(trng->rst);
-		clk_disable_unprepare(trng->ahb);
-		clk_disable_unprepare(trng->hclk);
-
-		return dev_err_probe(&pdev->dev, ret, "Failed to register hwrng\n");
+		ret = dev_err_probe(&pdev->dev, ret, "Failed to register hwrng\n");
+		goto disable_ahb;
 	}
 
 	return 0;
+
+disable_ahb:
+	clk_disable_unprepare(trng->ahb);
+disable_hclk:
+	clk_disable_unprepare(trng->hclk);
+
+	return ret;
 }
 
 static int __maybe_unused starfive_trng_suspend(struct device *dev)
@@ -365,11 +378,17 @@ static int __maybe_unused starfive_trng_suspend(struct device *dev)
 static int __maybe_unused starfive_trng_resume(struct device *dev)
 {
 	struct starfive_trng *trng = dev_get_drvdata(dev);
+	int ret;
 
-	clk_prepare_enable(trng->hclk);
-	clk_prepare_enable(trng->ahb);
+	ret = clk_prepare_enable(trng->hclk);
+	if (ret)
+		return ret;
 
-	return 0;
+	ret = clk_prepare_enable(trng->ahb);
+	if (ret)
+		clk_disable_unprepare(trng->hclk);
+
+	return ret;
 }
 
 static const struct dev_pm_ops starfive_trng_pm_ops = {
-- 
2.53.0



