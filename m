Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C7937417C;
	Tue, 10 Mar 2026 11:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141106; cv=none; b=g6ipVHy2vDUl/fOkZJbNeUzn/e3ASbw9K5F6YuxE5HL4tpRk3lopnlq9Le0UVETUQpTHmK/JrxnsRrok8qlqJoRLyKJaMmlODtE8CmXJ7nnqm8+kUDDT/OSVFKo3KKuWi+IYYvBeaIYUf5EMWPXqQLFBngS/n/JX0ctRO8Vk7Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141106; c=relaxed/simple;
	bh=cf0ka6n2i1P3gSi7cu/2DFNtAPCfomNhU9IgUKUwAsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SStl/2C/h/N0vgOFmB2D+1RbNOjk5N64TSm74SuxBn4gIbdKD1U6ZPxhN6yBALG16Ao2pRNI4/6V8FhvS8oe1de3roE8FvBhj2vMBzDOHtsMmU2cH9BhQShdITSz+SgsI6+m+4PzHcqc1HqaTqQjQSyCO3/tu6G3QnrXC7P1hPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dSx1TJhr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dSx1TJhr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C8BC2BC9E;
	Tue, 10 Mar 2026 11:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141106;
	bh=cf0ka6n2i1P3gSi7cu/2DFNtAPCfomNhU9IgUKUwAsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dSx1TJhr11qbCpiKJhUh8y9sIY/LlQxL1KpQ4ci0o4qAShKqNUVUa0QKxUmTMQmOH
	 0H13szgAAsYLg+Yf5mRdvWHJCfykwIIVD01wgxx5sg91v0X5BsGwi3XI9Cn4cG6B42
	 PKziZXHYcJVrii+5VJL0SxfjvHhIOQt8drNYfRT/n1Yu1QEruP0l2XLOC6wYNwWBpP
	 Nal2MJb0QQfz2aTZkIEMU8tbvc+EctqqmPudVZKXpPaVH5NPTlsep4J8yu+8G9JWFH
	 WWrH1W3QNmCn9lZqTOgCJam856O3uWeD8NjJ/Y9EOa0l0tYvUpzX8/BtXYSHJ1ULQj
	 3r759FFdYeQ9g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Ji-Ze Hong (Peter Hong)" <peter_hong@fintek.com.tw>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Vincent Mailhol <mailhol@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.19 108/311] can: usb: f81604: correctly anchor the urb in the read bulk callback
Date: Tue, 10 Mar 2026 07:02:35 -0400
Message-ID: <28d8f8abd2afb85b64dc6ad04afa5a5f86526414.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 952caa5da10bed22be09612433964f6877ba0dde upstream.

When submitting an urb, that is using the anchor pattern, it needs to be
anchored before submitting it otherwise it could be leaked if
usb_kill_anchored_urbs() is called.  This logic is correctly done
elsewhere in the driver, except in the read bulk callback so do that
here also.

Cc: Ji-Ze Hong (Peter Hong) <peter_hong@fintek.com.tw>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Vincent Mailhol <mailhol@kernel.org>
Cc: stable@kernel.org
Assisted-by: gkh_clanker_2000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2026022334-starlight-scaling-2cea@gregkh
Fixes: 88da17436973 ("can: usb: f81604: add Fintek F81604 support")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/f81604.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/f81604.c b/drivers/net/can/usb/f81604.c
index efe61ece79ea2..28ac92d669faa 100644
--- a/drivers/net/can/usb/f81604.c
+++ b/drivers/net/can/usb/f81604.c
@@ -413,6 +413,7 @@ static void f81604_read_bulk_callback(struct urb *urb)
 {
 	struct f81604_can_frame *frame = urb->transfer_buffer;
 	struct net_device *netdev = urb->context;
+	struct f81604_port_priv *priv = netdev_priv(netdev);
 	int ret;
 
 	if (!netif_device_present(netdev))
@@ -445,10 +446,15 @@ static void f81604_read_bulk_callback(struct urb *urb)
 	f81604_process_rx_packet(netdev, frame);
 
 resubmit_urb:
+	usb_anchor_urb(urb, &priv->urbs_anchor);
 	ret = usb_submit_urb(urb, GFP_ATOMIC);
+	if (!ret)
+		return;
+	usb_unanchor_urb(urb);
+
 	if (ret == -ENODEV)
 		netif_device_detach(netdev);
-	else if (ret)
+	else
 		netdev_err(netdev,
 			   "%s: failed to resubmit read bulk urb: %pe\n",
 			   __func__, ERR_PTR(ret));
@@ -646,10 +652,15 @@ static void f81604_read_int_callback(struct urb *urb)
 		f81604_handle_tx(priv, data);
 
 resubmit_urb:
+	usb_anchor_urb(urb, &priv->urbs_anchor);
 	ret = usb_submit_urb(urb, GFP_ATOMIC);
+	if (!ret)
+		return;
+	usb_unanchor_urb(urb);
+
 	if (ret == -ENODEV)
 		netif_device_detach(netdev);
-	else if (ret)
+	else
 		netdev_err(netdev, "%s: failed to resubmit int urb: %pe\n",
 			   __func__, ERR_PTR(ret));
 }
-- 
2.51.0

