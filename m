Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A6D1BA878;
	Tue, 30 Jul 2024 15:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355150; cv=none; b=S+14DIOKIKte4LQgD2ZK0wJguZY2jHRUYBnX/ShrRTzewlM94kVXxuOkVLaXmDSr91JSiKenhr/CmPtXY8JTl6olTNjYW4Ju+NIGIxnOIUswNDycMgNYrhAToOuAKR+OfIKgk7TNPlmI72QrKFN2GdAzpdQ9UrL4uAzDB4MWZUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355150; c=relaxed/simple;
	bh=UMDz401NiNfX90VOc0T2A69uehnpk6x/rBJom5Y5G3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=orFxCS4F8fNKf9/ewgDk7v63Wq0RPyLXph9WBErnK/TYTh6VY1kmZXL9jWXfEnT5Rkcn6aYCyJqguVDDxv26aIpt7vrCp8Rwf1r5llvFpb4ltN1jy/MroinEUigXZh07WhQg+HwLftF/mRY3bC2yZ/FMMto7FMArKMBmUbk2mfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xgrv57PN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xgrv57PN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99DEC32782;
	Tue, 30 Jul 2024 15:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355150;
	bh=UMDz401NiNfX90VOc0T2A69uehnpk6x/rBJom5Y5G3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xgrv57PNGZx0bLahpVpD8etAxnq9RNMtaQN2qRe9MBatZo2yaFX5usLNEtKaNmJg/
	 Wz7XUAGvFwVipnPFBlqJszL660q8KOwp3J8t2CYP+jen6kfjr0NAumktfWNzek7eUv
	 cFEII32a/5B2Iy8nCyvC+Gv/JNe0Jj79i/iadJDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 032/568] arm64: dts: qcom: sm6115: add power-domain to UFS PHY
Date: Tue, 30 Jul 2024 17:42:19 +0200
Message-ID: <20240730151641.094084875@linuxfoundation.org>
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

[ Upstream commit a9eb454873a813ddc4578e5c3b37778de6fda472 ]

The UFS PHY is powered on via the UFS_PHY_GDSC power domain. Add
corresponding power-domain the the PHY node.

Fixes: 97e563bf5ba1 ("arm64: dts: qcom: sm6115: Add basic soc dtsi")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240501-qcom-phy-fixes-v1-7-f1fd15c33fb3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6115.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm6115.dtsi b/arch/arm64/boot/dts/qcom/sm6115.dtsi
index 87cbc4e8b1ed5..821db9b851855 100644
--- a/arch/arm64/boot/dts/qcom/sm6115.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6115.dtsi
@@ -1043,6 +1043,8 @@ ufs_mem_phy: phy@4807000 {
 			clocks = <&gcc GCC_UFS_CLKREF_CLK>, <&gcc GCC_UFS_PHY_PHY_AUX_CLK>;
 			clock-names = "ref", "ref_aux";
 
+			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
+
 			resets = <&ufs_mem_hc 0>;
 			reset-names = "ufsphy";
 			status = "disabled";
-- 
2.43.0



