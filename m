Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180BF32B125;
	Sat, 12 Sep 2026 16:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230362; cv=none; b=plM42yCAeXCiCXxan0X8JnWsyizQB3UDPqhJtABGBWnGt+frdEVXWB+I4nUPBMuW1z/6kJCNun2RdH9EHL3roMevYPL8XjGFeM3ArHnp4y3aBrRmPVh5OxECp3gsA6u+bN7a0Nl2P+xF8o7lIiCUYwo3fCW50EZNkvb41Agdbaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230362; c=relaxed/simple;
	bh=JGZos2b48S4qSRLL7YrQN4fYa0Qdrj4tyxWOOVrveDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lKkhdxc3Q7dgB589Z2QJVLzKcYzVz+nXyxY1So4Hz6rLQLFzvRr7lrdBEABjFgt86Uoq45c+17CEltAozlkvGv9evRq297/XmaHxRDCDbLFNXXtOz3elaw0IHA4Fiabbz51nMktCUNSlcPKzSZ68Rfn92X1nIo/4HkTRUrjQd4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BNGgeiRn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BNGgeiRn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063811F000FF;
	Sat, 12 Sep 2026 16:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230361;
	bh=qr9KftMXyy4BhkrNWgoLsRmR4aCBsvTNcfZBEoBG1OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BNGgeiRn0obv9n5lwWnLrocirXUtVrS8MEsfWJoCgDHFj3C3oQZ7hqpMRuUSNsaRD
	 RcTio/imlFwa9YvzsVugHRrV6qeBfhjFQdMWDkjlqQx9AoI//Xzk1Eb5Tdv/lZKGwO
	 beVsDataYUESilWd82coRmEiJ73nTJ1DXWbCvm6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0776/1191] arm64: dts: qcom: sm8150: Fix the PCIe iommu-map entries
Date: Sat, 12 Sep 2026 08:58:24 +0200
Message-ID: <20260912065605.705295750@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit d2e56fb42e3d10d7e711063cdc00523ddb31d544 ]

The IOMMU provider apps_smmu uses '#iommu-cells = <2>', but the PCIe
iommu-map entries specify only one cell for the SID, omitting the SID
mask. This went unnoticed until the OF core started warning with commit
ccb2fd725d41 ("of: Respect #{iommu,msi}-cells in maps"):

  iommu-map has 1-cell entries targeting 2-cell #iommu-cells, treating as 1-cell output

So fix the entries to match the provider's '#iommu-cells' property.

Fixes: a1c86c680533 ("arm64: dts: qcom: sm8150: Add PCIe nodes")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260730-iommu-map-fix-v1-6-83405d37ba41@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8150.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index 9168173dd0e3e..1ea6a09b57bc2 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -1810,8 +1810,8 @@ pcie0: pci@1c00000 {
 				      "slave_q2a",
 				      "tbu";
 
-			iommu-map = <0x0   &apps_smmu 0x1d80 0x1>,
-				    <0x100 &apps_smmu 0x1d81 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1d80 0x0 0x1>,
+				    <0x100 &apps_smmu 0x1d81 0x0 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -1912,8 +1912,8 @@ pcie1: pci@1c08000 {
 			assigned-clocks = <&gcc GCC_PCIE_1_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommu-map = <0x0   &apps_smmu 0x1e00 0x1>,
-				    <0x100 &apps_smmu 0x1e01 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1e00 0x0 0x1>,
+				    <0x100 &apps_smmu 0x1e01 0x0 0x1>;
 
 			resets = <&gcc GCC_PCIE_1_BCR>;
 			reset-names = "pci";
-- 
2.53.0



