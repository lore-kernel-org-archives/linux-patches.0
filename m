Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B3F1F130E;
	Tue,  3 Dec 2024 15:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238232; cv=none; b=RQxYHcpuIferFZzlD9HQz9NVtSaZUSg7iR/CAdXjwfWh1cM0/IaCfAsRvepFMGqNewY5R2GluLDehwI0HVcmnQL1+o2JnDI+0/gihr34VMv2neSpe1DImL7jJavtWLgVsx/Fy2CHVQDUq0ayk4ZrwW9ScGzz6QMOLyG5Ea4sqKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238232; c=relaxed/simple;
	bh=9FVnb/clbbKNMn2OQu9XCwQ7u8z2aMm8bXpAWyneMNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOmp1gAgx+OmFM3BX+Rq8Q4OM6+yN446NmkGsSYD+T0Afi3488SEoTDUlMkY+RiD/8SGhpoCbltXHucI0Wo46J7BKypGVD54VLC6HBg9wy4St/WINQt37YMNhu2PiKC72+BKyKwxjEcFHnW5lqRHvIrfp4wwpFB1h7A7TZr24/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2HAp0F/Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2HAp0F/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4D2C4CED6;
	Tue,  3 Dec 2024 15:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238232;
	bh=9FVnb/clbbKNMn2OQu9XCwQ7u8z2aMm8bXpAWyneMNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2HAp0F/Qn8Wmpl/f849IGRDvWkUzp2lva3CRwVFbPkHgm+/csGR46PueMxhw5UD84
	 YlRwR1St4e3oMsrEWIQQ56t149bDMIFmxRROKFEUqOrVMZWR7Y5HgqGPG3KA8zaIbQ
	 RLYg0sYvpka8Q0HyIoWbn8cyV5vz+WUM6V3lcYDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Riesch <michael.riesch@wolfvision.net>,
	Muhammed Efe Cetin <efectn@6tel.net>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 176/817] arm64: dts: rockchip: Remove enable-active-low from two boards
Date: Tue,  3 Dec 2024 15:35:48 +0100
Message-ID: <20241203144002.601035159@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

[ Upstream commit 4a9d7e6596f90631f21bca9cb46c6de05d8e86d4 ]

The 'enable-active-low' property is not a valid, because it is the
default behaviour of the fixed regulator.

Only 'enable-active-high' is valid, and when this property is absent
the fixed regulator will act as active low by default.

Both the rk3588-orange-pi-5 and the Wolfvision pf5 io expander overlay
smuggled those enable-active-low properties in, so remove them to
make dtbscheck happier.

Fixes: 28799a7734a0 ("arm64: dts: rockchip: add wolfvision pf5 io expander board")
Cc: Michael Riesch <michael.riesch@wolfvision.net>
Fixes: b6bc755d806e ("arm64: dts: rockchip: Add Orange Pi 5")
Cc: Muhammed Efe Cetin <efectn@6tel.net>

Reviewed-by: Michael Riesch <michael.riesch@wolfvision.net>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20241008203940.2573684-10-heiko@sntech.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/rockchip/rk3568-wolfvision-pf5-io-expander.dtso     | 1 -
 arch/arm64/boot/dts/rockchip/rk3588s-orangepi-5.dts              | 1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-wolfvision-pf5-io-expander.dtso b/arch/arm64/boot/dts/rockchip/rk3568-wolfvision-pf5-io-expander.dtso
index ebcaeafc3800d..fa61633aea152 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-wolfvision-pf5-io-expander.dtso
+++ b/arch/arm64/boot/dts/rockchip/rk3568-wolfvision-pf5-io-expander.dtso
@@ -49,7 +49,6 @@ vcc1v8_eth: vcc1v8-eth-regulator {
 
 	vcc3v3_eth: vcc3v3-eth-regulator {
 		compatible = "regulator-fixed";
-		enable-active-low;
 		gpio = <&gpio0 RK_PC0 GPIO_ACTIVE_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&vcc3v3_eth_enn>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3588s-orangepi-5.dts b/arch/arm64/boot/dts/rockchip/rk3588s-orangepi-5.dts
index feea6b20a6bf5..6b77be6432495 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-orangepi-5.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-orangepi-5.dts
@@ -71,7 +71,6 @@ vcc5v0_sys: vcc5v0-sys-regulator {
 
 	vcc_3v3_sd_s0: vcc-3v3-sd-s0-regulator {
 		compatible = "regulator-fixed";
-		enable-active-low;
 		gpios = <&gpio4 RK_PB5 GPIO_ACTIVE_LOW>;
 		regulator-name = "vcc_3v3_sd_s0";
 		regulator-boot-on;
-- 
2.43.0



