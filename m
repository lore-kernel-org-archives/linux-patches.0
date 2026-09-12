Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F59B38DC59;
	Sat, 12 Sep 2026 10:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208878; cv=none; b=pwn9iEC+iYrDld1eRVYHAzZ5+RY9ZyHtX2WnBGlHojamvAIShcwgvtm0oBVVnYmoKhxs31ZHwxsNYWa3rkpD1Hl+53ZLBSShCDPGPyLGV9kykihs2L8UtwrVx6gHm6wGgqC2pAbabfcjEGUfxYlHM0P01tETYWNDUhJJIdYwt0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208878; c=relaxed/simple;
	bh=tHv/6YGkruseNlWxvFIVtCPdECoMm1pkOAxLVXvhPu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tzBjItzCX4emMz7SHBP+WBYiNViUFHGzPCeAv2S/dlRhZbu3ifl9JLNNBhM6diY6EpNfQo4E+wnTqbTy5X8HXVFucLCJbuyV7lE0Xmi4fFyQEAPzVZe0e1NiqQvgHAG4Y9dCJpgjiGf6GePweCrZl+eCwANyVM/jVMSd/j3BZWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I5tsUI5T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I5tsUI5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 757181F000FF;
	Sat, 12 Sep 2026 10:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208877;
	bh=MUBu2AWBvBmVcaE7rdRBGgakdXqO9keUHlQKSiYEm4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I5tsUI5TAVUiuk0stjSbTeRww46Qz8vlzpDH1HD7Cz5dEMgXO45BeLn/oznZ2DMk/
	 J3EGK+YZSiYy2u6xrgtKmYKdc1sbRdsypshQ0Y8QGUNZ2+3CmUsXyhTMmUHSkPhPSy
	 RjkvLuxnk5qICOJFL/ASrbtsVvJtPhNWA+wDZc9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0690/1518] arm64: dts: qcom: sm8550: Fix the PCIe iommu-map entries
Date: Sat, 12 Sep 2026 08:47:39 +0200
Message-ID: <20260912065639.048286147@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit 16d98ee918d63018eaa6cc260791b71319aa4faa ]

The IOMMU provider apps_smmu uses '#iommu-cells = <2>', but the PCIe
iommu-map entries specify only one cell for the SID, omitting the SID
mask. This went unnoticed until the OF core started warning with commit
ccb2fd725d41 ("of: Respect #{iommu,msi}-cells in maps"):

  iommu-map has 1-cell entries targeting 2-cell #iommu-cells, treating as 1-cell output

So fix the entries to match the provider's '#iommu-cells' property.

Fixes: 7d1158c984d3 ("arm64: dts: qcom: sm8550: Add PCIe PHYs and controllers nodes")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260730-iommu-map-fix-v1-10-83405d37ba41@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index 479c94f5066f3..e38d3ea19e7dd 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -2009,8 +2009,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 
 			msi-map = <0x0 &gic_its 0x1400 0x1>,
 				  <0x100 &gic_its 0x1401 0x1>;
-			iommu-map = <0x0   &apps_smmu 0x1400 0x1>,
-				    <0x100 &apps_smmu 0x1401 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1400 0x0 0x1>,
+				    <0x100 &apps_smmu 0x1401 0x0 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -2175,8 +2175,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 
 			msi-map = <0x0 &gic_its 0x1480 0x1>,
 				  <0x100 &gic_its 0x1481 0x1>;
-			iommu-map = <0x0   &apps_smmu 0x1480 0x1>,
-				    <0x100 &apps_smmu 0x1481 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1480 0x0 0x1>,
+				    <0x100 &apps_smmu 0x1481 0x0 0x1>;
 
 			resets = <&gcc GCC_PCIE_1_BCR>,
 				<&gcc GCC_PCIE_1_LINK_DOWN_BCR>;
-- 
2.53.0



