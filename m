Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040786;
	b=KNM0ZQmCrMx/1dxRIr2/tMl4V1G2DMv+00zR1mRH0WcPdEOVHbIi7VQPFEZEG49I6HwG
	 Pcs91IbdwDUz9AhgPSVu0JoEmXxnBOqWMfURji2JAdqAlYqybTw3JJ6w+UuSlCYBTPSuy
	 Z+sl4ypmvyhTaJlcQu04n1ws0G+NlYoy7OLkC1XCZNRaaCZNrLBAj1j5KM6lp2/0QbvHF
	 5ZqIz/FrKa2JEvuOUUz10XrI/NIxxuH4VPNadCJvYE0g3Hdgyk6I+RSLGcjzCSArWrgl0
	 NqRo8+a8gzddTcGCT6MG3Vfwivm2tP4uGpJpdJT3T4BhXgpehzDbqJiO2AnH2Cv6L0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040786;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9rNwIUhB3ixo1/1+9/+XqkVLMgsAj4yqbTq2spxamFM=;
	b=VflBrWyGEeKCTj5vna9qh8r8qrTBvweUgVGOCOmNHMHVBt6a6jmfHRhnvO347p/Wh3Wm
	 bO9npVMlZuDQWLGWikzyZPTSlUn0PICoKVZX+0oEX3G3mRLSWoY6z2tME35yJ/X1qiinv
	 YrHrMZ+wJtshOZXn4xx5y1TlIfN0MYstNiqa8/sAVYFpgDDwQ1hQS0dMSPgy4dPLn+w0M
	 9d3BDmrxH+D221iCt3LA6qXf+QRprcTHs8sqQKj+Pt+oFR6R4ncGkI2bSa8kz9uZ1myVB
	 FhogW0GwqZRtuhI7/jUHTSQNLbDhenQIqvXaTh0qH/sKGj1s4QqkOZQCZnAK3uC3cWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U2nS8ayg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B7B606A31C;
	Wed, 18 Nov 2026 22:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U2nS8ayg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888411F000C4;
	Wed, 18 Nov 2026 22:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040786;
	bh=9rNwIUhB3ixo1/1+9/+XqkVLMgsAj4yqbTq2spxamFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U2nS8ayg5dFaXyMe7SJ+NUee+s7sFhUk32UVhXG2OGZhZTgHLNq8iCo6WQv9SEe50
	 APU2j6MLm4FIsH2UcgOHJbtlCS+eZMDgFG7nmFgSuwPJe+7KZB5dhze+1nZ8uqF6ei
	 Ekcyv2SmJT0VDyk0xLD/E7HTDtwE2yHkPTs6ok8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yaozhong Li <yaozhonguwl@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2579/3318] arm64: dts: rockchip: fix analog headphone output on rk3399-firefly
Date: Wed, 18 Nov 2026 15:53:21 +0100
Message-ID: <20261118150438.575427500@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yaozhong Li <yaozhonguwl@gmail.com>

[ Upstream commit 23eab1a5e36099fd1269f8a18dc389e04dc19011 ]

The analog headphone jack on this board has never produced any sound
with a mainline kernel.

GPIO4_C5 has to be high for audio to reach the jack. The board file
muxes the pin to GPIO through the rt5640_hpcon pinctrl group and
references that group from the codec node, but nothing ever requests or
drives the line.

Describe it the way rk3399-roc-pc-plus.dts already does something similar,
as a simple-audio-amplifier auxiliary component, so that DAPM asserts the
GPIO while the headphone path is active.

Measured on a Firefly-RK3399 by toggling only this line while a 1 kHz
tone kept playing, with the playback PCM in state: RUNNING throughout:

  high -> audible, low -> silent, high -> audible

With this change the line is claimed and follows the audio path:

  pin 149 (gpio4-21): headphones-amp gpio4:149
  idle:    gpio-21 (|enable) out lo
  playing: gpio-21 (|enable) out hi

Fixes: 171582e00db1 ("arm64: dts: rockchip: add support for firefly-rk3399 board")
Assisted-by: LLM
Signed-off-by: Yaozhong Li <yaozhonguwl@gmail.com>
Link: https://patch.msgid.link/20260921063431.103-2-yaozhonguwl@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arm64/boot/dts/rockchip/rk3399-firefly.dts | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts b/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts
index c5db64f3e1241..0e5cb46f0ea01 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts
@@ -96,6 +96,15 @@ key-power {
 		};
 	};
 
+	/* GPIO that enables the headphone output path */
+	headphones_amp: headphones-amp {
+		compatible = "simple-audio-amplifier";
+		enable-gpios = <&gpio4 RK_PC5 GPIO_ACTIVE_HIGH>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&rt5640_hpcon>;
+		sound-name-prefix = "Headphone Amp";
+	};
+
 	ir-receiver {
 		compatible = "gpio-ir-receiver";
 		gpios = <&gpio0 RK_PA6 GPIO_ACTIVE_LOW>;
@@ -132,8 +141,11 @@ rt5640-sound {
 		simple-audio-card,routing =
 			"Mic Jack", "MICBIAS1",
 			"IN1P", "Mic Jack",
-			"Headphone Jack", "HPOL",
-			"Headphone Jack", "HPOR";
+			"Headphone Amp INL", "HPOL",
+			"Headphone Amp INR", "HPOR",
+			"Headphone Jack", "Headphone Amp OUTL",
+			"Headphone Jack", "Headphone Amp OUTR";
+		simple-audio-card,aux-devs = <&headphones_amp>;
 
 		simple-audio-card,cpu {
 			sound-dai = <&i2s1>;
@@ -547,8 +559,6 @@ rt5640: rt5640@1c {
 		clock-names = "mclk";
 		realtek,in1-differential;
 		#sound-dai-cells = <0>;
-		pinctrl-names = "default";
-		pinctrl-0 = <&rt5640_hpcon>;
 	};
 };
 
-- 
2.53.0



