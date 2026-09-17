Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A8D1D54FA;
	Thu, 17 Sep 2026 18:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671394; cv=none; b=ZG+mefSsIG2G2euVpHDxpvoA5eiRITTF8pSAeZk4OgAOHIUfZOCw5O/NuKZocg+Zov47TtB6IZRZc8fbGPpHiU0w9Sd3iAwxU6f6oDYodzpwAV92qml5K2MjD2tV0bjzPQdeRUpqs414vWNSrZ/6qXyVS2pOJvZi4i3ju7gCTGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671394; c=relaxed/simple;
	bh=oftajYKtN2ABee4XKfy26VywwiwyFFLenL9K4s8GZIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WitODInMjuT9hsIpx/KFFh3xe+Ao2gfh1yhDeoSNk7wxfstNqhVq1V8R12c4+YGlLhKehpMWw6dPsJl3fM9C98O3c3LBNnc8MH7toE5OSyMhTcKUTkXNStkcN5h/DWcOJS50JHiD2qazezVislzQefdzOzXafCXCbWk+/meAO1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jwf8VLHR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jwf8VLHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9AF1F000FF;
	Thu, 17 Sep 2026 18:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671393;
	bh=f9k84TwOZQUu4qJ5aUIPL+sB2etiz1VhVgjX11M7bwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jwf8VLHRnxWLlZrkfLtgV0uoNIdyrMe0jESzCE7NHtrMWq1tDSDOHwWy5yO3qqCgb
	 36o664sVNWPBgWT5pQP/harFbFVhAKS3kdmRF9VuyaPiLeKgzEY9UOuHTME7QnusB7
	 VeJ+PuEMAAZ9MPKBmM1kd+1+mwCSMEK0IFyuidkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0924/1102] Revert "arm64: dts: qcom: sm8650: Fix the PCIe iommu-map entries"
Date: Thu, 17 Sep 2026 16:14:27 +0100
Message-ID: <20260917151603.830993698@linuxfoundation.org>
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

This reverts commit 8c64ba2f9b7fe2aaae3198f3f9f4cb2ae54459db.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8650.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8650.dtsi b/arch/arm64/boot/dts/qcom/sm8650.dtsi
index d28dfbf57e634..51bfb220b6c2e 100644
--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -2281,8 +2281,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 
 			operating-points-v2 = <&pcie0_opp_table>;
 
-			iommu-map = <0     &apps_smmu 0x1400 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1401 0x0 0x1>;
+			iommu-map = <0     &apps_smmu 0x1400 0x1>,
+				    <0x100 &apps_smmu 0x1401 0x1>;
 
 			interrupt-map = <0 0 0 1 &intc 0 0 0 149 IRQ_TYPE_LEVEL_HIGH>,
 					<0 0 0 2 &intc 0 0 0 150 IRQ_TYPE_LEVEL_HIGH>,
@@ -2459,8 +2459,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 
 			operating-points-v2 = <&pcie1_opp_table>;
 
-			iommu-map = <0     &apps_smmu 0x1480 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1481 0x0 0x1>;
+			iommu-map = <0     &apps_smmu 0x1480 0x1>,
+				    <0x100 &apps_smmu 0x1481 0x1>;
 
 			interrupt-map = <0 0 0 1 &intc 0 0 0 434 IRQ_TYPE_LEVEL_HIGH>,
 					<0 0 0 2 &intc 0 0 0 435 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.53.0



