Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5830428EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:55:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A26C433D2;
	Mon, 30 Jan 2023 13:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675086925;
	bh=LvMSBPai/U8bmO1UpRwsvsA3+jxjAdM6uJT5h9PaInU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hN1lJDHG51RdPoWkUCU3PC4BXvQqyEkJ93jPoIdfZhnFMmAHRORHingegtwFmiBNn
	 21lDXOCV30EO5lstnxPhuQeNyZCWL28AUxLXpjKQlBsfiAfdIWViH6qOnMii4pKiYy
	 2/cdEqMPNuw3nga57N4zB//jEF++jRhgVx910bT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/313] arm64: dts: verdin-imx8mm: fix dahlia audio playback
Date: Mon, 30 Jan 2023 14:47:27 +0100
Message-Id: <20230130134337.236151157@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>

[ Upstream commit 0d1d030f00f3f3eea04017cbd50ffe44a2842ebc ]

Set optional `simple-audio-card,mclk-fs` parameter to ensure a proper
clock to the wm8904 audio codec. Without this change with an audio
stream rate of 44.1 kHz the playback is completely distorted.

Fixes: 6a57f224f734 ("arm64: dts: freescale: add initial support for verdin imx8m mini")
Signed-off-by: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-verdin-dahlia.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-verdin-dahlia.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-verdin-dahlia.dtsi
index c2a5c2f7b204..7c3f5c54f040 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-verdin-dahlia.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-verdin-dahlia.dtsi
@@ -9,6 +9,7 @@ sound_card: sound-card {
 		simple-audio-card,bitclock-master = <&dailink_master>;
 		simple-audio-card,format = "i2s";
 		simple-audio-card,frame-master = <&dailink_master>;
+		simple-audio-card,mclk-fs = <256>;
 		simple-audio-card,name = "imx8mm-wm8904";
 		simple-audio-card,routing =
 			"Headphone Jack", "HPOUTL",
-- 
2.39.0



