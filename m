Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313C0381B0F;
	Sat, 12 Sep 2026 08:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201883; cv=none; b=dDse9IZmykXbLKZlu75ASQU6gOmgkwkomt/BtKMeKw1LCpVH4O6fvRhA3hwgjPCKXTQPTSXxN+Y7dDLN9A6ph6SZLweZzt5U+WTSuHfoIpMfbSIL62Jshnrzm9pgYYnOIhXgSQl8mH6clre5FQ5UaLy+sn7hvncXbP9QWlo8Ml4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201883; c=relaxed/simple;
	bh=VTsVCuUBRwrclf0Gy0clJOZOz/xw3q5GBVdby03ldb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dmrwb1JFwFBas+g0RMWH53q8f4Z5dnTru+5kfiEnoV8y0qKCM82a5O8yWiAhTjrbia6Vfbvx/geFtgMAH0mD93U0kCxuQQlZywT8UEhIWDwopldODZ2BQZERHY5HWCH/O7KagwgM5m6MyTIMOuJeTOXjxUf+QMUIAqewtJuSQOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HK8wt4aA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HK8wt4aA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1BD1F000FF;
	Sat, 12 Sep 2026 08:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201882;
	bh=+2CIQ5VpA4nhsiA655ZsLNSS6x5t6BkkKURJz1a/RCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HK8wt4aAjANmxCB0xBywp3f6l0K5dD8Y2H+LWfsCTf7VOFWH524snBiXqnTFg4lM+
	 IHDGsJoXVUFyhlsG5CHF3My8sr45KB+gn3Gjf1AE0xuqauDrCXxmhD42JHVx9wlccH
	 9iGvR3igQttOfPNnlNbX3IJ3N1aDGYLJS1/OMGeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1087/1815] arm64: dts: qcom: lemans: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies
Date: Sat, 12 Sep 2026 08:47:17 +0200
Message-ID: <20260912065714.539077816@linuxfoundation.org>
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

[ Upstream commit 932113c3c77814b4001ad37ea4383b93bc385284 ]

The QMP PHY expects the vdda-phy supply to be the lower voltage (~0.8V)
and the vdda-pll supply to be the higher voltage (~1.2V), as used by the
PCIe and UFS QMP PHYs on this SoC. But these two supplies are swapped for
the USB QMP PHYs on these boards, feeding 1.14V to vdda-phy and 0.72V to
vdda-pll.

Fix it by swapping the two supplies back.

Fixes: 76326da895b8 ("arm64: dts: qcom: lemans: Refactor ride/ride-r3 boards based on daughter cards")
Fixes: 7bd68ef80661 ("arm64: dts: qcom: lemans-evk: Enable first USB controller in device mode")
Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Assisted-by: Claude:opus-4-8
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260803-phy-supply-fix-v1-25-5880630cde3e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/lemans-evk.dts          | 4 ++--
 arch/arm64/boot/dts/qcom/lemans-ride-common.dtsi | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/lemans-evk.dts b/arch/arm64/boot/dts/qcom/lemans-evk.dts
index 34dfc8d22b6a5..b835fce8b336f 100644
--- a/arch/arm64/boot/dts/qcom/lemans-evk.dts
+++ b/arch/arm64/boot/dts/qcom/lemans-evk.dts
@@ -1008,8 +1008,8 @@ &usb_0_hsphy {
 };
 
 &usb_0_qmpphy {
-	vdda-phy-supply = <&vreg_l1c>;
-	vdda-pll-supply = <&vreg_l7a>;
+	vdda-phy-supply = <&vreg_l7a>;
+	vdda-pll-supply = <&vreg_l1c>;
 
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/lemans-ride-common.dtsi b/arch/arm64/boot/dts/qcom/lemans-ride-common.dtsi
index 40f88498999bd..b2195fc030957 100644
--- a/arch/arm64/boot/dts/qcom/lemans-ride-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/lemans-ride-common.dtsi
@@ -1103,8 +1103,8 @@ &usb_0_hsphy {
 };
 
 &usb_0_qmpphy {
-	vdda-phy-supply = <&vreg_l1c>;
-	vdda-pll-supply = <&vreg_l7a>;
+	vdda-phy-supply = <&vreg_l7a>;
+	vdda-pll-supply = <&vreg_l1c>;
 
 	status = "okay";
 };
@@ -1126,8 +1126,8 @@ &usb_1_hsphy {
 };
 
 &usb_1_qmpphy {
-	vdda-phy-supply = <&vreg_l1c>;
-	vdda-pll-supply = <&vreg_l7a>;
+	vdda-phy-supply = <&vreg_l7a>;
+	vdda-pll-supply = <&vreg_l1c>;
 
 	status = "okay";
 };
-- 
2.53.0



