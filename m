Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585685;
	b=aFf5REpItV2MVfbUa4oNSGrq1BThJror18rkkAYLbmtiG/H5y6hpwP4Mp+xXkvxiTIQl
	 9ybsV/KbkVjmrVS3Wvwk4u9iuBYaMToTwjp4zEu9ReN8G4YVrIjrxMXKBWxJqSQ6mFjmY
	 1Vzf97PTcT34yTRy1645fO6sxbmkszoV6/mFkZmPaCWo2HZF2o6rjiTidqTHti9idLu4Z
	 4kG/wijoOcsjAelP6OhbFeM9EG+1mKxfYil472Fu5ckqZ6zcnmx7Wz1XiXGMcOzk10ZNc
	 5VPRCqmFUu+uTVijL3LjZQ22j8L9JlRdCiBdGE8ajnHfgC5Qyg0N0Toe8lszkIVkccA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585685;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ACKGaRoYFJthUOH5UnveAFoVF4vw3/5KWbxhEse48c4=;
	b=401U8KoWDinRFdfwjCjGcy+yAkltdR9Xq+No4F+hAxNU3n4GStWavbsWY4pk1X9yDPO0
	 eE2S9VCId0jfZTnZgAoSjYyXj3XtoL+teY58iB+2hns1uDdlSvRUJFPnIAPweoxZfw3S5
	 3TC4U5vMRoP0E6QUXnFKPS4dBCz4P5YZ77FbCBRxwaPMHGnils9rB3UtlVsvpQBXU1m+K
	 xg8nNrxdCSykIENUTyHitIQ2LEiiwBcs9D2weRxAWpBc7p8i1wOjMR8TJYgew9FlUUeky
	 JTXm7G/h3ULGJhyl/QFN8PmIEv8IPhBYZWLyhVHqWkQND0jcCaeF9wUza1ZaUJ2T2yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=luIU2+g8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68167606A8AA;
	Fri, 13 Nov 2026 16:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=luIU2+g8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14DBA1F000C4;
	Fri, 13 Nov 2026 16:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585685;
	bh=ACKGaRoYFJthUOH5UnveAFoVF4vw3/5KWbxhEse48c4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=luIU2+g82h2BCjDnxHBQ1WY8GT719rDPT5bKXkgC7FVAjH/pHCtF//s9OVtatQ9Fo
	 Ao6Nc2JCG5ZUfOoRRJNZJXMkBrSFE0K6bCj2LUcnSesxTOXl4pvFREhVIrP6vCGgYy
	 2GRQbN3xxwxAf1AvksbhZYbZobUX0ioOTST7j5KU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 295/507] can: isotp: check the return values of can_rx_register() in isotp_bind()
Date: Fri, 13 Nov 2026 10:49:59 -0500
Message-ID: <20261113153805.241727803@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index e4957855829e6..28e9d22772fa3 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1550,7 +1550,6 @@ static int isotp_bind(struct socket *sock, struct sockaddr_unsized *uaddr, int l
 	struct sock *sk = sock->sk;
 	struct isotp_sock *so = isotp_sk(sk);
 	struct net *net = sock_net(sk);
-	int ifindex;
 	struct net_device *dev;
 	canid_t tx_id = addr->can_addr.tp.tx_id;
 	canid_t rx_id = addr->can_addr.tp.rx_id;
@@ -1627,26 +1626,36 @@ static int isotp_bind(struct socket *sock, struct sockaddr_unsized *uaddr, int l
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
@@ -1657,6 +1666,9 @@ static int isotp_bind(struct socket *sock, struct sockaddr_unsized *uaddr, int l
 	netdev_hold(so->dev, &so->dev_tracker, GFP_KERNEL);
 
 out_put_dev:
+	if (err)
+		so->ifindex = 0; /* reset on failed bind() */
+
 	/* remove potential reference from dev_get_by_index() */
 	dev_put(dev);
 out:
-- 
2.53.0



