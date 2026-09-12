Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1662361DDC;
	Sat, 12 Sep 2026 08:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200527; cv=none; b=YiUaUH4u//xpKoRIPQBcmU3xEuHNgjX3ag93cw16eLnVN20GQYU06Iru1fUvJVLK8VggLFBNTV8Pc5qTHXaPRh407Zg7jpAT7tkeGM+qV6IP7Vy8A1WKxKEdTZxbL0+C+b2/DH1DRBGtUxxfAniVqaK105Xc3zBOghN7hYfsnhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200527; c=relaxed/simple;
	bh=BJ8O4mfLif/rldTg3xzvoqs6BUxlTvu/sNlVND/Xa68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qPF1Zb4dJQiUb2iZYSXKe5RRc4xMrO2GgPcRgMK5hicARmZB8uhKl4ygfTGnTGc7QMry2vbtOnweYvBMdpuDTQOaJA/bXXgs0mc1sEYaAawSPJSlklogByCywuTyPOeUQ7llgpkYHMYLh9gfdz0sLRlEqU5YSc3ZuAbE+jNCfs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xm/QKOVt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xm/QKOVt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9251F000FF;
	Sat, 12 Sep 2026 08:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200526;
	bh=bFLnD5H/umbtT+IqCJeiocCI7+2D6uiMtZwWB3Mg1jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xm/QKOVtg8nxJHdzsGNm11TaCteJ/3kQa5db+g2zK6r5YuKqicBQehlqvi749OAax
	 9br0RBdPWrM6jsd68ETe8Sb4j/EwDPAzS6PcP7T+xPJTVI9Jp4ueOB3Jz9ZR7krjbw
	 IqFJZ4KNUDOWkuh/fuGlkLamWYxEIsUYLC/LMJvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0807/1815] arm64: dts: qcom: sm8750: Fix the PCIe iommu-map entries
Date: Sat, 12 Sep 2026 08:42:37 +0200
Message-ID: <20260912065707.858939959@linuxfoundation.org>
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

[ Upstream commit 366a540432a38c1c1533a319bc07b333f53752b6 ]

The IOMMU provider apps_smmu uses '#iommu-cells = <2>', but the PCIe
iommu-map entries specify only one cell for the SID, omitting the SID
mask. This went unnoticed until the OF core started warning with commit
ccb2fd725d41 ("of: Respect #{iommu,msi}-cells in maps"):

  iommu-map has 1-cell entries targeting 2-cell #iommu-cells, treating as 1-cell output

So fix the entries to match the provider's '#iommu-cells' property.

Fixes: 19f1395333f8 ("arm64: dts: qcom: sm8750: Add PCIe PHY and controller node")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260730-iommu-map-fix-v1-12-83405d37ba41@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8750.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8750.dtsi b/arch/arm64/boot/dts/qcom/sm8750.dtsi
index 6bcda7c38dbf9..c15ad5de0aa87 100644
--- a/arch/arm64/boot/dts/qcom/sm8750.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8750.dtsi
@@ -5280,8 +5280,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 			interconnect-names = "pcie-mem",
 					     "cpu-pcie";
 
-			iommu-map = <0x0   &apps_smmu 0x1400 0x1>,
-				    <0x100 &apps_smmu 0x1401 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1400 0x0 0x1>,
+				    <0x100 &apps_smmu 0x1401 0x0 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
-- 
2.53.0



