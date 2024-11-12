Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0754220D4E3;
	Tue, 12 Nov 2024 10:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407550; cv=none; b=U+3GY2O1GrRqOl2WwIcNIwqL9ze+l1DZHoPJ70vC3kh/UdtqpailQ6j4OlVxlEwZUR8vxl2G/9Ir1EXZLsZxx9rJL+nG10A919KEgGfnyZPlDVkOUJn2W6Rx+NEE3Z//KrLFsuHu7Fl8wLyf0tsW6ssOGLM6iM31NBowmVkYKiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407550; c=relaxed/simple;
	bh=St6luTUqRiYreUqA8eq/DZLLP1BJCTzNXPkf8cKoiqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UjBioHRGE/wAYTFvCmo555LINXChiwFxofFk6TfsKVLqBuy+k78+pA+/+u1wDx0msYeMhZKWxwLAbzX/Ny79/Eg60hMK+VcHctO4NNTKzk7iW+gW5h8TaDrZZ0WvNyIaWAOxmuCuLGWJErgXm7DFCqfQiMXDRqBIxD5qRUZ2+W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JzoRGsj7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JzoRGsj7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84601C4CECD;
	Tue, 12 Nov 2024 10:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407549;
	bh=St6luTUqRiYreUqA8eq/DZLLP1BJCTzNXPkf8cKoiqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JzoRGsj7zJcYoQX3MOHqMzmnIZ8l5dWhmcIpwD1au8h8gqxtAlaZa/9SJinaJ6VV5
	 1HkZOHH660p441ac7yLMTA+42zvPs2rUt8VhaLHBkO3/F9+ymlNaDwXfzF5OARjSIQ
	 g2IhGGX7hG/wMlNCp4Yvyk/vsb5qVSlwC+IuozQA=
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
Subject: [PATCH 6.6 010/119] arm64: dts: rockchip: Remove undocumented supports-emmc property
Date: Tue, 12 Nov 2024 11:20:18 +0100
Message-ID: <20241112101849.109929145@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 12397755830bd..5fcc5f32be2d7 100644
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
index 6ecdf5d283390..c1e611c040a2c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dts
@@ -508,7 +508,6 @@
 	non-removable;
 	pinctrl-names = "default";
 	pinctrl-0 = <&emmc_bus8 &emmc_clk &emmc_cmd>;
-	supports-emmc;
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/rockchip/rk3568-lubancat-2.dts b/arch/arm64/boot/dts/rockchip/rk3568-lubancat-2.dts
index a8a4cc190eb32..abc33be2e74dc 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-lubancat-2.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-lubancat-2.dts
@@ -590,7 +590,6 @@
 	non-removable;
 	pinctrl-names = "default";
 	pinctrl-0 = <&emmc_bus8 &emmc_clk &emmc_cmd>;
-	supports-emmc;
 	status = "okay";
 };
 
-- 
2.43.0



