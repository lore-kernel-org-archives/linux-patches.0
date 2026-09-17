Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9B84D7D2F;
	Thu, 17 Sep 2026 17:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666826; cv=none; b=sGgruW4oZRhKGuVliOq5SqboIEHYsIiJb9i9yg8B4a1JPHqKd03w3X4MAfTcV5FuaCDoVYwaAWgysc96rGpwZJwxH/V+dAt9qNdwQlabBnalWyQIVEQKk/lLrpQfT123yQaICKJCvrgCdT+N6nNFr5rBOWeY/tr1qiXAQUuH3ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666826; c=relaxed/simple;
	bh=rmreQYyK/qu4qA1f6eJlm8GquT5bQAQ0Mb7G//dU5Dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNe7QfJEBs34JbBt2yiOhJ4sFs7GEqOy1E9XorcpmlwHKEJjXP+392CaxZoMztiIOOfWsjuUh8xDFJT0hsIoD86zpbPKzuuWuOn4ZBem9XcRcpbx0zPqEyM+O2N0FMGAT8RTYIlqGtQSljeYyA5UKZEPfZzOTCDw2LrTcAGU0nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d0CyO1Im; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d0CyO1Im"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706B71F000FF;
	Thu, 17 Sep 2026 17:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666825;
	bh=NnlZEYxUPMXxyRJTjIkU34JpI9ZqUEqc/65wvnqMFp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d0CyO1ImngDMdyOBmqDEcpKbxEKMA7Ofe8kHs208zxrhL4HfAlg20FlrQMcZEOZaA
	 V8fnAnnAW7bll3pt8BSq0lBFkJuQChAkA9OEK2hxFyv0U6FR/FVrULuoBx7wtubZ2T
	 RUuyNKhNAuwgrRFJFtSWuxJWvg5wjXogkQrkAp7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1136/1250] Revert "arm64: dts: qcom: sm8650: Fix the PCIe iommu-map entries"
Date: Thu, 17 Sep 2026 16:15:31 +0100
Message-ID: <20260917151623.039192817@linuxfoundation.org>
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

This reverts commit f418e83ac1abec16df99e36185c44b7a08c2aaf7.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8650.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8650.dtsi b/arch/arm64/boot/dts/qcom/sm8650.dtsi
index 349ce22c6b686..6c775ef20cb0a 100644
--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -3626,8 +3626,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 
 			operating-points-v2 = <&pcie0_opp_table>;
 
-			iommu-map = <0     &apps_smmu 0x1400 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1401 0x0 0x1>;
+			iommu-map = <0     &apps_smmu 0x1400 0x1>,
+				    <0x100 &apps_smmu 0x1401 0x1>;
 
 			interrupt-map = <0 0 0 1 &intc 0 0 GIC_SPI 149 IRQ_TYPE_LEVEL_HIGH 0>,
 					<0 0 0 2 &intc 0 0 GIC_SPI 150 IRQ_TYPE_LEVEL_HIGH 0>,
@@ -3806,8 +3806,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 
 			operating-points-v2 = <&pcie1_opp_table>;
 
-			iommu-map = <0     &apps_smmu 0x1480 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1481 0x0 0x1>;
+			iommu-map = <0     &apps_smmu 0x1480 0x1>,
+				    <0x100 &apps_smmu 0x1481 0x1>;
 
 			interrupt-map = <0 0 0 1 &intc 0 0 GIC_SPI 434 IRQ_TYPE_LEVEL_HIGH 0>,
 					<0 0 0 2 &intc 0 0 GIC_SPI 435 IRQ_TYPE_LEVEL_HIGH 0>,
-- 
2.53.0



