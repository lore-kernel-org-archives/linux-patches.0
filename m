Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3DF3515D1;
	Wed, 30 Sep 2026 16:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785561; cv=none; b=a88btBGJ/LCGSBFxpvdVRzsQSSAx2YrljB20ms+pNsQ4j5JNYfthRDnzOtMVu8gZkaDSUVLnFLpRXr221FKHbDposgbgYeBUMbXh62JmS0x3KtECFhbScqZiTtYh7etDveRocRw6eDUKAU/hoQdqQ7yahu1w4syRoC6OF8NmybM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785561; c=relaxed/simple;
	bh=VVhG8MaNtUraN+qHCOLWBQbSRndqDNnyMf8NHTo20HA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RmCF5STyhScCVdKCndRB5HLn0JvnhP9S2PUWVf2VDAqrlpjf3YP6l24YRQMcxk1+CFHWOKJCOlC1MkSyJhx5eyo1ovMo1meiucTTuAMi1pgoILFgdQzmcC5ksUlnbQ70i3LmupFSabMrs/n49cWBbtirGJbeT8dZompPJ+55cJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P9QhxCkh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P9QhxCkh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3572D1F00893;
	Wed, 30 Sep 2026 16:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785551;
	bh=KfOC5EweutJrLDhhIow//8sE+sQgc68NNTLDLy9MJXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P9QhxCkhTs5t7YravM3l0usL8cckr85IpmK495otZURm5k5FBphENPmKlXhudHLR0
	 0/ba5zDwBS8L5xHyXXYapf1CyziyhShPezGu2XIbUFv5CGdx4eKawxB/gJ8xw/GsyV
	 X6codkZiFenQE2tNDAZpL6/GRmNNaWjK+/PXAZ6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 550/982] Revert "arm64: dts: qcom: sm8450: Fix the PCIe iommu-map entries"
Date: Wed, 30 Sep 2026 17:21:26 +0200
Message-ID: <20260930152428.584794670@linuxfoundation.org>
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

This reverts commit 2eec945bc94f35ae597e4ce49bc4f4b581ee82a0.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index 4911f2be3e7c7..653998706b7ff 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -1759,8 +1759,8 @@ pcie0: pci@1c00000 {
 				      "aggre0",
 				      "aggre1";
 
-			iommu-map = <0x0   &apps_smmu 0x1c00 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1c01 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c00 0x1>,
+				    <0x100 &apps_smmu 0x1c01 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -1865,8 +1865,8 @@ pcie1: pci@1c08000 {
 				      "ddrss_sf_tbu",
 				      "aggre1";
 
-			iommu-map = <0x0   &apps_smmu 0x1c80 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1c81 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c80 0x1>,
+				    <0x100 &apps_smmu 0x1c81 0x1>;
 
 			resets = <&gcc GCC_PCIE_1_BCR>;
 			reset-names = "pci";
-- 
2.53.0



