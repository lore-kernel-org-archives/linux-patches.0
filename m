Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4909932C94B;
	Fri, 17 Oct 2025 15:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713506; cv=none; b=lJTdICfLqjGcgsV03qOqdTDCYDT+qfd8i3t0wSbttzCdzsanTNrE24j4tSEVYDPpcVKTD+h7hNC/s/BVL2/TJtD44BRjRPn0T0pJbMUDYNs2BIAQQDpJGdFZUKxaVGRlHWf6d0GS0MZAqPMCdULWI4J2QF3+P+YnBzY785hDVQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713506; c=relaxed/simple;
	bh=sAFm3HJUeyqlNz5vnLoK1aHOGEZUh0iAP5VW+4m3PnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XTySR9eC6xr1T/bgGVIpyfYjuU/cF1Ns7R/FK1JkAAbm28w0z297gavRZ60uJ62tj88hG14AtIX13hbrepDO92fRGHjrX+Dfu55bP9Vpw6g9o+il4BAGAh/J/dExszyVkFr2YMeXoXAx0lKuZ4CHEP/9HbrpyuyTEhwshwrcqqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UwcXeZSe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UwcXeZSe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646BDC4CEFE;
	Fri, 17 Oct 2025 15:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713505;
	bh=sAFm3HJUeyqlNz5vnLoK1aHOGEZUh0iAP5VW+4m3PnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UwcXeZSemIOn6FKBf/kSzO5DMPTlYLne8uH1xYOqTFE7fpBJkR1d212xK1ERvB6L2
	 B0F78VxBtuxAuLh50TcnASToJT4K1d+wd4G34EBxCHw7UaFRJ99+AT/ZD56BpLVF2J
	 WFwIYDNf25ZqckgdbNu+6ppsZtRgi2KOEcb5v8OY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/201] clk: mediatek: mt8195-infra_ao: Fix parent for infra_ao_hdmi_26m
Date: Fri, 17 Oct 2025 16:51:22 +0200
Message-ID: <20251017145135.520269545@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 6c4c26b624790098988c1034541087e3e5ed5bed ]

The infrastructure gate for the HDMI specific crystal needs the
top_hdmi_xtal clock to be configured in order to ungate the 26m
clock to the HDMI IP, and it wouldn't work without.

Reparent the infra_ao_hdmi_26m clock to top_hdmi_xtal to fix that.

Fixes: e2edf59dec0b ("clk: mediatek: Add MT8195 infrastructure clock support")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mt8195-infra_ao.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/mediatek/clk-mt8195-infra_ao.c b/drivers/clk/mediatek/clk-mt8195-infra_ao.c
index dfba6eb61ccfe..4ecdf9ae02443 100644
--- a/drivers/clk/mediatek/clk-mt8195-infra_ao.c
+++ b/drivers/clk/mediatek/clk-mt8195-infra_ao.c
@@ -103,7 +103,7 @@ static const struct mtk_gate infra_ao_clks[] = {
 	GATE_INFRA_AO0(CLK_INFRA_AO_CQ_DMA_FPC, "infra_ao_cq_dma_fpc", "fpc", 28),
 	GATE_INFRA_AO0(CLK_INFRA_AO_UART5, "infra_ao_uart5", "top_uart", 29),
 	/* INFRA_AO1 */
-	GATE_INFRA_AO1(CLK_INFRA_AO_HDMI_26M, "infra_ao_hdmi_26m", "clk26m", 0),
+	GATE_INFRA_AO1(CLK_INFRA_AO_HDMI_26M, "infra_ao_hdmi_26m", "top_hdmi_xtal", 0),
 	GATE_INFRA_AO1(CLK_INFRA_AO_SPI0, "infra_ao_spi0", "top_spi", 1),
 	GATE_INFRA_AO1(CLK_INFRA_AO_MSDC0, "infra_ao_msdc0", "top_msdc50_0_hclk", 2),
 	GATE_INFRA_AO1(CLK_INFRA_AO_MSDC1, "infra_ao_msdc1", "top_axi", 4),
-- 
2.51.0



