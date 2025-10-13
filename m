Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DBD3093C9;
	Mon, 13 Oct 2025 15:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368124; cv=none; b=P/37bZ1D7nxrnOLnTtzG5HkQBDk8FtPkdAdCVzWl7suHHWaXqVSeB34BeskfPEb7PVBuU9wDLTfOdqtHcVBswWyVJ+KyXsyls5mbQDPCN0caXp0no9eMKfbiKP6eFpNwPLICRwiH4aAYcnOLzX6rUnBJeOBim22RmKZfNaCXGS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368124; c=relaxed/simple;
	bh=paa7JaKwW3ECcFr/xLgof+WcKk50N9oB3+yY57WsB7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P0NTD/6593mS7xZRB3yDAB5zJjMXj/Q9+XjWr/WmkPo4gLy8Zm/6fOTYFpoYDwwe+XHPXsYz7wFbayb3A7ObjNpPCDH7h+X8Kyotm6Itwlnr8JfBTZOFxNgs+RiE62zxSXFlfkif8vL8rkqWx3bzJXZ3tkC2/EP7kilfDXTx1aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gc/Krv2q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gc/Krv2q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27945C4CEE7;
	Mon, 13 Oct 2025 15:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368124;
	bh=paa7JaKwW3ECcFr/xLgof+WcKk50N9oB3+yY57WsB7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gc/Krv2qWjdbHU3fSQZjvFRGK1hAjglPkObDTVH4UQzDAI2U6daDlR8q200x/1NS5
	 vQIaoe52HmwzzpoTS8ey0juA9TBVyfibusMOwacABDLfOdUuo/m0om/Z+vF2JJw4Be
	 K/kUgL/52rdbnLDl6NJ1HilXU3oGEITRbRjhq+7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoqing Jiang <guoqing.jiang@canonical.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Macpaul Lin <macpaul.lin@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 052/262] arm64: dts: mediatek: mt8195: Remove suspend-breaking reset from pcie0
Date: Mon, 13 Oct 2025 16:43:14 +0200
Message-ID: <20251013144328.002595205@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guoqing Jiang <guoqing.jiang@canonical.com>

[ Upstream commit 3374b5fb26b300809ecd6aed9f414987dd17c313 ]

When test suspend resume with 6.8 based kernel, system can't resume
and I got below error which can be also reproduced with 6.16 rc6+
kernel.

mtk-pcie-gen3 112f0000.pcie: PCIe link down, current LTSSM state: detect.quiet (0x0)
mtk-pcie-gen3 112f0000.pcie: PM: dpm_run_callback(): genpd_resume_noirq returns -110
mtk-pcie-gen3 112f0000.pcie: PM: failed to resume noirq: error -110

After investigation, looks pcie0 has the same problem as pcie1 as
decribed in commit 3d7fdd8e38aa ("arm64: dts: mediatek: mt8195:
Remove suspend-breaking reset from pcie1").

Fixes: ecc0af6a3fe6 ("arm64: dts: mt8195: Add pcie and pcie phy nodes")
Signed-off-by: Guoqing Jiang <guoqing.jiang@canonical.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Macpaul Lin <macpaul.lin@mediatek.com>
Link: https://lore.kernel.org/r/20250721095959.57703-1-guoqing.jiang@canonical.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8195.dtsi | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195.dtsi b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
index 2e138b54f5563..451aa278bef50 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -1563,9 +1563,6 @@ pcie0: pcie@112f0000 {
 
 			power-domains = <&spm MT8195_POWER_DOMAIN_PCIE_MAC_P0>;
 
-			resets = <&infracfg_ao MT8195_INFRA_RST2_PCIE_P0_SWRST>;
-			reset-names = "mac";
-
 			#interrupt-cells = <1>;
 			interrupt-map-mask = <0 0 0 7>;
 			interrupt-map = <0 0 0 1 &pcie_intc0 0>,
-- 
2.51.0



