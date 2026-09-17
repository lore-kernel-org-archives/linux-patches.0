Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A05F4F93DE;
	Thu, 17 Sep 2026 17:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666829; cv=none; b=P9Vaklge68zcmIXF+SLXaQZ9c6OB18re1av5OYg2720SqEvj84w6fQvV7B23ZefddZvlcuK+ioG+kICOrJ4vxJ9qDybBecxN04yFPMLSTV3d3kaqVxDHkDrhfzzQGhXpwrfOIqgOp9NKnjPbE+5munWZP7m5qNooAa0c/IuD8cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666829; c=relaxed/simple;
	bh=6isCj7vtCxAnqB2l2DbBKsQHdoy6rHgtdGUz6kynkxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=caFQwkrZjPRU6dOqadoscpuGZCtwJm4Pfx/YH+1vELAGllviWMresp2l1+vFgEYnT29nU2WxaSFwUw1a2a68LcgnpxudE08fdBc8D4kAEB8IYRL/iLjY63L6kk/Djnb0ugpHfIfccBR/uoEXxHbLHp2+phay1LQP7jMR25jRwlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fKpw4DQY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fKpw4DQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D00E1F000FF;
	Thu, 17 Sep 2026 17:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666827;
	bh=IPzizOLn4oW9TAFNQVY0D5BG2JckjOGuA/uPQa8Tk9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fKpw4DQYOAJrDym38D8ABnYltfivJXQU59L53O83nkCGs7hjbD91vz/qLD4StEj+0
	 vyo8d2AiODYHiGZ3jZbVBWEgJ5/YuzZsuhVqGBVcjUGGCsariuSh6bfku1X+XhqNCb
	 D5Y4dRJEBpCxXS4lxmudsYG5rtIh5OLeQz8FFpFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1137/1250] Revert "arm64: dts: qcom: sm8550: Fix the PCIe iommu-map entries"
Date: Thu, 17 Sep 2026 16:15:32 +0100
Message-ID: <20260917151623.066685979@linuxfoundation.org>
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

This reverts commit e8a7928da474e5e944f4747b096cc8515b3ffb73.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index e38d3ea19e7dd..479c94f5066f3 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -2009,8 +2009,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 
 			msi-map = <0x0 &gic_its 0x1400 0x1>,
 				  <0x100 &gic_its 0x1401 0x1>;
-			iommu-map = <0x0   &apps_smmu 0x1400 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1401 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1400 0x1>,
+				    <0x100 &apps_smmu 0x1401 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -2175,8 +2175,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 
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



