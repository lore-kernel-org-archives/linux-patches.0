Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBE13019D8;
	Sat, 12 Sep 2026 14:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224223; cv=none; b=I3kDoSm454yVdMmswPR56ySVrnB1w0tzAMSYahRsgMhNxFZu7bpAuJoC3dC8yAdg5hspJLoMNDdwB5m+KyxBtuZul3UxUYsN12iSLLHE7qyyZdqvdslfZ6RMnGQoYV9xCDgKjDCNrqr+VHGstsq7j3HvviaNhstp/8s+sCs5n1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224223; c=relaxed/simple;
	bh=bRpdHx3e8ezXLfIh/WJnTJ/5whoTIK5Z6Eo9phFm6jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B35fmm7k9f+gA4clLkTi58zVoKHrLq31mlqn2fffYGJiHQRzK8AhSrZ5H8uIuBWEEvRZusSHSf5Ltj2/AnPUq4qDD3k+7cs37hbCd5QWea7S9ElPwtTXXA4/xPhZiz6IDjtjNYu9UYd6rybbQm1DRlY0Qot4UdlZcyt8zMVsnzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tYrD8Ke9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tYrD8Ke9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372451F000FF;
	Sat, 12 Sep 2026 14:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224222;
	bh=NqnZQgGagQm4MqXqNsXfCevXG5UUNUxUjoeH8o9WP8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tYrD8Ke9lhrHu1k/t43byjRmIL2U5VTijucYKGLfQ92KJHXuS7VvKlMVeAqqkJWHM
	 fhyZxo+4HoWB7cyRrQRfC6bQ6YEcuqEUWqhmX33K8ONpFwIbULRJRJ8p4qZZFM3Xsw
	 woursHfpBnPAdyDkMvVlLJjimLF8+bWGzwopo9cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0947/1424] arm64: dts: qcom: sdm845: Fix the PCIe iommu-map entries
Date: Sat, 12 Sep 2026 08:56:19 +0200
Message-ID: <20260912065628.525003859@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit deaea7e982bc353c8d3c406774970f16ed901adb ]

The IOMMU provider apps_smmu uses '#iommu-cells = <2>', but the PCIe
iommu-map entries specify only one cell for the SID, omitting the SID
mask. This went unnoticed until the OF core started warning with commit
ccb2fd725d41 ("of: Respect #{iommu,msi}-cells in maps"):

  iommu-map has 1-cell entries targeting 2-cell #iommu-cells, treating as 1-cell output

So fix the entries to match the provider's '#iommu-cells' property.

Fixes: 5c538e09cb19 ("arm64: dts: qcom: sdm845: Add first PCIe controller and PHY")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260730-iommu-map-fix-v1-5-83405d37ba41@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 64 ++++++++++++++--------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index fa91e2036dd56..0bcaeba8dafa4 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -2349,22 +2349,22 @@ pcie0: pci@1c00000 {
 				      "slave_q2a",
 				      "tbu";
 
-			iommu-map = <0x0   &apps_smmu 0x1c10 0x1>,
-				    <0x100 &apps_smmu 0x1c11 0x1>,
-				    <0x200 &apps_smmu 0x1c12 0x1>,
-				    <0x300 &apps_smmu 0x1c13 0x1>,
-				    <0x400 &apps_smmu 0x1c14 0x1>,
-				    <0x500 &apps_smmu 0x1c15 0x1>,
-				    <0x600 &apps_smmu 0x1c16 0x1>,
-				    <0x700 &apps_smmu 0x1c17 0x1>,
-				    <0x800 &apps_smmu 0x1c18 0x1>,
-				    <0x900 &apps_smmu 0x1c19 0x1>,
-				    <0xa00 &apps_smmu 0x1c1a 0x1>,
-				    <0xb00 &apps_smmu 0x1c1b 0x1>,
-				    <0xc00 &apps_smmu 0x1c1c 0x1>,
-				    <0xd00 &apps_smmu 0x1c1d 0x1>,
-				    <0xe00 &apps_smmu 0x1c1e 0x1>,
-				    <0xf00 &apps_smmu 0x1c1f 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c10 0x0 0x1>,
+				    <0x100 &apps_smmu 0x1c11 0x0 0x1>,
+				    <0x200 &apps_smmu 0x1c12 0x0 0x1>,
+				    <0x300 &apps_smmu 0x1c13 0x0 0x1>,
+				    <0x400 &apps_smmu 0x1c14 0x0 0x1>,
+				    <0x500 &apps_smmu 0x1c15 0x0 0x1>,
+				    <0x600 &apps_smmu 0x1c16 0x0 0x1>,
+				    <0x700 &apps_smmu 0x1c17 0x0 0x1>,
+				    <0x800 &apps_smmu 0x1c18 0x0 0x1>,
+				    <0x900 &apps_smmu 0x1c19 0x0 0x1>,
+				    <0xa00 &apps_smmu 0x1c1a 0x0 0x1>,
+				    <0xb00 &apps_smmu 0x1c1b 0x0 0x1>,
+				    <0xc00 &apps_smmu 0x1c1c 0x0 0x1>,
+				    <0xd00 &apps_smmu 0x1c1d 0x0 0x1>,
+				    <0xe00 &apps_smmu 0x1c1e 0x0 0x1>,
+				    <0xf00 &apps_smmu 0x1c1f 0x0 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -2459,22 +2459,22 @@ pcie1: pci@1c08000 {
 			assigned-clocks = <&gcc GCC_PCIE_1_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommu-map = <0x0   &apps_smmu 0x1c00 0x1>,
-				    <0x100 &apps_smmu 0x1c01 0x1>,
-				    <0x200 &apps_smmu 0x1c02 0x1>,
-				    <0x300 &apps_smmu 0x1c03 0x1>,
-				    <0x400 &apps_smmu 0x1c04 0x1>,
-				    <0x500 &apps_smmu 0x1c05 0x1>,
-				    <0x600 &apps_smmu 0x1c06 0x1>,
-				    <0x700 &apps_smmu 0x1c07 0x1>,
-				    <0x800 &apps_smmu 0x1c08 0x1>,
-				    <0x900 &apps_smmu 0x1c09 0x1>,
-				    <0xa00 &apps_smmu 0x1c0a 0x1>,
-				    <0xb00 &apps_smmu 0x1c0b 0x1>,
-				    <0xc00 &apps_smmu 0x1c0c 0x1>,
-				    <0xd00 &apps_smmu 0x1c0d 0x1>,
-				    <0xe00 &apps_smmu 0x1c0e 0x1>,
-				    <0xf00 &apps_smmu 0x1c0f 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c00 0x0 0x1>,
+				    <0x100 &apps_smmu 0x1c01 0x0 0x1>,
+				    <0x200 &apps_smmu 0x1c02 0x0 0x1>,
+				    <0x300 &apps_smmu 0x1c03 0x0 0x1>,
+				    <0x400 &apps_smmu 0x1c04 0x0 0x1>,
+				    <0x500 &apps_smmu 0x1c05 0x0 0x1>,
+				    <0x600 &apps_smmu 0x1c06 0x0 0x1>,
+				    <0x700 &apps_smmu 0x1c07 0x0 0x1>,
+				    <0x800 &apps_smmu 0x1c08 0x0 0x1>,
+				    <0x900 &apps_smmu 0x1c09 0x0 0x1>,
+				    <0xa00 &apps_smmu 0x1c0a 0x0 0x1>,
+				    <0xb00 &apps_smmu 0x1c0b 0x0 0x1>,
+				    <0xc00 &apps_smmu 0x1c0c 0x0 0x1>,
+				    <0xd00 &apps_smmu 0x1c0d 0x0 0x1>,
+				    <0xe00 &apps_smmu 0x1c0e 0x0 0x1>,
+				    <0xf00 &apps_smmu 0x1c0f 0x0 0x1>;
 
 			resets = <&gcc GCC_PCIE_1_BCR>;
 			reset-names = "pci";
-- 
2.53.0



