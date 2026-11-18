Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017647;
	b=pubY/SPrXrQCgI13jgnGaMSeBHgnw6iXSFO/hcN3H3z8FuGKBtoWcbBJxkWwqcZCEDyg
	 wdvGywYsmb8H+HWss0to2IxhqO5gsLC1IU42+K+uR4YbkuPS4ZpfaZb6z2/tSXjtxuyvQ
	 +H3RuCXhmfDBIXwLrLbJxgEZ25ysJeNl/ouwa36ubRx3w96JOPPxhPHloFmnep2mmxMjW
	 ZTf0N+MVVi/D6fRuNj3aVKt/HL9RyWGgLdRpC4MzNPNOjooP0agGM0oGc+Q7jJ5ej2ok2
	 LGRRmfTubyHSFgs03rb3aoJjUUc5BxRJRqhLCcABVAzaffSq77Pxj3mGfmxndt4kprg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017647;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QjRq6KbwouGiDKbC3QHThLjtnu2WV9rJKhs7YFJgraw=;
	b=RAg3LeRc5VAKgK9jaAofO82LY85rtddACafI7tspTPfc6HuSUjVQZsUJPVaCJKlhXp8m
	 dKlFOW0+DwneNur0ERxhBX0pZ7gFaJwRhE6moIDdbmMnnfNfTFhnWtHJ9/Oa2jPqUQYoL
	 pwyO/IETpASE2mJmKWhkr07n2mGB1G5zTwt46rychYtioPNltL2cIExizTAaSWeezmIL0
	 U7Xy4xr0rTvbvEgmZR0Q4hV0UBzRg/7IQ0JzT7mcohLwD4eXpT0zrI6cX/FYYBLpgmVBI
	 Bg11+DX2SpbocaC4qm8kKfDduAdX2YR34LMp6S5gmOTv1nLonZym55LW2MgeKmEo5BQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jqI9krRn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A18F606A334;
	Wed, 18 Nov 2026 16:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jqI9krRn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C945F1F000C5;
	Wed, 18 Nov 2026 16:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017647;
	bh=QjRq6KbwouGiDKbC3QHThLjtnu2WV9rJKhs7YFJgraw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jqI9krRnRTqHZFlyI0W06jw/GZeFqjbZpeVYV3ltKJpYOajDzuN1ox2SV3ie38BtF
	 MRFOjYCQVPo6rWl95AL33ZB2HcciOizvuXl6HHJzvOJMoGZLWp5qe2527blHEUstbN
	 8zpJwIVlRXRItAsHzShqxTWZRVy19j0G5MLnC604=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Liu <xin.liu@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0918/2651] arm64: dts: qcom: hamoa-iot-evk: use on-board crystal for PS8830 retimers
Date: Wed, 18 Nov 2026 15:35:58 +0100
Message-ID: <20261118150320.943055522@linuxfoundation.org>
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

[ Upstream commit 723ce02feb131a81224a281872028d584b69b0ca ]

On the Hamoa IoT EVK, each of the two existing PS8830 retimers has its
own 25 MHz crystal wired to the retimer's XI/XO pins. The reference
clock does not come from the PMIC, so the RPMH_RF_CLK4/5 references in
the retimer nodes are wrong: they keep those RF clocks enabled for
nothing and describe a connection that does not exist on the board.

Fixes: c11645afb0e2 ("arm64: dts: qcom: Add base HAMOA-IOT-EVK board")
Signed-off-by: Xin Liu <xin.liu@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260914101233.981643-3-xin.liu@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts b/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts
index 9fa86bb6438ec..b8bb9bb70db72 100644
--- a/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts
+++ b/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts
@@ -35,6 +35,18 @@ mcp2518fd_osc: clock-40000000 {
 			clock-frequency = <40000000>;
 			#clock-cells = <0>;
 		};
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
 	};
 
 	wcd938x: audio-codec {
@@ -745,7 +757,7 @@ typec-mux@8 {
 		compatible = "parade,ps8830";
 		reg = <0x08>;
 
-		clocks = <&rpmhcc RPMH_RF_CLK5>;
+		clocks = <&clk_rtmr2_xo>;
 
 		vdd-supply = <&vreg_rtmr2_1p15>;
 		vdd33-supply = <&vreg_rtmr2_3p3>;
@@ -860,7 +872,7 @@ typec-mux@8 {
 		compatible = "parade,ps8830";
 		reg = <0x8>;
 
-		clocks = <&rpmhcc RPMH_RF_CLK4>;
+		clocks = <&clk_rtmr1_xo>;
 
 		vdd-supply = <&vreg_rtmr1_1p15>;
 		vdd33-supply = <&vreg_rtmr1_3p3>;
-- 
2.53.0



