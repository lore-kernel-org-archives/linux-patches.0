Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41DF338939
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301722; cv=none; b=ON37v/YUtgIzvpPASh/G2B0B4SgeuxpOP0KUP9pjPWltMKB+Zlx4My4dR7fmb8ZxDg98MBGobekWZPlf6duOxI/fUqK1ozc6ouLv8HzRgMs/O2PV5e+IeNP6b/51YlW0bima5HL8yhCU976fiBkDyi8GOkBiv7I5O1QHz6Y9R5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301722; c=relaxed/simple;
	bh=8I+SADlvJ0P43d9w61NkIHkPsYLbGFA9z8Ov89M1nTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PG+XliZHvMsAEAY8qFDjqT3G+RbL0/VcSM6FSzPe7ppVP0HYx+yShCZCOGk83/vuR1wCWBYWi3jMBZWggwmTggNZ5r8p/k0betlEKmSIoduXRPwYJMt/lItQvHLHLQILMSHEkEkLzlQdyYNj0/q0fnhwLSTWYXu6fEoeO9y65e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e0al0rL5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e0al0rL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 436E2C19423;
	Sat, 28 Feb 2026 18:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301722;
	bh=8I+SADlvJ0P43d9w61NkIHkPsYLbGFA9z8Ov89M1nTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e0al0rL5NhKaxzossHiWKE32Pvp33zzfi/1MLiZ3rqYdsm6gvmuceVqKhVB9IRnGk
	 qObWLMNqvPPe12YnplqCDZ6IsSmlUmTU7pfX0CJOIMKZte9V8rLx3GPC74L/rZ79rt
	 k9pK6TuGQioI7NiWyCbyNPgW/yyogpnxwfj7l2Kl8LEbAg42N/d3OFpSI0nItTGlCd
	 5zLMcMh+M/K1iLcDuq1rMhZFoIYm5cbSb5LrQ0uVbAN+g1gt+MLQn7TsYy290tPp6a
	 shLaBklm4iTcGj505pkrB4D0ziaAXSTH2ux4Yk38A9BzbrYKrFfkJbxY/oFhqE+j5n
	 +39aWr5Vpvmnw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 120/385] arm64: dts: amlogic: g12: assign the MMC B and C signal clocks
Date: Sat, 28 Feb 2026 12:55:42 -0500
Message-ID: <20260228180011.1568201-120-sashal@kernel.org>
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

[ Upstream commit be2ff5fdb0e83e32d4ec4e68a69875cec0d14621 ]

The amlogic MMC driver operate with the assumption that MMC clock
is configured to provide 24MHz. It uses this path for low
rates such as 400kHz.

Assign the clocks to make sure they are properly configured

Fixes: 4759fd87b928 ("arm64: dts: meson: g12a: add mmc nodes")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260114-amlogic-mmc-clocks-followup-v1-5-a999fafbe0aa@baylibre.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index d08c97797010d..c3a718de85c6d 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -2420,6 +2420,9 @@ sd_emmc_b: mmc@ffe05000 {
 				 <&clkc CLKID_FCLK_DIV2>;
 			clock-names = "core", "clkin0", "clkin1";
 			resets = <&reset RESET_SD_EMMC_B>;
+
+			assigned-clocks = <&clkc CLKID_SD_EMMC_B_CLK0>;
+			assigned-clock-rates = <24000000>;
 		};
 
 		sd_emmc_c: mmc@ffe07000 {
@@ -2432,6 +2435,9 @@ sd_emmc_c: mmc@ffe07000 {
 				 <&clkc CLKID_FCLK_DIV2>;
 			clock-names = "core", "clkin0", "clkin1";
 			resets = <&reset RESET_SD_EMMC_C>;
+
+			assigned-clocks = <&clkc CLKID_SD_EMMC_C_CLK0>;
+			assigned-clock-rates = <24000000>;
 		};
 
 		usb: usb@ffe09000 {
-- 
2.51.0

