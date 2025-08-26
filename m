Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427CA341672;
	Tue, 26 Aug 2025 13:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215847; cv=none; b=WQGCKo9W66SgE9XbmHrVwP9mN13kt2qxi/N8bFOR5sZ2k2nihqvuLJYT/pVS/HX2fC1D/vfSULKUzuBRvKZvaFCVHesf35EaOVQz5WfjMMTTwQrnXU0oHHd8ylQcTCASJOfrNLYSHIxwEl9TLlQi63psDVtiWgVeN1zkYUChyzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215847; c=relaxed/simple;
	bh=kIVeoDS7oz9Pd8O2h81gEWJygiGIkHRw8A4xohFt7LY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ji61eo4Cd54U6Ld81VlrQqEySb0pTvMcdH77CO1sz09wMizrmTrczBWxWk/fR7fDbfHUi0100KIQZli1LzjwQumjSXTXgWV8SKNE5pDVe/Gva9ouCLYP3SaqTRaNTMpKwjEsXjknkPubn4lbEdO2vcj2tjGJxHFplg0J5wr4OBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nTRjftne; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nTRjftne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9D8C4CEF1;
	Tue, 26 Aug 2025 13:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215847;
	bh=kIVeoDS7oz9Pd8O2h81gEWJygiGIkHRw8A4xohFt7LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nTRjftneDmh28jqugpsREJ6ABiTtlbQ4T2aBeSv8hEBAzx6dwPVizbdM3OtmLgzwr
	 iycuYlJiOG3JCr7vJHJ9IG2iX2sxfQeD6UbVtf7UTl/JEny1VLhls9+BMxK065zewN
	 NnLR9Dv54Mgx8LmQx7ZJfGkqX49e/1rFl9XnsNkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Jimmy Assarsson <extja@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 161/644] can: kvaser_usb: Assign netdev.dev_port based on device channel index
Date: Tue, 26 Aug 2025 13:04:12 +0200
Message-ID: <20250826110950.466753203@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f6cb5ba61ac9..d5f119f607ef 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -838,6 +838,7 @@ static int kvaser_usb_init_one(struct kvaser_usb *dev, int channel)
 
 	SET_NETDEV_DEV(netdev, &dev->intf->dev);
 	netdev->dev_id = channel;
+	netdev->dev_port = channel;
 
 	dev->nets[channel] = priv;
 
-- 
2.39.5



