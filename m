Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A2442CB1E;
	Tue, 21 Jul 2026 19:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661626; cv=none; b=CC+EnEpgx3v1HWNt15S7ffbR/yz0LEeg61ahwmbtPMEcZQCI1jTJo9/iweahkbhKaazqc16NizDaI9UsBMR8ZV9ar7g+/CYXjdNSkvxFQRm+Y36HeLxR+8TbabeB+xt1Ocz13OIJ9eKP8yWGrwAplkaobR1Iy1NXLhUqxYnS0gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661626; c=relaxed/simple;
	bh=up1jZ5vTXbZokgV4qsRYz9hJNtvKCkOEeyO0o6BK49Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SkY15foKI344W6wj7G8FuEixTZahygFmOwERPtO9dQLZqKkaX4hj+4ZJzMOj9sTnWkxEDQ3PtUx65qhNG7cAtuxNKOzc5eTRg41xMlDPQcA94ZYC3MQ/Vf3eSuvr05H7SLem5XefHY4DtlxQR/IzAOE+7jQJ4moH9o2gLlEsm7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XusW0hQ/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XusW0hQ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5542B1F000E9;
	Tue, 21 Jul 2026 19:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661624;
	bh=Fo2N5ISErxJh1pHrjM43J80hExecq9dnwR6r2rKJFZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XusW0hQ/kn1pD6NOJquoUPcJLYAMO/ibXP5THxNl3Me4DFKcZYpO7Vp2sWRM+yMTw
	 w1L9kVL26oLB8vzy/QE+4B1+JECUltRCCfoBK6Ve9Ii2thu4vqcswGJzmn/z8wtUAS
	 grfEMmglxhhDonAt7JUe6flk35P/G/2JWCDgZBe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0094/1276] arm64: dts: imx8x-colibri: Correct SODIMM PAD settings
Date: Tue, 21 Jul 2026 17:08:57 +0200
Message-ID: <20260721152448.199226981@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index edba5b58241465..0151cb687134e8 100644
--- a/arch/arm64/boot/dts/freescale/imx8x-colibri.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8x-colibri.dtsi
@@ -577,12 +577,12 @@ pinctrl_adc0: adc0grp {
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



