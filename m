Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044150;
	b=GBDc3lf6h5zjNvpey4uVQ6EqIy0x7J0WbOEr4RDyNp03gB602BjaO0UEBuV2XXmWbzCW
	 SuRV92aFi/nt4wib4nwXN+X8v2YusO14S7qe5JuxZRn0JGl3+jzBzag9ocKH7o+ArKUYQ
	 0UpLZ5D+if9b0jVvSxOoHJaymCh01seU1vN6I0snFsE5IePxhyc361ap+VP/YFUlQIRmn
	 NDvEBTolOENU+qY+cPZ+gEUaZcV5XoqliCmHqXXl2bkJpqVmL4CheWsmPAyLZVbIx7Fm1
	 8zwMuVyXFuP2R6mNm1yq7G3OT0ARWYo4iiyVVdgCKIBnCf3gSCnLMdK5wu3UC8GgFpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044150;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zOB2kMl2MxWDeSAc/5sh4TLIiVzM37p4AurFeXZ06j0=;
	b=yCk8F5drz6+j2eCF12YVOWJYBqCWZ/BKsCOMUdG8PEruEGE4vV98GPQNqvIKSCR8MDt9
	 p1CLQN2R6PPs3r0lXh4kdcbEie7lRPy1kVC9QrrF4T7amfzZ9fCz/ufYFrEQPk/jhbg9z
	 UwZ0tRpdFw0I6RhildIC0yH01UyikxHJO2zxpAcFfLuyAkzmZIgrBWt8xEgjgmxAhq/NR
	 JotT3P8Kl9uhiMtDiuBQ9oIX9MjB70sQwNL6+OnEoELllwUt9OeP4m2/fmgzEFruWoovT
	 tAenvNEuKLTCadSKmin205NPWSXN3pMYngGJg7KZHOKXql1aj+BchcQFTE3cew8AHNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rbmTpEIe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECD0606A320;
	Wed, 18 Nov 2026 23:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rbmTpEIe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02691F000C4;
	Wed, 18 Nov 2026 23:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044150;
	bh=zOB2kMl2MxWDeSAc/5sh4TLIiVzM37p4AurFeXZ06j0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rbmTpEIeqGjKQrAh/S7P8Jwd9VOD+cPUD+t0hF000vuFMUMdforhv7+1gnn/7f8MQ
	 7ytBGtmBiko0vo9LWxvvca+9l6yeB/RvFD4Cvvhmsw/mqYcnwbYHfwor63EWC0TAFj
	 XrWvJf1GT6Ryan9xtpRjzqi/35ZknFZlpgQOpFXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0462/2857] net: mctp: Add some detail on the key allocation implementation
Date: Wed, 18 Nov 2026 15:24:56 +0100
Message-ID: <20261118150218.059247680@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeremy Kerr <jk@codeconstruct.com.au>

[ Upstream commit aee6479a458e2c5027e558cfe26c60c37f8efc80 ]

We could do with a little more comment on where MCTP_ADDR_ANY will match
in the key allocations.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 26cc0e69cce0 ("mctp: route: iterate socket tag list in mctp_lookup_prealloc_tag()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/route.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index cbcf5ecec93bb..7235467f11021 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -73,6 +73,40 @@ static struct mctp_sock *mctp_lookup_bind(struct net *net, struct sk_buff *skb)
 	return NULL;
 }
 
+/* A note on the key allocations.
+ *
+ * struct net->mctp.keys contains our set of currently-allocated keys for
+ * MCTP tag management. The lookup tuple for these is the peer EID,
+ * local EID and MCTP tag.
+ *
+ * In some cases, the peer EID may be MCTP_EID_ANY: for example, when a
+ * broadcast message is sent, we may receive responses from any peer EID.
+ * Because the broadcast dest address is equivalent to ANY, we create
+ * a key with (local = local-eid, peer = ANY). This allows a match on the
+ * incoming broadcast responses from any peer.
+ *
+ * We perform lookups when packets are received, and when tags are allocated
+ * in two scenarios:
+ *
+ *  - when a packet is sent, with a locally-owned tag: we need to find an
+ *    unused tag value for the (local, peer) EID pair.
+ *
+ *  - when a tag is manually allocated: we need to find an unused tag value
+ *    for the peer EID, but don't have a specific local EID at that stage.
+ *
+ * in the latter case, on successful allocation, we end up with a tag with
+ * (local = ANY, peer = peer-eid).
+ *
+ * So, the key set allows both a local EID of ANY, as well as a peer EID of
+ * ANY in the lookup tuple. Both may be ANY if we prealloc for a broadcast.
+ * The matching (in mctp_key_match()) during lookup allows the match value to
+ * be ANY in either the dest or source addresses.
+ *
+ * When allocating (+ inserting) a tag, we need to check for conflicts amongst
+ * the existing tag set. This requires macthing either exactly on the local
+ * and peer addresses, or either being ANY.
+ */
+
 static bool mctp_key_match(struct mctp_sk_key *key, mctp_eid_t local,
 			   mctp_eid_t peer, u8 tag)
 {
@@ -386,6 +420,9 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 			 * key lookup to find the socket, but don't use this
 			 * key for reassembly - we'll create a more specific
 			 * one for future packets if required (ie, !EOM).
+			 *
+			 * this lookup requires key->peer to be MCTP_ADDR_ANY,
+			 * it doesn't match just any key->peer.
 			 */
 			any_key = mctp_lookup_key(net, skb, MCTP_ADDR_ANY, &f);
 			if (any_key) {
-- 
2.53.0



