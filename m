Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4245919E992;
	Tue, 12 Nov 2024 10:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407035; cv=none; b=hmWRAukvNiosGo3s1s3dyIWN1D6gAGuAKu6SlXGC06u9n+qobHKLsWqWwZNxmd+awdMbM3fNz9vRfCUqor922/rdyRd+UA68144KtH6hPlaR4/W0f8+B4ExkYP82LN+lzIgp4bFMGZ01vr6gZscm5AIY21CqBKTx3pSBqGkDpYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407035; c=relaxed/simple;
	bh=YJ+m3AmdL9Y20fx2OBv/DiR22IicJla0MtsyBkKWQ8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mt6RbVgNdDfcQyLx3AeF+++tIvRg9lqLOCT62QoJi2XDblRsP+zlT8IRspvOmPgT9/1ReAz8AftUUTJmbdHao0xFRKMExQ543s+mCF/0KgsjJ/FvGMf4bWOMxnvayuqR2qxfmk1lNHYsBa+UXw+6ECmIsD5/1VuIDPc/inaykS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZTw4bSGf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZTw4bSGf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B51A2C4CECD;
	Tue, 12 Nov 2024 10:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407035;
	bh=YJ+m3AmdL9Y20fx2OBv/DiR22IicJla0MtsyBkKWQ8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZTw4bSGfHmPa4iu1BDtKXgg6KQmo9LDIBDwTcqBCDMC2QX5kN4pYP/J9sJEIA8ZBO
	 s7J//06kGhqjq6gmj6sQ8kIKJWYoJAIu4kQHNsokY/rTUfSuB4yp+BF2rvyOyUzpqk
	 /BrB9W+WkhiTc0DG/O0y2GINBZpzSD2/xagURb3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caesar Wang <wxt@rock-chips.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 09/76] ARM: dts: rockchip: Fix the spi controller on rk3036
Date: Tue, 12 Nov 2024 11:20:34 +0100
Message-ID: <20241112101840.137737663@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
References: <20241112101839.777512218@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e0d4c71f109a7..d7a86f21cf23f 100644
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



