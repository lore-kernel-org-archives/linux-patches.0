Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C59381B0F;
	Sat, 12 Sep 2026 08:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201844; cv=none; b=jRcYdVLJ+bklWTq5pbK4F9jP2IeHXixzt984nB2G5QYF9iXAXGAsS+idR6kgAkgR4b6IC6zB6eCNwmrTnOTMUTuBaVx53v7ZR3s7g0/dzyjw5HzUOK48NGaSmVhSRubK2SoGnW1g+SlfFgdqCwHiHq00dUPEEhJdP1/0vLNmYps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201844; c=relaxed/simple;
	bh=ac36J+x2cprpG++dEEGq9XQz5j0pYrKNGUhGgIAWSv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T560IW9iVC2ca5T9JeTq6xvpZPXacEOCsdVg6VzYKl/eaDuyavsKQt7IIcrntleX4TVA8S0OYZFGSaSCbEx7q0F/johUPvgF+8e1XRJ18jZaMVAlzXksQEl/ZC8oP42L45dSd7vQhHktxYshBCHiGSonpravwOjFjvYBM+EM178=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gYBMqhCB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gYBMqhCB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D236D1F000FF;
	Sat, 12 Sep 2026 08:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201842;
	bh=O+uEtpt6kuRANRB0Qc1ZPMFNglbaoXvDaPubsUKfDFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gYBMqhCBEc3gqSDiF+4W5OGe776azIg3lGREEknj+MT2CgpM2tX/22FPWjf5u8Cdw
	 rpgQ52gZWyKMTRHV5LRXwqRNRx5XYbjWFQSzBwbVIcNbp+UCEnMh0d56xnpGvNsPRj
	 a5kLZ2IItV71T07jnnr3HIjCzUSR3L7FTIxOCmDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1079/1815] arm64: dts: qcom: sc8180x: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies
Date: Sat, 12 Sep 2026 08:47:09 +0200
Message-ID: <20260912065714.352006036@linuxfoundation.org>
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

[ Upstream commit 8e1877c41c2ee4ad245e1c26c98f3b4cb2585162 ]

The QMP PHY expects the vdda-phy supply to be around 0.88V and the
vdda-pll supply to be 1.2V. But these two supplies are swapped for the
USB QMP PHYs on these boards, feeding 1.2V to vdda-phy and 0.88V to
vdda-pll.

Fix it by swapping the two supplies back.

Fixes: 2ce38cc1e8fe ("arm64: dts: qcom: sc8180x: Introduce Primus")
Fixes: 20dea72a393c ("arm64: dts: qcom: sc8180x: Introduce Lenovo Flex 5G")
Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Assisted-by: Claude:opus-4-8
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260803-phy-supply-fix-v1-17-5880630cde3e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/qcom/sc8180x-lenovo-flex-5g.dts     | 16 ++++++++--------
 arch/arm64/boot/dts/qcom/sc8180x-primus.dts      | 16 ++++++++--------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8180x-lenovo-flex-5g.dts b/arch/arm64/boot/dts/qcom/sc8180x-lenovo-flex-5g.dts
index 7601afc3d7bf9..565e5a9979b1a 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x-lenovo-flex-5g.dts
+++ b/arch/arm64/boot/dts/qcom/sc8180x-lenovo-flex-5g.dts
@@ -611,15 +611,15 @@ &usb_mp_hsphy1 {
 };
 
 &usb_mp_qmpphy0 {
-	vdda-phy-supply = <&vreg_l3c_1p2>;
-	vdda-pll-supply = <&vreg_l5e_0p88>;
+	vdda-phy-supply = <&vreg_l5e_0p88>;
+	vdda-pll-supply = <&vreg_l3c_1p2>;
 
 	status = "okay";
 };
 
 &usb_mp_qmpphy1 {
-	vdda-phy-supply = <&vreg_l3c_1p2>;
-	vdda-pll-supply = <&vreg_l5e_0p88>;
+	vdda-phy-supply = <&vreg_l5e_0p88>;
+	vdda-pll-supply = <&vreg_l3c_1p2>;
 
 	status = "okay";
 };
@@ -633,8 +633,8 @@ &usb_prim_hsphy {
 };
 
 &usb_prim_qmpphy {
-	vdda-phy-supply = <&vreg_l3c_1p2>;
-	vdda-pll-supply = <&vreg_l5e_0p88>;
+	vdda-phy-supply = <&vreg_l5e_0p88>;
+	vdda-pll-supply = <&vreg_l3c_1p2>;
 
 	orientation-switch;
 
@@ -674,8 +674,8 @@ &usb_sec_hsphy {
 };
 
 &usb_sec_qmpphy {
-	vdda-phy-supply = <&vreg_l3c_1p2>;
-	vdda-pll-supply = <&vreg_l5e_0p88>;
+	vdda-phy-supply = <&vreg_l5e_0p88>;
+	vdda-pll-supply = <&vreg_l3c_1p2>;
 
 	orientation-switch;
 
diff --git a/arch/arm64/boot/dts/qcom/sc8180x-primus.dts b/arch/arm64/boot/dts/qcom/sc8180x-primus.dts
index e34f4758ebe28..c10a936b320a9 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x-primus.dts
+++ b/arch/arm64/boot/dts/qcom/sc8180x-primus.dts
@@ -703,15 +703,15 @@ &usb_mp_hsphy1 {
 };
 
 &usb_mp_qmpphy0 {
-	vdda-phy-supply = <&vreg_l3c_1p2>;
-	vdda-pll-supply = <&vreg_l5e_0p88>;
+	vdda-phy-supply = <&vreg_l5e_0p88>;
+	vdda-pll-supply = <&vreg_l3c_1p2>;
 
 	status = "okay";
 };
 
 &usb_mp_qmpphy1 {
-	vdda-phy-supply = <&vreg_l3c_1p2>;
-	vdda-pll-supply = <&vreg_l5e_0p88>;
+	vdda-phy-supply = <&vreg_l5e_0p88>;
+	vdda-pll-supply = <&vreg_l3c_1p2>;
 
 	status = "okay";
 };
@@ -725,8 +725,8 @@ &usb_prim_hsphy {
 };
 
 &usb_prim_qmpphy {
-	vdda-phy-supply = <&vreg_l3c_1p2>;
-	vdda-pll-supply = <&vreg_l5e_0p88>;
+	vdda-phy-supply = <&vreg_l5e_0p88>;
+	vdda-pll-supply = <&vreg_l3c_1p2>;
 
 	orientation-switch;
 
@@ -762,8 +762,8 @@ &usb_sec_hsphy {
 };
 
 &usb_sec_qmpphy {
-	vdda-phy-supply = <&vreg_l3c_1p2>;
-	vdda-pll-supply = <&vreg_l5e_0p88>;
+	vdda-phy-supply = <&vreg_l5e_0p88>;
+	vdda-pll-supply = <&vreg_l3c_1p2>;
 
 	orientation-switch;
 
-- 
2.53.0



