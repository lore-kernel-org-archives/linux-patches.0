Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C935A264FA0;
	Tue,  8 Apr 2025 11:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110846; cv=none; b=L0DpDB3Q9eqIdYo9iVqjwJMLQV1qkIl6mU7gTeYWPSwnfymhHlXJ3gkH2rvupR7c2IT/+ri+9EPkZjEIlrR/MUv2Ejb5pSTipsnnMpyaHQp1iSOXqDzMD6Bk2AsfWHNIfRfoR+Mw49IH818eMBe5CbewPc7wzWOAQS3zGd1zYYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110846; c=relaxed/simple;
	bh=4gcSXo2ZT3UXMuqJOT5exeWRlJmN8NKnzc5R7ZkV0WU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g9w3ocCvsj+g9ZzRf2eBxETMd7s3nPdfwurLGicBx7MxFLHsrNdxh9n2f7iV6SUzBUQLyJlEobn5fMCkP2gpj46pJD6kHO2fUIddrVG1oy/kkuZbUp9jc52TVcuOhHiFPn1NnqaXOO+KgAhUcWCcSf/BjAseHZftOXc1yP5WGY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQSe2c4r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQSe2c4r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3A2C4CEE5;
	Tue,  8 Apr 2025 11:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110846;
	bh=4gcSXo2ZT3UXMuqJOT5exeWRlJmN8NKnzc5R7ZkV0WU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wQSe2c4rg2N8ebrRrVAxuNVJjaRVJt/sxIVWT7LsDnhnxKz9OU/sRhxjPiAED+VQW
	 lZSSImokA9CdHxtP5M+S3hH5Z3UlykuH79dDeHs0cxSSg49mk5OEklPlkL+89FFxyB
	 uKgCGr4xjutLITaqryr2SbBiLkXKA8xEtZbXdsfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqi Zhang <xueqi.zhang@mediatek.com>,
	Yong Wu <yong.wu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 167/731] memory: mtk-smi: Add ostd setting for mt8192
Date: Tue,  8 Apr 2025 12:41:04 +0200
Message-ID: <20250408104918.160555184@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xueqi Zhang <xueqi.zhang@mediatek.com>

[ Upstream commit 90a0fbaac4a588a1116a191521c3c837c25582ee ]

Add initial ostd setting for mt8192. All the settings come from DE.
These settings help adjust Multimedia HW's bandwidth limits to achieve
a balanced bandwidth requirement.
Without this, the VENC HW work abnormal while stress testing.

Fixes: 02c02ddce427 ("memory: mtk-smi: Add mt8192 support")
Signed-off-by: Xueqi Zhang <xueqi.zhang@mediatek.com>
Reviewed-by: Yong Wu <yong.wu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20250307054515.23455-1-xueqi.zhang@mediatek.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/mtk-smi.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/memory/mtk-smi.c b/drivers/memory/mtk-smi.c
index 5710348f72f6f..a8f5467d6b31e 100644
--- a/drivers/memory/mtk-smi.c
+++ b/drivers/memory/mtk-smi.c
@@ -332,6 +332,38 @@ static const u8 mtk_smi_larb_mt8188_ostd[][SMI_LARB_PORT_NR_MAX] = {
 	[25] = {0x01},
 };
 
+static const u8 mtk_smi_larb_mt8192_ostd[][SMI_LARB_PORT_NR_MAX] = {
+	[0] = {0x2, 0x2, 0x28, 0xa, 0xc, 0x28,},
+	[1] = {0x2, 0x2, 0x18, 0x18, 0x18, 0xa, 0xc, 0x28,},
+	[2] = {0x5, 0x5, 0x5, 0x5, 0x1,},
+	[3] = {},
+	[4] = {0x28, 0x19, 0xb, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x4, 0x1,},
+	[5] = {0x1, 0x1, 0x4, 0x1, 0x1, 0x1, 0x1, 0x16,},
+	[6] = {},
+	[7] = {0x1, 0x3, 0x2, 0x1, 0x1, 0x5, 0x2, 0x12, 0x13, 0x4, 0x4, 0x1,
+	       0x4, 0x2, 0x1,},
+	[8] = {},
+	[9] = {0xa, 0x7, 0xf, 0x8, 0x1, 0x8, 0x9, 0x3, 0x3, 0x6, 0x7, 0x4,
+	       0xa, 0x3, 0x4, 0xe, 0x1, 0x7, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1,
+	       0x1, 0x1, 0x1, 0x1, 0x1,},
+	[10] = {},
+	[11] = {0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1,
+		0x1, 0x1, 0x1, 0xe, 0x1, 0x7, 0x8, 0x7, 0x7, 0x1, 0x6, 0x2,
+		0xf, 0x8, 0x1, 0x1, 0x1,},
+	[12] = {},
+	[13] = {0x2, 0xc, 0xc, 0xe, 0x6, 0x6, 0x6, 0x6, 0x6, 0x12, 0x6, 0x28,
+		0x2, 0xc, 0xc, 0x28, 0x12, 0x6,},
+	[14] = {},
+	[15] = {0x28, 0x14, 0x2, 0xc, 0x18, 0x4, 0x28, 0x14, 0x4, 0x4, 0x4, 0x2,
+		0x4, 0x2, 0x8, 0x4, 0x4,},
+	[16] = {0x28, 0x14, 0x2, 0xc, 0x18, 0x4, 0x28, 0x14, 0x4, 0x4, 0x4, 0x2,
+		0x4, 0x2, 0x8, 0x4, 0x4,},
+	[17] = {0x28, 0x14, 0x2, 0xc, 0x18, 0x4, 0x28, 0x14, 0x4, 0x4, 0x4, 0x2,
+		0x4, 0x2, 0x8, 0x4, 0x4,},
+	[18] = {0x2, 0x2, 0x4, 0x2,},
+	[19] = {0x9, 0x9, 0x5, 0x5, 0x1, 0x1,},
+};
+
 static const u8 mtk_smi_larb_mt8195_ostd[][SMI_LARB_PORT_NR_MAX] = {
 	[0] = {0x0a, 0xc, 0x22, 0x22, 0x01, 0x0a,}, /* larb0 */
 	[1] = {0x0a, 0xc, 0x22, 0x22, 0x01, 0x0a,}, /* larb1 */
@@ -427,6 +459,7 @@ static const struct mtk_smi_larb_gen mtk_smi_larb_mt8188 = {
 
 static const struct mtk_smi_larb_gen mtk_smi_larb_mt8192 = {
 	.config_port                = mtk_smi_larb_config_port_gen2_general,
+	.ostd			    = mtk_smi_larb_mt8192_ostd,
 };
 
 static const struct mtk_smi_larb_gen mtk_smi_larb_mt8195 = {
-- 
2.39.5



