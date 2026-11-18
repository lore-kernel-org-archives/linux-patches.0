Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043936;
	b=LWT1LfhLw0iZxlcuj9kwHCHXvbo3sV3/4ivOn9BxaZuDTKX3btSpSgq+rxmoBsb9QIED
	 Bz41c5F66UBwZd9yV4xqppUTHChIbXzSnXat/vadtGPfiJ3q42TbEHyWGCTVQqkaKr8DM
	 Z40R1Ku9PKkQDK/630Pgze3GTDRLYJQ1OjMwFWX1vsZ+23WNhSJc7slntBksBLXsAiJtD
	 0dSY+CxJHJ4aJfTDlDIP8MeqX1+xPHZf7Jj+Kwd+VBr5CzKHNsnF0K67+2N/I6KXn1x+y
	 3aD7zyC7wg0/BXS4lxAjkKUWuyAMYXhtKKOoRJFBZd74u2FieLvDK3kSwuXTevBdTHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043936;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f9fv/5R+41pvLROqCdwywuLBQiTDqx/Lbb36ftRBu4A=;
	b=d06htJ6vHuXnA/KkesDJW+ZXOeOC5ppz8LmFu1vdrFkA/gGfY3VCpTywP21/MZNtJscW
	 vlqMZ2jVYjgGbg2Jt6cmxmFTmJyMco2YpDJdl8WnYL1DAV9PN4WYO/Z1+yCb2zsetmF3K
	 qb9y1Z3tjgxkJyzwvpYhUwnFm69+9XyuahWqg9zYiaGLH62M3DzZtCh7EMJSLph7hw35P
	 Sgchdoe743qHwegvmDp6EEzdAIjCX0LQBtwZCl2A9zIi9d2496mptBAn/yTfiEyo3lcHW
	 Blv5ABcJatYXWejlAJEM5j4+0fYHt9gm1N584Xw2g3n+++L8AipeKd4z6ksWrynXccQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O6bfn5cz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62743606A32F;
	Wed, 18 Nov 2026 23:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O6bfn5cz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87421F000C4;
	Wed, 18 Nov 2026 23:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043936;
	bh=f9fv/5R+41pvLROqCdwywuLBQiTDqx/Lbb36ftRBu4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O6bfn5czmd/2E8onF0IAfVBmRN+oP35RC7oc3bgBU9SHuWUO1vLDF6DwPFzvKKwCy
	 il+uhmZkXfDPIqRDJQFbG51NkPvvElACI7d2puKLq5xXYkCCUzaxN59RLtzxlEBEPp
	 tAvAqWRIQR16fkmX7Cfcm+zT/Gn5cJMFmnpQH/D8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0388/2857] xfrm: save input state data before secpath resets
Date: Wed, 18 Nov 2026 15:23:42 +0100
Message-ID: <20261118150215.371680063@linuxfoundation.org>
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

From: Zhiling Zou <zhilinz@nebusec.ai>

[ Upstream commit 3cf5cdecd99c9c186a5ea518d93bbf3045b6e3aa ]

xfrm_input() stores the current xfrm_state in the skb secpath while it
continues receive-side processing. Some input paths can reset that secpath
before xfrm_input() has finished dereferencing the state.

Receive callback users such as VTI and XFRM interfaces can reset the
secpath. The VTI receive path does so before checking whether the packet
crosses network namespaces, while the XFRM interface path does so only for
cross-network-namespace packets. The XFRM_MAX_DEPTH error path can also
reset the secpath before the final drop callback reports the current
state's protocol.

If secpath_reset() drops the last state reference while the state is
concurrently deleted, xfrm_input() can still dereference the freed state
when selecting transport_finish() or reporting the drop callback protocol.

Save the state protocol on the stack while the state is still valid,
and use the already saved address family for transport_finish(). A larval
XFRM_STATE_ACQ state has no type, so retain nexthdr as its protocol. This
preserves the existing drop-path fallback while avoiding the post-reset
state dereferences without adding an extra state reference to every
received packet.

Fixes: df3893c176e9 ("vti: Update the ipv4 side to use it's own receive hook.")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
[ sashal: Dropped the hunk for the missing x->dir check, and kept the older xfrm_rcv_cb, transport_finish and drop code (no RCU wrapper, skb->dev) while only swapping in the saved xfrm_proto and family. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_input.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index b39bb4662d4b2..fb7c992ed91b7 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -462,6 +462,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 	struct xfrm_state *x = NULL;
 	xfrm_address_t *daddr;
 	u32 mark = skb->mark;
+	u8 xfrm_proto = nexthdr;
 	unsigned int family = AF_UNSPEC;
 	int decaps = 0;
 	int async = 0;
@@ -472,6 +473,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 
 	if (encap_type < 0 || (xo && (xo->flags & XFRM_GRO || encap_type == 0))) {
 		x = xfrm_input_state(skb);
+		xfrm_proto = x->type ? x->type->proto : nexthdr;
 
 		if (unlikely(x->km.state != XFRM_STATE_VALID)) {
 			if (x->km.state == XFRM_STATE_ACQ)
@@ -572,11 +574,13 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 
 		x = xfrm_state_lookup(net, mark, daddr, spi, nexthdr, family);
 		if (x == NULL) {
+			xfrm_proto = nexthdr;
 			secpath_reset(skb);
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMINNOSTATES);
 			xfrm_audit_state_notfound(skb, family, spi, seq);
 			goto drop;
 		}
+		xfrm_proto = x->type ? x->type->proto : nexthdr;
 
 		skb->mark = xfrm_smark_get(skb->mark, x);
 
@@ -695,7 +699,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 		crypto_done = false;
 	} while (!err);
 
-	err = xfrm_rcv_cb(skb, family, x->type->proto, 0);
+	err = xfrm_rcv_cb(skb, family, xfrm_proto, 0);
 	if (err)
 		goto drop;
 
@@ -718,7 +722,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 
 		err = -EAFNOSUPPORT;
 		rcu_read_lock();
-		afinfo = xfrm_state_afinfo_get_rcu(x->props.family);
+		afinfo = xfrm_state_afinfo_get_rcu(family);
 		if (likely(afinfo))
 			err = afinfo->transport_finish(skb, xfrm_gro || async);
 		rcu_read_unlock();
@@ -742,7 +746,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 drop:
 	if (async)
 		dev_put(skb->dev);
-	xfrm_rcv_cb(skb, family, x && x->type ? x->type->proto : nexthdr, -1);
+	xfrm_rcv_cb(skb, family, xfrm_proto, -1);
 	kfree_skb(skb);
 	return 0;
 }
-- 
2.53.0



