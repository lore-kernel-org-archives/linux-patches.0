Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5AB379EE2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301716; cv=none; b=PZgBWLg6MOfqxhbF1ZpT6qNl+KC7NzdBPHgoAHzIqfF6DZLjIEva9xYbNNR5FAp9CxTrSZX2phxTYQli0VJdUeW4Sg13dINefk/HBnTHoKj+bhXlZvd8u72hchhgY1Sz3+Lui59WSitjpilptoOiSF1GJg8iCgkYv+iLsLCfAxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301716; c=relaxed/simple;
	bh=m7pmvTA+fq2HLCAgyZbzAUGe4hUkhdfS1xqVOX6kLgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GkiI04BYHy/+7iODsfA0g99tdzQ5ZnivQaTRuXyKiS3b+B3EngGfzxxSPiPCIsWFL62HwqRBMOsYfikTLuXeJ9qsOmYNr+XOiXj+BC2/9X02u8Y6P9DbSeUf7ifhwZY33M4kzo7cyF7abS5POOJNBZ5xzcOSLGUqkZ+VuavoPKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r8T+moaO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r8T+moaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06B7C116D0;
	Sat, 28 Feb 2026 18:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301716;
	bh=m7pmvTA+fq2HLCAgyZbzAUGe4hUkhdfS1xqVOX6kLgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r8T+moaOH43gTMG2Lu0RZHwYK3u90jU55kWWruEZdOGbTCVBvDHrCgMFWGvQ/HjSl
	 4v7VsnktgBCYJAHo8CUn9NmuhVWYjjCxlk0hvNfrXB/JDX4MOpIxe8mCvIwv4zi8gS
	 Q5CI+Pw9/uDVsgjMjxZvkYWUTwSh4eWkgbf93IOoBp/Eeh23pLMRzB7GZffzcubFhQ
	 VWi9blPMcxncwUgahXg9vQmGGB7oz0VwM6eP/NUsuL16BK7EbqzljTBLtRHErErKCR
	 WiQGXP2LWceQi4WG/+uAwjEipxqGHRWRwDz7kUhrK4w95FM/EjOa/fRPsiqfo0c6PT
	 PR9hoRQCg8HFQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jerome Brunet <jbrunet@baylibre.com>,
	Nick Xie <nick@khadas.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 112/385] arm64: dts: amlogic: s4: assign mmc b clock to 24MHz
Date: Sat, 28 Feb 2026 12:55:34 -0500
Message-ID: <20260228180011.1568201-112-sashal@kernel.org>
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

[ Upstream commit 86124a8becb43eed3103f2459399daee8af2c99d ]

The amlogic MMC driver operate with the assumption that MMC clock
is configured to provide 24MHz. It uses this path for low
rates such as 400kHz.

This assumption did hold true until but it now, but it is apparently
not the case with s4. The clock has been reported to provide 1GHz
instead. This is most likely due to how the bootloader is using the MMC
clock on this platform.

Regardless of why the MMC clock rate is 1GHz, if the MMC driver expects
24MHz, the clock should be properly assigned, so assign it.

Reported-by: Nick Xie <nick@khadas.com>
Closes: https://lore.kernel.org/linux-amlogic/20260113011931.40424-1-nick@khadas.com/
Fixes: 3ab9d54b5d84 ("arm64: dts: amlogic: enable some device nodes for S4")
Tested-by: Nick Xie <nick@khadas.com>
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260114-amlogic-s4-mmc-fixup-v3-1-a4d3e136b3f2@baylibre.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-s4.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-s4.dtsi b/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
index 957577d986c06..4c45fd98381e8 100644
--- a/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
@@ -833,6 +833,9 @@ sd: mmc@fe08a000 {
 			clock-names = "core", "clkin0", "clkin1";
 			resets = <&reset RESET_SD_EMMC_B>;
 			status = "disabled";
+
+			assigned-clocks = <&clkc_periphs CLKID_SD_EMMC_B>;
+			assigned-clock-rates = <24000000>;
 		};
 
 		emmc: mmc@fe08c000 {
-- 
2.51.0

