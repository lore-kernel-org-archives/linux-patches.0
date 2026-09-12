Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2387237F74C;
	Sat, 12 Sep 2026 08:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200582; cv=none; b=LMCA8APInzlygu6flURkZxkEx9xXXWk5sfBABtpYNg8Y0giC9YkVaciWP0Xe/hdIRQS6BGWMb2thEObmgQjZxyFxOO6wuRbV8gbAr2skp8aINEBBBMRbqz5PDrwzX+9IKYRTE2SZxRjjA3/3JwRpFjCNWPgBnedU7tTYplpRLyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200582; c=relaxed/simple;
	bh=cZluXbICu+gVTEYu//6Y5oR5nZIZXL6/NBtYF6cUTXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oq2VdD44/4ugO1ILSxV1EHji9ZKGpO9Q9UktfkauUrv10Zkt0t9YahQvKoDjkZNQi1Hms+a1wFMRUJdcU01hqNFa8lLtkY7W5BRCMrgoSmVvx3NwYwJpQIY0tXEOChJD3UIEb8uMYdRHkhn7ZIN8UR1FJJA351SsEYM6iJDezJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yqTBjP8B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yqTBjP8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6ACD1F000FF;
	Sat, 12 Sep 2026 08:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200580;
	bh=jSxzjrivIgtYuwX+gjAbC6QuhbA00aPupG7sFWYQVpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yqTBjP8BYTN1ErmN92RhxoItTMXejxky8kkqA0EnWbt8a7T7+ryJ7m+WtWsK359bF
	 E1DxKnj4tJiSRgdVkxvd9W5gWdu5h6cRpkXG0YEx1ZAOsBL+13EVT+gdEekg9wzGVm
	 VIc5ypABz/mgiFTdMM2Ai23ZWwoYgV2VuKb5ijok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0817/1815] arm64: dts: qcom: qcs6490-rb3gen2-industrial-mezzanine: Fix the PCIe iommu-map entries
Date: Sat, 12 Sep 2026 08:42:47 +0200
Message-ID: <20260912065708.092852435@linuxfoundation.org>
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

[ Upstream commit 770d1448435bca2b1cd00854dc9401320b584d5b ]

The IOMMU provider apps_smmu uses '#iommu-cells = <2>', but the PCIe
iommu-map entries specify only one cell for the SID, omitting the SID
mask. This went unnoticed until the OF core started warning with commit
ccb2fd725d41 ("of: Respect #{iommu,msi}-cells in maps"):

  iommu-map has 1-cell entries targeting 2-cell #iommu-cells, treating as 1-cell output

So fix the entries to match the provider's '#iommu-cells' property.

Fixes: 4559b435f741 ("arm64: dts: qcom: qcs6490-rb3gen2-industrial-mezzanine: Add TC9563 PCIe switch node for PCIe0")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260730-iommu-map-fix-v1-22-83405d37ba41@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../qcs6490-rb3gen2-industrial-mezzanine.dtso | 50 +++++++++----------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2-industrial-mezzanine.dtso b/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2-industrial-mezzanine.dtso
index 83908db335afa..14c64439ae1e6 100644
--- a/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2-industrial-mezzanine.dtso
+++ b/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2-industrial-mezzanine.dtso
@@ -54,15 +54,15 @@
 	pinctrl-0 = <&pcie0_reset_n>, <&pcie0_wake_n>, <&pcie0_clkreq_n>;
 	pinctrl-names = "default";
 
-	iommu-map = <0x0 &apps_smmu 0x1c00 0x1>,
-		    <0x100 &apps_smmu 0x1c01 0x1>,
-		    <0x208 &apps_smmu 0x1c04 0x1>,
-		    <0x210 &apps_smmu 0x1c05 0x1>,
-		    <0x218 &apps_smmu 0x1c06 0x1>,
-		    <0x300 &apps_smmu 0x1c07 0x1>,
-		    <0x400 &apps_smmu 0x1c08 0x1>,
-		    <0x500 &apps_smmu 0x1c09 0x1>,
-		    <0x501 &apps_smmu 0x1c10 0x1>;
+	iommu-map = <0x0 &apps_smmu 0x1c00 0x0 0x1>,
+		    <0x100 &apps_smmu 0x1c01 0x0 0x1>,
+		    <0x208 &apps_smmu 0x1c04 0x0 0x1>,
+		    <0x210 &apps_smmu 0x1c05 0x0 0x1>,
+		    <0x218 &apps_smmu 0x1c06 0x0 0x1>,
+		    <0x300 &apps_smmu 0x1c07 0x0 0x1>,
+		    <0x400 &apps_smmu 0x1c08 0x0 0x1>,
+		    <0x500 &apps_smmu 0x1c09 0x0 0x1>,
+		    <0x501 &apps_smmu 0x1c10 0x0 0x1>;
 
 	status = "okay";
 };
@@ -151,22 +151,22 @@
 };
 
 &pcie1 {
-	iommu-map = <0x0 &apps_smmu 0x1c80 0x1>,
-		    <0x100 &apps_smmu 0x1c81 0x1>,
-		    <0x208 &apps_smmu 0x1c84 0x1>,
-		    <0x210 &apps_smmu 0x1c85 0x1>,
-		    <0x218 &apps_smmu 0x1c86 0x1>,
-		    <0x300 &apps_smmu 0x1c87 0x1>,
-		    <0x408 &apps_smmu 0x1c90 0x1>,
-		    <0x410 &apps_smmu 0x1c91 0x1>,
-		    <0x418 &apps_smmu 0x1c92 0x1>,
-		    <0x500 &apps_smmu 0x1c93 0x1>,
-		    <0x600 &apps_smmu 0x1c94 0x1>,
-		    <0x700 &apps_smmu 0x1c95 0x1>,
-		    <0x701 &apps_smmu 0x1c96 0x1>,
-		    <0x800 &apps_smmu 0x1c97 0x1>,
-		    <0x900 &apps_smmu 0x1c98 0x1>,
-		    <0x901 &apps_smmu 0x1c99 0x1>;
+	iommu-map = <0x0 &apps_smmu 0x1c80 0x0 0x1>,
+		    <0x100 &apps_smmu 0x1c81 0x0 0x1>,
+		    <0x208 &apps_smmu 0x1c84 0x0 0x1>,
+		    <0x210 &apps_smmu 0x1c85 0x0 0x1>,
+		    <0x218 &apps_smmu 0x1c86 0x0 0x1>,
+		    <0x300 &apps_smmu 0x1c87 0x0 0x1>,
+		    <0x408 &apps_smmu 0x1c90 0x0 0x1>,
+		    <0x410 &apps_smmu 0x1c91 0x0 0x1>,
+		    <0x418 &apps_smmu 0x1c92 0x0 0x1>,
+		    <0x500 &apps_smmu 0x1c93 0x0 0x1>,
+		    <0x600 &apps_smmu 0x1c94 0x0 0x1>,
+		    <0x700 &apps_smmu 0x1c95 0x0 0x1>,
+		    <0x701 &apps_smmu 0x1c96 0x0 0x1>,
+		    <0x800 &apps_smmu 0x1c97 0x0 0x1>,
+		    <0x900 &apps_smmu 0x1c98 0x0 0x1>,
+		    <0x901 &apps_smmu 0x1c99 0x0 0x1>;
 };
 
 &pcie1_switch0_dsp1 {
-- 
2.53.0



