Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055737;
	b=ihBV71FZC8QVczzxtFA1kQKL6eerj+lkk5yLGJLG6WL0CQ3abwLRbUE6kV3vK9/x/SoX
	 +3UaCypAnAwhPxaPubnAGJ8yny8DYu1UdFnDA71n4pohklMrn7zgVFmgnHpJ2JGQc+LqF
	 nib9Dkisu2bdfG6nhtv5yTqjR8RnISW2oab+0hcaF9VcRxZXDX0xGFVutkf74jW5GZWai
	 OE8MtdaFOVN+pVB11AxKBgsq7cpzUKVuBcxcp2q7t2/2QT1rc9caqiBH2VfKUtxZd0koh
	 Xva5KcXqK1fP9ZbGUOJS/JcdIdEzI5+bTTvHsjPTZPGYVXK7Jbfp9e+G/Hk1x9sIhtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055737;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XqC9EGUw+U5Mmd/Gr7ohnm/lN+gqRSvyA5e6bAZCeT8=;
	b=svtzKTbmKLB2+jx6MmIeKCyRH1jPDmRNURHsQTn9Dt75HsHUPPV509C1uATd1RL7O4Ni
	 Je/lRof4sMiH22VkwT7XzeA6B4DP2/bROMj+BXK6ncLZT/lqkPif3v1c2F6dLEcS5tFdt
	 QDTZtSsk6xIN49jM6OSzq7i+AkqmZlBcaW0u36WOYKP6suIbm+wq4G+/DZxJcfvq+veZy
	 6B0wi+HFw95eNGdrh0rmVU5D+pInEkGk+AH/Aci7fm5ZiS4PqnApNYU6DubKiiJbcLgel
	 UDLOPQY9xuRSZdC9tG3lk3D2hH0g5UUvTx4BUksbvgJaV0GhZOlMz+3Lmcik5Vgdqzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NMO6VVOl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4AC606A31C;
	Thu, 19 Nov 2026 02:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NMO6VVOl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA96C1F000C4;
	Thu, 19 Nov 2026 02:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055737;
	bh=XqC9EGUw+U5Mmd/Gr7ohnm/lN+gqRSvyA5e6bAZCeT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NMO6VVOlWVQslga5sPzJifhZGzAeJ0Po58T00ZCCmoqCx3z1Yt4aovzSHPMEekBUd
	 bVd7kxMmXN6Kw7SUM7ZiGaZLpNBVQeISQNpT64SdDLdN7BZ6t+LWL7q7D0utHcEFgD
	 By+WpKv6lWR1TzhnbKGzPQfeZqDc6RextYAakTfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yaozhong Li <yaozhonguwl@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1739/2214] arm64: dts: rockchip: disable unused i2s0 on rk3399-firefly
Date: Wed, 18 Nov 2026 15:56:55 +0100
Message-ID: <20261118150121.220343752@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6df072b5fe4ac..6d732431d9615 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts
@@ -622,13 +622,9 @@ accelerometer@68 {
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
@@ -683,6 +679,12 @@ ir_int: ir-int {
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



