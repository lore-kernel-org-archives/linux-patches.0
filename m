Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8E9146592;
	Thu, 13 Jun 2024 11:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279396; cv=none; b=j97kaNEsnEtihy3AqHhCUsq/T9o2Zx7hH7k7MEcq8bCFtxHKIVpuq2AYc/5/4xGNfJe8fRcDCgCURZcM6UNx/+ev8gOzAA94DRwi/SeYOG2Rd12c+NCvqrw2cTpg0FBg4RH3jsxRV8jRV+xNAPdvoDDPh+xvGLcamKHpCNcQ0zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279396; c=relaxed/simple;
	bh=GBBjBpMWgI5FJg5/eP56rPrHrjCOxFISW+bcMzZyWFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=byp7QdDmWtf/O7jEP/RB8tzZtynRgJu88V2kE5TeClL3GCBFjdS61xHUwFgxExjP3LVoEdHKxm6Bkn3DH1kHJspnVp5rCMCXfPHKEIY++Vz+h1qWGvnwzx3lfMUMxABIzO2xf+AvbNvGq3oqDnXJGoCz10y7egi2DWSiIRkh9ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vutj71pr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vutj71pr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4226C32786;
	Thu, 13 Jun 2024 11:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279396;
	bh=GBBjBpMWgI5FJg5/eP56rPrHrjCOxFISW+bcMzZyWFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vutj71prfuJMGbh7y0Fhw0uQTi0fpgoM6SiP/9E+l7tRPpwk1TgqRFbNbJGuK2ZIs
	 r2fZahiUz7hjwmnUF+vyC53PoAU/Qmpc9eC1AL+17nMUbfDZNAB5frTX1ftBdyWVPO
	 IzHLqo2VagHYtWvmiiuCleM5LgAB0LmMaEEe8uJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.9 031/157] arm64: dts: qcom: sc8280xp: add missing PCIe minimum OPP
Date: Thu, 13 Jun 2024 13:32:36 +0200
Message-ID: <20240613113228.621392035@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 2b621971554a94094cf489314dc1c2b65401965c upstream.

Add the missing PCIe CX performance level votes to avoid relying on
other drivers (e.g. USB or UFS) to maintain the nominal performance
level required for Gen3 speeds.

Fixes: 813e83157001 ("arm64: dts: qcom: sc8280xp/sa8540p: add PCIe2-4 nodes")
Cc: stable@vger.kernel.org      # 6.2
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20240306095651.4551-5-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -1799,6 +1799,7 @@
 			assigned-clock-rates = <100000000>;
 
 			power-domains = <&gcc PCIE_4_GDSC>;
+			required-opps = <&rpmhpd_opp_nom>;
 
 			resets = <&gcc GCC_PCIE_4_PHY_BCR>;
 			reset-names = "phy";
@@ -1898,6 +1899,7 @@
 			assigned-clock-rates = <100000000>;
 
 			power-domains = <&gcc PCIE_3B_GDSC>;
+			required-opps = <&rpmhpd_opp_nom>;
 
 			resets = <&gcc GCC_PCIE_3B_PHY_BCR>;
 			reset-names = "phy";
@@ -1998,6 +2000,7 @@
 			assigned-clock-rates = <100000000>;
 
 			power-domains = <&gcc PCIE_3A_GDSC>;
+			required-opps = <&rpmhpd_opp_nom>;
 
 			resets = <&gcc GCC_PCIE_3A_PHY_BCR>;
 			reset-names = "phy";
@@ -2099,6 +2102,7 @@
 			assigned-clock-rates = <100000000>;
 
 			power-domains = <&gcc PCIE_2B_GDSC>;
+			required-opps = <&rpmhpd_opp_nom>;
 
 			resets = <&gcc GCC_PCIE_2B_PHY_BCR>;
 			reset-names = "phy";
@@ -2199,6 +2203,7 @@
 			assigned-clock-rates = <100000000>;
 
 			power-domains = <&gcc PCIE_2A_GDSC>;
+			required-opps = <&rpmhpd_opp_nom>;
 
 			resets = <&gcc GCC_PCIE_2A_PHY_BCR>;
 			reset-names = "phy";


