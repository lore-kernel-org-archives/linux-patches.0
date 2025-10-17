Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F5E3370F6;
	Fri, 17 Oct 2025 14:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713066; cv=none; b=sYfLv/qXrPscqpHmMnm58j0LmIcF0SLXO3By35ET9uFGnA8DAJIjglZG9d9tzR6R7uRH3h/kSjBL2luEKPlFKvJWIAheC16yOzpi3X1STovnEEpnfE4EOK4sXVLc9gpjSieEJzc/zcf7mOkSSzUcRyCf5dAbvZx5AO70pMATSLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713066; c=relaxed/simple;
	bh=smz7diFiyEc2LJ6HvOb3raVh6rpzwfoWWsah7muajvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=royxkC+P1dkYkkOo5y6BRsjOZdYRnFb+eMAaQ6k61iCcqiS2vHTcKQPvEzBLq0wEp1Y0fzEx/ngFF09WRYscgrDhNSwny2dxDBtJNQ6eRdiTB1VnPaZbGV5N8YcOOlsR6WyhMHbKrFWusDWBV8LbHZpxojKrDd44JoJ+yoNGcDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w4+x9aPK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w4+x9aPK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F21C4CEE7;
	Fri, 17 Oct 2025 14:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713065;
	bh=smz7diFiyEc2LJ6HvOb3raVh6rpzwfoWWsah7muajvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w4+x9aPKB0Tla08ULIWBs+DOjzd6y65mWmT+XIvce+HwEshuzx6WeWVkfTr8p4KCE
	 Yb4x86qOmLFyUeyi00TUwgHlgnW9cPshSgtdZyv1vJqB3SQQYdwfDsrCjnLpGqs/Qk
	 VhuPExRWqee9O4/+tH0xeu5Va9GXfYs5PlJnAd3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 018/168] clk: mediatek: mt8195-infra_ao: Fix parent for infra_ao_hdmi_26m
Date: Fri, 17 Oct 2025 16:51:37 +0200
Message-ID: <20251017145129.689873888@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fcd410461d3bb..516b5830f16e1 100644
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



