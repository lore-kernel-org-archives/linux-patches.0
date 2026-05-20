Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4240369999;
	Wed, 20 May 2026 17:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297750; cv=none; b=mmRGupFsf3KpI1f2JMjc4uL1fRSDbHdz7JhP4zITc72bnRmwCS1vUyw4CqqB30OVq2ULooeWNSfbiWDUdZUdtvgqLMQTnQZFac8OmMQKrrhTxbxxfZ9890XHR1SCoL3CZuVAU5UZG015enP0K++Z8uJ+/7nC+cSxnPhizXeKmg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297750; c=relaxed/simple;
	bh=xZiaYPjOWOJslRbm/nduc8PZ6k2Zg8fCPHIbukC/ETY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GhbFmRY3Q5Liv9TwNHYGqbQl1xJtO4Ia1AZ7/iRKhKqlCPr2u2wE2r9CsKvoDsrPBik4ocgPY9eq7SBd4sVV56czEYEH7FIzfDM6muJBfDaI3HSlwr0eBOvkAiCfCQzC5N0ODeqAL+j/pubZDPnbyI/hLUB1SU9gkR4DMjSecr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M8WUeArl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M8WUeArl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DFEF1F000E9;
	Wed, 20 May 2026 17:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297748;
	bh=OiLM4A7K0yqVE6QfMPzfnK8mz5vaZjERfOZQ2nJeRvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M8WUeArlK8hP2cA0Ym3GRPWDZlQ7b5pdc1pm9X8Uqwxt2gb9FEhcY3+MYvPsdpWUF
	 ezKKVYDcFiZ1VkXjR3V/pxNVlrxjDnjpcFJdW73UhaHI/aP0VAD7QXxX03GDxILzP9
	 m764vSarGVADeVPUA/+eDWyWB8wJyZqXxk+b+ETw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 149/957] net: airoha: Add airoha_eth_soc_data struct
Date: Wed, 20 May 2026 18:10:32 +0200
Message-ID: <20260520162137.785483056@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 5863b4e065e2253ef05684f728a04e4972046bcb ]

Introduce airoha_eth_soc_data struct to contain differences between
various SoC. Move XSI reset names in airoha_eth_soc_data. This is a
preliminary patch to enable AN7583 ethernet controller support in
airoha-eth driver.

Co-developed-by: Christian Marangi <ansuelsmth@gmail.com>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20251017-an7583-eth-support-v3-4-f28319666667@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 02f729643959 ("net: airoha: Fix FE_PSE_BUF_SET configuration if PPE2 is available")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 42 +++++++++++++++++++-----
 drivers/net/ethernet/airoha/airoha_eth.h | 17 ++++++++--
 2 files changed, 48 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index 060865b98880e..5162f2a689000 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -1406,8 +1406,7 @@ static int airoha_hw_init(struct platform_device *pdev,
 	int err, i;
 
 	/* disable xsi */
-	err = reset_control_bulk_assert(ARRAY_SIZE(eth->xsi_rsts),
-					eth->xsi_rsts);
+	err = reset_control_bulk_assert(eth->soc->num_xsi_rsts, eth->xsi_rsts);
 	if (err)
 		return err;
 
@@ -2943,6 +2942,7 @@ static int airoha_register_gdm_devices(struct airoha_eth *eth)
 
 static int airoha_probe(struct platform_device *pdev)
 {
+	struct reset_control_bulk_data *xsi_rsts;
 	struct device_node *np;
 	struct airoha_eth *eth;
 	int i, err;
@@ -2951,6 +2951,10 @@ static int airoha_probe(struct platform_device *pdev)
 	if (!eth)
 		return -ENOMEM;
 
+	eth->soc = of_device_get_match_data(&pdev->dev);
+	if (!eth->soc)
+		return -EINVAL;
+
 	eth->dev = &pdev->dev;
 
 	err = dma_set_mask_and_coherent(eth->dev, DMA_BIT_MASK(32));
@@ -2975,13 +2979,18 @@ static int airoha_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	eth->xsi_rsts[0].id = "xsi-mac";
-	eth->xsi_rsts[1].id = "hsi0-mac";
-	eth->xsi_rsts[2].id = "hsi1-mac";
-	eth->xsi_rsts[3].id = "hsi-mac";
-	eth->xsi_rsts[4].id = "xfp-mac";
+	xsi_rsts = devm_kzalloc(eth->dev,
+				eth->soc->num_xsi_rsts * sizeof(*xsi_rsts),
+				GFP_KERNEL);
+	if (err)
+		return err;
+
+	eth->xsi_rsts = xsi_rsts;
+	for (i = 0; i < eth->soc->num_xsi_rsts; i++)
+		eth->xsi_rsts[i].id = eth->soc->xsi_rsts_names[i];
+
 	err = devm_reset_control_bulk_get_exclusive(eth->dev,
-						    ARRAY_SIZE(eth->xsi_rsts),
+						    eth->soc->num_xsi_rsts,
 						    eth->xsi_rsts);
 	if (err) {
 		dev_err(eth->dev, "failed to get bulk xsi reset lines\n");
@@ -3074,8 +3083,23 @@ static void airoha_remove(struct platform_device *pdev)
 	platform_set_drvdata(pdev, NULL);
 }
 
+static const char * const en7581_xsi_rsts_names[] = {
+	"xsi-mac",
+	"hsi0-mac",
+	"hsi1-mac",
+	"hsi-mac",
+	"xfp-mac",
+};
+
+static const struct airoha_eth_soc_data en7581_soc_data = {
+	.version = 0x7581,
+	.xsi_rsts_names = en7581_xsi_rsts_names,
+	.num_xsi_rsts = ARRAY_SIZE(en7581_xsi_rsts_names),
+	.num_ppe = 2,
+};
+
 static const struct of_device_id of_airoha_match[] = {
-	{ .compatible = "airoha,en7581-eth" },
+	{ .compatible = "airoha,en7581-eth", .data = &en7581_soc_data },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, of_airoha_match);
diff --git a/drivers/net/ethernet/airoha/airoha_eth.h b/drivers/net/ethernet/airoha/airoha_eth.h
index 3e43f01e9a652..655bc6acd80f0 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.h
+++ b/drivers/net/ethernet/airoha/airoha_eth.h
@@ -21,7 +21,6 @@
 #define AIROHA_MAX_NUM_IRQ_BANKS	4
 #define AIROHA_MAX_DSA_PORTS		7
 #define AIROHA_MAX_NUM_RSTS		3
-#define AIROHA_MAX_NUM_XSI_RSTS		5
 #define AIROHA_MAX_MTU			9216
 #define AIROHA_MAX_PACKET_SIZE		2048
 #define AIROHA_NUM_QOS_CHANNELS		4
@@ -556,9 +555,18 @@ struct airoha_ppe {
 	struct dentry *debugfs_dir;
 };
 
+struct airoha_eth_soc_data {
+	u16 version;
+	const char * const *xsi_rsts_names;
+	int num_xsi_rsts;
+	int num_ppe;
+};
+
 struct airoha_eth {
 	struct device *dev;
 
+	const struct airoha_eth_soc_data *soc;
+
 	unsigned long state;
 	void __iomem *fe_regs;
 
@@ -568,7 +576,7 @@ struct airoha_eth {
 	struct rhashtable flow_table;
 
 	struct reset_control_bulk_data rsts[AIROHA_MAX_NUM_RSTS];
-	struct reset_control_bulk_data xsi_rsts[AIROHA_MAX_NUM_XSI_RSTS];
+	struct reset_control_bulk_data *xsi_rsts;
 
 	struct net_device *napi_dev;
 
@@ -611,6 +619,11 @@ static inline bool airhoa_is_lan_gdm_port(struct airoha_gdm_port *port)
 	return port->id == 1;
 }
 
+static inline bool airoha_is_7581(struct airoha_eth *eth)
+{
+	return eth->soc->version == 0x7581;
+}
+
 bool airoha_is_valid_gdm_port(struct airoha_eth *eth,
 			      struct airoha_gdm_port *port);
 
-- 
2.53.0



