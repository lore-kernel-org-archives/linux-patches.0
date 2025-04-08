Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9974A21ADAE;
	Tue,  8 Apr 2025 11:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110772; cv=none; b=Oh0QRgSKDuPN8OZWQNCCPhxKVIl/u8moAu1c71EyZtKTJ7VnfIvusnaT09/DGQ0PpT78Oix6UjrBQJxXp32+Y0DebAjOXoq7Nb1Pf+J8UEbYnLnOgu2j+1AmODJMp5Ksces0WYibjfL4gFOY8vrQChPnv7fAA9VogAJ/t7YbkTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110772; c=relaxed/simple;
	bh=cFJ5pYutueVPPSJI4uWTOyCNnlddRF72cXD97ChPaz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZ1xf9XqKb7b2MBa0XKiB5wEIInHNu1qHG3JTbCQdOtiAeeLYLYhFMNAKhzWUcZnaXCWCAHxpPtu6a2lT2HWdJD3mPXZ1YO3XCHADSW6NREo1pc7O3txJLbLaXwAuuk4LOM2dFzsE9I2XirjMBuJm/ol9gikX+b7dgP/C7NfmAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DuJJ+KFw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DuJJ+KFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F93C4CEE5;
	Tue,  8 Apr 2025 11:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110772;
	bh=cFJ5pYutueVPPSJI4uWTOyCNnlddRF72cXD97ChPaz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DuJJ+KFwX4KsnQGfcuQ6emVJ3MC9e8a/Q8bjq5V1Y5Zg5vgZ0BLhneJJwslaArBGi
	 Glh7sBX4JU/nO05M3avQbVwAZzlMltOOAIKvnasxfbYwe4KyctYrDHEhmVs7+OKzan
	 a1T2E6Z38GdOHb6TRRdDOPmJI2FfnDrjoZ4o6ifE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <ziyao@disroot.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 188/731] arm64: dts: rockchip: Fix PWM pinctrl names
Date: Tue,  8 Apr 2025 12:41:25 +0200
Message-ID: <20250408104918.650186863@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yao Zi <ziyao@disroot.org>

[ Upstream commit 09b0a7b63a6cda138e2e47c6acb2aee80338624c ]

These Rockchip boards assign "active" as the pinctrl name for PWM
controllers, which has never been supported in mainline Rockchip PWM
driver. It seems the name used by downstream kernel is accidentally
brought into maineline. Let's fix them.

Fixes: 4403e1237be3 ("arm64: dts: rockchip: Add devicetree for board roc-rk3308-cc")
Fixes: 964ed0807b5f ("arm64: dts: rockchip: add rk3318 A95X Z2 board")
Fixes: e7a095908227 ("arm64: dts: rockchip: Add devicetree for NanoPC-T4")
Fixes: 3f5d336d64d6 ("arm64: dts: rockchip: Add support for rk3588s based board Cool Pi 4B")
Signed-off-by: Yao Zi <ziyao@disroot.org>
Link: https://lore.kernel.org/r/20250310140916.14384-2-ziyao@disroot.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts     | 2 +-
 arch/arm64/boot/dts/rockchip/rk3318-a95x-z2.dts    | 4 ++--
 arch/arm64/boot/dts/rockchip/rk3399-nanopi4.dtsi   | 2 +-
 arch/arm64/boot/dts/rockchip/rk3588s-coolpi-4b.dts | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts b/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts
index 629121de5a13d..5e71819489920 100644
--- a/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3308-roc-cc.dts
@@ -147,7 +147,7 @@
 
 &pwm5 {
 	status = "okay";
-	pinctrl-names = "active";
+	pinctrl-names = "default";
 	pinctrl-0 = <&pwm5_pin_pull_down>;
 };
 
diff --git a/arch/arm64/boot/dts/rockchip/rk3318-a95x-z2.dts b/arch/arm64/boot/dts/rockchip/rk3318-a95x-z2.dts
index a94114fb7cc1d..96c27fc5005d1 100644
--- a/arch/arm64/boot/dts/rockchip/rk3318-a95x-z2.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3318-a95x-z2.dts
@@ -274,13 +274,13 @@
 
 &pwm0 {
 	pinctrl-0 = <&pwm0_pin_pull_up>;
-	pinctrl-names = "active";
+	pinctrl-names = "default";
 	status = "okay";
 };
 
 &pwm1 {
 	pinctrl-0 = <&pwm1_pin_pull_up>;
-	pinctrl-names = "active";
+	pinctrl-names = "default";
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-nanopi4.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-nanopi4.dtsi
index b169be06d4d1f..c8eb5481f43d0 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-nanopi4.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-nanopi4.dtsi
@@ -603,7 +603,7 @@
 };
 
 &pwm2 {
-	pinctrl-names = "active";
+	pinctrl-names = "default";
 	pinctrl-0 = <&pwm2_pin_pull_down>;
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/rockchip/rk3588s-coolpi-4b.dts b/arch/arm64/boot/dts/rockchip/rk3588s-coolpi-4b.dts
index 9c394f733bbfb..b2c30122aacc5 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-coolpi-4b.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-coolpi-4b.dts
@@ -429,7 +429,7 @@
 };
 
 &pwm13 {
-	pinctrl-names = "active";
+	pinctrl-names = "default";
 	pinctrl-0 = <&pwm13m2_pins>;
 	status = "okay";
 };
-- 
2.39.5



