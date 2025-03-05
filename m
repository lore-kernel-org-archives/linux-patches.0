Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955106ADD;
	Wed,  5 Mar 2025 17:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197046; cv=none; b=ZagRmOxoPYqwNXCOBBxWuWPTKgf4BxFlwdjfdmFeUa/iT+a+WC854C4cJPM1LoIJKdI4Z70wEC7kp3Iguv31KeT30vXYigQ/8hT293iGFTJZc8bU/vu+kMGxcX9BupM8v5DTqI230EMhqYT4u3+9XDrNV12jYWpoxAOArdBfR74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197046; c=relaxed/simple;
	bh=rnRUO9BgTne7684l0d1gTAcmYDVmXYvVOSWSG6MYltc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lk5RsmO2AUC0zT8AfXa0aovD1lwvBiL+sYeiRdFc78q8us9bevxR1ov5xJ3OFyVzde5Wxb5UB76LRJi+qMnSgletIk+jiq0NLOStm356zOHOmGy0bJaIvlH31BHRQDZEjUGfkEbb0sv+mD2RTJkgm7bPTCc1v0oixBXccZqRqhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GTJUmUrg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GTJUmUrg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2C2C4CED1;
	Wed,  5 Mar 2025 17:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197046;
	bh=rnRUO9BgTne7684l0d1gTAcmYDVmXYvVOSWSG6MYltc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GTJUmUrgPfNFu7CLtEoLVBJxKZ8V/xtmsg+rR9A2MLsGU74S+/NqNldZBPJWXKiKJ
	 GiJZSq3hihejMxAkgknKdII9JEQEqLOoLMkDQi7cDw9wJN/7zeyKUXsr5cwVtCpK2J
	 bPnrlCfIwddHOVDinV/bI2F2xZRizazx0g2QC4io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/176] clk: mediatek: mt2701-bdp: add missing dummy clk
Date: Wed,  5 Mar 2025 18:46:29 +0100
Message-ID: <20250305174506.275657507@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit fd291adc5e9a4ee6cd91e57f148f3b427f80647b ]

Add dummy clk for index 0 which was missed during the conversion to
mtk_clk_simple_probe().

Fixes: 973d1607d936 ("clk: mediatek: mt2701: use mtk_clk_simple_probe to simplify driver")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Link: https://lore.kernel.org/r/b8526c882a50f2b158df0eccb4a165956fd8fa13.1734300668.git.daniel@makrotopia.org
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mt2701-bdp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/mediatek/clk-mt2701-bdp.c b/drivers/clk/mediatek/clk-mt2701-bdp.c
index b0f0572079452..d2647ea58ae28 100644
--- a/drivers/clk/mediatek/clk-mt2701-bdp.c
+++ b/drivers/clk/mediatek/clk-mt2701-bdp.c
@@ -31,6 +31,7 @@ static const struct mtk_gate_regs bdp1_cg_regs = {
 	GATE_MTK(_id, _name, _parent, &bdp1_cg_regs, _shift, &mtk_clk_gate_ops_setclr_inv)
 
 static const struct mtk_gate bdp_clks[] = {
+	GATE_DUMMY(CLK_DUMMY, "bdp_dummy"),
 	GATE_BDP0(CLK_BDP_BRG_BA, "brg_baclk", "mm_sel", 0),
 	GATE_BDP0(CLK_BDP_BRG_DRAM, "brg_dram", "mm_sel", 1),
 	GATE_BDP0(CLK_BDP_LARB_DRAM, "larb_dram", "mm_sel", 2),
-- 
2.39.5



