Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D5A154C00;
	Fri, 15 Nov 2024 06:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652966; cv=none; b=TIdnjamC0sIWvmZk/RJIr5uNBpghg95mAKowDmMSy5tddhJFPV5F2NNT+NatomdA8am11PkI04Fr8SwhdSVjotqVR620uEYjPLzv7nhGFWQaueBTdJ3kAOvnL9KbLNei6miBVrSoF/jJBUbUxIM0i3wi21g3QYZSRPN6xlypLQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652966; c=relaxed/simple;
	bh=UK1PCDpwm2GeDA7j+hrow0xTEKScH82QYswEqZBn1qU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M3IRCcthlEIxxJJkFBQ++5QkWf3wBOY5h4f/XOzBjrBAz8OECOU07kRox1VAD3GgCbloeJtr3wDalnNfUKYDhUNfVQzfuUroF+qBIeMA7zGSr1BhpUGPdhaALW6pocg0QCrFkGzG60SpV9xVNjoL6FjSJ+C7NUfil6nN96NXkhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q0/2NjHj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q0/2NjHj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5882C4CED2;
	Fri, 15 Nov 2024 06:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652966;
	bh=UK1PCDpwm2GeDA7j+hrow0xTEKScH82QYswEqZBn1qU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q0/2NjHjlsXCQdCXdlNAYeoTIMHb5l9cgPOP2sLkxZNPOdx1DZF2CtE/kBYGsxjKM
	 cz9PlN/Gf2yLHYSwTr6ia8Ohs7tvgIyvrQaaDrzJ6lD/beRnz2xjBcLuRP/JrBKcdW
	 izYE7R8cWcCMBMTGyD/65WPGmwWPqddZWaOJg7O8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caesar Wang <wxt@rock-chips.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 07/66] ARM: dts: rockchip: Fix the spi controller on rk3036
Date: Fri, 15 Nov 2024 07:37:16 +0100
Message-ID: <20241115063723.106320004@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.834793938@linuxfoundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 7c031260186db..c26981c75c21c 100644
--- a/arch/arm/boot/dts/rk3036.dtsi
+++ b/arch/arm/boot/dts/rk3036.dtsi
@@ -489,11 +489,11 @@
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



