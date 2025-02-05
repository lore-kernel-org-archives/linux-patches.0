Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5452714F9E7;
	Wed,  5 Feb 2025 14:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764457; cv=none; b=WUYaHh7OShELpz13v5rEDlIgXbxxilwqnGaEmKbjCp117Y9TBIKJQxGOqsNKxUc/6CcfeUXIetGrG2FPwVjOu/+bu4TqVlZXJhXI3/2Q1ztSptIMJeh2sYiljFkElzc2GQ10HifJlYd+KEpwx9GUtPw9lAv22T8QiR8/qHznwes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764457; c=relaxed/simple;
	bh=HeL8VraQeo+2d8/U/AnhPxnoDlvZN720i+jY2ejMf2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AcRweJrD510pUUDl5pCw7GB81TETNdlVo5bwMCU4TF/9994CaTfTBQdIDg5d7icu24CywJYZOqnFS09KKKsJtPIuJOiLtekzHpnNB8CWtt0lly3LgtmcNRC8HQKOCT772HbJp4PDB0dHhzOSgP9dRhSDekU0euFidHIrNRq9bPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2pFdKDD7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2pFdKDD7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90ABC4CED1;
	Wed,  5 Feb 2025 14:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764457;
	bh=HeL8VraQeo+2d8/U/AnhPxnoDlvZN720i+jY2ejMf2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2pFdKDD78CCHqWpydR5R0adt7aYMmluGmTBqTnSJpfgo7CiCjaH+obHpfoBO8GzHN
	 aRvwWYTM7n2V1CIpfOStG4noxSnfmQTbPoxWn05fXkU7hj5HHKyxtNvMbwLforDkGj
	 KmDHxwdVVcVe1+1AX4iDPITGaq61XHLqOZoWdCBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 125/590] clk: imx93: Add IMX93_CLK_SPDIF_IPG clock
Date: Wed,  5 Feb 2025 14:38:00 +0100
Message-ID: <20250205134500.043656564@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 6a7853544482e2336b5b8bb9a4b964f9d687f290 ]

Split IMX93_CLK_SPDIF_IPG from IMX93_CLK_SPDIF_GATE
because the IMX93_CLK_SPDIF_GATE controls the gate
of IPG clock and root clock. Without this change,
disabling IMX93_CLK_SPDIF_GATE would also disable
the IPG clock, causing register access failures.

Fixes: 1c4a4f7362fd ("arm64: dts: imx93: Add audio device nodes")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20241119015805.3840606-3-shengjiu.wang@nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx93.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/imx/clk-imx93.c b/drivers/clk/imx/clk-imx93.c
index 58a516dd385bf..eb818db008fb6 100644
--- a/drivers/clk/imx/clk-imx93.c
+++ b/drivers/clk/imx/clk-imx93.c
@@ -15,7 +15,7 @@
 
 #include "clk.h"
 
-#define IMX93_CLK_END 207
+#define IMX93_CLK_END 208
 
 #define PLAT_IMX93 BIT(0)
 #define PLAT_IMX91 BIT(1)
@@ -38,6 +38,7 @@ static u32 share_count_sai2;
 static u32 share_count_sai3;
 static u32 share_count_mub;
 static u32 share_count_pdm;
+static u32 share_count_spdif;
 
 static const char * const a55_core_sels[] = {"a55_alt", "arm_pll"};
 static const char *parent_names[MAX_SEL][4] = {
@@ -252,7 +253,8 @@ static const struct imx93_clk_ccgr {
 	{ IMX93_CLK_MQS1_GATE,		"mqs1",		"sai1_root",		0x9b00, },
 	{ IMX93_CLK_MQS2_GATE,		"mqs2",		"sai3_root",		0x9b40, },
 	{ IMX93_CLK_AUD_XCVR_GATE,	"aud_xcvr",	"audio_xcvr_root",	0x9b80, },
-	{ IMX93_CLK_SPDIF_GATE,		"spdif",	"spdif_root",		0x9c00, },
+	{ IMX93_CLK_SPDIF_IPG,		"spdif_ipg_clk", "bus_wakeup_root",	0x9c00, 0, &share_count_spdif},
+	{ IMX93_CLK_SPDIF_GATE,		"spdif",	"spdif_root",		0x9c00, 0, &share_count_spdif},
 	{ IMX93_CLK_HSIO_32K_GATE,	"hsio_32k",	"osc_32k",		0x9dc0, },
 	{ IMX93_CLK_ENET1_GATE,		"enet1",	"wakeup_axi_root",	0x9e00, 0, NULL, PLAT_IMX93, },
 	{ IMX93_CLK_ENET_QOS_GATE,	"enet_qos",	"wakeup_axi_root",	0x9e40, 0, NULL, PLAT_IMX93, },
-- 
2.39.5



