Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023554;
	b=t1gmTuoCj9Wahp0SvUFO9r8gTUmLCcNFa669NDcfsriGfYITzGgpRULblTGw1i1ED7Oz
	 FHBrEHFJG1Px3txUPojptWP0/a+9Q4Ev4/4jWVLrbWGy8pLoHAindiwIDt9ZfrNZgKtuJ
	 Qao3fpHEFozbZlonKz8WAeT6iBgiiMf81wLsXJHTnMt57wWTo/Qgxb3sDKXn0N3wjMs1y
	 SGmOAKM14FxTsftE3tJU/ycGARj+qMiuVwALhe1QsiIdQKWowWPcmxulNkgQmsAJw+Gl+
	 Kb0aYHLrSDFdpH07BTMqSReXhAYh7OrdFyTdWeGU/hKcLxnGznGvqS2i9M8b/p+3y2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023554;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wZbiqrnhPWES+5Kvc0RkaqMYdhIqSKwDg7yx4aCc5ek=;
	b=n252het5RCE6h+Fai5ECnvbPb23Uc3MiRQmhBF95DzxOkjlngHUoofq/uOFz4SXx6Cvv
	 SA+F+ATms20+/Ha+YCAWQ3C4W8dsWNypSC/BL1cwO+5aX8gVr+C0ysV0WuXlh7OVgr/nG
	 peZ+a/bre7zRSMhwMa9cQWG84EtdGjdqpH4FglJbYySrXJTPT3uqVX4QrPXfTAPlxRWkt
	 cmyF4SNRszD5cK3JUR4jFMOIU9WbaR1N5YewPUyztcPLgtxOy/AM/8MB3SwgtfYyk6rH7
	 pGrUadrRjFET8+i+EmNAVwCgQSZBNK1ppYCuWnIacgZ7ff0OINMK9rNww9IPSlazwjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h3MCcxsM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AABE606A333;
	Wed, 18 Nov 2026 17:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h3MCcxsM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3C41F000C4;
	Wed, 18 Nov 2026 17:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023554;
	bh=wZbiqrnhPWES+5Kvc0RkaqMYdhIqSKwDg7yx4aCc5ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h3MCcxsM3udD6S30UbraWEObH+I+hxq+D4msGGDpUCn8TmGa1bvByHwAcG1SFmWBi
	 r3gp++6DMuWRH5luQUdWy1HH3jB3FeRP47Ig1uAEbShfZQm+isjj3iUxlEiyx8kPSw
	 J7+4cxifYCJl5SQ10AlE/C+eAofgP/0SjqjtV9Ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Jared McArthur <j-mcarthur@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0411/2151] arm64: dts: ti: k3-j784s4-j742s2-evm-common: Set ACSPCIe refclk to MAIN_PLL2_HSDIV4 for pcie1
Date: Wed, 18 Nov 2026 15:35:46 +0100
Message-ID: <20261118150137.038101607@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2834f0a8bbee0..2d6f80636de2a 100644
--- a/arch/arm64/boot/dts/ti/k3-j784s4-j742s2-evm-common.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j784s4-j742s2-evm-common.dtsi
@@ -1196,6 +1196,8 @@ &pcie1_rc {
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



