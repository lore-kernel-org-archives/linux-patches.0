Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059135;
	b=EWCfyfUyGf5OZUxv4XZNDRuA/hPyqwDipx1gK1kHRDmeHeh4bhQ2x0A257N1KibP8Zy/
	 ZW0IMzp5RKKBXQ4LXs6HeJ/xTpQPdNFQZmlDe/acTNdiq73B6R/0zt4eZO5FYVGz1Z5df
	 FCHwmnvYocCULCsFJjuCl5doTwagOlI7Gj+/5QMcXGXiN1vvFByPSpcu+LjiyfzZjCT4k
	 JGEDB/rtUg8KXTK/1Pl2oqpYXJuXoT+lV4s6xyTbyDFubcyDkCtlyPmYofEhjBKMRcKwA
	 RJd8yfN4nRR+qFT67b45R+ODfxoUnIJYINxHZxotgtTAPJ7CXOTjjEHgd9G0Cb0aYcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059135;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+JadyCdnekqyrW31TgvG9Iaz+hUF3ilcGe9kj7d3PtE=;
	b=N81BnS3/i1gY1f+P3Yhx449+GpYZDVhi+r9iILtO7ntt/qQ42KAgnaGWsQjqxVK81o29
	 MXIIorKZh6aYr8ya2E29PoAnJeow7rgcAG2NcMip5XlJpNZJ/+5qOSo8jXIZ/PnD7E/39
	 oKrYd+wQN7UeK3a1gA2Mq7ZIXRS/Vwx27msJB3VXDHmNkkzsv/pRbxv29h3MG683PSoj0
	 WQ5FUkgh/4oZaKcRbYmOVuNTiK32rulxoXMPZSPIIjyuDSfTxOLirImi9s7ab/DM5ziZ/
	 XHQLkhaFVuKgwnSeHqXsvnsr94QlC3okhWDqQUS/BHUUyBIoVq8qDUUKyJhr5dOIeLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rz4vAqBS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7F3606A31C;
	Thu, 19 Nov 2026 03:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rz4vAqBS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8BA1F000C4;
	Thu, 19 Nov 2026 03:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059134;
	bh=+JadyCdnekqyrW31TgvG9Iaz+hUF3ilcGe9kj7d3PtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rz4vAqBSeY6FissUl5i4xN9u8bRXfDnOXRiNsJTRz+zosLOEvZVpy803GNZ+54LUt
	 4d9PN5mthgpBHQFg7cfGhq+8PrizdSZuXrgwbcgowHw8QprQ2dCm2xRLaHamC/hmal
	 acrhKPaL/YKQ9yJ3X7kyrYfs25g8Z+jM22/BMFuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xia Yan <yanxia@cmss.chinamobile.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0734/1848] ipv6: fix device binding after failed datagram connect
Date: Wed, 18 Nov 2026 15:46:12 +0100
Message-ID: <20261118145946.960377969@linuxfoundation.org>
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

From: Xia Yan <yanxia@cmss.chinamobile.com>

[ Upstream commit bc53aab4881adc134f495092034e9e7c0791d84c ]

__ip6_datagram_connect() can change sk_bound_dev_if when connecting to
an address that needs a scope ID. If ip6_datagram_dst_update() fails,
the old peer address and port are restored, but the new device binding
is left behind.

A UDP socket can then keep reporting its original peer while sends and
attempts to reconnect to that peer fail with ENETUNREACH. Replies to the
socket are also dropped by the device match. The same problem occurs
when a scoped multicast destination picks up np->mcast_oif.

Save the original binding before processing the scope and restore it
along with the peer information on failure. This completes the rollback
in commit 2f987a76a977 ("net: ipv6: keep sk status consistent after
datagram connect failure") and preserves the new binding on success.

Found while reviewing scope-ID handling in __ip6_datagram_connect().

Confirmed by exchanging UDP traffic over ::1, then attempting a link-local
connect with a nonexistent scope ifindex or a down interface. After that
connect fails, the original peer is still reported but communication and
reconnecting to it fail.

Tested before and after the fix in UML for three rounds, covering explicit
scopes, multicast interface fallback, initially unconnected sockets and
existing bindings. With the fix, the old binding and peer are retained,
and traffic and reconnection to the original peer work. Also built on
x86_64 with W=1 using adjusted allmodconfig and allyesconfig
configurations, with no new warnings.

Fixes: 2f987a76a977 ("net: ipv6: keep sk status consistent after datagram connect failure")
Cc: stable@vger.kernel.org
Signed-off-by: Xia Yan <yanxia@cmss.chinamobile.com>
Link: https://patch.msgid.link/20261029135822.448299-1-yanxia@cmss.chinamobile.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/datagram.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index 8f772274f0daa..b265930e74514 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -141,6 +141,7 @@ int __ip6_datagram_connect(struct sock *sk, struct sockaddr *uaddr,
 	__be32			fl6_flowlabel = 0;
 	__be32			old_fl6_flowlabel;
 	__be16			old_dport;
+	int			old_bound_dev_if;
 	int			addr_type;
 	int			err;
 
@@ -211,6 +212,8 @@ int __ip6_datagram_connect(struct sock *sk, struct sockaddr *uaddr,
 		goto out;
 	}
 
+	old_bound_dev_if = sk->sk_bound_dev_if;
+
 	if (__ipv6_addr_needs_scope_id(addr_type)) {
 		if (addr_len >= sizeof(struct sockaddr_in6) &&
 		    usin->sin6_scope_id) {
@@ -253,6 +256,7 @@ int __ip6_datagram_connect(struct sock *sk, struct sockaddr *uaddr,
 		sk->sk_v6_daddr = old_daddr;
 		np->flow_label = old_fl6_flowlabel;
 		inet->inet_dport = old_dport;
+		WRITE_ONCE(sk->sk_bound_dev_if, old_bound_dev_if);
 		goto out;
 	}
 
-- 
2.53.0



