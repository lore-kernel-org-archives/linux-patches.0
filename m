Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018639;
	b=rdVfG3aAww0tmaS5QbqDvuDLHD5fznwpI2K/2fyrTo0eWV0E5hEUthQXzn6EsVFIw91H
	 1W0XBJ5BmgIrAzdg2AymIXSY+EE5of2LR7a1rIISIZRQelpQO5gFqS74SpLNhLLMmS2Wh
	 9kLC1pZ9AHp8u3busYFe7q87aZl60Ke41KbXV9tseRgXx3Ao7T41tGfUF0X6jO8AEo5Of
	 goiWlw5WwFxAEX71B8NazcRkhQk8+nodEhFGO9khYNBW+9RMCXECepmMlZYGRH3bMH/vk
	 Uwx/pmBfHHm3Ra8RBK7dyY/8EVPENyuHxS98HtQ5L9G8T/k04kqt0C4E+kONiolAmiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018639;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VRfZ3K1kdM2OX58XA2XFNDkdg5dp0kPKgPo+aWJ0Ukg=;
	b=TIcoPdzl92VQAGcDZUpp0nyvbcG0zzT44LUsJf360J+O6md81/bpGqkKS119Dig6HyBh
	 VpCQNzV/FMqUFH/fQpLNgrSdtGTusbGPLT9eQJ9WluNmPletj908FHQ1ZYDuHNyN5vjyK
	 T9jYX7adnHHQD7yaO66NPb4TzdU+/Mlnh1BfXVFhdhR/UhprEnjLilMknBrpYYFiCfZaf
	 ZfR3x1xEF1Gk6BA3xkBz11jYaQUynVdGRohhrFKsAEUz9CsyW2nEpIjNjEB/YTXsCSqiV
	 w0zgeB7EABELgnhDAsh6uwDj5QJaIAqPd6ZLENTJAukDOLnLQoyfMbzT/Rlb2aK7b4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="w/5ayIJ7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FEF3606A325;
	Wed, 18 Nov 2026 16:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w/5ayIJ7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045B41F000C4;
	Wed, 18 Nov 2026 16:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018639;
	bh=VRfZ3K1kdM2OX58XA2XFNDkdg5dp0kPKgPo+aWJ0Ukg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w/5ayIJ7ezFwRfUZ3LpIlNHWHI3w7AoSQHgAtKgzgXEMwkT5/yyRUaOlHf/LLKt2Q
	 2PjGbFvNVv5Q/NGfmibbTgxk9iddGaVqaaaFNgb5kZuj60EHnuTBwvPTqZUdCDaDSx
	 N79mCYPuiS6+aYYKPODTyrpoiuIqc3e3BCXDAW/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1305/2651] soc: qcom: geni-se: provide PROG_RAM_DEPTH for I2C HUB Serial Engines
Date: Wed, 18 Nov 2026 15:42:25 +0100
Message-ID: <20261118150334.949568641@linuxfoundation.org>
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
index 6ac2bdc16984c..08e05ba70f731 100644
--- a/drivers/soc/qcom/qcom-geni-se.c
+++ b/drivers/soc/qcom/qcom-geni-se.c
@@ -101,22 +101,26 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(geni_se_regs);
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
@@ -1244,6 +1248,7 @@ static const struct se_fw_hdr *geni_find_protocol_fw(struct geni_se *se, const s
 						     enum geni_se_protocol_type protocol,
 						     u32 *fw_size_out)
 {
+	struct geni_wrapper *wrapper = se->wrapper;
 	struct device *dev = se->dev;
 	const struct elf32_hdr *ehdr;
 	const struct elf32_phdr *phdrs;
@@ -1308,8 +1313,11 @@ static const struct se_fw_hdr *geni_find_protocol_fw(struct geni_se *se, const s
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
@@ -1620,6 +1628,7 @@ static int geni_se_probe(struct platform_device *pdev)
 		return PTR_ERR(wrapper->base);
 
 	desc = device_get_match_data(&pdev->dev);
+	wrapper->prog_ram_depth = desc->prog_ram_depth;
 
 	if (!has_acpi_companion(&pdev->dev) && desc->num_clks) {
 		int i;
@@ -1672,6 +1681,7 @@ static const char * const i2c_master_hub_clks[] = {
 static const struct geni_se_desc i2c_master_hub_desc = {
 	.clks = i2c_master_hub_clks,
 	.num_clks = ARRAY_SIZE(i2c_master_hub_clks),
+	.prog_ram_depth = 1020,
 };
 
 static const struct of_device_id geni_se_dt_match[] = {
-- 
2.53.0



