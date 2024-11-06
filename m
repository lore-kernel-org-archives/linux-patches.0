Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC0F1E1322;
	Wed,  6 Nov 2024 12:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896492; cv=none; b=nyzhqRD0DJDBI5o2j2EoMCdJJHzUDpI4K1epp8OH1f6T29xd6D/6UqFg99ZN/c7z1OZ03oUZ8ZURvwVocg/GXt/8nWxH6d21svnRVhaig2uFOKH6xEqFIBuMiil2Si+rhqiREfL3HK+BT/nMIbKmtFC3dvmkJ56Y3udgts+34XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896492; c=relaxed/simple;
	bh=ZsO7XpcE/jakp6QQ0Su1B4E7XMtZllrwx+NTDxcE2L0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eZtfe0dXN4c1zVCcDLYGP8tm+Y/2Q75CF1W31BUE4TG4ADxMpTc1dpq5Ar0MKmCZo379ryZqigJWUxQIMiqlesVW4bgQsj/JAOlvBXIzXu7QMm422TC5V6//fJdAg0cJ37oEGIkMgzAHd31jfO7RwknhWJtTbkXOF93zKeQrmDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Myw9TV33; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Myw9TV33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D05AC4CED3;
	Wed,  6 Nov 2024 12:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896492;
	bh=ZsO7XpcE/jakp6QQ0Su1B4E7XMtZllrwx+NTDxcE2L0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Myw9TV33yOB/LGGGrrpuZCQlayhmeSPoxSEniLfykI5wvGAzF4w1V/0ZWawfkOxgT
	 ULJPxOLNNUHerHvXoEg9ZC31f12x/sw6SBMr1GbXP3jtmP3PAGu++255jw286MRYZQ
	 CfY7HKOdjRm6ngmCKhHdWYC3J9xmaLsfiy3W6oBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.11 220/245] arm64: dts: qcom: x1e80100: fix PCIe4 and PCIe6a PHY clocks
Date: Wed,  6 Nov 2024 13:04:33 +0100
Message-ID: <20241106120324.672914488@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 27727cb6604e0998d03d9ec063b517b239d2bb0f upstream.

Add the missing clkref enable and pipediv2 clocks to the PCIe4 and
PCIe6a PHYs.

Fixes: 5eb83fc10289 ("arm64: dts: qcom: x1e80100: Add PCIe nodes")
Cc: stable@vger.kernel.org	# 6.9
Cc: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Konrad Dybcio <konradybcio@kernel.org>
Link: https://lore.kernel.org/r/20240916082307.29393-3-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -2973,14 +2973,16 @@
 
 			clocks = <&gcc GCC_PCIE_6A_PHY_AUX_CLK>,
 				 <&gcc GCC_PCIE_6A_CFG_AHB_CLK>,
-				 <&rpmhcc RPMH_CXO_CLK>,
+				 <&tcsr TCSR_PCIE_4L_CLKREF_EN>,
 				 <&gcc GCC_PCIE_6A_PHY_RCHNG_CLK>,
-				 <&gcc GCC_PCIE_6A_PIPE_CLK>;
+				 <&gcc GCC_PCIE_6A_PIPE_CLK>,
+				 <&gcc GCC_PCIE_6A_PIPEDIV2_CLK>;
 			clock-names = "aux",
 				      "cfg_ahb",
 				      "ref",
 				      "rchng",
-				      "pipe";
+				      "pipe",
+				      "pipediv2";
 
 			resets = <&gcc GCC_PCIE_6A_PHY_BCR>,
 				 <&gcc GCC_PCIE_6A_NOCSR_COM_PHY_BCR>;
@@ -3105,14 +3107,16 @@
 
 			clocks = <&gcc GCC_PCIE_4_AUX_CLK>,
 				 <&gcc GCC_PCIE_4_CFG_AHB_CLK>,
-				 <&rpmhcc RPMH_CXO_CLK>,
+				 <&tcsr TCSR_PCIE_2L_4_CLKREF_EN>,
 				 <&gcc GCC_PCIE_4_PHY_RCHNG_CLK>,
-				 <&gcc GCC_PCIE_4_PIPE_CLK>;
+				 <&gcc GCC_PCIE_4_PIPE_CLK>,
+				 <&gcc GCC_PCIE_4_PIPEDIV2_CLK>;
 			clock-names = "aux",
 				      "cfg_ahb",
 				      "ref",
 				      "rchng",
-				      "pipe";
+				      "pipe",
+				      "pipediv2";
 
 			resets = <&gcc GCC_PCIE_4_PHY_BCR>;
 			reset-names = "phy";


