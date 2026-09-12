Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967FC381B0F;
	Sat, 12 Sep 2026 08:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201829; cv=none; b=cULM8AvhwgDvNLHkuKcCMItw3Hm7ehu0enHfR0eSOdm3DwXVxgI7lz5nxJj6Jlnyhd0wqOMLdu/rUkB083qVAL7/FxQnOQ04JlpX4fJq2ljhqhNRXf5Jj0d+bkcxJq0Ig9S0Gkkb0NEcgggHlr86fRxCGfYjtRXSW7FcZ6sKJrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201829; c=relaxed/simple;
	bh=DZVW6LqzoCQk8E3aJhCYkkYtQ0yoCBHu+HAT+8Tqew0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMp1RZQj2QKfa+pyulupD0wLOGk5et032MIeed8g2jJLssUogqzqJmijhE7w5VPNFt7A0BBmm1LaBbe75iOfHJD73BKPoWwVLXembJ25RLnL7MTENWsUNZJFPcFTpDbmQpXcaaxtU3e3BAay8pV97oUZR3KNxC+IrlYpKiu3syE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ttwDZu2h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ttwDZu2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26021F000FF;
	Sat, 12 Sep 2026 08:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201828;
	bh=lZp7RrFcrEzwXEmtUahnVVCkjYeVLnXo1aTdWZ2vdJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ttwDZu2hmyZRFYPJaNHR4Tle6fJv3ditWq5bxp7RgWumPmduF/FxF9Jux7IMbTRO4
	 kP64iJqPJKc/Gz2jgJBtr9olQXNDWlOheTjwA5YltJt4J27V44WYdfme2buNvevzAo
	 M8wQMOHa4ty4+XC4l9LD5vXPYQtS6+Wgg1XV64bQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1077/1815] arm64: dts: qcom: sc7180: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies
Date: Sat, 12 Sep 2026 08:47:07 +0200
Message-ID: <20260912065714.304968094@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit 2c45c4df3079acba14920b14286cebfea24ec603 ]

The QMP PHY expects the vdda-phy supply to be around 0.88V and the
vdda-pll supply to be 1.2V. But these two supplies are swapped for the
USB QMP PHYs on these boards, feeding 1.2V to vdda-phy and 0.9V to
vdda-pll.

Fix it by swapping the two supplies back.

Fixes: 0b766e7fe5a2 ("arm64: dts: qcom: sc7180: Add USB related nodes")
Fixes: 7ec3e67307f8 ("arm64: dts: qcom: sc7180-trogdor: add initial trogdor and lazor dt")
Fixes: 4a9f8f8f2ada ("arm64: dts: qcom: Add Acer Aspire 1")
Fixes: de8eed359759 ("arm64: dts: qcom: Add support for ECS LIVA QC710")
Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Assisted-by: Claude:opus-4-8
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260803-phy-supply-fix-v1-15-5880630cde3e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180-acer-aspire1.dts   | 4 ++--
 arch/arm64/boot/dts/qcom/sc7180-ecs-liva-qc710.dts | 4 ++--
 arch/arm64/boot/dts/qcom/sc7180-idp.dts            | 4 ++--
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi       | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-acer-aspire1.dts b/arch/arm64/boot/dts/qcom/sc7180-acer-aspire1.dts
index 1514da6362698..d9c70897b6f1c 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-acer-aspire1.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-acer-aspire1.dts
@@ -631,8 +631,8 @@ &usb_1_hsphy {
 };
 
 &usb_1_qmpphy {
-	vdda-phy-supply = <&vreg_l3c_1p2>;
-	vdda-pll-supply = <&vreg_l4a_0p8>;
+	vdda-phy-supply = <&vreg_l4a_0p8>;
+	vdda-pll-supply = <&vreg_l3c_1p2>;
 
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/sc7180-ecs-liva-qc710.dts b/arch/arm64/boot/dts/qcom/sc7180-ecs-liva-qc710.dts
index b84da371581b9..3100fab18787a 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-ecs-liva-qc710.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-ecs-liva-qc710.dts
@@ -563,8 +563,8 @@ &usb_1_hsphy {
 };
 
 &usb_1_qmpphy {
-	vdda-phy-supply = <&vreg_l3c_1p2>;
-	vdda-pll-supply = <&vreg_l4a_0p8>;
+	vdda-phy-supply = <&vreg_l4a_0p8>;
+	vdda-pll-supply = <&vreg_l3c_1p2>;
 
 	/delete-property/ mode-switch;
 	/delete-property/ orientation-switch;
diff --git a/arch/arm64/boot/dts/qcom/sc7180-idp.dts b/arch/arm64/boot/dts/qcom/sc7180-idp.dts
index 0bce3eefca2e9..acfb9937651d6 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-idp.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-idp.dts
@@ -461,8 +461,8 @@ &usb_1_hsphy {
 
 &usb_1_qmpphy {
 	status = "okay";
-	vdda-phy-supply = <&vreg_l3c_1p2>;
-	vdda-pll-supply = <&vreg_l4a_0p8>;
+	vdda-phy-supply = <&vreg_l4a_0p8>;
+	vdda-pll-supply = <&vreg_l3c_1p2>;
 };
 
 &venus {
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
index cd4a0e281cf8f..0e0bc8543f714 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
@@ -998,8 +998,8 @@ &usb_1_hsphy {
 
 &usb_1_qmpphy {
 	status = "okay";
-	vdda-phy-supply = <&vdda_usb_ss_dp_1p2>;
-	vdda-pll-supply = <&vdda_usb_ss_dp_core>;
+	vdda-phy-supply = <&vdda_usb_ss_dp_core>;
+	vdda-pll-supply = <&vdda_usb_ss_dp_1p2>;
 };
 
 &venus {
-- 
2.53.0



