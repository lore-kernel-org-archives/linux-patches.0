Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A339D2EBDE9;
	Sat, 12 Sep 2026 07:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197668; cv=none; b=V7Z5kfaBIfz4WI1zGZUR+lDpdFABnKu2rrDUBgFulwwtA3zwPPfQfQvfeJs6KvZmn2hGHxNk4wSigmifbPBgKCsy4Sog9sVs9f3pFsuCalIrWRib2ArTsu7TNZN87kfWOJ5379JTc4IDXGFPxBCy1nZCxmxaEzlDOG+fwY4ht9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197668; c=relaxed/simple;
	bh=2ytG2zelHUMWBCJ3lzZ2FHk7bqtNhJ3wMjkNXxTcu5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dj8JAoFCplqF/JijemDJu/4O0Lrsf5qrQ/tY1KwV/jF45Rmi03yFYQ3gI52feT44P6GhwScPw5tpZnbvn9b5Rb1hxG8sx9vR29A/QfLlt0VsKNJZ0vZmNkSOZdsulARVMrotXZws9iYvnUPDcssld510UoSVKoDkVXuenpXaqqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZRnFvDt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZRnFvDt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B3B1F000FF;
	Sat, 12 Sep 2026 07:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197667;
	bh=YjlChZHfxQ4XnK9jXuVR6G+9lhL6RcLt98HGWZTw/G4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vZRnFvDtLvBu2TUY0d2pK6x2kf4k5tXfcukX8H3TxzxDcefmZusc8IDI/RA2xvJNA
	 EMbh3MWEPKHGeLwVPH8lmw07AalmwRQmQht7a+LsC1NaD9a7zjOnJ4NMG2Wsreq9EE
	 zUOAsI5MpO0bKE1xTKEyXAUYvaRpJuhdZ8saPZq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sibi Sankar <sibi.sankar@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Anvesh Jain P <anvesh.p@oss.qualcomm.com>,
	Anthony Ruhier <aruhier@mailbox.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0220/1815] arm64: dts: qcom: glymur-crd: Add Embedded controller node
Date: Sat, 12 Sep 2026 08:32:50 +0200
Message-ID: <20260912065654.158050428@linuxfoundation.org>
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

From: Sibi Sankar <sibi.sankar@oss.qualcomm.com>

[ Upstream commit 44c655a08c9ee9590e64f8306a66917bbb629970 ]

Add embedded controller node for Glymur CRDs which adds fan control,
temperature sensors, access to EC state changes through SCI events
and suspend entry/exit notifications to the EC.

Signed-off-by: Sibi Sankar <sibi.sankar@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Co-developed-by: Anvesh Jain P <anvesh.p@oss.qualcomm.com>
Signed-off-by: Anvesh Jain P <anvesh.p@oss.qualcomm.com>
Tested-by: Anthony Ruhier <aruhier@mailbox.org>
Link: https://lore.kernel.org/r/20260511-add-driver-for-ec-v9-3-e5437c39b7f8@oss.qualcomm.com
[bjorn: Added i2c alias for &i2c9]
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: f64ef325f1d9 ("arm64: dts: glymur-crd: Add reset GPIO to touchscreen node")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/glymur-crd.dtsi | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/glymur-crd.dtsi b/arch/arm64/boot/dts/qcom/glymur-crd.dtsi
index e784b538f42e1..f7478b59624e6 100644
--- a/arch/arm64/boot/dts/qcom/glymur-crd.dtsi
+++ b/arch/arm64/boot/dts/qcom/glymur-crd.dtsi
@@ -22,6 +22,7 @@ aliases {
 		i2c0 = &i2c0;
 		i2c1 = &i2c4;
 		i2c2 = &i2c5;
+		i2c3 = &i2c9;
 		spi0 = &spi18;
 	};
 
@@ -444,6 +445,22 @@ vreg_l4h_e0_1p2: ldo4 {
 	};
 };
 
+&i2c9 {
+	clock-frequency = <400000>;
+
+	status = "okay";
+
+	embedded-controller@76 {
+		compatible = "qcom,glymur-crd-ec", "qcom,hamoa-crd-ec";
+		reg = <0x76>;
+
+		interrupts-extended = <&tlmm 66 IRQ_TYPE_EDGE_FALLING>;
+
+		pinctrl-0 = <&ec_int_n_default>;
+		pinctrl-names = "default";
+	};
+};
+
 &pcie3b {
 	vddpe-3v3-supply = <&vreg_nvmesec>;
 
@@ -596,6 +613,12 @@ hall_int_n_default: hall-int-n-state {
 		bias-disable;
 	};
 
+	ec_int_n_default: ec-int-n-state {
+		pins = "gpio66";
+		function = "gpio";
+		bias-disable;
+	};
+
 	pcie4_default: pcie4-default-state {
 		clkreq-n-pins {
 			pins = "gpio147";
-- 
2.53.0



