Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CB24A441D;
	Wed, 30 Sep 2026 16:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785562; cv=none; b=BIhtOVYBXJu+0EgoGs/i3kFH8XkJ1sHAwlaXgTunWWJYH47yWvsj/nUxFDjTKaCS2bEAMVg85cEjlkD1si2IPp097wvYqTqiw9Gj7ayFDbtqOqeVevY9tYi/AbAK3siV/bT+BG3S3VX48XYIKO4FtMgESGMZKwlctiuqbne1A9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785562; c=relaxed/simple;
	bh=105kzi4c1D5WAuCOgd3+wDptwVXyu6eyxafvNGPOb90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nRjLMxqximNdKpx6mJ0zMgdcTBYGnm4uYoewzlpTSwmawH0SnaECKGbf2/IKyZ/PWBd2Od0M7XNhzi61U61/tm+ZX679dSfiFsfMFptI12rdUqB5Uh8fI9HbAC8N0WFyXGCxyM2bH8ObUrG2ruFjHPw589UvPpMYwYP2eRtwSsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yru6iX+m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yru6iX+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50331F0089F;
	Wed, 30 Sep 2026 16:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785557;
	bh=qUohdxzrN/jA1eRPdP+m9TaDcPsydJmkRG2r35u8MyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yru6iX+moZY2LEtelqqoen9MeUUtm84ez423MIegUWx4Nl7V+zayH4DDYU28pG7hi
	 fesYqg1T1jv+NuhgX3NUG1TCU2ZIrqZ5aJsSS9oUSDbB8+dVJzTftfAkbWZJjHM59x
	 cg7MtSbIODO1WjSZpauo7q0r6BNKnRz5sOk0uH3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 552/982] Revert "arm64: dts: qcom: sm8250: Fix the PCIe iommu-map entries"
Date: Wed, 30 Sep 2026 17:21:28 +0200
Message-ID: <20260930152428.628372049@linuxfoundation.org>
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

This reverts commit 6a8666fc1c629863022899046f8c46f3bb45a68e.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index 7020f32e59d05..fbda1925f8e03 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -1850,8 +1850,8 @@ pcie0: pci@1c00000 {
 				      "tbu",
 				      "ddrss_sf_tbu";
 
-			iommu-map = <0x0   &apps_smmu 0x1c00 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1c01 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c00 0x1>,
+				    <0x100 &apps_smmu 0x1c01 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -1956,8 +1956,8 @@ pcie1: pci@1c08000 {
 			assigned-clocks = <&gcc GCC_PCIE_1_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommu-map = <0x0   &apps_smmu 0x1c80 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1c81 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c80 0x1>,
+				    <0x100 &apps_smmu 0x1c81 0x1>;
 
 			resets = <&gcc GCC_PCIE_1_BCR>;
 			reset-names = "pci";
@@ -2064,8 +2064,8 @@ pcie2: pci@1c10000 {
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



