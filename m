Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDE73644CA;
	Sat, 12 Sep 2026 08:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200484; cv=none; b=jM06y4fwFftRUdP4VOfnQHqCHdFTFtLd630tv3ef6f/GQr9Fqu1r5LWqEAGPOT/EPN1aHxLuBSJnbizNZgJOUI4Ywn50YcWsrUsi1eW5lXyPeKanUlRDdws47HVcjjrnnif9PkE8FI8T4a9FuIxDb+8KLktwfXW6SB/tT45PllI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200484; c=relaxed/simple;
	bh=590GFyQPcESrLf2K23XWFuLcs8fN0UC64tVZ4h1SlkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ifty2+IUXhMsKH9iFVeriVxh3dMw12C2h7khsUXcdRwZhuUA9FVgzxV7DbatAOXBms+ELUQ9NtuFQKAO97E5mrRWNNjCF56hzjpWM9A5O+0vhijw7G8SaASuNIeam14Vieez0H4C4CvtgibO4J64rnUhNMdl8xbYBkHPaNwgaZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C4V45dFr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C4V45dFr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5A81F00893;
	Sat, 12 Sep 2026 08:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200483;
	bh=rk+eeG5MhgxG8g3YXQYaTF8hCypninxEJO/2FMw8CmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C4V45dFrv3keD0BwqIROcARoQ3HIT1HO4twzEapKKKeSP90RdE7hQa7kenZKPBeCQ
	 EYY9LYU8BOOLh0Me4BSCp3ueFDJFpv1Sq/d0ntymQKG6YKx4u25I+9beavM86N9zuT
	 ShBM1Bbc7JjVlq9etG+bfOfYZiOOCrTJdjSiKDNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0799/1815] arm64: dts: qcom: sc8180x: Fix the PCIe iommu-map entries
Date: Sat, 12 Sep 2026 08:42:29 +0200
Message-ID: <20260912065707.669071512@linuxfoundation.org>
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
index 45391768e2458..5d3f0c4d7b464 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
@@ -1767,8 +1767,8 @@ pcie0: pcie@1c00000 {
 			assigned-clocks = <&gcc GCC_PCIE_0_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommu-map = <0x0   &apps_smmu 0x1d80 0x1>,
-				    <0x100 &apps_smmu 0x1d81 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1d80 0x0 0x1>,
+				    <0x100 &apps_smmu 0x1d81 0x0 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -1886,8 +1886,8 @@ pcie3: pcie@1c08000 {
 			assigned-clocks = <&gcc GCC_PCIE_3_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommu-map = <0x0   &apps_smmu 0x1e00 0x1>,
-				    <0x100 &apps_smmu 0x1e01 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1e00 0x0 0x1>,
+				    <0x100 &apps_smmu 0x1e01 0x0 0x1>;
 
 			resets = <&gcc GCC_PCIE_3_BCR>;
 			reset-names = "pci";
@@ -2006,8 +2006,8 @@ pcie1: pcie@1c10000 {
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



