Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDBC154C05;
	Tue, 23 Jan 2024 00:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969409; cv=none; b=S+YeJakbUiiPBw10nA1wxpm5CCi0zAKMSa0UmsYW611hzG2vkduMuCh9BezYFP/RtCW/aAHjc/tNX14O6ODQgNHssF2NdtfbTcBZP5M52iTHKxr1zzF29bUZ4Tm6DBKIYzM4m1mexeOyT0SAfTYD8UUiDxiaNFbBVmh/NJ2DENk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969409; c=relaxed/simple;
	bh=xXId+G/0Qmp5fIY4U1xAdUki4Z3RhXAsp4U+6WwNMQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E7P0AyOWUQloWuhGfKe5TvMz98KvPWMkgPHmbF551ap6tqv2K64vIiZBE6r6z9k53B5cD+nBk1qP1fst3ICpZ9ZPvtywZPplbKVclbUYegFIiZ4K6ZFs7yk5GUiOujsQsaMKl+bX/CorPkZ5/QWmAcW5OS+XbymT6MmF/yIK+VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q6EzpsIP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q6EzpsIP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE1BC433F1;
	Tue, 23 Jan 2024 00:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969408;
	bh=xXId+G/0Qmp5fIY4U1xAdUki4Z3RhXAsp4U+6WwNMQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q6EzpsIPv0ySuM9Bij+kCrOdhhIx5TkLj2Q5S6W4I1HspFGP2IhGyo9C1aQ/ADrTP
	 Gn4RUTGkw14mhj6o8COTf/ss+seOpZLaGlkZ7jyDUXLPYm7je4sOQO4soe3ppwsNje
	 OMgLTUvhn7JUdWTKKyAsmlGNpA4C0U3GUHCdOtHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Ning <zhangn1985@outlook.com>,
	Andy Yan <andyshrk@163.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 227/641] arm64: dts: rockchip: Fix led pinctrl of lubancat 1
Date: Mon, 22 Jan 2024 15:52:11 -0800
Message-ID: <20240122235825.039568027@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Yan <andyshrk@163.com>

[ Upstream commit 8586a5d217ef7bfeee24943c600a8a7890d6f477 ]

According to the schematics, the gpio control sys_led is GPIO0_C5.

Fixes: 8d94da58de53 ("arm64: dts: rockchip: Add EmbedFire LubanCat 1")
Reported-by: Zhang Ning <zhangn1985@outlook.com>
Closes: https://lore.kernel.org/linux-rockchip/OS0P286MB06412D049D8BF7B063D41350CD95A@OS0P286MB0641.JPNP286.PROD.OUTLOOK.COM/T/#u
Signed-off-by: Andy Yan <andyshrk@163.com>
Link: https://lore.kernel.org/r/20231225005055.3102743-1-andyshrk@163.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dts b/arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dts
index 1c6d83b47cd2..6ecdf5d28339 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dts
@@ -455,7 +455,7 @@ &pcie2x1 {
 &pinctrl {
 	leds {
 		sys_led_pin: sys-status-led-pin {
-			rockchip,pins = <0 RK_PC7 RK_FUNC_GPIO &pcfg_pull_none>;
+			rockchip,pins = <0 RK_PC5 RK_FUNC_GPIO &pcfg_pull_none>;
 		};
 	};
 
-- 
2.43.0



