Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF3A13AE9;
	Sat,  3 Feb 2024 04:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933771; cv=none; b=cwL6MUJSm6QXwgwACtY8HiOMX/b3CRHS28pHnMEfje242DmYliXuKlfe0/t0wEE+idhAvWsnlsiHx1Db4Cg2JUKEhAY/2qDQc7mriVGrZ8Gij43PhM9JBTMGEQxpRHhfu5ZFWCUkXU4AY6ohjsuvbHOzO/MY1xcY/i7tpgydV4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933771; c=relaxed/simple;
	bh=YdFSd9xBDlAo7W68MB6u11LVrjRjKQtmWMqWtxu0Qng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fiKiRRAGCmZQ0/N4FC7cU8UHSpYfwQIEOCgqW2yJ0NI6PF0oH6MAIzzeT3DXB49cRbeQd0UxuLUgdA4vfQi2ZLuuotXgymUxmU9I3s5ZIEGpLcC8L6jC/RPivWGz1FZPuR2bRK8tzq8RUWgcAvfp5OeKmICGrNx+xPie7YnJn3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EfcouRm0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EfcouRm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF43C43399;
	Sat,  3 Feb 2024 04:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933771;
	bh=YdFSd9xBDlAo7W68MB6u11LVrjRjKQtmWMqWtxu0Qng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EfcouRm0qnUEpXFsUwbkb2wo4RGCLw9v3JoyljjoVmq9tgD/wkAgDVQk2A2ZFpmpv
	 j6wTVavGUtD7BsISnaR67RjVYmHNga5JNAMp3+Kh2LG39TK+YKhmXW+pvK8jKwYn1w
	 KhRh7wFP9WXVBmOwTAK3CTrNLkFB3uHQ1IbWuGnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 073/353] ARM: dts: qcom: msm8660: fix PMIC node labels
Date: Fri,  2 Feb 2024 20:03:11 -0800
Message-ID: <20240203035406.137176767@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit c6d86aa8a12194d1c9c2f9108910a46c8a3ddc90 ]

Change PM8058 node labels to start with pm8058_ prefix, following other
Qualcomm PMIC device nodes.

Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20230928110309.1212221-11-dmitry.baryshkov@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/qcom/qcom-apq8060-dragonboard.dts   |  4 ++--
 arch/arm/boot/dts/qcom/qcom-msm8660.dtsi         | 16 ++++++++--------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm/boot/dts/qcom/qcom-apq8060-dragonboard.dts b/arch/arm/boot/dts/qcom/qcom-apq8060-dragonboard.dts
index 569cbf0d8df8..94351c9bf94b 100644
--- a/arch/arm/boot/dts/qcom/qcom-apq8060-dragonboard.dts
+++ b/arch/arm/boot/dts/qcom/qcom-apq8060-dragonboard.dts
@@ -71,7 +71,7 @@
 		/* Trig on both edges - getting close or far away */
 		interrupts-extended = <&pm8058_gpio 34 IRQ_TYPE_EDGE_BOTH>;
 		/* MPP05 analog input to the XOADC */
-		io-channels = <&xoadc 0x00 0x05>;
+		io-channels = <&pm8058_xoadc 0x00 0x05>;
 		io-channel-names = "aout";
 		pinctrl-names = "default";
 		pinctrl-0 = <&dragon_cm3605_gpios>, <&dragon_cm3605_mpps>;
@@ -944,7 +944,7 @@
 	};
 };
 
-&xoadc {
+&pm8058_xoadc {
 	/* Reference voltage 2.2 V */
 	xoadc-ref-supply = <&pm8058_l18>;
 
diff --git a/arch/arm/boot/dts/qcom/qcom-msm8660.dtsi b/arch/arm/boot/dts/qcom/qcom-msm8660.dtsi
index 78023ed2fdf7..9217ced108c4 100644
--- a/arch/arm/boot/dts/qcom/qcom-msm8660.dtsi
+++ b/arch/arm/boot/dts/qcom/qcom-msm8660.dtsi
@@ -80,13 +80,13 @@
 	 */
 	iio-hwmon {
 		compatible = "iio-hwmon";
-		io-channels = <&xoadc 0x00 0x01>, /* Battery */
-			    <&xoadc 0x00 0x02>, /* DC in (charger) */
-			    <&xoadc 0x00 0x04>, /* VPH the main system voltage */
-			    <&xoadc 0x00 0x0b>, /* Die temperature */
-			    <&xoadc 0x00 0x0c>, /* Reference voltage 1.25V */
-			    <&xoadc 0x00 0x0d>, /* Reference voltage 0.625V */
-			    <&xoadc 0x00 0x0e>; /* Reference voltage 0.325V */
+		io-channels = <&pm8058_xoadc 0x00 0x01>, /* Battery */
+			      <&pm8058_xoadc 0x00 0x02>, /* DC in (charger) */
+			      <&pm8058_xoadc 0x00 0x04>, /* VPH the main system voltage */
+			      <&pm8058_xoadc 0x00 0x0b>, /* Die temperature */
+			      <&pm8058_xoadc 0x00 0x0c>, /* Reference voltage 1.25V */
+			      <&pm8058_xoadc 0x00 0x0d>, /* Reference voltage 0.625V */
+			      <&pm8058_xoadc 0x00 0x0e>; /* Reference voltage 0.325V */
 	};
 
 	soc: soc {
@@ -390,7 +390,7 @@
 					row-hold = <91500>;
 				};
 
-				xoadc: xoadc@197 {
+				pm8058_xoadc: xoadc@197 {
 					compatible = "qcom,pm8058-adc";
 					reg = <0x197>;
 					interrupts-extended = <&pm8058 76 IRQ_TYPE_EDGE_RISING>;
-- 
2.43.0



