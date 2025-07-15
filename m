Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66082E62BE;
	Tue, 15 Jul 2025 13:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585996; cv=none; b=uOKUO/qp9IGZPLz0bxZ2lv6gORa8AL1axcEpicZ10KRVeBUdp5h57gJzGIBi3XgssuNbJWcAS4vPE3T/3v+Agr0HQ252PoF6n+siW57CQBuFQRbFzhht6bWE4OAIVz+crnrtPkP0qEeTy+87Kl3aANKbXXIuzN29kZTIqakiqXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585996; c=relaxed/simple;
	bh=ADs/62x78aDnT030KrSdHDM2tHxNdM8SHgo9EulMx/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZukeBVZkBbfOs3U5yNTdZxZBn5d5IozR/GJ99hDg0i6/gSkErP0udpBljdSDb/DhW7d6iPnpAgYkSrU1bKgkHxZlxdacEuGsTzTIspIHSaU4C4dYghS1O04kFUPoqSrrXjMnKlwA7OnCL1nGrSHzRTzZaQXwv+EizChaiZcQMyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CH962KIX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CH962KIX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B13C4CEE3;
	Tue, 15 Jul 2025 13:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585996;
	bh=ADs/62x78aDnT030KrSdHDM2tHxNdM8SHgo9EulMx/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CH962KIX8zs0D4GxRA4j7DBYVVg10YFntlIZ/9kR/S/nrmZNcNovUFSvKqlDUSB6J
	 QEZjq5fc2BfMag9dcNci3OD7mZiuUR4kk0rg49MHQ2fEVBiabXvMaAG4Z4/82vOPB2
	 Fz3P+hmlbO5FvjfHH79f4fCqkhoAaCprfxcRq6Y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Sean Nyekjaer <sean@geanix.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 087/109] can: m_can: m_can_handle_lost_msg(): downgrade msg lost in rx message to debug level
Date: Tue, 15 Jul 2025 15:13:43 +0200
Message-ID: <20250715130802.364714554@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sean Nyekjaer <sean@geanix.com>

[ Upstream commit 58805e9cbc6f6a28f35d90e740956e983a0e036e ]

Downgrade the "msg lost in rx" message to debug level, to prevent
flooding the kernel log with error messages.

Fixes: e0d1f4816f2a ("can: m_can: add Bosch M_CAN controller support")
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Link: https://patch.msgid.link/20250711-mcan_ratelimit-v3-1-7413e8e21b84@geanix.com
[mkl: enhance commit message]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index ba7f7de25c852..e6a74d66f0d8c 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -606,7 +606,7 @@ static int m_can_handle_lost_msg(struct net_device *dev)
 	struct can_frame *frame;
 	u32 timestamp = 0;
 
-	netdev_err(dev, "msg lost in rxf0\n");
+	netdev_dbg(dev, "msg lost in rxf0\n");
 
 	stats->rx_errors++;
 	stats->rx_over_errors++;
-- 
2.39.5



