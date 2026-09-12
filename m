Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE232D0C92;
	Sat, 12 Sep 2026 08:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201779; cv=none; b=NqZZrnFBhLO0BZ2QGflZ6Z5g4kM+gE3UpWpJsyBS8h11XdrhHgx3XPW61CPcydn2+CT8Ixt3CPaTSuYQ44aV/9wA5QhQYq69xNsiKU9FIOoqfNvpeel4vKZvNXO77UpbvGGk02lucqUEyl7CbWR1naU3ZawhSmcN6JUqXDjofFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201779; c=relaxed/simple;
	bh=JM+b58PX3kXiJwbCa9U7gYDiHThjtV2XuNwtNb3sPCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PrYtPj1bmwG3YloxvranlsoV3HFM/vZ7aaN47DWy1j182XO2UDgr/zrPNlIE0hfGk9euMaYKv+WKpEGE/aGCeHttimH+xDB25v2QCwaVl7BhClo9Qn7aCOfFyNDARmDYg5/t8PlzGVYVmLOGi5Idn5bQ1zxAywOjq9UMMavDBLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TjLBKXkR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TjLBKXkR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55DC1F000FF;
	Sat, 12 Sep 2026 08:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201778;
	bh=+n/mQwUIFfFqHxcbmw/UqiV6514XvUH0sy4TFl7ZbxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TjLBKXkRBS3UyvuVikSirdGnt/5jul4tDN/zZM36Ia/ap9U09QivBjAvz2xwY8QfH
	 LKbqz50j5xcIuy+paJg9hqXxlAdGWc0OhXP7ysbhuICvG0I0cO1KVDqbXkCt26lg+z
	 7f4fJ85ijbCz6FbMP2iIWTa/GZvc1HD6WKQxbIVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1067/1815] arm64: dts: qcom: sdm850: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies
Date: Sat, 12 Sep 2026 08:46:57 +0200
Message-ID: <20260912065714.072370020@linuxfoundation.org>
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

[ Upstream commit ef7b567f54c72a91dec3fb0bd5d80b8e956f7cd8 ]

The QMP PHY expects the vdda-phy supply to be around 0.88V and the
vdda-pll supply to be 1.2V. But these two supplies are swapped for the
USB QMP PHYs on these boards, feeding 1.2V to vdda-phy and 0.88V to
vdda-pll.

Fix it by swapping the two supplies back.

Fixes: aab69794b55d ("arm64: dts: qcom: Add support for Huawei MateBook E 2019")
Fixes: 44acee207844 ("arm64: dts: qcom: Add Lenovo Yoga C630")
Fixes: d4b341269efb ("arm64: dts: qcom: Add support for Samsung Galaxy Book2")
Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Assisted-by: Claude:opus-4-8
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260803-phy-supply-fix-v1-5-5880630cde3e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arm64/boot/dts/qcom/sdm850-huawei-matebook-e-2019.dts | 8 ++++----
 arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts      | 8 ++++----
 arch/arm64/boot/dts/qcom/sdm850-samsung-w737.dts          | 8 ++++----
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm850-huawei-matebook-e-2019.dts b/arch/arm64/boot/dts/qcom/sdm850-huawei-matebook-e-2019.dts
index f048653818702..a4339b562b604 100644
--- a/arch/arm64/boot/dts/qcom/sdm850-huawei-matebook-e-2019.dts
+++ b/arch/arm64/boot/dts/qcom/sdm850-huawei-matebook-e-2019.dts
@@ -872,8 +872,8 @@ &usb_1_hsphy {
 };
 
 &usb_1_qmpphy {
-	vdda-phy-supply = <&vdda_usb1_ss_1p2>;
-	vdda-pll-supply = <&vdda_usb1_ss_core>;
+	vdda-phy-supply = <&vdda_usb1_ss_core>;
+	vdda-pll-supply = <&vdda_usb1_ss_1p2>;
 
 	status = "okay";
 };
@@ -898,8 +898,8 @@ &usb_2_hsphy {
 };
 
 &usb_2_qmpphy {
-	vdda-phy-supply = <&vdda_usb2_ss_1p2>;
-	vdda-pll-supply = <&vdda_usb2_ss_core>;
+	vdda-phy-supply = <&vdda_usb2_ss_core>;
+	vdda-pll-supply = <&vdda_usb2_ss_1p2>;
 
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
index 8cdaef5360d11..3c353d27d7e89 100644
--- a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
+++ b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
@@ -864,8 +864,8 @@ &usb_1_hsphy {
 &usb_1_qmpphy {
 	status = "okay";
 
-	vdda-phy-supply = <&vdda_usb1_ss_1p2>;
-	vdda-pll-supply = <&vdda_usb1_ss_core>;
+	vdda-phy-supply = <&vdda_usb1_ss_core>;
+	vdda-pll-supply = <&vdda_usb1_ss_1p2>;
 };
 
 &usb_1_qmpphy_out {
@@ -957,8 +957,8 @@ &usb_2_hsphy {
 &usb_2_qmpphy {
 	status = "okay";
 
-	vdda-phy-supply = <&vdda_usb2_ss_1p2>;
-	vdda-pll-supply = <&vdda_usb2_ss_core>;
+	vdda-phy-supply = <&vdda_usb2_ss_core>;
+	vdda-pll-supply = <&vdda_usb2_ss_1p2>;
 };
 
 &venus {
diff --git a/arch/arm64/boot/dts/qcom/sdm850-samsung-w737.dts b/arch/arm64/boot/dts/qcom/sdm850-samsung-w737.dts
index a676d3ea01b99..b7a1e2317fc2f 100644
--- a/arch/arm64/boot/dts/qcom/sdm850-samsung-w737.dts
+++ b/arch/arm64/boot/dts/qcom/sdm850-samsung-w737.dts
@@ -609,8 +609,8 @@ &usb_1_hsphy {
 &usb_1_qmpphy {
 	status = "okay";
 
-	vdda-phy-supply = <&vdda_usb1_ss_1p2>;
-	vdda-pll-supply = <&vdda_usb1_ss_core>;
+	vdda-phy-supply = <&vdda_usb1_ss_core>;
+	vdda-pll-supply = <&vdda_usb1_ss_1p2>;
 };
 
 &usb_2 {
@@ -635,8 +635,8 @@ &usb_2_hsphy {
 &usb_2_qmpphy {
 	status = "okay";
 
-	vdda-phy-supply = <&vdda_usb2_ss_1p2>;
-	vdda-pll-supply = <&vdda_usb2_ss_core>;
+	vdda-phy-supply = <&vdda_usb2_ss_core>;
+	vdda-pll-supply = <&vdda_usb2_ss_1p2>;
 };
 
 &venus {
-- 
2.53.0



