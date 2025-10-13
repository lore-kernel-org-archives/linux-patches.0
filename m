Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA253112BE;
	Mon, 13 Oct 2025 15:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369053; cv=none; b=TfmeBkm2d3qwwqdBqkT4cmICXoLCw9pP6l7v28a0+99JdcZZ2UHAq9lGYSlxvHI0dzlw8PXhmUGVWf3XGnTUKMM4QlcnLC1DNRx8xjdSLoysaJgvZWFGymlLomUzXZO9rmIj6X8uV7nZhJgh+iZFTBwXGlfNUzfv/VHj762ho8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369053; c=relaxed/simple;
	bh=0CFlXRLs3QNtGhZgCFE67j0CPt4rO72/8MHhT2nCR5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MFePL314strOHRqLPILR9+U+j4cMzQPZXSN0iVyWP9s/BzlIdK62UJF2HPOpUUkXZJ8DIWt9B7NFIxeYEzfUSnLDK3lBE150teoi1tRUvMgqAStTo0QJiPgqqNz2uoSXPtMXReStVw67YgANfY9Rn7U4lDc0TUCkr5O8RvdVbsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZRsb8x/n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZRsb8x/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F19C4CEE7;
	Mon, 13 Oct 2025 15:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369052;
	bh=0CFlXRLs3QNtGhZgCFE67j0CPt4rO72/8MHhT2nCR5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZRsb8x/nLz8EX2XUlFw1q+B6CMXEnL1SGq0ZxglzOWTmh2JjDrwClko+O1O1mxfBr
	 xRkilHyf86MdoJRv4H/xvup5tlLKCXp7E+1FxtQ0BcGKl6L+wRB/3pHAR41li7skpU
	 D8I5RuiI1DkVZcLf4jUpraJPk3L4eMtQksBq76GE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoqing Jiang <guoqing.jiang@canonical.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Macpaul Lin <macpaul.lin@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 111/563] arm64: dts: mediatek: mt8195: Remove suspend-breaking reset from pcie0
Date: Mon, 13 Oct 2025 16:39:32 +0200
Message-ID: <20251013144415.316350330@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 8877953ce292b..ab0b2f606eb43 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -1588,9 +1588,6 @@ pcie0: pcie@112f0000 {
 
 			power-domains = <&spm MT8195_POWER_DOMAIN_PCIE_MAC_P0>;
 
-			resets = <&infracfg_ao MT8195_INFRA_RST2_PCIE_P0_SWRST>;
-			reset-names = "mac";
-
 			#interrupt-cells = <1>;
 			interrupt-map-mask = <0 0 0 7>;
 			interrupt-map = <0 0 0 1 &pcie_intc0 0>,
-- 
2.51.0



