Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015406;
	b=BbaEBA/cNRFmcfD2e50LzKD/pzqVQ5+oP18xFT0sYorNSLJQmELwlpPCHfdRTf+c+IpK
	 pn8/4P4odaBDFUjkfKjYsBa1ev3cveE5rHopituhiw1K06jhVpIxTiM6IIRRWi5RJJ9BZ
	 Mwbin0sPlzAOIjo/H/kVpcZfnlfIfvhyjv7RA+Ql36OtHqxIxlAtlBeYVijU89Uz8WbrQ
	 kjoBu+wuCnBeUJOvdGkADxkdxIWl289Ruh+b2IaWdG61mTmzXXWjahkCxbLqW75z9I9B4
	 afuNPvlM86reUYl3SsAKosDETOrWoPDG9HyT5ugHZ/V9oq+n5QeEYPryrhP2OT9s0fQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015406;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Po0SvMNFN5Sb7j0UTtdZDbQigbDabSrxsOCZJVZ8C6s=;
	b=ehAW2j5BOES3kQTiPP2/PEXoZ28EhPj3G2UC1fWNEL1zKBIJ7DL1+kVjoMCFk913ywXR
	 ndDGPlEu+o4T7XQgdyMSdmE3Ths1jBWbdHgcf06tf0FfRdhcG/s+Kjpi4Fcz81XdNW1Hz
	 QN8j7XOgTP8/qE6xPW1p7rcc7yyPOYn8aLc6vLUUo8ezzJEcLlrMtu6RNNp+jspwE9/gl
	 Uzn3qkSh7+jo4i6N9jq/Hd8lPypoUhw74TExXHiK8YxMP6JOlBY/b8V83SJZtIo7Q8Q0K
	 Nn9ICdcnVoGDc1M85Jiqwq+eJ87TXZk6gwYx00uU1szfjr95XWL6kGc7CbdpCqFLB5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R1YItIz5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9254B606A32F;
	Wed, 18 Nov 2026 15:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R1YItIz5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33ED1F000C4;
	Wed, 18 Nov 2026 15:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015406;
	bh=Po0SvMNFN5Sb7j0UTtdZDbQigbDabSrxsOCZJVZ8C6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R1YItIz5uWqp/ddLoIpXYeUuT5iS4aTrk0QGZpjOiLK8jq77LxiKCTHV5w/Tz2QEA
	 0nNnIBZDz4EfGMcHOw/CSECuuXa4/JuXlw5vdJQNoKgEOW+t/6OUK2k2IwF2Z1MCsB
	 Syc1tJt7OT76CBWE81yx4+rDGwh8BQhH/I2+EN7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0121/2651] arm64: dts: imx95-15x15-frdm: fix duplicated can-phy node names
Date: Wed, 18 Nov 2026 15:22:41 +0100
Message-ID: <20261118150252.226062249@linuxfoundation.org>
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

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit 47580f0648398f837aaa3019ba3b7437ed1dea1b ]

Both the flexcan2 and flexcan5 CAN transceiver PHY nodes use the same
node name "can-phy", which results in a node name collision. Distinguish
them by using unit-less unique names "can-phy0" and "can-phy1".

These two CAN PHYs share their silent pin, this shared GPIO can be
handled by GPIO shared proxy.

Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Fixes: 9bdfeed989b1 ("arm64: dts: freescale: imx95: Add support for i.MX95 15x15 FRDM board")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx95-15x15-frdm.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx95-15x15-frdm.dts b/arch/arm64/boot/dts/freescale/imx95-15x15-frdm.dts
index 0f43e3be70589..7ed9ff978432e 100644
--- a/arch/arm64/boot/dts/freescale/imx95-15x15-frdm.dts
+++ b/arch/arm64/boot/dts/freescale/imx95-15x15-frdm.dts
@@ -56,7 +56,7 @@ dmic: dmic {
 		num-channels = <2>;
 	};
 
-	flexcan2_phy: can-phy {
+	flexcan2_phy: can-phy0 {
 		compatible = "nxp,tja1051";
 		#phy-cells = <0>;
 		max-bitrate = <5000000>;
@@ -67,7 +67,7 @@ flexcan2_phy: can-phy {
 		silent-gpios = <&pcal6524 7 GPIO_ACTIVE_HIGH>;
 	};
 
-	flexcan5_phy: can-phy {
+	flexcan5_phy: can-phy1 {
 		compatible = "nxp,tja1051";
 		#phy-cells = <0>;
 		max-bitrate = <5000000>;
-- 
2.53.0



