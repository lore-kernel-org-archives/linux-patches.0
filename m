Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FDF24A05D;
	Wed, 25 Feb 2026 01:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983436; cv=none; b=JDuFnpp9XLniYF0kIF36y/OURS83CMt3bnXNClQVXG4eaD7KMOfqUzdNBs2+YU3oVocHQwLlTVUfHnBVp7ZIPP9H3khW07VcVTm7DYdU/l3ASba3pIfC6uHByQxNRpvEsgDymIyxH9vV5nLKZsme4oWIFHSxLo8QBH9x6Zc9DSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983436; c=relaxed/simple;
	bh=nUTwuyXyRmJQcNAQ5v8PhLEVXsbqtUu2lLGt0/kvUzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C09BB2XEZfxKFV6ONSX2Xzd/F1UrHCQgJ653sR3TTMnjSf3lMRNJUb/WMtkE9z9Mov+lHBk7ecufkE3Uvdtyzj+EQ9JJ+YyMZCbMlHwoOv/6qoedj9ayTqFT3EmnzylsO13KwVqGqe0NU8sq4JOLeNoGjovhxCxHNN0T5pW/8io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eMWIFott; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eMWIFott"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20E6C116D0;
	Wed, 25 Feb 2026 01:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983436;
	bh=nUTwuyXyRmJQcNAQ5v8PhLEVXsbqtUu2lLGt0/kvUzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eMWIFottv18VE0BEU625odIChc8WbITGZtbMlQiXDa4nSrfNNLTl0giEXpvRdYYuH
	 z5UNgYtLvE+CXFG9Y0gb6dqsOC8L50keDSBl8eCzf8+/FnT5/9jSjhjYa9DcpMZFvU
	 xava2AnqYNygcj+SWKNjn/3PgMMBLXbETpKPhdeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sjoerd Simons <sjoerd@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Laura Nao <laura.nao@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 554/781] clk: mediatek: Drop __initconst from gates
Date: Tue, 24 Feb 2026 17:21:03 -0800
Message-ID: <20260225012413.390138978@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sjoerd Simons <sjoerd@collabora.com>

[ Upstream commit 871afb43e41ad4e8246438de495a939cd0f8113c ]

Since commit 8ceff24a754a ("clk: mediatek: clk-gate: Refactor
mtk_clk_register_gate to use mtk_gate struct") the mtk_gate structs
are no longer just used for initialization/registration, but also at
runtime. So drop __initconst annotations.

Fixes: 8ceff24a754a ("clk: mediatek: clk-gate: Refactor mtk_clk_register_gate to use mtk_gate struct")
Signed-off-by: Sjoerd Simons <sjoerd@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Laura Nao <laura.nao@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mt7981-eth.c | 6 +++---
 drivers/clk/mediatek/clk-mt8516.c     | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/mediatek/clk-mt7981-eth.c b/drivers/clk/mediatek/clk-mt7981-eth.c
index 906aec9ddff54..0655ebb6c561f 100644
--- a/drivers/clk/mediatek/clk-mt7981-eth.c
+++ b/drivers/clk/mediatek/clk-mt7981-eth.c
@@ -31,7 +31,7 @@ static const struct mtk_gate_regs sgmii0_cg_regs = {
 		.ops = &mtk_clk_gate_ops_no_setclr_inv,	\
 	}
 
-static const struct mtk_gate sgmii0_clks[] __initconst = {
+static const struct mtk_gate sgmii0_clks[] = {
 	GATE_SGMII0(CLK_SGM0_TX_EN, "sgm0_tx_en", "usb_tx250m", 2),
 	GATE_SGMII0(CLK_SGM0_RX_EN, "sgm0_rx_en", "usb_eq_rx250m", 3),
 	GATE_SGMII0(CLK_SGM0_CK0_EN, "sgm0_ck0_en", "usb_ln0", 4),
@@ -53,7 +53,7 @@ static const struct mtk_gate_regs sgmii1_cg_regs = {
 		.ops = &mtk_clk_gate_ops_no_setclr_inv,	\
 	}
 
-static const struct mtk_gate sgmii1_clks[] __initconst = {
+static const struct mtk_gate sgmii1_clks[] = {
 	GATE_SGMII1(CLK_SGM1_TX_EN, "sgm1_tx_en", "usb_tx250m", 2),
 	GATE_SGMII1(CLK_SGM1_RX_EN, "sgm1_rx_en", "usb_eq_rx250m", 3),
 	GATE_SGMII1(CLK_SGM1_CK1_EN, "sgm1_ck1_en", "usb_ln0", 4),
@@ -75,7 +75,7 @@ static const struct mtk_gate_regs eth_cg_regs = {
 		.ops = &mtk_clk_gate_ops_no_setclr_inv,	\
 	}
 
-static const struct mtk_gate eth_clks[] __initconst = {
+static const struct mtk_gate eth_clks[] = {
 	GATE_ETH(CLK_ETH_FE_EN, "eth_fe_en", "netsys_2x", 6),
 	GATE_ETH(CLK_ETH_GP2_EN, "eth_gp2_en", "sgm_325m", 7),
 	GATE_ETH(CLK_ETH_GP1_EN, "eth_gp1_en", "sgm_325m", 8),
diff --git a/drivers/clk/mediatek/clk-mt8516.c b/drivers/clk/mediatek/clk-mt8516.c
index 21eb052b0a539..342a59019fea9 100644
--- a/drivers/clk/mediatek/clk-mt8516.c
+++ b/drivers/clk/mediatek/clk-mt8516.c
@@ -544,7 +544,7 @@ static const struct mtk_gate_regs top5_cg_regs = {
 #define GATE_TOP5(_id, _name, _parent, _shift)				\
 	GATE_MTK(_id, _name, _parent, &top5_cg_regs, _shift, &mtk_clk_gate_ops_setclr)
 
-static const struct mtk_gate top_clks[] __initconst = {
+static const struct mtk_gate top_clks[] = {
 	/* TOP1 */
 	GATE_TOP1(CLK_TOP_THEM, "them", "ahb_infra_sel", 1),
 	GATE_TOP1(CLK_TOP_APDMA, "apdma", "ahb_infra_sel", 2),
-- 
2.51.0



