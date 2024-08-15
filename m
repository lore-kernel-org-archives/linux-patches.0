Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1F41A08C6;
	Thu, 15 Aug 2024 14:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731959; cv=none; b=kGHP57kQ/S+LDDoevh+hQw1/fxtuq9jcO2t/0UsTX5V97L/m2fiSisu/zaAHiHFXZqrnaJpqmWnpCJkpD6wUy6PIT3b+/4RH4A7aurNEACGgh0+R28xXeOcGhAMM4/YCfWiI8ndsEqsSCCxtY7x6GUg0S9Mdnih3gwfK3RfVqLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731959; c=relaxed/simple;
	bh=2ZBIrbi8VL/XriuFx+Q31pWVNanIoxTo0l1pNSuDRlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUevjPCTBnUmwj3mOx1L213Vh+uewSxBNi13y9RZmW4TPsQn7qEXtIzEG608AfdYccXPtmr92JLxLxXyHFBS4iYB2FTjqlm3Y2ZH4hasHRV204BrWPgsmUQCHi24+JPgbPwdy77Ox85XKtZu+lnOTmazpSSRkknizpNnEbX8ks0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yZXS9UzC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZXS9UzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F65C32786;
	Thu, 15 Aug 2024 14:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731959;
	bh=2ZBIrbi8VL/XriuFx+Q31pWVNanIoxTo0l1pNSuDRlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yZXS9UzC4J+Zrm25ax4Sui9UsvmjsRjfHibMjrcSlpakZJRby2v4w4UG7RA8jlqM+
	 DTp0VEXnseoZtuVrWmNTRKpI+j4B24ZUhiMqQFwZYdgLz+3N36vmIa0UJT7xf8i72j
	 PZCBWtavdSnasCNu8cQoqLMuUTSdiE35Q/qhIORE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/352] arm64: dts: qcom: sdm845: add power-domain to UFS PHY
Date: Thu, 15 Aug 2024 15:21:19 +0200
Message-ID: <20240815131919.723434930@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b00f6d8bc8bac..da48ae60155af 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -2125,6 +2125,8 @@ ufs_mem_phy: phy@1d87000 {
 			clocks = <&gcc GCC_UFS_MEM_CLKREF_CLK>,
 				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>;
 
+			power-domains = <&gcc UFS_PHY_GDSC>;
+
 			resets = <&ufs_mem_hc 0>;
 			reset-names = "ufsphy";
 			status = "disabled";
-- 
2.43.0



