Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030851;
	b=ZKkYR4vaE0C0U3RlNCH4RNwwwp9Gy/Q3XISzqKN2SJ+xVPZ0C2s+CJVinbuHICmC02bC
	 DP05rRFWjFjMCkDSeKrMvFvXptBT231+M4wAsXI5740zLPh+HGmHTa9Bv4HehQqCofZaz
	 phEMNVFKYflBASDV8LdqETvH4+qn1aOQWTXdECH3KBkyeK2P6M7IAgXsnvk+tGKDP3HoN
	 B19JTNqlDGOCh/zteWKCU7GMKlZoa+6jF0v9DOR0AFAsmJ+ri8F26cG3WU0pPZkHGK8w8
	 OE9zRdTpYInADJLBHFaLaoIDZbL1HqfU2K8tWf70/FcbKAu9z4tQZglgMjdqFl97vkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030851;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vObVqDQMX8SgcJVxk6jBep0tYhUxzIHTP1CTo4ciYAk=;
	b=TuK49iQBNntlr0GJhjmNbejQK259HBQI1GAJH0z1enLNsM2QmInvRKd7VLIPqFYwkUZs
	 36glg+3PYmk+TE9IS93WjLENGGLu5qpbhNnL1kuU4+f8VoZ9Ul4cnonGzIL3gm6+cCl0j
	 iq3Jr0rUcIzOZOnBNWzuVlc+bUSQBww/qH0iPyilOwsAxmLkLDjmSe6p4BS1pUez49V4q
	 DIIVYFoMMFOBfjz4wFRV2TVjUO+F4RqKtBH8yFDuPcHE+bUaa5Oxg0vRpxpU++w1FLhzs
	 Gw7n4tvS+gCGOfydNQC53+gq9MOcFjoHIDtDXRbkee9xLt8UOBq1y15GvYZ4h3ZALUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t2TDfXgB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B25606D34D;
	Wed, 18 Nov 2026 19:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t2TDfXgB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67DA51F000C5;
	Wed, 18 Nov 2026 19:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030850;
	bh=vObVqDQMX8SgcJVxk6jBep0tYhUxzIHTP1CTo4ciYAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t2TDfXgBtjCdtf8oySY2szwHZ1XLAbbf6D4FoFWY/UPU/nYMep9xSIcEnPRFRqEUS
	 rCg+cE/muAP6fwb8r78OTOM6Y9OBpOyBqVPuM/obKbFYANrKu5rxMEp5hLbhEr5lGe
	 csoKbSgIiXgKwuCRUKXG3I1M5MQNS1LFCoO0BeZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yaozhong Li <yaozhonguwl@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0851/1756] arm64: dts: rockchip: disable unused i2s0 on rk3399-firefly
Date: Wed, 18 Nov 2026 15:49:38 +0100
Message-ID: <20261118150043.264511078@linuxfoundation.org>
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

From: Yaozhong Li <yaozhonguwl@gmail.com>

[ Upstream commit 9416a641cfe5b75dd9178c15960ee741c1091b45 ]

The board file enables i2s0, but no sound card references it: the
on-board RT5640 is wired to i2s1 and the S/PDIF transmitter has its own
controller. Keeping it enabled starves the other controllers, due to the
pl330 instance that serves the audio block only having six channels.

The i2s0 pin groups also lists GPIO4_A0, which carries SCLK_I2S_8CH_OUT,
providing the MCLK the codec runs on.

So add the pinmux for the MCLK signal to the i2s1 node.

The RT5640 and S/PDIF cards then register with no DMA errors, and a
1 kHz tone measured through the codec's internal HPOL/HPOR loopback is
unchanged (L 2135 -> 2138, R 2202 -> 2203), confirming that MCLK still
reaches the codec.

Fixes: 171582e00db1 ("arm64: dts: rockchip: add support for firefly-rk3399 board")
Assisted-by: LLM
Signed-off-by: Yaozhong Li <yaozhonguwl@gmail.com>
Link: https://patch.msgid.link/20260921063431.103-3-yaozhonguwl@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-firefly.dts | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts b/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts
index 1dddc26efed95..7e5452cdceabd 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts
@@ -628,13 +628,9 @@ accelerometer@68 {
 	};
 };
 
-&i2s0 {
-	rockchip,playback-channels = <8>;
-	rockchip,capture-channels = <8>;
-	status = "okay";
-};
-
 &i2s1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&i2s_8ch_mclk_pin>, <&i2s1_2ch_bus>;
 	rockchip,playback-channels = <2>;
 	rockchip,capture-channels = <2>;
 	status = "okay";
@@ -689,6 +685,12 @@ ir_int: ir-int {
 		};
 	};
 
+	i2s1 {
+		i2s_8ch_mclk_pin: i2s-8ch-mclk-pin {
+			rockchip,pins = <4 RK_PA0 1 &pcfg_pull_none>;
+		};
+	};
+
 	lcd-panel {
 		lcd_panel_reset: lcd-panel-reset {
 			rockchip,pins = <4 RK_PD6 RK_FUNC_GPIO &pcfg_pull_up>;
-- 
2.53.0



