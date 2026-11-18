Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062035;
	b=2+UY1qLNNijIwNXYHgNJ7YmKrF22O3FOnql0wlNVjcmWfK2tM81tlvOJ+l2G7d8o1fFY
	 dWyMMG2CRwRvRPwj4ppmrUo2v1hL1NiMY54gVD9GaelBujczwTuCdXs9OjIgt+FdvlFKk
	 486/HQVfKG61gXI0k5mhDocGBhX7o6EYNEZ8YtDsDgmngo9MoGCbGNM/U66o2DTu4PBTx
	 Rj5/xn7LrJ1RrKrqi04316Y1AdwbFn8LVpmluRY12fE0LqeJ3HUzTOC7oO1SojHNSV40e
	 qul8U3b0GvrF+MV1ZX67L798xp/DADR0hqx3GxNND5bXl61Pm+1miwePiJ9a4Uac2sQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062035;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tvo4I+XE/qPXOrbIcj7NjoYM3+RTZnwkpG1iW1MR5EE=;
	b=GmuunIz/KLK7+mQHEz6SRx0Q5bs/fInYRqqxNeA11qDPe7/jVm3fru0bOvFWYdocQ9fc
	 7mkREaM8PVSAFmfJkt4QCnI7cDzYslBKuninEXwZtbSfxgQI/wetj+Px0BhfnDUCUZBbV
	 qy3cP/hTa1qwpUy9fRx5/mTSsJ56iheyfAMr3wCvMw8BohjHpgWigbS4nP37tYTEQSs4Y
	 PxcUQkRo5+0TeIhOLTJAkqy8g8cmJC86YuGnWZN+/+J5jsfksHU0+txWICDNaNqU5q9Yv
	 4uvHqI7lfrwQfh41xcy4krUGbME7gn08Zgf6PccZ96vmac5mu7Ko54mhlyBD/cfmBcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RYZXGqQw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9401B606A325;
	Thu, 19 Nov 2026 04:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RYZXGqQw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E651F1F000C4;
	Thu, 19 Nov 2026 04:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062035;
	bh=Tvo4I+XE/qPXOrbIcj7NjoYM3+RTZnwkpG1iW1MR5EE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RYZXGqQw632MHtUdKPzNTPnRVvAg1Ou68QhmPczzXXCs3mJAkyMqFxax7sYGraFr+
	 LnDobuRLDUxo5wrx7Wi7tLBMI5O6LEDKHoEeP9BTHHymaXxGavd2JZbf+XzgT81roU
	 s5px/6wNpIieS7oCdwq/7xc5/a0WvLmFWp5dBCgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1765/1848] net/rds: include the scope id in the sendmsg connection cache check
Date: Wed, 18 Nov 2026 16:03:23 +0100
Message-ID: <20261118150033.309117449@linuxfoundation.org>
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

From: Allison Henderson <achender@kernel.org>

[ Upstream commit b7dfff5e3eb3984d42026a6d653ec2a3d5cec729 ]

rds_sendmsg() reuses the connection cached in rs->rs_conn when its
peer address and ToS match the request.  The interface index is part
of a connection's identity as well: rds_conn_create_outgoing() passes
the request's scope_id down as dev_if, and rds_conn_lookup() compares
c_dev_if, so sends to the same link-local address through two
interfaces are two different connections.  The cache-hit test never
looked at it.

A socket bound to a non-link-local address has rs_bound_scope_id 0,
and the scope check at the top of rds_sendmsg() accepts any non-zero
destination scope for such a socket.  So after a send to fe80::x%ifA,
a send to fe80::x%ifB hits the cached ifA connection and the datagram
leaves through ifA, to whichever peer answers to that address there.

Compare c_dev_if with the request's scope_id in the cache test, so
that such a send takes the lookup path and finds, or creates, the ifB
connection - the same key the lookup uses.  A send without a
destination takes its scope from the socket, and the connection it
created was keyed on that same scope, so the comparison holds for it
too; the next patch gives that send the connected peer's own scope.

Found by inspection while reworking this cache for the connection
lifetime series on net-next; not observed in the field.

Fixes: 1e2b44e78eea ("rds: Enable RDS IPv6 support")
Signed-off-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20261020002816.3087414-2-achender@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/send.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/rds/send.c b/net/rds/send.c
index bd27e73e30849..b0961a0a9be3a 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -1309,7 +1309,8 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 	/* rds_conn_create has a spinlock that runs with IRQ off.
 	 * Caching the conn in the socket helps a lot. */
 	if (rs->rs_conn && ipv6_addr_equal(&rs->rs_conn->c_faddr, &daddr) &&
-	    rs->rs_tos == rs->rs_conn->c_tos) {
+	    rs->rs_tos == rs->rs_conn->c_tos &&
+	    rs->rs_conn->c_dev_if == scope_id) {
 		conn = rs->rs_conn;
 	} else {
 		conn = rds_conn_create_outgoing(sock_net(sock->sk),
-- 
2.53.0



