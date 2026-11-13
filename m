Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585926;
	b=GmiLKbs08TPH2KCLQVo2dJQkODU6IBno0AgSBQjkA25K1yeC0D+FQ0rUcj9qW+l1+EDF
	 y0uNAHN3SblAEGsmWV4nxX7Gr8z6FPmrjxRZCm3ybTTOHF0+uNRoKCMJzIXqDfK3CJZmX
	 FITG2VCtHDJwAO98krdZYx6aCXwY4JDZluXOG0u0JcMTiM0phtY1ljUr+Mirl8GMMxgka
	 aFsv/pL4HJWLm/GzQ34JzMHnLyMw/3VHfefb7ndQ+RWBK6TaSr4bEg7H7KwvomgzEgxxP
	 0hM0MCYiAYOUS0YUWAEUlyEHabFKlySsqmROJl/F/sr8EC8z1OhAX67BOICqh8xOFyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585926;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1lS+9O+x98+qJw29gfF7Uin1tCdrOJYkiLCrUgQ5gr0=;
	b=Vl2hB+Ic+ErvD6Cv6n1Jun6gvhCbWGtPE06IDseJ5+Glgu28FWEPGvIpFPm4qyTzZMkn
	 cs1y7vG/xzXljLFTIngx/KBPo+Ascb0jKG/b2ZZ7SwsryuObRl713711t0l9sj3Yby2+3
	 c6oaOyH+zjcoDS+O7sYuy94SJB7YLG6FHHAzaaYVEreG5xrbZy+iASksz34Pfedm7wzLk
	 K3pGXG5+XSJR4JpTNd1vQ2uGm+zyX6Rv1HmcpxpWUQJvLiEbypJhKvUSVpyzKFUNmwlSS
	 TmqOVAq/zdCFixj85yz1GUnH0eXGOIRd0gJ8OPnCAckFZlqB8kUMJ4L9pnBe+JW4sSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nR6dP5Hg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD27606A33D;
	Fri, 13 Nov 2026 16:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nR6dP5Hg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 364211F000C4;
	Fri, 13 Nov 2026 16:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585926;
	bh=1lS+9O+x98+qJw29gfF7Uin1tCdrOJYkiLCrUgQ5gr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nR6dP5Hgr488Q5GKpa+3Bu41pChhBcl2/YjWEfKgMlGMKhvs5wnwdzeFjUGF56O/t
	 GPou1/GZl1MGS+3bNAzAf5HpOfQ4CjtAvlKRAKsjjAyfVLQQn0m3mGYYH0fDqy7jY6
	 3VJTR6YLYRv+Ixr3eqnry1sz9YytUi9BE4wVpl6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Aksh Garg <a-garg7@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 486/507] PCI: cadence: Store the core controller in platform drvdata
Date: Fri, 13 Nov 2026 10:53:10 -0500
Message-ID: <20261113153813.545413568@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit cfe96ce583c51bf6e034d4038c652a1e8227867c ]

cdns_plat_pcie_probe() stores a struct cdns_plat_pcie pointer with
platform_set_drvdata(). cdns_plat_pcie_shutdown() and the callbacks in
cdns_pcie_pm_ops retrieve the same pointer with dev_get_drvdata() but use
it as a struct cdns_pcie pointer. This makes them read phy_count and phy
beyond the wrapper.

struct cdns_plat_pcie only contains a pointer to struct cdns_pcie. Drop
the redundant wrapper and store the struct cdns_pcie pointer directly.

Fixes: bd22885aa188 ("PCI: cadence: Refactor driver to use as a core library")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Aksh Garg <a-garg7@ti.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260915082826.4135665-1-lilinmao@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../controller/cadence/pcie-cadence-plat.c    | 27 ++++++-------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/pci/controller/cadence/pcie-cadence-plat.c b/drivers/pci/controller/cadence/pcie-cadence-plat.c
index 5900d68c6e83a..abda260543c8b 100644
--- a/drivers/pci/controller/cadence/pcie-cadence-plat.c
+++ b/drivers/pci/controller/cadence/pcie-cadence-plat.c
@@ -14,14 +14,6 @@
 
 #define CDNS_PLAT_CPU_TO_BUS_ADDR	0x0FFFFFFF
 
-/**
- * struct cdns_plat_pcie - private data for this PCIe platform driver
- * @pcie: Cadence PCIe controller
- */
-struct cdns_plat_pcie {
-	struct cdns_pcie        *pcie;
-};
-
 static const struct of_device_id cdns_plat_pcie_of_match[];
 
 static u64 cdns_plat_cpu_addr_fixup(struct cdns_pcie *pcie, u64 cpu_addr)
@@ -36,9 +28,9 @@ static const struct cdns_pcie_ops cdns_plat_ops = {
 static int cdns_plat_pcie_probe(struct platform_device *pdev)
 {
 	const struct cdns_plat_pcie_of_data *data;
-	struct cdns_plat_pcie *cdns_plat_pcie;
 	struct device *dev = &pdev->dev;
 	struct pci_host_bridge *bridge;
+	struct cdns_pcie *pcie;
 	struct cdns_pcie_ep *ep;
 	struct cdns_pcie_rc *rc;
 	bool is_rc;
@@ -51,11 +43,6 @@ static int cdns_plat_pcie_probe(struct platform_device *pdev)
 	is_rc = data->is_rc;
 
 	pr_debug(" Started %s with is_rc: %d\n", __func__, is_rc);
-	cdns_plat_pcie = devm_kzalloc(dev, sizeof(*cdns_plat_pcie), GFP_KERNEL);
-	if (!cdns_plat_pcie)
-		return -ENOMEM;
-
-	platform_set_drvdata(pdev, cdns_plat_pcie);
 	if (is_rc) {
 		if (!IS_ENABLED(CONFIG_PCIE_CADENCE_PLAT_HOST))
 			return -ENODEV;
@@ -67,9 +54,9 @@ static int cdns_plat_pcie_probe(struct platform_device *pdev)
 		rc = pci_host_bridge_priv(bridge);
 		rc->pcie.dev = dev;
 		rc->pcie.ops = &cdns_plat_ops;
-		cdns_plat_pcie->pcie = &rc->pcie;
+		pcie = &rc->pcie;
 
-		ret = cdns_pcie_init_phy(dev, cdns_plat_pcie->pcie);
+		ret = cdns_pcie_init_phy(dev, pcie);
 		if (ret) {
 			dev_err(dev, "failed to init phy\n");
 			return ret;
@@ -94,9 +81,9 @@ static int cdns_plat_pcie_probe(struct platform_device *pdev)
 
 		ep->pcie.dev = dev;
 		ep->pcie.ops = &cdns_plat_ops;
-		cdns_plat_pcie->pcie = &ep->pcie;
+		pcie = &ep->pcie;
 
-		ret = cdns_pcie_init_phy(dev, cdns_plat_pcie->pcie);
+		ret = cdns_pcie_init_phy(dev, pcie);
 		if (ret) {
 			dev_err(dev, "failed to init phy\n");
 			return ret;
@@ -114,13 +101,15 @@ static int cdns_plat_pcie_probe(struct platform_device *pdev)
 			goto err_init;
 	}
 
+	platform_set_drvdata(pdev, pcie);
+
 	return 0;
 
  err_init:
  err_get_sync:
 	pm_runtime_put_sync(dev);
 	pm_runtime_disable(dev);
-	cdns_pcie_disable_phy(cdns_plat_pcie->pcie);
+	cdns_pcie_disable_phy(pcie);
 
 	return 0;
 }
-- 
2.53.0



