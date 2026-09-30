Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA27363C6C;
	Wed, 30 Sep 2026 19:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795783; cv=none; b=SP+dPg7YED538QkXkAG0ZxnMBeKLR5yKT/MRcWW+ctDxTqJCrxcwkOIzkPObSk6KHmClrOix5D96yb7e6/lTV0teZwvtSDcLhYr7o/NN5CXoWBiu6t36TEiFyWkhQYFPAy9r0yEHLCkq01u0KmgccTK4Md1UjC1HQhP8xUtRoiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795783; c=relaxed/simple;
	bh=WtjenT6CHZtIV3UBePmudvq+ZcJKn5McPKaCiONutLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GBMWux9JJroKXRdqHWkygZ1q9vCY7m5tAGetkwlDGLw0xSj5CZN+27xF0mJsWfVsUd4Qrxm9ScfFhHKQlCVUuFsVKHu4ucJPM84tW/QnOzP3YpzyplkajEmIOG0Xtu87OfYL/ICYPXrNwUzv+QhB8q5IOppwQv4YlR8ZPmQFDEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OgU2TO46; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OgU2TO46"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA501F000FF;
	Wed, 30 Sep 2026 19:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795782;
	bh=cLys2QfATgWVglXyHDYzu3Q+ZSSaDt1snWIwHB/a0AE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OgU2TO46SoGUMs/miKwvuyQ3Pufsm54XmsjhEB22MRWUXoQylFLgnUh6HU2jp/pZt
	 eYUGkUxakdyj0Kuj6G3sKR+MqHbF01VSsMYbtj1oyzLnlpBk0iun870L9Lh5DDv8Ae
	 jF92nm6upVx9LiooumGpP1A7q6k3QuZx0KPZxmKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0682/1193] Revert "arm64: dts: qcom: sc8180x: Fix the PCIe iommu-map entries"
Date: Wed, 30 Sep 2026 17:22:46 +0200
Message-ID: <20260930152449.397344817@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

This reverts commit 31db9b8610e3fe6367cca8e5aca23953ecaf1efa.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8180x.dtsi | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8180x.dtsi b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
index 83a78c159027a..26414e41f32cc 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
@@ -1745,8 +1745,8 @@ pcie0: pci@1c00000 {
 			assigned-clocks = <&gcc GCC_PCIE_0_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommu-map = <0x0   &apps_smmu 0x1d80 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1d81 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1d80 0x1>,
+				    <0x100 &apps_smmu 0x1d81 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -1842,8 +1842,8 @@ pcie3: pci@1c08000 {
 			assigned-clocks = <&gcc GCC_PCIE_3_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommu-map = <0x0   &apps_smmu 0x1e00 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1e01 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1e00 0x1>,
+				    <0x100 &apps_smmu 0x1e01 0x1>;
 
 			resets = <&gcc GCC_PCIE_3_BCR>;
 			reset-names = "pci";
@@ -1940,8 +1940,8 @@ pcie1: pci@1c10000 {
 			assigned-clocks = <&gcc GCC_PCIE_1_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommu-map = <0x0   &apps_smmu 0x1c80 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1c81 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c80 0x1>,
+				    <0x100 &apps_smmu 0x1c81 0x1>;
 
 			resets = <&gcc GCC_PCIE_1_BCR>;
 			reset-names = "pci";
@@ -2038,8 +2038,8 @@ pcie2: pci@1c18000 {
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



