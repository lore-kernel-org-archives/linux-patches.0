Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F584195C9;
	Tue, 21 Jul 2026 20:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665654; cv=none; b=RNuO9YVIvoFZ3zKqBH1fY03NPBDUjlaL1WTrySn0W0D8myRABAB9ZJD5FzAnlSoMq24Nn+J1mlBcV68R2jSimkb0pSubV2NEMtOCpEQgy6CmT0BZqRO0QS6mgmMUORvthxTIf2BPQ6dYqZgRvEpLhT3DRole1hj7XsfM4b5Fb1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665654; c=relaxed/simple;
	bh=cAdgMKyPinFJXZoilIVKrYUbHIDdpBZrUEI7mSOnou8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AsqlnelWGeFSnJAbCBiIoAk+w8ohJIe5ipbqq2tOTXwo1oNFpxmp9JTrao5fsOS36/r5bMDO/FoPnvr0imhgby9fgCSkBNPNpxaY1JnYBhMog9Qy9FJRdr2eMf0iFRYCjizAqGs+8IuQMCy7pBPzPqsSKUd7kCh+ZkmHLLUTRb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S2Vpia6Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S2Vpia6Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB39B1F000E9;
	Tue, 21 Jul 2026 20:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665652;
	bh=IPJDUkCao3rBXHy3I37yhuGyLV+RAg0bByUhT4xs2xQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S2Vpia6QJHCg7Bmx8o60M4TqkxnzDbPnzlw9IhfCrKSxc7IS5+Lk9NOfHfZYVSJRM
	 eZumG4Aq3pxNLl/2+aVmiQVgkUoQU+eaQZRMSOJMTQcKdI2P366S6GdsBagpxgIERH
	 2Ytw0j7WPAvr4J00dv0aFim9OhwJ2Zs2i57wSaHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0385/1266] arm64: dts: imx8x-colibri: Correct SODIMM PAD settings
Date: Tue, 21 Jul 2026 17:13:42 +0200
Message-ID: <20260721152450.440357520@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 0a03ee38a262cab0d9754e9947d565e089a9f7a5 ]

SION is BIT(30), not BIT(26). Correct it.

Fixes: 7ece3cbc8b1ef ("arm64: dts: colibri-imx8x: Add atmel pinctrl groups")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Reviewed-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8x-colibri.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8x-colibri.dtsi b/arch/arm64/boot/dts/freescale/imx8x-colibri.dtsi
index 49d105eb476919..b7986605119efb 100644
--- a/arch/arm64/boot/dts/freescale/imx8x-colibri.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8x-colibri.dtsi
@@ -383,12 +383,12 @@ pinctrl_adc0: adc0grp {
 	 */
 	pinctrl_atmel_adap: atmeladaptergrp {
 		fsl,pins = <IMX8QXP_UART1_RX_LSIO_GPIO0_IO22			0x21>,		/* SODIMM  30 */
-			   <IMX8QXP_UART1_TX_LSIO_GPIO0_IO21			0x4000021>;	/* SODIMM  28 */
+			   <IMX8QXP_UART1_TX_LSIO_GPIO0_IO21			0x40000021>;	/* SODIMM  28 */
 	};
 
 	/* Atmel MXT touchsceen + boards with built-in Capacitive Touch Connector */
 	pinctrl_atmel_conn: atmelconnectorgrp {
-		fsl,pins = <IMX8QXP_QSPI0B_DATA2_LSIO_GPIO3_IO20		0x4000021>,	/* SODIMM 107 */
+		fsl,pins = <IMX8QXP_QSPI0B_DATA2_LSIO_GPIO3_IO20		0x40000021>,	/* SODIMM 107 */
 			   <IMX8QXP_QSPI0B_SS1_B_LSIO_GPIO3_IO24		0x21>;		/* SODIMM 106 */
 	};
 
-- 
2.53.0



