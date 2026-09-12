Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0490D2F12AC;
	Sat, 12 Sep 2026 19:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242364; cv=none; b=uiPppAsH3z3Q5phTOSYkIe3VlsfY3ISxdilzn+ZI8pzuLmOCn0+LMYCFAN9wp5VF5oz30dg90SDPY8STqXh27HtCuG2q/siG1obfKHvUx6lMrDQzk+DFTcOSc4qs2g+yXnajLIOqKiLcafzkLuKtUnY/ESSyag5pXGN4Yj72xfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242364; c=relaxed/simple;
	bh=+vcUkOENH4Utw2ZjiKXbAuTr4VhPsXK9IAHlCWGIZdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SSvHuO5u7yioQwL9acxkVdEDmWa1lv6XQ6av+tSH9Qm7GTRuAu/RxsPvyB4daJg93k6qQOnHmtDWs/dimSb0vW6/Kay7pbkEfxGwety4T/gOR9/TnhQ6wlVidGho8XaAaVz4WfVZLzjieKR4XDOrZKSRjxEroV61wDTMXjXSNrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ff1+O+vz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ff1+O+vz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F7F1F000FF;
	Sat, 12 Sep 2026 19:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242362;
	bh=xi493yib0GNB8oowwmRtWZ5kuMzfARwOM/lAvoJW7Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ff1+O+vzjX4CILSf9Z44abvfoYcAE+VB3wYaV6xiCvDKtL5TuR98PtbLdr8YN5tQT
	 mHJVrq3DTJYPtugHV427nVCOToqnpx2OygpWl8zU+txCfpZNI61YSawzvHMze20i8c
	 Z3yLB4D0QxFSL7iRqtfdzOC4FIPYhW1qL46AZM7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tang Bin <tangbin@cmss.chinamobile.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 375/798] crypto: sa2ul - Use the defined variable to clean code
Date: Sat, 12 Sep 2026 09:00:03 +0200
Message-ID: <20260912065525.751396398@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6fa1a5b414ee5..69af26d561827 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -2353,8 +2353,7 @@ static int sa_ul_probe(struct platform_device *pdev)
 	pm_runtime_enable(dev);
 	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0) {
-		dev_err(&pdev->dev, "%s: failed to get sync: %d\n", __func__,
-			ret);
+		dev_err(dev, "%s: failed to get sync: %d\n", __func__, ret);
 		pm_runtime_disable(dev);
 		return ret;
 	}
@@ -2377,16 +2376,16 @@ static int sa_ul_probe(struct platform_device *pdev)
 
 	sa_register_algos(dev);
 
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
@@ -2395,8 +2394,8 @@ static int sa_ul_probe(struct platform_device *pdev)
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



