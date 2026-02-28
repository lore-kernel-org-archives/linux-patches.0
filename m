Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137D139B963
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302546; cv=none; b=NwVcqyLlqY1kDMBVWQX696to4hlWbaPiKAv3z6E7d8ZTyc2J7PAj7uwmrJMNA1NQBKzFCiBf8T8Y97PsjP+5HorCcQGb74/PadQH3l5Tfq8txpdUwQfOYkjE6ZnMLTFAQ741LAxxHZIK5Fft9QkrQDWmsMm3yjPV/RSHtpEGjio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302546; c=relaxed/simple;
	bh=d9VagIoghnJjFcwuKdtTNepbL3dCXfy9YLRxwN0NBH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BGVV1EUedNWlrXUvC+YqAAJAl3roNG8pP33uXJjYy8HMXm7IhdSqcAUfHbnqIzy/1nb4RhyA+cvH9w4h+O0tIPPVIA1/EsDWwnHcMws501X/8h00gybfT9AMeeGGnntjf41aNjfL5MGqGIDxkQAbeIjlLUmvujdMkdf9pXzcEJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IbfjceuX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IbfjceuX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B80DC19425;
	Sat, 28 Feb 2026 18:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302545;
	bh=d9VagIoghnJjFcwuKdtTNepbL3dCXfy9YLRxwN0NBH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IbfjceuXCni24mCeoPrPVt19XeCeCSW7ZZOxhEoN3PNvG2R6qLTK5A7jwcveLFU/w
	 MszL7OEm/op5eT8y7dHUcuwtab4U7LIfZdVmwM1uwC+HNElHLhEY25KslZ/xCCRMUe
	 QEmCYJQ5l/onUOjyI7cFuqOLCYNu5ox5xiirjyGf6tOyJHjskYtX7lKYlntK4zJwVi
	 2L9nZU4Rn37YNqqyDVKRS6wFbCmNlcWMrpVZ9xgAC9K598W5cR+tc6xEkysdN2JYT2
	 2nRQp3zGsWUME5Ac9zSRUYoDNrBb5INqDhxl5bkbyT/zDwFXZhWkGkagZDFk+DJmYK
	 G50jYy7HY8tVA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 048/164] arm64: dts: amlogic: g12: assign the MMC A signal clock
Date: Sat, 28 Feb 2026 13:13:07 -0500
Message-ID: <20260228181505.1600663-48-sashal@kernel.org>
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

[ Upstream commit 3c941feaa363f1573a501452391ddf513394c84b ]

The amlogic MMC driver operate with the assumption that MMC clock
is configured to provide 24MHz. It uses this path for low
rates such as 400kHz.

Assign the clock to make sure it is properly configured

Fixes: 8a6b3ca2d361 ("arm64: dts: meson: g12a: add SDIO controller")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260114-amlogic-mmc-clocks-followup-v1-6-a999fafbe0aa@baylibre.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index 64bf34c9d769d..20b4575594a03 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -2336,6 +2336,9 @@ sd_emmc_a: sd@ffe03000 {
 				 <&clkc CLKID_FCLK_DIV2>;
 			clock-names = "core", "clkin0", "clkin1";
 			resets = <&reset RESET_SD_EMMC_A>;
+
+			assigned-clocks = <&clkc CLKID_SD_EMMC_A_CLK0>;
+			assigned-clock-rates = <24000000>;
 		};
 
 		sd_emmc_b: sd@ffe05000 {
-- 
2.51.0

