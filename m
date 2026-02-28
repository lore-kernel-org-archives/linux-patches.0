Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EEA379ED5
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301721; cv=none; b=KJhcrPKChdsbpGwljJsYf0zngoo0nXpO6kpTOumDHloaAIoIuK6ukCTCZJJWPmHXZE0lUVmveclWmM452OTJs+Fe0mEd5vrewurc8+WiF9fvcxXbuhsP44UsP1Fv7r+TXK7A8Ncz55tC0k1dOygM25mr6y+Kql+iSlSuuVCvwJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301721; c=relaxed/simple;
	bh=xzORAQEbFY1pFkN5JYRfz1GO5l9qo04la2SqXfBNGH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2Tr2W2zDKKWMeqFDzr7AmpKsEJy3Nzbjlv510L+V9KNJoikjPrQAKdztCfLoiaq8hdO6EQvo3qnvGQCFCqw6vFAoHNInwzRUKhbN7VbUbBTBYmzVQwwnyJoJnnBz9Yye+7r5HdqopTbIQNQf+4G7TkDULUpAoCLnoG3GYpamyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cpkee+3T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cpkee+3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90D6C19424;
	Sat, 28 Feb 2026 18:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301721;
	bh=xzORAQEbFY1pFkN5JYRfz1GO5l9qo04la2SqXfBNGH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cpkee+3TfcMEo/4hafLMVstplsFUTWKeokjuxqK4qN4jLEtRipP+KkRKMEWkIjT1+
	 1P15cvmT5488XoSP5TNTQwmkukd5EXp3G2DRmhaGTSzzyE/mcN965atXHrMXfPBQ4G
	 BoJxAD/GZrvB8usbxQrjL0W74hqXwj6UQPYKI8gNWg6fH3BmxNTYs3vLUoMHPZLuTe
	 QP3oSgSC7QUL6NYKF/sklDqui4MauFcmJif4agkEv5RzZoXUWKllwRzccJQaYJCvjV
	 Y67yZeKFw3EjQBRAegpQfTpn4paUNe30K8mYREmOxQVO1l5hokZqDVYevdFNsGkuX0
	 f9WO1V99q9KVQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 118/385] arm64: dts: amlogic: axg: assign the MMC signal clocks
Date: Sat, 28 Feb 2026 12:55:40 -0500
Message-ID: <20260228180011.1568201-118-sashal@kernel.org>
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
index e9b22868983db..4717c9666f2a5 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
@@ -1923,6 +1923,9 @@ sd_emmc_b: mmc@5000 {
 					<&clkc CLKID_FCLK_DIV2>;
 				clock-names = "core", "clkin0", "clkin1";
 				resets = <&reset RESET_SD_EMMC_B>;
+
+				assigned-clocks = <&clkc CLKID_SD_EMMC_B_CLK0>;
+				assigned-clock-rates = <24000000>;
 			};
 
 			sd_emmc_c: mmc@7000 {
@@ -1935,6 +1938,9 @@ sd_emmc_c: mmc@7000 {
 					<&clkc CLKID_FCLK_DIV2>;
 				clock-names = "core", "clkin0", "clkin1";
 				resets = <&reset RESET_SD_EMMC_C>;
+
+				assigned-clocks = <&clkc CLKID_SD_EMMC_C_CLK0>;
+				assigned-clock-rates = <24000000>;
 			};
 
 			nfc: nand-controller@7800 {
-- 
2.51.0

