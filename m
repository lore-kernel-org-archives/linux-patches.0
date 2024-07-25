Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C1419B3E2;
	Thu, 25 Jul 2024 14:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918317; cv=none; b=fPiFvb2jTVGq+0EutMuwowoK1TZIGARyguispqeFY59n4eHBricylBno1t/ndfUGrSF9EUh7Bk0IcClc32UpbWkniDoiLVGmUPA0a0o0FyLatqdfvugnc9oFVsApA0FWlVuJIKdcRYpbwJLsXsk5INsN78qYnjc2MO2Y9dKSGFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918317; c=relaxed/simple;
	bh=wEcCaD+1XuwyFSB13jMtHmH55RYJTf7Uy9tF0coQCRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/LtlqVYigesvJWNN7tQ8+00mX0Fxx2VI8zCgn7U1xfC9Y9PGW5DOeXzM9V4iwRRRGqZHMniMwYbLGDS3r6F815gfh7Z9HCS7D3lFjfHBE9gxtOliUXFGfoxkm29B3fQV2nF7VFwXMlgdbPu1Kh3DlWZeDv2nTEO/sWnVrAStR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M6OmgoF8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M6OmgoF8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A054C116B1;
	Thu, 25 Jul 2024 14:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918316;
	bh=wEcCaD+1XuwyFSB13jMtHmH55RYJTf7Uy9tF0coQCRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M6OmgoF85yOPVHwRQpxlDcUFmOzGRfxieHAAzUb3nFg67rhY6eABG+X2c/zx0ubos
	 aF4KWnoewFWNoo41vgUGptGGblDXnwq+BU1GqZkhV3PDZzAT2O6AwFCYLszRCwtVMe
	 knJ0zvPtpI2hJ1dc/NdithP//yfXvAfyRCTtGs44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.10 13/29] arm64: dts: qcom: x1e80100-qcp: Fix USB PHYs regulators
Date: Thu, 25 Jul 2024 16:36:29 +0200
Message-ID: <20240725142732.313824704@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142731.814288796@linuxfoundation.org>
References: <20240725142731.814288796@linuxfoundation.org>
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

commit 20676f7819d7364b7e8bd437b212106faa893b49 upstream.

The 1.2v HS PHY shared regulator is actually LDO2 from PM8550ve id J.
Also add the missing supplies to QMP PHYs.

Fixes: f9a9c11471da ("arm64: dts: qcom: x1e80100-qcp: Enable more support")
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: stable@vger.kernel.org      # 6.9
Link: https://lore.kernel.org/r/20240530-x1e80100-dts-fix-usb-phy-supplies-v1-2-6eb72a546227@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-qcp.dts |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-qcp.dts
@@ -537,7 +537,7 @@
 
 &usb_1_ss0_hsphy {
 	vdd-supply = <&vreg_l2e_0p8>;
-	vdda12-supply = <&vreg_l3e_1p2>;
+	vdda12-supply = <&vreg_l2j_1p2>;
 
 	phys = <&smb2360_0_eusb2_repeater>;
 
@@ -545,6 +545,9 @@
 };
 
 &usb_1_ss0_qmpphy {
+	vdda-phy-supply = <&vreg_l3e_1p2>;
+	vdda-pll-supply = <&vreg_l1j_0p8>;
+
 	status = "okay";
 };
 
@@ -559,7 +562,7 @@
 
 &usb_1_ss1_hsphy {
 	vdd-supply = <&vreg_l2e_0p8>;
-	vdda12-supply = <&vreg_l3e_1p2>;
+	vdda12-supply = <&vreg_l2j_1p2>;
 
 	phys = <&smb2360_1_eusb2_repeater>;
 
@@ -567,6 +570,9 @@
 };
 
 &usb_1_ss1_qmpphy {
+	vdda-phy-supply = <&vreg_l3e_1p2>;
+	vdda-pll-supply = <&vreg_l2d_0p9>;
+
 	status = "okay";
 };
 
@@ -581,7 +587,7 @@
 
 &usb_1_ss2_hsphy {
 	vdd-supply = <&vreg_l2e_0p8>;
-	vdda12-supply = <&vreg_l3e_1p2>;
+	vdda12-supply = <&vreg_l2j_1p2>;
 
 	phys = <&smb2360_2_eusb2_repeater>;
 
@@ -589,6 +595,9 @@
 };
 
 &usb_1_ss2_qmpphy {
+	vdda-phy-supply = <&vreg_l3e_1p2>;
+	vdda-pll-supply = <&vreg_l2d_0p9>;
+
 	status = "okay";
 };
 


