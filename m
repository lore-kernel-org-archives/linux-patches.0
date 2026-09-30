Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6213D9530;
	Wed, 30 Sep 2026 19:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795772; cv=none; b=VkdpgrXh/LvsP2WURb8UpHNhO4YcoeMKqyck1pse7xTautSYs/Yb92Uzmapl00nshRBEe6x0ld/4xK6no3GTTiHKvWPnjEI4IuJD2CvpMvZlsfsd4IeeeGTXezNTnKJWWmAehzjqXBOxJdkWLaephUxZE98HNrBRnceVwT+rcXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795772; c=relaxed/simple;
	bh=4WSzwhX/nADK3m6/8ngYg83Ycw/2yI6KZCkXeDe1kCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlAiGDIDeYGui08pfBB0TS9DgCnBZJ4NZRn5XVnFbqkHkQtg9uJA+fSSIitmi4y3Q4WmKjWCAFyayHNwc4PINg3LDS7ru+bDQNz91HEErDElrpXD5czOQuFlBZttg7bsfPULWXrBZ36k/nQ5FPIYmhqn959x3zPrdc3sehkKHd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Sig/WZ8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Sig/WZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B2E1F000FF;
	Wed, 30 Sep 2026 19:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795770;
	bh=QzCuBbxZsOD36gsKwjaANKMHR3D6nbh45SezwgklUNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Sig/WZ8M8NzMTblsX6QH65y3SeDVnQmlsbZWBNuxGZnu4h8PmzCxliHnpbefAcpn
	 yqUlO0tEdc4rTVokE9VbwT/2TD9yYcm5YbEO4bwRV5H6Vzc6SFVZ7iFWZqs8lJDjZH
	 TEzpoOkhk+t5jhSDbxvp7q3WvjafL6bwpRFEa7QI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0679/1193] Revert "arm64: dts: qcom: sm8250: Fix the PCIe iommu-map entries"
Date: Wed, 30 Sep 2026 17:22:43 +0200
Message-ID: <20260930152449.329360534@linuxfoundation.org>
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

This reverts commit 9dedefe9d949ad0ba21c3d30998623223aafc7dd.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index dd537ab1c6814..4fa5917690f16 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -1895,8 +1895,8 @@ pcie0: pci@1c00000 {
 				      "tbu",
 				      "ddrss_sf_tbu";
 
-			iommu-map = <0x0   &apps_smmu 0x1c00 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1c01 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c00 0x1>,
+				    <0x100 &apps_smmu 0x1c01 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -2002,8 +2002,8 @@ pcie1: pci@1c08000 {
 			assigned-clocks = <&gcc GCC_PCIE_1_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommu-map = <0x0   &apps_smmu 0x1c80 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1c81 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c80 0x1>,
+				    <0x100 &apps_smmu 0x1c81 0x1>;
 
 			resets = <&gcc GCC_PCIE_1_BCR>;
 			reset-names = "pci";
@@ -2111,8 +2111,8 @@ pcie2: pci@1c10000 {
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



