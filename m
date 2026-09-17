Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7164F5E0E;
	Thu, 17 Sep 2026 17:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666841; cv=none; b=daQEb8HKUm13JzZ/c7Y18SbHvaYAbFVn09Phzwk2LxFp/1kA9E4yZS51J+tyvJN+X+yQAk9FeBSr5+vqr8o+8CjOK0ELlhl8pi996y5MiyXAxMaaz2HH0m6e5AwEa32q0plBCRV7mVa6qJ7Ci5MTHVwbYHwb4uPGjCje7QXd6NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666841; c=relaxed/simple;
	bh=QUr+TVf3YSQCM6l6Ar2aX5eDVGE3CrM7Gj1fxNvuM/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+i+/bvWfDZlPxKAArbteyoosFrk48VuGmMgWcDg95H9gVibVWNQNEJ9+AkmK5mn6uE8EmzcHADUyNfny3FE99dqgPnw2E+ljijxfzvLgQVViWeeCbme1rQAfy3uJEbgT/ZZMvFJUmDpi/SX3fg7GAWiDCBX1p9FuEXso24dBrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=awGQGCRI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="awGQGCRI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD461F000FF;
	Thu, 17 Sep 2026 17:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666839;
	bh=ygf9lc+1MuaMQtXZ6VGLYEM9oiDtLECVdbWolZx5xo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=awGQGCRIKEKnqDw95SFswH+66wzlVKguT8iq0ej2rXfTz+roRGRQM5mQmtKeCf/lE
	 wpUg0K83G5kgLVzhaxTUX77yV6xhHY8pnKI41JH8kyZfrWP1zhcQk2ewXyREBaQJ8z
	 s/Vrf+e5M4rNWp/onAPByP6A+61lGOPiw/3PS00M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1141/1250] Revert "arm64: dts: qcom: sm8150: Fix the PCIe iommu-map entries"
Date: Thu, 17 Sep 2026 16:15:36 +0100
Message-ID: <20260917151623.179757484@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

This reverts commit 152e82a60d70e6da88d784b305bae6f9171aca9f.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8150.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index 35981d6026b3c..e1f480e3ed0b7 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -1884,8 +1884,8 @@ pcie0: pcie@1c00000 {
 				      "bus_slave",
 				      "slave_q2a";
 
-			iommu-map = <0x0   &apps_smmu 0x1d80 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1d81 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1d80 0x1>,
+				    <0x100 &apps_smmu 0x1d81 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -2002,8 +2002,8 @@ pcie1: pcie@1c08000 {
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



