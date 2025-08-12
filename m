Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D778B2FD1D1;
	Tue, 12 Aug 2025 17:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020376; cv=none; b=RLLFxYZ2cIRq4BsZy946mcFk9/x8nau6dZCdjkTV9SfDlOAR0zHT37OhTDLoeQ44OAEqqiJ7hVRElBKu1oNUQXLQChcXyig+twPVmXsJ6msTpG+X0DWq1KcaS6TP6gWxCg2TuqCdZ8vq2Jx0zkA0PAiZ3nMtKtbOIySvmgxyLiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020376; c=relaxed/simple;
	bh=9ow/K/v1D3qmSDHmxI+cBWPag5+JoJloppZ/cyZpz3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdFAY8WxR33x3JpCwgHgxypA0da/6glXzi98EpMOhXOVx6BoIXSpaDgZgA5LthbFK8ORgBYqQUudINkyZepePolWgtaUT3Sg62Hfd4d6flBCXaBQKt3rOStXUyAtMo+fodOByDX9DbqsjxraZnPNTr2/z+Z8aLoTPgwr0lq8+NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nKffyath; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nKffyath"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F951C4CEF0;
	Tue, 12 Aug 2025 17:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020376;
	bh=9ow/K/v1D3qmSDHmxI+cBWPag5+JoJloppZ/cyZpz3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nKffyatho4Oxughprn4zIrfjlkFYnKBZ06+ayYsDp/SSzglgd7tbgug2YwDqpQGUd
	 8wfjTRqDICOPvvnQjprl9mUXe2a5WsFe4wpDYeplEfCjNAyno0h6nG9B5BhRJ6qKQb
	 /uQV2Cks3NOzigD6UXk6MejxbPEYMehIkdYvMoqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/253] can: dev: can_restart(): move debug message and stats after successful restart
Date: Tue, 12 Aug 2025 19:26:48 +0200
Message-ID: <20250812172949.572339095@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit f0e0c809c0be05fe865b9ac128ef3ee35c276021 ]

Move the debug message "restarted" and the CAN restart stats_after_
the successful restart of the CAN device, because the restart may
fail.

While there update the error message from printing the error number to
printing symbolic error names.

Link: https://lore.kernel.org/all/20231005-can-dev-fix-can-restart-v2-4-91b5c1fd922c@pengutronix.de
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
[mkl: mention stats in subject and description, too]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: c1f3f9797c1f ("can: netlink: can_changelink(): fix NULL pointer deref of struct can_priv::do_set_mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/dev/dev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/dev/dev.c b/drivers/net/can/dev/dev.c
index 42c486d1fd10b..78e3ea180d767 100644
--- a/drivers/net/can/dev/dev.c
+++ b/drivers/net/can/dev/dev.c
@@ -147,15 +147,15 @@ static void can_restart(struct net_device *dev)
 		netif_rx(skb);
 	}
 
-	netdev_dbg(dev, "restarted\n");
-	priv->can_stats.restarts++;
-
 	/* Now restart the device */
 	netif_carrier_on(dev);
 	err = priv->do_set_mode(dev, CAN_MODE_START);
 	if (err) {
-		netdev_err(dev, "Error %d during restart", err);
+		netdev_err(dev, "Restart failed, error %pe\n", ERR_PTR(err));
 		netif_carrier_off(dev);
+	} else {
+		netdev_dbg(dev, "Restarted\n");
+		priv->can_stats.restarts++;
 	}
 }
 
-- 
2.39.5



