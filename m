Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9357328B517;
	Sat, 12 Sep 2026 08:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200474; cv=none; b=fMcQx2L17L+zKEINCGewRJ8ruwTuM3O7Xv0nPBwk0NNvSq0/SrflkmBZ2ZgfRDXy4sLfyMhx1JDlD7AgRdClpEDEWIMdCey+gcEbe/iYWmyhcBRwTHOsz91kDKu6yKl0235EXOz95n48mZaeG8iYg330sluVNZd5PzXwib1Y/7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200474; c=relaxed/simple;
	bh=qJO7v9OuWa4hCME7gjA2+32eCv/i5CLDo8ibyAhX8zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4hUVhRVyVdM7LiL0+Pg6IfzZ7cSToVHHU0juXyagYUPbJ+x2xd7kTjPJKttc/QO72aQpck/RYEcXwGCi61ZEnxPS4RGvW/5hOxOEN6+Tjm2TZ3CnkI2Ne6W4fpuLdqFfU8pknusbZXmd/iY8Q8e+9fq07QgHGcDpoBI3CCj0J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vly6Va8t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vly6Va8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD8D1F000FF;
	Sat, 12 Sep 2026 08:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200473;
	bh=MVwDoiha0qCyxb4xz+JgfZOQQLj+z1xJB/JAiCmLVoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vly6Va8t+8MgjHQaa7Dt2Hp+o3bKmxr6IhfVAVxoKGGjar8li5fCq+2RKTv745iJY
	 IkYtU9qYlzeq+qvHtGuW146gOiNdLG3UYINfCQi0rLoBxXIIHXuPABRHAdmvWk66mK
	 FP8SM8Su4TolgpSWzlt2ysHkUkXJk0219le88ba0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0797/1815] arm64: dts: qcom: kodiak: Fix the PCIe iommu-map entries
Date: Sat, 12 Sep 2026 08:42:27 +0200
Message-ID: <20260912065707.620324215@linuxfoundation.org>
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

[ Upstream commit 52dac5bda29a3acd896fab2567605683d34970db ]

The IOMMU provider apps_smmu uses '#iommu-cells = <2>', but the PCIe
iommu-map entries specify only one cell for the SID, omitting the SID
mask. This went unnoticed until the OF core started warning with commit
ccb2fd725d41 ("of: Respect #{iommu,msi}-cells in maps"):

  iommu-map has 1-cell entries targeting 2-cell #iommu-cells, treating as 1-cell output

So fix the entries to match the provider's '#iommu-cells' property.

Fixes: f8328b7549e1 ("arm64: dts: qcom: sc7280: Describe the first PCIe controller and PHY")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260730-iommu-map-fix-v1-2-83405d37ba41@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/kodiak.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/kodiak.dtsi b/arch/arm64/boot/dts/qcom/kodiak.dtsi
index ba907760fa6d6..48639568f15e4 100644
--- a/arch/arm64/boot/dts/qcom/kodiak.dtsi
+++ b/arch/arm64/boot/dts/qcom/kodiak.dtsi
@@ -2281,8 +2281,8 @@ pcie0: pcie@1c00000 {
 				      "aggre0",
 				      "aggre1";
 
-			iommu-map = <0x0   &apps_smmu 0x1c00 0x1>,
-				    <0x100 &apps_smmu 0x1c01 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c00 0x0 0x1>,
+				    <0x100 &apps_smmu 0x1c01 0x0 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -2427,8 +2427,8 @@ pcie1: pcie@1c08000 {
 
 			dma-coherent;
 
-			iommu-map = <0x0 &apps_smmu 0x1c80 0x1>,
-				    <0x100 &apps_smmu 0x1c81 0x1>;
+			iommu-map = <0x0 &apps_smmu 0x1c80 0x0 0x1>,
+				    <0x100 &apps_smmu 0x1c81 0x0 0x1>;
 
 			status = "disabled";
 
-- 
2.53.0



