Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6DF569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0A8C433D2;
	Sun, 28 May 2023 19:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302447;
	bh=Mb7vC4HaS36Qt/3xSV8OVLEzv5520vqh75pTPeWKkpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/oWu7ZZXpv/FUDiRQkzEFAlq7a/pbpGC64Am7CfHwZr4yS0Ca04nrqgnv6YxrDIT
	 yTGSkf+kZ2Gf5+i7W4LDGhGEsshKleneJDkAV0WqBpCg52guHT0ceFAiqEMpUbbiNO
	 Sklwkh5Z89XsAWwETUQkYNvlQl0wM6qwTsCxtR3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Liu Ying <victor.liu@nxp.com>,
	Marek Vasut <marex@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 127/127] Revert "arm64: dts: imx8mp: Drop simple-bus from fsl,imx8mp-media-blk-ctrl"
Date: Sun, 28 May 2023 20:11:43 +0100
Message-Id: <20230528190840.351644456@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190836.161231414@linuxfoundation.org>
References: <20230528190836.161231414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit bd2573ee0f91c0e6d2bee8599110453e2909060e which is
commit 5a51e1f2b083423f75145c512ee284862ab33854 upstream.

Marc writes:
	can you please revert this patch, without the corresponding driver patch
	[1] it breaks probing of the device, as no one populates the sub-nodes.

	[1] 9cb6d1b39a8f ("soc: imx: imx8m-blk-ctrl: Scan subnodes and bind
	drivers to them")

Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
Link: https://lore.kernel.org/r/20230523-justly-situated-317e792f4c1b-mkl@pengutronix.de
Cc: Alexander Stein <alexander.stein@ew.tq-group.com>
Cc: Liu Ying <victor.liu@nxp.com>
Cc: Alexander Stein <alexander.stein@ew.tq-group.com>
Cc: Marek Vasut <marex@denx.de>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mp.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/imx8mp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
@@ -1151,7 +1151,7 @@
 
 			media_blk_ctrl: blk-ctrl@32ec0000 {
 				compatible = "fsl,imx8mp-media-blk-ctrl",
-					     "syscon";
+					     "simple-bus", "syscon";
 				reg = <0x32ec0000 0x10000>;
 				#address-cells = <1>;
 				#size-cells = <1>;


