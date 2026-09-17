Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D073ACEF4;
	Thu, 17 Sep 2026 18:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671412; cv=none; b=CdYu8z3TBtpV246eS63+Jjmg/MMIhOQ3L74N391sNEMlHfYsk1cIsI/TmeXiUMUEeEoLl5Q8Awi9EoqXfh0GWvH/JgCNqFT2CDm9gzTww6WK77ifBN0QAwN6u+wfnEWCMhK7Zge/POLurV4/HG1Ycf0x5U59TF6ufJpDe1DYxPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671412; c=relaxed/simple;
	bh=KXa1xDK4/Yp8WY6gAL+fNuogQ7RfRVmFOj/6pT3GNtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXEBbV+pCQu8+hO8mi3ocQloQa2k286Ud2BYCsfjIuueMyZUrZtKblXghvtQ/zamZpyy6oEuXHQqlZKx+cQgktQeoqfYFjPPwqm83gu5+Eh8Rliw3efDmAi4p3kbEGmGEKXv4WqOIHg5nP4MYsJW7IM8iOGeSZlD2F+F6a8abL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JBaBG0vP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JBaBG0vP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE6A1F000FF;
	Thu, 17 Sep 2026 18:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671411;
	bh=S6Hs7gdcCdlosH7hEE087YgLqzP4iF8DfAVD9QncB7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JBaBG0vP/aap/Qn2W6Egq5s67+YCbP0xbbWC2T2j1vrVm7yodYf///d64PfreUkTH
	 x5x4sNyuGX5OeP8yKsVrEogcY4VGn0NmRCEZfYA+yKr7hs6qG9KYUEHCEH+2AC7eDt
	 V9zQ2YUX99uKVbYrHN0SYExO9N2ghTb3t8yrfyEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0928/1102] Revert "arm64: dts: qcom: sm8250: Fix the PCIe iommu-map entries"
Date: Thu, 17 Sep 2026 16:14:31 +0100
Message-ID: <20260917151603.933956515@linuxfoundation.org>
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

This reverts commit 9a82d5cf632a590518315276830ecaf9d0b89f95.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index f1851cbcd48b9..d6607c38eb35c 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -2187,8 +2187,8 @@ pcie0: pcie@1c00000 {
 				      "tbu",
 				      "ddrss_sf_tbu";
 
-			iommu-map = <0x0   &apps_smmu 0x1c00 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1c01 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c00 0x1>,
+				    <0x100 &apps_smmu 0x1c01 0x1>;
 
 			resets = <&gcc GCC_PCIE_0_BCR>;
 			reset-names = "pci";
@@ -2312,8 +2312,8 @@ pcie1: pcie@1c08000 {
 			assigned-clocks = <&gcc GCC_PCIE_1_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommu-map = <0x0   &apps_smmu 0x1c80 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1c81 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1c80 0x1>,
+				    <0x100 &apps_smmu 0x1c81 0x1>;
 
 			resets = <&gcc GCC_PCIE_1_BCR>;
 			reset-names = "pci";
@@ -2437,8 +2437,8 @@ pcie2: pcie@1c10000 {
 			assigned-clocks = <&gcc GCC_PCIE_2_AUX_CLK>;
 			assigned-clock-rates = <19200000>;
 
-			iommu-map = <0x0   &apps_smmu 0x1d00 0x0 0x1>,
-				    <0x100 &apps_smmu 0x1d01 0x0 0x1>;
+			iommu-map = <0x0   &apps_smmu 0x1d00 0x1>,
+				    <0x100 &apps_smmu 0x1d01 0x1>;
 
 			resets = <&gcc GCC_PCIE_2_BCR>;
 			reset-names = "pci";
-- 
2.53.0



