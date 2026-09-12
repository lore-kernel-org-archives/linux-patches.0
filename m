Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD4547ACE6;
	Sat, 12 Sep 2026 12:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216586; cv=none; b=dClHamLfWTHEpbAsoD341CrT16XwpPFC4Eb1ESlNvpGRBe0kBF7QPKtjjX3fj/5F9hXFfDPEl8FCt/8JNmXlkM5hp8OPwzCi71+rH58CFDnxNzcl53rREEYfIZZBQ1fClWcUUuMmQKioVnwYN0vo0V3CZtHjbr+IApcOHKvQ63Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216586; c=relaxed/simple;
	bh=SEyKkpGRU6cl5/hs50GbQIHbK9BwvNXNwrsT1iXitVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbtKLAniGL8D5VxTNd4AxgM+68KoKtRZZaPRLwwzaP+Y++auFOuKwDs1oxw4zS5S1/M10n34qlwq3zJ8bd4Xh9PurxSd1Ky6dwItbusClgOHyQx6X6eJncO0b/bcx21OqWyR6X9e0zy5mYwFh8Vnx7RtaxeAMzx0q8rLlwSJeBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lK7HsiTw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lK7HsiTw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A3341F000FF;
	Sat, 12 Sep 2026 12:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216583;
	bh=nevToaIecOv5g4kuQU2lx24ihiPL7QWPgxB2p9y27/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lK7HsiTwlPLlAeizAkTpH5///ochIa1u4dBC1Lw6A62mVmLxK6Lm33J0j5OnVaoiT
	 UNowAJ9T8WiH1avED6lTPjupxV3a3JeXAsZRjAyBhhwdZ0+QcFkPTlYtawmV35Mzzh
	 qo3mRfWLgQQi9Iitig3Cw0fctubXV74yR+OP75GM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0766/1376] arm64: dts: qcom: sc8180x: Fix the PCIe iommu-map entries
Date: Sat, 12 Sep 2026 08:53:12 +0200
Message-ID: <20260912065624.612877788@linuxfoundation.org>
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

[ Upstream commit a4548204821a56c23cd711cfad2a637ca055ff47 ]

The IOMMU provider apps_smmu uses '#iommu-cells = <2>', but the PCIe
iommu-map entries specify only one cell for the SID, omitting the SID
mask. This went unnoticed until the OF core started warning with commit
ccb2fd725d41 ("of: Respect #{iommu,msi}-cells in maps"):

  iommu-map has 1-cell entries targeting 2-cell #iommu-cells, treating as 1-cell output

So fix the entries to match the provider's '#iommu-cells' property.

Fixes: d20b6c84f56a ("arm64: dts: qcom: sc8180x: Add PCIe instances")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260730-iommu-map-fix-v1-4-83405d37ba41@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8180x.dtsi | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8180x.dtsi b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
index 4715e26fc2647..d3aed296e32cc 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
@@ -1761,8 +1761,8 @@ pcie0: pcie@1c00000 {
 			assigned-clocks = <&gcc GCC_PCIE_0_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommu-map = <0x0   &apps_smmu 0x1d80 0x1>,
-				    <0x100 &apps_smmu 0x1d81 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1d80 0x0 0x1>,
+				    <0x100 &apps_smmu 0x1d81 0x0 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -1882,8 +1882,8 @@ pcie3: pcie@1c08000 {
 			assigned-clocks = <&gcc GCC_PCIE_3_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommu-map = <0x0   &apps_smmu 0x1e00 0x1>,
-				    <0x100 &apps_smmu 0x1e01 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1e00 0x0 0x1>,
+				    <0x100 &apps_smmu 0x1e01 0x0 0x1>;
 
 			resets = <&gcc GCC_PCIE_3_BCR>;
 			reset-names = "pci";
@@ -2004,8 +2004,8 @@ pcie1: pcie@1c10000 {
 			assigned-clocks = <&gcc GCC_PCIE_1_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommu-map = <0x0   &apps_smmu 0x1c80 0x1>,
-				    <0x100 &apps_smmu 0x1c81 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c80 0x0 0x1>,
+				    <0x100 &apps_smmu 0x1c81 0x0 0x1>;
 
 			resets = <&gcc GCC_PCIE_1_BCR>;
 			reset-names = "pci";
@@ -2126,8 +2126,8 @@ pcie2: pcie@1c18000 {
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



