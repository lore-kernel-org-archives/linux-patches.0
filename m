Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025477;
	b=KCSr+s2bq/LtYV8hog7d9hateB0OW78TbZ3muNifAkdhFaO9yt4+6K3K4k3zXsSXFh7s
	 WoglCyMepmquIXGa/13WOjE0GFtBEz5vrbjcCWhFaUgVc+4rNeGcylGjLwim6vKuKSOhZ
	 j9DUn8qVyYfblXXpNbowStlWzuYGkrXaovYDP+rJPEZIUO6CFSYEmSiiXGy+rL+aQx0Yo
	 0XNSKTIEck3dqacJieNUQOWoNEKfEJJihMsw77Rm9rGg+bT/qPf0Wpps2kKI/dacF94Pj
	 yA29elQQc7aLDTJRUNMVi8x2/a2GQsbVRMawlCW8ApefJdFdpmrVbKjj1jA48/9pG7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025477;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GPX6p5kG04r7VnZ2sBb3ZG4b56pM++Bac7wRK3Uun6Y=;
	b=xJtZbwhPNklVOPHGoS1AvoG+Wb5bj+eWNXUrsHb5OwLmRe+2WVpBKDUKYAybgksDwA6P
	 sivu9TbUVts7hvwZ8IJxvAjPhGL1DI3z/z7v20Cp2UVz0DnLHDZ0jDBgiMd1jmBCR7S1L
	 4HYEFQBlS2grtQJo7GhDgYTiiASDiJZDjUpxMxxIqhZ72k5EVDYDurnYK20rNWhnoJtQd
	 M8slvSa7joaNSbn3CqmUxtBgYC9zxSXS+tOMtFc3v0qtE23PNT9UX60rPQOlAYuRWWD+v
	 W/4SaY4OewTt7OM27TV/FR7fgqSTesEP4dnDO6g44dN26YYLfGu39L/S0uS/bd05JHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ru3LCHVr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D77606A320;
	Wed, 18 Nov 2026 18:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ru3LCHVr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB3F1F000C4;
	Wed, 18 Nov 2026 18:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025477;
	bh=GPX6p5kG04r7VnZ2sBb3ZG4b56pM++Bac7wRK3Uun6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ru3LCHVrAS4GoV/ub8waP+Z81sWcD82PNDYBZXwnVrE2bzp+FmNWkPMcSTxG7kP3a
	 YIWTfnfdQFj/8OugxCTVeRlbvTz3ENwpHVjPdeO2CNxsE6pBa2VfrHOd4rM0uiVabc
	 jKNl6qjUI7E2gcOaNmK7GSjfI/dHqXif0gAn8Hsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1092/2151] soc: qcom: geni-se: provide PROG_RAM_DEPTH for I2C HUB Serial Engines
Date: Wed, 18 Nov 2026 15:47:07 +0100
Message-ID: <20261118150202.056367586@linuxfoundation.org>
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

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 803f9950a6c6e0b37ed7f24925feed823703467e ]

The I2C Hub serial elements lacks DMA, so the SE_HW_PARAM_2 register which
is in the DMA register space doesn't exist for those instances.

Provide the ram depth in the compatible data to be used instead
of the reading the missing SE_HW_PARAM_2 register.

Fixes: 522bfb4f33c0 ("soc: qcom: geni-se: Use HW PROG_RAM_DEPTH to validate firmware size")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260923-topic-sm8x50-i2c-hub-fw-ram-v3-1-44287b4e814b@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/qcom-geni-se.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/qcom/qcom-geni-se.c b/drivers/soc/qcom/qcom-geni-se.c
index f85cac34c7260..ca251d84d540e 100644
--- a/drivers/soc/qcom/qcom-geni-se.c
+++ b/drivers/soc/qcom/qcom-geni-se.c
@@ -94,22 +94,26 @@
  * @base:		Base address of this instance of QUP wrapper core
  * @clks:		Handle to the primary & optional secondary AHB clocks
  * @num_clks:		Count of clocks
+ * @prog_ram_depth:	Available CFG RAM depth for instance without SE_HW_PARAM_2
  */
 struct geni_wrapper {
 	struct device *dev;
 	void __iomem *base;
 	struct clk_bulk_data clks[MAX_CLKS];
 	unsigned int num_clks;
+	unsigned int prog_ram_depth;
 };
 
 /**
  * struct geni_se_desc - Data structure to represent the QUP Wrapper resources
  * @clks:		Name of the primary & optional secondary AHB clocks
  * @num_clks:		Count of clock names
+ * @prog_ram_depth:	Available CFG RAM depth for instance without SE_HW_PARAM_2
  */
 struct geni_se_desc {
 	unsigned int num_clks;
 	const char * const *clks;
+	unsigned int prog_ram_depth;
 };
 
 static const char * const icc_path_names[] = {"qup-core", "qup-config",
@@ -1005,6 +1009,7 @@ static const struct se_fw_hdr *geni_find_protocol_fw(struct geni_se *se, const s
 						     enum geni_se_protocol_type protocol,
 						     u32 *fw_size_out)
 {
+	struct geni_wrapper *wrapper = se->wrapper;
 	struct device *dev = se->dev;
 	const struct elf32_hdr *ehdr;
 	const struct elf32_phdr *phdrs;
@@ -1069,8 +1074,11 @@ static const struct se_fw_hdr *geni_find_protocol_fw(struct geni_se *se, const s
 		cfg_val_end = le16_to_cpu(sefw->cfg_val_offset) +
 			      le16_to_cpu(sefw->cfg_size_in_items) * sizeof(u32);
 
-		prog_ram_depth = FIELD_GET(PROG_RAM_DEPTH_MSK,
-					   readl_relaxed(se->base + SE_HW_PARAM_2));
+		if (wrapper->prog_ram_depth)
+			prog_ram_depth = wrapper->prog_ram_depth;
+		else
+			prog_ram_depth = FIELD_GET(PROG_RAM_DEPTH_MSK,
+					readl_relaxed(se->base + SE_HW_PARAM_2));
 		if (fw_size >= prog_ram_depth) {
 			dev_err(dev, "Firmware size (%u) exceeds RAM size (%u)\n",
 				fw_size, prog_ram_depth);
@@ -1381,6 +1389,7 @@ static int geni_se_probe(struct platform_device *pdev)
 		return PTR_ERR(wrapper->base);
 
 	desc = device_get_match_data(&pdev->dev);
+	wrapper->prog_ram_depth = desc->prog_ram_depth;
 
 	if (!has_acpi_companion(&pdev->dev) && desc->num_clks) {
 		int i;
@@ -1433,6 +1442,7 @@ static const char * const i2c_master_hub_clks[] = {
 static const struct geni_se_desc i2c_master_hub_desc = {
 	.clks = i2c_master_hub_clks,
 	.num_clks = ARRAY_SIZE(i2c_master_hub_clks),
+	.prog_ram_depth = 1020,
 };
 
 static const struct of_device_id geni_se_dt_match[] = {
-- 
2.53.0



