Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FAB5038F7;
	Wed, 30 Sep 2026 16:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785688; cv=none; b=ItLreFG/Sxytj2WK4Q1sloJbSlMLIVRJTYEVxN8JjbXA9JL1siS791IGp14in/IzOYjEnGadknCVCBWV547eOkvh5cTkYdCpymC1AZHNI4qYddt3MgtnlhIIZt4DJ8t/caLf+grCT0beNKEprCaObSg49cpNm+bXT+h//ETFa7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785688; c=relaxed/simple;
	bh=eTdm8Qiyvvt80mBK1y+vxrFoWZsR3hL5xODyjzX2hog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=adomn49y/cMQ/4oMz5CKtOzzQr0BRdmzZZ+Z7y6eT17rMAbQA44Y4wy24QJUHyL8J2HpzRXrbxihMKwaCP5jqiduhmIUqx4q1EpzVxTkm36RBiYoe+qUjlrLEvZIizyQ/iNPwozFLwrsbAGp0VqsEgjsvG2YZ6eHmpfsFgZH66E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c0YLeWGJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c0YLeWGJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE95C1F0089C;
	Wed, 30 Sep 2026 16:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785682;
	bh=b9aXjHZ7seHMyc6fC8rwFO+3FOB5bV9GlMJIhXBFv/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c0YLeWGJSb1VWkDQ3xGxGEvess1RPH3r4ImksuKUnVb/xUbrn3R/khBlsQLE91bKU
	 uzqmkgNIUPc9wcWhLgthcwPz3QxK9Fxow521LQvzl0CwgNZaSpUhYy/VWIdisrVwDM
	 8W0TIw2W3juizyT16IXSUxTLiJb51dEV6cE5Z38U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 549/982] Revert "arm64: dts: qcom: sm8550: Fix the PCIe iommu-map entries"
Date: Wed, 30 Sep 2026 17:21:25 +0200
Message-ID: <20260930152428.563687157@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

This reverts commit d831304f2079e114fa74e585bf667a83fdbc25c8.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index 45fb37bf08f66..18134a7e69745 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -1432,8 +1432,8 @@ pcie0: pci@1c00000 {
 
 			msi-map = <0x0 &gic_its 0x1400 0x1>,
 				  <0x100 &gic_its 0x1401 0x1>;
-			iommu-map = <0x0   &apps_smmu 0x1400 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1401 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1400 0x1>,
+				    <0x100 &apps_smmu 0x1401 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -1537,8 +1537,8 @@ pcie1: pci@1c08000 {
 
 			msi-map = <0x0 &gic_its 0x1480 0x1>,
 				  <0x100 &gic_its 0x1481 0x1>;
-			iommu-map = <0x0   &apps_smmu 0x1480 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1481 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1480 0x1>,
+				    <0x100 &apps_smmu 0x1481 0x1>;
 
 			resets = <&gcc GCC_PCIE_1_BCR>,
 				<&gcc GCC_PCIE_1_LINK_DOWN_BCR>;
-- 
2.53.0



