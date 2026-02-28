Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC807346AD3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302083; cv=none; b=WBf1Ri6F/TEcQxZedQ5gVJ6g8XpnbQeDcekTPuAUZlQdSY4fFGLwylvrI9VG12kSbCJ2/OG0wKX0YgKlCQDm1dhU+FtnPnDyLdO2Q+/nGXdIexS7Ea7vrtvK7b7OAbiydLmkisTcazhyYNuc8SsGFFoyvONXrS7duB97CnNQ4p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302083; c=relaxed/simple;
	bh=257ymC3i7Tx6e9zc0JpN6M5VvjqWx1sdMYKqrtB42jU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LlvWLmYvhmrUKDl7TB3dwZoSq/GU3RUxu2SsxaUKZ6m2tfoAEvkjgL7An0Ge6j8PaHoJ2Elh89YD5E4hsTJv0jykLpH7WnGt2fGrsPCebSXVkCzgOQyWnJ4qtM3rVX6FehkyUxOsLrALcPx41o8dLpRFDNv4BDKk9iSO60VySG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SxSEgrtS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SxSEgrtS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B93C19423;
	Sat, 28 Feb 2026 18:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302083;
	bh=257ymC3i7Tx6e9zc0JpN6M5VvjqWx1sdMYKqrtB42jU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SxSEgrtSWKtLAJRQIt7+K2QdT47dDUaDY9TTa7/7o17a3NAzLzYw7xAcSCDsctpa7
	 Hyg4VzJIv4MsIFGM9LDH25kW2HIFzoE1+WjMW4CQdJj0+QRCtl35dywn71zwyCKu+g
	 xqKp+xu+a4u3fwP04cecm62MhkNuWDTGQmt8eW6sswke4ZhAV+M/JT7z1feR0faBSR
	 qJo4AOXYTEOfHhIylkyCe2McPfp0MRL5fmjAEeQKEH0x/u+wJt00Q3JWxQjQkf0/ej
	 aibYIL4gC5MEGIBl63liagMm+13MpQ0/NLKmNON/vS4ECaohQcdJjgdbCOlPcYJM/w
	 Y+zf58kiVr+qA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Casey Connolly <casey.connolly@linaro.org>,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/283] arm64: dts: qcom: sdm845-oneplus: Don't keep panel regulator always on
Date: Sat, 28 Feb 2026 13:03:27 -0500
Message-ID: <20260228180709.1583486-65-sashal@kernel.org>
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

From: Casey Connolly <casey.connolly@linaro.org>

[ Upstream commit 45d1f42d3e84b5880cf9fab1eb24a7818320eeb7 ]

The panel regulator doesn't need to be always on, so remove this
property.

Fixes: 288ef8a42612 ("arm64: dts: sdm845: add oneplus6/6t devices")
Signed-off-by: Casey Connolly <casey.connolly@linaro.org>
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251118-dts-oneplus-regulators-v2-2-3e67cea1e4e7@ixit.cz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
index c50d335e0761f..4e335c9fd8185 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
@@ -251,7 +251,6 @@ vreg_l14a_1p88: ldo14 {
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
-			regulator-always-on;
 		};
 
 		vreg_l17a_1p3: ldo17 {
-- 
2.51.0

