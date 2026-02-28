Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D72379EF1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302090; cv=none; b=kT+9QebhxlsuwIXe2waaUamJBAe1GQ3K9g4E2I1kmnoCCWhVi48xEiwYNgWnBiMSh0BcucJ6u2S9wNAg2OPYA50MWHprIgvfRZ2GOeZ9EVIWN1j1s7QxFCcQckzwyulKbV6pAYGDl1pV0U2n7Xk+gERPF6399vd6hOi9GSG/FN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302090; c=relaxed/simple;
	bh=7gA32HN3tVu7SU93MsRIgL49mIflUgX1oIcUvb8gyn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YSZxOYu7g9ik61XtSi277oNkY4TXm9y9Nn9L2lh7m75cZ1Eq16apwcWupoC9Mj1loTRl+IX11t20IIaLAMpt0Lalksxnp+wANb4h39/1onyf4UbGEaUVt0GMpQRcEVfdeVWD14JBk1y6knfJVyEjLpk7ga9zF1yv7NLqwfYb3Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GIdi6isK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GIdi6isK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B372C116D0;
	Sat, 28 Feb 2026 18:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302090;
	bh=7gA32HN3tVu7SU93MsRIgL49mIflUgX1oIcUvb8gyn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GIdi6isKhiuXq31YZDiAZHj0727QUrsWK5q5Bukyn/QWmQklwCSv35f5K0L3wTLHL
	 Fbcyfs+R56pwTm0mXyk9w9QYeJAWHN9Pg6aVlOeL/tBQpHo+Cx5MCE38nLTSL5zcXe
	 BqnesVN4sHeY34K0FUx7FMNRMicqOarfokCoDopplKfgs0D4cLPOKjOhtSLM+T+9uy
	 PLyFGKbZ8Mu0cLJ534CUZQB/1RCg+fMtmloDzrHfZkq9KdnDp8HwpHdkmXfZLBr3CV
	 AGiSEjsJKjK2KULQve9aXRjQEjEk/UBIYg2Ero8XeGs82Za9yyMbtSvyGHFIkSW+0q
	 gs0vDYPOuP6cw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/283] arm64: dts: amlogic: axg: assign the MMC signal clocks
Date: Sat, 28 Feb 2026 13:03:36 -0500
Message-ID: <20260228180709.1583486-74-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 768d0ed78dbe6..16af71d84a132 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
@@ -1894,6 +1894,9 @@ sd_emmc_b: mmc@5000 {
 					<&clkc CLKID_FCLK_DIV2>;
 				clock-names = "core", "clkin0", "clkin1";
 				resets = <&reset RESET_SD_EMMC_B>;
+
+				assigned-clocks = <&clkc CLKID_SD_EMMC_B_CLK0>;
+				assigned-clock-rates = <24000000>;
 			};
 
 			sd_emmc_c: mmc@7000 {
@@ -1906,6 +1909,9 @@ sd_emmc_c: mmc@7000 {
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

