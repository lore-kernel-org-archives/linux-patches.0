Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39258443E2F;
	Tue, 21 Jul 2026 17:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655712; cv=none; b=go2YeYhCgsPEW3iyGnXrM4g8VExEB0evzXx1zx/Ye54hLaAmwBVESe53Dp4gThqZM0ElIdQd/ttpIAPOfQJWQOZ8Iq2++cYUFE3h0j5s3iXJl/rTOsdZm8I5sqsMCtx4j8UulOZX38zSN9ZJXyO9Jp7/c89wVSaiiLRIRkaijQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655712; c=relaxed/simple;
	bh=Z8WzuVGwYaLlO7Qt9K5lY3KtWXPAgVLcEbA2uZU2zhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P76P+H5S3fLzZcJSA++P8mV125UUZsi/ME8WCJvF3IzgPBuh5/7MdOdw2CGYPyQWtWv7Z9hfFVQj10xPhZlfaRaDFc5KGAEp+zTQbvMA1N+OJIbQ64UQHF12Pz3r31ewpEVdtKDe5aROd/BhquSstb9Zk3MjbA3gibEi8B6Rv5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TwgZ+v4/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TwgZ+v4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 613771F000E9;
	Tue, 21 Jul 2026 17:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655709;
	bh=ejzKGhHRfO+aQYPl6l6dwG69Y12Jawrauuc53e87b/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TwgZ+v4/oHTdHngdHh9+5MxYZ1G9Rw9Gye5OGtxDe4XMh1quc04Z6aUqAhzyF94vC
	 tf3JBR0C3j0j3Mjvv3v5TBo5TQzk0EjZwAjygTFUatp6I70GxAXvU5Mcyn6UrQbL25
	 d09a4WYCTsL2iDboEdF949VjiWPFIcvip0fUQo9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0113/1611] arm64: dts: imx8x-colibri: Correct SODIMM PAD settings
Date: Tue, 21 Jul 2026 17:03:49 +0200
Message-ID: <20260721152517.395426285@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 8e9e841cc82813..f0f04599106bbd 100644
--- a/arch/arm64/boot/dts/freescale/imx8x-colibri.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8x-colibri.dtsi
@@ -604,12 +604,12 @@ pinctrl_adc0: adc0grp {
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



