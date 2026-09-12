Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA81369990;
	Sat, 12 Sep 2026 08:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200532; cv=none; b=GdCG8HGIQQ0O9+/DyB5GHrNavjC2BveDCHV/fZxirGOJC6RRZ6g23QLVmJr/tSun+Jo4vj6bkA1w71SsoaxVzSuH4mildgqJR0b862LQeYq+9E6wCTcY3ddZdPYBOfWyKBBtrt5H24eNGLMk4JpfgxaJtn90sXNLYB9VClmPEVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200532; c=relaxed/simple;
	bh=exmGooZasVlL+qjNxEUf0fjAOPKBT8AoxSOIppd2W+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UuV7oth4EB9wzyCCSP3gMkcHQMDDQ19nJh154Cgp70CASD+MQd+fUFA4L3QEYwOmWNAK1R5pMWIEVfEXhQWgBi+MTeaEV3Q4+Dp/IvZKaOdDpDjIgYqxov2CchumjV7bCYaUWMAPXFp6xDXBtOb4MQgKq1jiQb1Yil+bewCP2o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H3lFCt05; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H3lFCt05"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 678D51F000FF;
	Sat, 12 Sep 2026 08:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200531;
	bh=IEUKQjZunNB/7ITdr3mkkoQccSA2BuES2G5oFBBV9PQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H3lFCt05zsU2J1X+NnMpdzZDEVY1aIM21SohaU9Du9wHRVa1/gD/rg5YtXqfUagZh
	 Z+nUcROp3CMolxUv9ABxzXjxBeU6gVrfLZGAJb1AX9BYmMX6Dq2kQKBNXJKQTgNUCz
	 31bpNqVrOOiZq0GB/Pq9SfkpA3w06KVE/U6Z2Vhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0808/1815] arm64: dts: qcom: talos: Fix the PCIe iommu-map entries
Date: Sat, 12 Sep 2026 08:42:38 +0200
Message-ID: <20260912065707.884360453@linuxfoundation.org>
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
 arch/arm64/boot/dts/qcom/talos.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/talos.dtsi b/arch/arm64/boot/dts/qcom/talos.dtsi
index f77069c1e10e2..23990890280bd 100644
--- a/arch/arm64/boot/dts/qcom/talos.dtsi
+++ b/arch/arm64/boot/dts/qcom/talos.dtsi
@@ -1349,8 +1349,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
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



