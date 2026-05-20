Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DC528DC4;
	Wed, 20 May 2026 17:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298453; cv=none; b=sPlrcEgJ6Y9P4268LzozjcggDITqDZR9EMaAqlY0TehFDEWkPuNZmH/YZHp47diz4LFxoWga47Jaj0UI5oxn6k3b0+LktlS3IcM8rFzu68TntxfvBwWjmQDLr3Vthkd38fmSqlcpamqPTnj5Z9U0IE+U4aQMf9uQwEcTZH6bezU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298453; c=relaxed/simple;
	bh=yhUFuP8Q3u6+8PpmCPqL4lEX0pz267Ed6Vu4euhoTEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hro1uSKn3AwAtruW/hSbiMCQt5upDHkw+Vfii7hp+YDWXJ8EahYgjMy+ESCFWO1LDn7PEiKNhR6qOgetmMGtN4qhsAwnoh2aMgfevUb4uGkuj63z3vXAV6IKirQ6jsb4KX+jOGqMGeHQwxJ2sM9xcJ0GoAXvwxHLbcYrBmqtxqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tksvgrh7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tksvgrh7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AB31F000E9;
	Wed, 20 May 2026 17:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298452;
	bh=kSvMMRelc76AtPOMT1NvpVJyoUPLU14qlhZmpXsBal8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tksvgrh7GTM977L1OdTSwgqPSTbW4GbdjrlF1Kob6ccbGvks9DwQEnPKi/imiwMWY
	 eJTD1BejJ7AOVEhSRde9twQkb/wwS8Lxpxgy5kTJiokfTkC3g6Cxi0KglDSgl9FfNF
	 BTyfk76J2Si4Cbm7hoTSc8wXKrP3X3P9bqXXSSsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nora Schiffer <nora.schiffer@ew.tq-group.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 416/957] arm64: dts: freescale: imx8mp-tqma8mpql-mba8mp-ras314: fix UART1 RTS/CTS muxing
Date: Wed, 20 May 2026 18:14:59 +0200
Message-ID: <20260520162143.544700096@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nora Schiffer <nora.schiffer@ew.tq-group.com>

[ Upstream commit b8d785a9f360abcd6a6f8f10a2adf222f8494d66 ]

UART1 operates in DCE mode, but the RTS/CTS pins were incorrectly
configured using the DTE pinmux setting.

Correct the pinmux to match DCE mode. Switching the RTS and CTS signals
is fine for this board, as UART1 is routed to a pin header. Existing
functionality is unaffected, as RTS/CTS could never have worked with
the incorrect pinmux.

Fixes: ddabb3ce3f90 ("arm64: dts: freescale: add TQMa8MPQL on MBa8MP-RAS314")
Signed-off-by: Nora Schiffer <nora.schiffer@ew.tq-group.com>
Reviewed-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/freescale/imx8mp-tqma8mpql-mba8mp-ras314.dts     | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mp-ras314.dts b/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mp-ras314.dts
index a122f2ed5f531..06c865c3a8cf8 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mp-ras314.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-tqma8mpql-mba8mp-ras314.dts
@@ -833,8 +833,8 @@ pinctrl_tlv320aic3x04: tlv320aic3x04grp {
 	pinctrl_uart1: uart1grp {
 		fsl,pins = <MX8MP_IOMUXC_SAI2_RXFS__UART1_DCE_TX	0x14>,
 			   <MX8MP_IOMUXC_SAI2_RXC__UART1_DCE_RX		0x14>,
-			   <MX8MP_IOMUXC_SAI2_RXD0__UART1_DTE_CTS	0x14>,
-			   <MX8MP_IOMUXC_SAI2_TXFS__UART1_DTE_RTS	0x14>;
+			   <MX8MP_IOMUXC_SAI2_RXD0__UART1_DCE_RTS	0x14>,
+			   <MX8MP_IOMUXC_SAI2_TXFS__UART1_DCE_CTS	0x14>;
 	};
 
 	pinctrl_uart1_gpio: uart1gpiogrp {
-- 
2.53.0



