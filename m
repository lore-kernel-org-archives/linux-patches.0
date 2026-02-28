Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B2235AC18
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302691; cv=none; b=IiIedWzyr0MqxoIPMkYE5FrxQoH1yNZO9y5jJATpGFNVBFhhYMkXQ47vUZCo0+7tRFgtWNESrhZmJiZA3VtF8TCCPe2L07hzWISfc98XCW8DGfNsBPhe5vQtpPhFDEkDhhoCx5OmQG2YX6i1MnKd386klRDSWSk72tuvtKieqyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302691; c=relaxed/simple;
	bh=OFgjpe0+Gm35TYhipmQtkfGA2UWL58orW0Do0wEkP4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0u0smU8pZ5A5sgAdwyJazuhBLafYfSMq4vAQ6FFBxcdfshRHRYmluwT03tOErPe2RzXWti8a16ep2AhbCIJf7GoPHQ5yEjgYV/ynk2KYObGbHamiYwxbLqNU2r6J4R/Bwlr09Y3i4X7ptcpNzZJ11qRWgc5dREIVsxuckN3TxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o3rnWWCn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o3rnWWCn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18AF8C19423;
	Sat, 28 Feb 2026 18:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302691;
	bh=OFgjpe0+Gm35TYhipmQtkfGA2UWL58orW0Do0wEkP4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o3rnWWCnGLSgmFmmHjfH32yMt2+0lo4eRrOuQHYDD1BXjXCQt0IkmK9AP6t7eyc4J
	 ImQTrgbXv5sFbEMrZJVgWBbo/5gqg+d/5pAf3Tjz7Z/FtAIOiiNbB9n3KjibeObtVt
	 +2Ucz2YHOAqiXFBDPsX+5TxUvCTnz+l3COPIgheF+0k3K5Q95hixNR2cwRiurZdcgn
	 AXlRP+I57QmN3sBCZJqMAoIrXtvpebxYvV0VSlt13mlZqdVFjU2YTxpgRmlmqueapW
	 0WGUlypXUG/K07zrilCxa3nO56kEZZjgj71U9Bv3/PvMXaumnaoZBR+spHVGgUxoXW
	 kAzrTg4dsWJNQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/147] arm64: dts: amlogic: g12: assign the MMC A signal clock
Date: Sat, 28 Feb 2026 13:15:53 -0500
Message-ID: <20260228181736.1605592-45-sashal@kernel.org>
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
index ff764f7b017d7..27ebe5cc4f39c 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -2323,6 +2323,9 @@ sd_emmc_a: sd@ffe03000 {
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

