Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040789;
	b=HlfK43cexKmnE3bzmHhQhvGFyRbxeNlj9IB6FbX1G8+d7WI3RAz/rBv3ZcFbMx0O6hcI
	 JP9mME+yrGugU1mHRUZiDo0XBKcN5r6PHXQzTrv8RKGE9kgRdOiTKZsWdWTnn1pTVVLv4
	 P3U3VKvyyFnygdxeVtd+TVzkk2h/ejgU8y3/KIz2Az7RaCEj+uTQL4QuTTKoUzJ/MGxcD
	 mmNVURYXt6tihrnfiUMPBKQZsEa2YmhanDhbGRjOmzhuBs2KvLdWuJVrAE4yGLzgiStSm
	 w6LluY19y9TAwFbRDadhuy3lQwU0RmRMeeQTbahCW0coCjMiyEsDFmVmsigH6RQv26w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040789;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R0R+OPEBY3bGgmI4dNJNs3KiaWY5zVR72GQhY9r2Ls8=;
	b=pte7jJKJpFTA/3d2rMHckIWhlMh9v10rV1mGPlpXnFRlWuDCwVuz6tjRMG6hB0uhPj32
	 1BHF/6KxgxOtfsNFmynqR/yEGg+g+jz7kD5OMWAEdro0A74oLi/o7SplbXWxgF82qBknL
	 L+pG+dXDSkn+Xk6Epj6dzG0jIDjFve1A+nbQA98LZMkdk2AfnexOK6tO9zoAaf22SahGd
	 ZG5K17ltJhMHXmzmirEMuyyzktOygltQePerEYDkoEaO1Ysx1oWHGe/2Fz1amcFeysick
	 0oBCsxzh+0yn18eKEY40VTB4GGtZq509bqR7zH4GMwXuDNLNzoaKTdvMuUDUu/pdRSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KgsXOCU5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5BA606A325;
	Wed, 18 Nov 2026 22:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KgsXOCU5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D7DC1F000C5;
	Wed, 18 Nov 2026 22:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040788;
	bh=R0R+OPEBY3bGgmI4dNJNs3KiaWY5zVR72GQhY9r2Ls8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KgsXOCU5I2ucfn/OubM9q/JUCTNE97xx2o0Mn8pVgIgJtqXOvb9hESXAIOoxPmSOr
	 Wxf5EOL8Z0ZnZJAD0qIHdT0dIQA3VrIZNDbwzfFniy2hbzqWiK22H/uoC/RoUXvx+C
	 6URISnZZxVHSQT5bC+iZf8o1uW1c/A55kicEfPPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yaozhong Li <yaozhonguwl@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2580/3318] arm64: dts: rockchip: disable unused i2s0 on rk3399-firefly
Date: Wed, 18 Nov 2026 15:53:22 +0100
Message-ID: <20261118150438.603019249@linuxfoundation.org>
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
index 0e5cb46f0ea01..ba2ba5cffe43a 100644
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



