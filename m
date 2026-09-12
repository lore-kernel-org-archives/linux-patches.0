Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02C1423EB9;
	Sat, 12 Sep 2026 10:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209021; cv=none; b=HHAgJ0OEoRoztROjr8UMkmdGzn5OLM6HJ+/NHWPZAQCkCqfIsk0lcR6Y7W3/q5WUstdJOb7TntWpBcxZYgHdxmDWyaTqjbzwwP83MahdyqEMSpMlXmp8vBF3BWKqbXw2+bp8yWSvneW/rIUAod9NISTj70FaQAjRokRgc/XTql0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209021; c=relaxed/simple;
	bh=2PELbCWkXKxLdAK52QEL8bg8ZbWHnhH1TfXQpSGzm9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XupScyAMUGbFW0uG7uAR6d6OEy9p0wfwHP21cbbsTh+kqORFQZFHRWU1R2zZNk56fP2HROYprxcMtZaQeCC1prGOb6m1fOiRehExrTi1I++ptq8bmv6yMbuSEnD76ebehWIx+fZIXQQzSfCOQZx1kOypg8V0ry7edmgKmi2EVXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dnU+4pmy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dnU+4pmy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0505C1F00893;
	Sat, 12 Sep 2026 10:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209019;
	bh=bovl9vayTE7rLkAgLiX9AGt7w2PYL5HzzkRYbpdgffw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dnU+4pmy6ecuJnULLPd3p7nbL66IPG80CafY+iBTiHBWM8btPNPOKfKWgS/7mAW0z
	 ODCFLcJTZq5IQuPkwNxX1DeCO64/7vo0Oh4RWyFsM5656CzdmMMvarfSzR12Ax5l0h
	 z7bZ3WHzaMCND5WA+wTfzbffUMp+pez7+K4eUJ/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0693/1518] arm64: dts: qcom: talos: Fix the PCIe iommu-map entries
Date: Sat, 12 Sep 2026 08:47:42 +0200
Message-ID: <20260912065639.114853675@linuxfoundation.org>
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

[ Upstream commit f7e687d6050f27a03847abadc12d6821576d06ee ]

The IOMMU provider apps_smmu uses '#iommu-cells = <2>', but the PCIe
iommu-map entries specify only one cell for the SID, omitting the SID
mask. This went unnoticed until the OF core started warning with commit
ccb2fd725d41 ("of: Respect #{iommu,msi}-cells in maps"):

  iommu-map has 1-cell entries targeting 2-cell #iommu-cells, treating as 1-cell output

So fix the entries to match the provider's '#iommu-cells' property.

Fixes: 718cc7542a00 ("arm64: dts: qcom: qcs615: enable pcie")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260730-iommu-map-fix-v1-13-83405d37ba41@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6150.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6150.dtsi b/arch/arm64/boot/dts/qcom/sm6150.dtsi
index a066ad5ffde57..ff3ae5688f03e 100644
--- a/arch/arm64/boot/dts/qcom/sm6150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6150.dtsi
@@ -1175,8 +1175,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 					 &config_noc SLAVE_PCIE_0 QCOM_ICC_TAG_ACTIVE_ONLY>;
 			interconnect-names = "pcie-mem", "cpu-pcie";
 
-			iommu-map = <0x0 &apps_smmu 0x400 0x1>,
-				    <0x100 &apps_smmu 0x401 0x1>;
+			iommu-map = <0x0 &apps_smmu 0x400 0x0 0x1>,
+				    <0x100 &apps_smmu 0x401 0x0 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
-- 
2.53.0



