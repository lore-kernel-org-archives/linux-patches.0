Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627D934E75A;
	Sat, 12 Sep 2026 12:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216601; cv=none; b=mALgu7NBkevJaclo1JUBGesuzt34PwOg+GsBrDK/V5V9qYgSXYSRXrzDWpA9Mg4/mJkAvGyfRhr048JXL7aCyfPOhWnhrh3sN0jkt9f5Y7wG1X2Ne5QgnWWyLDQpnHA5/zZsl+CR9UXRBPPgNyZ+Vyf+mNDju0ZEc6HcmLioMe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216601; c=relaxed/simple;
	bh=nFyy9YfcghnlQbvME0waOEVY6pRtNMALxTz073O4lsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gSv2b//h1fu+nbCU1WipmK4iG0Qj2N2byqbo9S9L/6GNIQi+45Gq/MQ4Pb331dOJ0u7Adry989auz8yhp/qtFHkqPEE+ZBbvmTW8yofVycK15ej4rv7fZvrOeLsGgvqhPNYbXbOW0yzB8Bfee8mkhKvR8Hq9WGvoVioi/LR9mbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MNTOCO/q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MNTOCO/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 498D21F000FF;
	Sat, 12 Sep 2026 12:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216599;
	bh=fpo1+ppVUDRN/vg9o8SK3yYsgkGWNQN9o/oy8xC+vsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MNTOCO/qslT0Sv+Rf12qLlbFXV7eLYjZHNXfWaspYCJBNJA11ubJKvk4HDDKJFmy+
	 g5LV5MpbMs3m0xEJHLZ1pGSjtG4OXOh+0ARzjz+Vbvha8REwlPPPY0TcXi4RxtAuDt
	 uJT/Z96mhTnOuHgjXm43vmF6BOJwqcWgxT+sbgyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0769/1376] arm64: dts: qcom: sm8250: Fix the PCIe iommu-map entries
Date: Sat, 12 Sep 2026 08:53:15 +0200
Message-ID: <20260912065624.678494639@linuxfoundation.org>
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

[ Upstream commit c41749e9554d4e03e7074f5d1e46140bc4ac77bd ]

The IOMMU provider apps_smmu uses '#iommu-cells = <2>', but the PCIe
iommu-map entries specify only one cell for the SID, omitting the SID
mask. This went unnoticed until the OF core started warning with commit
ccb2fd725d41 ("of: Respect #{iommu,msi}-cells in maps"):

  iommu-map has 1-cell entries targeting 2-cell #iommu-cells, treating as 1-cell output

So fix the entries to match the provider's '#iommu-cells' property.

Fixes: e53bdfc00977 ("arm64: dts: qcom: sm8250: Add PCIe support")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260730-iommu-map-fix-v1-7-83405d37ba41@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index d6607c38eb35c..f1851cbcd48b9 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -2187,8 +2187,8 @@ pcie0: pcie@1c00000 {
 				      "tbu",
 				      "ddrss_sf_tbu";
 
-			iommu-map = <0x0   &apps_smmu 0x1c00 0x1>,
-				    <0x100 &apps_smmu 0x1c01 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c00 0x0 0x1>,
+				    <0x100 &apps_smmu 0x1c01 0x0 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -2312,8 +2312,8 @@ pcie1: pcie@1c08000 {
 			assigned-clocks = <&gcc GCC_PCIE_1_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommu-map = <0x0   &apps_smmu 0x1c80 0x1>,
-				    <0x100 &apps_smmu 0x1c81 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c80 0x0 0x1>,
+				    <0x100 &apps_smmu 0x1c81 0x0 0x1>;
 
 			resets = <&gcc GCC_PCIE_1_BCR>;
 			reset-names = "pci";
@@ -2437,8 +2437,8 @@ pcie2: pcie@1c10000 {
 			assigned-clocks = <&gcc GCC_PCIE_2_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommu-map = <0x0   &apps_smmu 0x1d00 0x1>,
-				    <0x100 &apps_smmu 0x1d01 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1d00 0x0 0x1>,
+				    <0x100 &apps_smmu 0x1d01 0x0 0x1>;
 
 			resets = <&gcc GCC_PCIE_2_BCR>;
 			reset-names = "pci";
-- 
2.53.0



