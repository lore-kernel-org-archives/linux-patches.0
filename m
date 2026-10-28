Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215410;
	b=Qr80FLuZxjLiWzho1NRW8e6RQ/kShVG0aW8+o672a6EeYQ8C44IcFU0isFwBwUtIj63n
	 LoJTv/FcBt398mvWoSJMs3Yuyhq4copMUSj8qS2h7UrfRyuP6zmPDHfkt4rkqxd8WEnrF
	 r546XPcjKDPWxkaOnOK2m6gf/j3OOA8bAmRsy/R02HTgYbhat1ZOxsgD53jvfNsvIm3Ha
	 Tx8gWVhnZjMlNyz9veBm2lOEvvHnOWO3Nr08MALOo5zsmXI98jRx2yLjHVMBFcFF70Fz4
	 XnGJuheQhzZVbKWfr0gRC79bv4jBDGzCcIi2Wjoh3Mkld5qFSSVImnUWGsGciEv+nKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215410;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=POI+87iN7BUt0gXg5u6bQfSuwCnrXx6jW4Izi7Bg9y0=;
	b=IHw/ust1tgsMB7XNGCmVlqTSNFJYnlckpWv0rgpxaPokSElrJYq8RwfGIDvPN16kt+Sk
	 iwMtaoiSzIVrTqP/Wp0ivhujoRPXF8wMFMJ1LC4emJ58y2OaAcCr5NHjKED0u51ZjdHfA
	 /AJsrqfh7T4TppELM7D5TGpll05yyl5N4uInAybrd+Lo56Zm035ab/DVEOHXBsMuVKMuC
	 VWWDUCabANvlLm7oWQ/UvDo33hg7DN0wCHH0W//ipKbG6FnPyxJMU/xlktxcaXPBjK5/F
	 pGcVdpMi6QXEpAmWl9hXBTwusCIArEm2hENz+mFPfZMqZoy5xv7qzXEdLwYzwaPTTyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ujnz8pzP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B65606A31A;
	Wed, 28 Oct 2026 19:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ujnz8pzP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F041F01825;
	Wed, 28 Oct 2026 19:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215410;
	bh=POI+87iN7BUt0gXg5u6bQfSuwCnrXx6jW4Izi7Bg9y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ujnz8pzPkMod7Jbo4aoLsun72ix7Y//MdGhEJPPWyzLvq5cghAoCOu5/SDIlR7fB3
	 bsEhA0ss9ENnlE5sCHGWUuyvuHG+MGZVqpfbhE1ohJMM+YnvXhb3uN2K15O6UwWevh
	 /yOOVEUrfOdq3SJdD8iv+bGuD6CoHMOwyQD39ZTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoniu Zhou <guoniu.zhou@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1201/1887] pmdomain: imx93-blk-ctrl: Extract PHY as shared domain for DSI/CSI
Date: Wed, 28 Oct 2026 17:54:57 +0100
Message-ID: <20261028170526.735412472@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guoniu Zhou <guoniu.zhou@oss.nxp.com>

[ Upstream commit 99611233f8cda833169fa6487d5dacdf189e5cb0 ]

The MIPI DSI and CSI domains share control bits for clock and reset, which
can lead to incorrect behavior if one domain disables the shared resource
while the other is still active.

To fix the issue, introduce a shared MIPI PHY power domain to own the
common resources and make DSI and CSI its subdomains. This ensures the
shared bits are properly managed and not disabled while still in use.

Fixes: e9aa77d413c9 ("soc: imx: add i.MX93 media blk ctrl driver")
Cc: stable@vger.kernel.org
Signed-off-by: Guoniu Zhou <guoniu.zhou@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/imx93-blk-ctrl.c | 50 ++++++++++++++++++++++++++++++--
 1 file changed, 47 insertions(+), 3 deletions(-)

diff --git a/drivers/soc/imx/imx93-blk-ctrl.c b/drivers/soc/imx/imx93-blk-ctrl.c
index 955e084c9d11b..ef15562ded14e 100644
--- a/drivers/soc/imx/imx93-blk-ctrl.c
+++ b/drivers/soc/imx/imx93-blk-ctrl.c
@@ -47,6 +47,8 @@
 
 #define PRIO(X)			(X)
 
+#define BLK_CTRL_NO_PARENT	UINT_MAX
+
 struct imx93_blk_ctrl_domain;
 
 struct imx93_blk_ctrl {
@@ -73,6 +75,7 @@ struct imx93_blk_ctrl_domain_data {
 	int num_clks;
 	u32 rst_mask;
 	u32 clk_mask;
+	u32 parent;
 	int num_qos;
 	struct imx93_blk_ctrl_qos qos[DOMAIN_MAX_QOS];
 };
@@ -272,18 +275,46 @@ static int imx93_blk_ctrl_probe(struct platform_device *pdev)
 		bc->onecell_data.domains[i] = &domain->genpd;
 	}
 
+	for (i = 0; i < bc_data->num_domains; i++) {
+		struct imx93_blk_ctrl_domain *domain = &bc->domains[i];
+		const struct imx93_blk_ctrl_domain_data *data = domain->data;
+
+		if (data->parent == BLK_CTRL_NO_PARENT)
+			continue;
+
+		ret = pm_genpd_add_subdomain(&bc->domains[data->parent].genpd,
+					     &domain->genpd);
+		if (ret) {
+			dev_err_probe(dev, ret, "failed to add subdomain %s\n",
+				      domain->genpd.name);
+			goto cleanup_links;
+		}
+	}
+
 	pm_runtime_enable(dev);
 
 	ret = of_genpd_add_provider_onecell(dev->of_node, &bc->onecell_data);
 	if (ret) {
 		dev_err_probe(dev, ret, "failed to add power domain provider\n");
-		goto cleanup_pds;
+		goto cleanup_links;
 	}
 
 	dev_set_drvdata(dev, bc);
 
 	return 0;
 
+cleanup_links:
+	for (i = 0; i < bc_data->num_domains; i++) {
+		struct imx93_blk_ctrl_domain *domain = &bc->domains[i];
+
+		if (domain->data->parent == BLK_CTRL_NO_PARENT)
+			continue;
+
+		pm_genpd_remove_subdomain(&bc->domains[domain->data->parent].genpd,
+					  &domain->genpd);
+	}
+	i = bc_data->num_domains;
+
 cleanup_pds:
 	for (i--; i >= 0; i--)
 		pm_genpd_remove(&bc->domains[i].genpd);
@@ -314,8 +345,9 @@ static const struct imx93_blk_ctrl_domain_data imx93_media_blk_ctl_domain_data[]
 		.name = "mediablk-mipi-dsi",
 		.clk_names = (const char *[]){ "dsi" },
 		.num_clks = 1,
-		.rst_mask = BIT(11) | BIT(12),
-		.clk_mask = BIT(11) | BIT(12),
+		.rst_mask = BIT(11),
+		.clk_mask = BIT(11),
+		.parent = IMX93_MEDIABLK_PD_MIPI_PHY,
 	},
 	[IMX93_MEDIABLK_PD_MIPI_CSI] = {
 		.name = "mediablk-mipi-csi",
@@ -323,6 +355,7 @@ static const struct imx93_blk_ctrl_domain_data imx93_media_blk_ctl_domain_data[]
 		.num_clks = 2,
 		.rst_mask = BIT(9) | BIT(10),
 		.clk_mask = BIT(9) | BIT(10),
+		.parent = IMX93_MEDIABLK_PD_MIPI_PHY,
 	},
 	[IMX93_MEDIABLK_PD_PXP] = {
 		.name = "mediablk-pxp",
@@ -330,6 +363,7 @@ static const struct imx93_blk_ctrl_domain_data imx93_media_blk_ctl_domain_data[]
 		.num_clks = 1,
 		.rst_mask = BIT(7) | BIT(8),
 		.clk_mask = BIT(7) | BIT(8),
+		.parent = BLK_CTRL_NO_PARENT,
 		.num_qos = 2,
 		.qos = {
 			{
@@ -351,6 +385,7 @@ static const struct imx93_blk_ctrl_domain_data imx93_media_blk_ctl_domain_data[]
 		.num_clks = 2,
 		.rst_mask = BIT(4) | BIT(5) | BIT(6),
 		.clk_mask = BIT(4) | BIT(5) | BIT(6),
+		.parent = BLK_CTRL_NO_PARENT,
 		.num_qos = 1,
 		.qos = {
 			{
@@ -367,6 +402,7 @@ static const struct imx93_blk_ctrl_domain_data imx93_media_blk_ctl_domain_data[]
 		.num_clks = 1,
 		.rst_mask = BIT(2) | BIT(3),
 		.clk_mask = BIT(2) | BIT(3),
+		.parent = BLK_CTRL_NO_PARENT,
 		.num_qos = 4,
 		.qos = {
 			{
@@ -392,6 +428,14 @@ static const struct imx93_blk_ctrl_domain_data imx93_media_blk_ctl_domain_data[]
 			}
 		}
 	},
+	[IMX93_MEDIABLK_PD_MIPI_PHY] = {
+		.name = "mediablk-mipi-phy",
+		.clk_names = NULL,
+		.num_clks = 0,
+		.rst_mask = BIT(12),
+		.clk_mask = BIT(12),
+		.parent = BLK_CTRL_NO_PARENT,
+	},
 };
 
 static const struct regmap_range imx93_media_blk_ctl_yes_ranges[] = {
-- 
2.53.0



