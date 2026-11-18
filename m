Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051635;
	b=Hdb+rrsbKSLdzlbvFFmJr22FZ1DsUQGroztVDZy4Lws/H9goSqcLsgksSpVZaxrmrkqO
	 M0U21fSz65yjqn8EXRYnUggwQr3nWcilZSohd4B06/FvzJXbifEmvNYDu5UtTG1ApquTN
	 OcHXQSZWrUWU0rnKTH7DUcFlhy3emcbXre1OymTdcBZ+vcnC/lNO1F6u7DAU3AZNj+hqZ
	 e6TVoOYcQF3IOdtikgLF0QUO0AVdqVUrTWQnvSTlMx+YPmQVHExa2PMyrPqZBAjxkh/s+
	 W4NO68ZnoVWKf1EitDSEQlDIUFzlecoktTUrlWtsYI7pkZ0zJzgJXPW4a3a/rXsFgdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051635;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xrvg19PX9YKW0pCokvdfnUMutvcwOPN2Z56pilcB7yg=;
	b=S2U+eHOIptL6xo5RfhB2Hr46OGdfVzOGhc4gysdU4AkJUYCzpA5WQSbGLPZoM7FGhsUc
	 7KWEXD2AeHvWZbMgpv8La1+FSFGnP3ZVTyExklgA5z4r9AosvEOJvIuymW6P+Va1gkE5i
	 1PnHfwz2a8k5mlG3rccr0zYOPQGq6Fu1Q3+W4iQx1pnPVY1POHGP48W4KWc57cecpKymW
	 jXx6Z93wQgf6YXcpSNM9RZqs7aT7pgjioD/c8hDxZ70x6OkR7nQ1rTw1pPzgEVwcgGWPa
	 xSMhf7ee4wpBQpZrVx8+xmB3UDEN+26rnojPJt92FwNAt3aKa52TvOiW3Yf96JASsnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JolveXwU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F97D606A332;
	Thu, 19 Nov 2026 01:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JolveXwU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 687171F000C8;
	Thu, 19 Nov 2026 01:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051634;
	bh=Xrvg19PX9YKW0pCokvdfnUMutvcwOPN2Z56pilcB7yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JolveXwUxx4ZrVvlJjWib991eDP8l1K+qHbR3rheQ0qSI7IP1uQ6yAwbMXL+V8Chp
	 RD+NwmoJejXG8CEeochz/oRohxn1425Nm8r2C9P8JwjKKPy4Or2H+SOlr89wJ8T4I9
	 GvbnrbIfeCVrsqld0NwIWdNqY/ssvj6QdS3i4Ndc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiming Cheng <shiming.cheng@mediatek.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Harshvardhan Jha <harshvardhan.j.jha@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0278/2214] net: gro: fix double aggregation of flush-marked skbs
Date: Wed, 18 Nov 2026 15:32:34 +0100
Message-ID: <20261118150021.182563117@linuxfoundation.org>
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

From: Shiming Cheng <shiming.cheng@mediatek.com>

[ Upstream commit e751256486d0ded20f5a9f9863467f1dce65142f ]

Commit 0ab03f353d36 ("net-gro: Fix GRO flush when receiving a GSO
packet.") added a flush check to skb_gro_receive(), but
skb_gro_receive_list() lacks the same validation.

As a result, packets marked with NAPI_GRO_CB(skb)->flush may still be
re-aggregated.

This allows already-GRO'd packets with existing frag_list to be
re-aggregated into a new GRO session, corrupting the frag_list chain
structure. When skb_segment() attempts to unpack these malformed packets,
it encounters invalid state and triggers a kernel panic.

Scenario (Tethering/Device forwarding):
  1. Driver: Generated aggregated packet P1 via LRO with frag_list
  2. Dev A: Receives aggregated fraglist packet and flush flag set
  3. Dev A: Re-enters GRO, skb_gro_receive_list() is called
  4. Missing flush check allows re-aggregation despite flush flag
  5. Frag_list chain becomes corrupted (loops or dangling refs)
  6. Dev B: TX path calls skb_segment(), crashes on corrupted frag_list

Root cause in skb_segment():
  The check at line ~4891:
    if (hsize <= 0 && i >= nfrags && skb_headlen(list_skb) &&
        (skb_headlen(list_skb) == len || sg)) {

  When frag_list is corrupted by double aggregation, when list_skb is
  a NULL pointer from skb->next, skb_headlen(list_skb) dereference
  NULL/corrupted pointers occurs.

Call Trace:
 skb_headlen(NULL skb)
 skb_segment
 tcp_gso_segment
 tcp4_gso_segment
 inet_gso_segment
 skb_mac_gso_segment
 __skb_gso_segment
 skb_gso_segment
 validate_xmit_skb
 validate_xmit_skb_list
 sch_direct_xmit
 qdisc_restart
 __qdisc_run
 qdisc_run
 net_tx_action

Fix: Add NAPI_GRO_CB(skb)->flush validation to the early-return check in
skb_gro_receive_list(), matching the defensive programming pattern of
skb_gro_receive().

Fixes: 3a1296a38d0c ("net: Support GRO/GSO fraglist chaining.")
Cc: stable@vger.kernel.org
Signed-off-by: Shiming Cheng <shiming.cheng@mediatek.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260709014704.3625-1-shiming.cheng@mediatek.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[Harshvardhan Jha: Apply the flush guard in net/core/skbuff.c, where 5.15 keeps this helper]
Signed-off-by: Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 6e2242b2830ff..2a1aaed462645 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4005,7 +4005,9 @@ EXPORT_SYMBOL_GPL(skb_segment_list);
 
 int skb_gro_receive_list(struct sk_buff *p, struct sk_buff *skb)
 {
-	if (unlikely(p->len + skb->len >= 65536))
+	/* make sure to check flush flag and to not merge */
+	if (unlikely(p->len + skb->len >= 65536 ||
+		     NAPI_GRO_CB(skb)->flush))
 		return -E2BIG;
 
 	if (NAPI_GRO_CB(p)->last == p)
-- 
2.53.0



