Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168B260252;
	Tue, 23 Jan 2024 00:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970853; cv=none; b=npqVYeRJN/SmYhhNBrsmJ6CBsnGpiXpMUXBZRoZaouVEJ0l0FWXO3155W8P7BNwxxMWg7qijqcpfU0qr6aBIi+FhjBSXb9r1KxwRM2DMgJrwxqzdELD7CMw4zFORDmYFDnQUHxYeY5nw5S2zz87o2Oo08aZV3M1FPiBxQzJ2B2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970853; c=relaxed/simple;
	bh=ZY+lknEH/rkQPnGcWWWBLaRlII1cicnzkLOvpx01CRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MfIyWPEM4bhQpt36Ahgf7M95iwIzUCFLegKx0lJ0uw9jI9pLT27NO3H967k7G/XnjeE3PF1t4+XFCPogCC7dGcmBfo10CCRoF8I+reqsmDws9yvACv6wiVaY8EyH0fU5rFYDPQ5q49cNntAygRj0nWKCpVKuwPIiDexnihdaM9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BLbJI8Za; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BLbJI8Za"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B56C43390;
	Tue, 23 Jan 2024 00:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970852;
	bh=ZY+lknEH/rkQPnGcWWWBLaRlII1cicnzkLOvpx01CRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BLbJI8ZaVNhKj8vvc87veBQRPmHcxtp5ZvezFKigDwu/tijyjylpFEKQ7C4bKZ/pK
	 kSf77RKSrVIdkHH8VM9g/JTQFmBR2bvstl3DMqGWwIknrz+tTCrLkyrjrIgNYTITDU
	 ODk+O93Bht2FhgDcDoWgS1OS6s4lrogdedeAux0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 125/417] arm64: dts: qcom: sm8150-hdk: fix SS USB regulators
Date: Mon, 22 Jan 2024 15:54:53 -0800
Message-ID: <20240122235756.136418157@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit a509adf05b2aac31b22781f5aa09e4768a5b6c39 ]

The SM8150-HDK uses two different regulators to power up SuperSpeed USB
PHYs. The L5A regulator is used for the second USB host, while the first
(OTG) USB host uses different regulator, L18A. Fix the regulator for the
usb_1 QMPPHY and (to remove possible confusion) drop the
usb_ss_dp_core_1/_2 labels.

Fixes: 0ab1b2d10afe ("arm64: dts: qcom: add sm8150 hdk dts")
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20231215174152.315403-4-dmitry.baryshkov@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8150-hdk.dts | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8150-hdk.dts b/arch/arm64/boot/dts/qcom/sm8150-hdk.dts
index 3331ee957d64..368da4c7f41b 100644
--- a/arch/arm64/boot/dts/qcom/sm8150-hdk.dts
+++ b/arch/arm64/boot/dts/qcom/sm8150-hdk.dts
@@ -126,8 +126,6 @@ vdda_qrefs_0p875_5:
 		vdda_sp_sensor:
 		vdda_ufs_2ln_core_1:
 		vdda_ufs_2ln_core_2:
-		vdda_usb_ss_dp_core_1:
-		vdda_usb_ss_dp_core_2:
 		vdda_qlink_lv:
 		vdda_qlink_lv_ck:
 		vreg_l5a_0p875: ldo5 {
@@ -209,6 +207,12 @@ vreg_l17a_3p0: ldo17 {
 			regulator-max-microvolt = <3008000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 		};
+
+		vreg_l18a_0p8: ldo18 {
+			regulator-min-microvolt = <880000>;
+			regulator-max-microvolt = <880000>;
+			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+		};
 	};
 
 	pm8150l-rpmh-regulators {
@@ -439,13 +443,13 @@ &usb_2_hsphy {
 &usb_1_qmpphy {
 	status = "okay";
 	vdda-phy-supply = <&vreg_l3c_1p2>;
-	vdda-pll-supply = <&vdda_usb_ss_dp_core_1>;
+	vdda-pll-supply = <&vreg_l18a_0p8>;
 };
 
 &usb_2_qmpphy {
 	status = "okay";
 	vdda-phy-supply = <&vreg_l3c_1p2>;
-	vdda-pll-supply = <&vdda_usb_ss_dp_core_1>;
+	vdda-pll-supply = <&vreg_l5a_0p875>;
 };
 
 &usb_1 {
-- 
2.43.0



