Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2B347AF5F;
	Sat, 12 Sep 2026 12:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216596; cv=none; b=u50Gf/mU6U7uAa/jjqo6bISm9fghtPGTqtP56jSxluyUPaljUqwjVOPxm74O1r/aHICCDX6hEXa/fRHQ6YR7HoMFKHTWsRDS6DhL4+iUSW5Nb7UAO+2ajjmoxcXfOnqrrqYcrqadGrVkJGHTR0G5cs9B5Og6b95S4AfzzVEVVMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216596; c=relaxed/simple;
	bh=F3BwkcUx0bX1Isv0wE4LN3uQIJTOTLjntc7M415KCOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ovQDwl+V1yFbtnNbxXUtvY+E+7JOUBNneEJwfnHnAHshr2ZJj6Dy8zczrkUhes345Xzoip19YXUmA8j1Agzm6OTnT88BVOEDUFLjgdmsxgWoV+89A7y7yyzWGBLxiN7Cjfodo/FG4aB6I5xzaVzc0HFpvl6Q9ZYkOzmxcVDKfqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QGYj0J0m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QGYj0J0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1691B1F000FF;
	Sat, 12 Sep 2026 12:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216594;
	bh=9FQgo7l1xUMEPl7ZyvzfBt+M33kTIrjQu1DfWHb4Suw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QGYj0J0mScNKPzSmtJEUp2Ca+IIX4P7rdXxy+sDTnC62ZWgpY5/fgzORXCHDWdh1W
	 m2X3w9YPNHP/hHCqsD2waNrk9TRYpui9gEpvkb/SoseYeN6+gLCI3PoDbwQCUmB1r6
	 DoFbXZ3y+DDcm89gRP4zVB3av5MqaSNKJdcuFrFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0768/1376] arm64: dts: qcom: sm8150: Fix the PCIe iommu-map entries
Date: Sat, 12 Sep 2026 08:53:14 +0200
Message-ID: <20260912065624.656895228@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit d2e56fb42e3d10d7e711063cdc00523ddb31d544 ]

The IOMMU provider apps_smmu uses '#iommu-cells = <2>', but the PCIe
iommu-map entries specify only one cell for the SID, omitting the SID
mask. This went unnoticed until the OF core started warning with commit
ccb2fd725d41 ("of: Respect #{iommu,msi}-cells in maps"):

  iommu-map has 1-cell entries targeting 2-cell #iommu-cells, treating as 1-cell output

So fix the entries to match the provider's '#iommu-cells' property.

Fixes: a1c86c680533 ("arm64: dts: qcom: sm8150: Add PCIe nodes")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260730-iommu-map-fix-v1-6-83405d37ba41@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8150.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index 0aeceffd872c0..e06f7782b551c 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -1885,8 +1885,8 @@ pcie0: pcie@1c00000 {
 				      "tbu",
 				      "ref";
 
-			iommu-map = <0x0   &apps_smmu 0x1d80 0x1>,
-				    <0x100 &apps_smmu 0x1d81 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1d80 0x0 0x1>,
+				    <0x100 &apps_smmu 0x1d81 0x0 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -2005,8 +2005,8 @@ pcie1: pcie@1c08000 {
 			assigned-clocks = <&gcc GCC_PCIE_1_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommu-map = <0x0   &apps_smmu 0x1e00 0x1>,
-				    <0x100 &apps_smmu 0x1e01 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1e00 0x0 0x1>,
+				    <0x100 &apps_smmu 0x1e01 0x0 0x1>;
 
 			resets = <&gcc GCC_PCIE_1_BCR>;
 			reset-names = "pci";
-- 
2.53.0



