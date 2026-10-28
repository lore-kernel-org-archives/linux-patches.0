Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215407;
	b=k3Q98+UoZFHRUR4RaPGTLQ2JgCzAxv0Jxqsfh6fhZE78nib7lI71+FEe215BTKUYAFMY
	 0FofKp9XqMGUQLG6+23VeLHT+aqiemYjStXrX6IpE26mwlPInetU/zH0SnTrXPHpR2Vff
	 4VCfQzz90wfnx+zniL/vbsmm3b0JKhAJiU9CSIVwkltpJB26okSsJphBrh7lS/UGIZsc0
	 ncGmq5JXLhlQvb3wjlVxjkL46fhR/ezeq19ZLvPF2quVxwcKEOM3G1/PlTT5uJUZo2Jgl
	 JypNBAs+YVgBYZ3u+4Yry5jfjKkWnwIpW06cB5IcpYm2yBe1NQ/Rdxj/4Ikm6B+z2YQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215407;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hLU2peaqD3Ly65CvaA4E9z+YPmYfKDc2zfTAxalxgXg=;
	b=Jw4JU3O01PHl2KFPA26nPFy9Me1OdOgp4FXz77sx0DndR2AVcJ1V+LrICc1srA5PcIua
	 JkHObp7+0OIq3U+iL+Vz8SaTfQ/3/k9euuuAd6+7QYVybbOnuCTcInA8yZ/P+4K9ErZjF
	 OqAOWBxBa9Zw4HmoRZTxO4u8opp3FC5i4bJeH7dFhhlNol8PH0jSNWTE3fSYmMmZYnowx
	 YMpqMjkD3ewdHvQwR6MTDwD/JfADk14+JjDepoufNTyxVxg3a9Oy1+E/s2sZTlBoNWfLf
	 1BApL7ZjQ5k0WqXfx39CBahcmSsJ5CcehGSEnQG/YGTSGSeyn3Ko+IKJJ8Mg4qiXvTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sQTfKPuV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82158606A31A;
	Wed, 28 Oct 2026 19:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sQTfKPuV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA4F1F01828;
	Wed, 28 Oct 2026 19:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215407;
	bh=hLU2peaqD3Ly65CvaA4E9z+YPmYfKDc2zfTAxalxgXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sQTfKPuV8nkt2r0A0iFOJPj5dVEBI/ScjG/Ca2hL92islNntayrBv2Fmiu1zCJjEf
	 WjWA+PqeO2p8bdtermp/ujHZD7wFZkO1Zagf5aj5UUNDH1wMrtQJlyBcZGR59eII5l
	 L3RQ/RL8fKnnpYN8HPRmdUhQZu/bkY3jCxy2jjiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1200/1887] pmdomain: imx: Fix i.MX8MP VC8000E power up sequence
Date: Wed, 28 Oct 2026 17:54:56 +0100
Message-ID: <20261028170526.711699031@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 25e252bcf1593b420b12a7231d9dd64b885a2ae2 ]

Per errata[1]:
ERR050531: VPU_NOC power down handshake may hang during VC8000E/VPUMIX
power up/down cycling.
Description: VC8000E reset de-assertion edge and AXI clock may have a
timing issue.
Workaround: Set bit2 (vc8000e_clk_en) of BLK_CLK_EN_CSR to 0 to gate off
both AXI clock and VC8000E clock sent to VC8000E and AXI clock sent to
VPU_NOC m_v_2 interface during VC8000E power up(VC8000E reset is
de-asserted by HW)

Add a bool variable is_errata_err050531 in
'struct imx8m_blk_ctrl_domain_data' to represent whether the workaround
is needed. If is_errata_err050531 is true, first clear the clk before
powering up gpc, then enable the clk after powering up gpc.

[1] https://www.nxp.com/webapp/Download?colCode=IMX8MP_1P33A

Fixes: a1a5f15f7f6cb ("soc: imx: imx8m-blk-ctrl: add i.MX8MP VPU blk ctrl")
Cc: stable@vger.kernel.org
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/imx8m-blk-ctrl.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/imx/imx8m-blk-ctrl.c b/drivers/soc/imx/imx8m-blk-ctrl.c
index 65315bf908b36..8a80b2d1035b2 100644
--- a/drivers/soc/imx/imx8m-blk-ctrl.c
+++ b/drivers/soc/imx/imx8m-blk-ctrl.c
@@ -59,6 +59,15 @@ struct imx8m_blk_ctrl_domain_data {
 	 * register.
 	 */
 	u32 mipi_phy_rst_mask;
+
+	/*
+	 * VC8000E reset de-assertion edge and AXI clock may have a timing issue.
+	 * Workaround: Set bit2 (vc8000e_clk_en) of BLK_CLK_EN_CSR to 0 to gate off
+	 * both AXI clock and VC8000E clock sent to VC8000E and AXI clock sent to
+	 * VPU_NOC m_v_2 interface during VC8000E power up(VC8000E reset is
+	 * de-asserted by HW)
+	 */
+	bool is_errata_err050531;
 };
 
 #define DOMAIN_MAX_CLKS 4
@@ -115,7 +124,11 @@ static int imx8m_blk_ctrl_power_on(struct generic_pm_domain *genpd)
 		dev_err(bc->dev, "failed to enable clocks\n");
 		goto bus_put;
 	}
-	regmap_set_bits(bc->regmap, BLK_CLK_EN, data->clk_mask);
+
+	if (data->is_errata_err050531)
+		regmap_clear_bits(bc->regmap, BLK_CLK_EN, data->clk_mask);
+	else
+		regmap_set_bits(bc->regmap, BLK_CLK_EN, data->clk_mask);
 
 	/* power up upstream GPC domain */
 	ret = pm_runtime_get_sync(domain->power_dev);
@@ -124,6 +137,9 @@ static int imx8m_blk_ctrl_power_on(struct generic_pm_domain *genpd)
 		goto clk_disable;
 	}
 
+	if (data->is_errata_err050531)
+		regmap_set_bits(bc->regmap, BLK_CLK_EN, data->clk_mask);
+
 	/* wait for reset to propagate */
 	udelay(5);
 
@@ -514,6 +530,7 @@ static const struct imx8m_blk_ctrl_domain_data imx8mp_vpu_blk_ctl_domain_data[]
 		.clk_mask = BIT(2),
 		.path_names = (const char *[]){"vc8000e"},
 		.num_paths = 1,
+		.is_errata_err050531 = true,
 	},
 };
 
-- 
2.53.0



