Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADDD3BD22C;
	Wed, 30 Sep 2026 19:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795763; cv=none; b=GAYVtlh3pXF+GHYtjxtarE5akvY4tCaHv9Ko62mZEcEHxmVAnPjhExQFZ2aeVECUJDbrY4XAKnfX9KMrEYIyNs3cRACj/lTTO9rNBnGdiEnnhgo4fDGNCYzg8FSX7I0BW23UlvLgKshLqlO4dgYI4Riv0dBA27O9HGAw9+tXPME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795763; c=relaxed/simple;
	bh=3qIucSX3koN+s44kWBxpd3/jfuqxmOPI+cP2jsEjFhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOtQge26w/uU1nTFvn/59vUx31PTWuUCZEsDUMdUpXD/lStXlAwSb21Jd+zHNPJwMooi9UmKk66L7Es76MALTriShlsVFW5sDidqp321LUXXqBpK8mciFg8ZkvAHPTeiRSQd6Xkdkozy0Fan6LAuRJy8kDxvBj9f+JFviXe+UXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lfBTBXsm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lfBTBXsm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C341A1F000FF;
	Wed, 30 Sep 2026 19:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795762;
	bh=vfJH0mtiMVZDpwYIvo3uBfmSR+LvZtQIiGGZqRVxGg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lfBTBXsmkNGE9X4ajapyM+PLak3gd2Tp7doXq+bl242Cvb7indOVFYNoyXE9cKRWO
	 xuekffr4YAXG06+QA4HWb+J+HDFORF375zqTE+v4oHeK3EvN49zTyhemoGpNzMN1V2
	 3Gzb0SnXq25thUCMOoKEpYS+y0TxiRufCmkgozgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0676/1193] Revert "arm64: dts: qcom: sm8550: Fix the PCIe iommu-map entries"
Date: Wed, 30 Sep 2026 17:22:40 +0200
Message-ID: <20260930152449.264854710@linuxfoundation.org>
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

This reverts commit 76c695d6e923614e9490a3cb4f8538742f7493b8.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index 7f56451b1563b..db61589c8634a 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -1736,8 +1736,8 @@ pcie0: pci@1c00000 {
 
 			msi-map = <0x0 &gic_its 0x1400 0x1>,
 				  <0x100 &gic_its 0x1401 0x1>;
-			iommu-map = <0x0   &apps_smmu 0x1400 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1401 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1400 0x1>,
+				    <0x100 &apps_smmu 0x1401 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -1834,8 +1834,8 @@ pcie1: pci@1c08000 {
 
 			msi-map = <0x0 &gic_its 0x1480 0x1>,
 				  <0x100 &gic_its 0x1481 0x1>;
-			iommu-map = <0x0   &apps_smmu 0x1480 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1481 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1480 0x1>,
+				    <0x100 &apps_smmu 0x1481 0x1>;
 
 			resets = <&gcc GCC_PCIE_1_BCR>,
 				<&gcc GCC_PCIE_1_LINK_DOWN_BCR>;
-- 
2.53.0



