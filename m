Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3962E738F;
	Sat, 12 Sep 2026 08:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201798; cv=none; b=FgFdpMvA4J8bTmW5sWvQchUWP6dygabH6Z1nscJPx7hySAFUsF0NLUjrSfmSM8gphiCSI6Nqrco3dGnVzHyC4xOyXLiUT1jZrhwEnlUKj3K1ppASA0QB3dif5qN9IQyzsiVaqtH6+Fh9FzBTn8HwasLxCCaq7Oz8HhYbcOUQeI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201798; c=relaxed/simple;
	bh=Pz1DVeUCJZzvbssWfmC/tpNDhKIwXJcYE1/Wwbwr98k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P/xRLpPwHvBIBhQZSeb3e2myhZcqL1b4hVDL+VevRmGngeZLX8xj8Ut9GdQdFqDXJG6lbslxBBQ7+Rv/7y736CLeU9EDIzwuuAHsCEOhwoVRX8nqjQY0hqEmqAD+DT9lZz3oJ2HN39AoRrPAnba90arjQlsPudtRB/DMwNCYR9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aotW5koM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aotW5koM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C2C1F000FF;
	Sat, 12 Sep 2026 08:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201797;
	bh=u/Q0km4uF2y2RlQc6mcLRxv525Sxl4cuhXSV9XssbEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aotW5koMSNiFWjSpkmqxzjyHT5Gka5Ba9O88NDR2WiyzeEXmztDxnv5Pn+uFRZ1A4
	 mrnXKgCjxp8dnHkpMAUtikj+VlJ6acwsXB57LFOR8Xy9rxxZvbIKP+SSdMnDwXZ6ed
	 N81sZqfcnO1ImaMqH2v4rHG5eyHgUKKb5nlBSwZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1070/1815] arm64: dts: qcom: sm8350: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies
Date: Sat, 12 Sep 2026 08:47:00 +0200
Message-ID: <20260912065714.143566303@linuxfoundation.org>
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

[ Upstream commit 65cd57115c379ff0d0a200ad5a857afb8042a63c ]

The QMP PHY expects the vdda-phy supply to be around 0.88V and the
vdda-pll supply to be 1.2V. But these two supplies are swapped for the
USB QMP PHYs on these boards, feeding 1.2V to vdda-phy and 0.88V to
vdda-pll.

Fix it by swapping the two supplies back.

Fixes: 9208c19f2124 ("arm64: dts: qcom: Introduce SM8350 HDK")
Fixes: c16160cfa565 ("arm64: dts: qcom: add minimal DTS for Microsoft Surface Duo 2")
Fixes: 054b40a6111f ("arm64: dts: qcom: sm8350-mtp: enable USB nodes")
Fixes: 5a077120bcf6 ("arm64: dts: qcom: sm8350-sagami: Wire up USB regulators and fix USB3")
Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Assisted-by: Claude:opus-4-8
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260803-phy-supply-fix-v1-8-5880630cde3e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350-hdk.dts                   | 8 ++++----
 .../arm64/boot/dts/qcom/sm8350-microsoft-surface-duo2.dts | 8 ++++----
 arch/arm64/boot/dts/qcom/sm8350-mtp.dts                   | 8 ++++----
 arch/arm64/boot/dts/qcom/sm8350-sony-xperia-sagami.dtsi   | 4 ++--
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350-hdk.dts b/arch/arm64/boot/dts/qcom/sm8350-hdk.dts
index 5f975d0094658..b43dbb5921b18 100644
--- a/arch/arm64/boot/dts/qcom/sm8350-hdk.dts
+++ b/arch/arm64/boot/dts/qcom/sm8350-hdk.dts
@@ -860,8 +860,8 @@ &usb_1_hsphy {
 &usb_1_qmpphy {
 	status = "okay";
 
-	vdda-phy-supply = <&vreg_l6b_1p2>;
-	vdda-pll-supply = <&vreg_l1b_0p88>;
+	vdda-phy-supply = <&vreg_l1b_0p88>;
+	vdda-pll-supply = <&vreg_l6b_1p2>;
 };
 
 &usb_1_qmpphy_out {
@@ -890,8 +890,8 @@ &usb_2_hsphy {
 &usb_2_qmpphy {
 	status = "okay";
 
-	vdda-phy-supply = <&vreg_l6b_1p2>;
-	vdda-pll-supply = <&vreg_l5b_0p88>;
+	vdda-phy-supply = <&vreg_l5b_0p88>;
+	vdda-pll-supply = <&vreg_l6b_1p2>;
 };
 
 /* PINCTRL - additions to nodes defined in sm8350.dtsi */
diff --git a/arch/arm64/boot/dts/qcom/sm8350-microsoft-surface-duo2.dts b/arch/arm64/boot/dts/qcom/sm8350-microsoft-surface-duo2.dts
index 3bd5e57cbcdaa..57bb8c322e8b0 100644
--- a/arch/arm64/boot/dts/qcom/sm8350-microsoft-surface-duo2.dts
+++ b/arch/arm64/boot/dts/qcom/sm8350-microsoft-surface-duo2.dts
@@ -358,8 +358,8 @@ &usb_1_hsphy {
 &usb_1_qmpphy {
 	status = "okay";
 
-	vdda-phy-supply = <&vreg_l6b_1p2>;
-	vdda-pll-supply = <&vreg_l1b_0p88>;
+	vdda-phy-supply = <&vreg_l1b_0p88>;
+	vdda-pll-supply = <&vreg_l6b_1p2>;
 };
 
 &usb_2 {
@@ -377,6 +377,6 @@ &usb_2_hsphy {
 &usb_2_qmpphy {
 	status = "okay";
 
-	vdda-phy-supply = <&vreg_l6b_1p2>;
-	vdda-pll-supply = <&vreg_l5b_0p88>;
+	vdda-phy-supply = <&vreg_l5b_0p88>;
+	vdda-pll-supply = <&vreg_l6b_1p2>;
 };
diff --git a/arch/arm64/boot/dts/qcom/sm8350-mtp.dts b/arch/arm64/boot/dts/qcom/sm8350-mtp.dts
index 8bee57f3b25a1..859985e561aa5 100644
--- a/arch/arm64/boot/dts/qcom/sm8350-mtp.dts
+++ b/arch/arm64/boot/dts/qcom/sm8350-mtp.dts
@@ -354,8 +354,8 @@ &usb_1_hsphy {
 &usb_1_qmpphy {
 	status = "okay";
 
-	vdda-phy-supply = <&vreg_l6b_1p2>;
-	vdda-pll-supply = <&vreg_l1b_0p88>;
+	vdda-phy-supply = <&vreg_l1b_0p88>;
+	vdda-pll-supply = <&vreg_l6b_1p2>;
 };
 
 &usb_2 {
@@ -373,8 +373,8 @@ &usb_2_hsphy {
 &usb_2_qmpphy {
 	status = "okay";
 
-	vdda-phy-supply = <&vreg_l6b_1p2>;
-	vdda-pll-supply = <&vreg_l5b_0p88>;
+	vdda-phy-supply = <&vreg_l5b_0p88>;
+	vdda-pll-supply = <&vreg_l6b_1p2>;
 };
 
 &ipa {
diff --git a/arch/arm64/boot/dts/qcom/sm8350-sony-xperia-sagami.dtsi b/arch/arm64/boot/dts/qcom/sm8350-sony-xperia-sagami.dtsi
index 7ae1eb0a7ccea..1f9d094fee8fc 100644
--- a/arch/arm64/boot/dts/qcom/sm8350-sony-xperia-sagami.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350-sony-xperia-sagami.dtsi
@@ -917,6 +917,6 @@ &usb_1_hsphy {
 &usb_1_qmpphy {
 	status = "okay";
 
-	vdda-phy-supply = <&pm8350_l6>;
-	vdda-pll-supply = <&pm8350_l1>;
+	vdda-phy-supply = <&pm8350_l1>;
+	vdda-pll-supply = <&pm8350_l6>;
 };
-- 
2.53.0



