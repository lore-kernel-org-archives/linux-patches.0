Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFF5368D5A;
	Sat, 12 Sep 2026 08:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201774; cv=none; b=KnRGXduCziNRJpQ9/BtLIaLxBCp8cCMiaYK3J7WwZlAsdkzIBeBK4w+W1pWXfv4VSU3vYhA0dkylcoqFguX2SOJM/aAUsko0jGbmUjYl/2yhiL9IxFjDpzjMdRnlKg8R02DPhGY2onMeodG38w2PS7aqF6hCUNlnAQ7Yv+TTu6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201774; c=relaxed/simple;
	bh=mNWS0b66MUEWDiRaiWp1z/YBK05F9GV+KT6UEdLMhbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jAzJt/7Y9EPkvata/wH/QxHATuGZ5gH2RTwsyTt8GMTrCToycwcIZAcAsB9XIM0QeZt7lnVYeNG3/pkygYzL9eyQyKtVjAGxp+Pq0iEGcFr0tNQMgEqsOshvnyUm7U5TPrTVSVgqkHXCLAoJENjECphTqviHJKBZlelop5xBmx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WXPUTXJC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WXPUTXJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1261F000FF;
	Sat, 12 Sep 2026 08:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201772;
	bh=XtqWVMC3YRVIDjPjnvrOFtzppJ2MR75CtcXITez3Xx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WXPUTXJCU4cxGWjvW/u4mfUjvt8kGsIZCqvH8PcCpT2EIzb31GfGN41b7d0Z3YhbU
	 6EJMbDGs6GcLF9tA6nDtbSHibX16Oe32MUNT5ZNvJANgyUMj+VnuaoFkPMu+nKrlC5
	 7tjtPskcCJTVzECbHC/linPZj0U5AX5DLHYn/WnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1066/1815] arm64: dts: qcom: sdm845: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies
Date: Sat, 12 Sep 2026 08:46:56 +0200
Message-ID: <20260912065714.047486751@linuxfoundation.org>
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

[ Upstream commit ce18e4c1cfc77c2eda5f0b9839edac1b0e929c54 ]

The QMP PHY expects the vdda-phy supply to be around 0.88V and the
vdda-pll supply to be 1.2V. But these two supplies are swapped for the
USB QMP PHYs on these boards, feeding 1.2V to vdda-phy and 0.88V to
vdda-pll.

Fix it by swapping the two supplies back.

Fixes: 3f72e2d3e682 ("arm64: dts: qcom: Add Dragonboard 845c")
Fixes: a678adbf2d22 ("arm64: dts: qcom: Add support for Pixel 3 and Pixel 3 XL")
Fixes: 28ae8aa3923c ("arm64: dts: qcom: add device tree for LG G7 and LG V35")
Fixes: cfe10d38aa1a ("arm64: dts: qcom: sdm845-mtp: Add nodes for USB")
Fixes: d711b22eee55 ("arm64: dts: qcom: starqltechn: add initial device tree for starqltechn")
Fixes: 45882459159d ("arm64: dts: qcom: sdm845: add device tree for SHIFT6mq")
Fixes: dd6459a0890a ("arm64: dts: qcom: split beryllium dts into common dtsi and tianma dts")
Fixes: be497abe19bf ("arm64: dts: qcom: Add support for Xiaomi Mi Mix2s")
Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Assisted-by: Claude:opus-4-8
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260803-phy-supply-fix-v1-4-5880630cde3e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts                | 8 ++++----
 arch/arm64/boot/dts/qcom/sdm845-google-common.dtsi        | 4 ++--
 arch/arm64/boot/dts/qcom/sdm845-lg-common.dtsi            | 4 ++--
 arch/arm64/boot/dts/qcom/sdm845-mtp.dts                   | 8 ++++----
 arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts   | 4 ++--
 arch/arm64/boot/dts/qcom/sdm845-shift-axolotl.dts         | 4 ++--
 .../boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi     | 4 ++--
 arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts        | 4 ++--
 8 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
index 02416812b6a7f..846138149b2cd 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
@@ -1121,8 +1121,8 @@ &usb_1_hsphy {
 &usb_1_qmpphy {
 	status = "okay";
 
-	vdda-phy-supply = <&vreg_l26a_1p2>;
-	vdda-pll-supply = <&vreg_l1a_0p875>;
+	vdda-phy-supply = <&vreg_l1a_0p875>;
+	vdda-pll-supply = <&vreg_l26a_1p2>;
 };
 
 &usb_2 {
@@ -1147,8 +1147,8 @@ &usb_2_hsphy {
 &usb_2_qmpphy {
 	status = "okay";
 
-	vdda-phy-supply = <&vreg_l26a_1p2>;
-	vdda-pll-supply = <&vreg_l1a_0p875>;
+	vdda-phy-supply = <&vreg_l1a_0p875>;
+	vdda-pll-supply = <&vreg_l26a_1p2>;
 };
 
 &ufs_mem_hc {
diff --git a/arch/arm64/boot/dts/qcom/sdm845-google-common.dtsi b/arch/arm64/boot/dts/qcom/sdm845-google-common.dtsi
index b2dc0327dff85..ebeebbde64053 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-google-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-google-common.dtsi
@@ -571,8 +571,8 @@ &usb_1_hsphy {
 };
 
 &usb_1_qmpphy {
-	vdda-phy-supply = <&vreg_l26a_1p2>;
-	vdda-pll-supply = <&vreg_l1a_0p875>;
+	vdda-phy-supply = <&vreg_l1a_0p875>;
+	vdda-pll-supply = <&vreg_l26a_1p2>;
 
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/sdm845-lg-common.dtsi b/arch/arm64/boot/dts/qcom/sdm845-lg-common.dtsi
index e0c3566761bf8..c14b4b3d9a3c9 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-lg-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-lg-common.dtsi
@@ -677,8 +677,8 @@ &usb_1_hsphy {
 };
 
 &usb_1_qmpphy {
-	vdda-phy-supply = <&vdda_usb1_ss_1p2>;
-	vdda-pll-supply = <&vdda_usb1_ss_core>;
+	vdda-phy-supply = <&vdda_usb1_ss_core>;
+	vdda-pll-supply = <&vdda_usb1_ss_1p2>;
 
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/sdm845-mtp.dts b/arch/arm64/boot/dts/qcom/sdm845-mtp.dts
index 091568642faa7..00ea30afc9f6d 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-mtp.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-mtp.dts
@@ -729,8 +729,8 @@ &usb_1_hsphy {
 &usb_1_qmpphy {
 	status = "okay";
 
-	vdda-phy-supply = <&vdda_usb1_ss_1p2>;
-	vdda-pll-supply = <&vdda_usb1_ss_core>;
+	vdda-phy-supply = <&vdda_usb1_ss_core>;
+	vdda-pll-supply = <&vdda_usb1_ss_1p2>;
 };
 
 &usb_2 {
@@ -761,8 +761,8 @@ &usb_2_hsphy {
 &usb_2_qmpphy {
 	status = "okay";
 
-	vdda-phy-supply = <&vdda_usb2_ss_1p2>;
-	vdda-pll-supply = <&vdda_usb2_ss_core>;
+	vdda-phy-supply = <&vdda_usb2_ss_core>;
+	vdda-pll-supply = <&vdda_usb2_ss_1p2>;
 };
 
 &venus {
diff --git a/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts b/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
index 0d915ecb0444f..cd735417adddc 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
@@ -949,8 +949,8 @@ &usb_1_hsphy {
 };
 
 &usb_1_qmpphy {
-	vdda-phy-supply = <&vdda_usb1_ss_1p2>;
-	vdda-pll-supply = <&vdda_usb1_ss_core>;
+	vdda-phy-supply = <&vdda_usb1_ss_core>;
+	vdda-pll-supply = <&vdda_usb1_ss_1p2>;
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/qcom/sdm845-shift-axolotl.dts b/arch/arm64/boot/dts/qcom/sdm845-shift-axolotl.dts
index f21b914f22b51..ca503af9b832b 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-shift-axolotl.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-shift-axolotl.dts
@@ -876,8 +876,8 @@ &usb_1_hsphy {
 &usb_1_qmpphy {
 	status = "okay";
 
-	vdda-phy-supply = <&vreg_l26a_1p2>;
-	vdda-pll-supply = <&vreg_l1a_0p875>;
+	vdda-phy-supply = <&vreg_l1a_0p875>;
+	vdda-pll-supply = <&vreg_l26a_1p2>;
 };
 
 &venus {
diff --git a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi
index 54e58ca046934..710b296e49643 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi
@@ -645,8 +645,8 @@ &usb_1_hsphy {
 &usb_1_qmpphy {
 	status = "okay";
 
-	vdda-phy-supply = <&vreg_l26a_1p2>;
-	vdda-pll-supply = <&vreg_l1a_0p875>;
+	vdda-phy-supply = <&vreg_l1a_0p875>;
+	vdda-pll-supply = <&vreg_l26a_1p2>;
 };
 
 &venus {
diff --git a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
index a44d6e776c82e..cce7348e583ac 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
@@ -668,8 +668,8 @@ &usb_1_hsphy {
 };
 
 &usb_1_qmpphy {
-	vdda-pll-supply = <&vreg_l1a_0p875>;
-	vdda-phy-supply = <&vreg_l26a_1p2>;
+	vdda-pll-supply = <&vreg_l26a_1p2>;
+	vdda-phy-supply = <&vreg_l1a_0p875>;
 	status = "okay";
 };
 
-- 
2.53.0



