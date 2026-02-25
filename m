Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7911F03DE;
	Wed, 25 Feb 2026 01:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983883; cv=none; b=mdrIsONaBJtCyeeEuJGYi9XDwoRiFL1b1LrNb4VP8c4IqbYQEzvSg7sB0e63QceCOOoJIs+EszTGlfgOzEQiHETntmVgeAmQvY8oUjfPKoICPYO+6BT3UgFf70qIEky28/GMxWx8qMCEUhK1gE6O/aKWQNDo/vkWRBXCQBK71cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983883; c=relaxed/simple;
	bh=iOnbOdj2pJD/UUmBWOpt+9EDVxpFj5Lha65g2VP4AII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jwS2VUdxsbhPZyc/lrPshoMHYSQkw9fY8McQmJVld+ZVFP7oZcR1xEbmpFrJqI7JDLKFrq7Sz1ylg/OhNLWiy3oYomCvrOV7jzq6Lqzf6jCmDIRMI1DTfdiR/6r0V7Ljihb8wHb9KvxXx2jC5VwJYDpFuSbfSUjRed8Qv4Y32Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OPuRnnXD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OPuRnnXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B221C116D0;
	Wed, 25 Feb 2026 01:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983883;
	bh=iOnbOdj2pJD/UUmBWOpt+9EDVxpFj5Lha65g2VP4AII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OPuRnnXDH06jM5Ts2PCvkI0fWPdLWN/yYS3rtb0EhN+/zpgO04/IKmEgximc3yHgE
	 3vvmwlzqmDdwg0E5K7pKo7vpr3qM2QH5uVblCpImIiL49WT54O2TZ1PpASDBAg6yR2
	 BG/X8zl1MOh7rEZnMinqp0xfQ9iVConJm3LiL99o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 157/641] arm64: dts: amlogic: gx: assign the MMC signal clocks
Date: Tue, 24 Feb 2026 17:18:03 -0800
Message-ID: <20260225012352.884698469@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 406706559046eebc09a31e8ae5e78620bfd746fe ]

The amlogic MMC driver operate with the assumption that MMC clock
is configured to provide 24MHz. It uses this path for low
rates such as 400kHz.

Assign the clocks to make sure they are properly configured

Fixes: 50662499f911 ("ARM64: dts: meson-gx: Use correct mmc clock source 0")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260114-amlogic-mmc-clocks-followup-v1-4-a999fafbe0aa@baylibre.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi | 9 +++++++++
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi  | 9 +++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
index f69923da07feb..a9c830a570cc6 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
@@ -824,6 +824,9 @@ &sd_emmc_a {
 		 <&clkc CLKID_FCLK_DIV2>;
 	clock-names = "core", "clkin0", "clkin1";
 	resets = <&reset RESET_SD_EMMC_A>;
+
+	assigned-clocks = <&clkc CLKID_SD_EMMC_A_CLK0>;
+	assigned-clock-rates = <24000000>;
 };
 
 &sd_emmc_b {
@@ -832,6 +835,9 @@ &sd_emmc_b {
 		 <&clkc CLKID_FCLK_DIV2>;
 	clock-names = "core", "clkin0", "clkin1";
 	resets = <&reset RESET_SD_EMMC_B>;
+
+	assigned-clocks = <&clkc CLKID_SD_EMMC_B_CLK0>;
+	assigned-clock-rates = <24000000>;
 };
 
 &sd_emmc_c {
@@ -840,6 +846,9 @@ &sd_emmc_c {
 		 <&clkc CLKID_FCLK_DIV2>;
 	clock-names = "core", "clkin0", "clkin1";
 	resets = <&reset RESET_SD_EMMC_C>;
+
+	assigned-clocks = <&clkc CLKID_SD_EMMC_C_CLK0>;
+	assigned-clock-rates = <24000000>;
 };
 
 &simplefb_hdmi {
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
index ba535010a3c91..e202d84f06720 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
@@ -894,6 +894,9 @@ &sd_emmc_a {
 		 <&clkc CLKID_FCLK_DIV2>;
 	clock-names = "core", "clkin0", "clkin1";
 	resets = <&reset RESET_SD_EMMC_A>;
+
+	assigned-clocks = <&clkc CLKID_SD_EMMC_A_CLK0>;
+	assigned-clock-rates = <24000000>;
 };
 
 &sd_emmc_b {
@@ -902,6 +905,9 @@ &sd_emmc_b {
 		 <&clkc CLKID_FCLK_DIV2>;
 	clock-names = "core", "clkin0", "clkin1";
 	resets = <&reset RESET_SD_EMMC_B>;
+
+	assigned-clocks = <&clkc CLKID_SD_EMMC_B_CLK0>;
+	assigned-clock-rates = <24000000>;
 };
 
 &sd_emmc_c {
@@ -910,6 +916,9 @@ &sd_emmc_c {
 		 <&clkc CLKID_FCLK_DIV2>;
 	clock-names = "core", "clkin0", "clkin1";
 	resets = <&reset RESET_SD_EMMC_C>;
+
+	assigned-clocks = <&clkc CLKID_SD_EMMC_C_CLK0>;
+	assigned-clock-rates = <24000000>;
 };
 
 &simplefb_hdmi {
-- 
2.51.0



