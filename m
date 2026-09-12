Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A4B1DC198;
	Sat, 12 Sep 2026 08:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200494; cv=none; b=UYPLPmtd1U4dYP43W6q31lQpHwXhR/VNk/ji2l6TUdYFxjMQ7DKeg135TXp7jNEr7io+AF+jpf6nHtPI4n93QHDMMTvDfTxM+xhZSbtrn3YtyHeaz/pCpdPmOD4MjDdaEn/kQArFBpCtBLwN0YMvexzru6RnRw8zY01ZypG1Mfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200494; c=relaxed/simple;
	bh=mFXPeFLo27m6ZUDFXnDyFmR9pZxzgC03TPwxogzUZMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UvSRyIh5Vhi3KNj9LrlGAFZYPSiB7CMFMoNlxsMB2mlVIYEA/4bQHIxpYL2HLYWxw/CwW9sA9SKukQHYmJ6NDzUM1kdTfALFXOin8yj8mZt/VT1wGKZFkyUWQi1BpcYXjPdpvz2mLeujR5OLo85vaUWlyROFLKbt+QffGopzgy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CydNMuap; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CydNMuap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA081F000FF;
	Sat, 12 Sep 2026 08:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200492;
	bh=kZtBykkQyLcvbY7LMRgMSJwyGijPVv3FjKSb/oMxdYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CydNMuapVEfRA9wzf40AMrBMA4gPk4+o0sEqEHs3RV+gq4+v8KbnHffa/eqM2AX3X
	 oYjatCk0j0FLfZZ+CTMBjSdlwPEojHFz560khVKP415X6fhpv4L1xoVC4DEPu9fZ17
	 6MrWu5fC80CtjjJTZaSVA2eFTsnN21djuudVJCFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0801/1815] arm64: dts: qcom: sm8150: Fix the PCIe iommu-map entries
Date: Sat, 12 Sep 2026 08:42:31 +0200
Message-ID: <20260912065707.716761774@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 0e101096209ab..109a76f4ca75f 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -1893,8 +1893,8 @@ pcie0: pcie@1c00000 {
 				      "bus_slave",
 				      "slave_q2a";
 
-			iommu-map = <0x0   &apps_smmu 0x1d80 0x1>,
-				    <0x100 &apps_smmu 0x1d81 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1d80 0x0 0x1>,
+				    <0x100 &apps_smmu 0x1d81 0x0 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -2011,8 +2011,8 @@ pcie1: pcie@1c08000 {
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



