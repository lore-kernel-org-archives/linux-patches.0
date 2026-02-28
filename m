Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59A739B946
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302544; cv=none; b=s+4ricgKphq3wC2A/ed8BIdIkcMJzm9eSCYHMHoYkf1k1fWYyQSJpdC00LKKG8e9b8gokPBs4FciVuNL2czXQRiH9m+NTJtzwKu6dhtTYX+GrlZnyATBG9MXYAScjwVaqZ4c4bi+oXFnA3AdfUx6g3f5iRkuY5vET3NuA5ppFM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302544; c=relaxed/simple;
	bh=O9h42/cOQQiz3I0DYi2IVQ/catvVPOV0PDwNmJp7T+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PgPgsAO92RjAnRk25ratMaxoFtema/3USPboGWVYD5EXBfoCV8aCmopxegykxBjs9JMbr9hpTQCqdGvxtjwFxV5JbxAIOI2o1VZw1dv8gUgdhG3ufQzi7OLYPOjuQseoH+6LFRhjJaredJgiZi+NW1BVj0ySTBLsEF+B5SdUSgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tpr6yFXT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tpr6yFXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED090C116D0;
	Sat, 28 Feb 2026 18:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302544;
	bh=O9h42/cOQQiz3I0DYi2IVQ/catvVPOV0PDwNmJp7T+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tpr6yFXTi3nOrx4GfJAJm03xKHVeskQnLDgB2955//GmK3PqkarA0AV0z8vIwfD39
	 r9tPUCCbhFEUqV22cW9oetOT4+D5bmIVP0He/51m9CXhfzadg/UWeX5PSdQa+Is85a
	 WodExUcRvMJMPfD3L+x/rlDXsqzwXqmb9PUF537NuNJdKZ+6Py5DxuutArZsQ/doHI
	 6lc7r+CHxz/kDhY4drqtXem5+XmSvKxJgykopJL/oGkkoGN11hIZT11uZ0GTqpMy9T
	 wbKcsWKl0HrqnH8WsMnXi7g2d71GGF7pcFEzn5hYR+MSHE2CKQY4ljE5GryFiMFGiR
	 xpmV+g6f6s2GQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 046/164] arm64: dts: amlogic: gx: assign the MMC signal clocks
Date: Sat, 28 Feb 2026 13:13:05 -0500
Message-ID: <20260228181505.1600663-46-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index 256c46771db78..c57a6f37bc2af 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
@@ -779,6 +779,9 @@ &sd_emmc_a {
 		 <&clkc CLKID_FCLK_DIV2>;
 	clock-names = "core", "clkin0", "clkin1";
 	resets = <&reset RESET_SD_EMMC_A>;
+
+	assigned-clocks = <&clkc CLKID_SD_EMMC_A_CLK0>;
+	assigned-clock-rates = <24000000>;
 };
 
 &sd_emmc_b {
@@ -787,6 +790,9 @@ &sd_emmc_b {
 		 <&clkc CLKID_FCLK_DIV2>;
 	clock-names = "core", "clkin0", "clkin1";
 	resets = <&reset RESET_SD_EMMC_B>;
+
+	assigned-clocks = <&clkc CLKID_SD_EMMC_B_CLK0>;
+	assigned-clock-rates = <24000000>;
 };
 
 &sd_emmc_c {
@@ -795,6 +801,9 @@ &sd_emmc_c {
 		 <&clkc CLKID_FCLK_DIV2>;
 	clock-names = "core", "clkin0", "clkin1";
 	resets = <&reset RESET_SD_EMMC_C>;
+
+	assigned-clocks = <&clkc CLKID_SD_EMMC_C_CLK0>;
+	assigned-clock-rates = <24000000>;
 };
 
 &simplefb_hdmi {
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
index a689bd14ece99..fb6e8c466811f 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
@@ -848,6 +848,9 @@ &sd_emmc_a {
 		 <&clkc CLKID_FCLK_DIV2>;
 	clock-names = "core", "clkin0", "clkin1";
 	resets = <&reset RESET_SD_EMMC_A>;
+
+	assigned-clocks = <&clkc CLKID_SD_EMMC_A_CLK0>;
+	assigned-clock-rates = <24000000>;
 };
 
 &sd_emmc_b {
@@ -856,6 +859,9 @@ &sd_emmc_b {
 		 <&clkc CLKID_FCLK_DIV2>;
 	clock-names = "core", "clkin0", "clkin1";
 	resets = <&reset RESET_SD_EMMC_B>;
+
+	assigned-clocks = <&clkc CLKID_SD_EMMC_B_CLK0>;
+	assigned-clock-rates = <24000000>;
 };
 
 &sd_emmc_c {
@@ -864,6 +870,9 @@ &sd_emmc_c {
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

