Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784D435AC01
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302689; cv=none; b=GI4ma2ieW+3FRDrep03pcmhOapOtCzJCGSbZfr7wJoi9nJHx0UcNfoau/Ai4Mw9W83xkHyzGpoUzew7hk8O5a9DsyMYXAzMfTuFIzlNUp9Z4r47/HgHuSrIqiDf+c6Ccv6dJAkjaF0Zto26/CU5n9qTb6mj3iMrdryL7IXVvTRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302689; c=relaxed/simple;
	bh=RmTVrZmV2hjIiEvEwmF4jBaZ5qYVnaabOmqNs8/5lWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uH2p5Y4IevDZBBNZ/RWlRZ7OBDroZuycXIyxIN0KPoSqKER70UQvlcM1zQpD51vByDgzliSRvj63C6OLTIPb5ZuTIW/AahibcfMqV/Sze7bSvHhqWHD/Ed8nxCMXAOljOxvsiJrMCmUJXEI2nizHoJF2dMKhiAU2ahKtSapIzss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tGRNJtpJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tGRNJtpJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0950C116D0;
	Sat, 28 Feb 2026 18:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302689;
	bh=RmTVrZmV2hjIiEvEwmF4jBaZ5qYVnaabOmqNs8/5lWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tGRNJtpJ9NvcDljGraeiVkyeCtrX1kBGObptbzfvx9QV+g9YaQiPeef1cgIMJvDJP
	 UAn2zczOZ622snucCIXJ352MHGu06s+uw5PCd67qEMW6id1kpwC67KlEIId5s24lad
	 C7TtZQZyzk73O4YuXOSDzAVJHikNrN+Dk5ETkkxsV/4y44IXIwLINdWnlBUaRwPYYV
	 5UntNejewa6uGQ4DoXvCfw+PT81pEnyJ53jmyRK0ecrGfNW77euMQDMsAKprO1UbFe
	 bSokuQvqD9kX6nkyPygWA9WA2xw8dT5ai1719G/RYtoVub6A8R/QMh27HxdjB/6Ctd
	 TT2V7edA+lD6g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/147] arm64: dts: amlogic: axg: assign the MMC signal clocks
Date: Sat, 28 Feb 2026 13:15:50 -0500
Message-ID: <20260228181736.1605592-42-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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

[ Upstream commit 13d3fe2318ef6e46d6fcfe13bc373827fdf2aeac ]

The amlogic MMC driver operate with the assumption that MMC clock
is configured to provide 24MHz. It uses this path for low
rates such as 400kHz.

Assign the clocks to make sure they are properly configured

Fixes: 221cf34bac54 ("ARM64: dts: meson-axg: enable the eMMC controller")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260114-amlogic-mmc-clocks-followup-v1-3-a999fafbe0aa@baylibre.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
index c892b252e5b0c..18e705169201b 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
@@ -1761,6 +1761,9 @@ sd_emmc_b: sd@5000 {
 					<&clkc CLKID_FCLK_DIV2>;
 				clock-names = "core", "clkin0", "clkin1";
 				resets = <&reset RESET_SD_EMMC_B>;
+
+				assigned-clocks = <&clkc CLKID_SD_EMMC_B_CLK0>;
+				assigned-clock-rates = <24000000>;
 			};
 
 			sd_emmc_c: mmc@7000 {
@@ -1773,6 +1776,9 @@ sd_emmc_c: mmc@7000 {
 					<&clkc CLKID_FCLK_DIV2>;
 				clock-names = "core", "clkin0", "clkin1";
 				resets = <&reset RESET_SD_EMMC_C>;
+
+				assigned-clocks = <&clkc CLKID_SD_EMMC_C_CLK0>;
+				assigned-clock-rates = <24000000>;
 			};
 
 			usb2_phy1: phy@9020 {
-- 
2.51.0

