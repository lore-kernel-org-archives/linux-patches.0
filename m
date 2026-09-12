Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0D53002B3;
	Sat, 12 Sep 2026 10:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208762; cv=none; b=rKuhLnwSdZai/QMvA70GRY8mwIEWOUqR2LLESgC4EBtLK5OLr0u8kuZ6q6zJqY2oDQvjK4sW0TqNN8aTZWYMdRAeMyGhvJLGd32gu6gTHqsflgFariTu49LqDNJzvQHa89j4yPYGivTBGKos8UJB8xbACeIeKAUig/+Pzrqqu0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208762; c=relaxed/simple;
	bh=S+NaKGK/dxwOcLJVAIzX6ZHRgUJQu8KD61KIdC4bVvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WX4Pnhw54TqCJ6vAr/yqCXHkKI86pJXxvRnNQSiHPCsGV/cIh6MnTJTmmiYVPugujN73eut9d7lBPd60699sEWPqn2ndG30wb1+7ndUiZe0jGnbSVsn24DKPG1wN2LKIGKkKo4qsKA2qH2+4cw6y2PrEh8HpMMls6lbnkh21CNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eOdSP8z0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eOdSP8z0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66A91F000FF;
	Sat, 12 Sep 2026 10:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208760;
	bh=o0sRX13O14cL61xlTJQj+errbcNg5WHoyvppaoJuTWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eOdSP8z0XoCUPG07vvl8rFS8F2ZoO/AbAj4S0sUfr+55kj8OtcnCa6BZevF5sRNfz
	 coIvwoDyUCWjGSpgJiPlZ8td41VDfkjfyfCJCC3mWKWcK//hjfKSRvZqcS2No08FJ8
	 VUwuvakw+0l+vTsRtxQOSk2d69yCit5E+daVVKTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0682/1518] arm64: dts: qcom: kodiak: Fix the PCIe iommu-map entries
Date: Sat, 12 Sep 2026 08:47:31 +0200
Message-ID: <20260912065638.865872567@linuxfoundation.org>
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

[ Upstream commit 52dac5bda29a3acd896fab2567605683d34970db ]

The IOMMU provider apps_smmu uses '#iommu-cells = <2>', but the PCIe
iommu-map entries specify only one cell for the SID, omitting the SID
mask. This went unnoticed until the OF core started warning with commit
ccb2fd725d41 ("of: Respect #{iommu,msi}-cells in maps"):

  iommu-map has 1-cell entries targeting 2-cell #iommu-cells, treating as 1-cell output

So fix the entries to match the provider's '#iommu-cells' property.

Fixes: f8328b7549e1 ("arm64: dts: qcom: sc7280: Describe the first PCIe controller and PHY")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260730-iommu-map-fix-v1-2-83405d37ba41@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 0f566dd75c964..7d53e06e97b07 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -2273,8 +2273,8 @@ pcie0: pcie@1c00000 {
 				      "aggre0",
 				      "aggre1";
 
-			iommu-map = <0x0   &apps_smmu 0x1c00 0x1>,
-				    <0x100 &apps_smmu 0x1c01 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c00 0x0 0x1>,
+				    <0x100 &apps_smmu 0x1c01 0x0 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -2419,8 +2419,8 @@ pcie1: pcie@1c08000 {
 
 			dma-coherent;
 
-			iommu-map = <0x0 &apps_smmu 0x1c80 0x1>,
-				    <0x100 &apps_smmu 0x1c81 0x1>;
+			iommu-map = <0x0 &apps_smmu 0x1c80 0x0 0x1>,
+				    <0x100 &apps_smmu 0x1c81 0x0 0x1>;
 
 			status = "disabled";
 
-- 
2.53.0



