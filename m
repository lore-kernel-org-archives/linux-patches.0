Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2E3AD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:13:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5D8C433F1;
	Wed,  4 Jan 2023 16:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672848790;
	bh=8jEAnOgj6WAwSacmCzKr6pansgO9Hlao88Dh9B6VRlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qgR00hM4xrAz54CgmsKS6QF5aOIMxYGb2LXXgCxMd17aMCRCHcGxA3Wl6k/w/9828
	 yxJrEqsbaqPLiPzyez/rHYfSm/vz90532vEKRZq5PBzUp6tJDrBIOz+LxL2mt9NIzC
	 oIyL5tVtzTR9HRggX/iQhxcD4UmGhTrDBcLZ2Rrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Brian Masney <bmasney@redhat.com>,
	Konrad Dybcio <konrad.dybcio@somainline.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.0 014/177] arm64: dts: qcom: sc8280xp: fix UFS reference clocks
Date: Wed,  4 Jan 2023 17:05:05 +0100
Message-Id: <20230104160508.088641235@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

commit f446022b932aff1d6a308ca5d537ec2b512debdc upstream.

There are three UFS reference clocks on SC8280XP which are used as
follows:

 - The GCC_UFS_REF_CLKREF_CLK clock is fed to any UFS device connected
   to either controller.

 - The GCC_UFS_1_CARD_CLKREF_CLK and GCC_UFS_CARD_CLKREF_CLK clocks
   provide reference clocks to the two PHYs.

Note that this depends on first updating the clock driver to reflect
that all three clocks are sourced from CXO. Specifically, the UFS
controller driver expects the device reference clock to have a valid
frequency:

	ufshcd-qcom 1d84000.ufs: invalid ref_clk setting = 0

Fixes: 152d1faf1e2f ("arm64: dts: qcom: add SC8280XP platform")
Fixes: 8d6b458ce6e9 ("arm64: dts: qcom: sc8280xp: fix ufs_card_phy ref clock")
Fixes: f3aa975e230e ("arm64: dts: qcom: sc8280xp: correct ref clock for ufs_mem_phy")
Link: https://lore.kernel.org/lkml/Y2OEjNAPXg5BfOxH@hovoldconsulting.com/
Cc: stable@vger.kernel.org	# 5.20
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221104092045.17410-2-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -861,7 +861,7 @@
 				 <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
 				 <&gcc GCC_UFS_PHY_AHB_CLK>,
 				 <&gcc GCC_UFS_PHY_UNIPRO_CORE_CLK>,
-				 <&rpmhcc RPMH_CXO_CLK>,
+				 <&gcc GCC_UFS_REF_CLKREF_CLK>,
 				 <&gcc GCC_UFS_PHY_TX_SYMBOL_0_CLK>,
 				 <&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>,
 				 <&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>;
@@ -892,7 +892,7 @@
 			ranges;
 			clock-names = "ref",
 				      "ref_aux";
-			clocks = <&gcc GCC_UFS_REF_CLKREF_CLK>,
+			clocks = <&gcc GCC_UFS_CARD_CLKREF_CLK>,
 				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>;
 
 			resets = <&ufs_mem_hc 0>;
@@ -930,7 +930,7 @@
 				 <&gcc GCC_AGGRE_UFS_CARD_AXI_CLK>,
 				 <&gcc GCC_UFS_CARD_AHB_CLK>,
 				 <&gcc GCC_UFS_CARD_UNIPRO_CORE_CLK>,
-				 <&rpmhcc RPMH_CXO_CLK>,
+				 <&gcc GCC_UFS_REF_CLKREF_CLK>,
 				 <&gcc GCC_UFS_CARD_TX_SYMBOL_0_CLK>,
 				 <&gcc GCC_UFS_CARD_RX_SYMBOL_0_CLK>,
 				 <&gcc GCC_UFS_CARD_RX_SYMBOL_1_CLK>;
@@ -961,7 +961,7 @@
 			ranges;
 			clock-names = "ref",
 				      "ref_aux";
-			clocks = <&gcc GCC_UFS_REF_CLKREF_CLK>,
+			clocks = <&gcc GCC_UFS_1_CARD_CLKREF_CLK>,
 				 <&gcc GCC_UFS_CARD_PHY_AUX_CLK>;
 
 			resets = <&ufs_card_hc 0>;


