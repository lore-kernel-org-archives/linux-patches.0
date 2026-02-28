Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D058F37524F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302543; cv=none; b=P1sks18VzaC6fuf3a6sPHv22KziGR5JPlYqwe4/E0LApcrIPjgGaDwyGqUvks6ezrZwnj+cERWcfgdb7TwKBiRFYi1Y3RBPIS0VAekRm6v+7I+TGrcQJAFF5diwMb6mnijNq4nGsKDHSB3X+EUFonEia8x7uQ+xH/lHRv3PgEcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302543; c=relaxed/simple;
	bh=bpu0aGzBPKVvFz+XJhOMpNCvP9Zufvjn5WU1U3O0fY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqDTynl8afPofDEWMgQzLM+O1zT0Dvi9+nIXaLp8Sns64eUgQD/lzEanl93o+gQU52cs4jLEyuh4jbWYMsGRUYodXYKqNTryFEj/IQlqrrSPPAkZ3DwZ5KGh1X0DM8Z0yJly8Q6qU5y6yflsqHCEIQNlMJDkl57PIcICqyiqWCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X5s18SUH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X5s18SUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373DFC19424;
	Sat, 28 Feb 2026 18:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302543;
	bh=bpu0aGzBPKVvFz+XJhOMpNCvP9Zufvjn5WU1U3O0fY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X5s18SUH3if0WQ1WDN8NUtlpQyTdLPtncxeizEcYqYoyG9shIntyasct8ZLcU8NIr
	 dCt6GSBJZQ/1zp4y23nt57evOBv+EpLoS+dfjkNuo1+GJL8JTX3nPbolDe01ZIFBL7
	 1hTcKgJ3nTyikF6XlJPPPuKJ38ms9G/kvVwE3WU3itIShuEeFx+/Wgmf/zcxq77E72
	 AJvvkhWnfvX2SDv12a1Uw4k/y6OtlSibHt549k0kdERttvGPN8vmGlKaKuwiEUjCQf
	 lpf/NpD3is+SuNhrw6xftY/xro2YzhRG8gK/LKVv+ya7fFGBGANo36X/LRgko2r+YS
	 PIONYcHGD9zdw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 045/164] arm64: dts: amlogic: axg: assign the MMC signal clocks
Date: Sat, 28 Feb 2026 13:13:04 -0500
Message-ID: <20260228181505.1600663-45-sashal@kernel.org>
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
index db5a1f4653135..280fe16b68fe0 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
@@ -1892,6 +1892,9 @@ sd_emmc_b: sd@5000 {
 					<&clkc CLKID_FCLK_DIV2>;
 				clock-names = "core", "clkin0", "clkin1";
 				resets = <&reset RESET_SD_EMMC_B>;
+
+				assigned-clocks = <&clkc CLKID_SD_EMMC_B_CLK0>;
+				assigned-clock-rates = <24000000>;
 			};
 
 			sd_emmc_c: mmc@7000 {
@@ -1904,6 +1907,9 @@ sd_emmc_c: mmc@7000 {
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

