Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A1E216DE2;
	Tue, 12 Nov 2024 10:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408006; cv=none; b=cr3/NWKHdMoWsyJ5Eam/TqwiKiSTTA0qwqa0VvOgBSHLwMt92dgeFLczt028BNhtlPJXFde0dltVcNGRiABEOjyM9e0ORX0BnSO4rggIzL2pZyOI8F3iw1uIDJN9309b2oxv8BCc2m1ONJ2XaH4WtZhLqR82svc4K73RV4vIlhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408006; c=relaxed/simple;
	bh=sgrJaZeZmuTMA/sGjBaFA74FGMGVEm5OcblGyxDKdbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C6HUBbn7XaDWf4Ojywkg8jIb4uzEtiSyeosA1KbC5SnhbrkeEcKIb197uDBcihN85iAqklCsHOJYQwA7MaYYs+M+mkNm7Z6lOjROFKyYEuu2K3X+YAsYkCj7b3+P5z6UGUtPLCW60McJVhg33b8WWYwwfjB7Xkp4yPe8KBE3yjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1cb2VeBz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1cb2VeBz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC05C4CECD;
	Tue, 12 Nov 2024 10:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408005;
	bh=sgrJaZeZmuTMA/sGjBaFA74FGMGVEm5OcblGyxDKdbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1cb2VeBz0Ug8JSytvbEaWvOnShLLMrhtEqmwB91D4QMQU0+GdE7Rfw/vtKZfg5MaM
	 u3nBfr7RWFCzkJBYvbWMFs7nEKc3Rfd+ZM8NVDwvQZQGk+QWOm7gCaEf8RPIIzD+yV
	 MqDjIjspKX1PUqHekYBQiyZ6lE6HZRkMWooaHUs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diederik de Haas <didi.debian@cknow.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 008/184] arm64: dts: rockchip: Remove hdmis 2nd interrupt on rk3328
Date: Tue, 12 Nov 2024 11:19:26 +0100
Message-ID: <20241112101901.191788496@linuxfoundation.org>
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

From: Diederik de Haas <didi.debian@cknow.org>

[ Upstream commit de50a7e3681771c6b990238af82bf1dea9b11b21 ]

The "synopsys,dw-hdmi.yaml" binding specifies that the interrupts
property of the hdmi node has 'maxItems: 1', so the hdmi node in
rk3328.dtsi having 2 is incorrect.

Paragraph 1.3 ("System Interrupt connection") of the RK3328 TRM v1.1
page 16 and 17 define the following hdmi related interrupts:
-  67 hdmi_intr
- 103 hdmi_intr_wakeup

The difference of 32 is due to a different base used in the TRM.

The RK3399 (which uses the same binding) has '23: hdmi_irq' and
'24: hdmi_wakeup_irq' according to its TRM (page 19).
The RK3568 (also same binding) has '76: hdmi_wakeup' and '77: hdmi'
according to page 17 of its TRM.
In both cases the non-wakeup IRQ was used, so use that too for rk3328.

Helped-by: Heiko Stuebner <heiko@sntech.de>
Fixes: 725e351c265a ("arm64: dts: rockchip: add rk3328 display nodes")
Signed-off-by: Diederik de Haas <didi.debian@cknow.org>
Link: https://lore.kernel.org/r/20241008113344.23957-3-didi.debian@cknow.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3328.dtsi | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328.dtsi b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
index b01efd6d042c8..a60259ae8a532 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -754,8 +754,7 @@
 		compatible = "rockchip,rk3328-dw-hdmi";
 		reg = <0x0 0xff3c0000 0x0 0x20000>;
 		reg-io-width = <4>;
-		interrupts = <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 71 IRQ_TYPE_LEVEL_HIGH>;
+		interrupts = <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&cru PCLK_HDMI>,
 			 <&cru SCLK_HDMI_SFC>,
 			 <&cru SCLK_RTC32K>;
-- 
2.43.0



