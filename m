Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43EB145A18;
	Tue, 30 Jul 2024 15:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354882; cv=none; b=BJozsJhZMZ9j8kb2gc3r5imv6eWj7pe9mt6N6CTR2RmJ01g7jch1o/41hbUmAl+vP5h8u2Q4MYs0AxXdLC+TFIUtWgorktfYtXIVqGbAtBUly58RGwLrarR3ptAuUWPWZdODlQGWi0WegC6cfTDKps5LYtdT7efnabQ/IvIqqwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354882; c=relaxed/simple;
	bh=IlKqDMY7UI31FEbCsuUUSq9JLbbmDqdfrksKPsiVLlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T81GRnP3JfEcJivDY3Gqz2fMVoX1axAWKMmrpE6WFZjyR3hpIYmMnh5TC4qjnpZAxle1atmJeTFiQFBAO/uYb5hzZsxFy599bLeHNPlGwMlgzvlJ/3CxAJuwkjBSh9EhSa6hNJiVh0azdRngoo4u5AbRAZhXa+iDiPRuz5xWNRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/iyUixx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/iyUixx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAFA2C32782;
	Tue, 30 Jul 2024 15:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354882;
	bh=IlKqDMY7UI31FEbCsuUUSq9JLbbmDqdfrksKPsiVLlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/iyUixxdanKgvQYeRTEgrvXkTCzrKjaC/eGK5eemuarCtcw8J4xgwO3Nh/3zxXL4
	 0uw2Qcx2HTTPmM5KUD+EaYfhdskpDRq3CHApYauFTQmJfu2jgSGX9UbkpEI9LkJj9b
	 2dUNDdvOmk3BJgJ4OwLiwP7S43yN73gGf4H+AGmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 031/440] arm64: dts: qcom: sdm845: add power-domain to UFS PHY
Date: Tue, 30 Jul 2024 17:44:24 +0200
Message-ID: <20240730151616.981517482@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit fd39ae8b9bc10419b1e4b849cdbc6755a967ade1 ]

The UFS PHY is powered on via the UFS_PHY_GDSC power domain. Add
corresponding power-domain the the PHY node.

Fixes: cc16687fbd74 ("arm64: dts: qcom: sdm845: add UFS controller")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240501-qcom-phy-fixes-v1-6-f1fd15c33fb3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index 95c515da9f2e0..71644b9b8866a 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -2537,6 +2537,8 @@ ufs_mem_phy: phy@1d87000 {
 			clocks = <&gcc GCC_UFS_MEM_CLKREF_CLK>,
 				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>;
 
+			power-domains = <&gcc UFS_PHY_GDSC>;
+
 			resets = <&ufs_mem_hc 0>;
 			reset-names = "ufsphy";
 			status = "disabled";
-- 
2.43.0



