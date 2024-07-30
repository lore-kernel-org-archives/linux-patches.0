Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C78D19F467;
	Tue, 30 Jul 2024 15:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355195; cv=none; b=TR7AIncFwUiF1BTNcSx1lUCAaB97Fw7cu116gfa8Kh1bA+Pb1HU1mCwbOkRfe57qJHZu79VPF/z10CEveCIx9CvrT4eweFxVgm5JonkgLJlE4PZH42AxoqoHEnuRg/MS/XSd2hfdvscOIzEvZPIz1wCNgVTHpCTYzwFvoOYV8yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355195; c=relaxed/simple;
	bh=5LM1pqhRHLYUoOSUPb/BBg/xVmEWhvgDpDts8sZpyiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LzNTDXPp2muyXbqMuUHGnq/5HWLAyv16kYojEIuIfV/HuyURGikLYRPtmvT/rt+e9jOyD2iT/q6Cl/GpMC1SokKjmtE9sEcL5M4KFn73IC3Zyvg6rzZtCir7qKLDuupCRUibevaLZnFhnhVZy7HjOb9aycRxrgo64Dg+2d2rwXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QWGKZTAF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QWGKZTAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACBCC32782;
	Tue, 30 Jul 2024 15:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355195;
	bh=5LM1pqhRHLYUoOSUPb/BBg/xVmEWhvgDpDts8sZpyiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QWGKZTAF+mEptv4Oot91k+XuI+Al6KsFdSZNazfLSr1zjQerzue3PRyEpVWIl1ZTE
	 zIRXBywqlYd9Pit8ADcRsk3ZV/cOTuIZ7674/Zz3DHhqZ/WWNsTXuqcdnps+K4AWVC
	 8KlXiukEIymn8UvyJbyS2uS7uRCO1sjjrrgus8Kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/568] arm64: dts: qcom: sm8350: add power-domain to UFS PHY
Date: Tue, 30 Jul 2024 17:42:23 +0200
Message-ID: <20240730151641.249902438@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 634acc8cea1584b507801315831a330443f819b4 ]

The UFS PHY is powered on via the UFS_PHY_GDSC power domain. Add
corresponding power-domain the the PHY node.

Fixes: 59c7cf814783 ("arm64: dts: qcom: sm8350: Add UFS nodes")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240501-qcom-phy-fixes-v1-10-f1fd15c33fb3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index 5ed464c37422d..d4f1b36c7aebe 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -1731,6 +1731,8 @@ ufs_mem_phy: phy@1d87000 {
 			clocks = <&rpmhcc RPMH_CXO_CLK>,
 				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>;
 
+			power-domains = <&gcc UFS_PHY_GDSC>;
+
 			resets = <&ufs_mem_hc 0>;
 			reset-names = "ufsphy";
 			status = "disabled";
-- 
2.43.0



