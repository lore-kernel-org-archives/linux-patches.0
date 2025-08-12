Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06AD2882CE;
	Tue, 12 Aug 2025 19:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025983; cv=none; b=mFnvxwVQLnHK4f3Y1TCDPwT89BTFTBcZv9jN0CZgsPVrzEvBRBk8ZYh8Ox51DcAii4Q52AP3dP4WvaZ6sZTEeGy3oFNWeWwSF6IcLbNyRYJqU6r0+pKZpkBXmjvDbouh5QAic5/NNBcf9cEx2yaWKqhZcwApsLIMjmqSN5lpQaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025983; c=relaxed/simple;
	bh=tcEDALz9zmKyXl5Lcrqp8mGC/bu4VgYZFXwzSn1A1fY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkktnyTrDbl1VYX03A6VO6xE8vwYWFuOhhzy6xnZ5R65pdLS2g+EGW5MrdGeMqY5U5eag0SwQh9WHleIv+sfj+fN3APRe5SBGLCbbiMa+XsecMdljF3O9lvQhorc1l0OPDgLVtOxBnIIPb70VM9kV8S5Gzl1gB6CV6E7iAm1w9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ajw7y0wl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ajw7y0wl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30CCFC4CEF0;
	Tue, 12 Aug 2025 19:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025983;
	bh=tcEDALz9zmKyXl5Lcrqp8mGC/bu4VgYZFXwzSn1A1fY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ajw7y0wlVX7RQN3+YjiVlO3EtJyx0af/QnbIodTinkjyUGz1tpx53pjj5pffKyCE3
	 Dy0KIm3ogcAuUYmOJNMTRFhumFt/ZpqXk+Ro6lSMlvFN15xDg72k83AsKZDLCP+eKL
	 pUHVm79b10vP3q4RG9f/IoT8i8xqIkIsUbf5B0Nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Jimmy Assarsson <extja@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 203/480] can: kvaser_usb: Assign netdev.dev_port based on device channel index
Date: Tue, 12 Aug 2025 19:46:51 +0200
Message-ID: <20250812174405.849493702@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index dcb0bcbe0565..f73ccbc3140a 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -852,6 +852,7 @@ static int kvaser_usb_init_one(struct kvaser_usb *dev, int channel)
 	netdev->ethtool_ops = &kvaser_usb_ethtool_ops;
 	SET_NETDEV_DEV(netdev, &dev->intf->dev);
 	netdev->dev_id = channel;
+	netdev->dev_port = channel;
 
 	dev->nets[channel] = priv;
 
-- 
2.39.5



