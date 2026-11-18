Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053399;
	b=zBETmMo8YjMDq5wy+oNfEj6NaYi5IvKTs2vxiV2fg2rh6TxYPXcFQtb61UiTfxk02Bs4
	 nH2+7g80zi2X0q6XLkvcj806n3uPLRKYQd9Cbpu0wBFc3BR7pG9AiueJBTSKDpzTzQyGb
	 RcO0/f5uuNCI+pixONnWCDgJ2fRsltSxjHrQuLZ4mLFzA/iesipmsnW2TRU7flBvK4Llk
	 yVEolLxLhB11qwmbG0ZDQ2ILoPT3h1yIVphSoYovNpaCbdfpxyGthyAPI6Er0yeLi3YFH
	 agn1TF4E97ylWrGrXTzdX1SWo71OC/8+9nAo9UV0c4TFzKaPUiCcqESGgxQx9bVfcVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053399;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MKVWD57yE5Tne08Vfx86Bst5pruUzujr4o6UFpsZIN8=;
	b=3thrD037SDEQn6vrun16JRK9cKZVRPHIpO3jVZSqp+2yTYXonaWTmgFPcF22eQX/tDEx
	 lJvhcp2jwhowhpTaG0RvWx/4PZ/RzhnAFe4pOYRo6kmLgTtW4XSYKXDFyVqcC20v5BrSz
	 GlDNCA+9wx0Lk1ZJfJliEgp04cM0O08LdygwZY0Pgymz2EX+Db3ZRBeblAIzDfyjJOL5S
	 p1Wm0+ANaUQP8Zuxk5UlrA/3n4szaKNvVGesoPnCCONMLaMp0Y+sPpHE71VRVdIbJZnC3
	 a3xmaYGsieC4oSLRHsO1SnQXoCt/mm1NfXUGNWClLG/ZIUDTht0W2XS0yt1g4iTfl/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Ik/xvVQj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E860606A31C;
	Thu, 19 Nov 2026 01:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ik/xvVQj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2AF31F000C4;
	Thu, 19 Nov 2026 01:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053399;
	bh=MKVWD57yE5Tne08Vfx86Bst5pruUzujr4o6UFpsZIN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ik/xvVQjPgKhkNW3mVwsjE2qjg2XGPUKGvkpR5Q+lt630x0PkECXoe3PQdwCE927T
	 Xco+mxpELZZ6cdNENbWTYB2BNiRwL6iVychSQsFTdbwIix4JGEKusBY7ee62yNkFii
	 G81OfwnRPyzyGCmJJZEoU7izZHg1rn8H4Z9tlbls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xia Yan <yanxia@cmss.chinamobile.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0907/2214] ipv6: fix device binding after failed datagram connect
Date: Wed, 18 Nov 2026 15:43:03 +0100
Message-ID: <20261118150048.621431590@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



