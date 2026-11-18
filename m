Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029115;
	b=mFFXtkUFMI3H46ZPxf4HNE/1se9wco0/oE2B55j0yEbzIYCDHNN2Qvsij562JxRwX6+f
	 Ev1JkoGvYZuvUgmVb9pawYjEWjYDVZeVo3ZYbiukVqBkYDO06cjpmLX7ku/r7Lo6CijZU
	 v3K5r+aevfDDjO0lHF1krT3SzTZftUqPeXgOUXk2O92UCquqLSYmx6+0QOVMNVjwmhHL+
	 BBxnY5WS/FBDLvyVvzKLxuueTDooEbjABFafTdFkPhJNtV93UezSDCND6Gc4/JGPhYhdO
	 WPwhiZGUjnMnoOT3Sw9abGR+YPxgSZvMoi26FgYUXGpp0Ql69xUZZNl3xkJT+92eeGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029115;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3G70saNtQpor2KPLGsA/6rwzK+cNNTn/R+KMmS6YY4U=;
	b=2+h0fX8+D30OxTYZ3Si0ZRK6CKYVtDdp6MKeJ5nBDwdkyurr0YmCZU4Zbmh7opWmUVVu
	 28h8zq9z17guxKXLu84iTbUVwjfKf6SJSR5Ej2D0AgpTB4Du8MqmvvyLEdgZ4tq1Mc7uk
	 NMHe6tWM7fL/EvdeEdsVxCSoN1c+EJqgDyiFWjrRCPK4klf4fYQ4vVXT4wJJxcFQJM64L
	 81ox02dO00r+Cwi2yQvnQFRSvLyxetFPMkOTI/1PYPwqpn08PUTRDU6TiGQtyNykx/Qz+
	 cCAS6lg3/AxWrjbKOkUTSwFFpiIH3e684O1N6vhLvynN8riQSCUU4GcLP5c1M0qUO7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qrrcmjwg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F63606A31C;
	Wed, 18 Nov 2026 19:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qrrcmjwg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 520CD1F000C4;
	Wed, 18 Nov 2026 19:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029114;
	bh=3G70saNtQpor2KPLGsA/6rwzK+cNNTn/R+KMmS6YY4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qrrcmjwgmNZxolK/0m4Q6s9LgwdxYh5ChrRtLHlhAjLVysX1YQd0B1RDBKpMOV78f
	 sMCtxRnlaBnqPyXgMCOBg0Hmwn3lpmhaMUJBFaHmLSqiGCiI6wmOqSFh3sKCmcwaOP
	 pdE0oF0xKmx5h2sKQl9oeSAaDUn5u2Zk8invnlnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jared McArthur <j-mcarthur@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Sen Wang <sen@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0235/1756] arm64: dts: ti: k3-j722s-evm: Switch audio codec clock from audio_refclk1 to external clock
Date: Wed, 18 Nov 2026 15:39:22 +0100
Message-ID: <20261118150017.607366052@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jared McArthur <j-mcarthur@ti.com>

[ Upstream commit 432bfc86fe62b654c74d9376b03cbe4d3513ac5f ]

In revision PROC170E1 of the J722SXH01EVM [0], the audio codec's
(TLV320AIC3106IRGZT [1]) MCLK was provided by the AUDIO_EXT_REFCLK1
(96MHz). Revisions PROC170E2 and later switched the MCLK's source
to an external LMK6CE012288CDLFT [2] oscillator (12.288MHz). The
PROC170E1 revision of the board is not publicly available.

Fix the audio codec's clock by creating a new fixed clock node with
a frequency of 12.288MHz, and switch the audio codec's clock from
the audio_refclk1 to the new fixed clock. Remove pinmuxing and clock
muxing for the audio_refclk1.

[0] https://www.ti.com/lit/zip/SPRR495
[1] https://www.ti.com/lit/gpn/TLV320AIC3106
[2] https://www.ti.com/lit/gpn/lmk6c

Fixes: 3a36c535dfd2 ("arm64: dts: ti: k3-j722s-evm: Enable analog audio support")
Signed-off-by: Jared McArthur <j-mcarthur@ti.com>
Tested-by: Moteen Shah <m-shah@ti.com>
Tested-by: Sen Wang <sen@ti.com>
Link: https://patch.msgid.link/20260804210558.1455777-1-j-mcarthur@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j722s-evm.dts | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j722s-evm.dts b/arch/arm64/boot/dts/ti/k3-j722s-evm.dts
index ccc04548d3b9a..8286ce75a5744 100644
--- a/arch/arm64/boot/dts/ti/k3-j722s-evm.dts
+++ b/arch/arm64/boot/dts/ti/k3-j722s-evm.dts
@@ -194,6 +194,12 @@ vsys_io_1v2: regulator-vsys-io-1v2 {
 		regulator-boot-on;
 	};
 
+	tlv320_mclk: clock-12288000 {
+		compatible = "fixed-clock";
+		clock-frequency = <12288000>;
+		#clock-cells = <0>;
+	};
+
 	codec_audio: sound {
 		compatible = "simple-audio-card";
 		simple-audio-card,name = "J722S-EVM";
@@ -219,7 +225,7 @@ simple-audio-card,cpu {
 
 		sound_master: simple-audio-card,codec {
 			sound-dai = <&tlv320aic3106>;
-			clocks = <&audio_refclk1>;
+			clocks = <&tlv320_mclk>;
 		};
 	};
 
@@ -378,12 +384,6 @@ J722S_IOPAD(0x0084, PIN_INPUT, 2) /* (N21) GPMC0_ADVn_ALE.MCASP1_AXR2 */
 		>;
 	};
 
-	audio_ext_refclk1_pins_default: audio-ext-refclk1-default-pins {
-		pinctrl-single,pins = <
-			J722S_IOPAD(0x00a0, PIN_OUTPUT, 1) /* (N24) GPMC0_WPn.AUDIO_EXT_REFCLK1 */
-		>;
-	};
-
 	pmic_irq_pins_default: pmic-irq-default-pins {
 		pinctrl-single,pins = <
 			J722S_IOPAD(0x030, PIN_INPUT, 7) /* (K23) GPIO0_12 */
@@ -575,12 +575,6 @@ ldo3: ldo3 {
 	};
 };
 
-&k3_clks {
-	/* Configure AUDIO_EXT_REFCLK1 pin as output */
-	pinctrl-names = "default";
-	pinctrl-0 = <&audio_ext_refclk1_pins_default>;
-};
-
 &main_i2c0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&main_i2c0_pins_default>;
-- 
2.53.0



