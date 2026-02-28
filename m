Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A184346772
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302092; cv=none; b=F4O9ekUCjT4CUu0/6dTZWA/FKZO4OIsLvdGFj+3OgY1/iGv+nCGsmHx0ZygCZ3wJ05cMyTgeRXQiPFLP6Ve5GYBuEMpgWOtWL5lAz2lYGOlo8DDUYn9FpVK4NbjS0v+a0ez1GLpM94bYlkV+QBQEUMn+cx2jiVByXyyI/mByk9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302092; c=relaxed/simple;
	bh=blEfrk/DC3POCpjCiWKY2X4ZuSOuYlDFdw8riZBJTTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKd1j4/G39emoRCs1CxEPrJBKbnLL6L0u4yynw7dXTLW/U6w7RaY06BTQPQ9a84xJYMQ9uqBkg758NwzY4mRNDHN0tmjjcvpUlkmX5gDDa7B4VTgGc+glEIFMDuDy77pKqPch1YnU5ioyt/9Qm3fH8bvkmAYzmMayVKNSpAVQTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z8Vc/+an; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z8Vc/+an"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7C3C116D0;
	Sat, 28 Feb 2026 18:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302092;
	bh=blEfrk/DC3POCpjCiWKY2X4ZuSOuYlDFdw8riZBJTTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z8Vc/+angJDBlLsm3Aivq9Be5rmvfyarjYUByBsFE57FvdMIqvZqCWjdUPTEd+f9L
	 Qc7H8+YakYkSR74aOTT9Kii5Fhrq3rVeI7IKCyAwo0jLBgH5RBSzeTbQPCvx7nS3yF
	 NekRTKV2l/9XrhVqRVjRt+TVaXdHph84LJg8Ptd1KnwVffQPw38PmrRzvC+6bG01JD
	 7XNsRR/8QkWl4qllFa730zRYQzvfY45r+KS7pvph/V0bPcOlJVGv+CcO/vPJ/KM0Df
	 bRlVhZ0KvuWVy1LjLKSRoBoLW0Dj/sMBVU0kvJ9H1pZr8Q37Dyj1TgNLfmad0+pW9Z
	 x1E6MKVfXh7Tg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 076/283] arm64: dts: amlogic: g12: assign the MMC B and C signal clocks
Date: Sat, 28 Feb 2026 13:03:38 -0500
Message-ID: <20260228180709.1583486-76-sashal@kernel.org>
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
index 0ff0d090548d0..cf2d073154f43 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -2353,6 +2353,9 @@ sd_emmc_b: mmc@ffe05000 {
 				 <&clkc CLKID_FCLK_DIV2>;
 			clock-names = "core", "clkin0", "clkin1";
 			resets = <&reset RESET_SD_EMMC_B>;
+
+			assigned-clocks = <&clkc CLKID_SD_EMMC_B_CLK0>;
+			assigned-clock-rates = <24000000>;
 		};
 
 		sd_emmc_c: mmc@ffe07000 {
@@ -2365,6 +2368,9 @@ sd_emmc_c: mmc@ffe07000 {
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

