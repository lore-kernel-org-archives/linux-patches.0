Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C1628EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:53:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C339C43445;
	Mon, 30 Jan 2023 13:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675086836;
	bh=jGrvf7qXlmMHHk9CHaKkxT+r9d5C3D9hU5Ky3E9h0YM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jjY48C/yqoxArKU0psIuaPs/iH3GtqxKlLrPUTOS9pKEVoJHx5KH78EQhcsx65yvV
	 ZSsieQE0KwEUtkasAdl5w+6TPhdvmV6TH3Wdeqp9mG5KmR+1kvTEgrkAtyy6DDSyMZ
	 p2l5iIPYn1DPuItDxeB2DBR4FlTnUxkxk4BJZxWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/313] arm64: dts: verdin-imx8mm: fix dev board audio playback
Date: Mon, 30 Jan 2023 14:47:29 +0100
Message-Id: <20230130134337.321976070@linuxfoundation.org>
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

[ Upstream commit 6c620a30515c494b5eeb3dc0e40d3220ea04c53b ]

Set optional `simple-audio-card,mclk-fs` parameter to ensure a proper
clock to the nau8822 audio codec. Without this change with an audio
stream rate of 44.1 kHz the playback is faster.
Set the MCLK at the right frequency, codec can properly use it to
generate 44.1 kHz I2S-FS.

Fixes: 6a57f224f734 ("arm64: dts: freescale: add initial support for verdin imx8m mini")
Signed-off-by: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-verdin-dev.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-verdin-dev.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-verdin-dev.dtsi
index 73cc3fafa018..b2bcd2282170 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-verdin-dev.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-verdin-dev.dtsi
@@ -11,6 +11,7 @@ sound_card: sound-card {
 		simple-audio-card,bitclock-master = <&dailink_master>;
 		simple-audio-card,format = "i2s";
 		simple-audio-card,frame-master = <&dailink_master>;
+		simple-audio-card,mclk-fs = <256>;
 		simple-audio-card,name = "imx8mm-nau8822";
 		simple-audio-card,routing =
 			"Headphones", "LHP",
-- 
2.39.0



