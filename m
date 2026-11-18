Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015412;
	b=0Iw4T9e2eg3oMu6g9Xw3WjuGmM1YcLPrNCeqZgauuCxwlMWKa2NbSKnrt7qMqCEOaFUl
	 z+jfIHm2FgD6edGvnyJdHGKl59fx6WqJTyStFx6ZlNxs1J0vUOjFNU6SnHbIdXFDrORlx
	 GkwuT46f/25opR+DAkiF8pBa8Y7r+dlAccTulXF1/NaG1PVlwcqudwpqOaV+dE+yTEDA9
	 xa5bzNAnLtbspjSNvtzRoTiMOpr6ea2hAkWORJuHltkSej+Oh7HzWymtFn9QDmz1iYpuh
	 cmDjafhuEq69Jh/yG2EIhjxwmtT8YUBZrbz2f0KylHPTbhy6e+1hVPi1UHoQpfuusZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015412;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tMAzlCWaQ04uxFm1jMzGL85VtUv6ruB6Fu1EfAYVfAw=;
	b=dIR2S4VxOUa/k54kkwrWRvXybaIW3Wk4zOtcJUhyHNGPO5QNaBQDoNQKdmy04ZE2JfHA
	 KYRK9UaFlXWfVnDuksnvVtFLAVDXvIC38F7GOHd0HpCBmeoonvJ4bJk7YpGiogFotWyZM
	 BaC4Z6vDVHFTJSbdUxViQEGMzxzFkMDLqo8KB+pN97VhplCuREt4uEClrqLpHD8NlJ61I
	 BGz0XHIv9Xx7bWj33Zh0oTU18Hon92O87xV0o8ehM2gpilHElKbT7z0B04i57J3MrpJNR
	 TfGRAWwh7EM6aYzXZsnuWVvMJbJq9Z6J14D7gW+pccFmlkXzhq2wzQHSW52scOEpyNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=adTFh5Nm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24372606A320;
	Wed, 18 Nov 2026 15:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=adTFh5Nm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A57E1F000C4;
	Wed, 18 Nov 2026 15:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015412;
	bh=tMAzlCWaQ04uxFm1jMzGL85VtUv6ruB6Fu1EfAYVfAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=adTFh5Nmj+LNZYbwwOY33gcwVeSyk2+MWsWclmb8Vu4WN9gjZfKNwOQBc/30K7dON
	 7EMFnZYjfHUbP9xaRk+gtjdNjOk78FIyd7QpllV3+0SsBbMy/OdM0z+38xwdtcvTJu
	 tOuTXL2SRdvRaNtfP4Rlq/dR/vcEGfRTNpvCHK0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Primoz Fiser <primoz.fiser@norik.com>,
	Chancel Liu <chancel.liu@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0123/2651] arm64: dts: imx8mp-phyboard-pollux-peb-av-10: Fix SAI master assignment
Date: Wed, 18 Nov 2026 15:22:43 +0100
Message-ID: <20261118150252.294900977@linuxfoundation.org>
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

From: Primoz Fiser <primoz.fiser@norik.com>

[ Upstream commit 1c3f5701bc0ff5cbe56bdae76157047d47051d44 ]

The dailink_master label was placed on the codec sub-node instead of
the CPU sub-node, configuring the codec as I2S bitclock/frame master
with SAI2 as slave. On this board, BCLK and LRCLK are wired the other
way around: SAI2 must be bus master, with the codec as I2S slave.

Move dailink_master to the CPU sub-node so SAI2 drives BCLK and LRCLK,
fixing broken audio on the PHYTEC phyBOARD-Pollux-i.MX8MP board with
PEB-AV-10 Audio/Video expansion board. Also remove the spurious clocks
property from the codec sub-node, which had no effect in this topology.

Fixes: 7012f551081f ("arm64: dts: imx8mp pollux: add expansion board overlay")
Signed-off-by: Primoz Fiser <primoz.fiser@norik.com>
Reviewed-by: Chancel Liu <chancel.liu@gmail.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/freescale/imx8mp-phyboard-pollux-peb-av-10.dtsi | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-phyboard-pollux-peb-av-10.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-phyboard-pollux-peb-av-10.dtsi
index bb740f845855a..8957b24a7ad2e 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-phyboard-pollux-peb-av-10.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-phyboard-pollux-peb-av-10.dtsi
@@ -77,13 +77,12 @@ sound {
 			"MIC3R", "Microphone Jack",
 			"Microphone Jack", "Mic Bias";
 
-		simple-audio-card,cpu {
+		dailink_master: simple-audio-card,cpu {
 			sound-dai = <&sai2>;
 		};
 
-		dailink_master: simple-audio-card,codec {
+		simple-audio-card,codec {
 			sound-dai = <&codec>;
-			clocks = <&clk IMX8MP_CLK_SAI2>;
 		};
 	};
 };
-- 
2.53.0



