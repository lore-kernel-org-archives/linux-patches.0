Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD134C33CC;
	Wed, 30 Sep 2026 16:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785567; cv=none; b=O/Q4tww3kJxu/0nMj8NSuecNgwFjSGWfglHwkwLi+SqWXKDBUBb7fK88agcPNkFLjv4WVK/skbbhcyZZOpbJE34R2oXtDX8ouINuqmFzcN4sDPaPLvFJrLCeRhflZO8DI8VWPEkOqu5meGbNwYMhT0fbUBrhPHfe8XFn8Yx0ldE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785567; c=relaxed/simple;
	bh=UqcrcQDPIfWOMqQS7rZvwjKUCMQglV2sv1sGGixqf9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GS1C3MkPtf0fkaBHLpXPyfUleB7xPo/91RKYGwFf6B6M4MIiQpq0KakdfGXL/GacfJm9YpeFGV4yxK/JJ0qOiEH8Q+lQskfQQd4eUPC25GUSAtgC+pkO7SJ+Goj6QjPMTjLwtibcYYHsLr0vjmhai5QLleLEL2S3t0+9do2BfBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2KzLg5rd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2KzLg5rd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D9F1F00899;
	Wed, 30 Sep 2026 16:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785560;
	bh=1kpiViGIQIDqBTSs9HMdc4D8Rg7xVkfiFy0iknseQhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2KzLg5rdlKpYoJxyjBVbhai9rjF86V+u5mOFQ5+o9PRm94TmsZW/NCM43oVHjEhjd
	 OaMORMCj4dj3eJYAbnD4N0LrtROQC7eQ5v/MeVEFepk799kf3li+AMpvcNtHsL8uTe
	 21w2vZa3utUCGXGWID9msp1wB8MLy8qgYGHJGu8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 553/982] Revert "arm64: dts: qcom: sm8150: Fix the PCIe iommu-map entries"
Date: Wed, 30 Sep 2026 17:21:29 +0200
Message-ID: <20260930152428.650318431@linuxfoundation.org>
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

This reverts commit 7312115432d2ad14ccf92b2359d57bb039a239e3.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8150.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index 1ea6a09b57bc2..9168173dd0e3e 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -1810,8 +1810,8 @@ pcie0: pci@1c00000 {
 				      "slave_q2a",
 				      "tbu";
 
-			iommu-map = <0x0   &apps_smmu 0x1d80 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1d81 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1d80 0x1>,
+				    <0x100 &apps_smmu 0x1d81 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -1912,8 +1912,8 @@ pcie1: pci@1c08000 {
 			assigned-clocks = <&gcc GCC_PCIE_1_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommu-map = <0x0   &apps_smmu 0x1e00 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1e01 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1e00 0x1>,
+				    <0x100 &apps_smmu 0x1e01 0x1>;
 
 			resets = <&gcc GCC_PCIE_1_BCR>;
 			reset-names = "pci";
-- 
2.53.0



