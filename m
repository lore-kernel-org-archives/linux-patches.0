Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049114;
	b=Y0RUI+XuH1vnZEbLwjrzHNCnfxETZsT+6ENT9k3vDTOSpLEUwEQ3/5qoDh3aDwIxWet9
	 qkNj9HtSjX81wgU99eiOpPA1e5TGh/aeWOrd8UTC8v35HYQXvdl/cTL73RsYiAQ6ZzR7b
	 hq3alm3LNj92I+Fslr+2QS+qmMHr0WxBlpL1CC1VffKfAKzeBt3+PKi+U2ytv/yfOA1d4
	 EQ+9HiNNshrRuU6y+AFzo3CNnNwDUERckBNGPKk0VvQKLYALBswGY+ZzMOcQhKgN3nO7P
	 H6vZbBPGFk5JQTutn38BXlGfsU2K9yszfPil9V+MCwxsI7/AF2n4741MR3xWIUJybKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049114;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QGy5Uagxc9MORBqVF1/aU52yDMYdv7+llvTZ7+/wpdk=;
	b=f1kRe0r7/VnjMCaDALwIVyOHvt/wsHrHhulF9QF9+rWr9dL2Si9JV5CNOvjlfxV8hoDO
	 OAQIvj4OC//7eCB21zlQqLZ2mHofa/xpIde0+5nW6hodbZU58as5n18WqOCV2osa1Eaz9
	 086FrC76qzQIZiET25zcCuOT3xf4Zs6jsX7XBKeEZ3wV4OzjcdrIxflMYU5j/Cc2e/E/n
	 nZxbCfJCLe3FBpYLELn7JBsHA5+smJwDlW3ScOamDpgLNEZld9egrezGT3ZepcZWwm/XX
	 yM/64UPZs3YXPE1ouy3257w4ceUtNmB0Kl/oWN93svNeYQfsh9xd/beGzoNc0KaIjGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rcjYSYJw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9BB606A32C;
	Thu, 19 Nov 2026 00:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rcjYSYJw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82931F000C4;
	Thu, 19 Nov 2026 00:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049114;
	bh=QGy5Uagxc9MORBqVF1/aU52yDMYdv7+llvTZ7+/wpdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rcjYSYJwUSsy5taDIBIndaXJPGj7VTeadc3ORyMEUXLRwW2sffQWUMDWa7lUar5ZU
	 oV52RMqy4ELqApmfQTvmmI/5/rclYHJbjwHEH2y+REmQjpOBLBsYmCq6ZXWnhDq4RJ
	 cc5gNwYDLT+GtaADuFwrWZDwzXue5dSXJgWAh+0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yaozhong Li <yaozhonguwl@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2229/2857] arm64: dts: rockchip: disable unused i2s0 on rk3399-firefly
Date: Wed, 18 Nov 2026 15:54:23 +0100
Message-ID: <20261118150321.675849873@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



