Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6070E6FDE1;
	Mon, 29 Jan 2024 17:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548491; cv=none; b=j1SWcZfbk9A+FcWPk2oqI3J3bche57qPribSVtnnc7DwEnJ2T0xMeVEUwOXYSLXO4AILP8ydKJ/wu5s2RGrQpdy7rLsqgh8A5yjFkxq4Y3hDeYaYTGKKHVKueb49+dqJCw6tH6YhbUhDht/h6jHOZLb48tNBkyArp5mjYQaT8Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548491; c=relaxed/simple;
	bh=l1zBQwcntQbZ0MrzHlZ+IsmC7nDe0ZU1hNJ4b1KS8ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q7U/0ekfAQ4xJYFxhUY50S00wLxGP87csB3q2TfNXpNBEHH7/5k2xiFKsZQEkhTiq1iFPtY3Y6TYNIU0hw81JcuH7Ptj0g4LoTJTI5OIwLP0vz4uIKkKQyGX1Atl3ZtnpxdFC2axg+S+MsRmHR2WZJ9ICEbgjWqh39sStLPN55U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aqGx0K4r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aqGx0K4r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F6FC433C7;
	Mon, 29 Jan 2024 17:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548491;
	bh=l1zBQwcntQbZ0MrzHlZ+IsmC7nDe0ZU1hNJ4b1KS8ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aqGx0K4rKT5HQ3s6DV1LUleDQH11/tFA1NRtKveMvgNJg8IWdHPXt19zR3Nxmlu83
	 fbMM9rQoDX3P75OYavy8alq9FQmvo2BbJA9pExm7Nc5iw23xM3CUyeFeTcU+rkVASL
	 YOTDDm1/YLjviZZTUU42ohjpE/l4BdYbQGdHv+GQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan@gerhold.net>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 088/331] arm64: dts: qcom: Add missing vio-supply for AW2013
Date: Mon, 29 Jan 2024 09:02:32 -0800
Message-ID: <20240129170017.504561621@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Stephan Gerhold <stephan@gerhold.net>

commit cc1ec484f2d0f464ad11b56fe3de2589c23f73ec upstream.

Add the missing vio-supply to all usages of the AW2013 LED controller
to ensure that the regulator needed for pull-up of the interrupt and
I2C lines is really turned on. While this seems to have worked fine so
far some of these regulators are not guaranteed to be always-on. For
example, pm8916_l6 is typically turned off together with the display
if there aren't any other devices (e.g. sensors) keeping it always-on.

Cc: stable@vger.kernel.org # 6.6
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20231204-qcom-aw2013-vio-v1-1-5d264bb5c0b2@gerhold.net
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/msm8916-longcheer-l8150.dts  |    1 +
 arch/arm64/boot/dts/qcom/msm8916-wingtech-wt88047.dts |    1 +
 arch/arm64/boot/dts/qcom/msm8953-xiaomi-mido.dts      |    1 +
 arch/arm64/boot/dts/qcom/msm8953-xiaomi-tissot.dts    |    1 +
 arch/arm64/boot/dts/qcom/msm8953-xiaomi-vince.dts     |    1 +
 5 files changed, 5 insertions(+)

--- a/arch/arm64/boot/dts/qcom/msm8916-longcheer-l8150.dts
+++ b/arch/arm64/boot/dts/qcom/msm8916-longcheer-l8150.dts
@@ -88,6 +88,7 @@
 		#size-cells = <0>;
 
 		vcc-supply = <&pm8916_l17>;
+		vio-supply = <&pm8916_l6>;
 
 		led@0 {
 			reg = <0>;
--- a/arch/arm64/boot/dts/qcom/msm8916-wingtech-wt88047.dts
+++ b/arch/arm64/boot/dts/qcom/msm8916-wingtech-wt88047.dts
@@ -118,6 +118,7 @@
 		#size-cells = <0>;
 
 		vcc-supply = <&pm8916_l16>;
+		vio-supply = <&pm8916_l5>;
 
 		led@0 {
 			reg = <0>;
--- a/arch/arm64/boot/dts/qcom/msm8953-xiaomi-mido.dts
+++ b/arch/arm64/boot/dts/qcom/msm8953-xiaomi-mido.dts
@@ -111,6 +111,7 @@
 		reg = <0x45>;
 
 		vcc-supply = <&pm8953_l10>;
+		vio-supply = <&pm8953_l5>;
 
 		#address-cells = <1>;
 		#size-cells = <0>;
--- a/arch/arm64/boot/dts/qcom/msm8953-xiaomi-tissot.dts
+++ b/arch/arm64/boot/dts/qcom/msm8953-xiaomi-tissot.dts
@@ -104,6 +104,7 @@
 		reg = <0x45>;
 
 		vcc-supply = <&pm8953_l10>;
+		vio-supply = <&pm8953_l5>;
 
 		#address-cells = <1>;
 		#size-cells = <0>;
--- a/arch/arm64/boot/dts/qcom/msm8953-xiaomi-vince.dts
+++ b/arch/arm64/boot/dts/qcom/msm8953-xiaomi-vince.dts
@@ -113,6 +113,7 @@
 		reg = <0x45>;
 
 		vcc-supply = <&pm8953_l10>;
+		vio-supply = <&pm8953_l5>;
 
 		#address-cells = <1>;
 		#size-cells = <0>;


