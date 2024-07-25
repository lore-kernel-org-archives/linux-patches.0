Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CE0F519;
	Thu, 25 Jul 2024 14:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918787; cv=none; b=ce9PBch2etykUnmbVdZ58AOstnFkhzEnspD0JqnRzD0n2Ul90TWzmAyX4RaJuOT8Mbpy/6KXW1AhkMUtdC1o1mbuCG1bxA8+ZbzEbKKc4p9txrLLrli0C/fDqF0Kkw11X7B4sp6jMres7Yr20vKDeH/+Qd4doozhXD/RchZlcfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918787; c=relaxed/simple;
	bh=BLlxdd9+AUhmvO6pinhnzJRGrIe6EBW7NxLPdANK8TI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHAyr7yKypnYEWJwv1uJ4d7JQQposz/8h2WRy45/ICF41jdWyQSqhDAYrTkbUNQ0YKwk0QISDx/RBa4lMGRuMJOyzv1QawFkYs20lZQZgyU0AIOqh4i6h3X908G9r/iJTeuD3LRkNL+IydGumg6Yc1GpbzWDoXyjRu0TZABSDyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s5omDbzu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s5omDbzu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D269C116B1;
	Thu, 25 Jul 2024 14:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918787;
	bh=BLlxdd9+AUhmvO6pinhnzJRGrIe6EBW7NxLPdANK8TI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s5omDbzu0qeQZAbozRXWIP/FG9M5gGfFRIB3W4OcKf8DAais59mpq8GH5LV5NQw2k
	 OuQ1fZkEmvLqEm5NnHFCCxono6hGGkz1iW3yvehM1mtKJbo4UrEG7J/ijRMjABJPz2
	 ZFJiFFQDtdGEa2nQR3+5q5wEuUPayj93K/RE53H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.9 18/29] arm64: dts: qcom: x1e80100-crd: Fix USB PHYs regulators
Date: Thu, 25 Jul 2024 16:37:28 +0200
Message-ID: <20240725142732.364238662@linuxfoundation.org>
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

commit ae5cee8e7349d7e5deff4cf90a08cbd738287155 upstream.

The 1.2v HS PHY shared regulator is actually LDO2 from PM8550ve id J.
Also add the missing supplies to QMP PHYs.

Fixes: d7e03cce0400 ("arm64: dts: qcom: x1e80100-crd: Enable more support")
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: stable@vger.kernel.org      # 6.9
Link: https://lore.kernel.org/r/20240530-x1e80100-dts-fix-usb-phy-supplies-v1-1-6eb72a546227@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-crd.dts |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100-crd.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-crd.dts
@@ -824,12 +824,15 @@
 
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
 
@@ -844,12 +847,15 @@
 
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
 
@@ -864,12 +870,15 @@
 
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
 


