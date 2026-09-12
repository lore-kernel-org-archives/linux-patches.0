Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DEB369990;
	Sat, 12 Sep 2026 08:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200572; cv=none; b=kqB260Hkc0+lQEdhC4hYF2wusI5DLLD5jMiZeVddeH5ZBqu4CZbgp7ZO9m3l+0mFvTyDEa3yJv1XkRJb4XReMlltZFRQ9BkeSlCxfNBszx9QrfMsCwfEbAl1ZAxmrjfafOPKZRhseqM0d00lXXGoT7fArLGUBDzlU42lGeD/BdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200572; c=relaxed/simple;
	bh=V7/JV90h6lVcFD8WIiWYzVRkqrstti43DlAOT62NtTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DY80yY3W39EytKEraPkN06KOzrAHwYJDr8NQiayPVmT0VaVgAIXrV/ggLR8t00Q1fLvpSagTZO3ZaMvjCNifi2xe+r9AInI6Uqkjsd2746ldcKQZIIU1JLHdUkh6UD8r82E9U5/4l+CJuqg5H2YA074S7RFgh6kdZvHG50qbdkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LYmlwJxi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LYmlwJxi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7881F000FF;
	Sat, 12 Sep 2026 08:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200570;
	bh=PdixBSILS/Mbb8ZvnwzfPWERXFdo0XOpWMYYonp6bbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LYmlwJxiP0DuU2za+vrJHb+nUQ+I/wpOhErppzCyAlt5EO170y4SBDdioG0mlAfLN
	 N/xBOvywYTUNbmsgA1WOymm8i44rPsCSZvO1V9+zE0H1yFVXZHLtb9+2KCugEgO4kj
	 K+0IqqhZFcHW+26S+KsJTRzJJKiTY14q2QeBxxI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0815/1815] arm64: dts: qcom: qcs6490-thundercomm-minipc-g1iot: Fix the PCIe iommu-map entries
Date: Sat, 12 Sep 2026 08:42:45 +0200
Message-ID: <20260912065708.046412199@linuxfoundation.org>
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

[ Upstream commit fc3c550b3847636f6c0732dc6c94e879ab5ff578 ]

The IOMMU provider apps_smmu uses '#iommu-cells = <2>', but the PCIe
iommu-map entries specify only one cell for the SID, omitting the SID
mask. This went unnoticed until the OF core started warning with commit
ccb2fd725d41 ("of: Respect #{iommu,msi}-cells in maps"):

  iommu-map has 1-cell entries targeting 2-cell #iommu-cells, treating as 1-cell output

So fix the entries to match the provider's '#iommu-cells' property.

Fixes: 1cde54c54b83 ("arm64: dts: qcom: qcs6490: Add Thundercomm AI Mini PC G1 IoT")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260730-iommu-map-fix-v1-20-83405d37ba41@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../qcom/qcs6490-thundercomm-minipc-g1iot.dts  | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/qcs6490-thundercomm-minipc-g1iot.dts b/arch/arm64/boot/dts/qcom/qcs6490-thundercomm-minipc-g1iot.dts
index a5ad796cb65d0..2fc8987204e9c 100644
--- a/arch/arm64/boot/dts/qcom/qcs6490-thundercomm-minipc-g1iot.dts
+++ b/arch/arm64/boot/dts/qcom/qcs6490-thundercomm-minipc-g1iot.dts
@@ -711,15 +711,15 @@ &pcie1 {
 		    <&pcie1_wake_n>;
 	pinctrl-names = "default";
 
-	iommu-map = <0x0 &apps_smmu 0x1c80 0x1>,
-		    <0x100 &apps_smmu 0x1c81 0x1>,
-		    <0x208 &apps_smmu 0x1c84 0x1>,
-		    <0x210 &apps_smmu 0x1c85 0x1>,
-		    <0x218 &apps_smmu 0x1c86 0x1>,
-		    <0x300 &apps_smmu 0x1c87 0x1>,
-		    <0x400 &apps_smmu 0x1c88 0x1>,
-		    <0x500 &apps_smmu 0x1c89 0x1>,
-		    <0x501 &apps_smmu 0x1c90 0x1>;
+	iommu-map = <0x0 &apps_smmu 0x1c80 0x0 0x1>,
+		    <0x100 &apps_smmu 0x1c81 0x0 0x1>,
+		    <0x208 &apps_smmu 0x1c84 0x0 0x1>,
+		    <0x210 &apps_smmu 0x1c85 0x0 0x1>,
+		    <0x218 &apps_smmu 0x1c86 0x0 0x1>,
+		    <0x300 &apps_smmu 0x1c87 0x0 0x1>,
+		    <0x400 &apps_smmu 0x1c88 0x0 0x1>,
+		    <0x500 &apps_smmu 0x1c89 0x0 0x1>,
+		    <0x501 &apps_smmu 0x1c90 0x0 0x1>;
 
 	status = "okay";
 };
-- 
2.53.0



