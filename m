Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13009170A3A;
	Tue, 12 Nov 2024 10:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407334; cv=none; b=UKSCiFPf2gKPHLNHu3UZGpPTIBiUuWoDo8ElzqJvciTRoPrD9Gn0jtoS4IoXeMffMwqPIlW+92KatM0nR22NWgCYnMMxZxnIqWlhuV9sII59apFds1QLUGWdiVvF/yqnQdHL0Je5td0mMu42Fr/TihalqWeEqnfkE9hi31s1YCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407334; c=relaxed/simple;
	bh=/18pJu6vInkdd3amG/6+/zl0R8VJa5z4FDTyqSMMzlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c2NUqPLI/lfax6riYzSXIGTRur3QGSiI5YobEVH39MBUBhZkmIqDXpC2IT0+2NBc0KRHJuBzyl+Eu1OfFEO0Jom2FElsaovWeCjgxm/LyO9E0K2hcFXdrEu0ykBzDzmiBeqvrZovbyuWmpvCITwcGITVE9ZCEqxAsdso/c4fZfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MYL1tYXW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MYL1tYXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7457AC4CECD;
	Tue, 12 Nov 2024 10:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407333;
	bh=/18pJu6vInkdd3amG/6+/zl0R8VJa5z4FDTyqSMMzlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MYL1tYXWBf293raWppbwIJm9J3oCgqM/2XfLctBH7Dz5FnidOgltfKlkssMmlz5Z8
	 fD+wrB0tKHkY0pYpEyF7xX3eMPsvQWEM0arL10yrP2ejARwdyVrLahGbCB37R9WNs7
	 tfltTXsUbL+vlqhMQvBqEshl/e4nKzhtc1hmyic8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caesar Wang <wxt@rock-chips.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 14/98] ARM: dts: rockchip: Fix the spi controller on rk3036
Date: Tue, 12 Nov 2024 11:20:29 +0100
Message-ID: <20241112101844.814456164@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/rk3036.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/rk3036.dtsi b/arch/arm/boot/dts/rk3036.dtsi
index 4e208528eebf2..5bdbadd879fe8 100644
--- a/arch/arm/boot/dts/rk3036.dtsi
+++ b/arch/arm/boot/dts/rk3036.dtsi
@@ -550,11 +550,11 @@
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



