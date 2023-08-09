Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FCD613A
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:43:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6223C433C9;
	Wed,  9 Aug 2023 10:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691577833;
	bh=WkSDuAUcAY10Aq0D9LeDq4PdmfjDWJtUJDoLgh8B9/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EkWfQOIeoRUKF1SCZ5wBwrE79fkUiknjrx3Az7YSv63DOyFPvV9Kg9nh077Jq9aSr
	 zODYqePaX0Gk1AEymV7n585D+z87g/9NBbrRD1RaSZ+wIyTZdUk0kZlKd7U0oLl++6
	 W238T2zJc+oTcFZFJNdb3VvdWbih2Yv3aJfIZayw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 011/165] arm64: dts: freescale: Fix VPU G2 clock
Date: Wed,  9 Aug 2023 12:39:02 +0200
Message-ID: <20230809103643.139188965@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Benjamin Gaignard <benjamin.gaignard@collabora.com>

[ Upstream commit b27bfc5103c72f84859bd32731b6a09eafdeda05 ]

Set VPU G2 clock to 300MHz like described in documentation.
This fixes pixels error occurring with large resolution ( >= 2560x1600)
HEVC test stream when using the postprocessor to produce NV12.

Fixes: 4ac7e4a81272 ("arm64: dts: imx8mq: Enable both G1 and G2 VPU's with vpu-blk-ctrl")
Signed-off-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mq.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mq.dtsi b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
index 0492556a10dbc..345c70c6c697a 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
@@ -770,7 +770,7 @@
 									 <&clk IMX8MQ_SYS1_PLL_800M>,
 									 <&clk IMX8MQ_VPU_PLL>;
 						assigned-clock-rates = <600000000>,
-								       <600000000>,
+								       <300000000>,
 								       <800000000>,
 								       <0>;
 					};
-- 
2.40.1



