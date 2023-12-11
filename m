Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0D4321B8;
	Mon, 11 Dec 2023 18:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NKSoOArW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5775C433C7;
	Mon, 11 Dec 2023 18:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320940;
	bh=u35j2L0ePWubg8mqnc8WP0Q9I1Vl0uJdY3mxqaC2RYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NKSoOArWmNlbgb1QF7Yv1Cq3EGS0NdbK6RiWJ1iYUdrXbUu7VYcQxt3brwFfjGwec
	 20KlT6GBrdphqcZ7KuDhtH0+2d8SlHuyar1Wih3+prfStgP5YF7XXWTX9guZz7n7UV
	 LquQm3ta+5WJWnPfHPiw7DJqFslbRneQSRlm8IqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Bee <knaerzche@gmail.com>,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 051/141] arm64: dts: rockchip: Expand reg size of vdec node for RK3399
Date: Mon, 11 Dec 2023 19:21:50 +0100
Message-ID: <20231211182028.736277105@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182026.503492284@linuxfoundation.org>
References: <20231211182026.503492284@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Bee <knaerzche@gmail.com>

[ Upstream commit 35938c18291b5da7422b2fac6dac0af11aa8d0d7 ]

Expand the reg size for the vdec node to include cache/performance
registers the rkvdec driver writes to. Also add missing clocks to the
related power-domain.

Fixes: cbd7214402ec ("arm64: dts: rockchip: Define the rockchip Video Decoder node on rk3399")
Signed-off-by: Alex Bee <knaerzche@gmail.com>
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Link: https://lore.kernel.org/r/20231105233630.3927502-10-jonas@kwiboo.se
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399.dtsi | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
index 4255e2d7a72fc..9e33f0e6ed504 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -993,7 +993,9 @@
 			power-domain@RK3399_PD_VDU {
 				reg = <RK3399_PD_VDU>;
 				clocks = <&cru ACLK_VDU>,
-					 <&cru HCLK_VDU>;
+					 <&cru HCLK_VDU>,
+					 <&cru SCLK_VDU_CA>,
+					 <&cru SCLK_VDU_CORE>;
 				pm_qos = <&qos_video_m1_r>,
 					 <&qos_video_m1_w>;
 				#power-domain-cells = <0>;
@@ -1260,7 +1262,7 @@
 
 	vdec: video-codec@ff660000 {
 		compatible = "rockchip,rk3399-vdec";
-		reg = <0x0 0xff660000 0x0 0x400>;
+		reg = <0x0 0xff660000 0x0 0x480>;
 		interrupts = <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH 0>;
 		clocks = <&cru ACLK_VDU>, <&cru HCLK_VDU>,
 			 <&cru SCLK_VDU_CA>, <&cru SCLK_VDU_CORE>;
-- 
2.42.0



