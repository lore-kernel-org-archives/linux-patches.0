Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63862141DB;
	Tue, 12 Nov 2024 10:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408103; cv=none; b=tp5DHh6AGQEFcXGcrrexstrRYU+/jEc6p2e8AC7grFl5muEc+POqN10+FR3Fc0BGhyAwYWc+WXyKuhfecxZxeh09XbVsofOTCpbuyRGQK0SrpY9G68ho+u0WxMFwedruO14YmuqPBQIfcmRJeZudLvpe7vAidLAN7sPBEkh3oT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408103; c=relaxed/simple;
	bh=yVdLX32m1p8Om2pSpay/lNqkLjyFyeeTkEzDXmUOtg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bo6MIi5jJZEmm/nfxHzAu7/BsiWAA4WRTHDgM9FyweW4PJ/wQJpU3jEFCkiaXXQDzto8YgxA7eluP8ONpuoEeWtR8pkLr5WAWgqfbe6p7E5I+I2PPhgyTH9hxd2lQE3nA64v8VbMfpPcvkqoBN4WYBla0MYIfxy3FrbSBeo2yWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ondsRjIP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ondsRjIP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44CFBC4CECD;
	Tue, 12 Nov 2024 10:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408103;
	bh=yVdLX32m1p8Om2pSpay/lNqkLjyFyeeTkEzDXmUOtg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ondsRjIP4m1E7KI9yxVNe35tKhcN4+n6KovaJDO4vITAiwkTwfaYSBOmAwZk+bt7W
	 XmBpbP2HTZowwG4n1ULZ2GJMQAc3Whyl29OYc6KLnR59SwokY0DOMix/kr18H7mWrU
	 gL59QGK0/yE4JB6MqlUjyVFR9at4b36AZpGWatTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caesar Wang <wxt@rock-chips.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 029/184] ARM: dts: rockchip: Fix the spi controller on rk3036
Date: Tue, 12 Nov 2024 11:19:47 +0100
Message-ID: <20241112101901.985348046@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit 8bade1ad1f0821aef31f6a8fb1027ae292566d85 ]

Compatible and clock names did not match the existing binding.
So set the correct values and re-order+rename the clocks.

It looks like no rk3036 board did use the spi controller so far,
so this was never detected on a running device yet.

Fixes: f629fcfab2cd ("ARM: dts: rockchip: support the spi for rk3036")
Cc: Caesar Wang <wxt@rock-chips.com>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20241008203940.2573684-14-heiko@sntech.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rockchip/rk3036.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/rockchip/rk3036.dtsi b/arch/arm/boot/dts/rockchip/rk3036.dtsi
index 09371f07d7b4b..63b9912be06a7 100644
--- a/arch/arm/boot/dts/rockchip/rk3036.dtsi
+++ b/arch/arm/boot/dts/rockchip/rk3036.dtsi
@@ -553,11 +553,11 @@
 	};
 
 	spi: spi@20074000 {
-		compatible = "rockchip,rockchip-spi";
+		compatible = "rockchip,rk3036-spi";
 		reg = <0x20074000 0x1000>;
 		interrupts = <GIC_SPI 23 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&cru PCLK_SPI>, <&cru SCLK_SPI>;
-		clock-names = "apb-pclk","spi_pclk";
+		clocks = <&cru SCLK_SPI>, <&cru PCLK_SPI>;
+		clock-names = "spiclk", "apb_pclk";
 		dmas = <&pdma 8>, <&pdma 9>;
 		dma-names = "tx", "rx";
 		pinctrl-names = "default";
-- 
2.43.0



