Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC438245010;
	Tue, 30 Sep 2025 15:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245986; cv=none; b=OStIDVPqzAhx6Q5B2o5rHY3cF7w6DFVBCNLvsmNxeXL1e57dBvBdok3vjgd5VEU0mm4smK9U7csnnx2p2NkBEZpUXjatgOXjjWjnxcM4+CV8HvtYtU7rGmWqaUIzyHbWX5h9cU3/Ot7Ajk2iF+C640anNAYE3LCYKBcoEDQK+7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245986; c=relaxed/simple;
	bh=iAFis5c6jRyjJGcFIsVxOxMPFAKIfFLkIqT8KuPIz94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HlrNxct/tqEmvjxuT7kQe8gnqsHu+4p/A0gZyrfmi1YcRdzlD58n6eWVP05zshUqSwwELfGIG4H4a2x3EEv5Ymp5/rXZTvpM4uBiA8+UrPAzoMB5AuNWSYOeUvM+RC0yh4gtd9nPVdSWr8goI+m4PGrT3CwYUBdKK8BZWykSZSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OFVuCR74; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OFVuCR74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380E1C4CEF0;
	Tue, 30 Sep 2025 15:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245986;
	bh=iAFis5c6jRyjJGcFIsVxOxMPFAKIfFLkIqT8KuPIz94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OFVuCR740/OBE7aS/KFfS1GzGIvCkftT1Vc8REqGUqM3Lbk8BoUdlouMzYQIT7fSf
	 ZNVNkED5QTIMHU6Afd4I3lUpyKNeK2vpJfpHfiGjn5Gv+WLMo5xg6L0wajkKmT+C5W
	 peGJwB+NnUKJQQkGohsM0dHnqK+2JH77mGNjfVbc=
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
Subject: [PATCH 6.12 18/89] net: fec: rename struct fec_devinfo fec_imx6x_info -> fec_imx6sx_info
Date: Tue, 30 Sep 2025 16:47:32 +0200
Message-ID: <20250930143822.630566918@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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
index 0bd814251d56e..d144494f97e91 100644
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



