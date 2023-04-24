Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A377C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:24:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63002C4339B;
	Mon, 24 Apr 2023 13:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342687;
	bh=HoYateV9CPjqYQA3fMmSc2t6e99pRonY5DvM+1OkD3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YM6lYq0HUFR8YJOsXpxJE4GHmpZCblKFgcHeDWFp1PvBT3dWhEjBE7OV42Ya4Qj/X
	 fD+9734d2aQ3bwvTs/pimweo0NADU05o/yXiZZ3dULiT2G7lw2HOdaz4xyUHLiblA1
	 Sl1widJQuKLwrtXgH3FG6AbgZj2GCz1m0HIVA/BI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Marco Felsch <m.felsch@pengutronix.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 08/98] arm64: dts: imx8mm-evk: correct pmic clock source
Date: Mon, 24 Apr 2023 15:16:31 +0200
Message-Id: <20230424131134.164246664@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 85af7ffd24da38e416a14bd6bf207154d94faa83 ]

The osc_32k supports #clock-cells as 0, using an id is wrong, drop it.

Fixes: a6a355ede574 ("arm64: dts: imx8mm-evk: Add 32.768 kHz clock to PMIC")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-evk.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-evk.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-evk.dtsi
index 7d6317d95b131..1dd0617477fdf 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-evk.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-evk.dtsi
@@ -193,7 +193,7 @@
 		rohm,reset-snvs-powered;
 
 		#clock-cells = <0>;
-		clocks = <&osc_32k 0>;
+		clocks = <&osc_32k>;
 		clock-output-names = "clk-32k-out";
 
 		regulators {
-- 
2.39.2



