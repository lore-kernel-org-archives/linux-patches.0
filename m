Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69836379EDF
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301706; cv=none; b=qIW5jWWbcuQFnl7d4TrQffiAdzlJoEbJZ4Z7mN9nQUk4vsjcNtNXGVWf3ag6aw98xQKrG8XEOSt2JFzKqUwQ/E3X9+pAbQ0wQ0/YhxINIpoalkKQ1q1MdQwnbSdM92yjjjlG1/W0VEkmB1fGkMVHV+G5Ri3sm8qhExX8CznZggA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301706; c=relaxed/simple;
	bh=b56F7FLV6Bz04kiEcKDrj5e9qIwUKen40k75qsXEj/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CYdkwgmev/bOuDdXFb0VrAzy8kLdySUyu5CSl2b38V6/10Bz0tThTW7iRUSyYIdohPqiWsf/kfUIKCMqk/4V0/W9pOZfbW4Me76NyMM+UxzVF3NvD8DjWl5llaZKZvdb3n+6YD8Cnz6/6GNBEjZVCKfylZukdE1V8Eps4D19H6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZPJf2U3X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZPJf2U3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D12C116D0;
	Sat, 28 Feb 2026 18:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301706;
	bh=b56F7FLV6Bz04kiEcKDrj5e9qIwUKen40k75qsXEj/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZPJf2U3XLxk4Zr1sP+YVMomDFyQDNUyCPnZ9IWyK8la0En/clwJZIXGqHQvsOFWp3
	 6B8QoDStN9svNgyMo6tm4PDLj/+O3M2iZEHhC7NsbAaclQqU8J3yaV9i/c4Xm+uIUt
	 RFvgsPES9fBtqMw+A5ZFdMAAze0s5lMCHt9DTB6wCkYt92JUEBP4IYuoIVW2CaLzWi
	 4sF0J0Vdy2UOhVIDxlHIJBxo6lWowicMDE5sjQBIfdeTGqNE5ZnV7isQQS11xX5YnX
	 dPfPvwEH8jjaqkhnv6Nwrz234amhPW20woAnWi5AoKATAF6HJj7oRtONgESZP1pSwl
	 hNSo0ccRIyVGg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Casey Connolly <casey.connolly@linaro.org>,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 100/385] arm64: dts: qcom: sdm845-oneplus: Don't keep panel regulator always on
Date: Sat, 28 Feb 2026 12:55:22 -0500
Message-ID: <20260228180011.1568201-100-sashal@kernel.org>
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
index 56840b6ed6449..3b47baa011c23 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
@@ -252,7 +252,6 @@ vreg_l14a_1p88: ldo14 {
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
-			regulator-always-on;
 		};
 
 		vreg_l17a_1p3: ldo17 {
-- 
2.51.0

