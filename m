Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0173212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:02:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1FBC433D2;
	Tue,  7 Feb 2023 13:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675774953;
	bh=VvzWuZ6lOQSA6XIOVbU1yB1uevXoo+XQGbn7rXzbx6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pi49qr+wy0MYkmOKZpE4i2aUOG6/ShUiCj8im5RpnpUU46ajsZKibW0MFZNGiRFZt
	 4RyOxK1V6b6FvNxgO8yX8PM0oo29h8sUtwF8dITA19TO2BRb3gQqSMeLjzxlN6bcwe
	 6E5P8l6jdUGPeysPCSHiy6eB44oww/T0MG7+lCBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 081/208] can: mcp251xfd: mcp251xfd_ring_set_ringparam(): assign missing tx_obj_num_coalesce_irq
Date: Tue,  7 Feb 2023 13:55:35 +0100
Message-Id: <20230207125637.999605370@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 1613fff7a32e1d9e2ac09db73feba0e71a188445 ]

If the a new ring layout is set, the max coalesced frames for RX and
TX are re-calculated, too. Add the missing assignment of the newly
calculated TX max coalesced frames.

Fixes: 656fc12ddaf8 ("can: mcp251xfd: add TX IRQ coalescing ethtool support")
Link: https://lore.kernel.org/all/20230130154334.1578518-1-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-ethtool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ethtool.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ethtool.c
index 3585f02575df..57eeb066a945 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ethtool.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ethtool.c
@@ -48,6 +48,7 @@ mcp251xfd_ring_set_ringparam(struct net_device *ndev,
 	priv->rx_obj_num = layout.cur_rx;
 	priv->rx_obj_num_coalesce_irq = layout.rx_coalesce;
 	priv->tx->obj_num = layout.cur_tx;
+	priv->tx_obj_num_coalesce_irq = layout.tx_coalesce;
 
 	return 0;
 }
-- 
2.39.0



