Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99494158A13;
	Tue, 23 Jul 2024 18:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759635; cv=none; b=oeg7pD7k6OpZMl5b7XcoxZ3P7tApVO7l1tcIXj59QX1cte0G2V5bZtV0/azk7J4hlVKX5SjFCSk9pgaQggwRvuSU2eMXhfkPhjI2eCDqjO6KPOY+8hnm4AFiFzgDic72jEeql5p54gTUcRzQUbeyWQJGj7mAJJVceI/AyRqoPHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759635; c=relaxed/simple;
	bh=ZYFpaCYd7/pocIJd8kzgQXHmhL/JIDnO8ytdvhRItw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJdL+tKqfnXg+E9Ba1kSyr5I2AGFlikoN88+zzrrOMmC1n/P959E7SypA98J4rkoMOeXAEf2UV6VP9yyjToInNGTYxtJPi0VQ2MUQXA6kgI2ZzyZOqCmkYqc2x6zXlVoFwV3UJg82u/rdAUtAKsMVsDLD4PSbjDGHAUolXstMKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FuvBGbvX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FuvBGbvX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE99DC4AF09;
	Tue, 23 Jul 2024 18:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759635;
	bh=ZYFpaCYd7/pocIJd8kzgQXHmhL/JIDnO8ytdvhRItw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FuvBGbvXNfX+KDRdQn2y4FmNh/ZK687+17rU+B+n45Y7V+IxVG3pkse4JCJg6SOlx
	 mFUBonGW4buBJUxTbEtejCzCt06l2ruHAUSQ0ICMdjbtu2cQH4sfv7MBUoUhWJ0MBZ
	 nLNlxDv+0+nwXPtEq1g+OHts1CqEmRRWbh3kb34c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/129] can: kvaser_usb: fix return value for hif_usb_send_regout
Date: Tue, 23 Jul 2024 20:23:45 +0200
Message-ID: <20240723180407.758172582@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 0d34d8163fd87978a6abd792e2d8ad849f4c3d57 ]

As the potential failure of usb_submit_urb(), it should be better to
return the err variable to catch the error.

Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Link: https://lore.kernel.org/all/20240521041020.1519416-1-nichen@iscas.ac.cn
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index 387edc8f89bfb..15f28b6fe758e 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -292,7 +292,7 @@ int kvaser_usb_send_cmd_async(struct kvaser_usb_net_priv *priv, void *cmd,
 	}
 	usb_free_urb(urb);
 
-	return 0;
+	return err;
 }
 
 int kvaser_usb_can_rx_over_error(struct net_device *netdev)
-- 
2.43.0



