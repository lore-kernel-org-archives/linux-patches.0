Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4257341ADD;
	Wed, 30 Sep 2026 19:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795777; cv=none; b=UkTREv0n6fpx7Xn4ynGeSxgev7S4Vs15L0PQ2HqbKOIh/2DsKjNXqrBRMrFnDi/7JYvbrTrkgPwRlhh87RtAMqzze0COxc9p5y3k3beQ3YsN5SDN+AcFmKjEi+QaoIqqaGz36F0YWZ5Kl07NmAbk3UEHh5dajy1MZzQzc92adF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795777; c=relaxed/simple;
	bh=f16rKnZv3ppTJurdNLfhiuhxx9MguAbVFoSoaR5WBBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WorXgSfjzZwDF4XhwmZ1pcrHN0mA5fZlEaSnnbMVApNnl01j5A86nb69cQgis+Fn/Tf3H1nU8rl5DWQJwRWuIeZen2fXSDa+TPPX8ntSRHSa5exhhMU38MArjlF9f9yRKZycdQlOetMxh60frCRVNHnKisf6AQz1A2pIlSHmGBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1bBnph4R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1bBnph4R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38CE1F000FF;
	Wed, 30 Sep 2026 19:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795776;
	bh=BVaEBq+Clr5kVkvPf4V2fvmHd0tvgdkvzgmSBnxOT34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1bBnph4RHVTSTYKCoGKC6kOMeiYEuaJeRrXCtWFmnoglVip50vQJngGJf1dSIVNiN
	 JL0LpkbUamsm8BSvhDScmvlglyBG28BmM0oVGYD4AQLRZVQsrgbp1RerrYHziuF2Zj
	 PW8LuPYNT8v5gYXRagJi7euvZJBuS29FPKhrUFYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0680/1193] Revert "arm64: dts: qcom: sm8150: Fix the PCIe iommu-map entries"
Date: Wed, 30 Sep 2026 17:22:44 +0200
Message-ID: <20260930152449.352080977@linuxfoundation.org>
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

This reverts commit 796fcf46d75515f920d3efe4a33540fc6523d940.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8150.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index a506fcf4644f3..73ef228ff2689 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -1865,8 +1865,8 @@ pcie0: pci@1c00000 {
 				      "slave_q2a",
 				      "tbu";
 
-			iommu-map = <0x0   &apps_smmu 0x1d80 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1d81 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1d80 0x1>,
+				    <0x100 &apps_smmu 0x1d81 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -1967,8 +1967,8 @@ pcie1: pci@1c08000 {
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



