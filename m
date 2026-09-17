Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74FF538F658;
	Thu, 17 Sep 2026 18:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671406; cv=none; b=VPAKjbn81YdVmnCl+RBtxbzP54DUn7zaWqREzlLhz2S7PIvaTHRcmmDDbTXqZodVyrk6XT+rUaAYQXn2EZmZTxOVJDf8h8sbECtxd/GzsN0rrshP4PwxrGfekkHl8cjJP2bhInBNUAmHwW0NRTn3B/oqpxQEljR7BRQhJ3VapRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671406; c=relaxed/simple;
	bh=3F5jYnJwFvUaQOkOLoFFm372OMg+OJSWiVyEjt8j8P8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nfWAOmcEy7S6B7O+0Jn8EMYKi+3COCh0zOwEgCMWYdjER2L2R7zyOGr6ztrV56TGhU7vw4UTVXvaXIoBTARVRRccekag703DNABGLMDYhYD0jFuXI8r+hlgs1w0Pt9ZsQW6VL9SY8CxrzNHDmVSGBCl+OXwCLlV+UKm2wVqHahs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ObHRQGe6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ObHRQGe6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6651F00893;
	Thu, 17 Sep 2026 18:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671405;
	bh=OPXRBWWrhAgXIjvMr0JsYRLtQlUb3zjK9gkYffhYSzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ObHRQGe6Ip4KtkHiNCH8GhdlZ0d9IVLE+P6QE4r19KrlR2SRxtFEEPu/ueF1MUhqE
	 Y4k5sVzJDcXZmBtsAn7BxrYmZM+legR4AvVV+KRahzvCgBcEOsf5t1IiQdlqDG9gW9
	 7MuxxaYflmDE55q3NXplcMQLuDsM62+WnAGP3i2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0926/1102] Revert "arm64: dts: qcom: sm8450: Fix the PCIe iommu-map entries"
Date: Thu, 17 Sep 2026 16:14:29 +0100
Message-ID: <20260917151603.882922719@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 9dd1668a0f69e1e8ecda14d28e5f746a053723f8.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index 521b12a56e55d..59172db1e3d9e 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -1834,8 +1834,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 				      "aggre0",
 				      "aggre1";
 
-			iommu-map = <0x0   &apps_smmu 0x1c00 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1c01 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c00 0x1>,
+				    <0x100 &apps_smmu 0x1c01 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -1994,8 +1994,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
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



