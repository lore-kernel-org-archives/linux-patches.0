Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F0B381B0F;
	Sat, 12 Sep 2026 08:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201839; cv=none; b=BYbm55MXWN5SaEhdEE34OipBFflKX9BiXgHF1CpxwHymViHi1dmLNZmKo2WYpfwHOTUwXIkUcSJWJRRfllBLZbNMywvfUNVWvgz9LCBlrCCzgXgH1utnnPbEirBjx7MVofuPyhm8ecJglCxnxM+E1GzHxVigJFUjIKuac1sCtY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201839; c=relaxed/simple;
	bh=E+DoNj4CsruVwhCTVqhQCX5S21dXcHZub2RATarpUE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qgju32tr3MfTto3KY3L+0RLmHwN6WNo3mWGG+V0Np9jSPOqmiqWYbyN8omVzeivhGwjP9H04ciMOyYPxjOjVlQxeIfrWJecbBuKPQS2A6aHpIcgBnRbACo4GZvXJAS1gzK32q1mH6PFVPsrTtbBcAgLDXAHkQIkO3SbMRruEyZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oFNqItOK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oFNqItOK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248201F000FF;
	Sat, 12 Sep 2026 08:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201838;
	bh=H05426kLGYpyubgrM1f2O3ToXCGYS2oBnerT4IFX0MA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oFNqItOKgv/OwB+/FEv7d5KC8iOo5UFoooY35qkcdNVeZUlNvzRAHy8FJBDK2V6tQ
	 9SUBpL0/nHUwZxslbQLfyXiFuotYjAM8R1eKkvnuFh98T19+/rpz8Q41HoYXSUiInu
	 RMribhsjpiRNObypykxnpResl7OnaR+U1B5P6nwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1078/1815] arm64: dts: qcom: sc7280: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies
Date: Sat, 12 Sep 2026 08:47:08 +0200
Message-ID: <20260912065714.327733985@linuxfoundation.org>
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

[ Upstream commit b3038aac412d14538f135e6509e657997fd6825d ]

The QMP PHY expects the vdda-phy supply to be around 0.88V and the
vdda-pll supply to be 1.2V. But these two supplies are swapped for the
USB QMP PHYs on these boards, feeding 1.2V to vdda-phy and 0.9V to
vdda-pll.

Fix it by swapping the two supplies back.

Fixes: 97a5b73b7058 ("arm64: dts: qcom: sc7280-idp: Add device tree files for IDP2")
Fixes: 116f7cc43d28 ("arm64: dts: qcom: sc7280: Add herobrine-r1")
Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Assisted-by: Claude:opus-4-8
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260803-phy-supply-fix-v1-16-5880630cde3e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280-idp.dtsi   | 4 ++--
 arch/arm64/boot/dts/qcom/sc7280-qcard.dtsi | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280-idp.dtsi b/arch/arm64/boot/dts/qcom/sc7280-idp.dtsi
index 8cac4ce9c8515..23ced0621c99e 100644
--- a/arch/arm64/boot/dts/qcom/sc7280-idp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280-idp.dtsi
@@ -542,8 +542,8 @@ &usb_1_hsphy {
 &usb_1_qmpphy {
 	status = "okay";
 
-	vdda-phy-supply = <&vreg_l6b_1p2>;
-	vdda-pll-supply = <&vreg_l1b_0p8>;
+	vdda-phy-supply = <&vreg_l1b_0p8>;
+	vdda-pll-supply = <&vreg_l6b_1p2>;
 };
 
 &uart7 {
diff --git a/arch/arm64/boot/dts/qcom/sc7280-qcard.dtsi b/arch/arm64/boot/dts/qcom/sc7280-qcard.dtsi
index 9ae9af40f4d21..264029ff3f903 100644
--- a/arch/arm64/boot/dts/qcom/sc7280-qcard.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280-qcard.dtsi
@@ -465,8 +465,8 @@ &usb_1_hsphy {
 };
 
 &usb_1_qmpphy {
-	vdda-phy-supply = <&vdd_a_usbssdp_0_1p2>;
-	vdda-pll-supply = <&vdd_a_usbssdp_0_core>;
+	vdda-phy-supply = <&vdd_a_usbssdp_0_core>;
+	vdda-pll-supply = <&vdd_a_usbssdp_0_1p2>;
 };
 
 &usb_2_hsphy {
-- 
2.53.0



