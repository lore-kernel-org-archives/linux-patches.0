Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C2F49D587;
	Thu, 17 Sep 2026 17:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666871; cv=none; b=jCjAiM1tNSPVGSKXhf828b/e7MBgjizwEfZ7JjJeG2CCOkBk/FMTEwJp/u9MsRTqBU7ZBhAngAyCAtzOSan+oVEnKBTtzEL/QdWLQ84XzjEy27Z7LBJ5/Y0Y3T5YmsBTr+SSY1U9C0UHTF7lzY/wqHTBuuu5M20Li7HPls6Yoak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666871; c=relaxed/simple;
	bh=4D60sPfYqYjZQQ0ddIPmjaO66LSsRKhXc+bL7qYXm98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iErjJN/nUwtRQNv9rNwCJmQ640TIASyub0v5/SrwoP3rLTJtT5E7kSCXWvVELHXBOFimlvgkqtjPUw9gnbrd/aWyUOnkZf/4LDXeR6OYo/a/ZIAOCW90zo4vr9NP/JFnKMGIb2qmLTOjN5ylgwZvAg76fJVmx4BE7IoH3LTKOms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HygkyJcq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HygkyJcq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B651F000FF;
	Thu, 17 Sep 2026 17:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666870;
	bh=XDbwrvpThr6zf+irQzIIqBB4sa6ItVNmRtBDt4oTLJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HygkyJcqcfAaUpf3I7vdV+TdZ3s0WLggHznQJ5NFWoR2y9Iw6/h1Vtzsaga7FVl0T
	 Z8YOVz+7hpvwNLycsAHG8QjsN1T/VjNJfJeyvYiSGovDDNM/OoL6+nDCKnXjobX35i
	 Q237vzMyq7O8GM+9Ibh4OeYeZoELptpd5tYduvGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1145/1250] Revert "arm64: dts: qcom: kodiak: Fix the PCIe iommu-map entries"
Date: Thu, 17 Sep 2026 16:15:40 +0100
Message-ID: <20260917151623.297245752@linuxfoundation.org>
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

This reverts commit d2b404826bf93c6102ceb5d3186ef41675f0f6ad.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 7d53e06e97b07..0f566dd75c964 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -2273,8 +2273,8 @@ pcie0: pcie@1c00000 {
 				      "aggre0",
 				      "aggre1";
 
-			iommu-map = <0x0   &apps_smmu 0x1c00 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1c01 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c00 0x1>,
+				    <0x100 &apps_smmu 0x1c01 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -2419,8 +2419,8 @@ pcie1: pcie@1c08000 {
 
 			dma-coherent;
 
-			iommu-map = <0x0 &apps_smmu 0x1c80 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1c81 0x0 0x1>;
+			iommu-map = <0x0 &apps_smmu 0x1c80 0x1>,
+				    <0x100 &apps_smmu 0x1c81 0x1>;
 
 			status = "disabled";
 
-- 
2.53.0



