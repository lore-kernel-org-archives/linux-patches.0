Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF00503BF3;
	Wed, 30 Sep 2026 16:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785572; cv=none; b=jD5xjnGWO7b8n2R6BEL20ykbjkNY9AlL3/rWBjA4OJR5JNL3Do4XVIfxpbDnktO5spfWRksSFjD1Q4QgieplTYzLzF2Cu5Bs+IF4ZDNODBmstXQwJ0CsuoJ+wDszNSzFaTQRLo3J2AlNOkXJSvHAeQ9vkdGQcC+4Cos+MCObJ+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785572; c=relaxed/simple;
	bh=918UqVk7e4iP7VrjKbsYP8LfRQGMtpNQRLPRmIaKHyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TpLlfeB1k7NxKhMuD2HC3vx8usDdsqgEtVVi0bXqdM7+n6lFioozoOMzw86ii7FjFcHtMbtduqc5JrKaBS3YKo00TO9sEz4m6j5k/kcz+bD05e3yrggsLSAdU9d4v3dzyx1J81+qD+5deDJ1ZMcM3pdlSmTLO6YZi+bZHl1RpQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NREJKMCu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NREJKMCu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7155F1F00893;
	Wed, 30 Sep 2026 16:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785563;
	bh=2VTfWREoXbnjJ6BbAzZbuYepMTNKG/a1EWnLvEgnyIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NREJKMCuKXRt1ERZec5VM743x4paGst0NQqfZaJ84tk9nihXAC9wab8Ve7rZh2t5Y
	 3MzT4f9Enzn56w9U8MU4AFnQAHqPUMZYG7gle3icIRLecsUX8JWRazFxOSSV1uelxj
	 f0wzcODQpD8mxwUNdag6QsK8/vJyghYPh5pwHD6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 554/982] Revert "arm64: dts: qcom: sdm845: Fix the PCIe iommu-map entries"
Date: Wed, 30 Sep 2026 17:21:30 +0200
Message-ID: <20260930152428.672015558@linuxfoundation.org>
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

This reverts commit 34c6835023896943696e4f2c192dc850240982cc.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 64 ++++++++++++++--------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index 10b0956f48c20..71d2ecbec22b0 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -2254,22 +2254,22 @@ pcie0: pci@1c00000 {
 				      "slave_q2a",
 				      "tbu";
 
-			iommu-map = <0x0   &apps_smmu 0x1c10 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1c11 0x0 0x1>,
-				    <0x200 &apps_smmu 0x1c12 0x0 0x1>,
-				    <0x300 &apps_smmu 0x1c13 0x0 0x1>,
-				    <0x400 &apps_smmu 0x1c14 0x0 0x1>,
-				    <0x500 &apps_smmu 0x1c15 0x0 0x1>,
-				    <0x600 &apps_smmu 0x1c16 0x0 0x1>,
-				    <0x700 &apps_smmu 0x1c17 0x0 0x1>,
-				    <0x800 &apps_smmu 0x1c18 0x0 0x1>,
-				    <0x900 &apps_smmu 0x1c19 0x0 0x1>,
-				    <0xa00 &apps_smmu 0x1c1a 0x0 0x1>,
-				    <0xb00 &apps_smmu 0x1c1b 0x0 0x1>,
-				    <0xc00 &apps_smmu 0x1c1c 0x0 0x1>,
-				    <0xd00 &apps_smmu 0x1c1d 0x0 0x1>,
-				    <0xe00 &apps_smmu 0x1c1e 0x0 0x1>,
-				    <0xf00 &apps_smmu 0x1c1f 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c10 0x1>,
+				    <0x100 &apps_smmu 0x1c11 0x1>,
+				    <0x200 &apps_smmu 0x1c12 0x1>,
+				    <0x300 &apps_smmu 0x1c13 0x1>,
+				    <0x400 &apps_smmu 0x1c14 0x1>,
+				    <0x500 &apps_smmu 0x1c15 0x1>,
+				    <0x600 &apps_smmu 0x1c16 0x1>,
+				    <0x700 &apps_smmu 0x1c17 0x1>,
+				    <0x800 &apps_smmu 0x1c18 0x1>,
+				    <0x900 &apps_smmu 0x1c19 0x1>,
+				    <0xa00 &apps_smmu 0x1c1a 0x1>,
+				    <0xb00 &apps_smmu 0x1c1b 0x1>,
+				    <0xc00 &apps_smmu 0x1c1c 0x1>,
+				    <0xd00 &apps_smmu 0x1c1d 0x1>,
+				    <0xe00 &apps_smmu 0x1c1e 0x1>,
+				    <0xf00 &apps_smmu 0x1c1f 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -2363,22 +2363,22 @@ pcie1: pci@1c08000 {
 			assigned-clocks = <&gcc GCC_PCIE_1_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommu-map = <0x0   &apps_smmu 0x1c00 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1c01 0x0 0x1>,
-				    <0x200 &apps_smmu 0x1c02 0x0 0x1>,
-				    <0x300 &apps_smmu 0x1c03 0x0 0x1>,
-				    <0x400 &apps_smmu 0x1c04 0x0 0x1>,
-				    <0x500 &apps_smmu 0x1c05 0x0 0x1>,
-				    <0x600 &apps_smmu 0x1c06 0x0 0x1>,
-				    <0x700 &apps_smmu 0x1c07 0x0 0x1>,
-				    <0x800 &apps_smmu 0x1c08 0x0 0x1>,
-				    <0x900 &apps_smmu 0x1c09 0x0 0x1>,
-				    <0xa00 &apps_smmu 0x1c0a 0x0 0x1>,
-				    <0xb00 &apps_smmu 0x1c0b 0x0 0x1>,
-				    <0xc00 &apps_smmu 0x1c0c 0x0 0x1>,
-				    <0xd00 &apps_smmu 0x1c0d 0x0 0x1>,
-				    <0xe00 &apps_smmu 0x1c0e 0x0 0x1>,
-				    <0xf00 &apps_smmu 0x1c0f 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c00 0x1>,
+				    <0x100 &apps_smmu 0x1c01 0x1>,
+				    <0x200 &apps_smmu 0x1c02 0x1>,
+				    <0x300 &apps_smmu 0x1c03 0x1>,
+				    <0x400 &apps_smmu 0x1c04 0x1>,
+				    <0x500 &apps_smmu 0x1c05 0x1>,
+				    <0x600 &apps_smmu 0x1c06 0x1>,
+				    <0x700 &apps_smmu 0x1c07 0x1>,
+				    <0x800 &apps_smmu 0x1c08 0x1>,
+				    <0x900 &apps_smmu 0x1c09 0x1>,
+				    <0xa00 &apps_smmu 0x1c0a 0x1>,
+				    <0xb00 &apps_smmu 0x1c0b 0x1>,
+				    <0xc00 &apps_smmu 0x1c0c 0x1>,
+				    <0xd00 &apps_smmu 0x1c0d 0x1>,
+				    <0xe00 &apps_smmu 0x1c0e 0x1>,
+				    <0xf00 &apps_smmu 0x1c0f 0x1>;
 
 			resets = <&gcc GCC_PCIE_1_BCR>;
 			reset-names = "pci";
-- 
2.53.0



