Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F062141CD;
	Tue, 12 Nov 2024 10:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407230; cv=none; b=tMPNaZiscBK6fLtPNRibO4T2j5tRoApbritka4q379YaEVlbMQwnQWXovocfNSRpC/ifkq6HU4pB6yLPbeX0wYDHeWNl42FsclQtW6GNrarplJ0nPZ5qLxQ7/wLs+b7OeQbQEejaIBwLse6VHscR5kc3/6CGY4FiNZRbmwczLVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407230; c=relaxed/simple;
	bh=VYKPrA9t+P3dSgMSfdwRECChspPfkhRub870njgoV80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jj9uRnJN9tPryDwCVv8OiR1nYxh/8NWGH7I05nLEytA+/tFzPEFe/2zCALn+Qb1P43FdxkqdvOWZNbujLjkw6nMpo9qaI3K9yPhbdgxAfMw6aeoTWEpo9yCBAoZLdl2rvIVmJKmyoVRifKepM2+jQNzau3lpZB9M74JflrxmizQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F1b7Ckf9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F1b7Ckf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB7FC4CECD;
	Tue, 12 Nov 2024 10:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407230;
	bh=VYKPrA9t+P3dSgMSfdwRECChspPfkhRub870njgoV80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F1b7Ckf958Mh+yPSnZUpNy2N850fXtlDM2YeTSROwWxHVkQDeP8k4TpUO7Em2Zt2i
	 AaizhUU4cQdqQej3yxkzx+Tj3/LkLU/t3b7C0sRlfVD/MDpLomeir8PrLwZRAhpZN5
	 Qf3A+3b/NX0t/qbE7vxg33Pcu0HZLT4gWC9M53WI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 05/98] arm64: dts: rockchip: Fix bluetooth properties on Rock960 boards
Date: Tue, 12 Nov 2024 11:20:20 +0100
Message-ID: <20241112101844.474396728@linuxfoundation.org>
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

[ Upstream commit ea74528aaea5a1dfc8e3de09ef2af37530eca526 ]

The expected clock-name is different, and extclk also is deprecated
in favor of txco for clocks that are not crystals.

So fix it to match the binding.

Fixes: c72235c288c8 ("arm64: dts: rockchip: Add on-board WiFi/BT support for Rock960 boards")
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20241008203940.2573684-5-heiko@sntech.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-rock960.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rock960.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-rock960.dtsi
index 94e39ed633971..d38b25a0c77f4 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-rock960.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-rock960.dtsi
@@ -575,7 +575,7 @@
 	bluetooth {
 		compatible = "brcm,bcm43438-bt";
 		clocks = <&rk808 1>;
-		clock-names = "ext_clock";
+		clock-names = "txco";
 		device-wakeup-gpios = <&gpio2 RK_PD3 GPIO_ACTIVE_HIGH>;
 		host-wakeup-gpios = <&gpio0 RK_PA4 GPIO_ACTIVE_HIGH>;
 		shutdown-gpios = <&gpio0 RK_PB1 GPIO_ACTIVE_HIGH>;
-- 
2.43.0



