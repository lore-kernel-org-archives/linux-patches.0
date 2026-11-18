Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032800;
	b=X/dk34Pyc6Q0fVxsMHsmnqGb/7SgPhaVvJ8POE0YnZBcGPVWCc6V8kEOpIo2UXtRvcRj
	 SoEfNuW0E1pOeFNweI6eP0BX/j2mw4FUpxn9DoBcQR88FsiQ7eEGDK1ivoVCdljDPmiVo
	 U9aEDt1a15hXNzX48Y5PUhc2x4/reFdbfABjeQfoG0MCT7Sh2SydfUwg6QC+C/5kxQbgq
	 2Sx4SAl1OPMV2EbHWUvgGOFq9h+zjkEM1N2K7bEZ+u+WJNxGVTWo+eN4AwvLwRAbYz8jH
	 f18JFGNLswHDcnO9pjpmURi7v+h6+32EPQe3FuMg0vtnBuLwJnh0wI7wWDLnQkg3v1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032800;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C3dac3wDfwsyVnSlKwijn29dYM9Xw48m2VBPzxijPRo=;
	b=QhRH9EDtku6cbKy7NFwOTpVqlhNS4GGqRt5kNEXB4hYqLWf3nkm3pgehc7ThRmIMp837
	 u4Vs+LcY+NED5/NyGD1qUVleeU/+rxRT8g6vBnMQUPy54FetZVvklCyQuOZOpD65RvSZ/
	 yK5GB3jbyeENlDBCAg23u9LD7VD9129cwaZPLbTkXzyD1tX0/YtpmEZmGrgqAIjMts54l
	 4NEVhHR1T524yvAeNMny/4dKV71K3OFl9kqOMICdguBRh9R8v9WraWdS93bnY4J3v9k+/
	 OUdXf/YhsCqV5mn2ypr2C9GNhQYc6p8WME0lypbaYV1bU5PSgETEJ5Y+/WH9n5MHiIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D0EOnf67;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179F0606A32F;
	Wed, 18 Nov 2026 20:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D0EOnf67
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1B31F000C5;
	Wed, 18 Nov 2026 20:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032799;
	bh=C3dac3wDfwsyVnSlKwijn29dYM9Xw48m2VBPzxijPRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D0EOnf6754S+T847XakSyqurcdVyP8QLeM7EuLWePW6LyHSQQLp1UZkEmePi4mnQH
	 hKlBXiLZa4B1Pl9VnRTiIqAvQbPWCk8nXMqDBUaPEgsEMfeSIiu/mKuf9Goh0teaAM
	 tYErNBkeue8Aki/8iJzIf6U4kHIE+PxBJxpIEj5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1539/1756] net/rds: include the scope id in the sendmsg connection cache check
Date: Wed, 18 Nov 2026 16:01:06 +0100
Message-ID: <20261118150110.212950738@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



