Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042374;
	b=TGdtKcKRh0RxFx9ek5tqZLqTv7mZJt65qbA1R2PgNRzCRlIxdYu7RtvwREIUJ+7nOl0g
	 VhHyOB9tu2xtjJSxGSWkFymzYP6G5zNVxq6apffmJcde/OtniQrWESrLXS2HwAUOgXkFW
	 VrOYt/4hf+kCWCTLrEL+nf4Yxb1Rux8EFLB727uPzielwFyOZSgIliAN7BDTKMcYVljCG
	 eStdiJltLYioxw8JQh8NZD4b7aVAr+xrbCLsOzzXCJdKlnj8fDeKjMi7+IwDxWKY7f5M0
	 GK7hVMxwSxW1LfPkIaSRPvhxUehkUQdsPdW4YPLyWWYcecsusfTTZwmqIrWxAL+JGsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042374;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x4XB+8A8SYkzGBvjuYWgsfzd99y4gAwgOfe6EP65ts8=;
	b=yzJN2RnY5KLo+vOrAf5DMXDM8IUwElAOM2/HKh2HgXfMbNskwdRQZzmCxHfYBy7Uf5SF
	 DMPRXPACsDm4DvIPaYQT68kUZl0ylPMSCKc+rA39P+0tQ8rB4QpGph1Oef0MrZoDUkRKB
	 mE8YboHmf4qXUqhWeRUUAfBl0wo27G1ra7A8lyx+UoLm6BN7YJliu6syIKF+XeQ2GZe+d
	 QEiClLj5SE0983fqwz2pJeJ8Cvw40JL+GPH85OADeu06Q/vttom2dTGbNUgaI+rf13e3C
	 v3IByd0+0SIxxkI6teAKpk3Dd1lT1XDm3y7Z8LZK3mwK9e9UgPLZ4UsMPpRhg9oAn7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HIiDXZWW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7635B606A31C;
	Wed, 18 Nov 2026 22:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HIiDXZWW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66EE1F000C4;
	Wed, 18 Nov 2026 22:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042374;
	bh=x4XB+8A8SYkzGBvjuYWgsfzd99y4gAwgOfe6EP65ts8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HIiDXZWWQlNtfjuEvnYsLX1b+MDvKQoaJF8cxVdZu9akBL3mdtRJm3zMyPSMjk9Yo
	 ELLKq6JiyIIWBqsUmHI3riEhDEBQfTPL0PqM22rKTt5N39L6t9L83mm7LO1LpCSX/0
	 h/aepXZEMVhi94epZMtcp9+VO3j9a81XHD8XTRRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3147/3318] net/rds: include the scope id in the sendmsg connection cache check
Date: Wed, 18 Nov 2026 16:02:49 +0100
Message-ID: <20261118150454.279076512@linuxfoundation.org>
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
index 27cedbbd140db..d38964cbf3aa1 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -1308,7 +1308,8 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
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



