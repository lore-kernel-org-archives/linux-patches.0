Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E697E364049;
	Sat, 12 Sep 2026 08:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201878; cv=none; b=rik25+lxbd/dS2phW7YpkjeXdgscemgs4uBVNO0/ILTL5GM2ZIWrLbUTTqeY2g2HsIL6uxhYh22ola0EPoddtIyLYhNpBmrAbC4jZKK+F8VsR00Au1OijsO4TvVSGGb8OVtTw6oZ+jQxoWzyxUfxYEeaH2LxmbeQal5DxzPlfp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201878; c=relaxed/simple;
	bh=SVJYRY3ncwEF+NrCFadVXd6p8uWs0/mJWi9zRACGrTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFe7EwPMt2XlN+aTz1U/sGF2H+k7GKMWXGZd00gmj5tBGnynoIdu3kAZCxXn6yF6D5boIbdQA69k1uwjJ5Uq4l7sW+LE9A3F43W5zZDM6CF9nYpLV8r7ID0LaGGxT2QiepQ9ncu0Gl/duuNkDWdncVAeC9VHme0undSpCUri7ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=En8IuYnm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="En8IuYnm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F8C91F000FF;
	Sat, 12 Sep 2026 08:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201876;
	bh=FSHlW6aRjsIns9A0SgvupjF7RyKumXjuux+bYULeK/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=En8IuYnmA5v4WQocb9fXZ6JaWwb3Iwvsa0f9uju4IB0FvgTx98qk7Lh4sT0FmKOvs
	 Ol1U4rVWANaYBJENE9UvUNhoLI4LHfVDupFr2uBD1xyqwX6kJbSsfpIGNuW1Zr1ypk
	 fyghHopOiM7iCbz2ZQL1BHKGLsnKZyYdU0k2xE94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1086/1815] arm64: dts: qcom: glymur: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies
Date: Sat, 12 Sep 2026 08:47:16 +0200
Message-ID: <20260912065714.516091033@linuxfoundation.org>
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

[ Upstream commit c3c6b388edba50aad0d41b0b2a5e50482e320611 ]

The QMP PHY expects the vdda-phy supply to be the lower voltage (~0.8V)
and the vdda-pll supply to be the higher voltage (~1.2V), as used by the
DisplayPort QMP PHY on this SoC. But these two supplies are swapped for
the USB QMP PHYs on this board, feeding 1.2V to vdda-phy and 0.72V/0.83V
to vdda-pll.

Fix it by swapping the two supplies back.

Fixes: c8b63029455b ("arm64: dts: qcom: glymur-crd: Enable USB support")
Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Assisted-by: Claude:opus-4-8
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260803-phy-supply-fix-v1-24-5880630cde3e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/glymur-crd.dtsi | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/glymur-crd.dtsi b/arch/arm64/boot/dts/qcom/glymur-crd.dtsi
index fcf497a8356e2..79548f6f03f3f 100644
--- a/arch/arm64/boot/dts/qcom/glymur-crd.dtsi
+++ b/arch/arm64/boot/dts/qcom/glymur-crd.dtsi
@@ -1056,8 +1056,8 @@ &usb_0_hsphy {
 };
 
 &usb_0_qmpphy {
-	vdda-phy-supply = <&vreg_l4h_e0_1p2>;
-	vdda-pll-supply = <&vreg_l3f_e0_0p72>;
+	vdda-phy-supply = <&vreg_l3f_e0_0p72>;
+	vdda-pll-supply = <&vreg_l4h_e0_1p2>;
 	refgen-supply = <&vreg_l2f_e0_0p82>;
 
 	status = "okay";
@@ -1085,8 +1085,8 @@ &usb_1_hsphy {
 };
 
 &usb_1_qmpphy {
-	vdda-phy-supply = <&vreg_l4h_e0_1p2>;
-	vdda-pll-supply = <&vreg_l1h_e0_0p89>;
+	vdda-phy-supply = <&vreg_l1h_e0_0p89>;
+	vdda-pll-supply = <&vreg_l4h_e0_1p2>;
 	refgen-supply = <&vreg_l2f_e0_0p82>;
 
 	status = "okay";
@@ -1130,16 +1130,16 @@ &usb_mp_hsphy1 {
 };
 
 &usb_mp_qmpphy0 {
-	vdda-phy-supply = <&vreg_l4h_e0_1p2>;
-	vdda-pll-supply = <&vreg_l2h_e0_0p72>;
+	vdda-phy-supply = <&vreg_l2h_e0_0p72>;
+	vdda-pll-supply = <&vreg_l4h_e0_1p2>;
 	refgen-supply = <&vreg_l4f_e1_1p08>;
 
 	status = "okay";
 };
 
 &usb_mp_qmpphy1 {
-	vdda-phy-supply = <&vreg_l4h_e0_1p2>;
-	vdda-pll-supply = <&vreg_l2h_e0_0p72>;
+	vdda-phy-supply = <&vreg_l2h_e0_0p72>;
+	vdda-pll-supply = <&vreg_l4h_e0_1p2>;
 	refgen-supply = <&vreg_l4f_e1_1p08>;
 
 	status = "okay";
-- 
2.53.0



