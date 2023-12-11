Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20EE65101A;
	Mon, 11 Dec 2023 18:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FYY9ptVt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E34FC433C7;
	Mon, 11 Dec 2023 18:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319378;
	bh=GKaZxoSZW/MPBPaXpzOLVVMeqaQLtZKx4REJBvbRtzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FYY9ptVt+qMH6bBjGyYc44coOEP49/BhrbVi7l0aS8vMgbwoBjYjwlu5BOz2n7Zdy
	 7Oz13f8mrlDgQPcOOcQnWCprIQOfpqBN3fRUyla9hRcWoNKGgUu0dJx4GM9yPp2L/8
	 HmizysCF5ZBSX7whTbq5Th03u37xdlJdbebovaKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 083/244] arm64: dts: rockchip: Expand reg size of vdec node for RK3328
Date: Mon, 11 Dec 2023 19:19:36 +0100
Message-ID: <20231211182049.499891625@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit 0b6240d697a96eaa45a2a5503a274ebb4f162fa3 ]

Expand the reg size for the vdec node to include cache/performance
registers the rkvdec driver writes to.

Fixes: 17408c9b119d ("arm64: dts: rockchip: Add vdec support for RK3328")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Link: https://lore.kernel.org/r/20231105233630.3927502-9-jonas@kwiboo.se
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3328.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328.dtsi b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
index e729e7a22b23a..cc8209795c3e5 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -668,7 +668,7 @@
 
 	vdec: video-codec@ff360000 {
 		compatible = "rockchip,rk3328-vdec", "rockchip,rk3399-vdec";
-		reg = <0x0 0xff360000 0x0 0x400>;
+		reg = <0x0 0xff360000 0x0 0x480>;
 		interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&cru ACLK_RKVDEC>, <&cru HCLK_RKVDEC>,
 			 <&cru SCLK_VDEC_CABAC>, <&cru SCLK_VDEC_CORE>;
-- 
2.42.0



