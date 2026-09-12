Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33CD369990;
	Sat, 12 Sep 2026 08:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200548; cv=none; b=ZeAmWi7P24D3ACoMAfrbjPXVYnoKaZaGVU5gNK2MzGlgyPVSuZs6KeQ+xN0QX4djGCV0OL29Wv/pmwpprp3vTpIGrtz5ohgS4v+mp/MgTtqZSs6ycpB0o4n0qMTSOe9u+VL/Mv2wliDvgDFEy48XCWh6U1+zBN6Btj/Ptv11cWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200548; c=relaxed/simple;
	bh=7K3DTJgpqeQD45iqT8m/4haLwxlIz0FX0YMx7fmtkQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lvXce80ZptTJp5Wo0o8XoH7GvEDbsLvJ9L6D1p7Xyxkiqlp7tjkTTVo1q/CgtwxAhtI/eyVAECbbcLEnFE+EuyVmGvnuUG1VsA+FYfszoNd/SDhiOWgrMfGeYmxZoq/VvTb++fHfU4pGebLUqXM1sLW03O1y9kXlMGUaRZXg2/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NfIYwHTj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NfIYwHTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A891F000FF;
	Sat, 12 Sep 2026 08:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200546;
	bh=0RBTb3Zhvwgf3zA6MfqFwiJawqAEFemx8L9WRxYOqdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NfIYwHTjOYJ0piZY44Z0qVlqL6r0FehHJ9+Feg9FoA+baWhbLGf54HSjtAxhXnU1T
	 zhzZm5aEB3YfTL94zwzIDh9DC420TYLnMzIPEtxDkATCXr99eO9iKv70hwP4EaUKYj
	 OEBba8dOCJI9nFUcH2XIuTiB9SiIVSAm+VkdlWvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0811/1815] arm64: dts: qcom: monaco-monza-som: Fix the PCIe iommu-map entries
Date: Sat, 12 Sep 2026 08:42:41 +0200
Message-ID: <20260912065707.953683606@linuxfoundation.org>
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

[ Upstream commit d7ae79013e6c9b2374948d70856045cc84c9261d ]

The IOMMU provider pcie_smmu uses '#iommu-cells = <2>', but the PCIe
iommu-map entries specify only one cell for the SID, omitting the SID
mask. This went unnoticed until the OF core started warning with commit
ccb2fd725d41 ("of: Respect #{iommu,msi}-cells in maps"):

  iommu-map has 1-cell entries targeting 2-cell #iommu-cells, treating as 1-cell output

So fix the entries to match the provider's '#iommu-cells' property.

Fixes: 5238f4e7169f ("arm64: dts: qcom: Add Monaco Monza SoM")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260730-iommu-map-fix-v1-16-83405d37ba41@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/monaco-monza-som.dtsi | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/monaco-monza-som.dtsi b/arch/arm64/boot/dts/qcom/monaco-monza-som.dtsi
index 9b5ed55939b86..36af1ad2105d5 100644
--- a/arch/arm64/boot/dts/qcom/monaco-monza-som.dtsi
+++ b/arch/arm64/boot/dts/qcom/monaco-monza-som.dtsi
@@ -196,14 +196,14 @@ &iris {
 
 /* PCIe0 Gen4 x2 */
 &pcie0 {
-	iommu-map = <0x0 &pcie_smmu 0x0000 0x1>,
-		    <0x100 &pcie_smmu 0x0001 0x1>,
-		    <0x200 &pcie_smmu 0x0007 0x1>,
-		    <0x208 &pcie_smmu 0x0002 0x1>,
-		    <0x210 &pcie_smmu 0x0003 0x1>,
-		    <0x218 &pcie_smmu 0x0004 0x1>,
-		    <0x300 &pcie_smmu 0x0005 0x1>,
-		    <0x400 &pcie_smmu 0x0006 0x1>;
+	iommu-map = <0x0 &pcie_smmu 0x0000 0x0 0x1>,
+		    <0x100 &pcie_smmu 0x0001 0x0 0x1>,
+		    <0x200 &pcie_smmu 0x0007 0x0 0x1>,
+		    <0x208 &pcie_smmu 0x0002 0x0 0x1>,
+		    <0x210 &pcie_smmu 0x0003 0x0 0x1>,
+		    <0x218 &pcie_smmu 0x0004 0x0 0x1>,
+		    <0x300 &pcie_smmu 0x0005 0x0 0x1>,
+		    <0x400 &pcie_smmu 0x0006 0x0 0x1>;
 
 	status = "okay";
 };
-- 
2.53.0



