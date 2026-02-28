Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB5534252B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301722; cv=none; b=gtX7en+ydrzhQJpB73A23zPmdADtqlUJJwXUTge312xWNvfHHRxkZdYJJd4LMKDAZV1u46qEDErxbxFvmT6+QECPFOPhjGPSCvK/4zDCSfMC1aU5bjCg62bpf9LZGIqr3J+IYCzcsX2esfuNzJ0QkY2gemintQv9gESF7dTnKik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301722; c=relaxed/simple;
	bh=6jFmzm5AQ8bbB8HU9/RIjU49jukgVqAKBzTdo+2ra3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lRGMhG84GR0oQ81CikhSX7JfNNC2BtsDQ1DKg1iPxcC5/n3+yjACVwXUGutCTqVcYIwLtU4xGpkRo1IZwQZsCiaxAymSnF5YWootXJSLek6XSN0GWOHnsEOyUyvfdpOqGLZdUxDCvXQKrXLFc5VBLDlMcmTRM4TQVNkc16lgEI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oA3YeNRY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oA3YeNRY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C120C116D0;
	Sat, 28 Feb 2026 18:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301722;
	bh=6jFmzm5AQ8bbB8HU9/RIjU49jukgVqAKBzTdo+2ra3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oA3YeNRYKYu+3/X2B+moKmCaQeFQlx76K/v+VuI1mHJHNs9LYJXlnod9xPlrLZrJu
	 kzag7CDYpPDeHUg98gGmMjihOI5V78VHSlMgh8h4esq4h0SiWnIOkNylYH3jUd4CAt
	 xZeGwu5MSt7ta5eokam97BiSHrX4v5XreR6kXpu/wkZN3Ozg8mutqoueGoHnfJsCRJ
	 XYLbNERiJ/jNHB1ihbFmmAwlmexzaNqAJyTb0Sr8cqYeqbUL45t2fd/svE1Iuim3UZ
	 TM6AfN2GS47SZuI2bzRHCwCqp58pSqn9nd3apobhIvIGeYINH8moHvtJwRBGvfBjmu
	 jCr4DMHsNvntA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 119/385] arm64: dts: amlogic: gx: assign the MMC signal clocks
Date: Sat, 28 Feb 2026 12:55:41 -0500
Message-ID: <20260228180011.1568201-119-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index ed00e67e6923a..851ae89dd17fa 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
@@ -799,6 +799,9 @@ &sd_emmc_a {
 		 <&clkc CLKID_FCLK_DIV2>;
 	clock-names = "core", "clkin0", "clkin1";
 	resets = <&reset RESET_SD_EMMC_A>;
+
+	assigned-clocks = <&clkc CLKID_SD_EMMC_A_CLK0>;
+	assigned-clock-rates = <24000000>;
 };
 
 &sd_emmc_b {
@@ -807,6 +810,9 @@ &sd_emmc_b {
 		 <&clkc CLKID_FCLK_DIV2>;
 	clock-names = "core", "clkin0", "clkin1";
 	resets = <&reset RESET_SD_EMMC_B>;
+
+	assigned-clocks = <&clkc CLKID_SD_EMMC_B_CLK0>;
+	assigned-clock-rates = <24000000>;
 };
 
 &sd_emmc_c {
@@ -815,6 +821,9 @@ &sd_emmc_c {
 		 <&clkc CLKID_FCLK_DIV2>;
 	clock-names = "core", "clkin0", "clkin1";
 	resets = <&reset RESET_SD_EMMC_C>;
+
+	assigned-clocks = <&clkc CLKID_SD_EMMC_C_CLK0>;
+	assigned-clock-rates = <24000000>;
 };
 
 &simplefb_hdmi {
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
index f58d1790de1cb..f7fafebafd809 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
@@ -869,6 +869,9 @@ &sd_emmc_a {
 		 <&clkc CLKID_FCLK_DIV2>;
 	clock-names = "core", "clkin0", "clkin1";
 	resets = <&reset RESET_SD_EMMC_A>;
+
+	assigned-clocks = <&clkc CLKID_SD_EMMC_A_CLK0>;
+	assigned-clock-rates = <24000000>;
 };
 
 &sd_emmc_b {
@@ -877,6 +880,9 @@ &sd_emmc_b {
 		 <&clkc CLKID_FCLK_DIV2>;
 	clock-names = "core", "clkin0", "clkin1";
 	resets = <&reset RESET_SD_EMMC_B>;
+
+	assigned-clocks = <&clkc CLKID_SD_EMMC_B_CLK0>;
+	assigned-clock-rates = <24000000>;
 };
 
 &sd_emmc_c {
@@ -885,6 +891,9 @@ &sd_emmc_c {
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

