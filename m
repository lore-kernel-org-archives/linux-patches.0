Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF21368D5A;
	Sat, 12 Sep 2026 08:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201794; cv=none; b=aph6SFAAV+Tswobz9+TiaYJohuPzkZZaHrCjuoZV/Ink5b7RJSKjGJgZFiiE4HVkXRwt299GIyWCZ1/3/+wbJH64CTggdEpI95LLMmXNdFA8KnJZ99MtZHYZ5GqGJGlQP61uN2wZM1tavO68uiUsRdmOm4YGo/63j9V/p7uFIFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201794; c=relaxed/simple;
	bh=EEEua5Lkv5X+ylE2Cd1exv1ErIBUMifvS1+WW9G1aug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OtR3cMnDkjMKyV2LgJbE5k0armW9YMbqZEyK4T9d1bvjQljHtlenYHVg5TI0dCKz+Olej6Lr9W3cL6HZyh3PX877NW9lLESFXwsjK0voCqa3V+ohdYvheCy09LYKy6aaiWPJHmbEM91yCBaRoV3cENM51bGkkRIvgHpm6Hxitas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qvc40R3E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qvc40R3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38451F000FF;
	Sat, 12 Sep 2026 08:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201792;
	bh=CUW8H659oo/xlEg11ZhWkqI2ig2kRgsNlj+cHovHYrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qvc40R3EXBrEeV3og9j9+sqBN4h/VSQNsUo7nPwVJZ431lnaLnhvQM3Kd3MgWl/Yw
	 VwXZ9DeCqGKuww2LS7seqZ9z6OgcXW3Lx2k2611R2jcbOhTtIZwAS2gAy2CK37i4Qz
	 Zzcj+ol4VtHopgjIH/JAG5vUaTtt/Uv/pcvHORHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1069/1815] arm64: dts: qcom: sm8250: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies
Date: Sat, 12 Sep 2026 08:46:59 +0200
Message-ID: <20260912065714.118876936@linuxfoundation.org>
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

[ Upstream commit d57a10f2ebcf327bdecf8bb26e9f330b17b0b1a6 ]

The QMP PHY expects the vdda-phy supply to be around 0.88V and the
vdda-pll supply to be 1.2V. But these two supplies are swapped for the
USB QMP PHYs on these boards, feeding 1.2V to vdda-phy and 0.9V to
vdda-pll.

Fix it by swapping the two supplies back.

Fixes: 91ed0e90fc49 ("arm64: dts: qcom: add sm8250 hdk dts")
Fixes: 221f0ef37f55 ("arm64: dts: sm8250-mtp: enable USB host nodes")
Fixes: 69cdb97ef652 ("arm64: dts: qcom: sm8250: Add support for SONY Xperia 1 II / 5 II (Edo platform)")
Fixes: 264beb3cbd0d ("arm64: dts: qcom: sm8250-xiaomi-pipa: Add initial device tree")
Fixes: 52c90664f122 ("arm64: dts: qcom: qrb5165-rb5: Add USB support")
Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Assisted-by: Claude:opus-4-8
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260803-phy-supply-fix-v1-7-5880630cde3e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qrb5165-rb5.dts             | 8 ++++----
 arch/arm64/boot/dts/qcom/sm8250-hdk.dts              | 8 ++++----
 arch/arm64/boot/dts/qcom/sm8250-mtp.dts              | 8 ++++----
 arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi | 4 ++--
 arch/arm64/boot/dts/qcom/sm8250-xiaomi-pipa.dts      | 4 ++--
 5 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts b/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
index 690b484352edf..d6af679abe1a3 100644
--- a/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
+++ b/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
@@ -1424,8 +1424,8 @@ &usb_1_hsphy {
 &usb_1_qmpphy {
 	status = "okay";
 
-	vdda-phy-supply = <&vreg_l9a_1p2>;
-	vdda-pll-supply = <&vreg_l18a_0p92>;
+	vdda-phy-supply = <&vreg_l18a_0p92>;
+	vdda-pll-supply = <&vreg_l9a_1p2>;
 };
 
 &usb_1_qmpphy_out {
@@ -1451,8 +1451,8 @@ &usb_2_hsphy {
 &usb_2_qmpphy {
 	status = "okay";
 
-	vdda-phy-supply = <&vreg_l9a_1p2>;
-	vdda-pll-supply = <&vreg_l18a_0p92>;
+	vdda-phy-supply = <&vreg_l18a_0p92>;
+	vdda-pll-supply = <&vreg_l9a_1p2>;
 };
 
 &vamacro {
diff --git a/arch/arm64/boot/dts/qcom/sm8250-hdk.dts b/arch/arm64/boot/dts/qcom/sm8250-hdk.dts
index 3ea9d2b1a7d58..c1c673086df51 100644
--- a/arch/arm64/boot/dts/qcom/sm8250-hdk.dts
+++ b/arch/arm64/boot/dts/qcom/sm8250-hdk.dts
@@ -438,14 +438,14 @@ &usb_2_hsphy {
 
 &usb_1_qmpphy {
 	status = "okay";
-	vdda-phy-supply = <&vreg_l9a_1p2>;
-	vdda-pll-supply = <&vreg_l18a_0p92>;
+	vdda-phy-supply = <&vreg_l18a_0p92>;
+	vdda-pll-supply = <&vreg_l9a_1p2>;
 };
 
 &usb_2_qmpphy {
 	status = "okay";
-	vdda-phy-supply = <&vreg_l9a_1p2>;
-	vdda-pll-supply = <&vreg_l18a_0p92>;
+	vdda-phy-supply = <&vreg_l18a_0p92>;
+	vdda-pll-supply = <&vreg_l9a_1p2>;
 };
 
 &usb_1 {
diff --git a/arch/arm64/boot/dts/qcom/sm8250-mtp.dts b/arch/arm64/boot/dts/qcom/sm8250-mtp.dts
index 51779b99176d0..14c8ca602110f 100644
--- a/arch/arm64/boot/dts/qcom/sm8250-mtp.dts
+++ b/arch/arm64/boot/dts/qcom/sm8250-mtp.dts
@@ -862,8 +862,8 @@ &usb_1_hsphy {
 &usb_1_qmpphy {
 	status = "okay";
 
-	vdda-phy-supply = <&vreg_l9a_1p2>;
-	vdda-pll-supply = <&vreg_l18a_0p9>;
+	vdda-phy-supply = <&vreg_l18a_0p9>;
+	vdda-pll-supply = <&vreg_l9a_1p2>;
 };
 
 &usb_2 {
@@ -885,8 +885,8 @@ &usb_2_hsphy {
 &usb_2_qmpphy {
 	status = "okay";
 
-	vdda-phy-supply = <&vreg_l9a_1p2>;
-	vdda-pll-supply = <&vreg_l18a_0p9>;
+	vdda-phy-supply = <&vreg_l18a_0p9>;
+	vdda-pll-supply = <&vreg_l9a_1p2>;
 };
 
 &venus {
diff --git a/arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi b/arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi
index d8289b2698f37..51c0caaf4ea12 100644
--- a/arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi
@@ -715,8 +715,8 @@ &usb_1_hsphy {
 &usb_1_qmpphy {
 	status = "okay";
 
-	vdda-phy-supply = <&vreg_l9a_1p2>;
-	vdda-pll-supply = <&vreg_l18a_0p9>;
+	vdda-phy-supply = <&vreg_l18a_0p9>;
+	vdda-pll-supply = <&vreg_l9a_1p2>;
 };
 
 &venus {
diff --git a/arch/arm64/boot/dts/qcom/sm8250-xiaomi-pipa.dts b/arch/arm64/boot/dts/qcom/sm8250-xiaomi-pipa.dts
index 078ba13f8762e..f11e4e244dffd 100644
--- a/arch/arm64/boot/dts/qcom/sm8250-xiaomi-pipa.dts
+++ b/arch/arm64/boot/dts/qcom/sm8250-xiaomi-pipa.dts
@@ -515,8 +515,8 @@ &usb_1_hsphy {
 
 &usb_1_qmpphy {
 	status = "okay";
-	vdda-phy-supply = <&vreg_l9a_1p2>;
-	vdda-pll-supply = <&vreg_l18a_0p9>;
+	vdda-phy-supply = <&vreg_l18a_0p9>;
+	vdda-pll-supply = <&vreg_l9a_1p2>;
 };
 
 &ufs_mem_hc {
-- 
2.53.0



