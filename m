Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE3630EF97;
	Wed, 25 Feb 2026 06:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002665; cv=none; b=JWFmu29e/wiuaHYhmHSU8mUkaUOwVtZd6greedsz+ycToVH8iq2TMNN0jh2B9HQbcf8Dj58QlGAXHa7bw2R17IBSEBhsNmd02Z5z14CJNJikuSKu36KG4QZKXQFIHCfOfdXuxfE8g0ciUDpEbJcRjBSlkenhg2Xr+71CMEvjpe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002665; c=relaxed/simple;
	bh=jqTWTnQPqn+lu9oyCHqfseB4zhOF2B4TTKGMHGiS90Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SGiWB5vmKj8CV/xpFFkG0eSTZdKhepJMRrLjmN4hb1hIomHW6DDvAjxuMgJXLlxHISDqHnBQTbRDSZLpcQwtWVKp7Fw1UliYho3HZ3WZKwpvCIhVmc8dhAvwtBTtNEcoeR9BvgLEKoF59LoPHswh9YMTQiJfN66BaAjh7waA/zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zDH8PUoI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zDH8PUoI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC26C116D0;
	Wed, 25 Feb 2026 06:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002664;
	bh=jqTWTnQPqn+lu9oyCHqfseB4zhOF2B4TTKGMHGiS90Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zDH8PUoIgpb/qIiJeY9gVO+iWmGF2f4CxhChN/es8FQXxjwTebXQDo/z5+DcouJR5
	 sHqEDC9uH3OTYRy+A/e7Os/TN7JR4JMuy+RJEilW7BJPrJxBSsaQrMt296rYAK2/SF
	 LuSlLVS0U63oADPOi8UyvpWCCGuiICRBjaNllaRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sjoerd Simons <sjoerd@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Laura Nao <laura.nao@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 445/641] clk: mediatek: Drop __initconst from gates
Date: Tue, 24 Feb 2026 17:22:51 -0800
Message-ID: <20260225012359.307359753@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



