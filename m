Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4005839B95C
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302537; cv=none; b=UMHxOZjiY2pwqr29sBJgmxjgCzw7YMeGBRJlJKhSexZeNgL1oHYZmLnHh8kWIhGxc+a2D8AEFiQyG0iIso65Pvz5MRQsDnto5s3ZFneRTg6m2cyLjZQ2fmC7H1F18Fyf1AHVZxmqu2n9W8b131Z27KcQ60w8BATPn2l8zTNYHgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302537; c=relaxed/simple;
	bh=MkevmhNAW6m6fkPIH/QvNjLKz5oOaCstPLisB6yhQY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PI5JCGt2+zDD9EZXVPmwgzGhXvAyI1twqgY6zKdNta9C4KrqGAbC9IeBDa43QK0UCNUz6ecZ7C1LAnJyd8P5tSdj8J8PvUXXFrLpkWlSPMvKeK7dg9NIOhaumXv2KfbfzMiYuVQb6OWS4B4DzNDOroL76XVVAF/6L8RqeAR+ec4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M132l52J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M132l52J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407ECC19425;
	Sat, 28 Feb 2026 18:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302536;
	bh=MkevmhNAW6m6fkPIH/QvNjLKz5oOaCstPLisB6yhQY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M132l52JgpoQY3m27uOf1c3wpPUW28KdVviVtp4ElbssLzPjVTRVD7oGlpcdeXj4i
	 0KdP+lOdZT/wD9xukwWcYL361HHFtfccJhc+IiKn8bT+ExuSBwYnBlqlKjXzYSLlo9
	 YG/rgwQyF6YZcdzoRAtbA20wHXYsUWTS+l7YFIhpuwMLGDP7x5F8zHMtaWw5UczdLn
	 qwpj7hT/IwI0Yun5aWeo7GaxqAzy9rfbJOA4ND19u24famWOYV2zluPV5qdNZoSKFh
	 q6ivkXCRMYsWJ4JFI59PhonaKrZ0ANine2SikxNwRQ/OdOGo5Q140y+k+7A05ccViE
	 4dJjgHMtQokVw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Casey Connolly <casey.connolly@linaro.org>,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 037/164] arm64: dts: qcom: sdm845-oneplus: Don't keep panel regulator always on
Date: Sat, 28 Feb 2026 13:12:56 -0500
Message-ID: <20260228181505.1600663-37-sashal@kernel.org>
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
index 66b86dd292c8a..1a1e344f870ef 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
@@ -232,7 +232,6 @@ vreg_l14a_1p88: ldo14 {
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
-			regulator-always-on;
 		};
 
 		vreg_l17a_1p3: ldo17 {
-- 
2.51.0

