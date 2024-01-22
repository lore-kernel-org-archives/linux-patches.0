Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FBF15444A;
	Tue, 23 Jan 2024 00:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969378; cv=none; b=bMVubaccYHVmMcuuEh6szO8Mqr64voOJWrzIekz70AHPBc1DN+fk6kJact5KToD09C6qI9MSqENIysoQYt9ppP7S/Wx0sCAEct4RJtx7S159cZ6xYgNek8sIsiHW2jQ5xOJwN4kmUx7GPBaUFftSnkR/71dAlU7WXc9G/PA5Y0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969378; c=relaxed/simple;
	bh=TV03OMiWYUy2j+THCQ0YI1Dv2Nhi2EKcNPmFoQ3yLUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Esx9UP/D2kv4e7tkHqpMZby6B0Jo35S5aB/9njhJxDibRS3J8YSB8XRE4RwaC7Gd2Q/YdY/KV/dS5Trd2x306unGR/D8VPThWtC8e07JoDRwpenCNUsFGLemipivV0tMLTmxKrhWpl2dXlWWuDVCLcBDt8uaK56Unt1foSCHz0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=saT+ePzU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="saT+ePzU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9306BC43394;
	Tue, 23 Jan 2024 00:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969377;
	bh=TV03OMiWYUy2j+THCQ0YI1Dv2Nhi2EKcNPmFoQ3yLUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=saT+ePzU+Th6F0obe/SbeqKQ5ymx7p46mv46I0rkOuFu0BOFehnv12MWW3MmM2iQK
	 eInVdIoOg0T3zjIlT5WcYGNPxQmRA6SUd0mcfDpjnYS3n+Ir9IUVBjWOn2vjCSTUJ1
	 5ir9POGoOGU0Apd1salfepREVsFOf2CglBvZ2ako=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 205/641] arm64: dts: qcom: sc8180x: Fix up PCIe nodes
Date: Mon, 22 Jan 2024 15:51:49 -0800
Message-ID: <20240122235824.370237034@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 59ab5428348d..b5eb84287870 100644
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



