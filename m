Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9EBC36405A;
	Wed, 20 May 2026 17:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298374; cv=none; b=kESAeSeeit0xlMa2IdMbni3AOoi6mIfUXYqDz8u5eNVdMyOPU/HLbLdJtihyyklAES0vbcpikSvQjdx0+xm+vcGwGmKDE0BOIe+OV+Fvg4LOZfRbyJJEuda59y0T1Sb8ASPx5XvjfXmdxqfcNNs/Mur7V+zoQ3UwO9sllsJv5Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298374; c=relaxed/simple;
	bh=veewOMVk1K0n7KMssSdmWpF2O2nxfcpZjqtPdtfLdkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VfP7GyQr232rrDICPVUh0CstT4XK6TVkooGXdam7uCmCbSw+yF+sRhNxzO7ksRGF3+ouqGt+5a/KxfdWrlXuKCiZo4VOSBakuxFZIUwf65mGx8j0JVwl5HCbPelLfG4TTW0NWMD+xmmJxFz1JO6wKrE9spK2tVws20RBqb4h6ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mXxXMd9D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mXxXMd9D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5DB1F000E9;
	Wed, 20 May 2026 17:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298373;
	bh=VZEXUFePQ7f2HqhY5k8eErpED6jGW5miCa6e63z9yp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mXxXMd9D2njpVNOMNGl79zOWldzgEQVuQvAUUOTwCSBv9LiyXWF0keqBZiiFdAi1S
	 W830sN2OpypqcJQMC0WPXK9P3amf7wvCVr8SFdzwdXKie+mbDLbYFlnzdkNtV/EH8E
	 WXIPGrt2JoNQUvmvBdNKW1HhDwrhEgK0vOVKKrFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Wang <wangming5719@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 385/957] arm64: dts: rockchip: Fix Bluetooth stability on LCKFB TaiShan Pi
Date: Wed, 20 May 2026 18:14:28 +0200
Message-ID: <20260520162142.877628311@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Wang <wangming5719@gmail.com>

[ Upstream commit 861a9593e10bb6ab2a492b315c8a2a3aad70ac00 ]

The AP6212 WiFi/BT module on the LCKFB TaiShan Pi (RK3566) is prone to
communication timeouts and reset failures (error -110) when operating at
3 Mbps.

This patch stabilizes the Bluetooth interface by:
1. Updating the compatible string to 'brcm,bcm43430a1-bt' to better reflect
   the actual chip revision used in the AP6212 module.
2. Lowering the maximum UART baud rate from 3,000,000 to 1,500,000 bps.
   Tests show that 1.5 Mbps is the reliable upper limit for this board's
   UART configuration, eliminating the initialization timeouts.

Fixes: 251e5ade9ba4 ("arm64: dts: rockchip: add dts for LCKFB Taishan Pi RK3566")
Signed-off-by: Ming Wang <wangming5719@gmail.com>
Link: https://patch.msgid.link/20260206090453.1041919-1-wming126@126.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-lckfb-tspi.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-lckfb-tspi.dts b/arch/arm64/boot/dts/rockchip/rk3566-lckfb-tspi.dts
index ed65d31204446..18a560a6e2a4a 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-lckfb-tspi.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3566-lckfb-tspi.dts
@@ -635,10 +635,10 @@ &uart1 {
 	status = "okay";
 
 	bluetooth: bluetooth {
-		compatible = "brcm,bcm43438-bt";
+		compatible = "brcm,bcm43430a1-bt";
 		clocks = <&rk809 1>;
 		clock-names = "lpo";
-		max-speed = <3000000>;
+		max-speed = <1500000>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&bt_host_wake_l &bt_wake_l &bt_enable_h>;
 		shutdown-gpios = <&gpio2 RK_PB7 GPIO_ACTIVE_HIGH>;
-- 
2.53.0



