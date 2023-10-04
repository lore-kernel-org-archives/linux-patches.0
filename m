Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551181DA39
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/D4oK0L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF199C433C7;
	Wed,  4 Oct 2023 18:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444256;
	bh=0d/6Zln3n5ov0VC2+PiqklSJjNgpP4mCClwFRQuvRpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H/D4oK0LBGK9DdLZ3hiV4diL2HOxNnwYgCS/0gEgTCqGVVPAxHwR13L8dzet/AdD+
	 YDgILVov0Uz6vfGOfSgtZhoDPdM27XeREa0/kYcPrO651o0JE9wW5jePC2X6/bCidY
	 VoOU+fKHvcbCKjf07dM0hWAnXhuEqujmnH1xlzwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 147/321] arm64: dts: imx8mp-beacon-kit: Fix audio_pll2 clock
Date: Wed,  4 Oct 2023 19:54:52 +0200
Message-ID: <20231004175236.057756159@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 161af16c18f3e10d81870328928e5fff3a7d47bb ]

Commit 16c984524862 ("arm64: dts: imx8mp: don't initialize audio clocks
from CCM node") removed the Audio clocks from the main clock node, because
the intent is to force people to setup the audio PLL clocks per board
instead of having a common set of rates since not all boards may use
the various audio PLL clocks for audio devices.

This resulted in an incorrect clock rate when attempting to playback
audio, since the AUDIO_PLL2 wasn't set any longer. Fix this by
setting the AUDIO_PLL2 rate inside the SAI3 node since it's the SAI3
that needs it.

Fixes: 16c984524862 ("arm64: dts: imx8mp: don't initialize audio clocks from CCM node")
Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-beacon-kit.dts | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-beacon-kit.dts b/arch/arm64/boot/dts/freescale/imx8mp-beacon-kit.dts
index 06e91297fb163..acd265d8b58ed 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-beacon-kit.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-beacon-kit.dts
@@ -381,9 +381,10 @@
 &sai3 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_sai3>;
-	assigned-clocks = <&clk IMX8MP_CLK_SAI3>;
+	assigned-clocks = <&clk IMX8MP_CLK_SAI3>,
+			  <&clk IMX8MP_AUDIO_PLL2> ;
 	assigned-clock-parents = <&clk IMX8MP_AUDIO_PLL2_OUT>;
-	assigned-clock-rates = <12288000>;
+	assigned-clock-rates = <12288000>, <361267200>;
 	fsl,sai-mclk-direction-output;
 	status = "okay";
 };
-- 
2.40.1



