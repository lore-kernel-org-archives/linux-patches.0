Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6764E36D4;
	Thu, 17 Sep 2026 17:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666832; cv=none; b=P31vyHZqlTtsKGF8vU0fs5QXuACVEnci2BCkrN79deV8FbRpGjb/3LIJvZKnhvu1WHUc6t1yhVYe8HG8sD1alOUpoID+So+aa49gBsrEodOhRJ88bWCiWaYrH2zhJf7upScNwjlnOhJfE9oNAN5uMnLYQkeNa0pVkTr6wxwjOiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666832; c=relaxed/simple;
	bh=TokTIP/8DrJBCemdrNkvnwuIhft9jSYf+2Z9zw0PSDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXWXdFAQ6Izzf9vnKXxihV/btlS0Laq2M0e2NIl86uq3uPNUZcnQ5agPE4Yf5hp1MziQDz/YM1Y9xZwb7MpkLXCRddBH40Hb/14reHpl4fqhqNJcqWfcRyHTiJVNSt1x308/rx+8t2+4SSumv1rWteZsaVqUC+TMQQ2kVwTHVw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pvSNzbJp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pvSNzbJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC621F000FF;
	Thu, 17 Sep 2026 17:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666830;
	bh=zzzg71HZPPhMEDAB0OnsBKObALFSFFn1NTWpvi9QT4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pvSNzbJp5hPDw0c19DM1kWXTWzCqLbTo/A6JT4EfvFTD96o/uROz9cf4fuIPhqIe5
	 6pjt1uWhAve1CQsX5Ofx19195fLl/wM2hL6GBJ6rT+WTWRxEA0vGjuThDNRQgONBCL
	 vQqWnm/UnSQBpVOkJW5Ip3zbQURmFMN+B2UbWxVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1138/1250] Revert "arm64: dts: qcom: sm8450: Fix the PCIe iommu-map entries"
Date: Thu, 17 Sep 2026 16:15:33 +0100
Message-ID: <20260917151623.092939598@linuxfoundation.org>
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

This reverts commit dbcbbb2033736a203230f80fe317be3a8badd79b.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index cabd90b5024a3..991f3cbde1c8d 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -2023,8 +2023,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 				      "aggre0",
 				      "aggre1";
 
-			iommu-map = <0x0   &apps_smmu 0x1c00 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1c01 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c00 0x1>,
+				    <0x100 &apps_smmu 0x1c01 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -2185,8 +2185,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
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



