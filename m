Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA1D344D9A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301717; cv=none; b=rmfsinTDDfuryjPLRU6AGBw40jzo6YbrZKaEgziM9ozctZLdxXDLIqTZ3DTbdfP/vW531iDqQCUP8d6ACF5x1PC5oCakTTQs4y8PaGtSyLX3NN++sWPFJuHpPQhB/HuUshhAe1USh4yy8UzFzCVVnV3xf8bsJl6DvEKU6M1cEzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301717; c=relaxed/simple;
	bh=HznJm+DmsYQj75uisWqvdBNIwWgW7Fsw40PhapLa4ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4jDPuTCwebd/Nm2QEhkPSnxDVIcfzF1QiXi21rhfAGSCQe/BzupD3o+TBC43ushLHvcpqmfbdn8yh+J6JGqdoXbst3ZznukSwTkctPkACjN+vbe9oO//i8Q+AhqHCBL5T4rmWqlolVHPfK/ZK/OJIvhDkih4+3+WH+eeYPDxXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nSBy6V/B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nSBy6V/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C94C19423;
	Sat, 28 Feb 2026 18:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301717;
	bh=HznJm+DmsYQj75uisWqvdBNIwWgW7Fsw40PhapLa4ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nSBy6V/ByooHZLoFuLLlZ/cv7HOQ0ox2XG5WAPB6jsiHDFEI6AfQudlwfZ3P20U4r
	 fe+2cWhNHXvfLCciIJIemewRIlWluOlnFgF4jvQo1AVKqDhC9zA7372L8Zj5jNtFFr
	 uXdzYpzTRtRCjogf0sFfNQ4sl0BHKBPxrH1/27myG55ALJkAwzawNVYBLokZmLPvHM
	 F7pKDtXQ0LzgkJqZtMeXaXz52oX6fOFQ8jv8r6W+e38wSsDQsd7HHm/f70Pask6GVK
	 ecS5YUBk/6yM3Jf7f4GBdj1brRrkgQs7hR9OLgKsEX7WnKUqs//KZleJAcohbH7v2J
	 pg/dZ7XeCpAWg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jerome Brunet <jbrunet@baylibre.com>,
	Nick Xie <nick@khadas.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 113/385] arm64: dts: amlogic: s4: fix mmc clock assignment
Date: Sat, 28 Feb 2026 12:55:35 -0500
Message-ID: <20260228180011.1568201-113-sashal@kernel.org>
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

[ Upstream commit 3a115d42922cffc91b303992eadf220111d66c31 ]

MMC A and C are mis-represented as having their "clkin0" input connected to
xtal while it is actually connected to the MMC clock, probably in an
attempt to provide 24MHz to the device on this input.

Fix this and assign the clock to 24MHz to actually provide the required
rate.

Fixes: 3ab9d54b5d84 ("arm64: dts: amlogic: enable some device nodes for S4")
Tested-by: Nick Xie <nick@khadas.com>
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260114-amlogic-s4-mmc-fixup-v3-2-a4d3e136b3f2@baylibre.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-s4.dtsi | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-s4.dtsi b/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
index 4c45fd98381e8..7326aaa8d0ed7 100644
--- a/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
@@ -814,13 +814,16 @@ sdio: mmc@fe088000 {
 			reg = <0x0 0xfe088000 0x0 0x800>;
 			interrupts = <GIC_SPI 176 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&clkc_periphs CLKID_SDEMMC_A>,
-				 <&xtal>,
+				 <&clkc_periphs CLKID_SD_EMMC_A>,
 				 <&clkc_pll CLKID_FCLK_DIV2>;
 			clock-names = "core", "clkin0", "clkin1";
 			resets = <&reset RESET_SD_EMMC_A>;
 			cap-sdio-irq;
 			keep-power-in-suspend;
 			status = "disabled";
+
+			assigned-clocks = <&clkc_periphs CLKID_SD_EMMC_A>;
+			assigned-clock-rates = <24000000>;
 		};
 
 		sd: mmc@fe08a000 {
@@ -843,13 +846,16 @@ emmc: mmc@fe08c000 {
 			reg = <0x0 0xfe08c000 0x0 0x800>;
 			interrupts = <GIC_SPI 178 IRQ_TYPE_EDGE_RISING>;
 			clocks = <&clkc_periphs CLKID_NAND>,
-				 <&xtal>,
+				 <&clkc_periphs CLKID_SD_EMMC_C>,
 				 <&clkc_pll CLKID_FCLK_DIV2>;
 			clock-names = "core", "clkin0", "clkin1";
 			resets = <&reset RESET_NAND_EMMC>;
 			no-sdio;
 			no-sd;
 			status = "disabled";
+
+			assigned-clocks = <&clkc_periphs CLKID_SD_EMMC_C>;
+			assigned-clock-rates = <24000000>;
 		};
 	};
 };
-- 
2.51.0

