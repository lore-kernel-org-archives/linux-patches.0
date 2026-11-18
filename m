Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032772;
	b=bu9X88+jdOIjWeFPG2abDvxoU32YbxjxcXgdRkS6/0kXYYbJQCR1KbCO/kxUMIFV1nBt
	 jQ7s42lrHE2rgyFAe3SzMKqH9IVXxc7L9HXmtmhiA2boUMGhV5PoW2xDzJoT1WGNL544o
	 MW/qxeB1oFIoe7SzQ9ZIv9KAzpnptRyqar7jAj/RyC+IEYvtZJjXy8fFb5ONHRaJ3vn/v
	 WOtkhK+YC2pHxN7UD2+7Zn5nYiZCAibdNQs9nio9eTTsW9X7RhG8HaL/k8jpcH5yvdMdb
	 oyklf1h5EERf8hjR27/DWyaZHikdsvgXQ1K31DffZ8YYHlHXIQMYpT4hK7Jfv0uNemA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032772;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UcbHC7aRzqGtRNpH//7ioXgdiOvaeLgBMU9XR6XW1GI=;
	b=p/KMrOOdterLrBLa749FfgHRRCLEPiRja+ACjsS1HGsm2XWTXAljHA5gCXRtfQ6Oqc20
	 bRsWDSRx4iqi90hP+33NDk29d0xHVOEk+CptPo0VgZu8fiA97n+KQ+BJvBT7W+TwxFOH5
	 SuT/1mUFKpjt/cZwvL3FC0YaRGMYX7wYR08kLL5CU1gLeMCkVVgtL6PfdifDtmjFeFC21
	 VedEvhfx9m2G0aX62rT9OZ83my2itLj9HMvWvwB+b8Cb+dDAGtHhO2Cw+qpMbOX1x7tbX
	 4mXnfKUbN87aJ4GJqjAR9VJXIczcw6C1P8ucLi0Qcayt5zwA4zqoqbiggJGCDmX0CTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vlSmyCCC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99E0606A31C;
	Wed, 18 Nov 2026 20:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vlSmyCCC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DCA71F000C7;
	Wed, 18 Nov 2026 20:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032772;
	bh=UcbHC7aRzqGtRNpH//7ioXgdiOvaeLgBMU9XR6XW1GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vlSmyCCCW8L7S46MOAhpZaQi5oYr/qYStFuxiwYmpJj6nMgchOSaRYRalL6fRWTtN
	 nk6UKDxE2E1fsNmGrTN2Knr/eHCVxdGx6mP63w4TESHsPJvem9ShamnlLknwRa9Mlx
	 KyN4/z7J33M76DzhkTf8DwyseEvrmSyTd8A3Fcx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyuan Mo <hdthky0@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1530/1756] sctp: reject forged cookie peer_addr with unknown address family
Date: Wed, 18 Nov 2026 16:00:57 +0100
Message-ID: <20261118150109.881186877@linuxfoundation.org>
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

From: Xingyuan Mo <hdthky0@gmail.com>

[ Upstream commit 9802123ceca818aa69284c615114ca55b9cc94a1 ]

When cookie authentication is disabled, COOKIE-ECHO peer_addr is
attacker-controlled. An invalid sa_family made sctp_get_af_specific()
return NULL and crash in sctp_transport_init() on
af_specific->sockaddr_len. Validate it with af->addr_valid() in
sctp_unpack_cookie(), which also rejects a mismatched family, e.g.
an AF_INET6 peer_addr on an IPv4 socket that would later crash in
sctp_v6_get_dst() on inet6_sk(sk)->opt. Validate a copy of peer_addr,
since addr_valid() rewrites a v4-mapped v6 address in place and the
cookie still lives in the received skb, which is not guaranteed to
be unshared. Store the validated copy in the new association and
pass it to sctp_process_init() instead of the raw cookie, so a
v4-mapped v6 address is normalised to AF_INET before the association
and its primary transport are built from it.

For that, sctp_v6_addr_valid() has to return 0 for a non-v4-mapped
address when it is called with a socket that is not PF_INET6, so that
IPv6 addresses are never used on IPv4 sockets. The check is done after
the v4-mapped handling, so v4-mapped addresses passed to an IPv4
socket through the socket API keep being accepted. As addr_valid()
now also checks sk_family and ipv6_only_sock, simplify the address
handling in sctp_process_param() with it, as it additionally filters
out non-unicast addresses. As a side effect, a v4-mapped address in
an IPv6 address parameter is now normalised to AF_INET before the
transport is created, matching what the socket API paths already do.

Also add the missing !af check in sctp_process_init(), as
sctp_get_af_specific(AF_INET6) returns NULL on CONFIG_IPV6=n builds.

  BUG: KASAN: null-ptr-deref in sctp_transport_new+0xa7/0x350
  Read of size 4 at addr 00000000000000b4 by task poc/682
  Call Trace:
   <IRQ>
   sctp_transport_new+0xa7/0x350
   sctp_assoc_add_peer+0x153/0x850
   sctp_process_init+0xf9/0x1180
   sctp_sf_do_5_1D_ce+0x464/0xbc0
   sctp_do_sm+0x114/0x2990
   sctp_endpoint_bh_rcv+0x280/0x430
   sctp_inq_push+0xdd/0x100
   sctp_rcv+0x17f5/0x1ae0
   sctp4_rcv+0x2b/0x40
   ip_protocol_deliver_rcu+0x25b/0x270
   ip_local_deliver+0xd1/0xe0
   </IRQ>
  Kernel panic - not syncing: Fatal exception in interrupt

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xingyuan Mo <hdthky0@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20261019073747.178626-1-hdthky0@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/ipv6.c          |  6 +++++-
 net/sctp/sm_make_chunk.c | 24 +++++++++++++-----------
 net/sctp/sm_statefuns.c  |  2 +-
 3 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 28ea3a851862c..c20c116a30122 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -723,7 +723,8 @@ static int sctp_v6_available(union sctp_addr *addr, struct sctp_sock *sp)
  * SCTP.
  *
  * Output:
- * Return 0 - If the address is a non-unicast or an illegal address.
+ * Return 0 - If the address is a non-unicast or an illegal address,
+ *            or a non-v4-mapped address on a non-PF_INET6 socket.
  * Return 1 - If the address is a unicast.
  */
 static int sctp_v6_addr_valid(union sctp_addr *addr,
@@ -747,6 +748,9 @@ static int sctp_v6_addr_valid(union sctp_addr *addr,
 	if (!(ret & IPV6_ADDR_UNICAST))
 		return 0;
 
+	if (sp && sctp_opt2sk(sp)->sk_family != PF_INET6)
+		return 0;
+
 	return 1;
 }
 
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 6dae9831613ab..98a1942751634 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1760,7 +1760,9 @@ struct sctp_association *sctp_unpack_cookie(
 	__u8 *digest = ep->digest;
 	struct sctp_chunkhdr *ch;
 	unsigned int len, chlen;
+	union sctp_addr paddr;
 	enum sctp_scope scope;
+	struct sctp_af *af;
 	ktime_t kt;
 
 	/* Header size is static data prior to the actual cookie, including
@@ -1880,6 +1882,11 @@ struct sctp_association *sctp_unpack_cookie(
 		goto fail;
 	}
 
+	paddr = bear_cookie->peer_addr;
+	af = sctp_get_af_specific(paddr.sa.sa_family);
+	if (!af || !af->addr_valid(&paddr, sctp_sk(ep->base.sk), NULL))
+		goto malformed;
+
 	/* Make a new base association.  */
 	scope = sctp_scope(sctp_source(chunk));
 	retval = sctp_association_new(ep, ep->base.sk, scope, gfp);
@@ -1896,6 +1903,7 @@ struct sctp_association *sctp_unpack_cookie(
 
 	/* Populate the association from the cookie.  */
 	memcpy(&retval->c, bear_cookie, sizeof(*bear_cookie));
+	retval->c.peer_addr = paddr;
 
 	if (sctp_assoc_set_bind_addr_from_cookie(retval, bear_cookie,
 						 GFP_ATOMIC) < 0) {
@@ -2420,8 +2428,8 @@ int sctp_process_init(struct sctp_association *asoc, struct sctp_chunk *chunk,
 		    (param.p->type == SCTP_PARAM_IPV4_ADDRESS ||
 		     param.p->type == SCTP_PARAM_IPV6_ADDRESS)) {
 			af = sctp_get_af_specific(param_type2af(param.p->type));
-			if (!af->from_addr_param(&addr, param.addr,
-						 chunk->sctp_hdr->source, 0))
+			if (!af || !af->from_addr_param(&addr, param.addr,
+							chunk->sctp_hdr->source, 0))
 				continue;
 			if (sctp_cmp_addr_exact(sctp_source(chunk), &addr))
 				src_match = 1;
@@ -2593,17 +2601,11 @@ static int sctp_process_param(struct sctp_association *asoc,
 	 */
 	switch (param.p->type) {
 	case SCTP_PARAM_IPV6_ADDRESS:
-		if (PF_INET6 != asoc->base.sk->sk_family)
-			break;
-		goto do_addr_param;
-
 	case SCTP_PARAM_IPV4_ADDRESS:
-		/* v4 addresses are not allowed on v6-only socket */
-		if (ipv6_only_sock(asoc->base.sk))
-			break;
-do_addr_param:
 		af = sctp_get_af_specific(param_type2af(param.p->type));
-		if (!af->from_addr_param(&addr, param.addr, htons(asoc->peer.port), 0))
+		if (!af || !af->from_addr_param(&addr, param.addr,
+						htons(asoc->peer.port), 0) ||
+		    !af->addr_valid(&addr, sctp_sk(asoc->base.sk), NULL))
 			break;
 		scope = sctp_scope(peer_addr);
 		if (sctp_in_scope(net, &addr, scope))
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index b16bb0ebb552e..4670e6f570aba 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -814,7 +814,7 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
 	 * effects--it is safe to run them here.
 	 */
 	if (!sctp_process_init(new_asoc, chunk,
-			       &chunk->subh.cookie_hdr->c.peer_addr,
+			       &new_asoc->c.peer_addr,
 			       peer_init, GFP_ATOMIC))
 		goto nomem_init;
 
-- 
2.53.0



