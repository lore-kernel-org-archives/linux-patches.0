Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2811A76C7;
	Tue, 12 Nov 2024 10:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407609; cv=none; b=kdVm2fYJckiG0dfERa0fX/2PL/TI4rFoaD1IDAL1KM+mYN9WKCGDB3cKp3AMVyYAZIKBo3cnAFVr7GdtfkDUcRG/WlzlOGgDUNH5TgTFO73Sh8r37Y6/N5IgEUut8gGp1Uf6DhsOY7w7cshhctZmL5aWhZZrsijLTYXFQ7Dze/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407609; c=relaxed/simple;
	bh=k/tEiuPHV0h+Wdsei/jqlfBgbeh1c2v+OkxbDjS+l/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qwov/lfkeUlrCMsR6FmY1RB/cQoexJid6ISkg5nQzaFa+qZR6fqj7SMidjdCk2AzqG/R/IOkVsFxzRv5lVoMvawd1Cmu5u4efOmXUKb/PUtV7mdvm3eWgAQGnt8Ey5tKUGOJ0R0Yh2s0nYi/wIdLXmri5Yk/YczYRrO8DhoA8R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m7j/zA+l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m7j/zA+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A268C4CECD;
	Tue, 12 Nov 2024 10:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407609;
	bh=k/tEiuPHV0h+Wdsei/jqlfBgbeh1c2v+OkxbDjS+l/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m7j/zA+l8ABILQf83P+aNYV7B4eFS0anjCpoMm9y+d9QwgMuYIYxjW7GMbBpMy5wE
	 +seuu/TbEtB+Kz1RCONKF2Dfba73hsLssVmrCQnRRQYA9EJAQkZtF98sX9xypBY2nV
	 WapfGtafd5LkqdjV/UtAEfx4cQ4pQv4V8PMm41Ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andyshrk@163.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/119] arm64: dts: rockchip: Fix bluetooth properties on rk3566 box demo
Date: Tue, 12 Nov 2024 11:20:15 +0100
Message-ID: <20241112101848.995014582@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit 2fa98dcc8d3ea2ebbd9e6be778f8bb19231c28be ]

The expected clock-name is different, and extclk also is deprecated
in favor of txco for clocks that are not crystals.

The wakeup gpio properties are named differently too, when changing
from vendor-tree to mainline. So fix those to match the binding.

Fixes: 2e0537b16b25 ("arm64: dts: rockchip: Add dts for rockchip rk3566 box demo board")
Cc: Andy Yan <andyshrk@163.com>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20241008203940.2573684-4-heiko@sntech.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-box-demo.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-box-demo.dts b/arch/arm64/boot/dts/rockchip/rk3566-box-demo.dts
index 0c18406e4c597..7d46809338239 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-box-demo.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3566-box-demo.dts
@@ -449,9 +449,9 @@
 	bluetooth {
 		compatible = "brcm,bcm43438-bt";
 		clocks = <&pmucru CLK_RTC_32K>;
-		clock-names = "ext_clock";
-		device-wake-gpios = <&gpio2 RK_PC1 GPIO_ACTIVE_HIGH>;
-		host-wake-gpios = <&gpio2 RK_PC0 GPIO_ACTIVE_HIGH>;
+		clock-names = "txco";
+		device-wakeup-gpios = <&gpio2 RK_PC1 GPIO_ACTIVE_HIGH>;
+		host-wakeup-gpios = <&gpio2 RK_PC0 GPIO_ACTIVE_HIGH>;
 		shutdown-gpios = <&gpio2 RK_PB7 GPIO_ACTIVE_HIGH>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&bt_host_wake_l &bt_wake_l &bt_enable_h>;
-- 
2.43.0



