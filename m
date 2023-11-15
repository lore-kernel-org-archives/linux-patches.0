Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00193FB0F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EyKnmGt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EABDC433C8;
	Wed, 15 Nov 2023 19:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076258;
	bh=GdCZ6pXPpGqHfp4fZrQcT06qjKISCI+LQAB975t2Quo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EyKnmGt6n0bPw0X8DCyfPJAyzymU633OL3sNoZXdn7V5d4pMZE02/oOY5MzbZyKzU
	 IrS8NMwvlcD4CpMT/g5816c0ReDPWclxh1y5v1eSWf5FYng7hJluJwjveXPl2++EwV
	 W8KwOo1qepFW4jJTCr5Ym2Tn/NgOFvf7nbpCVsxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 177/550] clk: mediatek: clk-mt6797: Add check for mtk_alloc_clk_data
Date: Wed, 15 Nov 2023 14:12:41 -0500
Message-ID: <20231115191612.999048113@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 606f6366a35a3329545e38129804d65ef26ed7d2 ]

Add the check for the return value of mtk_alloc_clk_data() in order to
avoid NULL pointer dereference.

Fixes: 96596aa06628 ("clk: mediatek: add clk support for MT6797")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20230912093407.21505-3-jiasheng@iscas.ac.cn
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mt6797.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/clk/mediatek/clk-mt6797.c b/drivers/clk/mediatek/clk-mt6797.c
index 4c87c0348e5f4..d8303d5efc7fe 100644
--- a/drivers/clk/mediatek/clk-mt6797.c
+++ b/drivers/clk/mediatek/clk-mt6797.c
@@ -392,6 +392,8 @@ static int mtk_topckgen_init(struct platform_device *pdev)
 		return PTR_ERR(base);
 
 	clk_data = mtk_alloc_clk_data(CLK_TOP_NR);
+	if (!clk_data)
+		return -ENOMEM;
 
 	mtk_clk_register_factors(top_fixed_divs, ARRAY_SIZE(top_fixed_divs),
 				 clk_data);
@@ -547,6 +549,8 @@ static void mtk_infrasys_init_early(struct device_node *node)
 
 	if (!infra_clk_data) {
 		infra_clk_data = mtk_alloc_clk_data(CLK_INFRA_NR);
+		if (!infra_clk_data)
+			return;
 
 		for (i = 0; i < CLK_INFRA_NR; i++)
 			infra_clk_data->hws[i] = ERR_PTR(-EPROBE_DEFER);
@@ -572,6 +576,8 @@ static int mtk_infrasys_init(struct platform_device *pdev)
 
 	if (!infra_clk_data) {
 		infra_clk_data = mtk_alloc_clk_data(CLK_INFRA_NR);
+		if (!infra_clk_data)
+			return -ENOMEM;
 	} else {
 		for (i = 0; i < CLK_INFRA_NR; i++) {
 			if (infra_clk_data->hws[i] == ERR_PTR(-EPROBE_DEFER))
-- 
2.42.0



