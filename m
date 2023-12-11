Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53784437B;
	Mon, 11 Dec 2023 18:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2pAS79IZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54FAC433C8;
	Mon, 11 Dec 2023 18:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319418;
	bh=XOwVRShcc1uBUxh0Frbk7cogoSEZ7mgs4FkD7AaAZZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2pAS79IZegjJ2e1tDRNjWIITgoawlTZkukR8D4cRfLbSUeYMx/lnMroOgl4EkPCUU
	 WP1W3CpyNsblaLD9rJU8vVjkXHheh3A6V6C86TUG+ZE/O1zVk9WM+//R/62HMBUoQ+
	 u5UuzecHPdPwTR+daVQXXQ61eC/w5gf/ubOx0G7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Bee <knaerzche@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 097/244] ARM: dts: rockchip: Fix sdmmc_pwrens pinmux setting for RK3128
Date: Mon, 11 Dec 2023 19:19:50 +0100
Message-ID: <20231211182050.125094650@linuxfoundation.org>
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

From: Alex Bee <knaerzche@gmail.com>

[ Upstream commit 0c349b5001f8bdcead844484c15a0c4dfb341157 ]

RK3128's reference design uses sdmmc_pwren pincontrol as GPIO - see [0].

Let's change it in the SoC DT as well.

[0] https://github.com/rockchip-linux/kernel/commit/8c62deaf6025

Fixes: a0201bff6259 ("ARM: dts: rockchip: add rk3128 soc dtsi")
Signed-off-by: Alex Bee <knaerzche@gmail.com>
Link: https://lore.kernel.org/r/20231127184643.13314-2-knaerzche@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rockchip/rk3128.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/rockchip/rk3128.dtsi b/arch/arm/boot/dts/rockchip/rk3128.dtsi
index 88a4b0d6d928d..80d81af5fe0ef 100644
--- a/arch/arm/boot/dts/rockchip/rk3128.dtsi
+++ b/arch/arm/boot/dts/rockchip/rk3128.dtsi
@@ -795,7 +795,7 @@
 			};
 
 			sdmmc_pwren: sdmmc-pwren {
-				rockchip,pins = <1 RK_PB6 1 &pcfg_pull_default>;
+				rockchip,pins = <1 RK_PB6 RK_FUNC_GPIO &pcfg_pull_default>;
 			};
 
 			sdmmc_bus4: sdmmc-bus4 {
-- 
2.42.0



