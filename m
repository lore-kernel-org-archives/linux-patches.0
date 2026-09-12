Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620C7369990;
	Sat, 12 Sep 2026 08:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200562; cv=none; b=QUtuAuKivuUFcEqk9YuQyI1np6H/fIUPpiakkGpgU/0JBrb/GLIQzBA/yess1tM24PdBKTvNSDZE8tXZPTu62CGp3hHBcoD9LMdXstS/aZ38wJa2h1djkVAdl6yBHbowJm3qZek48elNrDGFVf4BTrT3C5u7z7r9Bb7FeQVysf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200562; c=relaxed/simple;
	bh=fZXvfpV5a5A4xvQZeZl3HcnVROYbJncbej3f1/X5zbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LABy4kUWgB+xuNay0xXBaPNrdTsiW8WrJnuiAy13mj6/0R/d3/pKFdUHD6f03jH6WQJ40VsbsLCYlppTKGZRGSX3JQyNqdVMhHi6spwtDNoKjt38g3v5v7di3+jAwCdBijGyL52LHocnXVd1LSY6M6Uf+OxXsj5UgJxpfRObftY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MklltC2W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MklltC2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9DD1F000FF;
	Sat, 12 Sep 2026 08:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200561;
	bh=vzW0Fe9dlT7Bhyl/+oAEg0fukO6bdvgIk7GIctpsyrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MklltC2WrQgdM2SOftA7cD9daCPl/n45buDjc8xO8I5G80gTUv26sxfZf7dXdQN0s
	 O0qSGvuoHDyqgBgI3iPjOLH9Kv4WGrIL4FVXIcPzLq5aDTJeWtoNSBP+2G3/TKvafC
	 hNHRwGTGuWluic2LT3j9W5m6ZLpHAkn8/lSaGRsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0813/1815] arm64: dts: qcom: lemans-evk-ifp-mezzanine: Fix the PCIe iommu-map entries
Date: Sat, 12 Sep 2026 08:42:43 +0200
Message-ID: <20260912065708.000548398@linuxfoundation.org>
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

[ Upstream commit 6ee8ab6ca91dcea05793809df8a1dcfa94bcf3f0 ]

The IOMMU provider pcie_smmu uses '#iommu-cells = <2>', but the PCIe
iommu-map entries specify only one cell for the SID, omitting the SID
mask. This went unnoticed until the OF core started warning with commit
ccb2fd725d41 ("of: Respect #{iommu,msi}-cells in maps"):

  iommu-map has 1-cell entries targeting 2-cell #iommu-cells, treating as 1-cell output

So fix the entries to match the provider's '#iommu-cells' property.

Fixes: b64abb26a291 ("arm64: dts: qcom: lemans-evk: Add IFP Mezzanine")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260730-iommu-map-fix-v1-18-83405d37ba41@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/qcom/lemans-evk-ifp-mezzanine.dtso     | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/lemans-evk-ifp-mezzanine.dtso b/arch/arm64/boot/dts/qcom/lemans-evk-ifp-mezzanine.dtso
index 44bd9b1a17652..22c975628ed79 100644
--- a/arch/arm64/boot/dts/qcom/lemans-evk-ifp-mezzanine.dtso
+++ b/arch/arm64/boot/dts/qcom/lemans-evk-ifp-mezzanine.dtso
@@ -204,15 +204,15 @@
 };
 
 &pcie0 {
-	iommu-map = <0x0 &pcie_smmu 0x0 0x1>,
-		    <0x100 &pcie_smmu 0x1 0x1>,
-		    <0x208 &pcie_smmu 0x2 0x1>,
-		    <0x210 &pcie_smmu 0x3 0x1>,
-		    <0x218 &pcie_smmu 0x4 0x1>,
-		    <0x300 &pcie_smmu 0x5 0x1>,
-		    <0x400 &pcie_smmu 0x6 0x1>,
-		    <0x500 &pcie_smmu 0x7 0x1>,
-		    <0x501 &pcie_smmu 0x8 0x1>;
+	iommu-map = <0x0 &pcie_smmu 0x0 0x0 0x1>,
+		    <0x100 &pcie_smmu 0x1 0x0 0x1>,
+		    <0x208 &pcie_smmu 0x2 0x0 0x1>,
+		    <0x210 &pcie_smmu 0x3 0x0 0x1>,
+		    <0x218 &pcie_smmu 0x4 0x0 0x1>,
+		    <0x300 &pcie_smmu 0x5 0x0 0x1>,
+		    <0x400 &pcie_smmu 0x6 0x0 0x1>,
+		    <0x500 &pcie_smmu 0x7 0x0 0x1>,
+		    <0x501 &pcie_smmu 0x8 0x0 0x1>;
 };
 
 &pcieport0 {
-- 
2.53.0



