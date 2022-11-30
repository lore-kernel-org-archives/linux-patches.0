Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9217279C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:45:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B5BC433C1;
	Wed, 30 Nov 2022 18:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833911;
	bh=VX/wCa5lt4Ui8k1NWL6rhaJxgEWFk//eJG1DQuTOU0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=059uI4Plni1J87hZPF7JlxDTkCvoh3ekBSYqkdUuRQxCKHCOpi6YsQYoq7aMMVWbo
	 FSiyKgLwXnB+sFNXyHvmIlKvJ6KFp9NBCiZ/5XoHIzDTWuVzaVeiG3m8TtxHcvPSWE
	 mlm/tu7wyNQ2HXhjlHjeOQcdnOiosaq/XxXeHa9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wens@csie.org>,
	Peter Geis <pgwipeout@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 060/289] arm64: dts: rockchip: Fix Pine64 Quartz4-B PMIC interrupt
Date: Wed, 30 Nov 2022 19:20:45 +0100
Message-Id: <20221130180545.491302635@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit 562105c1b072411c71ac2202410d83ee79297624 ]

Ths PMIC's interrupt line is tied to GPIO0_A3. This is described
correctly for the pinmux setting, but incorrectly for the interrupt.

Correct the interrupt setting so that interrupts from the PMIC get
delivered.

Fixes: dcc8c66bef79 ("arm64: dts: rockchip: add Pine64 Quartz64-B device tree")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Reviewed-by: Peter Geis <pgwipeout@gmail.com>
Link: https://lore.kernel.org/r/20221106161513.4140-1-wens@kernel.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-quartz64-b.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-quartz64-b.dts b/arch/arm64/boot/dts/rockchip/rk3566-quartz64-b.dts
index 528bb4e8ac77..a2d0524e0ec9 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-quartz64-b.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3566-quartz64-b.dts
@@ -176,7 +176,7 @@ rk809: pmic@20 {
 		compatible = "rockchip,rk809";
 		reg = <0x20>;
 		interrupt-parent = <&gpio0>;
-		interrupts = <RK_PA7 IRQ_TYPE_LEVEL_LOW>;
+		interrupts = <RK_PA3 IRQ_TYPE_LEVEL_LOW>;
 		clock-output-names = "rk808-clkout1", "rk808-clkout2";
 
 		pinctrl-names = "default";
-- 
2.35.1



