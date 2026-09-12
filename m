Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD245361DDC;
	Sat, 12 Sep 2026 08:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200576; cv=none; b=P3iT5G3/QzRL1q2kZnO/85Nrq7r90j4dBbBL39LUuCKW3S5ubd8MWPhXKrULlGbyyJK6pbVf8YTRjhgO7Ztp5HHHrIDH7qMZH2Xv6WwgJY20YIgs6uvJNwx9cjIOWE2S3rbbgdU11otaottbVBVoXoW1S/gdj0tft2rhIOJL5wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200576; c=relaxed/simple;
	bh=zVLnY+29KYEusYpA3vEk6Nyd0MJdLgqw8A01LSEU08I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNTTJMvOk+WE8BQOj3vL+ZLcLsX3TBHu23Wud2Dy3cgOpglqbPxDF2/ZdvYns7ttAjPggVE655qF+uutMcjWMg5KnkqWsxotZEkFQGvWYb0X9mUhB+gMhWetN0pKgMW7RSfNVKMG85MKRNyHNFwHayvrVt6vomhXqQEM7trT+XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iPNwGqvE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iPNwGqvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05581F000FF;
	Sat, 12 Sep 2026 08:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200575;
	bh=/AZyZaxBB3wvSm/5iqerzKo4GgSW4w6cnZYRM27BWYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iPNwGqvEdVTcBebqM+Ew3acNEosOHdK6yOLGYh78tFuqXy+1ckxcS5gFCpUAzEeF9
	 3chnZ/5TOWxIr7rm4ePCgwH9kSZKEV7NAULDCJw8iRB/ODttOaV//S4buEB8GvErS0
	 znvfRpuCHevvp8OpvmWZhDGAZGMdBZ1S6xEEXHkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0816/1815] arm64: dts: qcom: qcs6490-rb3gen2: Fix the PCIe iommu-map entries
Date: Sat, 12 Sep 2026 08:42:46 +0200
Message-ID: <20260912065708.068794996@linuxfoundation.org>
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
index 37a3b51323ce5..03fe7d58f6bfe 100644
--- a/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts
+++ b/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts
@@ -846,15 +846,15 @@ &pcie1 {
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



