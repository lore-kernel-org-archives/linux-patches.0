Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3343DAAC9;
	Thu, 17 Sep 2026 18:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671299; cv=none; b=CRVFv0ak6ISefaEPjruwUWDyhRLU4xODgEfk+j0wYfqo2qwzJY7n1MRHhgcFH/VIT7BPwgErGPzCnpdi/nkWERp/ydcdC6luuGopeeFoF3tcJIdHil3GM0osZc8SEBRl8o5uhBwtquQxEpmHssrnq3kctSnueC0CPNSB9d4BnMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671299; c=relaxed/simple;
	bh=TXVfG/mHD4zgomLnBFaLFJV34S8s7wyCXgK3nwO0FoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GzqljIHp+llgXuysGZfIyX8Dfx9M5fHQyhj9n1WrGkkHkWcBdhcS/hnkoNRixXBgOOHdM71Zvl1KCWtvWXV+9siqo/L+YZV1PdOVsOCYs9e/Jx1wX6mi8ZbsSTgKMzCTKP/B86gsGn9O/7t4OD7QNI0jw+eMkpEDc1/gxQfMB0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sLR9Wraz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sLR9Wraz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C901F000FF;
	Thu, 17 Sep 2026 18:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671297;
	bh=6oqYsXjdDn6tpHjF9UOLd3p9IuDjMd/qu2HCUqna8oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sLR9WrazfsyEGfVpTneqd6i8SKZBDxkfcYuWvanwpcmOn5JruR+Zsb+yC81Z4LgDn
	 hbJk7L/kqDXwVou+tPDjPZ65WLFrdkFvZh3SMHDLjzj/d0TaPfNIwT5gXt9KLPQMKM
	 nCMAKO9R+gySG3Djb3FVO6uRNG77XtWaSio+vjn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0931/1102] Revert "arm64: dts: qcom: sc8180x: Fix the PCIe iommu-map entries"
Date: Thu, 17 Sep 2026 16:14:34 +0100
Message-ID: <20260917151604.011423212@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 0936e21622b0862953174d573920720d439e43c5.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8180x.dtsi | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8180x.dtsi b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
index d3aed296e32cc..4715e26fc2647 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
@@ -1761,8 +1761,8 @@ pcie0: pcie@1c00000 {
 			assigned-clocks = <&gcc GCC_PCIE_0_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommu-map = <0x0   &apps_smmu 0x1d80 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1d81 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1d80 0x1>,
+				    <0x100 &apps_smmu 0x1d81 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -1882,8 +1882,8 @@ pcie3: pcie@1c08000 {
 			assigned-clocks = <&gcc GCC_PCIE_3_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommu-map = <0x0   &apps_smmu 0x1e00 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1e01 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1e00 0x1>,
+				    <0x100 &apps_smmu 0x1e01 0x1>;
 
 			resets = <&gcc GCC_PCIE_3_BCR>;
 			reset-names = "pci";
@@ -2004,8 +2004,8 @@ pcie1: pcie@1c10000 {
 			assigned-clocks = <&gcc GCC_PCIE_1_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommu-map = <0x0   &apps_smmu 0x1c80 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1c81 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c80 0x1>,
+				    <0x100 &apps_smmu 0x1c81 0x1>;
 
 			resets = <&gcc GCC_PCIE_1_BCR>;
 			reset-names = "pci";
@@ -2126,8 +2126,8 @@ pcie2: pcie@1c18000 {
 			assigned-clocks = <&gcc GCC_PCIE_2_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommu-map = <0x0   &apps_smmu 0x1d00 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1d01 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1d00 0x1>,
+				    <0x100 &apps_smmu 0x1d01 0x1>;
 
 			resets = <&gcc GCC_PCIE_2_BCR>;
 			reset-names = "pci";
-- 
2.53.0



