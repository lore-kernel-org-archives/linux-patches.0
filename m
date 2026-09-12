Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862EB340D9D;
	Sat, 12 Sep 2026 10:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208838; cv=none; b=RGRhDuy6urL0t27+C+yTXlXAMYPBxO15nwpR0xdUkL8+pyKCrMPv5U6ZMzdys89n1iMddFw91hO7FciMTrwooQkR7zbM39Y85RH9EIYKhxfDJIzoEVBGwsjQELPs0LuTPKkfK//OQBxUfi/dl0Wk/nyNbwvZi3GumYr6WYl95M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208838; c=relaxed/simple;
	bh=whFp1UBQhxJud91IsjNiV7shtgNlvI75akS6vcMq0qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NldFGothJgazR9MIYws+UR5LYZgP2xCIGbSVlAWGkJRYs03N1DVGBKr6po3aNNoH/+UPBh+C/u4sPKd+vVm/pbWAkPfGY5T4SKn2JIxXeyafZHBkzy4Sxwtrb+7BB1Fgllm2Lvk6Uw+fxHVIia8P6ue1vJA27TKQztg23Q4Dqr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YxE9nP/f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YxE9nP/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87A21F000FF;
	Sat, 12 Sep 2026 10:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208837;
	bh=bNohCbrx4xAqr5+95q4x20095uRoti5nsT17cjzTrrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YxE9nP/fW0FaJAZbuHQrBucP0RDrMPhzHrDKPZL8iLz8FZkZ1dMZbeDixYTSfxvUC
	 j72UoxjGtnQF2HDOkiTczASWkOqPfMBStdQuRZ0qg5VjrbuZWIVlY4WLq8alP1KSSK
	 k8o50umvdSqBrnZ6yC6eLaGUpJuIScSeX9gd1+Oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0700/1518] arm64: dts: qcom: qcs6490-rb3gen2: Fix the PCIe iommu-map entries
Date: Sat, 12 Sep 2026 08:47:49 +0200
Message-ID: <20260912065639.269425056@linuxfoundation.org>
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

[ Upstream commit 485dc5e557a8fef1374669f4ebe027c947187325 ]

The IOMMU provider apps_smmu uses '#iommu-cells = <2>', but the PCIe
iommu-map entries specify only one cell for the SID, omitting the SID
mask. This went unnoticed until the OF core started warning with commit
ccb2fd725d41 ("of: Respect #{iommu,msi}-cells in maps"):

  iommu-map has 1-cell entries targeting 2-cell #iommu-cells, treating as 1-cell output

So fix the entries to match the provider's '#iommu-cells' property.

Fixes: 267643b3e3a4 ("arm64: dts: qcom: qcs6490-rb3gen2: Add PCIe nodes")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260730-iommu-map-fix-v1-21-83405d37ba41@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts b/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts
index 18cea88120014..6be927c18482f 100644
--- a/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts
+++ b/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts
@@ -823,15 +823,15 @@ &pcie1 {
 	pinctrl-0 = <&pcie1_reset_n>, <&pcie1_wake_n>, <&pcie1_clkreq_n>;
 	pinctrl-names = "default";
 
-	iommu-map = <0x0 &apps_smmu 0x1c80 0x1>,
-		    <0x100 &apps_smmu 0x1c81 0x1>,
-		    <0x208 &apps_smmu 0x1c84 0x1>,
-		    <0x210 &apps_smmu 0x1c85 0x1>,
-		    <0x218 &apps_smmu 0x1c86 0x1>,
-		    <0x300 &apps_smmu 0x1c87 0x1>,
-		    <0x400 &apps_smmu 0x1c88 0x1>,
-		    <0x500 &apps_smmu 0x1c89 0x1>,
-		    <0x501 &apps_smmu 0x1c90 0x1>;
+	iommu-map = <0x0 &apps_smmu 0x1c80 0x0 0x1>,
+		    <0x100 &apps_smmu 0x1c81 0x0 0x1>,
+		    <0x208 &apps_smmu 0x1c84 0x0 0x1>,
+		    <0x210 &apps_smmu 0x1c85 0x0 0x1>,
+		    <0x218 &apps_smmu 0x1c86 0x0 0x1>,
+		    <0x300 &apps_smmu 0x1c87 0x0 0x1>,
+		    <0x400 &apps_smmu 0x1c88 0x0 0x1>,
+		    <0x500 &apps_smmu 0x1c89 0x0 0x1>,
+		    <0x501 &apps_smmu 0x1c90 0x0 0x1>;
 
 	status = "okay";
 };
-- 
2.53.0



