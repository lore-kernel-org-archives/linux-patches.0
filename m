Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059107;
	b=opjMMfJtuI6UuaBkXaHq0qm2zGi6FOmH99d26/E/zExjDeEfG9qxrhSMxyabsKx/NCnJ
	 SdiYhn08694Uy6CqzLYW1s5vC9MydCBgqFEFNAK7+eHo5jdpyDHSiWvQPe+6FNA0z4CbT
	 op0ffTVdZ1XTCA28uvVHo1Q2MYrQOc+7wea1rthiRFvOrH2h0+hQgsKOoG7+NpYDDJarz
	 wXq7k7FzwapEOzGCJgkeyyZ1onRxs2p4zAJJ7qaudXN79/0BbI7uEvoQ3B41unZOjayBt
	 1wW5IFdlAwY6US/iI3mZTGhD7pL5BLzKwG/qWD5zZHFIHbIPNrOyQo3jyNn4fzgr0+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aYQJCh7WHVGjTiVouwBhaCaBG3SURGlVjYBeOjSTKO0=;
	b=JISulSsWWb2E89jEBiIa4MBHTXl5ehLOwB4vXjxok4/g7Ws4vYzLP8M4xWFBpzVG0Jmv
	 h+CqTp320Prhym75dAeBUEL5ieJlPgVZAGTPPLzDIyG0LUn7/p6jaUZ9PKAo2Yns/StIA
	 yndstglt1L4KwuKhE2dQD3rgJwIxUzLMwWJxlVjso/HyOXQ14VEQJDK2sAPCyKzNw/pHS
	 0lTT7HG2Atel1EbG6pLN4WE3UiegMRT3xe9S2pCE+dnknpbdImuE01Pur/Ja3S/I8VqIy
	 rny+/kCRhtT3yd1dj+peRlmavSy2EebUIVvYzQxx4SbQMdR/7XdSg6EvfjoUqvn7JRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aVgYVSvT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51231606A325;
	Thu, 19 Nov 2026 03:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aVgYVSvT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85B31F000C4;
	Thu, 19 Nov 2026 03:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059107;
	bh=aYQJCh7WHVGjTiVouwBhaCaBG3SURGlVjYBeOjSTKO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aVgYVSvTg/wuMsKLXgYhy2qlnKRoLlELfQdi+7SlhkY27kWunSZwU4dCEWizQvKu8
	 0efRZGHFGjmvjLp0Mu6yS0AOHdSnJr22Gs/FyJFIMRxbPZvj3Ic8deeNzP/qPaMFl2
	 3IeXoY0exefGnzO/AbQr+Zqbnfmp2a/jm5O50r1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0725/1848] can: isotp: check the return values of can_rx_register() in isotp_bind()
Date: Wed, 18 Nov 2026 15:46:03 +0100
Message-ID: <20261118145946.356212657@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Hartkopp <socketcan@hartkopp.net>

[ Upstream commit 874f5f14cf626f72477071eff381c8485554250d ]

isotp_bind() ignores the return values of can_rx_register() for the RX
and the echo receiver and binds the socket anyway. When a receiver can
not be allocated, bind() succeeds without this receiver, so the socket
does not receive frames or its transmissions time out. isotp_release()
and isotp_notify() later try to remove the missing receiver, which
triggers the "receive list entry not found" warning in
can_rx_unregister().

As the device has been checked before and RTNL prevents a namespace
change during bind(), only -ENOMEM can be returned here.

Check the return values and register the RX receiver as the last step.
The echo receiver is registered first, as it only handles the socket's
own echo frames and does nothing while no transmission is in progress.
So a failed RX registration only needs to remove the echo receiver, and
isotp_rcv() has never processed a frame for this socket.

Set so->ifindex before the registrations, so that a First Frame received
before so->bound is set can be answered with a Flow Control frame and
the RX timeout is started as usual. As the RX receiver is registered
last, this can only happen for a bind() that succeeds. Reset so->ifindex
when bind() fails.

Check IFF_UP only after the receivers have been registered, so that a
bind() that fails on a down device does not report ENETDOWN. As bind()
holds RTNL, the device state can not change in between.

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Cc: stable@vger.kernel.org
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://patch.msgid.link/20261027-can-rx-lock-v12-2-eb5afc2d8b9b@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/isotp.c | 42 +++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 01d5a4603663c..d06a99ce84135 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1482,7 +1482,6 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 	struct sock *sk = sock->sk;
 	struct isotp_sock *so = isotp_sk(sk);
 	struct net *net = sock_net(sk);
-	int ifindex;
 	struct net_device *dev;
 	canid_t tx_id = addr->can_addr.tp.tx_id;
 	canid_t rx_id = addr->can_addr.tp.rx_id;
@@ -1559,26 +1558,36 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 		err = -EINVAL;
 		goto out_put_dev;
 	}
-	if (!(dev->flags & IFF_UP))
-		notify_enetdown = 1;
 
-	ifindex = dev->ifindex;
-
-	if (isotp_register_rxid(so))
-		can_rx_register(net, dev, rx_id, SINGLE_MASK(rx_id),
-				isotp_rcv, sk, "isotp", sk);
+	/* switch to new settings */
+	so->ifindex = dev->ifindex;
+	so->rxid = rx_id;
+	so->txid = tx_id;
 
 	/* no consecutive frame echo skb in flight */
 	WRITE_ONCE(so->cfecho, 0);
 
-	/* register for echo skb's */
-	can_rx_register(net, dev, tx_id, SINGLE_MASK(tx_id),
-			isotp_rcv_echo, sk, "isotpe", sk);
+	/* register for echo skb's first (no echo traffic at this point) */
+	err = can_rx_register(net, dev, tx_id, SINGLE_MASK(tx_id),
+			      isotp_rcv_echo, sk, "isotpe", sk);
+	if (err)
+		goto out_put_dev;
+
+	if (isotp_register_rxid(so)) {
+		err = can_rx_register(net, dev, rx_id, SINGLE_MASK(rx_id),
+				      isotp_rcv, sk, "isotp", sk);
+		if (err) {
+			/* unregister echo skb subscription */
+			can_rx_unregister(net, dev, tx_id, SINGLE_MASK(tx_id),
+					  isotp_rcv_echo, sk);
+			goto out_put_dev;
+		}
+	}
+
+	/* report a down device only for a successful bind() */
+	if (!(dev->flags & IFF_UP))
+		notify_enetdown = 1;
 
-	/* switch to new settings */
-	so->ifindex = ifindex;
-	so->rxid = rx_id;
-	so->txid = tx_id;
 	so->bound = 1;
 
 	/* bind() ok -> hold a reference for so->dev so that isotp_release()
@@ -1589,6 +1598,9 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 	dev_hold(so->dev);
 
 out_put_dev:
+	if (err)
+		so->ifindex = 0; /* reset on failed bind() */
+
 	/* remove potential reference from dev_get_by_index() */
 	dev_put(dev);
 out:
-- 
2.53.0



