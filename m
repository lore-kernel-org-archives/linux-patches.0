Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D67341ADD;
	Wed, 30 Sep 2026 19:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795769; cv=none; b=H7oCfkFExjJNy9C7SQv9YOiI48TPcivXsxi6DKBmbY3LCreZZUZ8AUxQpQw8JZcreuEWex3Wk2meVJmX6iiaIUEgQqWRndp2MSSoxPvYWNsY+aejsNRCd4po9SCARtGAQF3EH/SgnaIC9Snwo65jibKhAbp8SEheEqxD7BkP9G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795769; c=relaxed/simple;
	bh=eDRDYWhJ62MoMd/DuKyHRh1ocXvV62f0aDnCvuDHmtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uCFbe2r+XwFYA7EO0YtEZ0Yd7KYVT/i/d+GrSqSkLDlwZmlRvwqnWJgDhqPM4JzZThXGRgefDXjtAgP48P91splEgkGyzSGLjT1HH9jR+4KOPLM5DoV3MyyMxFXRJgvjKY1an43yk6EnQFPq03rgq1snkoCqWc7DBywyDJYje34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eNj9fn44; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eNj9fn44"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767E41F00898;
	Wed, 30 Sep 2026 19:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795768;
	bh=MYnQ+mwD8it/FWMudhFx0k8fXd8qLQ52Q9EtugPH5uQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eNj9fn44XWKI6yZzXuu0E2Rjse0ZZybw+10P7x7ETJBVAXxuwtVL4n2Fx3HlSEkFs
	 aKB4mv6CUq1BYlPQqZsNWkCQmCzI5g5azM0Hy9JO8oY2hpk4D+xLaZJ5QPOeCUSzNO
	 08bcbTMuv/+YJJvUCYDsIqW2OesFWYDG0XdUeiDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0678/1193] Revert "arm64: dts: qcom: sm8350: Fix the PCIe iommu-map entries"
Date: Wed, 30 Sep 2026 17:22:42 +0200
Message-ID: <20260930152449.308354683@linuxfoundation.org>
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

This reverts commit 4a2efff1ebdbeb8dfd765154ee1d975e786c6942.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index 8ce8e1c1f72d1..215782b1970df 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -1552,8 +1552,8 @@ pcie0: pci@1c00000 {
 				      "aggre1",
 				      "aggre0";
 
-			iommu-map = <0x0   &apps_smmu 0x1c00 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1c01 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c00 0x1>,
+				    <0x100 &apps_smmu 0x1c01 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -1635,8 +1635,8 @@ pcie1: pci@1c08000 {
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



