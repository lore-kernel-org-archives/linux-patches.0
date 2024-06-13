Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA49143870;
	Thu, 13 Jun 2024 12:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280394; cv=none; b=DVhx7ZheUwTuqkrmYXwHwJKr1cpi8eO71YwZboxbBY/LCP+QTLQcXM4Xa3d2TiRmAiaMNABkAy61qM+6IkiNzc5elbx75WgZG751r7fA80HQ/a008vECenqKsxW+nhTmsWYkulc0DP0Lww9Ozzc1lpCvdPbMXb7V+0yoPKXWUEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280394; c=relaxed/simple;
	bh=ZIWDNTnRd8uLjU47PAJ+xwHpkRc/39e47LrogpRBV+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WViywTiFwZlexihlyhYvvJtpMyBFO8Pm3Vf2CUX1vWWXrEMpQ7rm8x3zNbhOuxMisbPY8Ij0FyHg2FepX6erGOeXcMAbhaVgGV+C0Ec5yuwZ7RfZQm/8iKrUxbwglGRhzuo0+ShbV137nCCeROODhdBV4fSzoeTbpBVhD5BiK0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XAGB7zR1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XAGB7zR1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60DFC2BBFC;
	Thu, 13 Jun 2024 12:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280394;
	bh=ZIWDNTnRd8uLjU47PAJ+xwHpkRc/39e47LrogpRBV+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XAGB7zR1KNCOisMH3uHDBN8F/kllGFRtY8wFcTGF33zsH53L62Pmo+kzP5slWXsGY
	 Mlq3tDMLVDY//Gp44Mx4pG6XGcT5yQbJvwXFKrY958YthxIyiIPfcQV5VJr1yhDcnX
	 gbTTwgrIyg6ogLpT9CC9J7cinZeftH1bmZ6Ia8UU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 037/137] arm64: dts: qcom: sc8280xp: add missing PCIe minimum OPP
Date: Thu, 13 Jun 2024 13:33:37 +0200
Message-ID: <20240613113224.731131953@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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
@@ -1798,6 +1798,7 @@
 			assigned-clock-rates = <100000000>;
 
 			power-domains = <&gcc PCIE_4_GDSC>;
+			required-opps = <&rpmhpd_opp_nom>;
 
 			resets = <&gcc GCC_PCIE_4_PHY_BCR>;
 			reset-names = "phy";
@@ -1897,6 +1898,7 @@
 			assigned-clock-rates = <100000000>;
 
 			power-domains = <&gcc PCIE_3B_GDSC>;
+			required-opps = <&rpmhpd_opp_nom>;
 
 			resets = <&gcc GCC_PCIE_3B_PHY_BCR>;
 			reset-names = "phy";
@@ -1997,6 +1999,7 @@
 			assigned-clock-rates = <100000000>;
 
 			power-domains = <&gcc PCIE_3A_GDSC>;
+			required-opps = <&rpmhpd_opp_nom>;
 
 			resets = <&gcc GCC_PCIE_3A_PHY_BCR>;
 			reset-names = "phy";
@@ -2098,6 +2101,7 @@
 			assigned-clock-rates = <100000000>;
 
 			power-domains = <&gcc PCIE_2B_GDSC>;
+			required-opps = <&rpmhpd_opp_nom>;
 
 			resets = <&gcc GCC_PCIE_2B_PHY_BCR>;
 			reset-names = "phy";
@@ -2198,6 +2202,7 @@
 			assigned-clock-rates = <100000000>;
 
 			power-domains = <&gcc PCIE_2A_GDSC>;
+			required-opps = <&rpmhpd_opp_nom>;
 
 			resets = <&gcc GCC_PCIE_2A_PHY_BCR>;
 			reset-names = "phy";


