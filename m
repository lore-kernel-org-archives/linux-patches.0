Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037920;
	b=nBimzXEUHez5DIoMfh+B39GjUcc6zJycQ1LKh0YhNC5YLjFKIVXD00mWNUFbCWqcEY8u
	 CNig33yQvPMM6cnuQbLkTF1CcXXMb61kBxmMYHiurzi/UTDHQ6Krxo7WDpJJQ4+hkDFJT
	 V/B2+QccQSfy/M07ODuO8XdYFz097JeUaOcnRJ3gRfMKT9uSQsF1MjxzljQR7cg7Cb7gt
	 Aeb+NgZFYCtj/MtlxzBtfD4SW8pb0OgqW0U9Au9j88CJU+E0WcqRfr3/R1x3/usE+KIwZ
	 ua0WN/zUlzdZxO047oMo3US4jWn46+e/AV/qmSasPO3MYmNELvf3AOr3KPg//MuM+lA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037920;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hlnVwwiep9MX2JYoZt26FIepJlWHO9vfk2+1lgOZrNc=;
	b=GoNcnm0bg73AfSXcKVDTOFdh7jJQ8vuwGHWhv1zFaed5SMfKie02mX1nDkPIsNzty9bv
	 rj9sXt+Rywi1+xgLd88CM7yhn0QVya52i/g2UOKQDonq5yh0B85k2/VQ4BiWlO6uMFJxk
	 NLttFVs54qy46nTxKbsf9e2nvx1mOpjeNWEBOgGlpP0LLGmeDe2bqX15nhzupsP5/YA0E
	 dlpZeQZ5egZY1rv+ss8znGuoCe9B6CtPe62SzwKKJIFgFNXLy51+GexE/o9C807WxyLbt
	 hX3WoeBYTeaJlLSTe/cLWPtF29rZlCXfM7jfOsMbdKVW1u2hW0l3rTc5A3pqJiIG23Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ENpD8UF7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62714606A31C;
	Wed, 18 Nov 2026 21:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ENpD8UF7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47781F000C4;
	Wed, 18 Nov 2026 21:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037920;
	bh=hlnVwwiep9MX2JYoZt26FIepJlWHO9vfk2+1lgOZrNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ENpD8UF7CuB9Yc6G83k84B4lNkbW2X3QOFW56kL0o4dxjrH5YGrYMpWn5pzhGo97L
	 nYBpsSFA9kktVQXF0qj/Lg6l9AyDv5qfsEvhoqZd344O1ljHbepSwM6t1DDlq8te2V
	 ePMAIv2aQFZLVbLxwRPE7ds4nLiWC1AFoYhwylEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1511/3318] can: isotp: check the return values of can_rx_register() in isotp_bind()
Date: Wed, 18 Nov 2026 15:35:33 +0100
Message-ID: <20261118150406.270747167@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1a6691a5287ae..a11999c50c8ab 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1521,7 +1521,6 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 	struct sock *sk = sock->sk;
 	struct isotp_sock *so = isotp_sk(sk);
 	struct net *net = sock_net(sk);
-	int ifindex;
 	struct net_device *dev;
 	canid_t tx_id = addr->can_addr.tp.tx_id;
 	canid_t rx_id = addr->can_addr.tp.rx_id;
@@ -1598,26 +1597,36 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
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
@@ -1628,6 +1637,9 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
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



