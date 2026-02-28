Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8742737F2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302344; cv=none; b=UCdytTxpbbT05Fl+ZmTQ7nPc+6aHYw+Z3qmxrDEp9xJqlX0AznDSAv0iOTfy5ry5grWf4Dbuai5CRWXeuHkFxGJsMapyhlsCNQYI+q3bo5VMuPN+GO2f9J2TcsM+QHvscYw73+Pb8nv+GV0bYsVA9OznonisMmQUmo28RM3+PS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302344; c=relaxed/simple;
	bh=/FtdJBqCyFnNq0KarmafHdW/51pY0Xu3rQJuvQE33lI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PaesNOumtNjZlb+tCB/pjUVKflEaorCK5TeAhRzOO3zaHOEk4LkHPMYv+rNwsiDHz5u3GV0udE2bBsSdC7ia2+r3I+zbqFf9HD3zSrWfhYv32UJ7BNc2F+PMX5zEoSlb/qaMA9EF+RaGVqBEUXCVSQQ83UWuc8MpfpuDpRxvgRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=beF7e+Zc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="beF7e+Zc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0EDDC116D0;
	Sat, 28 Feb 2026 18:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302344;
	bh=/FtdJBqCyFnNq0KarmafHdW/51pY0Xu3rQJuvQE33lI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=beF7e+ZcC+drur/oGZQO/5kwlW1iFkdK1GKMpRT22UQa9L5krj6+a6Xywq/TDAWhY
	 qm3V8c67jRAfIwscBdfxdJxoNgJVi/q114mbpUiA7M/HyiBX1DtuD9EkWRNU4vudU2
	 4cpQuQaJ1QW9/sFH5sASq3dQKaVJpKYTwS4WWU1n7zxalwS8hW1yIMJJrHFLAvGgs5
	 eJgocM0G/GffzaCGN12hQiNQWEkbYU/S9+GX7PIhcJzXJMZuwLQGFO8/4FLnQ9GUw3
	 odAtQlMSdbVozxRaVMrpSohheLU1E67Pi4o1liq/hQ0578HGdjHKWDj7gis1QNgNFl
	 S6C8Z5ClkwZPQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/232] arm64: dts: amlogic: axg: assign the MMC signal clocks
Date: Sat, 28 Feb 2026 13:08:40 -0500
Message-ID: <20260228181127.1592657-67-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 6cc685f91fc94..e93f68f705af5 100644
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

