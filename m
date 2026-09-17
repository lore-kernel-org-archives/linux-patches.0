Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C8A4F85A9;
	Thu, 17 Sep 2026 17:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666844; cv=none; b=hXzc9pMwlbiAUn+JL8lwU9RiykQQ/FffZzauUfKF4rcTvkm993grQ2z8bLroKO7iTzllHQ8Hlqi9FVEkOnUj+XPM+2TAQZokboogC8WNPSjYiXzh/QYKEodrI1ngD5UKfQ+uN45rMCa0C0ozIxxlT4BVRaeE9XjH8jAvZev9558=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666844; c=relaxed/simple;
	bh=YBbdSsIVBLcSwHSSv8sMaRQr50kgFRrIrmtnXlAC6vQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L85oA0+078h4M/P+iECjKNDJRqpey20ctp9jAnZt0a+jKnsZYSGRhC69m8Md2kSi4e37EZVz+p1EGtJJusb1mNb0gTFx1JgrAOviv6aKfkrH2yg2EV5jf2N1KSWEU5mvPSTs32cuT3WOdY7sWjLzJQ+wWhDLdAzwtPfjb+bhao8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CzByapQb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CzByapQb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F861F000FF;
	Thu, 17 Sep 2026 17:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666842;
	bh=QUKz8ZZdqdNUzhaVa38bPHOZwqvqLsSu4TdpY8bPyrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CzByapQbO99nBRkPoJhP8yLvnP4v0Ie4YesVV26qvFHdOTgVo60cnFYzOn/ccmaO3
	 guxXKLZ8HUPhln9sUhU6aKiWzSclzQoGtvubwTDCCE/dMNnRr2aWo5Yaw4EG+Df9Ni
	 CUGJjbGorO/4QlPheli3UW10+Yojfaiz3lMiIhyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1142/1250] Revert "arm64: dts: qcom: sdm845: Fix the PCIe iommu-map entries"
Date: Thu, 17 Sep 2026 16:15:37 +0100
Message-ID: <20260917151623.209362856@linuxfoundation.org>
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

This reverts commit a98b8bb0ca25f05b15267da97dc665dd9e13309b.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 64 ++++++++++++++--------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index c49ef738d0947..13c9515260ef1 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -2367,22 +2367,22 @@ pcie0: pcie@1c00000 {
 				      "slave_q2a",
 				      "tbu";
 
-			iommu-map = <0x0   &apps_smmu 0x1c10 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1c11 0x0 0x1>,
-				    <0x200 &apps_smmu 0x1c12 0x0 0x1>,
-				    <0x300 &apps_smmu 0x1c13 0x0 0x1>,
-				    <0x400 &apps_smmu 0x1c14 0x0 0x1>,
-				    <0x500 &apps_smmu 0x1c15 0x0 0x1>,
-				    <0x600 &apps_smmu 0x1c16 0x0 0x1>,
-				    <0x700 &apps_smmu 0x1c17 0x0 0x1>,
-				    <0x800 &apps_smmu 0x1c18 0x0 0x1>,
-				    <0x900 &apps_smmu 0x1c19 0x0 0x1>,
-				    <0xa00 &apps_smmu 0x1c1a 0x0 0x1>,
-				    <0xb00 &apps_smmu 0x1c1b 0x0 0x1>,
-				    <0xc00 &apps_smmu 0x1c1c 0x0 0x1>,
-				    <0xd00 &apps_smmu 0x1c1d 0x0 0x1>,
-				    <0xe00 &apps_smmu 0x1c1e 0x0 0x1>,
-				    <0xf00 &apps_smmu 0x1c1f 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c10 0x1>,
+				    <0x100 &apps_smmu 0x1c11 0x1>,
+				    <0x200 &apps_smmu 0x1c12 0x1>,
+				    <0x300 &apps_smmu 0x1c13 0x1>,
+				    <0x400 &apps_smmu 0x1c14 0x1>,
+				    <0x500 &apps_smmu 0x1c15 0x1>,
+				    <0x600 &apps_smmu 0x1c16 0x1>,
+				    <0x700 &apps_smmu 0x1c17 0x1>,
+				    <0x800 &apps_smmu 0x1c18 0x1>,
+				    <0x900 &apps_smmu 0x1c19 0x1>,
+				    <0xa00 &apps_smmu 0x1c1a 0x1>,
+				    <0xb00 &apps_smmu 0x1c1b 0x1>,
+				    <0xc00 &apps_smmu 0x1c1c 0x1>,
+				    <0xd00 &apps_smmu 0x1c1d 0x1>,
+				    <0xe00 &apps_smmu 0x1c1e 0x1>,
+				    <0xf00 &apps_smmu 0x1c1f 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -2497,22 +2497,22 @@ pcie1: pcie@1c08000 {
 			assigned-clocks = <&gcc GCC_PCIE_1_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommu-map = <0x0   &apps_smmu 0x1c00 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1c01 0x0 0x1>,
-				    <0x200 &apps_smmu 0x1c02 0x0 0x1>,
-				    <0x300 &apps_smmu 0x1c03 0x0 0x1>,
-				    <0x400 &apps_smmu 0x1c04 0x0 0x1>,
-				    <0x500 &apps_smmu 0x1c05 0x0 0x1>,
-				    <0x600 &apps_smmu 0x1c06 0x0 0x1>,
-				    <0x700 &apps_smmu 0x1c07 0x0 0x1>,
-				    <0x800 &apps_smmu 0x1c08 0x0 0x1>,
-				    <0x900 &apps_smmu 0x1c09 0x0 0x1>,
-				    <0xa00 &apps_smmu 0x1c0a 0x0 0x1>,
-				    <0xb00 &apps_smmu 0x1c0b 0x0 0x1>,
-				    <0xc00 &apps_smmu 0x1c0c 0x0 0x1>,
-				    <0xd00 &apps_smmu 0x1c0d 0x0 0x1>,
-				    <0xe00 &apps_smmu 0x1c0e 0x0 0x1>,
-				    <0xf00 &apps_smmu 0x1c0f 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c00 0x1>,
+				    <0x100 &apps_smmu 0x1c01 0x1>,
+				    <0x200 &apps_smmu 0x1c02 0x1>,
+				    <0x300 &apps_smmu 0x1c03 0x1>,
+				    <0x400 &apps_smmu 0x1c04 0x1>,
+				    <0x500 &apps_smmu 0x1c05 0x1>,
+				    <0x600 &apps_smmu 0x1c06 0x1>,
+				    <0x700 &apps_smmu 0x1c07 0x1>,
+				    <0x800 &apps_smmu 0x1c08 0x1>,
+				    <0x900 &apps_smmu 0x1c09 0x1>,
+				    <0xa00 &apps_smmu 0x1c0a 0x1>,
+				    <0xb00 &apps_smmu 0x1c0b 0x1>,
+				    <0xc00 &apps_smmu 0x1c0c 0x1>,
+				    <0xd00 &apps_smmu 0x1c0d 0x1>,
+				    <0xe00 &apps_smmu 0x1c0e 0x1>,
+				    <0xf00 &apps_smmu 0x1c0f 0x1>;
 
 			resets = <&gcc GCC_PCIE_1_BCR>;
 			reset-names = "pci";
-- 
2.53.0



