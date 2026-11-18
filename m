Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018421;
	b=ClsL0UB2LeNQnlU0q2zspPubCtpDNTbf5CGA+uTy6vdXD0CiHaOorKSh0En7orWX85Cw
	 GV9AiZsl5FnoI9J/lCc5zNTGsy4BZqfphTmAp6hzQUnaXZ+jlCVzbJp0cH/ngz+MIxrrN
	 iIMjsI91nk+amusTNJU5cdZvU2FfnQt8UZ+rg4yorS9HXWqjhqE+eXubPeZdV2kQDFHgp
	 44ngmZaMc/HXQvw7trc7I+sJ4Fa5gkCsEesgaPcCLk1XB6UUTERP2qOXLGITADJ0QMAdp
	 HPIQrx4pWSnJF7hDpL11P9YBbXt2PjZWXuE13+yiyrx5yggjWSDG3ReJUvamQ0s8cLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018421;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FKNIfrbYxQBuwvu8rGK2QzGxZ3YeXwd94SZ3jSbkpiM=;
	b=DPB2/MxsjyDw3lXtidgZXRHzJeUhrWpkv2N3k6sHtXyLBGYCr/p5Z3Tzsky9DQuuTT/t
	 Jwc/z4qncL0/M4GDMfxqTdWjVVG1eizgPh8F6onaiqM8gcj0F3wPziaTYxBYLEla9jTL3
	 ytK6RCz+v9MuXKPIc9lCkIsxLxxhTVRM0b1fr5ucZlkakHxsguQT2AbDt3YFjfUhpwsGI
	 DD84z9r5vmYute+UkEYOIvK5Ts71f7392MW7HKWSVrZL80bHL7qSUVz19bsbrF3gnA11x
	 Isaz2urBOVQJReKnyBWrHa4ZnOEzLP8GvObSQa1KA/IYR92nhjEg0nEruwtXxH0yz6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XJryOFed;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919D7606A32F;
	Wed, 18 Nov 2026 16:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XJryOFed
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A8B1F000C5;
	Wed, 18 Nov 2026 16:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018421;
	bh=FKNIfrbYxQBuwvu8rGK2QzGxZ3YeXwd94SZ3jSbkpiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XJryOFedU34SMRE1vlEX+czHaLlLLxt6BLiLfYDNw9mDBVbaHTzEHv9nLnied4G1w
	 IsOxCxZgNjJWmNkQ/DD3MrUbN/WfTvE0wG+a02G1FPSwogK8iPGvR4XWnutZvXbF7c
	 3XC/XFRrmaouPzU7QvIoWLOS62MrRsRFL7I4F4+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Shawn Guo <shengchao.guo@oss.qualcomm.com>,
	Qiang Yu <qiang.yu@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1235/2651] phy: qcom: qmp-pcie: Refactor common multiphy handling
Date: Wed, 18 Nov 2026 15:41:15 +0100
Message-ID: <20261118150332.467304335@linuxfoundation.org>
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

From: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>

[ Upstream commit 6dd77bf6a10d0eb9ed17f5b6093b3511052084db ]

Reuse the existing port resource arrays for Glymur register regions,
power domains, and NOCSR resets instead of maintaining duplicate
Glymur-specific lists.

Attach each PHY instance's power domains to the device created for that
PHY. This ensures that the associated GDSCs are managed with the
lifetime of the individual PHY device rather than the parent multiphy
platform device.

Validate the clock-output-names property before using its count for
allocation, and use a generic module description.

Signed-off-by: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Tested-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Tested-by: Qiang Yu <qiang.yu@oss.qualcomm.com>
Link: https://patch.msgid.link/20260921-nord-v4-5-ed05c6e09240@oss.qualcomm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: fb0f0e0e9e5d ("phy: qcom: qmp-pcie: Check clock-output-names count in the multi-PHY driver")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../phy/qualcomm/phy-qcom-qmp-pcie-multiphy.c | 102 ++++++++----------
 1 file changed, 44 insertions(+), 58 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-pcie-multiphy.c b/drivers/phy/qualcomm/phy-qcom-qmp-pcie-multiphy.c
index e93cba4369fb1..befca9b78ce92 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-pcie-multiphy.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-pcie-multiphy.c
@@ -113,31 +113,19 @@ static const char * const glymur_vreg_l[] = {
 	"vdda-phy", "vdda-pll", "vdda-refgen0p9", "vdda-refgen1p2",
 };
 
-static const char * const glymur_pciephy_a_reg_l[] = {
+static const char * const pciephy_port_a_reg_l[] = {
 	"port_a",
 };
 
-static const char * const glymur_pciephy_b_reg_l[] = {
+static const char * const pciephy_port_b_reg_l[] = {
 	"port_b",
 };
 
-static const char * const glymur_pciephy_reg_l[] = {
+static const char * const pciephy_port_ab_reg_l[] = {
 	"port_a", "port_b",
 };
 
-static const char * const glymur_pciephy_a_pd_l[] = {
-	"port_a",
-};
-
-static const char * const glymur_pciephy_b_pd_l[] = {
-	"port_b",
-};
-
-static const char * const glymur_pciephy_pd_l[] = {
-	"port_a", "port_b",
-};
-
-static const char * const glymur_pciephy_a_nocsr_reset_l[] = {
+static const char * const pciephy_port_a_nocsr_reset_l[] = {
 	"port_a_nocsr",
 };
 
@@ -145,7 +133,7 @@ static const char * const glymur_pciephy_nocsr_reset_l[] = {
 	"port_a_nocsr", "port_b_nocsr",
 };
 
-static const char * const glymur_pciephy_b_nocsr_reset_l[] = {
+static const char * const pciephy_port_b_nocsr_reset_l[] = {
 	"port_b_nocsr",
 };
 
@@ -155,12 +143,12 @@ static const struct qmp_pcie_offsets glymur_pcie_offsets_v8_50 = {
 
 static const struct qmp_phy_cfg glymur_qmp_gen5x4_pciephy_a_cfg = {
 	.offsets		= &glymur_pcie_offsets_v8_50,
-	.reg_names		= glymur_pciephy_a_reg_l,
-	.num_regs		= ARRAY_SIZE(glymur_pciephy_a_reg_l),
-	.pd_names		= glymur_pciephy_a_pd_l,
-	.num_pds		= ARRAY_SIZE(glymur_pciephy_a_pd_l),
-	.nocsr_reset_list	= glymur_pciephy_a_nocsr_reset_l,
-	.num_nocsr_resets	= ARRAY_SIZE(glymur_pciephy_a_nocsr_reset_l),
+	.reg_names		= pciephy_port_a_reg_l,
+	.num_regs		= ARRAY_SIZE(pciephy_port_a_reg_l),
+	.pd_names		= pciephy_port_a_reg_l,
+	.num_pds		= ARRAY_SIZE(pciephy_port_a_reg_l),
+	.nocsr_reset_list	= pciephy_port_a_nocsr_reset_l,
+	.num_nocsr_resets	= ARRAY_SIZE(pciephy_port_a_nocsr_reset_l),
 	.vreg_list		= glymur_vreg_l,
 	.num_vregs		= ARRAY_SIZE(glymur_vreg_l),
 	.regs			= pciephy_v8_50_regs_layout,
@@ -173,12 +161,12 @@ static const struct qmp_phy_cfg glymur_qmp_gen5x4_pciephy_a_cfg = {
 
 static const struct qmp_phy_cfg glymur_qmp_gen5x4_pciephy_b_cfg = {
 	.offsets		= &glymur_pcie_offsets_v8_50,
-	.reg_names		= glymur_pciephy_b_reg_l,
-	.num_regs		= ARRAY_SIZE(glymur_pciephy_b_reg_l),
-	.pd_names		= glymur_pciephy_b_pd_l,
-	.num_pds		= ARRAY_SIZE(glymur_pciephy_b_pd_l),
-	.nocsr_reset_list	= glymur_pciephy_b_nocsr_reset_l,
-	.num_nocsr_resets	= ARRAY_SIZE(glymur_pciephy_b_nocsr_reset_l),
+	.reg_names		= pciephy_port_b_reg_l,
+	.num_regs		= ARRAY_SIZE(pciephy_port_b_reg_l),
+	.pd_names		= pciephy_port_b_reg_l,
+	.num_pds		= ARRAY_SIZE(pciephy_port_b_reg_l),
+	.nocsr_reset_list	= pciephy_port_b_nocsr_reset_l,
+	.num_nocsr_resets	= ARRAY_SIZE(pciephy_port_b_nocsr_reset_l),
 	.vreg_list		= glymur_vreg_l,
 	.num_vregs		= ARRAY_SIZE(glymur_vreg_l),
 	.regs			= pciephy_v8_50_regs_layout,
@@ -191,10 +179,10 @@ static const struct qmp_phy_cfg glymur_qmp_gen5x4_pciephy_b_cfg = {
 
 static const struct qmp_phy_cfg glymur_qmp_gen5x8_pciephy_cfg = {
 	.offsets		= &glymur_pcie_offsets_v8_50,
-	.reg_names		= glymur_pciephy_reg_l,
-	.num_regs		= ARRAY_SIZE(glymur_pciephy_reg_l),
-	.pd_names		= glymur_pciephy_pd_l,
-	.num_pds		= ARRAY_SIZE(glymur_pciephy_pd_l),
+	.reg_names		= pciephy_port_ab_reg_l,
+	.num_regs		= ARRAY_SIZE(pciephy_port_ab_reg_l),
+	.pd_names		= pciephy_port_ab_reg_l,
+	.num_pds		= ARRAY_SIZE(pciephy_port_ab_reg_l),
 	.nocsr_reset_list	= glymur_pciephy_nocsr_reset_l,
 	.num_nocsr_resets	= ARRAY_SIZE(glymur_pciephy_nocsr_reset_l),
 	.vreg_list		= glymur_vreg_l,
@@ -398,45 +386,39 @@ static const struct phy_ops qmp_pcie_phy_ops = {
 static void qmp_pcie_pd_detach(void *data)
 {
 	struct qmp_pcie *qmp = data;
-	const struct qmp_phy_cfg *cfg = qmp->cfg;
 	int i;
 
-	for (i = 0; i < cfg->num_pds; i++) {
+	for (i = 0; i < qmp->cfg->num_pds; i++) {
 		if (!IS_ERR_OR_NULL(qmp->pd_devs[i]))
 			dev_pm_domain_detach(qmp->pd_devs[i], true);
 	}
 }
 
-static int qmp_pcie_pd_init(struct qmp_pcie *qmp)
+static int qmp_pcie_pd_init(struct qmp_pcie *qmp, struct phy *phy)
 {
 	const struct qmp_phy_cfg *cfg = qmp->cfg;
-	struct device *dev = qmp->dev;
+	struct device *pd_dev = &phy->dev;
 	int i, ret;
 
 	if (!cfg->num_pds)
 		return 0;
 
-	qmp->pd_devs = devm_kcalloc(dev, cfg->num_pds, sizeof(*qmp->pd_devs),
+	qmp->pd_devs = devm_kcalloc(pd_dev, cfg->num_pds, sizeof(*qmp->pd_devs),
 				    GFP_KERNEL);
 	if (!qmp->pd_devs)
 		return -ENOMEM;
 
+	ret = devm_add_action_or_reset(pd_dev, qmp_pcie_pd_detach, qmp);
+	if (ret)
+		return ret;
+
 	for (i = 0; i < cfg->num_pds; i++) {
-		qmp->pd_devs[i] = dev_pm_domain_attach_by_name(dev,
-							       cfg->pd_names[i]);
-		if (IS_ERR_OR_NULL(qmp->pd_devs[i])) {
-			ret = PTR_ERR(qmp->pd_devs[i]) ? : -ENODATA;
-			goto err_detach;
-		}
+		qmp->pd_devs[i] = dev_pm_domain_attach_by_name(pd_dev, cfg->pd_names[i]);
+		if (IS_ERR_OR_NULL(qmp->pd_devs[i]))
+			return PTR_ERR_OR_ZERO(qmp->pd_devs[i]) ? : -ENODATA;
 	}
 
-	return devm_add_action_or_reset(dev, qmp_pcie_pd_detach, qmp);
-
-err_detach:
-	while (--i >= 0)
-		dev_pm_domain_detach(qmp->pd_devs[i], false);
-
-	return ret;
+	return 0;
 }
 
 static int qmp_pcie_vreg_init(struct qmp_pcie *qmp)
@@ -555,6 +537,8 @@ static int qmp_pcie_multiphy_register_clocks(struct device *dev,
 	int i, ret;
 
 	num_pipe_outputs = of_property_count_strings(np, "clock-output-names");
+	if (num_pipe_outputs < 0)
+		return num_pipe_outputs;
 
 	qmp_data->num_pipe_outputs = num_pipe_outputs;
 	qmp_data->pipe_out_clks = devm_kcalloc(dev, num_pipe_outputs,
@@ -630,6 +614,7 @@ static struct phy *qmp_pcie_multiphy_xlate(struct device *dev,
 static int qmp_pcie_probe_phy(struct qmp_pcie *qmp, struct device_node *np,
 			      struct phy **out_phy)
 {
+	struct phy *phy;
 	int ret;
 
 	ret = qmp_pcie_get_mmio(qmp);
@@ -648,15 +633,16 @@ static int qmp_pcie_probe_phy(struct qmp_pcie *qmp, struct device_node *np,
 	if (ret)
 		return ret;
 
-	ret = qmp_pcie_pd_init(qmp);
+	phy = devm_phy_create(qmp->dev, np, &qmp_pcie_phy_ops);
+	if (IS_ERR(phy))
+		return PTR_ERR(phy);
+
+	ret = qmp_pcie_pd_init(qmp, phy);
 	if (ret)
 		return ret;
 
-	*out_phy = devm_phy_create(qmp->dev, np, &qmp_pcie_phy_ops);
-	if (IS_ERR(*out_phy))
-		return PTR_ERR(*out_phy);
-
-	phy_set_drvdata(*out_phy, qmp);
+	phy_set_drvdata(phy, qmp);
+	*out_phy = phy;
 
 	return 0;
 }
@@ -739,5 +725,5 @@ static struct platform_driver qmp_pcie_multiphy_driver = {
 module_platform_driver(qmp_pcie_multiphy_driver);
 
 MODULE_AUTHOR("Qiang Yu <qiang.yu@oss.qualcomm.com>");
-MODULE_DESCRIPTION("Qualcomm QMP PCIe Multi-PHY driver for Glymur");
+MODULE_DESCRIPTION("Qualcomm QMP PCIe Multi-PHY driver");
 MODULE_LICENSE("GPL");
-- 
2.53.0



