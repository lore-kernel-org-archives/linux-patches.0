Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017644;
	b=GPr+vAO2A3wjCSpYacpshEIbbL3oAr4wcpwsEhy0Rv5nN+Ve0Hkfwfs/QvIR5xMV4Dk4
	 PZsGTz1LArUgUEzZPFDUYPzrZ6cWJ98XLDp3Z/Q8CKZF7UXIyvBxLv51Jz11GIJrWtBnE
	 hv41ebUVnKxZOgFPm0CrtyfWRFWPursrOh/lSLXR+YjkC0obgMJXMSA4bySLz5eCmi7cS
	 QzeaIq9S42anGf6Z84o8cDtveuPDLF+VMKn8NPDTP9rqcZ9uCqvOzLWOxx1tYCwHjEs78
	 zosqQ4+vMrQZMgPZ10stv2YCJS3AEApV2VupmHKjoGKdyWvb2ld52eyaJdNQWKOs23w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017644;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/gtKe3m9UDAnbwLCYuEp43dmNSLLzsKC4hwUr+lWbtI=;
	b=B0HCiAhcfnV52nOt3JaD1xm+HhjvoVLnKWTHDfIadgVESHs/L5qleJMWD8RB+hB8J1LG
	 JryYLrcF52RewvPHxtI0DdU5OTAib/GyvvY6S/5bwq49bNB4jt7FOjIJi+vc8PEgyWOfF
	 VbuSrkTWx9SImYxjud9kDdgXBJgDlOz1reXGh9VlsrJvdkKnJuBMj58C3K1Q+83cW30ot
	 ydT6LpF1UQ62naKk66tObwLiRRCI1BkY8xlWICHgbnnRYUe8c2MJaX5+s4jnbNc2ygI2m
	 eG5SX+TiW4y3rtFjeIMGjXMNLRkopnH6pOVigU/Esby510mXe7cqv2N7VkRjwHI64cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pT+c5M2G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93549606A31C;
	Wed, 18 Nov 2026 16:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pT+c5M2G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70851F000C5;
	Wed, 18 Nov 2026 16:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017644;
	bh=/gtKe3m9UDAnbwLCYuEp43dmNSLLzsKC4hwUr+lWbtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pT+c5M2G1A4OEb1+q6wCJHE+f8g0/5BMkznMnegoFzH/Xh424Pj6An7J6A/tfTqib
	 pz6Y1zgCtaf2Sy5ciI45XPwFUcJSOGzLo0qr60rvWlX/bzoB8xxOKLLutKTcU3NZs8
	 A1/VewoREq1ekvYMhZmBRXaCwfCwKD5xN7KV8jpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Liu <xin.liu@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0917/2651] arm64: dts: qcom: purwa-iot-evk: use on-board crystal for PS8830 retimers
Date: Wed, 18 Nov 2026 15:35:57 +0100
Message-ID: <20261118150320.907191946@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Liu <xin.liu@oss.qualcomm.com>

[ Upstream commit bda6d233a6ea408817fa5fb5727d11fa2349d9a5 ]

On the Purwa IoT EVK, each PS8830 retimer has its own 25 MHz crystal
wired to the retimer's XI/XO pins. The reference clock does not come
from the PMIC, so the RPMH_RF_CLK4/5 references in the retimer nodes
are wrong: they keep those RF clocks enabled for nothing and describe a
connection that does not exist on the board.

Remove the stale "Left unused" annotation from the vreg_rtmr0 regulators
as the retimer is actively used.

Fixes: 9ed20e877239 ("arm64: dts: qcom: Add base PURWA-IOT-EVK board")
Signed-off-by: Xin Liu <xin.liu@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260914101233.981643-2-xin.liu@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/purwa-iot-evk.dts | 27 ++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/purwa-iot-evk.dts b/arch/arm64/boot/dts/qcom/purwa-iot-evk.dts
index ad503beec1d3d..49ef183e2f5e9 100644
--- a/arch/arm64/boot/dts/qcom/purwa-iot-evk.dts
+++ b/arch/arm64/boot/dts/qcom/purwa-iot-evk.dts
@@ -60,6 +60,26 @@ chosen {
 		stdout-path = "serial0:115200n8";
 	};
 
+	clocks {
+		clk_rtmr0_xo: clock-rtmr0-xo {
+			compatible = "fixed-clock";
+			clock-frequency = <25000000>;
+			#clock-cells = <0>;
+		};
+
+		clk_rtmr1_xo: clock-rtmr1-xo {
+			compatible = "fixed-clock";
+			clock-frequency = <25000000>;
+			#clock-cells = <0>;
+		};
+
+		clk_rtmr2_xo: clock-rtmr2-xo {
+			compatible = "fixed-clock";
+			clock-frequency = <25000000>;
+			#clock-cells = <0>;
+		};
+	};
+
 	connector3 {
 		compatible = "usb-a-connector";
 		label = "USB-3-Type-A";
@@ -295,7 +315,6 @@ vreg_pcie_3v3_aux: regulator-pcie-3v3-aux {
 		pinctrl-names = "default";
 	};
 
-	/* Left unused as the retimer is not used on this board. */
 	vreg_rtmr0_1p15: regulator-rtmr0-1p15 {
 		compatible = "regulator-fixed";
 
@@ -686,7 +705,7 @@ typec-mux@8 {
 		compatible = "parade,ps8830";
 		reg = <0x08>;
 
-		clocks = <&rpmhcc RPMH_RF_CLK5>;
+		clocks = <&clk_rtmr2_xo>;
 
 		vdd-supply = <&vreg_rtmr2_1p15>;
 		vdd33-supply = <&vreg_rtmr2_3p3>;
@@ -743,7 +762,7 @@ typec-mux@8 {
 		compatible = "parade,ps8830";
 		reg = <0x8>;
 
-		clocks = <&rpmhcc RPMH_RF_CLK4>;
+		clocks = <&clk_rtmr0_xo>;
 
 		vdd-supply = <&vreg_rtmr0_1p15>;
 		vdd33-supply = <&vreg_rtmr0_3p3>;
@@ -848,7 +867,7 @@ typec-mux@8 {
 		compatible = "parade,ps8830";
 		reg = <0x8>;
 
-		clocks = <&rpmhcc RPMH_RF_CLK4>;
+		clocks = <&clk_rtmr1_xo>;
 
 		vdd-supply = <&vreg_rtmr1_1p15>;
 		vdd33-supply = <&vreg_rtmr1_3p3>;
-- 
2.53.0



