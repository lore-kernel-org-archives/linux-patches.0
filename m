Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199AF183CA0;
	Tue, 30 Jul 2024 16:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355354; cv=none; b=XP6NBYzkJevXhOh6TxD00+91QXuEJl/PjKUA/ByEDpbkpWDRppZ7lrDykMZ9HBo/uFHMY3Ohbfo2uFbHC/OYwPKGTIHZbbbwDlKLt/YJFZfvNaA6SzF6s6OKSYE7/8xMFiAVT2Ugn88mF6e6G+dA+TOByUk0pfo3Cot3TrwinL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355354; c=relaxed/simple;
	bh=fmFKTtRRieYv5TJm1WDbHCZCHQvmsaoiVHo92bxXIuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RcQNWOnIreyMrGANEGpAlzOJrWhXVijse022bDIxOvECmsm5EL7aR38AYWtJRoOdU3Q2NmCadIqmMUoYirTdNIchmXWUUPeZ2jHFyq3P7lLN80pYIJWBcQictNPk2kIc0XmuTlzmYgMk2Vk5DTcGieZoUpH2aGrfg2vKU29nzNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PaxUJudF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PaxUJudF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78075C32782;
	Tue, 30 Jul 2024 16:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355354;
	bh=fmFKTtRRieYv5TJm1WDbHCZCHQvmsaoiVHo92bxXIuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PaxUJudFvFpPNg0mzRFf99Kh06tONEWzT+KFkyfkrUFvKf77KseU4kDtJgg/BmDbI
	 z+7S7IYM51vPY9TMHRn7c5j798ONKkwsQ1ZIUExOJXb6IlrWq3HpF3lGWED5Qr6964
	 kGg/YWs+GopPLvqScHl5QJBDCsdtDtEUk3eV1/Cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viken Dadhaniya <quic_vdadhani@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 043/809] arm64: dts: qcom: sc7280: Remove CTS/RTS configuration
Date: Tue, 30 Jul 2024 17:38:39 +0200
Message-ID: <20240730151726.353815935@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viken Dadhaniya <quic_vdadhani@quicinc.com>

[ Upstream commit 2b96407b8f10f1d71b58cb35704eb91b8ea78db1 ]

For IDP variant, GPIO 20/21 is used by camera use case and camera
driver is not able acquire these GPIOs as it is acquired by UART5
driver as RTS/CTS pin.

UART5 is designed for debug UART for all the board variants of the
sc7280 chipset and RTS/CTS configuration is not required for debug
uart usecase.

Remove CTS/RTS configuration for UART5 instance and change compatible
string to debug UART.

Remove overwriting compatible property from individual target specific
file as it is not required.

Fixes: 38cd93f413fd ("arm64: dts: qcom: sc7280: Update QUPv3 UART5 DT node")
Signed-off-by: Viken Dadhaniya <quic_vdadhani@quicinc.com>
Link: https://lore.kernel.org/r/20240424075853.11445-1-quic_vdadhani@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcm6490-fairphone-fp5.dts |  1 -
 arch/arm64/boot/dts/qcom/qcm6490-idp.dts           |  1 -
 arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts       |  1 -
 arch/arm64/boot/dts/qcom/sc7280-idp.dtsi           |  1 -
 arch/arm64/boot/dts/qcom/sc7280-qcard.dtsi         |  1 -
 arch/arm64/boot/dts/qcom/sc7280.dtsi               | 14 ++------------
 6 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/qcm6490-fairphone-fp5.dts b/arch/arm64/boot/dts/qcom/qcm6490-fairphone-fp5.dts
index f3432701945f7..8cd2fe80dbb2c 100644
--- a/arch/arm64/boot/dts/qcom/qcm6490-fairphone-fp5.dts
+++ b/arch/arm64/boot/dts/qcom/qcm6490-fairphone-fp5.dts
@@ -864,7 +864,6 @@ sw_ctrl_default: sw-ctrl-default-state {
 };
 
 &uart5 {
-	compatible = "qcom,geni-debug-uart";
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/qcom/qcm6490-idp.dts b/arch/arm64/boot/dts/qcom/qcm6490-idp.dts
index 47ca2d0003414..107302680f562 100644
--- a/arch/arm64/boot/dts/qcom/qcm6490-idp.dts
+++ b/arch/arm64/boot/dts/qcom/qcm6490-idp.dts
@@ -658,7 +658,6 @@ &tlmm {
 };
 
 &uart5 {
-	compatible = "qcom,geni-debug-uart";
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts b/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts
index a085ff5b5fb21..7256b51eb08f9 100644
--- a/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts
+++ b/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts
@@ -632,7 +632,6 @@ &tlmm {
 };
 
 &uart5 {
-	compatible = "qcom,geni-debug-uart";
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/qcom/sc7280-idp.dtsi b/arch/arm64/boot/dts/qcom/sc7280-idp.dtsi
index a0059527d9e48..7370aa0dbf0e3 100644
--- a/arch/arm64/boot/dts/qcom/sc7280-idp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280-idp.dtsi
@@ -495,7 +495,6 @@ wcd_tx: codec@0,3 {
 };
 
 &uart5 {
-	compatible = "qcom,geni-debug-uart";
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/qcom/sc7280-qcard.dtsi b/arch/arm64/boot/dts/qcom/sc7280-qcard.dtsi
index f9b96bd2477ea..7d1d5bbbbbd95 100644
--- a/arch/arm64/boot/dts/qcom/sc7280-qcard.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280-qcard.dtsi
@@ -427,7 +427,6 @@ wcd_tx: codec@0,3 {
 };
 
 uart_dbg: &uart5 {
-	compatible = "qcom,geni-debug-uart";
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 2f7780f629ac5..c4a05d7b7ce65 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -1440,12 +1440,12 @@ spi5: spi@994000 {
 			};
 
 			uart5: serial@994000 {
-				compatible = "qcom,geni-uart";
+				compatible = "qcom,geni-debug-uart";
 				reg = <0 0x00994000 0 0x4000>;
 				clocks = <&gcc GCC_QUPV3_WRAP0_S5_CLK>;
 				clock-names = "se";
 				pinctrl-names = "default";
-				pinctrl-0 = <&qup_uart5_cts>, <&qup_uart5_rts>, <&qup_uart5_tx>, <&qup_uart5_rx>;
+				pinctrl-0 = <&qup_uart5_tx>, <&qup_uart5_rx>;
 				interrupts = <GIC_SPI 606 IRQ_TYPE_LEVEL_HIGH>;
 				power-domains = <&rpmhpd SC7280_CX>;
 				operating-points-v2 = <&qup_opp_table>;
@@ -5408,16 +5408,6 @@ qup_uart4_rx: qup-uart4-rx-state {
 				function = "qup04";
 			};
 
-			qup_uart5_cts: qup-uart5-cts-state {
-				pins = "gpio20";
-				function = "qup05";
-			};
-
-			qup_uart5_rts: qup-uart5-rts-state {
-				pins = "gpio21";
-				function = "qup05";
-			};
-
 			qup_uart5_tx: qup-uart5-tx-state {
 				pins = "gpio22";
 				function = "qup05";
-- 
2.43.0



