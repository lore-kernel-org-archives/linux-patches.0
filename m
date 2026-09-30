Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6B13C988B;
	Wed, 30 Sep 2026 19:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795780; cv=none; b=nk//AmG3vFehjJmaT+JYTxPW/+LG5d+8yLDSN91zAm1+6yr88P4E1qauENsDACEJzHjJBrz67vzku1a6VZOtd8q60YiRI13Um4zMHOjNAeSzz2sbgWCaHS5Kfw94vBnHQHJlAS/L/RmtTkXYOMwoPdN3xlr1U6xLsE3umhwnC9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795780; c=relaxed/simple;
	bh=c3lZ706GLsaGOjwTw1N1z4W6CdILCxhYWdG0BKznenk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OkpPheeYIbWxDdDRlj9/L7gZoL/GoFrdh5Bbocl5KdRP5I9rviTwrfkNwfYhRq8RQCFhNbjiufor0coir03DlSrR6ZkMqiVd2XlK+4KuYHYmQTqcNRjgOxkIh9Zx/c/gfhzO6z0WItQrqjxcPteQ8/PEodcMD8A7oUPKjOULNug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1LhvzBMN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1LhvzBMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A6F1F000FF;
	Wed, 30 Sep 2026 19:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795779;
	bh=e/O+l8iFNWcyYV4rqrS4dHMTkI1Zwv8pOQHc33dB9MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1LhvzBMNOM0L4FcuXrmfsNwPYDw4fRsQuUUYuGg3CChahBi9L2AFZ0RSSGVoF8uF4
	 z414xjSEAFUZCifR/c2l3lebO8RNkGSJJjUccibAlUvYpCpyOual+kENdsAWitYWlH
	 bSHPFw/CNBZkMRDza3zTcc/duFd8eqZTT0Ngf2GU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0681/1193] Revert "arm64: dts: qcom: sdm845: Fix the PCIe iommu-map entries"
Date: Wed, 30 Sep 2026 17:22:45 +0200
Message-ID: <20260930152449.374116322@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 3c9cbf39055faf75b588f30aac5e409555075295.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 64 ++++++++++++++--------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index 0bcaeba8dafa4..fa91e2036dd56 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -2349,22 +2349,22 @@ pcie0: pci@1c00000 {
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
@@ -2459,22 +2459,22 @@ pcie1: pci@1c08000 {
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



