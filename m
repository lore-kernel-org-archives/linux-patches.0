Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B95F1A6193;
	Tue, 30 Jul 2024 16:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356185; cv=none; b=Pa+k4WzGwL/MuYNQJCaUtnMtoz6eGMTfI+EhwQVPiAAxmkYccYFSJisii6PUkzoLEyGhRPASAFfnaQovhvsqphGk66XFBDVSmD8XmO9adMFO61fsdWhAfzFSOHnLtAY88ZecPNw8VtfQzSMTkadcKF/D4ED12QfKyDF6VkT5MAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356185; c=relaxed/simple;
	bh=guowVK68/GYabnF2dt3i+PabfvSOYnnGf/hL+XBUWsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F28Po20+B2K/O4/+zoGauEuKvuQH/215N78aQWNU5PcZnV8dt9nEKEP21oxhuBvkjNbBxlSLd4b2rcugNCoywz/UwwYh12vMxYdk2WtzMwo998IXpM9SA+mHp5MP5YXKQucF1LpDlUtMUfla6Fz/Yr+mrnQkS2+mvS8lxgB68zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0JYl3GE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0JYl3GE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5FEC32782;
	Tue, 30 Jul 2024 16:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356185;
	bh=guowVK68/GYabnF2dt3i+PabfvSOYnnGf/hL+XBUWsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0JYl3GEJy3r2gNTtnz12WczrB4enfbK1ZcSKcE+EeF+yLAHMuOwgBtp/amG1njfi
	 oHS8k+grsG7lf9b8BFAa8arBcC+LTG6hU9TIAGdV/K/DvpdE1N3aA+27Xlkaue4Ols
	 kHu6SffXC2muDn8VXd74y+B3b3vELFJAWLzAI3+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 127/809] arm64: dts: qcom: x1e80100: Fix USB HS PHY 0.8V supply
Date: Tue, 30 Jul 2024 17:40:03 +0200
Message-ID: <20240730151729.634914085@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@linaro.org>

[ Upstream commit 9c99c33a904c86d95ecf4e2690de6a826b88671c ]

According to the power grid documentation, the 0.8v HS PHY shared
regulator is actually LDO3 from PM8550ve id J. Fix both CRD and QCP
boards.

Fixes: d7e03cce0400 ("arm64: dts: qcom: x1e80100-crd: Enable more support")
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240629-x1e80100-dts-fix-hsphy-0-8v-supplies-v1-1-de99ee030b27@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-crd.dts | 6 +++---
 arch/arm64/boot/dts/qcom/x1e80100-qcp.dts | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100-crd.dts b/arch/arm64/boot/dts/qcom/x1e80100-crd.dts
index 7618ae1f8b1c9..b063dd28149e7 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-crd.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-crd.dts
@@ -840,7 +840,7 @@ &uart21 {
 };
 
 &usb_1_ss0_hsphy {
-	vdd-supply = <&vreg_l2e_0p8>;
+	vdd-supply = <&vreg_l3j_0p8>;
 	vdda12-supply = <&vreg_l2j_1p2>;
 
 	phys = <&smb2360_0_eusb2_repeater>;
@@ -865,7 +865,7 @@ &usb_1_ss0_dwc3 {
 };
 
 &usb_1_ss1_hsphy {
-	vdd-supply = <&vreg_l2e_0p8>;
+	vdd-supply = <&vreg_l3j_0p8>;
 	vdda12-supply = <&vreg_l2j_1p2>;
 
 	phys = <&smb2360_1_eusb2_repeater>;
@@ -890,7 +890,7 @@ &usb_1_ss1_dwc3 {
 };
 
 &usb_1_ss2_hsphy {
-	vdd-supply = <&vreg_l2e_0p8>;
+	vdd-supply = <&vreg_l3j_0p8>;
 	vdda12-supply = <&vreg_l2j_1p2>;
 
 	phys = <&smb2360_2_eusb2_repeater>;
diff --git a/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts b/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
index 5567636c8b27f..df3577fcd93c9 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
@@ -536,7 +536,7 @@ &uart21 {
 };
 
 &usb_1_ss0_hsphy {
-	vdd-supply = <&vreg_l2e_0p8>;
+	vdd-supply = <&vreg_l3j_0p8>;
 	vdda12-supply = <&vreg_l2j_1p2>;
 
 	phys = <&smb2360_0_eusb2_repeater>;
@@ -561,7 +561,7 @@ &usb_1_ss0_dwc3 {
 };
 
 &usb_1_ss1_hsphy {
-	vdd-supply = <&vreg_l2e_0p8>;
+	vdd-supply = <&vreg_l3j_0p8>;
 	vdda12-supply = <&vreg_l2j_1p2>;
 
 	phys = <&smb2360_1_eusb2_repeater>;
@@ -586,7 +586,7 @@ &usb_1_ss1_dwc3 {
 };
 
 &usb_1_ss2_hsphy {
-	vdd-supply = <&vreg_l2e_0p8>;
+	vdd-supply = <&vreg_l3j_0p8>;
 	vdda12-supply = <&vreg_l2j_1p2>;
 
 	phys = <&smb2360_2_eusb2_repeater>;
-- 
2.43.0



