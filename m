Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF9C369990;
	Sat, 12 Sep 2026 08:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200543; cv=none; b=RkBDnImtX36Xoen/6/Jtea1jTkCjhHhrfBrWsx1zi6lsDr9S51dnR+anJesEbc963Qu+7d17gv4ix4a8cCmEiEg2rt6F1ygjWFnPC9vTd492xM6duiP554egX2JZ2ojnxsH7otqX5XKr67SP9RL4DWWYOM05SSrJz2f4PTpPcSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200543; c=relaxed/simple;
	bh=nUOgRRrk0D3g6+JZrhe9tnOAAYFZ1aWLFnjzFvPMeGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mkiMnmXr1DR6ZnABOQNXEOTQzIOud45dSWNAYDG4ZgzT14/5+CKsb65lK3wZU6wgwdRiwuR63t48tru4fVD+0IbeER1dvpr0k4RYmwjdOPR07Lwc//YVVPZLXlyYT5ocz25v0SpGWyh1dtU0OjmUv7upLQ5xvkUWSpH4i4nwYis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oH7LDkxB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oH7LDkxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87D161F000FF;
	Sat, 12 Sep 2026 08:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200541;
	bh=Hvz2YgBVzP2HxfjSgL6lyrie8TjYcvTXRgMK9zsgqG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oH7LDkxBa7tVd5WMcsBzs0hQ7v7jg4WiEUmfBaZ6S2mqd43vPokhzvlYJ80FSumxi
	 QXAp05216YMdH7QE+TrMH0Gi6WSZXRKAsz+jJbHi5ULC2rsow+Qy6+mivVkrxcHvQo
	 sL4hNu+BDjZwoBmJpG+VH+uf/DPoPFJVAgU1Wo44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0810/1815] arm64: dts: qcom: monaco: Fix the PCIe iommu-map entries
Date: Sat, 12 Sep 2026 08:42:40 +0200
Message-ID: <20260912065707.930753839@linuxfoundation.org>
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

[ Upstream commit 2e455d9278550c8886a94e30a906437a26c79581 ]

The IOMMU provider pcie_smmu uses '#iommu-cells = <2>', but the PCIe
iommu-map entries specify only one cell for the SID, omitting the SID
mask. This went unnoticed until the OF core started warning with commit
ccb2fd725d41 ("of: Respect #{iommu,msi}-cells in maps"):

  iommu-map has 1-cell entries targeting 2-cell #iommu-cells, treating as 1-cell output

So fix the entries to match the provider's '#iommu-cells' property.

Fixes: 46a7c01e7e9d ("arm64: dts: qcom: qcs8300: enable pcie0")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260730-iommu-map-fix-v1-15-83405d37ba41@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/monaco.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/monaco.dtsi b/arch/arm64/boot/dts/qcom/monaco.dtsi
index 3a0749cd3e788..61ef690f5fdf7 100644
--- a/arch/arm64/boot/dts/qcom/monaco.dtsi
+++ b/arch/arm64/boot/dts/qcom/monaco.dtsi
@@ -2349,8 +2349,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 			interconnect-names = "pcie-mem",
 					     "cpu-pcie";
 
-			iommu-map = <0x0 &pcie_smmu 0x0000 0x1>,
-				    <0x100 &pcie_smmu 0x0001 0x1>;
+			iommu-map = <0x0 &pcie_smmu 0x0000 0x0 0x1>,
+				    <0x100 &pcie_smmu 0x0001 0x0 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>,
 				 <&gcc GCC_PCIE_0_LINK_DOWN_BCR>;
@@ -2526,8 +2526,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 					 &config_noc SLAVE_PCIE_1 QCOM_ICC_TAG_ACTIVE_ONLY>;
 			interconnect-names = "pcie-mem", "cpu-pcie";
 
-			iommu-map = <0x0 &pcie_smmu 0x0080 0x1>,
-				    <0x100 &pcie_smmu 0x0081 0x1>;
+			iommu-map = <0x0 &pcie_smmu 0x0080 0x0 0x1>,
+				    <0x100 &pcie_smmu 0x0081 0x0 0x1>;
 
 			resets = <&gcc GCC_PCIE_1_BCR>,
 				 <&gcc GCC_PCIE_1_LINK_DOWN_BCR>;
-- 
2.53.0



