Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634113FB19
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PFXm18JG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13193C433C7;
	Wed, 15 Nov 2023 19:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076260;
	bh=SpxlTDFyx2r1WLEmTb7Gty03xevvYMovlR93lPOpgSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PFXm18JGZBvlzT8Mc2W6F3U/cPyRvZry2zsa7n7KDyx2prJokiGqVPsglielwfqyy
	 ojshQTlwrCr6wpuDiMUG3m4q0djf0KqsuxQIOIIMrbVuLr1iFrlU0WxUhte0afgpZS
	 oRDM+gII2xeYaFpV+nUMpB5gGHdOS5u/fA5/YIRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 178/550] clk: mediatek: clk-mt7629-eth: Add check for mtk_alloc_clk_data
Date: Wed, 15 Nov 2023 14:12:42 -0500
Message-ID: <20231115191613.064554820@linuxfoundation.org>
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

[ Upstream commit 0884393c63cc9a1772f7121a6645ba7bd76feeb9 ]

Add the check for the return value of mtk_alloc_clk_data() in order to
avoid NULL pointer dereference.

Fixes: 3b5e748615e7 ("clk: mediatek: add clock support for MT7629 SoC")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20230912093407.21505-4-jiasheng@iscas.ac.cn
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mt7629-eth.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/clk/mediatek/clk-mt7629-eth.c b/drivers/clk/mediatek/clk-mt7629-eth.c
index 1e1c77cc14ba5..ad0a3854c2a0b 100644
--- a/drivers/clk/mediatek/clk-mt7629-eth.c
+++ b/drivers/clk/mediatek/clk-mt7629-eth.c
@@ -79,6 +79,8 @@ static int clk_mt7629_ethsys_init(struct platform_device *pdev)
 	int r;
 
 	clk_data = mtk_alloc_clk_data(CLK_ETH_NR_CLK);
+	if (!clk_data)
+		return -ENOMEM;
 
 	mtk_clk_register_gates(&pdev->dev, node, eth_clks,
 			       CLK_ETH_NR_CLK, clk_data);
@@ -102,6 +104,8 @@ static int clk_mt7629_sgmiisys_init(struct platform_device *pdev)
 	int r;
 
 	clk_data = mtk_alloc_clk_data(CLK_SGMII_NR_CLK);
+	if (!clk_data)
+		return -ENOMEM;
 
 	mtk_clk_register_gates(&pdev->dev, node, sgmii_clks[id++],
 			       CLK_SGMII_NR_CLK, clk_data);
-- 
2.42.0



