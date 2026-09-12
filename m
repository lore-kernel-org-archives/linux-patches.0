Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5131369224;
	Sat, 12 Sep 2026 08:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200499; cv=none; b=KhSLNz8wROdycShMt1PMA82h/WGGbFmL4GjQ+mFULFixHni+bodEo5wF4z6qjR3ycCnTiEzFup+qRsbtVCDRSvOFGiomIKFRGEPWp3/jYxYo8NSgqLldGr9t+M5E6aTgO5q32Mxh0+n/bb000q5co4vIlPkk3USfVObWdSbFIDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200499; c=relaxed/simple;
	bh=CF+S9Yd7SCdRFPY/zHi0I0Z2iWCUmwZnldo3FzpYcvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ev7dGbOjx93hl+Nb5W7eE5CO51mKW/AL2NObv/pK9pcJ5HHXGEKKJPNtVzGbAisc8YLfLHq3ijXvuKhYX18KngrHV7ceneD3171HGD29TFv82IpHm6Efns9zB0BKWA6/36+4TlnGbfzBcz2qh7zH4xidSlFI3LoT/wVgF10KfHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7msC8mT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7msC8mT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5DC01F000FF;
	Sat, 12 Sep 2026 08:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200497;
	bh=+tUIjQOUZmzFS/ihDCqzilohiDcUbwLDSKOdPkQzHGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e7msC8mTwjyS/j61nmIrf126gvjUgTs/3py7j+YF2N3YJ1PR07LHNy6g+dqZtypVa
	 pkAj8TnQ8sgaDNxfx0JDZFtP29toWpTj66K29qsEgCLcWEbcqCHL1/bpcUHc+du8Yb
	 PWZJnidN5jlO8u6Lb5xIAkAPujwhv4xcwBi4DYc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0802/1815] arm64: dts: qcom: sm8250: Fix the PCIe iommu-map entries
Date: Sat, 12 Sep 2026 08:42:32 +0200
Message-ID: <20260912065707.739496158@linuxfoundation.org>
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
index f6044bfaef876..ab461b5883c73 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -2190,8 +2190,8 @@ pcie0: pcie@1c00000 {
 				      "tbu",
 				      "ddrss_sf_tbu";
 
-			iommu-map = <0x0   &apps_smmu 0x1c00 0x1>,
-				    <0x100 &apps_smmu 0x1c01 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c00 0x0 0x1>,
+				    <0x100 &apps_smmu 0x1c01 0x0 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -2317,8 +2317,8 @@ pcie1: pcie@1c08000 {
 			assigned-clocks = <&gcc GCC_PCIE_1_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommu-map = <0x0   &apps_smmu 0x1c80 0x1>,
-				    <0x100 &apps_smmu 0x1c81 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c80 0x0 0x1>,
+				    <0x100 &apps_smmu 0x1c81 0x0 0x1>;
 
 			resets = <&gcc GCC_PCIE_1_BCR>;
 			reset-names = "pci";
@@ -2444,8 +2444,8 @@ pcie2: pcie@1c10000 {
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



