Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD6E306B05;
	Tue, 30 Sep 2025 15:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244502; cv=none; b=Hsl+LMKKGqtS7nyv50Eeb6ET2tR9jTauBrVLLUAJ1C4NXDzeFmoJWog60/28Llj97I8QUENXDqMsUbfE79ahNbIKVUPNZD0f6YOr/AOki0zjxU05UHAGRw29qrC8H4dVu1/BOe0Q/Y650O3k28KEwY/jrohR7inxL9ApZjB4zTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244502; c=relaxed/simple;
	bh=QroJdXtfoL+43pMrTXFhuDDnmYprr7GOzywck0D6Wx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3b9rNRbcKL3ShtdjrRHQCKYY8eJJy3p+648AAC2mBd3u97lCyMNMwFUMxid3/Y2kB/joJYUVM3OY7rKtR5X9fXe99tTTVvtvSieaXO54Q1QMwQyOmXD99mpylC0fSZl9ylbJB6k2uU25ONPi7myMqOrzG8WGu5IbziHgbDs4ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0B3dSB5F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0B3dSB5F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC43C116B1;
	Tue, 30 Sep 2025 15:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244501;
	bh=QroJdXtfoL+43pMrTXFhuDDnmYprr7GOzywck0D6Wx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0B3dSB5FttExXudbpoX4vZLGbeGxrY/oVxZ4y5wQK/lULOOKLdCH046axU3z6qbM3
	 rIL56gGXo7kkV0vder4oIEu+ixaz9TEtIzglgzBTgdVfYGRFm358oiC1qDmqbLLAtn
	 xyrKXdyMZcQeddtkZay+k19+mYHuVl7rb0OZaREQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 019/143] net: fec: rename struct fec_devinfo fec_imx6x_info -> fec_imx6sx_info
Date: Tue, 30 Sep 2025 16:45:43 +0200
Message-ID: <20250930143832.011185029@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 4e8594a88656fa86a9d2b1e72770432470b6dc0c ]

In da722186f654 ("net: fec: set GPR bit on suspend by DT
configuration.") the platform_device_id fec_devtype::driver_data was
converted from holding the quirks to a pointing to struct fec_devinfo.

The struct fec_devinfo holding the information for the i.MX6SX was
named fec_imx6x_info.

Rename fec_imx6x_info to fec_imx6sx_info to align with the SoC's name.

Reviewed-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Link: https://patch.msgid.link/20250618-fec-cleanups-v4-5-c16f9a1af124@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 5f15f42070c53..e8b37dfd5cc1d 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -131,7 +131,7 @@ static const struct fec_devinfo fec_mvf600_info = {
 		  FEC_QUIRK_HAS_MDIO_C45,
 };
 
-static const struct fec_devinfo fec_imx6x_info = {
+static const struct fec_devinfo fec_imx6sx_info = {
 	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
 		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
 		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_HAS_AVB |
@@ -196,7 +196,7 @@ static const struct of_device_id fec_dt_ids[] = {
 	{ .compatible = "fsl,imx28-fec", .data = &fec_imx28_info, },
 	{ .compatible = "fsl,imx6q-fec", .data = &fec_imx6q_info, },
 	{ .compatible = "fsl,mvf600-fec", .data = &fec_mvf600_info, },
-	{ .compatible = "fsl,imx6sx-fec", .data = &fec_imx6x_info, },
+	{ .compatible = "fsl,imx6sx-fec", .data = &fec_imx6sx_info, },
 	{ .compatible = "fsl,imx6ul-fec", .data = &fec_imx6ul_info, },
 	{ .compatible = "fsl,imx8mq-fec", .data = &fec_imx8mq_info, },
 	{ .compatible = "fsl,imx8qm-fec", .data = &fec_imx8qm_info, },
-- 
2.51.0



