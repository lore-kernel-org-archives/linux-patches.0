Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD6D4E4C4B;
	Thu, 17 Sep 2026 17:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666835; cv=none; b=WPycUClkOwi9rjWrmZFz1dAo0UgEAaEpwE8lwp6QkwWy3OdOAfSzzh441WaWHvCEE3fE9daBknE2gVH+sqC8V0fylKclAvEGJWqj7tiwXzhIdOr0zcVUvABEsKLpC9bxhNPrEFWEJgjbKOEEwimgruaqRbEwEkSTvKY/0ooN9Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666835; c=relaxed/simple;
	bh=QPmiCYIzNGOmTCx6ZFSXTk+SJXvMttVFIDPDd1PffWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uqH9y4BZbhLM6UzGP76HFoUsa6Q/pPXbAKwzvaeP70JF0QEwIyAF4EZukdL3J23o4FmpD9CBSXkU8IYc10a5rH329+M3yqdcnDZR85/LK3xj+rhjwJGKtWSOjtoTLb7l9AYOEpHX7lefGde1X9yTnTC2Wc6wvG7Y/rKE62BIaUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T6feq/Td; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T6feq/Td"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4711F000FF;
	Thu, 17 Sep 2026 17:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666833;
	bh=jAQiK9Ph9AwPrxRrLd4Vfzv92K7E1u2suGu8Qzehmxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T6feq/Tdb3np42g5/sl/AFvKhEhws1i9SCTMibu+tm9oz6gZAKhy+Y6bvRWdnOHoH
	 ft8V11SP6Q05YFCDaE4Hk6lEPKWom4GyjFYsKGXhas97oAKbgRMUc3aHheaehEUVzp
	 YNcBTxU2ettDoruLGgm5NqsHbnAqknTb0GZVN9MA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1139/1250] Revert "arm64: dts: qcom: sm8350: Fix the PCIe iommu-map entries"
Date: Thu, 17 Sep 2026 16:15:34 +0100
Message-ID: <20260917151623.122731376@linuxfoundation.org>
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

This reverts commit 793dbaa91c3bfbd099b132cc4b8bb6e7856aa3e3.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index 2bbc1f28be88b..af892b76322fd 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -1575,8 +1575,8 @@ pcie0: pcie@1c00000 {
 				      "aggre1",
 				      "aggre0";
 
-			iommu-map = <0x0   &apps_smmu 0x1c00 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1c01 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c00 0x1>,
+				    <0x100 &apps_smmu 0x1c01 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -1684,8 +1684,8 @@ pcie1: pcie@1c08000 {
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



