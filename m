Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524183FC5B7;
	Wed, 20 May 2026 18:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300705; cv=none; b=fVRnkbJ+lPTCxLgasbw0NDG+nP7E8rnBDEdXZsTmX9XfwAFsO4iw8BlAakCaaC5wUJ6ImWJfEXrSnwG43W6FQ+ptUKyBtMGl/hpxIy0H6IgF7iL+IMm4pbGVPwR/4bNEKQEU4aovTJFyaigHNjIJ36MYrS9GS7nycEBCLJXte+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300705; c=relaxed/simple;
	bh=EGr9+hB6rccyoXakziAxh3e8fP/cr/bPz12rLjPRXdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NN3x25+Xv0EKVJ/2yoNfGfR4XwddDg8A/DbXmJvtS5sOgwdOrdgRtV6OIro582EbTLnau8U2Y+x/TiFS8Po40MFCHOXMa17nQFu6bYIWd/mNbfld1eKu+zx4FDpJoVVWH1bdRT6AuQtwSa6tM4yyNOK23TsQDWEYzRSkW+e4odE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b9K8cPC1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b9K8cPC1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4DD1F000E9;
	Wed, 20 May 2026 18:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300704;
	bh=/E17RD3rIyyOSNupYCBODg6EEaPlQIRE34JZJUR0bbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b9K8cPC1Yjz+WP7L89jdA+3vUUnWMhaWPOykpH2SbIAlLOq3FzUjMNtjK1rdphgx1
	 N9m+QYYRlmIaMV+GvhDYmWhqOtcezz5hBVJBoB6HkU4GtD0kKLvn76qH9tl13bEsSd
	 JVc48kwYNJk+HOD6jE0WzyZXIuMXnixuI+Dc+ZDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Wang <wangming5719@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 276/666] arm64: dts: rockchip: Fix Bluetooth stability on LCKFB TaiShan Pi
Date: Wed, 20 May 2026 18:18:07 +0200
Message-ID: <20260520162117.195670819@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7cd91f8000cb0..419225a4806c1 100644
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



