Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB9B22EE69;
	Tue, 12 Nov 2024 10:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407958; cv=none; b=CRSVUVJ+zO/dyL0wZNJsQl2xlioD+nlX0HwJYWekcmDrXb8ziNdICUT9vsGmxntX2ICKGB9OGTNk2EPz3EyHI7j8rivuZNq+gmBuCAeO5haMwFtpvALo0svl/J1EdZyVzBl+yl3ysyX1SEKUovQf14zlPYRF9lAIJM97kNGoOc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407958; c=relaxed/simple;
	bh=u5L+Xyqct6Iyd7Z3N506MtCx+7L56YWOWEkV4tj7GB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h7KQpPCOCe89zOuSmnxG8klULcwZlbcqNErlEpEeuIQolIia6u95NVZxN8kAA5uyHSMzpoWnsVTiXDaBaUkkDruk/+SDVlvSl2ptXTBL5oxKs7pXeoY62UBIv6ySVMnsrbF/UElPwMlYL5CbTbtY466kc+/ae3H4EE/z9KkQoGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hbhwlH1w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hbhwlH1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3218DC4CECD;
	Tue, 12 Nov 2024 10:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407957;
	bh=u5L+Xyqct6Iyd7Z3N506MtCx+7L56YWOWEkV4tj7GB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hbhwlH1w1x9zr3CFNotLCQOvqNNwHiFfbOaiozFxrYSs7QR1gOAqflz1BI4MCN89w
	 NE3pfZCMVXaAq2Q+WzPiVlIir1ASYmO1a2kdGXW6Us4qDp0HSRsNnIBJfpsukGdmAN
	 kgWs1xaQncY6TCO3Xxsa0+HnrXkHfHfzHU7O4CSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@theobroma-systems.com>,
	Sergey Bostandzhyan <jin@mediatomb.cc>,
	Wenhao Cui <lasstp5011@gmail.com>,
	Andy Yan <andyshrk@163.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 016/184] arm64: dts: rockchip: Remove undocumented supports-emmc property
Date: Tue, 12 Nov 2024 11:19:34 +0100
Message-ID: <20241112101901.494016755@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit 1b670212ee3dd9d14c6d39a042dfe4ae79b49b4e ]

supports-emmc is an undocumented property that slipped into the mainline
kernel devicetree for some boards. Drop it.

Fixes: c484cf93f61b ("arm64: dts: rockchip: add PX30-µQ7 (Ringneck) SoM with Haikou baseboard")
Cc: Quentin Schulz <quentin.schulz@theobroma-systems.com>
Fixes: b8c028782922 ("arm64: dts: rockchip: Add DTS for FriendlyARM NanoPi R2S Plus")
Cc: Sergey Bostandzhyan <jin@mediatomb.cc>
Fixes: 8d94da58de53 ("arm64: dts: rockchip: Add EmbedFire LubanCat 1")
Cc: Wenhao Cui <lasstp5011@gmail.com>
Fixes: cdf46cdbabfc ("arm64: dts: rockchip: Add dts for EmbedFire rk3568 LubanCat 2")
Cc: Andy Yan <andyshrk@163.com>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20241008203940.2573684-6-heiko@sntech.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi         | 1 -
 arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s-plus.dts | 1 -
 arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dts      | 1 -
 arch/arm64/boot/dts/rockchip/rk3568-lubancat-2.dts      | 1 -
 4 files changed, 4 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi b/arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi
index bb1aea82e666e..b7163ed74232d 100644
--- a/arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi
+++ b/arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi
@@ -66,7 +66,6 @@
 	bus-width = <8>;
 	cap-mmc-highspeed;
 	mmc-hs200-1_8v;
-	supports-emmc;
 	mmc-pwrseq = <&emmc_pwrseq>;
 	non-removable;
 	vmmc-supply = <&vcc_3v3>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s-plus.dts b/arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s-plus.dts
index cb81ba3f23ffd..3093f607f282e 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s-plus.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3328-nanopi-r2s-plus.dts
@@ -27,6 +27,5 @@
 	num-slots = <1>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&emmc_clk &emmc_cmd &emmc_bus8>;
-	supports-emmc;
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dts b/arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dts
index c1194d1e438d0..9a2f59a351dee 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dts
@@ -507,7 +507,6 @@
 	non-removable;
 	pinctrl-names = "default";
 	pinctrl-0 = <&emmc_bus8 &emmc_clk &emmc_cmd>;
-	supports-emmc;
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/rockchip/rk3568-lubancat-2.dts b/arch/arm64/boot/dts/rockchip/rk3568-lubancat-2.dts
index a3112d5df2008..b505a4537ee8c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-lubancat-2.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-lubancat-2.dts
@@ -589,7 +589,6 @@
 	non-removable;
 	pinctrl-names = "default";
 	pinctrl-0 = <&emmc_bus8 &emmc_clk &emmc_cmd>;
-	supports-emmc;
 	status = "okay";
 };
 
-- 
2.43.0



