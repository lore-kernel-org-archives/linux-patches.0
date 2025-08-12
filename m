Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903BD2F5E;
	Tue, 12 Aug 2025 18:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022404; cv=none; b=bqexPuE4xgbbLF0hTalqYDaH02wk3JhSEc3tPuZ9autbisMgeNe/etpqm4MgVAFa2/Wi2Sd6eeKFsDghAiOrN+TNizZhlNtXrn5UMWYsIdqp9anjvnqAA+S1NQ1gcS963f9J/nQBfXiAT0V1Him7wby2/QAe69qw0AEf6PBK4/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022404; c=relaxed/simple;
	bh=CwIUVh10GfU4+R65VJ36y8RSj/8qXOMjQkT+igzzE8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YqWMUbo3j/u9VEE5ihHIRevBP3uHxabUlqnMjafP0JOraCbri1r5OX1KmpizTWXHV3WiMdKDNM0ESvTKCAZ0gWVRkJghFnPEsuyj0GMnBQo0FLlit+UZDK04eFbT+dUeSrJVrDK0bkXG4B0KGTbeTYVqih7BkiNFH86DAg4mpSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jI/2OuNM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jI/2OuNM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E59CC4CEF1;
	Tue, 12 Aug 2025 18:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022404;
	bh=CwIUVh10GfU4+R65VJ36y8RSj/8qXOMjQkT+igzzE8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jI/2OuNMwuhsJXlNP2y/5/sJTINfi5zGj3cEko2P523SdbmvRrXF6D/hqdDWhTjKC
	 ScdhUUzEqwEpjzVnXFE79jG0fwZyXAvmRXWs8bq6EjppPPxY3uCQlk7Anei1eafdjR
	 fLScFrlmsgcaDk/lCHq45+JZcNKXd8XnHafphgzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Jimmy Assarsson <extja@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 138/369] can: kvaser_usb: Assign netdev.dev_port based on device channel index
Date: Tue, 12 Aug 2025 19:27:15 +0200
Message-ID: <20250812173019.968185313@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jimmy Assarsson <extja@kvaser.com>

[ Upstream commit c151b06a087a61c7a1790b75ee2f1d6edb6a8a45 ]

Assign netdev.dev_port based on the device channel index, to indicate the
port number of the network device.
While this driver already uses netdev.dev_id for that purpose, dev_port is
more appropriate. However, retain dev_id to avoid potential regressions.

Fixes: 3e66d0138c05 ("can: populate netdev::dev_id for udev discrimination")
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://patch.msgid.link/20250725123452.41-4-extja@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index 7d12776ab63e..8bd7e800af8f 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -851,6 +851,7 @@ static int kvaser_usb_init_one(struct kvaser_usb *dev, int channel)
 	netdev->ethtool_ops = &kvaser_usb_ethtool_ops;
 	SET_NETDEV_DEV(netdev, &dev->intf->dev);
 	netdev->dev_id = channel;
+	netdev->dev_port = channel;
 
 	dev->nets[channel] = priv;
 
-- 
2.39.5



