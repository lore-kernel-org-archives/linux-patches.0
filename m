Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111322AD22;
	Wed,  5 Feb 2025 14:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764979; cv=none; b=byVgaJAHlHw6nQn3dncpqvc6z2OTJ28ysff9fQjBJjrkYi3yuxt1pdTeTgN7zMOlWLW9wPTFINhYtruHjJGlpec65uPqf1hCJb8zx8DCoKnYcoADJHj5ikg0S/FQbGeg/R2NFCmK2tYg+LFXf2puO5a8jhoU8heNjgrdWiRdD1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764979; c=relaxed/simple;
	bh=RWB37dAkmkwOj+AOdXe5VzPql/AD5gDNucOUQ/tKP1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TZTakFulk8UiyDPsOaPid0CCSbMTOstPsgS6Q+OlVotqt4vkCUel2vmQ1dWzv89kQBiUTU5oR1DmhUfFDqkxvWUnuGMao93IYhypefYVVWJIFPkwenDi909iwybTsee8qRczYPBXKk31IjOM9ML9kyUI+OANSpbXHvF5QRZ9YrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gm1pu6LP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gm1pu6LP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8586AC4CED1;
	Wed,  5 Feb 2025 14:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764978;
	bh=RWB37dAkmkwOj+AOdXe5VzPql/AD5gDNucOUQ/tKP1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gm1pu6LP/ap3ELvbfpFA4g8IFL/gtYgzRf+5lBAra5OZKOLAjbsCncOeW9NagPJu4
	 dXy+El/Vw7ZiSPH6/2C72hbi/93epW9a6q9a1PnYeh372E2iQBCjNg2RKDEhXMQGq6
	 YE1moK3YhNSwsk3BxRpvnSh9Of4e8Ar02VeiBOWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 132/623] clk: imx93: Add IMX93_CLK_SPDIF_IPG clock
Date: Wed,  5 Feb 2025 14:37:54 +0100
Message-ID: <20250205134501.280704931@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



