Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE26D1171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE4BC433C7;
	Mon, 21 Aug 2023 20:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648561;
	bh=IfaGbjKO/TlcVO0Lx+W+rPKRkL4X2MDdA2vUvtm2ygY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bFLn+MJo6sn2BcclpcQ+TPF5cP5u6rOFIzNkOKQIn8HbobF6iPxTmddnxvoKwWweL
	 rModA+TBXKD3tqrrfuGYYqTem/1YYyys5UdWr+uP86UNISYAjAUtPpq27Ariq2A+zS
	 17PJ0f0nLz0YRdpYtwEvdw9GO11Hj5LLCK/FC9ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Peng Fan <peng.fan@nxp.com>,
	Jacky Bai <ping.bai@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 190/234] arm64: dts: imx93: Fix anatop node size
Date: Mon, 21 Aug 2023 21:42:33 +0200
Message-ID: <20230821194137.232911188@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 78e869dd8b2ba19765ac9b05cdea3e432d1dc188 ]

Although the memory map of i.MX93 reference manual rev. 2 claims that
analog top has start address of 0x44480000 and end address of 0x4448ffff,
this overlaps with TMU memory area starting at 0x44482000, as stated in
section 73.6.1.
As PLL configuration registers start at addresses up to 0x44481400, as used
by clk-imx93, reduce the anatop size to 0x2000, so exclude the TMU area
but keep all PLL registers inside.

Fixes: ec8b5b5058ea ("arm64: dts: freescale: Add i.MX93 dtsi support")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx93.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx93.dtsi b/arch/arm64/boot/dts/freescale/imx93.dtsi
index e8d49660ac85b..c0f49fedaf9ea 100644
--- a/arch/arm64/boot/dts/freescale/imx93.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx93.dtsi
@@ -306,7 +306,7 @@
 
 			anatop: anatop@44480000 {
 				compatible = "fsl,imx93-anatop", "syscon";
-				reg = <0x44480000 0x10000>;
+				reg = <0x44480000 0x2000>;
 			};
 
 			adc1: adc@44530000 {
-- 
2.40.1



