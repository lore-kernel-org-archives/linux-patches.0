Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900652E7631;
	Sat, 12 Sep 2026 16:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230387; cv=none; b=AusUwjJ/fCtnRFFGrasBs+WK0d0Jj3XmNmAjhhUgu9iCPP1FSnNZ4iYXGFPwrEv4YEV3bFYe/EtMNLKOW8ATZ8BkSyXskWANujmFa8xPbn//SKdEUdGFMjvJ4sPT+2mUBnZ7O0wG+AgxobNN91WUE6C5/PSUEOo3OspIgNwOn54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230387; c=relaxed/simple;
	bh=tjLe0ZHBVWLLBwCyTI4tYWxj67KnmA5Brt5MZQFraLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JpvKAF4GfYsSxJ24FI8qslUQVHafcbf+5KsAQ4UERvjddEgVP/xTO4wLqg9b9guUfsjdMkKGuBVHgNPnLBXwWCSNYQ4XY3JorRTym8NJBQQn0nZ2/nIrhJ9MFqD9IdzBXjoqasRm8ZzcG+MFP07jzE+5yn3TCPIQbyMFuEGjWQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cXZP+5oI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cXZP+5oI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197DB1F000FF;
	Sat, 12 Sep 2026 16:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230386;
	bh=efsqW79aVA0WsKqOAz3eABsRrTckjreJtPDIC1I1vpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cXZP+5oILiunGLzOZoel4gREPfkxbdqYSfY1SZhgUkZAFojO7uUSP8S7rppz2rcFv
	 oO5Lkoq0srPwA0o25dhKYNBcgRtwYIlJNM/lPNJXYwt5BhMkqSvGrUaNyDtd5kK0qU
	 zdV8oUsbXVdFmoh+7XalkKcHbb6WC/txU2A4ZNS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0781/1191] arm64: dts: qcom: sm8550: Fix the msi-map entries
Date: Sat, 12 Sep 2026 08:58:29 +0200
Message-ID: <20260912065605.818794691@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 98a953fa2f4095b9777dbf59a3ed2ac3c0bf55cb ]

While adding the GIC ITS MSI support, it was found that the msi-map entries
needed to be swapped to receive MSIs from the endpoint.

But later it was identified that the swapping was needed due to a bug in
the Qualcomm PCIe controller driver. And since the bug is now fixed with
commit bf79e33cdd89 ("PCI: qcom: Enable BDF to SID translation properly"),
let's fix the msi-map entries also to reflect the actual mapping in the
hardware.

Fixes: 114990ce3edf ("arm64: dts: qcom: sm8550: Use GIC-ITS for PCIe0 and PCIe1")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Acked-by: Neil Armstrong <neil.armstrong@linaro.org>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
Link: https://lore.kernel.org/r/20240318-pci-bdf-sid-fix-v1-2-acca6c5d9cf1@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 16d98ee918d6 ("arm64: dts: qcom: sm8550: Fix the PCIe iommu-map entries")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index ea03538d7f996..3a507b46c24d0 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -1416,9 +1416,8 @@ pcie0: pci@1c00000 {
 			interconnect-names = "pcie-mem";
 			interconnects = <&pcie_noc MASTER_PCIE_0 0 &mc_virt SLAVE_EBI1 0>;
 
-			/* Entries are reversed due to the unusual ITS DeviceID encoding */
-			msi-map = <0x0 &gic_its 0x1401 0x1>,
-				  <0x100 &gic_its 0x1400 0x1>;
+			msi-map = <0x0 &gic_its 0x1400 0x1>,
+				  <0x100 &gic_its 0x1401 0x1>;
 			iommu-map = <0x0   &apps_smmu 0x1400 0x1>,
 				    <0x100 &apps_smmu 0x1401 0x1>;
 
@@ -1522,9 +1521,8 @@ pcie1: pci@1c08000 {
 			interconnect-names = "pcie-mem";
 			interconnects = <&pcie_noc MASTER_PCIE_1 0 &mc_virt SLAVE_EBI1 0>;
 
-			/* Entries are reversed due to the unusual ITS DeviceID encoding */
-			msi-map = <0x0 &gic_its 0x1481 0x1>,
-				  <0x100 &gic_its 0x1480 0x1>;
+			msi-map = <0x0 &gic_its 0x1480 0x1>,
+				  <0x100 &gic_its 0x1481 0x1>;
 			iommu-map = <0x0   &apps_smmu 0x1480 0x1>,
 				    <0x100 &apps_smmu 0x1481 0x1>;
 
-- 
2.53.0



