Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2974208C7
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gAN1nkzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0E6C433C8;
	Tue, 31 Oct 2023 17:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774403;
	bh=l8eO61Ee505lzw2r1MH9RZMGS+va+ti0IGxBH5B+gxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gAN1nkzXOqTeCOWl9gKa/ihOZDftr9LobaOmC//RlAYtju9fOOYGLesRzWnM/bG7i
	 GzUMDZnPOqrVTz/JFKi5mQD3dajDh6tUKaSrFKAL2cQb6HkK2SYNJITOtwOfb9awUE
	 LH0nxEpoIlmAvgDnPW1M7mnYLLkZSXI05m6+2REA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Bee <knaerzche@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.5 035/112] ARM: dts: rockchip: Fix i2c0 register address for RK3128
Date: Tue, 31 Oct 2023 18:00:36 +0100
Message-ID: <20231031165902.424955566@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Bee <knaerzche@gmail.com>

commit 2e9cbc4167da3134412ce47e4cdadbfdea30bbff upstream.

The register address for i2c0 is missing a 0x to mark it as hex.

Fixes: a0201bff6259 ("ARM: dts: rockchip: add rk3128 soc dtsi")
Signed-off-by: Alex Bee <knaerzche@gmail.com>
Link: https://lore.kernel.org/r/20230829203721.281455-6-knaerzche@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/rockchip/rk3128.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/rockchip/rk3128.dtsi b/arch/arm/boot/dts/rockchip/rk3128.dtsi
index b63bd4ad3143..2e345097b9bd 100644
--- a/arch/arm/boot/dts/rockchip/rk3128.dtsi
+++ b/arch/arm/boot/dts/rockchip/rk3128.dtsi
@@ -426,7 +426,7 @@ saradc: saradc@2006c000 {
 
 	i2c0: i2c@20072000 {
 		compatible = "rockchip,rk3128-i2c", "rockchip,rk3288-i2c";
-		reg = <20072000 0x1000>;
+		reg = <0x20072000 0x1000>;
 		interrupts = <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>;
 		clock-names = "i2c";
 		clocks = <&cru PCLK_I2C0>;
-- 
2.42.0



