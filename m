Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110223290D1;
	Sat, 12 Sep 2026 16:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232265; cv=none; b=MfZDtIxv+2M3vuLiijGeoUSmDmFqF989eDu8AtEbpv+uuPveIJBXki1NaTjn4WNndIAPyCAx/JAW+5wAGZm0OCfD+LSUaFvvmKs9FpFfBdcWjymB/ETZTHdgb4ruWZDVS/Y10JyT5HYZssIbc5f3yylXV12QEE6UkD7ZFbWRK98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232265; c=relaxed/simple;
	bh=n28TBVXvU9q7OZSVyVbEIhyqLfIaE8hVgtqjTglrFu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iey8CCB0gG7h0lGDpyGUE1gnashOLeLSP4eHzf53nEIAYhqHVu5/9g+AxXRPSa3iYbYPeqmCmgz+syFXeBoP5ztjc9JuGxkSFHMHv93FzVU0uEOSbkIi4Dm65cXMZF6jG7MLxi95IU9rpds62or5/8xS2Trzhoo64HnB3kTKWrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EtLNAD6e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EtLNAD6e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F2B1F000FF;
	Sat, 12 Sep 2026 16:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232264;
	bh=MHDycc9V60Rn71i1m8Su5KEL3FVKmLDxcgzZ+80R98w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EtLNAD6eY4oeVHj6YDLcCAbrGnf2+a8WrTT9YRCBqGG+xLC5L5McDPnmJevJ0Bf49
	 xl1U3lM1p4Lc8zDuyXbpW9kiBhpudjoq0+PJgNByf1kL8Yctn7DxYoYhccdm/t50Ty
	 RqBGw3BNNaB7Gyf9uJFmDw9Y1bzILicbNERdyaOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dzmitry Sankouski <dsankouski@gmail.com>,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1150/1191] arm64: dts: qcom: Re-enable resin on MSM8998 and SDM845 boards
Date: Sat, 12 Sep 2026 09:04:38 +0200
Message-ID: <20260912065613.976854506@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dzmitry Sankouski <dsankouski@gmail.com>

[ Upstream commit 4c881ab73a64cdbf8691e258ef17b740d27040a0 ]

resin node declaration was moved to pm8998.dtsi file (in disabled state).
MSM8998 and SDM845 boards defining resin node did not previously have
status="okay" and ended up disabled.
Re-enable it by using resin node link from pm8998.dtsi with status="okay".

Fixes: f86ae6f23a9e ("arm64: dts: qcom: sagit: add initial device tree for sagit")
Signed-off-by: Dzmitry Sankouski <dsankouski@gmail.com>
Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Reported-by: Marijn Suijten <marijn.suijten@somainline.org>
Link: https://lore.kernel.org/linux-arm-msm/20221222115922.jlachctn4lxopp7a@SoMainline.org/
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221228115243.201038-1-dsankouski@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8998-fxtec-pro1.dts       | 11 +++--------
 .../boot/dts/qcom/msm8998-sony-xperia-yoshino.dtsi    | 11 +++--------
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts            | 11 +++--------
 arch/arm64/boot/dts/qcom/sdm845-lg-common.dtsi        | 11 +++--------
 arch/arm64/boot/dts/qcom/sdm845-shift-axolotl.dts     | 11 +++--------
 arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts  | 11 +++--------
 arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts    | 11 +++--------
 7 files changed, 21 insertions(+), 56 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8998-fxtec-pro1.dts b/arch/arm64/boot/dts/qcom/msm8998-fxtec-pro1.dts
index 429ba57e20f71..6addb183552d5 100644
--- a/arch/arm64/boot/dts/qcom/msm8998-fxtec-pro1.dts
+++ b/arch/arm64/boot/dts/qcom/msm8998-fxtec-pro1.dts
@@ -368,14 +368,9 @@ cam_snapshot_pin_a: cam-snapshot-btn-active-state {
 	};
 };
 
-&pm8998_pon {
-	resin {
-		compatible = "qcom,pm8941-resin";
-		interrupts = <GIC_SPI 0x8 1 IRQ_TYPE_EDGE_BOTH>;
-		bias-pull-up;
-		debounce = <15625>;
-		linux,code = <KEY_VOLUMEDOWN>;
-	};
+&pm8998_resin {
+	linux,code = <KEY_VOLUMEDOWN>;
+	status = "okay";
 };
 
 &qusb2phy {
diff --git a/arch/arm64/boot/dts/qcom/msm8998-sony-xperia-yoshino.dtsi b/arch/arm64/boot/dts/qcom/msm8998-sony-xperia-yoshino.dtsi
index 87f116565fd8e..31afc19715aae 100644
--- a/arch/arm64/boot/dts/qcom/msm8998-sony-xperia-yoshino.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998-sony-xperia-yoshino.dtsi
@@ -353,14 +353,9 @@ vib_default: vib-en-state {
 	};
 };
 
-&pm8998_pon {
-	resin {
-		compatible = "qcom,pm8941-resin";
-		interrupts = <GIC_SPI 0x8 1 IRQ_TYPE_EDGE_BOTH>;
-		debounce = <15625>;
-		bias-pull-up;
-		linux,code = <KEY_VOLUMEUP>;
-	};
+&pm8998_resin {
+	linux,code = <KEY_VOLUMEUP>;
+	status = "okay";
 };
 
 &qusb2phy {
diff --git a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
index 5a5ecae073010..b683223c5fdd0 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
@@ -624,14 +624,9 @@ vol_up_pin_a: vol-up-active-state {
 	};
 };
 
-&pm8998_pon {
-	resin {
-		compatible = "qcom,pm8941-resin";
-		interrupts = <0x0 0x8 1 IRQ_TYPE_EDGE_BOTH>;
-		debounce = <15625>;
-		bias-pull-up;
-		linux,code = <KEY_VOLUMEDOWN>;
-	};
+&pm8998_resin {
+	linux,code = <KEY_VOLUMEDOWN>;
+	status = "okay";
 };
 
 &pmi8998_lpg {
diff --git a/arch/arm64/boot/dts/qcom/sdm845-lg-common.dtsi b/arch/arm64/boot/dts/qcom/sdm845-lg-common.dtsi
index e2921640880a1..84a6438cedfd4 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-lg-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-lg-common.dtsi
@@ -482,14 +482,9 @@ &mss_pil {
 	status = "okay";
 };
 
-&pm8998_pon {
-	resin {
-		compatible = "qcom,pm8941-resin";
-		interrupts = <0x0 0x8 1 IRQ_TYPE_EDGE_BOTH>;
-		debounce = <15625>;
-		bias-pull-up;
-		linux,code = <KEY_VOLUMEDOWN>;
-	};
+&pm8998_resin {
+	linux,code = <KEY_VOLUMEDOWN>;
+	status = "okay";
 };
 
 &sdhc_2 {
diff --git a/arch/arm64/boot/dts/qcom/sdm845-shift-axolotl.dts b/arch/arm64/boot/dts/qcom/sdm845-shift-axolotl.dts
index b65c35865dab9..21ee67eb0e598 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-shift-axolotl.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-shift-axolotl.dts
@@ -521,14 +521,9 @@ pinconf {
 	};
 };
 
-&pm8998_pon {
-	volume_down_resin: resin {
-		compatible = "qcom,pm8941-resin";
-		interrupts = <0x0 0x8 1 IRQ_TYPE_EDGE_BOTH>;
-		debounce = <15625>;
-		bias-pull-up;
-		linux,code = <KEY_VOLUMEDOWN>;
-	};
+&pm8998_resin {
+	linux,code = <KEY_VOLUMEDOWN>;
+	status = "okay";
 };
 
 &pmi8998_lpg {
diff --git a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts
index 9c0f7b410eee2..261364dc3faaf 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts
@@ -327,14 +327,9 @@ &pmi8998_wled {
 	qcom,cabc;
 };
 
-&pm8998_pon {
-	resin {
-		compatible = "qcom,pm8941-resin";
-		interrupts = <0x0 0x8 1 IRQ_TYPE_EDGE_BOTH>;
-		debounce = <15625>;
-		bias-pull-up;
-		linux,code = <KEY_VOLUMEDOWN>;
-	};
+&pm8998_resin {
+	linux,code = <KEY_VOLUMEDOWN>;
+	status = "okay";
 };
 
 /* QUAT I2S Uses 1 I2S SD Line for audio on TAS2559/60 amplifiers */
diff --git a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
index ffbe45a99b74a..3eeda63989279 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-polaris.dts
@@ -534,14 +534,9 @@ pinconf {
 	};
 };
 
-&pm8998_pon {
-	resin {
-		interrupts = <0x0 0x8 1 IRQ_TYPE_EDGE_BOTH>;
-		compatible = "qcom,pm8941-resin";
-		linux,code = <KEY_VOLUMEDOWN>;
-		debounce = <15625>;
-		bias-pull-up;
-	};
+&pm8998_resin {
+	linux,code = <KEY_VOLUMEDOWN>;
+	status = "okay";
 };
 
 &q6afedai {
-- 
2.53.0



