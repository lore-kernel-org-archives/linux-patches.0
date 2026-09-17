Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E44B3D954E;
	Thu, 17 Sep 2026 18:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671409; cv=none; b=HVNNiUcKymNu7Bl3fAsS9+PaReNSNf6eayS8adDuaUoLnBHfW7Am9LdjiMcRDxoEvXqPBhPKrvOABPYbLF3lXGkHEXMWeiPZENd2w5NrkjZ+Z1CrqF0Fqy9Oq+/gmFRGmes4XMhBLvQrKJ9md3d/c7/Y9tL/ZCPd+tJTAkkEd1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671409; c=relaxed/simple;
	bh=b9hwRtztbCXDd6G8nkKnzHtLgZ9eMf1lyjPo30DiPug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3kBd+BTgVutV5rPGvghpUy1ci4IarTCbyZDwaUHQLfgZXNhcEhH5FZp/eugnoIJ3ndNvhqvgrYUjA++1woXpU1Re36Ujw4py6asHs1zuL+zHQ1tJbiWECol7wzx00cp51XQKOPu6v8UjQrfJG7RdPddjHOKq8qwrbJ7b2fXgXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u4B0XX+e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u4B0XX+e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1EFB1F000FF;
	Thu, 17 Sep 2026 18:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671408;
	bh=l7fFOPaPasafR35Xv6l6bK/Mjycdqv1ml0ttFeY7x1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u4B0XX+eWxpo4lmOQ/pS5cIR7h0L1VNP9+gtkrP5nl2GRe9y9VGrQiU/Aqm1QSvDQ
	 I5fsck0M/DKo9hUb4r5/BakLTXtQD3IbpaTe7X3p7yeYN9733/xI4CUxt958nGrcpm
	 iMVWNJmotgZ/3I/WXXSAiqGnefFqOWzOuE9Pp4CM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0927/1102] Revert "arm64: dts: qcom: sm8350: Fix the PCIe iommu-map entries"
Date: Thu, 17 Sep 2026 16:14:30 +0100
Message-ID: <20260917151603.908146947@linuxfoundation.org>
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

This reverts commit 2fd6aabfdf27f49551ed9edcb845dd3c66e4fae5.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index 6f175791de90d..1870ec4176daa 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -1571,8 +1571,8 @@ pcie0: pcie@1c00000 {
 				      "aggre1",
 				      "aggre0";
 
-			iommu-map = <0x0   &apps_smmu 0x1c00 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1c01 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c00 0x1>,
+				    <0x100 &apps_smmu 0x1c01 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -1678,8 +1678,8 @@ pcie1: pcie@1c08000 {
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



