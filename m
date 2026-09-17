Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27C0515888;
	Thu, 17 Sep 2026 17:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666838; cv=none; b=qvmPwWf0F7mjJdeKCJqy84dCt+qTS+A5f8b5vakEIOD4c+3odkkPsCMf7Wi8qtWfqTARLRYqAcdfuFvnp3hELoCUnfc5sXP49JJuweDsDVtQmYhZqKpvHqDmOpnNdxVTRqEGmzVi5CnZsPcjWb02xpO4q5DnEQ1sgJA8aWc1wco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666838; c=relaxed/simple;
	bh=0uRth80pe+tb6Q5YcClofqa19zHDtBV/iAeAuxKC8So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ixah/db/Rnfkbsq15T1G7VhmXvAHAUWtMGaA8rD1pQMluTbtMAfnBZrqsDGm+kRb0DHxqipih61vcrvm6ZHLrbswYxdPJOebUWo/m2jLKJ3cJRqpOgIXhQlcBdkxtXytfuXKU9DMXbUeE01g4CQdS9JSUVc0QeVuuRfSQCwi5Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WjYEjZKK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WjYEjZKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A0D31F000FF;
	Thu, 17 Sep 2026 17:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666836;
	bh=j7VGu1OPlowp/BEXA2ZvayR0XKcEr9psbxiPOyGYjmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WjYEjZKKg7QOYBlsTnDyEF4ypkTP9/be/0YOpfTiPEl0oX7oFmXQAss86ocrfqTJV
	 6ZapbEdkP99QGSB46o+BBrKSBB1mYCPbtIctScjhWQLVWoLU/YmYTNUEpx5jSB12s+
	 BCNowoD8ODE0KrTrvCvCWVgIiNJy0JwV3QmXahEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1140/1250] Revert "arm64: dts: qcom: sm8250: Fix the PCIe iommu-map entries"
Date: Thu, 17 Sep 2026 16:15:35 +0100
Message-ID: <20260917151623.150876367@linuxfoundation.org>
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

This reverts commit c8fd2cabd0b7c1cf68ca1d78cd23e71e245ae032.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index 26ae05ab663c6..dfba5bc3ba7cf 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -2190,8 +2190,8 @@ pcie0: pcie@1c00000 {
 				      "tbu",
 				      "ddrss_sf_tbu";
 
-			iommu-map = <0x0   &apps_smmu 0x1c00 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1c01 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c00 0x1>,
+				    <0x100 &apps_smmu 0x1c01 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -2317,8 +2317,8 @@ pcie1: pcie@1c08000 {
 			assigned-clocks = <&gcc GCC_PCIE_1_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommu-map = <0x0   &apps_smmu 0x1c80 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1c81 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c80 0x1>,
+				    <0x100 &apps_smmu 0x1c81 0x1>;
 
 			resets = <&gcc GCC_PCIE_1_BCR>;
 			reset-names = "pci";
@@ -2444,8 +2444,8 @@ pcie2: pcie@1c10000 {
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



