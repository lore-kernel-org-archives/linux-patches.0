Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0326B288B2;
	Sat, 12 Sep 2026 10:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208931; cv=none; b=Nfx8BhUk8l2AclX3Abq9FXxgFBcK74OYu5AVNwB+JjTN629x3R4BV8Jld8YmGiWwhChnYS0JU13CN9kqkdcjW0nmG9Qwl8L2Ry+LJbqNcg3wZax5dbkK3lcpL3/Lg3wilUbeSM+6ZGqEyVWvCiVJu3Q1csVYapPjVXHAH4zc0iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208931; c=relaxed/simple;
	bh=tVZk4R9oHJ7Lzp4uVSwms0vT6s+KlSm/lF27A/gszXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5iZ48mHv0X5rYaRjq6JFDYOqAtrBRiI8r7DCgZ3L+EjjdFiQZqUxIRRMBFG6RRK+Gj09PJyZ9t7PEtingiO4Xf8Y40pcgCOdbzUDCNGsr0YjRTklBByvl/Q6w32cmJt7wveIsdXvCdWuPX1bAkwpHtAbST+CNWuSaXQXgQF868=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S4V6xhu7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S4V6xhu7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C0C1F000FF;
	Sat, 12 Sep 2026 10:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208929;
	bh=LFOkS20QrVzUPPlYPSElxHMqIqKPhiM3K5hfk+fNS34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S4V6xhu7Ik44v7zKU1dV1tuFB8VEmP335YocWgA/UY6vi4OCdeLiyiLhuHQpnheiO
	 jWn+t6fLq8ktu2KH2DtfNQg9481P2BCGS2Qe3cwRQ0EU9XEi1rVrZwV4BQP3RUZ0IW
	 ze6IIHh/oZNVHnqPhFXa/hnJKZQPaoOa87eEpUzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0691/1518] arm64: dts: qcom: sm8650: Fix the PCIe iommu-map entries
Date: Sat, 12 Sep 2026 08:47:40 +0200
Message-ID: <20260912065639.070796355@linuxfoundation.org>
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

[ Upstream commit 8ccba7b44609d58db088447a771f6f30cfa8739e ]

The IOMMU provider apps_smmu uses '#iommu-cells = <2>', but the PCIe
iommu-map entries specify only one cell for the SID, omitting the SID
mask. This went unnoticed until the OF core started warning with commit
ccb2fd725d41 ("of: Respect #{iommu,msi}-cells in maps"):

  iommu-map has 1-cell entries targeting 2-cell #iommu-cells, treating as 1-cell output

So fix the entries to match the provider's '#iommu-cells' property.

Fixes: 10e024671295 ("arm64: dts: qcom: sm8650: add interconnect dependent device nodes")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260730-iommu-map-fix-v1-11-83405d37ba41@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8650.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8650.dtsi b/arch/arm64/boot/dts/qcom/sm8650.dtsi
index 6c775ef20cb0a..349ce22c6b686 100644
--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -3626,8 +3626,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 
 			operating-points-v2 = <&pcie0_opp_table>;
 
-			iommu-map = <0     &apps_smmu 0x1400 0x1>,
-				    <0x100 &apps_smmu 0x1401 0x1>;
+			iommu-map = <0     &apps_smmu 0x1400 0x0 0x1>,
+				    <0x100 &apps_smmu 0x1401 0x0 0x1>;
 
 			interrupt-map = <0 0 0 1 &intc 0 0 GIC_SPI 149 IRQ_TYPE_LEVEL_HIGH 0>,
 					<0 0 0 2 &intc 0 0 GIC_SPI 150 IRQ_TYPE_LEVEL_HIGH 0>,
@@ -3806,8 +3806,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 
 			operating-points-v2 = <&pcie1_opp_table>;
 
-			iommu-map = <0     &apps_smmu 0x1480 0x1>,
-				    <0x100 &apps_smmu 0x1481 0x1>;
+			iommu-map = <0     &apps_smmu 0x1480 0x0 0x1>,
+				    <0x100 &apps_smmu 0x1481 0x0 0x1>;
 
 			interrupt-map = <0 0 0 1 &intc 0 0 GIC_SPI 434 IRQ_TYPE_LEVEL_HIGH 0>,
 					<0 0 0 2 &intc 0 0 GIC_SPI 435 IRQ_TYPE_LEVEL_HIGH 0>,
-- 
2.53.0



