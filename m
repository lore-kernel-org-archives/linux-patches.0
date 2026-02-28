Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E90379EEC
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301705; cv=none; b=fwgIfMpQ9o1mmo5iD+IjX4FBdipCrin3zpJTK8jCOvDqjgqhp+6vNHGu2Ne3HNhb0wqlH9v+A2rwAYSsOBpG/TDzs0G7HsCpp/tGXzvwc8huO93sKWv5sfiM3Xub1wiZy18gdhrNc2DGmtVoNupIvk6fjPUDAlZGukXTTTR0BKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301705; c=relaxed/simple;
	bh=rg4ovkt22X7c97RXPPHxyhY2eRR4xLkLTW0HAMWxQT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NGTbwPgNbCP/W2WkUacTqrcRDI8kGL57O1opMCdFqxOdleaOMWmuI4yhUf80Rlyjs3Il5gFYst+8U5du/o6NGtKwKNtltucG7xptf3KLfWGvCamUFpcO14FLhb7MTltHFwZwZxKWS/KcMJbv0+n+ORzXCQHPx62DVftxy6xX4jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cT5DhJ19; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cT5DhJ19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3862C19424;
	Sat, 28 Feb 2026 18:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301705;
	bh=rg4ovkt22X7c97RXPPHxyhY2eRR4xLkLTW0HAMWxQT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cT5DhJ197ViUV5Y4QVZ4G1xQE5zlnFu3WWVSrDraaHBricWPrvYFDc/xLBcQ3sqrC
	 l/TzYle+kAivBU9QHjNmzF2SgHmH/d/YZlAsC5cBDv8GcU2duQXXpHrkP4PKMr8/A/
	 InAJQq/pzRob17iSA5XC+JslyYu91VIZ/mmcYh/MRNnA0hQIvYg6s+a+C/N9cxsVOq
	 Lihml59U+W308WgmwiuflwPSlkKkGMMTdnKDJSNHKiUFmMFOIveIJk2Nj8BMxUe06A
	 feXlMTLidKmvfkMQqtErX1aT+TI1Dv6lYfrDuPLvNaYDNi8WbA1R5zoFM0ISP90ND4
	 L6euqa4Tr2Zpg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Casey Connolly <casey.connolly@linaro.org>,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 099/385] arm64: dts: qcom: sdm845-oneplus: Don't mark ts supply boot-on
Date: Sat, 28 Feb 2026 12:55:21 -0500
Message-ID: <20260228180011.1568201-99-sashal@kernel.org>
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

From: Casey Connolly <casey.connolly@linaro.org>

[ Upstream commit c9b98b9dad9749bf2eb7336a6fca31a6af1039d7 ]

The touchscreen isn't enabled by bootloader and doesn't need to be
enabled at boot, only when the driver probes, thus remove the
regulator-boot-on property.

Fixes: 288ef8a42612 ("arm64: dts: sdm845: add oneplus6/6t devices")
Signed-off-by: Casey Connolly <casey.connolly@linaro.org>
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251118-dts-oneplus-regulators-v2-1-3e67cea1e4e7@ixit.cz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
index d0cbf9106a792..56840b6ed6449 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
@@ -156,7 +156,6 @@ ts_1p8_supply: ts-1p8-regulator {
 
 		gpio = <&tlmm 88 0>;
 		enable-active-high;
-		regulator-boot-on;
 	};
 };
 
-- 
2.51.0

