Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769884E73C1;
	Thu, 17 Sep 2026 17:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666817; cv=none; b=WxSuk3bAzfpiH62fSa8paT8p5dz93pM2kJ7rsyAI0JpPpsVrQihtK42SXhXaFoJbuViR4Tqc7/tGQXKvP4b4uWMOlBRt9PBuEcLEv7ZjyQMbpiNnCGh0tO0cqEN3FztUMtoVhnXZ0K8C2eyq8fi/enUpDT4jd9jJe71ewir98mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666817; c=relaxed/simple;
	bh=IuhiTQDFtsShfbSmlUfO0jvShr1OtPwFEYq/9QbrcYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rmUc0cLVeiI33fgKyRU3CPR0xQnBrw72LjJ+FIjlIW8i5mNTtv8UmgpkzMVfa/jLPFWHNwV3RwhPFPbpNk1JvcI4226M8VJAffmtJFRtf2q64/CES0/Xyou1xeLLMKZK/EhotJZpG52Ux+OzpMzMn+kiJhMNHXiSZ/OP1zkytOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EkoBGKTv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EkoBGKTv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ECA91F000FF;
	Thu, 17 Sep 2026 17:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666816;
	bh=zchfexTe6ZKPUlaji5CoSY9Gu6CXO0dSvmeBqcqREnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EkoBGKTvPN7KB309wvDSMgqEg1sKi2KG/hZkJZK8ioFDVF1GXpcDJd2N5fGaswTxE
	 qiEK7MA0ENKprG0hh9wvPqVtJBYkWnZXIA5Xa2ZgPaWZZpM9LvM3B2Da3jWpRpgV1H
	 nai1kjKzL2eGf5lfUGVdLp6q9dF8/41cIfQjqd9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1133/1250] Revert "arm64: dts: qcom: lemans: Fix the PCIe iommu-map entries"
Date: Thu, 17 Sep 2026 16:15:28 +0100
Message-ID: <20260917151622.959451250@linuxfoundation.org>
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

This reverts commit e1c65abeb6aafa6daae8d183912f853a6e6a268f.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/lemans.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/lemans.dtsi b/arch/arm64/boot/dts/qcom/lemans.dtsi
index 806b6b5d4b205..0861e4ead93eb 100644
--- a/arch/arm64/boot/dts/qcom/lemans.dtsi
+++ b/arch/arm64/boot/dts/qcom/lemans.dtsi
@@ -2739,8 +2739,8 @@ pcie0: pcie@1c00000 {
 					<&gem_noc MASTER_APPSS_PROC 0 &config_noc SLAVE_PCIE_0 0>;
 			interconnect-names = "pcie-mem", "cpu-pcie";
 
-			iommu-map = <0x0 &pcie_smmu 0x0000 0x0 0x1>,
-				    <0x100 &pcie_smmu 0x0001 0x0 0x1>;
+			iommu-map = <0x0 &pcie_smmu 0x0000 0x1>,
+				    <0x100 &pcie_smmu 0x0001 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>,
 				 <&gcc GCC_PCIE_0_LINK_DOWN_BCR>;
@@ -2912,8 +2912,8 @@ pcie1: pcie@1c10000 {
 					<&gem_noc MASTER_APPSS_PROC 0 &config_noc SLAVE_PCIE_1 0>;
 			interconnect-names = "pcie-mem", "cpu-pcie";
 
-			iommu-map = <0x0 &pcie_smmu 0x0080 0x0 0x1>,
-				    <0x100 &pcie_smmu 0x0081 0x0 0x1>;
+			iommu-map = <0x0 &pcie_smmu 0x0080 0x1>,
+				    <0x100 &pcie_smmu 0x0081 0x1>;
 
 			resets = <&gcc GCC_PCIE_1_BCR>,
 				 <&gcc GCC_PCIE_1_LINK_DOWN_BCR>;
-- 
2.53.0



