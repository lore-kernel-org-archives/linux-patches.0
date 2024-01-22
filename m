Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CB162A13;
	Tue, 23 Jan 2024 01:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974999; cv=none; b=KwBFjCQyNesiTn/W0nEcOrG+KMtJvn9dmWFSEhot43omwfMdIACftX1QMyHZPYYSqmlrEgmvpA6yYXe4Evcyw4dLfjl8rdjizpQtmD6Ia9yF7gmxZCZuZYe5U4+Rp7zghIQjgri0RLNN1ZVFlprbmq0xgGVpTOnDutWshW75SfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974999; c=relaxed/simple;
	bh=rd76ELiHWwhH8qJO+mKotgvmPoTYrNMd26k6Tslq+Po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lTjEFrYlaGzd9MMX8QLUONsnteuNM5KfO4yMipLZTi03oiYTiB/T+MhBdpEJpxeWQkO17l21tFDn8gCjDhRVGyFsZtsfwn9qTf3mUw+DwMwhMsJWodJVuy5wx7Y4Qm9nLNhnxCk8y3IqvBJPA2/c6qh+yxgEenKDXEYv2Pcqm9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDOPwjdW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDOPwjdW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54065C433C7;
	Tue, 23 Jan 2024 01:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974999;
	bh=rd76ELiHWwhH8qJO+mKotgvmPoTYrNMd26k6Tslq+Po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wDOPwjdWTZl28Rny1okEZ22IG+0XfiyR4wXvY8bY52icuYEZEXaLZGdOpVemc0FN6
	 ukMWPasHLCRtqrR37iqcG8uHnh9pjJ2n5HDvKODUMtumnIFNJIpP0UsJ8LectjMpLm
	 A4HbABsnRkJ1P+8XcBWJ4ZBOc1HO3ukYuTupqBz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 187/583] arm64: dts: qcom: sc8180x: Fix up PCIe nodes
Date: Mon, 22 Jan 2024 15:53:58 -0800
Message-ID: <20240122235817.721667485@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 78403b37f6770441f80a78d13772394731afe055 ]

Duplicated clock output names cause probe errors and wrong clocks cause
hardware not to work. Fix such issues.

Fixes: d20b6c84f56a ("arm64: dts: qcom: sc8180x: Add PCIe instances")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231219-topic-8180_pcie-v1-1-c2acbba4723c@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8180x.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8180x.dtsi b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
index dfaeb337960e..f4381424e70a 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8180x.dtsi
@@ -1762,7 +1762,7 @@ pcie0_phy: phy@1c06000 {
 			clocks = <&gcc GCC_PCIE_PHY_AUX_CLK>,
 				 <&gcc GCC_PCIE_0_CFG_AHB_CLK>,
 				 <&gcc GCC_PCIE_0_CLKREF_CLK>,
-				 <&gcc GCC_PCIE1_PHY_REFGEN_CLK>,
+				 <&gcc GCC_PCIE0_PHY_REFGEN_CLK>,
 				 <&gcc GCC_PCIE_0_PIPE_CLK>;
 			clock-names = "aux",
 				      "cfg_ahb",
@@ -1860,7 +1860,7 @@ pcie3_phy: phy@1c0c000 {
 			clocks = <&gcc GCC_PCIE_PHY_AUX_CLK>,
 				 <&gcc GCC_PCIE_3_CFG_AHB_CLK>,
 				 <&gcc GCC_PCIE_3_CLKREF_CLK>,
-				 <&gcc GCC_PCIE2_PHY_REFGEN_CLK>,
+				 <&gcc GCC_PCIE3_PHY_REFGEN_CLK>,
 				 <&gcc GCC_PCIE_3_PIPE_CLK>;
 			clock-names = "aux",
 				      "cfg_ahb",
@@ -2066,7 +2066,7 @@ pcie2_phy: phy@1c1c000 {
 				      "refgen",
 				      "pipe";
 			#clock-cells = <0>;
-			clock-output-names = "pcie_3_pipe_clk";
+			clock-output-names = "pcie_2_pipe_clk";
 
 			#phy-cells = <0>;
 
-- 
2.43.0



