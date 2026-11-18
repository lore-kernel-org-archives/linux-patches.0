Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016231;
	b=QqZuIquNL7RZ+dXMlErAu+q5grdVA+P2BARpHvzcFy/xzOgEnejU8pXX69qU9FMRNWqO
	 UOQOBacsfQtiOMAfYHbuxtdOjdsfAEk0HTTzbbh72OXaZke/XGxS92grndhGKw5e9kVTs
	 z7kE6f+SDZRt6vPu4QWkRorHtFCSFCWf3T/HY7Q+sNrpGU27rU6jEyj6dL7eyGq2Xk6A1
	 kMIu56PXUrErnrIBFyu44tzriG8C24wIuZm+QpCwXFQSl5K5Fcc0Cd7TOtKXgw6foX+Z6
	 qygMkNHgAPJ4lD7txyyMI+JLUmsTpSGg1NWSI2UbPoOQSmice7CxYNAODSh+jSajL5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016231;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7Y91qhOGPApGeQN+auz7LYxAg/fyE3lg0M4s0lPbO4U=;
	b=JLmyE1UGbyBoM4AxBCBxqr6UroAK6RZZOA7w/nsmCu7DxDqebihpIEQAFynkugUQX/CH
	 MbPB9lakTne/S9ka2HBQRAjjG4RnvmOJe57QxTLO9FiaVV3rZhH1e0KsM4gSg2ptzSpNj
	 0G+D/V4admvWrdRr0JyfL+PtTXJ0V0MFeVQ+Bow82a4e+XVOAPuCDk7h13jYTuV7ytZcE
	 IA1OjI7+POrrT9Sz6KJ73WLmKjQ/Za1MXoBtJoTpk5M2gRdNON7CIvYhyktKYzzlfmW4O
	 aGNWaJtdQAFMGKEO1xL997+7X247QfYOwA/49hWk+iEtIByIspZ6ZqJrfZQhx713ytw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cZiT9HV0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0D0606A320;
	Wed, 18 Nov 2026 15:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cZiT9HV0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9163E1F000C5;
	Wed, 18 Nov 2026 15:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016231;
	bh=7Y91qhOGPApGeQN+auz7LYxAg/fyE3lg0M4s0lPbO4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cZiT9HV0YA07qWziAVxOWLWCmZqhqoofM5j8oK710mgQHEm+ZV5Pep9unkBIiTSHP
	 23ChGP65hRqANDtavVpYIARDpjFFMFUvk+zh8WRDC4IgGwpS63iJlrSIS4hueQQcMu
	 LHDza+AG1bJCC0OoUh7zBrbuVsSusGlYKX598F90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Jared McArthur <j-mcarthur@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0428/2651] arm64: dts: ti: k3-j784s4-j742s2-evm-common: Set ACSPCIe refclk to MAIN_PLL2_HSDIV4 for pcie1
Date: Wed, 18 Nov 2026 15:27:48 +0100
Message-ID: <20261118150303.233855163@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jared McArthur <j-mcarthur@ti.com>

[ Upstream commit 7e4b4f799bd043cb5b30176ddbe690a0fb5788bc ]

Commit e3dfcf482d07 ("arm64: dts: ti: k3-j784s4-j742s2-evm-common:
Enable ACSPCIE0 output for PCIe1") enabled the ACSPCIE0 buffers
to provide the PCIe refclk for PCIe1, but introduced a bug
where the clock is remporarily disabled during initialization.
The ACSPCIe reference clock is muxable between multiple
sources: SERDESx_REF_DER_OUT_CLK, MAIN_PLL2_HSDIV4_CLKOUT, and
SERDESx_REF_OUT_CLK [0]. On reset, the refclk is set to the
SERDESx_REF_DER_OUT_CLK. In the J742S2 and J784S4, "the SerDes PCIe
Reference Clock Output will be temporarily disabled when changing Data
Rates to or from 8.0 GT/s in Derived Refclk mode" [1]. Some external PCIe
devices cannot tolerate the reference clock being disabled and will
therefore fail to link.

This advisory is described in more detail as: i2242 of the J784S4
Silicon Revision 1.0 (Rev. B) document [1].

The refclk for devices connected to PCIe1 is provided by the ACSPCIe
buffers in the J742S2XH01EVM [2] and J784S4XEVM [3]. Work around
the advisory by setting the ACSPCIe reference clock source to
MAIN_PLL2_HSDIV4_CLKOUT. Use the TI SCI clock controller to assign the
clock's source [4].

[0] https://www.ti.com/lit/zip/spruj52
[1] https://www.ti.com/lit/pdf/SPRZ536
[2] https://www.ti.com/lit/zip/SPAC001
[3] https://www.ti.com/lit/zip/SPRR458
[4] https://software-dl.ti.com/tisci/esd/latest/5_soc_doc/j784s4/clocks.html

Fixes: e3dfcf482d07 ("arm64: dts: ti: k3-j784s4-j742s2-evm-common: Enable ACSPCIE0 output for PCIe1")
Reviewed-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Signed-off-by: Jared McArthur <j-mcarthur@ti.com>
Link: https://patch.msgid.link/20260908185903.404451-1-j-mcarthur@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j784s4-j742s2-evm-common.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-j784s4-j742s2-evm-common.dtsi b/arch/arm64/boot/dts/ti/k3-j784s4-j742s2-evm-common.dtsi
index ff3a85cbc524a..7c085663c8880 100644
--- a/arch/arm64/boot/dts/ti/k3-j784s4-j742s2-evm-common.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j784s4-j742s2-evm-common.dtsi
@@ -1206,6 +1206,8 @@ &pcie1_rc {
 	status = "okay";
 	clocks = <&k3_clks 333 0>, <&serdes0 CDNS_TORRENT_REFCLK_DRIVER>;
 	clock-names = "fck", "pcie_refclk";
+	assigned-clocks = <&k3_clks 415 0>;
+	assigned-clock-parents = <&k3_clks 415 2>;
 	num-lanes = <2>;
 	reset-gpios = <&exp1 2 GPIO_ACTIVE_HIGH>;
 	phys = <&serdes0_pcie1_link>;
-- 
2.53.0



