Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB87352FC8;
	Tue, 26 Aug 2025 14:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217364; cv=none; b=sH1ia4/26txUFmiGFMqXYjtUW4Q0HyhpZgdZkTSRrM1iz2ddU2ddCwjMHq39yHTmfZhNjz95xhaBmLFcPFNmg9wu1gsPaNB0Y3tJ9YgyPgUR/EK8eWXOYwz64rcrpBgGFX6+AhCZ52hdlDkyM64bvGiins73//t57dGsWor/xaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217364; c=relaxed/simple;
	bh=BhuKs2WTLtG2f1X7uzMMADeHgX9kPd/vT+5ZEztFPeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DOqvzgytGsYiooeaePjZK2Oo59vxOUs5syOoAqPmKDvISmD5b7lEVj4bNVuSEXOUP/ONGRm4bK4uT/8VU37oUDE/+X9R+SosgsbicxGH4nxH+KLr5tP9ExgEroyGHKLwaU1U7APXGEHK1Bz3DO9dVAUI2psQDE1Stef0YoKEVho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O+kzXN7R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O+kzXN7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D39C19422;
	Tue, 26 Aug 2025 14:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217364;
	bh=BhuKs2WTLtG2f1X7uzMMADeHgX9kPd/vT+5ZEztFPeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O+kzXN7RL19mJph8HBHuhICcSmQ+BIfGkm8P9JHTg4yO3c8P9gbumDi2SuJXRHEhb
	 pSLUaE2gTTj5t/ImCnSc3SBME5EL3QDUv9T0BFAWVwOCsQDR0EepPnMcv1E16ArHzp
	 T3UAHRH8yiEUVx04TRgC4CQPIxurDz6z3R/+9UG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Jimmy Assarsson <extja@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 116/523] can: kvaser_usb: Assign netdev.dev_port based on device channel index
Date: Tue, 26 Aug 2025 13:05:26 +0200
Message-ID: <20250826110927.383034562@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a96b22398407..602f0b3bbcdf 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -813,6 +813,7 @@ static int kvaser_usb_init_one(struct kvaser_usb *dev, int channel)
 
 	SET_NETDEV_DEV(netdev, &dev->intf->dev);
 	netdev->dev_id = channel;
+	netdev->dev_port = channel;
 
 	dev->nets[channel] = priv;
 
-- 
2.39.5



