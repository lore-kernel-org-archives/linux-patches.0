Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3F519CCEC;
	Tue, 22 Jul 2025 14:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192884; cv=none; b=pBy08TVyhC5rGJD8fyKMLWT7yI582S02URFY2FmDB6PA6H9fyxTahm2Iq2L22yrvRAXOz9mhp8MXLaD7aoW1IqEDv6P6uwZg2Zu4Uze/rlZ4BuV2MGLKWGzRDMRHtGnUhJv31807w4WRtMRYyiyjgu4/q9FuSNnJaWADRZef1KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192884; c=relaxed/simple;
	bh=fINcdv2diPFgVS2+6HSqUs5El0gGMBzvAc7hIyyayLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MexZDqfsB5MTloSjTjuohMPdrPm1kPdvYRk18rpiDbkDbAgNhxcHfeA4XG3N076V3hlNiFlr9q9IM7+5eMF6BR8ZNgP82LGO7ct6NGnijIpdYjlpFbXoJ80M9ek7wnemTOmb2o8U+tQ/3RjQ2ZCuTqeza2x7W5GA2lVITuwZsPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CEzIxI1l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CEzIxI1l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC3CC4CEEB;
	Tue, 22 Jul 2025 14:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192884;
	bh=fINcdv2diPFgVS2+6HSqUs5El0gGMBzvAc7hIyyayLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CEzIxI1lavdSMKsj8nfSIs6rjhR1gQWSj3LgpSjpvPWT8Iz/B3mIIf3cEOYbg+/yh
	 xw0fpn/dNs8hFyLQfRcXGsk2iKQmatXh0e25kC6cwVAfGq8USTXuOeG/WrpJgDfpIY
	 JfpW7yuFNpqq/Tgx0AGR2Wi6zKlE+JmgLxfkCfV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 086/158] arm64: dts: imx95: Correct the DMA interrupter number of pcie0_ep
Date: Tue, 22 Jul 2025 15:44:30 +0200
Message-ID: <20250722134343.976501385@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Zhu <hongxing.zhu@nxp.com>

[ Upstream commit 61f1065272ea3721c20c4c0a6877d346b0e237c3 ]

Correct the DMA interrupter number of pcie0_ep from 317 to 311.

Fixes: 3b1d5deb29ff ("arm64: dts: imx95: add pcie[0,1] and pcie-ep[0,1] support")
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx95.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx95.dtsi b/arch/arm64/boot/dts/freescale/imx95.dtsi
index f904d6b1c84bf..7365d6538a733 100644
--- a/arch/arm64/boot/dts/freescale/imx95.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx95.dtsi
@@ -1523,7 +1523,7 @@
 			      <0x9 0 1 0>;
 			reg-names = "dbi","atu", "dbi2", "app", "dma", "addr_space";
 			num-lanes = <1>;
-			interrupts = <GIC_SPI 317 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 311 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "dma";
 			clocks = <&scmi_clk IMX95_CLK_HSIO>,
 				 <&scmi_clk IMX95_CLK_HSIOPLL>,
-- 
2.39.5



