Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027826;
	b=PH8W0vG1qQ3Urx2RJhoYVzcmAku7Rnb8Pg28Jg7+9Gj08YR9WAy0V/cNsAmI6BZCWq7M
	 D4xdvjEKoPoD8lRBA5kdZ3dg24egCIJl0jl4W/Fty+TzHUXNi8/vCGhIxFMZXd1LiNIpq
	 LAEPMmvikVx8OIou3FtdLjJ5Q7gb6G3LB5PyN+pcxHwmjtxGZdL08VLOo0Ch/o9vdpg27
	 5vg4dozoXSTkzlEZaGVvC9dfemhGiTJdRVGkhQgriZEubilQPfKK9vIbkMlzue2a/7Y2L
	 qqsJunJlCWQF0jK/C+xpRQwfxAceC0OHcLZsHn8PB7gJkuWimPVVT/N6wFE4nrvtjXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027826;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YOn3wd4VRywVBRXreN0dEFAbP4AgUR4geGBJnm/FPyQ=;
	b=sNNiaBFt2deGnL9T4WfA5wXrNi+vg+uwuPHFYzJCQOuuFZfoAK4gTBoJ+G3cWKxFChbx
	 DQ26ZptDrf+ugqrXa1oOjpcrqcEqfUFt2L23I+As1jgTtpMYcflv2zvTcMuOCgprv8c6L
	 2RqTFQRfxctop8Ubr2hPxgK3fxjGVC41nJrAlLB4Hke4P/xvVD91IHQ+dFRNWbqy9jxF4
	 IKEMdsyLbWvYal5C3grPp41ktGW1hN3XlIfB7rVWIy1e8xb74vKTXExM1hr1VtpWtmCLy
	 yk+/9r1ONLXcTHvP8oZCeh9NG2QulocBFBXOCFqMTaYYgnHWmOMNaYiegk+4fKJrrFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BK1XoZCC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186BE606A31C;
	Wed, 18 Nov 2026 18:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BK1XoZCC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23FA81F000C8;
	Wed, 18 Nov 2026 18:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027825;
	bh=YOn3wd4VRywVBRXreN0dEFAbP4AgUR4geGBJnm/FPyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BK1XoZCCLRP45XM/p8xPHnEPgijq4FdVVtIG1dptXR3AppvGEtNMPObbRMOlPRcYC
	 fElLQAXHWOhuG+s2JY1s916j+GLhrrCyubniFt/3a3oBTqfMjmTSVRrbloLzhZs311
	 CX6ZYvpJFICV8H1cfI/jVvEiNje/LtO2p4OSeSno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1928/2151] net/rds: include the scope id in the sendmsg connection cache check
Date: Wed, 18 Nov 2026 16:01:03 +0100
Message-ID: <20261118150232.015387751@linuxfoundation.org>
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
index 0a541cfc90185..07bb23f93ca5c 100644
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



