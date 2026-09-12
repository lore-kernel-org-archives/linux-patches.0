Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F523019D8;
	Sat, 12 Sep 2026 14:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224213; cv=none; b=RjFk0sMTWHDPrbf9iJtTbLA87Gk+SATOK945wjNk2OWzVz+E+4rVjE9iF7Q9ahprYHquhjZSD5HAH23vBHYW6ufnJh0aw7cF5ZpACSTdpEN0oENsetueAQ2KUDpT3TC8NRXGAUeexZQ0CAvgEEhbhLuSx2cRpfTS8YZzdFRBKz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224213; c=relaxed/simple;
	bh=QcFSGKyBhpeR80SSn00UxXJRlwxnNHYAC5gnTxaNSSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWiSEmfwqQvqztCb9KF8zri9nBznf0RvsSEuhoL4+vPUUDPXfbGRc7RjNAmlhpXnS3Df+IbJvqtiZLcjOuXJcWJj/lK2M4ggB+K+VQqW7uSwTgXKc95Rbkwj4ewsozMWJxanL/cbpTnJ61LTDz7qgxf50HhxrngSywGKLRIOSQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GRBYMfF5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GRBYMfF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93BE1F000FF;
	Sat, 12 Sep 2026 14:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224211;
	bh=zk2LH01ccYGGf1Xyfu69sW/5uJrd2iWX7G+H8mfmMyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GRBYMfF5Q1m5Q1Sc5V/lDG9LRSoRCYCnRbfCfPVbx5vjp5N3MEz+sW9UFUqITsxUZ
	 TXfO1INnLVV7vISZbIw1g2aQN1mft9etNk85q5Lo/DLU2iWRlJzUkAJbXRnyMEzy9D
	 nWSQH9wKQ2Ef8b9sR8g1mmTo/hkDODntAqT6D1Sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0945/1424] arm64: dts: qcom: sc8180x: drop duplicated PCI iommus property
Date: Sat, 12 Sep 2026 08:56:17 +0200
Message-ID: <20260912065628.481686459@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 2c21e5a84524381977b4744e906fb31862ac5809 ]

The IOMMUs for PCI controller on SC8180x are defined in iommu-map, so
drop duplicared iommus:

  sc8180x-lenovo-flex-5g.dtb: pci@1c08000: Unevaluated properties are not allowed ('iommus' was unexpected)

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20231112184430.3495-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: a4548204821a ("arm64: dts: qcom: sc8180x: Fix the PCIe iommu-map entries")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8180x.dtsi | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8180x.dtsi b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
index dfeeada91b780..26414e41f32cc 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
@@ -1745,7 +1745,6 @@ pcie0: pci@1c00000 {
 			assigned-clocks = <&gcc GCC_PCIE_0_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommus = <&apps_smmu 0x1d80 0x7f>;
 			iommu-map = <0x0   &apps_smmu 0x1d80 0x1>,
 				    <0x100 &apps_smmu 0x1d81 0x1>;
 
@@ -1843,7 +1842,6 @@ pcie3: pci@1c08000 {
 			assigned-clocks = <&gcc GCC_PCIE_3_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommus = <&apps_smmu 0x1e00 0x7f>;
 			iommu-map = <0x0   &apps_smmu 0x1e00 0x1>,
 				    <0x100 &apps_smmu 0x1e01 0x1>;
 
@@ -1942,7 +1940,6 @@ pcie1: pci@1c10000 {
 			assigned-clocks = <&gcc GCC_PCIE_1_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommus = <&apps_smmu 0x1c80 0x7f>;
 			iommu-map = <0x0   &apps_smmu 0x1c80 0x1>,
 				    <0x100 &apps_smmu 0x1c81 0x1>;
 
@@ -2041,7 +2038,6 @@ pcie2: pci@1c18000 {
 			assigned-clocks = <&gcc GCC_PCIE_2_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommus = <&apps_smmu 0x1d00 0x7f>;
 			iommu-map = <0x0   &apps_smmu 0x1d00 0x1>,
 				    <0x100 &apps_smmu 0x1d01 0x1>;
 
-- 
2.53.0



