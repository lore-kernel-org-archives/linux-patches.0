Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024139;
	b=O/p2I+44mNyKBbqAxHgOvqAZHNuxgRfooHrln4IML7aKOmAN557osoJJMw3JSxcHT9vZ
	 Kk2QmlvB49RD04WRy6QYQ9oX+SJfSe/nAGaZJqchVABpum6k9bUwVM9TBhhlplvGzqc73
	 CWtXM9N84sia0OD6FOK4zifq7QnmZNzVzaGFj+WqD4FaOy6aRfQEckA3v++OIffkwpzOM
	 YN1Uh4sdjgUybtGHY1Q0nm9Q5ZNiDp80Y77CZ+P2okmJPoAeF5sMIJh4VGO7ElUN49lMJ
	 DABB2o/IPNr4vwxHICxdamkX1HROiPHQ+Cl4Q8H/1HJCXEiaUZf4AYhjmscn+KhEhTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024139;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Kw7azbzqhJ4Nd7dlmBzn1Il7WjmVkHFk1+XI+REtViE=;
	b=0IGluJHGptBxUnzul5/2rU6EPHmVGjBD1ip/Gi09TgJtOuTIw/6nkYoRqQ0+Qonv+SwU
	 H4cnjP2Cyeaxt47pqOUB5aPQhY161EMeUFf4Vl8i85uaZ4vtBKp2l4109ARhZF2aiLttD
	 IB4W61DT3H2Liqy9FgtzNTnw3qmNtethQ6JqBhIMVeJzWfHzynwlFyiYDteKWyezr2Jy1
	 ImeflFgSxM0NoIrmJWl63U6/3DqSaULnGb92WEsHnCwvru8/tT9MhfVzLI/JfJttiLXn0
	 j4h068QKiJKnlEJP6gYfanW4YmDbm/Db5X27gfOvdbxeJzRN/APMO9iI2YLpfJ0VaTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1qxDKetw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA20606A333;
	Wed, 18 Nov 2026 17:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1qxDKetw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2735A1F000C7;
	Wed, 18 Nov 2026 17:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024138;
	bh=Kw7azbzqhJ4Nd7dlmBzn1Il7WjmVkHFk1+XI+REtViE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1qxDKetwarzX5FwaI6/Y85eNRqh5U2e5GcNX7ZmPw43FkRncfrPmUIiTzCJLOke5K
	 HQm/K85/vF3PuTRAhCdhLOjztLkDVv2EcIRmemG7JfJolHz/UPTig/kGdHGzCZAEFG
	 bsubFclLhIuvXWegyBl3WnDhym0UI8m61ww2Jo6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0620/2151] hwrng: starfive - propagate clock and reset errors
Date: Wed, 18 Nov 2026 15:39:15 +0100
Message-ID: <20261118150144.496708456@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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



