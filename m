Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4441E22DAAF;
	Tue, 12 Nov 2024 10:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407948; cv=none; b=Lu4zZffdMqEIQih/DP4HfcorDi5MsEDMT78Fm+ckRkrz91EvHV2M313hwkIwBQljxkjjDcLeLMSx94NRHE7bEK7VhiwbF0VtilxI6XwURzc2N4UTrPrRBw0ov+Brt0F2hDxIHcvxPETgXIODvoFtvT8bDSFfwLxhc0+ZJK8UE6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407948; c=relaxed/simple;
	bh=QoNHfViCWBDsWnhGxsAjCKcG9zNS9cjDkLy0fjR7LRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G81ZegyyI8cEvALA2wswg4dAQ9u9fUGAbR1xfBjaCEfpL9sijPRvumsGMlxNca9QXV/tylfFQf4pwXAQWWITp50b+lnI4KmXKqxyY52FO5kOW3XSpg8VNRokiYy10bMhSK8j/LJrkMO50Vxugw1x06Nxj2naunwHC/WBhuuiD5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nLitHbzD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nLitHbzD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF29FC4CECD;
	Tue, 12 Nov 2024 10:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407948;
	bh=QoNHfViCWBDsWnhGxsAjCKcG9zNS9cjDkLy0fjR7LRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nLitHbzDYiMeTUD9dj1wHmgUaoK3WEglVJ1u3aka2nPRZf47BYOUPKwKqrsgvefmt
	 F06UKQc7ZEN/FabDf6qDFDVJuP40eyfz8fHs2o85zFU0RexjvfvYxmdpijjDVx3Z+M
	 A9Fx6knqbcS2VAlk7AiTcYH8q41d/rfuMNvVzq3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Yan <andyshrk@163.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 013/184] arm64: dts: rockchip: Fix bluetooth properties on rk3566 box demo
Date: Tue, 12 Nov 2024 11:19:31 +0100
Message-ID: <20241112101901.380558252@linuxfoundation.org>
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



