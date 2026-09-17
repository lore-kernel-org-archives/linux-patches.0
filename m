Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A7B49D5B9;
	Thu, 17 Sep 2026 18:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671404; cv=none; b=eJHrEr7RmRLb3QDCMX1ftnqzitvoOBxulj2WJg4tYpgA0aTMJfCaT3cPaqb7bKh0FswzU3nWhC/K3Tifv0mgKBOSOMLwngcIVciqUCu64b5UVaaETt87KeaThshDneYRVXDk8TJrvAjvitlt3yB5HzVC3bZALI6zqZSC1lQyVOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671404; c=relaxed/simple;
	bh=riV1/QXmab4ecMULi7JMjj0ja/8zHk86qKrDFtbE0pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zv/Ykg4XELZDA4WiHekMhSGgNqdDYreBBVMLadA+2WtkiWkdmk1NIOmTQNx3TuXocIaTfSGcf6mz6xi2DCLwnMhoSaLDQmdlniQfP2WMDRPjqhJnfY37yCc11J2zlm0w6AVlTJdwNUv7bpiMTi6dPmthsVSkMY+q1lPXmewx/mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XKf9Es7v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XKf9Es7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C8F1F000FF;
	Thu, 17 Sep 2026 18:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671402;
	bh=jpJN1VBUy/+wEhSJkpLaNAqQjZzEsJB0/Z1AQk8G8O8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XKf9Es7vcSvGWtZ/YZyDlhXo9dtfs9PfVL1JqZbP8WROACuQOMNY88iEYWW/irzpB
	 QKgpqY678sP/MAQW9+7M6/TqEF6CFJI41Hj1KLS6rku4Twu2COVpKHUgwgzf7KGWTf
	 hIr4a7zt/Xmj/Uvlh/jBifrsntGQXchKuHgwQLIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0925/1102] Revert "arm64: dts: qcom: sm8550: Fix the PCIe iommu-map entries"
Date: Thu, 17 Sep 2026 16:14:28 +0100
Message-ID: <20260917151603.857051412@linuxfoundation.org>
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

This reverts commit 4856decb6410603274d61963c9f7df3572ab07f0.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index 7f06bea09d0ac..38b15db0676ce 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -1771,8 +1771,8 @@ pcie0: pcie@1c00000 {
 
 			msi-map = <0x0 &gic_its 0x1400 0x1>,
 				  <0x100 &gic_its 0x1401 0x1>;
-			iommu-map = <0x0   &apps_smmu 0x1400 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1401 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1400 0x1>,
+				    <0x100 &apps_smmu 0x1401 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -1892,8 +1892,8 @@ pcie1: pcie@1c08000 {
 
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



