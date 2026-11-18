Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027831;
	b=gP2aSOoBeNWIW2ztHumQadPdDahGAMKRZWZ5jRkSCXEKvHyB3YWSP/AqZDkqgtlCEcwq
	 lkDGntmkk/oDD+mhUJqY07V7bJmJT7QAaIJNy2tYLbmP8SdMMbopnSLKEo4WA+BmRLOqO
	 Y1NoCCpdgd3cOG6zW79floyjyfBATazjJjcRa7ZZdsVT+b3vV/ND4pcIwDwaeOCCBpDW3
	 dHyZo8DxffikkYaTxUSfm8jsQuh/qlcK129x6HUdZVk0UmL+c1cWPWphQGzj56Lk2slHY
	 WTTZ0NGJwWfFG3v29wZ+sWjT9v7Ef0UhugJOZ4MTFyPpcueUai1guLYT50zIDn3Hg4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027831;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yvIJafAl5rKR5eMFHHdSyBQHdED/gmQkm3G5/PF+MgQ=;
	b=wIRB0Nllq1VejCNKMG4WJoiex1yaQTjB/3VdpxNDaJ9CkBPPXTNiS36tQxk6tj9oFeSJ
	 hgDTew6wOjNyuwmv0tBPJrqLra3hxWfsscDWmjAEzyds8V58sMqHgHQuQYc8E83SWSjiK
	 W1JYYA6+L574ihr/jm2+wSau3qxSNb43ScszBlZBxvPi7Tsi4SoAEiQv4IBPxfNcU6d7Q
	 ZDE/OV6jJ0oe9mLVEzam94/opmQ06BO9BxqpJ9UCi9djsG4dekjk44lZOkAgV6yv/7vE6
	 zD/hUvMkpI6vPu/dhae0DfChSjXaOReTi2vjCUWKsws0Iey4Kz4XxVPZSu0T5MyQtGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nXmrZiYD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61779606A320;
	Wed, 18 Nov 2026 18:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nXmrZiYD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B366A1F000C4;
	Wed, 18 Nov 2026 18:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027831;
	bh=yvIJafAl5rKR5eMFHHdSyBQHdED/gmQkm3G5/PF+MgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nXmrZiYDdBHgkwpfaAXHfDIRAxsqr5pkzCamG+MNxMuqp/ToYI/nEJqdUbO8xcBbt
	 qmtVcz4VWLZtQiYMNaghtbnxQSAbrs6XpYD7IxB92tb3gFAn+CE/BCK8e1AbE6R6nO
	 9S/unM2GDt0Vo88hSdWKTdnI9QGGXwDzAuWVbeB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1929/2151] net/rds: keep the connected peers scope id apart from the bound one
Date: Wed, 18 Nov 2026 16:01:04 +0100
Message-ID: <20261118150232.051766877@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Allison Henderson <achender@kernel.org>

[ Upstream commit 3fe64a5f670dbd6c7c84c2345b0b9726b3b79b31 ]

rds_connect() has nowhere to keep the scope of a link-local peer, so
it stores it in rs_bound_scope_id, the scope of the socket's own
bound address, for rds_bind() to check a later link-local bind
against.  That field is then also what a send without a destination
uses as the request's scope, what getpeername() and recvmsg() report
as the peer's scope, and what a later bind() overwrites:
rds_add_bound() stores the bound address's scope unconditionally,
which for a non-link-local address is 0.

So after connect(fe80::x%ifA) followed by bind(global), a send() with
no destination asks for fe80::x with scope 0.  rds_conn_lookup() keys
on the interface, so that finds or creates a connection with c_dev_if
0, which the TCP transport then tries to connect through
sin6_scope_id 0 and tcp_v6_connect() rejects for a link-local peer:
the connected socket's data is queued on a connection that can never
come up.  In the other order, bind(global) then connect(fe80::x%ifB),
the connect leaves a global-bound socket with rs_bound_scope_id ifB,
so sends to other link-local peers are refused as off-link and sends
to global peers inherit a meaningless interface.

Give the connected peer its own rs_conn_scope_id.  rds_connect()
records it there and leaves the bound scope alone, rds_bind()'s
connected-socket check compares against it, and the destination-less
send takes its scope from it - falling back to the bound scope for a
non-link-local peer, so that send() and sendto() to the connected
peer compute the same scope, and so the same connection.
getpeername() reports the connected peer with its own scope.
recvmsg() used to report every sender with the socket's bound scope;
a connected socket receives from any peer, so neither the bound scope
nor the connected peer's scope is right for an arbitrary sender.  It
now reports a link-local sender with the interface recorded on its
connection, c_dev_if: the TCP accept path takes it from the incoming
socket, and the IB passive side resolves it from the local address,
the closest the CM gets to the arrival interface.  Any other sender
is reported with scope 0, the inet6 convention.  Either way, a reply
to the address an application was given reaches the same connection.

Found by inspection while reworking the sendmsg connection cache; not
observed in the field.

Fixes: 1e2b44e78eea ("rds: Enable RDS IPv6 support")
Signed-off-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20261020002816.3087414-3-achender@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/af_rds.c | 15 +++++++++------
 net/rds/bind.c   |  4 ++--
 net/rds/rds.h    |  2 ++
 net/rds/recv.c   | 11 ++++++++++-
 net/rds/send.c   |  6 +++++-
 5 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
index a9445937d225b..c5d7817fde0fd 100644
--- a/net/rds/af_rds.c
+++ b/net/rds/af_rds.c
@@ -135,8 +135,7 @@ static int rds_getname(struct socket *sock, struct sockaddr *uaddr,
 			sin6->sin6_port = rs->rs_conn_port;
 			sin6->sin6_addr = rs->rs_conn_addr;
 			sin6->sin6_flowinfo = 0;
-			/* scope_id is the same as in the bound address. */
-			sin6->sin6_scope_id = rs->rs_bound_scope_id;
+			sin6->sin6_scope_id = rs->rs_conn_scope_id;
 			uaddr_len = sizeof(*sin6);
 		}
 	} else {
@@ -568,6 +567,7 @@ static int rds_connect(struct socket *sock, struct sockaddr *uaddr,
 		}
 		ipv6_addr_set_v4mapped(sin->sin_addr.s_addr, &rs->rs_conn_addr);
 		rs->rs_conn_port = sin->sin_port;
+		rs->rs_conn_scope_id = 0;
 		break;
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -612,11 +612,14 @@ static int rds_connect(struct socket *sock, struct sockaddr *uaddr,
 				ret = -EINVAL;
 				break;
 			}
-			/* Remember the connected address scope ID.  It will
-			 * be checked against the binding local address when
-			 * the socket is bound.
+			/* Remember the connected address scope ID.  It is
+			 * checked against the binding local address when
+			 * the socket is bound, and gives a send without a
+			 * destination its scope.
 			 */
-			rs->rs_bound_scope_id = sin6->sin6_scope_id;
+			rs->rs_conn_scope_id = sin6->sin6_scope_id;
+		} else {
+			rs->rs_conn_scope_id = 0;
 		}
 		rs->rs_conn_addr = sin6->sin6_addr;
 		rs->rs_conn_port = sin6->sin6_port;
diff --git a/net/rds/bind.c b/net/rds/bind.c
index 97a29172a8eec..70237a3243f02 100644
--- a/net/rds/bind.c
+++ b/net/rds/bind.c
@@ -233,8 +233,8 @@ int rds_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	 * non-link local address (scope_id is 0).
 	 */
 	if (!ipv6_addr_any(&rs->rs_conn_addr) && scope_id &&
-	    rs->rs_bound_scope_id &&
-	    scope_id != rs->rs_bound_scope_id) {
+	    rs->rs_conn_scope_id &&
+	    scope_id != rs->rs_conn_scope_id) {
 		ret = -EINVAL;
 		goto out;
 	}
diff --git a/net/rds/rds.h b/net/rds/rds.h
index a1dd83c2f9a29..5a1789ace8fbf 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -613,6 +613,8 @@ struct rds_sock {
 	struct in6_addr		rs_conn_addr;
 #define rs_conn_addr_v4		rs_conn_addr.s6_addr32[3]
 	__be16			rs_conn_port;
+	/* scope of rs_conn_addr when it is link-local, 0 otherwise */
+	__u32			rs_conn_scope_id;
 	struct rds_transport    *rs_transport;
 
 	/*
diff --git a/net/rds/recv.c b/net/rds/recv.c
index c400cc5ea3605..c279791041c6c 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -755,7 +755,16 @@ int rds_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 				sin6->sin6_port = inc->i_hdr.h_sport;
 				sin6->sin6_addr = inc->i_saddr;
 				sin6->sin6_flowinfo = 0;
-				sin6->sin6_scope_id = rs->rs_bound_scope_id;
+				/* A link-local sender is reported with the
+				 * interface recorded on its connection (the
+				 * accepting socket's device for TCP, the one
+				 * resolved for the local address on IB); any
+				 * other sender has no scope.
+				 */
+				sin6->sin6_scope_id =
+					(ipv6_addr_type(&inc->i_saddr) &
+					 IPV6_ADDR_LINKLOCAL) ?
+					inc->i_conn->c_dev_if : 0;
 				msg->msg_namelen = sizeof(*sin6);
 			}
 		}
diff --git a/net/rds/send.c b/net/rds/send.c
index 07bb23f93ca5c..5a5d21b9a3ca8 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -1222,7 +1222,11 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 		lock_sock(sk);
 		daddr = rs->rs_conn_addr;
 		dport = rs->rs_conn_port;
-		scope_id = rs->rs_bound_scope_id;
+		/* The connected peer's scope for a link-local peer, else
+		 * the bound scope, as an explicit send to that peer would
+		 * compute below.
+		 */
+		scope_id = rs->rs_conn_scope_id ?: rs->rs_bound_scope_id;
 		release_sock(sk);
 	}
 
-- 
2.53.0



