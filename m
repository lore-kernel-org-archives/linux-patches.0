Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480FF1A7262;
	Wed, 20 Nov 2024 12:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107581; cv=none; b=EbPW0qA1U9GcF9a1B+8XV5/34o6KgVjXfk2u1ix/6J4TuY3JxbIjQoDp8V25zcbMKYvztHGdl4OuunYjodEYV2tH1drBXMUGqarf9SlBoqlo6TJ+Za00Kcu/tCqHrEpluyAqnr6+kOIbCsl1kxb4qKDMYODT1HSFVUKkCwbke1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107581; c=relaxed/simple;
	bh=97WX+sZJqbMNoO6BQfJhl/yUh1AE3sowOGh3YUEVhrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUPEOuvfzfMG1hspxuV7J4d5slWQjYFB66Wp/omLKf3puQOd8K2WSPzCJgFVc3RCGe9VQIMAGydMO4opDHz6LZheMQVUa/MMjzOOuuRbYKsdvkKPEsDF6OhPxh9hA7kgv2bYFeZK7mlPwS9d0WbMjkv0nOv0JLk7szgAilSkzNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qj7XhAGr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qj7XhAGr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DC7C4CECD;
	Wed, 20 Nov 2024 12:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107581;
	bh=97WX+sZJqbMNoO6BQfJhl/yUh1AE3sowOGh3YUEVhrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qj7XhAGrrJ2Ap4fYZXKa/LCuKTlMEEnAb7ROV/JU3E+oQC8tA5gZys4PnAcBny2xF
	 ikacha+AZEDn6sv8mCtGpqYhuCpQevbcZRBZI+be7ZaRZ2NHFun1Kq/p+Y130dRtVB
	 ARlUZQKTmcfcu+/edMQ3EZ3TJo6x6scAUcjP6NuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 22/82] net: stmmac: rename stmmac_pltfr_remove_no_dt to stmmac_pltfr_remove
Date: Wed, 20 Nov 2024 13:56:32 +0100
Message-ID: <20241120125630.110279802@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 2c9fc838067b02cb3e6057fef5cd7cf1c04a95aa ]

Now, all users of the old stmmac_pltfr_remove() are converted to the
devres helper, it's time to rename stmmac_pltfr_remove_no_dt() back to
stmmac_pltfr_remove() and remove the old stmmac_pltfr_remove().

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 5b366eae7193 ("stmmac: dwmac-intel-plat: fix call balance of tx_clk handling routines")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../stmicro/stmmac/dwmac-intel-plat.c         |  2 +-
 .../ethernet/stmicro/stmmac/dwmac-visconti.c  |  3 +--
 .../ethernet/stmicro/stmmac/stmmac_platform.c | 23 +++----------------
 .../ethernet/stmicro/stmmac/stmmac_platform.h |  1 -
 4 files changed, 5 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
index d1aec2ca2b429..70edc5232379f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
@@ -164,7 +164,7 @@ static void intel_eth_plat_remove(struct platform_device *pdev)
 {
 	struct intel_dwmac *dwmac = get_stmmac_bsp_priv(&pdev->dev);
 
-	stmmac_pltfr_remove_no_dt(pdev);
+	stmmac_pltfr_remove(pdev);
 	clk_disable_unprepare(dwmac->tx_clk);
 }
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
index 45f5d66a11c26..a5a5cfa989c6e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
@@ -256,8 +256,7 @@ static int visconti_eth_dwmac_probe(struct platform_device *pdev)
 
 static void visconti_eth_dwmac_remove(struct platform_device *pdev)
 {
-	stmmac_pltfr_remove_no_dt(pdev);
-
+	stmmac_pltfr_remove(pdev);
 	visconti_eth_clock_remove(pdev);
 }
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 30d5e635190e6..b4fdd40be63cb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -810,7 +810,7 @@ static void devm_stmmac_pltfr_remove(void *data)
 {
 	struct platform_device *pdev = data;
 
-	stmmac_pltfr_remove_no_dt(pdev);
+	stmmac_pltfr_remove(pdev);
 }
 
 /**
@@ -837,12 +837,12 @@ int devm_stmmac_pltfr_probe(struct platform_device *pdev,
 EXPORT_SYMBOL_GPL(devm_stmmac_pltfr_probe);
 
 /**
- * stmmac_pltfr_remove_no_dt
+ * stmmac_pltfr_remove
  * @pdev: pointer to the platform device
  * Description: This undoes the effects of stmmac_pltfr_probe() by removing the
  * driver and calling the platform's exit() callback.
  */
-void stmmac_pltfr_remove_no_dt(struct platform_device *pdev)
+void stmmac_pltfr_remove(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
@@ -851,23 +851,6 @@ void stmmac_pltfr_remove_no_dt(struct platform_device *pdev)
 	stmmac_dvr_remove(&pdev->dev);
 	stmmac_pltfr_exit(pdev, plat);
 }
-EXPORT_SYMBOL_GPL(stmmac_pltfr_remove_no_dt);
-
-/**
- * stmmac_pltfr_remove
- * @pdev: platform device pointer
- * Description: this function calls the main to free the net resources
- * and calls the platforms hook and release the resources (e.g. mem).
- */
-void stmmac_pltfr_remove(struct platform_device *pdev)
-{
-	struct net_device *ndev = platform_get_drvdata(pdev);
-	struct stmmac_priv *priv = netdev_priv(ndev);
-	struct plat_stmmacenet_data *plat = priv->plat;
-
-	stmmac_pltfr_remove_no_dt(pdev);
-	stmmac_remove_config_dt(pdev, plat);
-}
 EXPORT_SYMBOL_GPL(stmmac_pltfr_remove);
 
 /**
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.h b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.h
index c5565b2a70acc..bb07a99e1248b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.h
@@ -32,7 +32,6 @@ int stmmac_pltfr_probe(struct platform_device *pdev,
 int devm_stmmac_pltfr_probe(struct platform_device *pdev,
 			    struct plat_stmmacenet_data *plat,
 			    struct stmmac_resources *res);
-void stmmac_pltfr_remove_no_dt(struct platform_device *pdev);
 void stmmac_pltfr_remove(struct platform_device *pdev);
 extern const struct dev_pm_ops stmmac_pltfr_pm_ops;
 
-- 
2.43.0



