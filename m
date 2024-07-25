Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2F819AD91;
	Thu, 25 Jul 2024 14:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918772; cv=none; b=p2ON8HuNHYrDFMYgp+jUnn3+FWWUuhk20y6v4dU4sLxvS8ZsF+aR6JjtrkSobDXEjYXl6O660zNXbRezSjErF+LBIxlfe2vs+IPYUDvs6hpx5JIgmjWuV18M8DND9Wdrk7zKwuNsW90llbY5Hr2vq+WO2T7UDPXC/fOMiqtESLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918772; c=relaxed/simple;
	bh=qJ7R8VIRdHO5714UUOc6bv5ywZbZoqAIhDbv+IplXpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZrWOzDwNXIpcpK/z9tbjzL1r+Jcu1DMQxsL2JDV0tEcU/w3s98awvPIfM2KpGsBfpw0At0LXW4P6JJp2fWcTENe9wDakFznlCXsnXy8sSUYOBwyT/SMVFVz1dyLNwSuR2yitJquSMJi10LxQ50jUWsw0fQ7o+LKOPXPn9XDamg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z4F0qcYk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z4F0qcYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 782F5C116B1;
	Thu, 25 Jul 2024 14:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918771;
	bh=qJ7R8VIRdHO5714UUOc6bv5ywZbZoqAIhDbv+IplXpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z4F0qcYk6+qvZkXD128wj52OFEEkF30j/dqPXH0jQXupAWDcnlEZoNSiwCMDpy7Qr
	 RUMW1foSvUrOF6F1LmqOBBLZt8wTQ3DoP1V0dpfIiy39iZ+N0dWt6FlPQNCXgCnCIP
	 mBTPo6DWKbQRGvIAGZHXwwlln1jtSk7vX6fq9SQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.9 13/29] arm64: dts: qcom: x1e80100-qcp: Fix USB PHYs regulators
Date: Thu, 25 Jul 2024 16:37:23 +0200
Message-ID: <20240725142732.175402973@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142731.678993846@linuxfoundation.org>
References: <20240725142731.678993846@linuxfoundation.org>
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
@@ -520,12 +520,15 @@
 
 &usb_1_ss0_hsphy {
 	vdd-supply = <&vreg_l2e_0p8>;
-	vdda12-supply = <&vreg_l3e_1p2>;
+	vdda12-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
 
 &usb_1_ss0_qmpphy {
+	vdda-phy-supply = <&vreg_l3e_1p2>;
+	vdda-pll-supply = <&vreg_l1j_0p8>;
+
 	status = "okay";
 };
 
@@ -540,12 +543,15 @@
 
 &usb_1_ss1_hsphy {
 	vdd-supply = <&vreg_l2e_0p8>;
-	vdda12-supply = <&vreg_l3e_1p2>;
+	vdda12-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
 
 &usb_1_ss1_qmpphy {
+	vdda-phy-supply = <&vreg_l3e_1p2>;
+	vdda-pll-supply = <&vreg_l2d_0p9>;
+
 	status = "okay";
 };
 
@@ -560,12 +566,15 @@
 
 &usb_1_ss2_hsphy {
 	vdd-supply = <&vreg_l2e_0p8>;
-	vdda12-supply = <&vreg_l3e_1p2>;
+	vdda12-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";
 };
 
 &usb_1_ss2_qmpphy {
+	vdda-phy-supply = <&vreg_l3e_1p2>;
+	vdda-pll-supply = <&vreg_l2d_0p9>;
+
 	status = "okay";
 };
 


