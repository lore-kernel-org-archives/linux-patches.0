Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C755731A575;
	Wed, 20 May 2026 16:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295677; cv=none; b=VuuCPFxpfhDmsvh5cKSZSP9Hp6s7KSUapunkxAEIEBzvSaH229LKJKMYi9q4zQFdjqM8nHsHr6G7NVkoRHxM/AG8Az47es943fasXqSMN+wzNaM9IqD+1DLeCxq3KSBhEwHxf7vAsyPnBAXDQxS5BhsKXEA8UWyUo0ujPbz6H4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295677; c=relaxed/simple;
	bh=mV7ayiho8Y7/OB4wLdJffBU/z075lrOSkuEZwEjFvew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gxXDvetShbQhL+dqZsvQ1b/jGTptTCoN4Mf8ac6RrWTlJdnwmNq5DRa288TnB9A1pixn/7XQsUhqpb/Mtkv35gLmmnYi8eElA5iPDPg9+xWnweeeEyjO3LHHbaBe6XUobBZG9Pm+G5c8UGwXDrqw672s2Siu3U42c2ke0J1qov8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tgJV1vMv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tgJV1vMv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389A71F000E9;
	Wed, 20 May 2026 16:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295676;
	bh=32cXe74AaLJvxm8sBzk/+C6V+Ylh9ztq2Y4kIcYzFH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tgJV1vMvTFESljMT89ugCcjc9wrpum6xGangX7+RG330BTiNDlYvavH6pNz8sdknZ
	 xJePKPFxk8SlCm6aRw8UmEP28PK1jvbrPLJvXFAqf4lm5X9d7NPy5clPdWfychJ9BA
	 WkN24zpzq+W2yAbHzgsZUNE8es6wN6mr/oXxfVXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Riccardo Mereu <r.mereu@arduino.cc>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0509/1146] arm64: dts: qcom: arduino-imola: fix faulty spidev node
Date: Wed, 20 May 2026 18:12:39 +0200
Message-ID: <20260520162159.705382783@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Riccardo Mereu <r.mereu@arduino.cc>

[ Upstream commit 1a040df09fab28b31399fce14a76455b536a2b08 ]

CS pin added on pinctrl0 property is causing spidev to return -ENODEV
since that GPIO is already part of spi5 pinmuxing.

Fixes: 3f745bc0f11f ("arm64: dts: qcom: qrb2210: add dts for Arduino unoq")
Signed-off-by: Riccardo Mereu <r.mereu@arduino.cc>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260213101002.105238-1-r.mereu.kernel@arduino.cc
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qrb2210-arduino-imola.dts | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/qrb2210-arduino-imola.dts b/arch/arm64/boot/dts/qcom/qrb2210-arduino-imola.dts
index 197ab6eb1666f..5ab605cc56c80 100644
--- a/arch/arm64/boot/dts/qcom/qrb2210-arduino-imola.dts
+++ b/arch/arm64/boot/dts/qcom/qrb2210-arduino-imola.dts
@@ -325,21 +325,13 @@ &sdhc_1 {
 &spi5 {
 	status = "okay";
 
-	spidev@0 {
-		reg = <0>;
+	mcu@0 {
 		compatible = "arduino,unoq-mcu";
-		pinctrl-0 = <&spidev_cs>;
-		pinctrl-names = "default";
+		reg = <0>;
 	};
 };
 
 &tlmm {
-	spidev_cs: spidev-cs-state {
-		pins = "gpio17";
-		function = "gpio";
-		drive-strength = <16>;
-	};
-
 	jmisc_gpio18: jmisc-gpio18-state {
 		pins = "gpio18";
 		function = "gpio";
-- 
2.53.0



