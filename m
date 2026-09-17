Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D742B4E0B66;
	Thu, 17 Sep 2026 18:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671296; cv=none; b=rVMfhC73Mem+RX2FjhoH0FzN8Witw2lM1Iau6dLquyc6WSw9MfPcfpM4IxjDuq94i5xTTPP2R0L1mbey0b2Isa+kBbsJwmxRFhX9m9G3jRib/Mkda0CfpadViF3s8XOUFN2jmjVU1rdXfp6x7XmxybGDjvbUE/jQtdPNnIZY8DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671296; c=relaxed/simple;
	bh=j6M/ObDq38gSYcWNY2GgPnFQKRCgsq7+x0XPozibpVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPlOGxzzKcbGAgEiP0PqxjzVWxTLeBPci1B+BymT3geImBJMXwDv3HCbVZS47zAM1wdf27AaAn38RlbgVs5f5ISlTjLBlt28xZbe0fgJkpiPoAwOOnUaMKJWTpj5kOA11FrN1zc+dYn+v86RWyPTmXXLK+xdfArPDfXOSEXxaMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lV5PXsxt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lV5PXsxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337C41F000FF;
	Thu, 17 Sep 2026 18:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671294;
	bh=bhjA/CDzu//gupMoRTFufXB1PyYcDlAvqA68wTGd1A4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lV5PXsxtDZFAtOtTkm796jaOLKNjiS/t1OvivYIWeGljrppZFgmcVeLbPqLOqdGzP
	 J89o+KXNLzpFa+QfYaBVfLWVBZXxOrHj4ceEfXAdxnhVpBktdGOOqSBo3z64i6ZFZ5
	 FMHJu0P9YTqbFWTLbYzb1b+unxxSD51KvdZG3CkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0930/1102] Revert "arm64: dts: qcom: sdm845: Fix the PCIe iommu-map entries"
Date: Thu, 17 Sep 2026 16:14:33 +0100
Message-ID: <20260917151603.985128038@linuxfoundation.org>
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

This reverts commit 8650c1d92827fd0cce68f0969067fac10b269292.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 64 ++++++++++++++--------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index 0653bccf50491..54956ae1f6745 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -2350,22 +2350,22 @@ pcie0: pcie@1c00000 {
 				      "slave_q2a",
 				      "tbu";
 
-			iommu-map = <0x0   &apps_smmu 0x1c10 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1c11 0x0 0x1>,
-				    <0x200 &apps_smmu 0x1c12 0x0 0x1>,
-				    <0x300 &apps_smmu 0x1c13 0x0 0x1>,
-				    <0x400 &apps_smmu 0x1c14 0x0 0x1>,
-				    <0x500 &apps_smmu 0x1c15 0x0 0x1>,
-				    <0x600 &apps_smmu 0x1c16 0x0 0x1>,
-				    <0x700 &apps_smmu 0x1c17 0x0 0x1>,
-				    <0x800 &apps_smmu 0x1c18 0x0 0x1>,
-				    <0x900 &apps_smmu 0x1c19 0x0 0x1>,
-				    <0xa00 &apps_smmu 0x1c1a 0x0 0x1>,
-				    <0xb00 &apps_smmu 0x1c1b 0x0 0x1>,
-				    <0xc00 &apps_smmu 0x1c1c 0x0 0x1>,
-				    <0xd00 &apps_smmu 0x1c1d 0x0 0x1>,
-				    <0xe00 &apps_smmu 0x1c1e 0x0 0x1>,
-				    <0xf00 &apps_smmu 0x1c1f 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c10 0x1>,
+				    <0x100 &apps_smmu 0x1c11 0x1>,
+				    <0x200 &apps_smmu 0x1c12 0x1>,
+				    <0x300 &apps_smmu 0x1c13 0x1>,
+				    <0x400 &apps_smmu 0x1c14 0x1>,
+				    <0x500 &apps_smmu 0x1c15 0x1>,
+				    <0x600 &apps_smmu 0x1c16 0x1>,
+				    <0x700 &apps_smmu 0x1c17 0x1>,
+				    <0x800 &apps_smmu 0x1c18 0x1>,
+				    <0x900 &apps_smmu 0x1c19 0x1>,
+				    <0xa00 &apps_smmu 0x1c1a 0x1>,
+				    <0xb00 &apps_smmu 0x1c1b 0x1>,
+				    <0xc00 &apps_smmu 0x1c1c 0x1>,
+				    <0xd00 &apps_smmu 0x1c1d 0x1>,
+				    <0xe00 &apps_smmu 0x1c1e 0x1>,
+				    <0xf00 &apps_smmu 0x1c1f 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -2464,22 +2464,22 @@ pcie1: pcie@1c08000 {
 			assigned-clocks = <&gcc GCC_PCIE_1_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommu-map = <0x0   &apps_smmu 0x1c00 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1c01 0x0 0x1>,
-				    <0x200 &apps_smmu 0x1c02 0x0 0x1>,
-				    <0x300 &apps_smmu 0x1c03 0x0 0x1>,
-				    <0x400 &apps_smmu 0x1c04 0x0 0x1>,
-				    <0x500 &apps_smmu 0x1c05 0x0 0x1>,
-				    <0x600 &apps_smmu 0x1c06 0x0 0x1>,
-				    <0x700 &apps_smmu 0x1c07 0x0 0x1>,
-				    <0x800 &apps_smmu 0x1c08 0x0 0x1>,
-				    <0x900 &apps_smmu 0x1c09 0x0 0x1>,
-				    <0xa00 &apps_smmu 0x1c0a 0x0 0x1>,
-				    <0xb00 &apps_smmu 0x1c0b 0x0 0x1>,
-				    <0xc00 &apps_smmu 0x1c0c 0x0 0x1>,
-				    <0xd00 &apps_smmu 0x1c0d 0x0 0x1>,
-				    <0xe00 &apps_smmu 0x1c0e 0x0 0x1>,
-				    <0xf00 &apps_smmu 0x1c0f 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c00 0x1>,
+				    <0x100 &apps_smmu 0x1c01 0x1>,
+				    <0x200 &apps_smmu 0x1c02 0x1>,
+				    <0x300 &apps_smmu 0x1c03 0x1>,
+				    <0x400 &apps_smmu 0x1c04 0x1>,
+				    <0x500 &apps_smmu 0x1c05 0x1>,
+				    <0x600 &apps_smmu 0x1c06 0x1>,
+				    <0x700 &apps_smmu 0x1c07 0x1>,
+				    <0x800 &apps_smmu 0x1c08 0x1>,
+				    <0x900 &apps_smmu 0x1c09 0x1>,
+				    <0xa00 &apps_smmu 0x1c0a 0x1>,
+				    <0xb00 &apps_smmu 0x1c0b 0x1>,
+				    <0xc00 &apps_smmu 0x1c0c 0x1>,
+				    <0xd00 &apps_smmu 0x1c0d 0x1>,
+				    <0xe00 &apps_smmu 0x1c0e 0x1>,
+				    <0xf00 &apps_smmu 0x1c0f 0x1>;
 
 			resets = <&gcc GCC_PCIE_1_BCR>;
 			reset-names = "pci";
-- 
2.53.0



