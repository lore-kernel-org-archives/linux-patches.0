Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1645A2F8BE7;
	Tue, 12 Aug 2025 17:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021336; cv=none; b=XLnespp0+fn3zfE/3PtQQ/Cce0L8m5+qFdyK+FKle3HB6/+LWSZi9oTwmfn5W7vST8DvzaaMLRLauZ6n2TqwzN33RLj9S+10PQkh5YXYNofnPYUZ2sTVkOKAA5u1V2JeDHU70zrjDmedGDmCjhZjL5e1JO4+cpXR1GFv/LKJqwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021336; c=relaxed/simple;
	bh=JSj/qbkFQ3fCQhSihoMTfshuFoBKKMy9ryU3bPQ3QMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmHOqWZH7o8KiyZ0EJ1l/vcPePHo/azny6pFUC5cB2gTTdLzFaD/5C84OQ6SY2yhkL/Hir1IS8oRymLQt9W+oTqJRCQegRkwwcYU5V72rYd0iyyqtYE/poS9Dl4ALZwo5k0LX3TVRb3gIG+y2orIbDrrdcw3jI83t/Wa7xYtp14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wfaUTTBU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wfaUTTBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A29CC4CEF1;
	Tue, 12 Aug 2025 17:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021336;
	bh=JSj/qbkFQ3fCQhSihoMTfshuFoBKKMy9ryU3bPQ3QMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wfaUTTBUu1UlW6e40MUyaQ46mTfVP1sfSFyk3qYv0BjK8qh8+gz0J1oUCjjSLr/e7
	 8rsqVaboFDsegmSRJ09ECwxf9xS+YTaQ4ugLTUMwwHazVaFCW1qdyaKP7lMnmEb6wp
	 Cd0l9fFRfOAKW32Bs9v7bzPXK5nM0vNlVEg8pmsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Jimmy Assarsson <extja@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 097/262] can: kvaser_usb: Assign netdev.dev_port based on device channel index
Date: Tue, 12 Aug 2025 19:28:05 +0200
Message-ID: <20250812172957.219229066@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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
index 15f28b6fe758..022b5b79247c 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -856,6 +856,7 @@ static int kvaser_usb_init_one(struct kvaser_usb *dev, int channel)
 	}
 	SET_NETDEV_DEV(netdev, &dev->intf->dev);
 	netdev->dev_id = channel;
+	netdev->dev_port = channel;
 
 	dev->nets[channel] = priv;
 
-- 
2.39.5



