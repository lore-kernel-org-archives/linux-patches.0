Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8952162A12;
	Tue, 23 Jan 2024 01:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974980; cv=none; b=lB/jbDrEv0gpI1RX1scgiEy4/mRNFrQWkDQXJpLKDEIxRkuM925wG3ff4qXVbcihdu+2PEPOYx4pNZW8mlAjm5TNx4opdkIsyvbtl8jgZP+jpcWQIwXqgQ1Qul66Oid2cXHKyprjv6xyxFMw6E2II/BlUfbODOceksyRYJdXU2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974980; c=relaxed/simple;
	bh=5wG0n6rZd1gSyQ7QDK3wqawTa90yVWHd8B6Yes5Jb44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aN9tjSZ3XE+3lnIMwAfaORLPqNbnl38JTam0DIp37WqXYdqoFzSqqTRbUko2x+XMeJXn0QwYKk/wQ6C5txQXpmHx/HKW8bQhJWCtw6SBFwjvGSBB3apL4zfRLDSjmxO9DZqBQCZ9fyIqjmoUHXcVuhu/16zmD9MnCf/HBUu8HJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SVXOphKG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SVXOphKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056C8C433F1;
	Tue, 23 Jan 2024 01:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974980;
	bh=5wG0n6rZd1gSyQ7QDK3wqawTa90yVWHd8B6Yes5Jb44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SVXOphKGLEI1UaeFJGdB+ZkAYgTTRjXerh0WUmCaNcSScGe6j3a6vyUm8HDzymE7o
	 bI/XaOabZXWg7bErFf4yIN+EySGLOYkTRnwILZ7cZ07wdNhxMtN4Hc7DQ5syozLOgH
	 6+OBTu8++LBrafW/EJ8GrPOYEoUQnG0y48g3dm+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 178/583] arm64: dts: qcom: sm8150-hdk: fix SS USB regulators
Date: Mon, 22 Jan 2024 15:53:49 -0800
Message-ID: <20240122235817.462109490@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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
index bb161b536da4..f4c6e1309a7e 100644
--- a/arch/arm64/boot/dts/qcom/sm8150-hdk.dts
+++ b/arch/arm64/boot/dts/qcom/sm8150-hdk.dts
@@ -127,8 +127,6 @@ vdda_qrefs_0p875_5:
 		vdda_sp_sensor:
 		vdda_ufs_2ln_core_1:
 		vdda_ufs_2ln_core_2:
-		vdda_usb_ss_dp_core_1:
-		vdda_usb_ss_dp_core_2:
 		vdda_qlink_lv:
 		vdda_qlink_lv_ck:
 		vreg_l5a_0p875: ldo5 {
@@ -210,6 +208,12 @@ vreg_l17a_3p0: ldo17 {
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
 
 	regulators-1 {
@@ -445,13 +449,13 @@ &usb_2_hsphy {
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



