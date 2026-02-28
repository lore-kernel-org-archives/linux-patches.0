Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920C2375AAD
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301720; cv=none; b=Vhlm9d/NL1IRqm/sx8kK09zdty8Ajnv0ILbV2CSOd7LcuiR4ubM/JtD9ABYgV3WNGx2gEkwrAQ6NnODTds44hpXr+aFrit7tJPMxBKTOJmnWLYb68BGGR1Ck8FmTDc5S16JFB6uJV67Snzsiuk7DpecI1hixOueE7oUDaYT4w1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301720; c=relaxed/simple;
	bh=yK34dXhslRUCupxNFWeKPWwsirufOg3iC8AqBblGhEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gzdCOpGNXu0Q5TZ+f6d9s1KiAa4TtXcw1/4D0vqYEFkFfI05WdejDz4Ec3X9qKoGfhe7mVHXaK5MBeXgnMVOCVGbXVjtdZi3smCn8uOF7E6bXj7HADgbAsZQYwLDTJbKsuxF/YKI/6tFZKx58Cm4/OWb80XZJvp/zQ9N2eqX28E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YNCfXJ2e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YNCfXJ2e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0232C116D0;
	Sat, 28 Feb 2026 18:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301720;
	bh=yK34dXhslRUCupxNFWeKPWwsirufOg3iC8AqBblGhEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YNCfXJ2eNuzn15aQcyMgPL06j9Wp4tH7IeE+omdKC5VAQNkew1hFFY8iaXEu6vq10
	 /WVKKheY04hNLH8z9kQ0XXh9yPHsf5NacdOItp5Le6rbabikhiSm8XVzg2EvdCB5Wn
	 dmnF2qOcxqBvkPofEk4crPYuTeuFtqKkhD+Mz0zsplYlq0y8U3NwrzQjrK4wokgEiV
	 qitNpYSu58cQpBw6bIP01lADn2tO3F85m4WHXwFVeR7cSnb24XNUuF1c7AvHkDirHE
	 WoT/2e+82MHa0yvh0MRrdjWPMa5zq7HFG06X+185ZSJQ6AHj2aoC9bzcCjIOL+SeBY
	 4zLZeVpx8zEnQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 117/385] arm64: dts: amlogic: c3: assign the MMC signal clocks
Date: Sat, 28 Feb 2026 12:55:39 -0500
Message-ID: <20260228180011.1568201-117-sashal@kernel.org>
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

[ Upstream commit 69330fd2368371c4eb47d60ace6bca09763d24a0 ]

The amlogic MMC driver operate with the assumption that MMC clock
is configured to provide 24MHz. It uses this path for low
rates such as 400kHz.

Assign the clocks to make sure they are properly configured

Fixes: 520b792e8317 ("arm64: dts: amlogic: add some device nodes for C3")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260114-amlogic-mmc-clocks-followup-v1-1-a999fafbe0aa@baylibre.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/amlogic-c3.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/amlogic-c3.dtsi b/arch/arm64/boot/dts/amlogic/amlogic-c3.dtsi
index d0cda759c25d0..edd92500ebc96 100644
--- a/arch/arm64/boot/dts/amlogic/amlogic-c3.dtsi
+++ b/arch/arm64/boot/dts/amlogic/amlogic-c3.dtsi
@@ -570,6 +570,10 @@ sdio: mmc@88000 {
 				no-sd;
 				resets = <&reset RESET_SD_EMMC_A>;
 				status = "disabled";
+
+				assigned-clocks = <&clkc_periphs CLKID_SD_EMMC_A>;
+				assigned-clock-rates = <24000000>;
+
 			};
 
 			sd: mmc@8a000 {
@@ -585,6 +589,9 @@ sd: mmc@8a000 {
 				no-sdio;
 				resets = <&reset RESET_SD_EMMC_B>;
 				status = "disabled";
+
+				assigned-clocks = <&clkc_periphs CLKID_SD_EMMC_B>;
+				assigned-clock-rates = <24000000>;
 			};
 
 			nand: nand-controller@8d000 {
-- 
2.51.0

