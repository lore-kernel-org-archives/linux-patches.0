Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF60187848;
	Fri, 15 Nov 2024 06:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653754; cv=none; b=GEYKOK1LU3Em3RfS21Ia4fHb3mLfQAJZhLOtUAtNhD6kSNQKTDpcE0gT3Ck27c2n5mIAFUf5fHTEtj3MX8MjGQMeDbXh/kFmY4vodZO1IjhKichnFXrSTluwCXujTsJduzKwHY61ACU8J4Q8kFg0YnHsP1w7dbhCK3tT3vxqMVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653754; c=relaxed/simple;
	bh=eO3f5tEJPmtCSE4+gQ69C7geisHxuNp9JPRTriOwznU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XEBIfLtmtdiv4W81AQIxlPFqT+GemmJG67hgvhwlEOtdBM7wdrufjiO/ETzkPmpDbO80WLAJexrVYU6qpFZJ0C+4arIb7Zqp9AEGKXu/8zepTua5HnvE2s1B28hFkbAyCYsMTWvnSf6pKN845U6blGU/ZzTVl67Qj1LUl4MN5bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xVEroK66; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xVEroK66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C78C4CED2;
	Fri, 15 Nov 2024 06:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653754;
	bh=eO3f5tEJPmtCSE4+gQ69C7geisHxuNp9JPRTriOwznU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xVEroK66THhu+5OQrRhn3Ter5KFGKh4XtC7wPW+34aqvuRmJdr9kNTXBC1O8QOWM2
	 xHul5YEoQnOJJbVxgHePNy4vUzShUzC0Ww86AhFoT6Qoju1so1/3bgQ0UAmdwqa2gN
	 qGyxFJry+WsOvO0o7q90S5PiGRcRxZcT1ZVnefGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andy.yan@rock-chips.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 05/82] arm64: dts: rockchip: Fix LED triggers on rk3308-roc-cc
Date: Fri, 15 Nov 2024 07:37:42 +0100
Message-ID: <20241115063725.759907443@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 213c0759c4b85..bf09b2818e20d 100644
--- a/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts
@@ -30,14 +30,14 @@
 
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



