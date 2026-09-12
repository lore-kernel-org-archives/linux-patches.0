Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01E21DA62E;
	Sat, 12 Sep 2026 10:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208986; cv=none; b=hcp0vAdozodWcxT1dRu5JaxfY1mAGKUqKnQ/ZiE03HzLVmT6MJRVYm8oFXIYGlG5idnl97EcJLMxdYZFtZJyy22Tabogi82bOe5sC6xqTbXFkTTSL1hDJVtxAodolaqxlvShKlzA+/UaUaXjhzBCARUNLJDzoOuybe93N8MlUHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208986; c=relaxed/simple;
	bh=D8lThoFVqE9pXW50+oDB7pXx3y5cRyjiqIdYRGTz89k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KiSDbAeMH4lHRdTHIfUN2Ebm1HmoKxE5HUv0i1cD7Lj8Gka3EMgX5MvDtZUCPynWLHBW1obbP1auY8VS358glxfY+w8zBVBXJyjwBRR7Yljv0LpPUOBNYnyYkJAEi0roDV8a3bbB15nYygBRGXoDEVVekYXQGu6/hVGRuUtQJu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a0Roso1V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a0Roso1V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F421E1F00893;
	Sat, 12 Sep 2026 10:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208984;
	bh=aIryWvIi5iEDOjECLrSlgaEaatxMp9oAJVssRYotL2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a0Roso1VIPuLDKM3TvO3ZcVBQsqoY1tn7OKU2ZolTX1W+c5DXIZSBmPBNfNLO1AAR
	 09I9C1gTRV9hlFRlrzEtvCHXjYY9i/VAcDz5IhzmrP76fZUFn9xDAwv3FNoLo/yR1s
	 ju1Wtnqn/09diAHibdX69+AnMH/idQxNeOBYWaL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0692/1518] arm64: dts: qcom: sm8750: Fix the PCIe iommu-map entries
Date: Sat, 12 Sep 2026 08:47:41 +0200
Message-ID: <20260912065639.092672841@linuxfoundation.org>
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

[ Upstream commit 366a540432a38c1c1533a319bc07b333f53752b6 ]

The IOMMU provider apps_smmu uses '#iommu-cells = <2>', but the PCIe
iommu-map entries specify only one cell for the SID, omitting the SID
mask. This went unnoticed until the OF core started warning with commit
ccb2fd725d41 ("of: Respect #{iommu,msi}-cells in maps"):

  iommu-map has 1-cell entries targeting 2-cell #iommu-cells, treating as 1-cell output

So fix the entries to match the provider's '#iommu-cells' property.

Fixes: 19f1395333f8 ("arm64: dts: qcom: sm8750: Add PCIe PHY and controller node")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260730-iommu-map-fix-v1-12-83405d37ba41@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8750.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8750.dtsi b/arch/arm64/boot/dts/qcom/sm8750.dtsi
index b714207e4c158..c6f4a43ff133e 100644
--- a/arch/arm64/boot/dts/qcom/sm8750.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8750.dtsi
@@ -3393,8 +3393,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 			interconnect-names = "pcie-mem",
 					     "cpu-pcie";
 
-			iommu-map = <0x0   &apps_smmu 0x1400 0x1>,
-				    <0x100 &apps_smmu 0x1401 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1400 0x0 0x1>,
+				    <0x100 &apps_smmu 0x1401 0x0 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
-- 
2.53.0



