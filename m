Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC4C39B94A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302545; cv=none; b=KoOe4k61W0a8NRzhoHe68bcv4MdCE2zJ1/nENeWzeSe7uxaOKOlhEiwJXWgcJZjFJHxMAj/6IDgNP+GUp/cYQkDPoZyXV1PmpzhTMUPGhl51ZE/GmBKO+1rFz8j0d25nf9uIhDfS0ARsfQSlDzRbfzBF/qfEv8jkq942865ZEK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302545; c=relaxed/simple;
	bh=sbveAkgV8mRS/pL24oojCUCX/Wf1Ou0OQKw46TNhU7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WdfqJl8KmkLvUY0odNjtCXIzNGjZbUNuLXkdefvM/p4S06SWoGwyqzvDqjndcKe+XHUv3d83WMsUGM7gfqXEPch95RKYgObwcppnEpPsoYctd6GyI04VnqQN8m98biZA6/G3wkSSlQUuo473QUQLskNBsD4nDITlykQ1YAlPkY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SQGI9rmN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SQGI9rmN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF93C19423;
	Sat, 28 Feb 2026 18:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302545;
	bh=sbveAkgV8mRS/pL24oojCUCX/Wf1Ou0OQKw46TNhU7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SQGI9rmNe1C4/NyRkFzHi7x+3Wsu/75CdlbBctE5/XQvZ9IhWsiSS+1c0g1PDBQu2
	 u7mjL6Feexo7jgLMtF3aRu8KxivMOQBCK0Y75UONWDBUyhCTFiYtcjVzYE79ZUttXp
	 HaRu+0Xsf3lWcOHpG4wCjPHbKRo3DXxuKqQIjQ3Kpj8TNGbSMCf2Rn6CTM4Vq+JTvI
	 Gg8+64ob5a611S3wFCoX/5IvpaiGWjy1oc0I/jpBpflr0VuVT9z0pQM9P89xIua4yQ
	 mcdZNYUxOTc0NYstDA4YxqoFs/eaNk6iG4Voep3TtSqjFdgfDIw3P4G9XAD2LMzEkL
	 bk56g0lBfAvVg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 047/164] arm64: dts: amlogic: g12: assign the MMC B and C signal clocks
Date: Sat, 28 Feb 2026 13:13:06 -0500
Message-ID: <20260228181505.1600663-47-sashal@kernel.org>
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
index 369334076467a..64bf34c9d769d 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -2348,6 +2348,9 @@ sd_emmc_b: sd@ffe05000 {
 				 <&clkc CLKID_FCLK_DIV2>;
 			clock-names = "core", "clkin0", "clkin1";
 			resets = <&reset RESET_SD_EMMC_B>;
+
+			assigned-clocks = <&clkc CLKID_SD_EMMC_B_CLK0>;
+			assigned-clock-rates = <24000000>;
 		};
 
 		sd_emmc_c: mmc@ffe07000 {
@@ -2360,6 +2363,9 @@ sd_emmc_c: mmc@ffe07000 {
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

