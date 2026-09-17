Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AC74078D3;
	Thu, 17 Sep 2026 18:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671415; cv=none; b=QQ3o29DkBr03ItFL4y6mh6/LuTL9YD4pztJJ4qWJs0pA98/INlPMNkV4lv89ozkgxWm6QOH2mxTDur2ss+M+FHpNCmxN4Qwe83zGyr7mW3BJYuesMUcRc6goxRijdwFEoxEeSXZiLf3S+j4gyMjBaB3F8u7o32k8Hdsp3oxSp+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671415; c=relaxed/simple;
	bh=4r2Bef0m+J4AhV9QBzVB+8XC+CWYXcityx8OHxsVSws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6NHvh25wE8aQiPzGWIEflhQT0TGHyAveo1qSVzkzsQXF0Uj0JvjnRTfNxLCjeVW0IpFfsqrZ6PQvrFnyRgVqabcfcW5uIwMYrjMHl1LP+tABZafLrUeNDoARM2wSyLAxq5i05u8cvxpfm0sUEmLUVo83icbpL0I6w5BXoZwEsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oXXCP0/M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oXXCP0/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE311F000FF;
	Thu, 17 Sep 2026 18:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671414;
	bh=pxb56bbpAf4+bIf7Ffl3tGbMZXt2i3lBkHSDq4qaSPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oXXCP0/MyvHVu+Dd7F1arRKRz0eoEFCN1SMHYAhYfvbKUeJNY8aIfs88lKdMqeAvP
	 NgWTbVCdf+iDVNn0IdKvOKT9k72jJGP7gv7x3W96CFsoQ9PBqzoRVCZkh/Rr2ih9JI
	 /lrHAS4vbPcip2RcrC/oicwdviZTULPR4VstU8so=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0929/1102] Revert "arm64: dts: qcom: sm8150: Fix the PCIe iommu-map entries"
Date: Thu, 17 Sep 2026 16:14:32 +0100
Message-ID: <20260917151603.959602235@linuxfoundation.org>
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

This reverts commit 325dd20f79eb9744165bd5d5a8a5b20e2c884409.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8150.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index e06f7782b551c..0aeceffd872c0 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -1885,8 +1885,8 @@ pcie0: pcie@1c00000 {
 				      "tbu",
 				      "ref";
 
-			iommu-map = <0x0   &apps_smmu 0x1d80 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1d81 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1d80 0x1>,
+				    <0x100 &apps_smmu 0x1d81 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -2005,8 +2005,8 @@ pcie1: pcie@1c08000 {
 			assigned-clocks = <&gcc GCC_PCIE_1_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommu-map = <0x0   &apps_smmu 0x1e00 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1e01 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1e00 0x1>,
+				    <0x100 &apps_smmu 0x1e01 0x1>;
 
 			resets = <&gcc GCC_PCIE_1_BCR>;
 			reset-names = "pci";
-- 
2.53.0



