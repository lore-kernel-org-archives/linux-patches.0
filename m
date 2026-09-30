Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774844EA39C;
	Wed, 30 Sep 2026 16:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785563; cv=none; b=pafXTwX3TlLWGXtO1/fMgJBPQTklpOVyKyBEC5yjpkLrDrFZyyxExuescYmXLSzjpv5+IAIAr79vTSVFUA9IzfdDhXtJOKSjkjejBMD/JxAsBejmj3jP3cAhdQwG/4xMUUk1aKo3VcU/aiti2egqv9KbFuvh5NqhPk1d1JNdeLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785563; c=relaxed/simple;
	bh=1mLZEsccNRbgJqEmZJB8TgRcztJki5MPgNoziWCayTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZYKoCtAZjYFMKWR9mHqnGt8hOcjjzR3nGLv/64PdcsxxTnOy7AobymlU2a4ZWj8vilhdTWQQIJjuOSkiJWB2D8Kih7cn8UElY62Aj4gJ72RhuZllElxWQePfv0K1A3dfuz4cPVvEU1MlewOJi3gVB2IpQo6bUz8kgS1PP35M7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G+B3Ub+O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G+B3Ub+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A2E1F000FF;
	Wed, 30 Sep 2026 16:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785554;
	bh=Bmw4/+ViQwYLwJghmNe0jeYacPma2pX/1Lu//BpY2OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G+B3Ub+OQsQbURjdToBTy4ElGwjp4bpvtIKRnZSU/wV8f3GrRuBqjil965F/2CkFO
	 peJ2+7iM4e67PMqZNzLJ+ZiU41PUGDxFELX1J88adCVen57yw+P5VsfBMiAvImxGlr
	 nijgWreTE3LHFoIMaJ4fxc8NUgfVZzNKPqGQcbok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 551/982] Revert "arm64: dts: qcom: sm8350: Fix the PCIe iommu-map entries"
Date: Wed, 30 Sep 2026 17:21:27 +0200
Message-ID: <20260930152428.605819328@linuxfoundation.org>
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

This reverts commit 98d41e690de05a6367300ab85bdeddff1af933a4.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index 28224a4818534..bb556fdc66664 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -1635,8 +1635,8 @@ pcie0: pci@1c00000 {
 				      "aggre1",
 				      "aggre0";
 
-			iommu-map = <0x0   &apps_smmu 0x1c00 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1c01 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c00 0x1>,
+				    <0x100 &apps_smmu 0x1c01 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -1718,8 +1718,8 @@ pcie1: pci@1c08000 {
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



