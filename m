Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40D61C68C;
	Sun,  1 Sep 2024 16:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208636; cv=none; b=NRqiJms4SCBSkcyGGxFMCgCLNo+BIVcSbl4g8HYGjPMdDBSZ5T+6GYVP+huuDiyWl2xmfmrD//nJ21z2UWwjeanRjVqbHiHWc5rUrq+qjOM+XDuM8bhxHe2OBakdJHJbrTMyR9slHDE0WRy7si9mCMN16xGOpRtJdmn4QK2/wFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208636; c=relaxed/simple;
	bh=p3x9dBwF1IarLKQj8HWOn/mHCk/TxXpUYPqLLs93wUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pj5dY6Nj06AKQHH/Xw7kAowm/cAuHt6z+kVTJeCiojGLn2CkbJPHxm0+YNtiKzo0blml3qIAkWUUUnsKT16a/Q1e/TTPY58Un8ah2QLbUVzfbEJWGhIk6JYeGV3XWK+o4lwrvAd99vVvkditvjEjMwwYKqJ+dpGv3xzRvnhBALw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cOwrhPpa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cOwrhPpa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15898C4CEC3;
	Sun,  1 Sep 2024 16:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208636;
	bh=p3x9dBwF1IarLKQj8HWOn/mHCk/TxXpUYPqLLs93wUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cOwrhPpadqfvWQr6EkaA56ojYhLA19sGanUZZ9Lmy0pxRSInNCjg6wH8iyphV/iDS
	 tUs0gysr+VqAH4u6h5YyuzXy5z8sU2Bw+t4d4dJERON6woLzypEcwvzUKxIpWz1KI3
	 Nf/riC7u9io3tfEZDkvdpStwaf2y/0QxGN+nWB6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenwei Wang <shenwei.wang@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 143/149] arm64: dts: imx93: update default value for snps,clk-csr
Date: Sun,  1 Sep 2024 18:17:34 +0200
Message-ID: <20240901160822.824565956@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shenwei Wang <shenwei.wang@nxp.com>

[ Upstream commit 109f256285dd6a5f8c3bd0d80d39b2ccd4fe314e ]

For the i.MX93 SoC, the default clock rate for the IP of STMMAC EQOS is
312.5 MHz. According to the following mapping table from the i.MX93
reference manual, this clock rate corresponds to a CSR value of 6.

 0000: CSR clock = 60-100 MHz; MDC clock = CSR clock/42
 0001: CSR clock = 100-150 MHz; MDC clock = CSR clock/62
 0010: CSR clock = 20-35 MHz; MDC clock = CSR clock/16
 0011: CSR clock = 35-60 MHz; MDC clock = CSR clock/26
 0100: CSR clock = 150-250 MHz; MDC clock = CSR clock/102
 0101: CSR clock = 250-300 MHz; MDC clock = CSR clock/124
 0110: CSR clock = 300-500 MHz; MDC clock = CSR clock/204
 0111: CSR clock = 500-800 MHz; MDC clock = CSR clock/324

Fixes: f2d03ba997cb ("arm64: dts: imx93: reorder device nodes")
Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx93.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx93.dtsi b/arch/arm64/boot/dts/freescale/imx93.dtsi
index 4a3f42355cb8f..a0993022c102d 100644
--- a/arch/arm64/boot/dts/freescale/imx93.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx93.dtsi
@@ -1105,7 +1105,7 @@
 							 <&clk IMX93_CLK_SYS_PLL_PFD0_DIV2>;
 				assigned-clock-rates = <100000000>, <250000000>;
 				intf_mode = <&wakeupmix_gpr 0x28>;
-				snps,clk-csr = <0>;
+				snps,clk-csr = <6>;
 				nvmem-cells = <&eth_mac2>;
 				nvmem-cell-names = "mac-address";
 				status = "disabled";
-- 
2.43.0



