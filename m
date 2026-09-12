Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D5D42376B;
	Sat, 12 Sep 2026 10:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209048; cv=none; b=QDHEnDouO6f/DDMVWhx1O8Em6rPf2DSCTqt8zqR1AbP7KAetGhZD5bQMPbCmZSXSsCypg1Nb3fXEc14niQYVuY5SrQVmvP69X3S8Jr5LLgjexCKG4ffB9KNJ0GxEjsxilmgAY3jJHE4Yoc3kMYCxOc6ESWyU5liBQ91N9UZgaRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209048; c=relaxed/simple;
	bh=PyhFntxsxFZWmFwUdKpf7Ddo1wF0KaZ1wFDxlMGUJDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZtWxM85VzmgDdq01KjT8ej+QE1DFOkuLsYdKKc/i9nbwf3HrS76wUhNkz+c4D7u1oGr3CTLu7rjXf1x8+cBPA6Oez+jxeIWjAunJP0gW6Uu+QBRbyjjRWq04QVsSWh2wBeqITuBTGwgQUQkiI9HYoEuibMNxXbUfujye75jAkuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SHOF0od6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SHOF0od6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32BF71F000FF;
	Sat, 12 Sep 2026 10:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209045;
	bh=JvnIfAN0+0LKp9fpUnK1TRksG1+KQVkje2JrKFAG/+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SHOF0od6CSeuJlRbilk7hukPCd1hW7PyXWwTSwc3DZtS6LjfJTZ232ilQ1J08L7xc
	 wIVraUr2yJFPZNRq+NnCWunQ6gC1cli1ZxSK+v4UUaARBlcNZAxZwvCZT9UvT+XuPw
	 Q9o94aj6P6ZqMMK4ohe/++psgakJPJYMFhSou7iI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0688/1518] arm64: dts: qcom: sm8350: Fix the PCIe iommu-map entries
Date: Sat, 12 Sep 2026 08:47:37 +0200
Message-ID: <20260912065639.003591300@linuxfoundation.org>
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

[ Upstream commit 80337ea3a154230621c0b4e3c831f5d81712ba18 ]

The IOMMU provider apps_smmu uses '#iommu-cells = <2>', but the PCIe
iommu-map entries specify only one cell for the SID, omitting the SID
mask. This went unnoticed until the OF core started warning with commit
ccb2fd725d41 ("of: Respect #{iommu,msi}-cells in maps"):

  iommu-map has 1-cell entries targeting 2-cell #iommu-cells, treating as 1-cell output

So fix the entries to match the provider's '#iommu-cells' property.

Fixes: 6daee40678a0 ("arm64: dts: qcom: sm8350: add PCIe devices")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260730-iommu-map-fix-v1-8-83405d37ba41@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index af892b76322fd..2bbc1f28be88b 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -1575,8 +1575,8 @@ pcie0: pcie@1c00000 {
 				      "aggre1",
 				      "aggre0";
 
-			iommu-map = <0x0   &apps_smmu 0x1c00 0x1>,
-				    <0x100 &apps_smmu 0x1c01 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c00 0x0 0x1>,
+				    <0x100 &apps_smmu 0x1c01 0x0 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -1684,8 +1684,8 @@ pcie1: pcie@1c08000 {
 				      "ddrss_sf_tbu",
 				      "aggre1";
 
-			iommu-map = <0x0   &apps_smmu 0x1c80 0x1>,
-				    <0x100 &apps_smmu 0x1c81 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c80 0x0 0x1>,
+				    <0x100 &apps_smmu 0x1c81 0x0 0x1>;
 
 			resets = <&gcc GCC_PCIE_1_BCR>;
 			reset-names = "pci";
-- 
2.53.0



