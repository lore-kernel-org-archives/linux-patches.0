Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51722BCF4C;
	Sat, 12 Sep 2026 18:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238346; cv=none; b=r/TsbtihtR1joujVII+6D6yquhyenz2e/bcNp0lQAWRUTBV5Ri8vCDiKnPsvH8BlfoQGlfgGPOMuezHC1bkcXCTcCd4Xx7s0hTaIWbdAYj8AJS6eaYfVi/JWikz1vC/hT+RkgEIYspyJeAGatMBuu2B/IjOaqVoP0hU3pqdpDbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238346; c=relaxed/simple;
	bh=rCVFmGTpF7L+q/6VRX02k0MYsosFkQ3nyuY/ClNtgco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dbiTB9EIOFhsc/LLj6QfpLr4eG2Pf4Y4x+rXdVWbjsMX6MaY6EmCE+IPWhIVUadETErBbpati3W3FccRzFQnn+l+jDxOIc6gFqB8QmhXnDKEc6GPNfenE9OmotWGxzMpBdZGoXFEISeM71AAm9+JtJJ1N+DkU+CiPQ5sCH7vl6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iQ0CQG1C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iQ0CQG1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7DC41F000FF;
	Sat, 12 Sep 2026 18:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238344;
	bh=/3NkUTbYZy2P61oCHwiAyZKPia+kr4//qYcD68FBx1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iQ0CQG1CZgulGkjnRApxo1ihFu3CZlC3847gRNUGbYA81NXxFn6k5h2lj3bV9Gjvi
	 7ifZcK5ZeNppQTMpKGzYD3BFbn/zLgw1XJEfjfjQMrmk5fE664qv+ZZUFs6Fz4dnJY
	 DsVcd+dLKinMmXSgSCRJV0WQW6wMtqvD5GVoCrj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tang Bin <tangbin@cmss.chinamobile.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 441/935] crypto: sa2ul - Use the defined variable to clean code
Date: Sat, 12 Sep 2026 08:57:51 +0200
Message-ID: <20260912065536.945476218@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tang Bin <tangbin@cmss.chinamobile.com>

[ Upstream commit 284340a368a034243d304bd64e5f6923780e3708 ]

Use the defined variable "dev" to make the code cleaner.

Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: d03f980a2585 ("crypto: sa2ul - stop probe if context pool creation fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sa2ul.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 05849a1c86f35..1cd81918580b0 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -2411,8 +2411,7 @@ static int sa_ul_probe(struct platform_device *pdev)
 	pm_runtime_enable(dev);
 	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0) {
-		dev_err(&pdev->dev, "%s: failed to get sync: %d\n", __func__,
-			ret);
+		dev_err(dev, "%s: failed to get sync: %d\n", __func__, ret);
 		pm_runtime_disable(dev);
 		return ret;
 	}
@@ -2434,16 +2433,16 @@ static int sa_ul_probe(struct platform_device *pdev)
 
 	sa_register_algos(dev_data);
 
-	ret = of_platform_populate(node, NULL, NULL, &pdev->dev);
+	ret = of_platform_populate(node, NULL, NULL, dev);
 	if (ret)
 		goto release_dma;
 
-	device_for_each_child(&pdev->dev, &pdev->dev, sa_link_child);
+	device_for_each_child(dev, dev, sa_link_child);
 
 	return 0;
 
 release_dma:
-	sa_unregister_algos(&pdev->dev);
+	sa_unregister_algos(dev);
 
 	dma_release_channel(dev_data->dma_rx2);
 	dma_release_channel(dev_data->dma_rx1);
@@ -2452,8 +2451,8 @@ static int sa_ul_probe(struct platform_device *pdev)
 destroy_dma_pool:
 	dma_pool_destroy(dev_data->sc_pool);
 
-	pm_runtime_put_sync(&pdev->dev);
-	pm_runtime_disable(&pdev->dev);
+	pm_runtime_put_sync(dev);
+	pm_runtime_disable(dev);
 
 	return ret;
 }
-- 
2.53.0



