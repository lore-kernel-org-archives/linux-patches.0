Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604F720D4E3;
	Tue, 12 Nov 2024 10:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407556; cv=none; b=RiyZwRDw5lnSjIYRXhDpp96n5uN5zCZUQSLV6dynO8632eAc/jQUj03XqgkKF0fDzSqaYAAP8TO0bVIMs7Z+afphRg/nebgwNRmto+NfxDdmLoOUHGrVcuWWROXUoXCf4Ze2/WipPP3Od/7rO64PNrgJSxcFmqyubtmJ7sg2yks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407556; c=relaxed/simple;
	bh=3e1o+zOObL00bCfBhgBfkrLJ7W6TK+vXjvMqS0Yj+TY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hwlD0Gox3EXMM8DtS7PzuSbEnGc6XleVr6IidRxs1+OkbKFQpVAJmNj6O4iuUnRDXY1H/EqlaoWB3+vOes9mc0aMjJlCuPKDZTUaCO1q3SZgSgESIokBsxUpnBPIzeAGroxIl0s5c0egChleDznikmpL6/E3sD8Q7eUezSacLyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uW36hTqI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uW36hTqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD53C4CECD;
	Tue, 12 Nov 2024 10:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407556;
	bh=3e1o+zOObL00bCfBhgBfkrLJ7W6TK+vXjvMqS0Yj+TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uW36hTqIMHRSTH96qqmyaNUaXBCy/YIn2y65+71KcYsumNWrBDrgx+eETG2qEFgxg
	 +tGk5ZAtMf2rEDZlqh4LEkml+uZVvTZ6x/VsfSdqk1T1V1vpQwk5B79zWWvKX8shyt
	 t/phGstuJ+xOxC0k4nW8yHN126INd2tLQJG4XOLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/119] arm64: dts: rockchip: Fix LED triggers on rk3308-roc-cc
Date: Tue, 12 Nov 2024 11:20:20 +0100
Message-ID: <20241112101849.183792666@linuxfoundation.org>
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

[ Upstream commit 3a53a7187f41ec3db12cf4c2cb0db4ba87c2f3a1 ]

There are two LEDs on the board, power and user events.
Currently both are assigned undocumented IR(-remote)
triggers that are probably only part of the vendor-kernel.

To make dtbs check happier, assign the power-led to a generic
default-on trigger and the user led to the documented rc-feedback
trigger that should mostly match its current usage.

Fixes: 4403e1237be3 ("arm64: dts: rockchip: Add devicetree for board roc-rk3308-cc")
Cc: Andy Yan <andy.yan@rock-chips.com>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20241008203940.2573684-8-heiko@sntech.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts b/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts
index 9232357f4fec9..d9e191ad1d77e 100644
--- a/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts
@@ -36,14 +36,14 @@
 
 		power_led: led-0 {
 			label = "firefly:red:power";
-			linux,default-trigger = "ir-power-click";
+			linux,default-trigger = "default-on";
 			default-state = "on";
 			gpios = <&gpio0 RK_PA6 GPIO_ACTIVE_HIGH>;
 		};
 
 		user_led: led-1 {
 			label = "firefly:blue:user";
-			linux,default-trigger = "ir-user-click";
+			linux,default-trigger = "rc-feedback";
 			default-state = "off";
 			gpios = <&gpio0 RK_PB2 GPIO_ACTIVE_HIGH>;
 		};
-- 
2.43.0



