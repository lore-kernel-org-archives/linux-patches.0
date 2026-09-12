Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6499369D72;
	Sat, 12 Sep 2026 08:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200552; cv=none; b=OwbZCiVG44jv9Fw9cUX/iLKftv/mGNVIiwQMQARS7TAy5zuf0TZabKA7a9QyYiN6YYHwH/av6xvZC6rNCrBNH510KQS0fcmaN9WPjUQxR4oSm3h2YB8kKcbzMhz0KlbcSd8wtcs7oH45ccZh179fCiqJwi4NrmISoYSMigb6Ti4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200552; c=relaxed/simple;
	bh=B60DX+H2lBRyIkaJuhaC+9K3dMs2v6F2sNxo2pr8j5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GDeAZepw/v5ZBcpx+EIFO2dSXIRwnG+q+22NifSd0OpayIfRo5+/HiJYzGYqZXzTuHKoYjPpPCkJVd7vFEAwgP9SRV9SZ9T88/kAthuLZp+p68rOTjbxakGsnpwf+9GB2a4vNd6zd77KjU0uUoGIHaqH8CMjgghA6bRIbksOQf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fk5AzR15; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fk5AzR15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AACD71F000FF;
	Sat, 12 Sep 2026 08:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200551;
	bh=zSuw07rQwscbwpFD7j2xWdR0kOIPAnUe9vZ0Tjr+kP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fk5AzR15y/bo0FEOiiW3iGDslkMhyl0PLrboXlCM4FULV1+bHOW8cQKxdOkx+hYnS
	 aAWQRi3IGzMoKT3dqkOZuJPiaaXCXmD0VjbJ3VKtumKl6Og7BaC2m7YUA4yPg1xj9Q
	 SOSof21YEmdDTKjOqtEZ8wE9wSXrQzw1N8C4V8DY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0812/1815] arm64: dts: qcom: monaco-evk-ifp-mezzanine: Fix the PCIe iommu-map entries
Date: Sat, 12 Sep 2026 08:42:42 +0200
Message-ID: <20260912065707.977020394@linuxfoundation.org>
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

[ Upstream commit b35b58535b45441a4521d50215b5668731857c7d ]

The IOMMU provider pcie_smmu uses '#iommu-cells = <2>', but the PCIe
iommu-map entries specify only one cell for the SID, omitting the SID
mask. This went unnoticed until the OF core started warning with commit
ccb2fd725d41 ("of: Respect #{iommu,msi}-cells in maps"):

  iommu-map has 1-cell entries targeting 2-cell #iommu-cells, treating as 1-cell output

So fix the entries to match the provider's '#iommu-cells' property.

Fixes: 5a67924d2fc5 ("arm64: dts: qcom: monaco-evk: Add IFP Mezzanine")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260730-iommu-map-fix-v1-17-83405d37ba41@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/qcom/monaco-evk-ifp-mezzanine.dtso     | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/monaco-evk-ifp-mezzanine.dtso b/arch/arm64/boot/dts/qcom/monaco-evk-ifp-mezzanine.dtso
index e6beb4393430b..a6e57ec8a1e14 100644
--- a/arch/arm64/boot/dts/qcom/monaco-evk-ifp-mezzanine.dtso
+++ b/arch/arm64/boot/dts/qcom/monaco-evk-ifp-mezzanine.dtso
@@ -50,15 +50,15 @@
 };
 
 &pcie0 {
-	iommu-map = <0x0   &pcie_smmu 0x0 0x1>,
-		    <0x100 &pcie_smmu 0x1 0x1>,
-		    <0x208 &pcie_smmu 0x2 0x1>,
-		    <0x210 &pcie_smmu 0x3 0x1>,
-		    <0x218 &pcie_smmu 0x4 0x1>,
-		    <0x300 &pcie_smmu 0x5 0x1>,
-		    <0x400 &pcie_smmu 0x6 0x1>,
-		    <0x500 &pcie_smmu 0x7 0x1>,
-		    <0x501 &pcie_smmu 0x8 0x1>;
+	iommu-map = <0x0   &pcie_smmu 0x0 0x0 0x1>,
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



