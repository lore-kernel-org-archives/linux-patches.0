Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061319;
	b=SOstqv6EsPGsiXhCe2LGDw8mBFgxSf++VA2dCskdmCjcvZYvGzpCxm7qLLKrTyuVCKdh
	 L169X3eUD2CqJI9oy1iKThNdGxI9cYWufxCvwMj7xByu7OiOb+KkF2OxF/cL1rXHQ9yiP
	 d1Q6BRdIZ7V9jFQ0aL+nyTnI8Ukft3FdHs+X8c1sX5vvmOJ4buWsnXOjnwdwRLfYdzrbI
	 a37lcU/5bPKDh99efFbIfHY014VKpHGXcme6QbInD+xfXrA+iNfBQo3uc/N1wDxrPkKYo
	 sR1P2DcYZ7Skq0O96cM+TbxuxxQYWFTInLNrG7kyBh9HjtvA5BLHVUc3MTlWAhLJJRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061319;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ap1ZAg1EW5iw+uyBOPPj27rlPH/GZ1ywb+g1UNsosZk=;
	b=K3/AKAT2++PbMc608z+M8T+KQn7IM3bsjwjDO4gGfpC5xJt2U7TtR38pT5coFeUZ31VT
	 typ5kmwH4ODoas5IzZIWtCtFPY5ROLgJKEfXhTU60p6WS9MUuDTVxDtW7b2SqNlL4bz/w
	 mmNMeyJNJFW2frGXueKoBOVdMFlMDHr+yMg8Kt8iRDB5i3LwvRDUB4qqbHNjE4XCAkQSP
	 BTBKoeEL6A53AP3cG2mRhSJYKtZVnGedN/mYydIC2XY084XdINymtHSFvsiiXYAK9QrAt
	 nHvk2xaintnCQLkC4UzgZI7I2Pfy0K9tC4UCnRFIXEPeqKJ5GrsTQVUwTLKyHabzVow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ig7qdVFH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D03606A320;
	Thu, 19 Nov 2026 04:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ig7qdVFH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077131F000C4;
	Thu, 19 Nov 2026 04:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061319;
	bh=ap1ZAg1EW5iw+uyBOPPj27rlPH/GZ1ywb+g1UNsosZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ig7qdVFHl+AN1BZ0jInr1iYAkCNSKtncIS2sxx4XK51Xlzi2zImg/KKeQBD3KXice
	 h8NEltWvvUvuQZKY4GGlXz9WjpjEGyF6yY16wOSv1W9N0GWIX6j2eQK7zuqkWVMl0Z
	 H8OQ1bAO2wxFIYkGANZFuZDiWxqirTQmP4j+RLuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yaozhong Li <yaozhonguwl@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1468/1848] arm64: dts: rockchip: disable unused i2s0 on rk3399-firefly
Date: Wed, 18 Nov 2026 15:58:26 +0100
Message-ID: <20261118150020.778645472@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 07272ed3a7695..546948f8a0ba4 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts
@@ -540,13 +540,9 @@ accelerometer@68 {
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
@@ -595,6 +591,12 @@ ir_int: ir-int {
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



