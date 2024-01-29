Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BA115AAA7;
	Mon, 29 Jan 2024 17:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548073; cv=none; b=L0LAtTTgmhs584uYluvadJ03HxCbsUr5mGO+5EQgztW7z4QSFBF6UQ5N5c/tKaUSzKh+9mfW1uPKrx5po6fpo0sH6qA28ig0Lt3T7UzkIht35KHR0Hd5TH3B79YxLOVuTJLoHOwvxLgyabSTkGRM+XE3upnLMZfp0973BsOnRBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548073; c=relaxed/simple;
	bh=63Y16PujCTVOJ/g02LK3fb/qiRNNaZNu2uDKkzTM+H4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bj6/4mjGSKpSo+5k0c1e0KINAVHt8Ei6OlXF6/NDcJdApBT3XxpAhrsxnCQW4pil10JsZ1N+u+nc3Y9ZAs+IOQDA3j435U1NmW5I19KCwVMwlg83Jr4fj7nI4eztTGw/LTEu3/9XjaSPwopkgykN9UfZF7Op1MPpF3HucJI8Aak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XVB5HZLI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XVB5HZLI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB7CC433F1;
	Mon, 29 Jan 2024 17:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548072;
	bh=63Y16PujCTVOJ/g02LK3fb/qiRNNaZNu2uDKkzTM+H4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XVB5HZLI+JD5vH8sdfZyqeTkYBfM4HwZMKgg8EVFHxQ4Tdgsf9P8LUPWGA/tHaL36
	 OsLej/I5RUxyAj9mZkIPzpLqamJM94ICdeGrrHN2pVwIuS5QpQIGifyXE+rSo+iXjx
	 IX5vq4MIj1AWymH/FzfZLS9s+3DkQkHMiGNQIZIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan@gerhold.net>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.7 081/346] arm64: dts: qcom: Add missing vio-supply for AW2013
Date: Mon, 29 Jan 2024 09:01:52 -0800
Message-ID: <20240129170018.776348314@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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
@@ -93,6 +93,7 @@
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


