Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037437;
	b=KEPgRWzqC1e7khMVhcaLBkVwfzRov11OW/draC5BXa4Z0LNOKzDHPlTwXhdW+S3i1+dl
	 5xIEkLnEzqkJ6o1Pn6+mZyaTXaLdl6Nw4jYjnGbmvVHBZhcT73PxnHtc381W+0Njug44b
	 Y1iBlRcJQGNh5tGU5qf9I28R68QOQAo3zJYMfNPUazrCvQ2qfjTRCtxMPWWn1+Arq0UGt
	 6E179Hs0Wdb9QDzbA1mhm+5ahCzaA+0vOFRNFpA6bWa3sKmol2ZQf4afX1rtdjCgtDR71
	 /J5HJer/pC+WUnCG8SxzNr3+cB01hOOfqmd0vrBr+L/VPpE6ntQ63kFPaDtIFIBkpKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037437;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VVIpXGd8AYtw7ZyjGdDkWJdczvNhIbXtHYujakAt8Js=;
	b=E8iYQmw7rN6QN1Z493e4p95uJt/w8FTafE5kA1McVKEfoa1nghRZGkEKM7sGC75zxXPP
	 HIO8zgig+R/fBkUMVRTpfuzKbwziBSWpdpY7WBFnWW3pWLo6WjaV90SIFgn0VvtqoFVFC
	 jztUNi0jFcaSqIFaEF1M3bUkSZ7aIkgikDZXZMJJK4KLaGULK7/9+OmNi1oTfxQRghAco
	 k2rZUHXu0fsac0tccQD/MIsYlwuF7JL+8/PDk66zjfMAo9DAUYl9hiJ4Ehb6dN1mTxpxQ
	 qgdV0uBHY2RZsxIUZ5nQ4lyjDyg4F92CncxkwPUnhxfMx/LXapnKAXJASckjpu5qk/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="oP4sh/A0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB85C606A32C;
	Wed, 18 Nov 2026 21:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oP4sh/A0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3138D1F000C4;
	Wed, 18 Nov 2026 21:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037436;
	bh=VVIpXGd8AYtw7ZyjGdDkWJdczvNhIbXtHYujakAt8Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oP4sh/A0uiO/oRh4GHz8+Rjrm1qEWAqXtQc8xLA4I0v06L7DKlWY6bh0P8JeeBXHG
	 hS/JhWes91QmTqP2xBQMfoJQ9RhZ8vpBsqhVmtbOpcu1213SdjL7L/IPwh8nWXaXyz
	 SX5UBzZr3GaqdRs10cmM+66AVN1VGlKsYZnyJbBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Ido Schimmel <idosch@nvidia.com>,
	Naman Gulati <namangulati@google.com>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1399/3318] ipmr: drop packets with unknown ingress VIF
Date: Wed, 18 Nov 2026 15:33:41 +0100
Message-ID: <20261118150402.576455921@linuxfoundation.org>
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

From: Zhiling Zou <zhilinz@nebusec.ai>

[ Upstream commit 09280680f2ea060514be2a39ea84209fb6d721d4 ]

A packet can race with VIF publication and make ipmr_find_vif() return
-1 even though the VIF device pointer is already visible. The parent VIF
device check can then pass with an invalid ingress VIF. For (*,G)
entries, this can also let the packet be forwarded back out its ingress
VIF.

Drop packets whose ingress VIF lookup fails in both IPv4 and IPv6
forwarding, before checking the MFC parent device. This prevents
forwarding with an unknown ingress VIF and avoids the (*,G) hairpin.

Without the early check, the negative index can reach the IPv4 offload
lookup only for an skb marked for L3 forwarding offload, currently done
by mlxsw. The race is rare; the supplied PoC reports only the UBSAN
negative-index diagnostic.

Fixes: 4eadb88244d1 ("ipmr: do not acquire mrt_lock while calling ip_mr_forward()")
Fixes: 9b1c21d898fd ("ip6mr: do not acquire mrt_lock while calling ip6_mr_forward()")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Link: https://lore.kernel.org/netdev/b966eb102e98f299e45be59ada033a8766e4c6df.1791899747.git.zhilinz@nebusec.ai/
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Suggested-by: Naman Gulati <namangulati@google.com>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Reviewed-by: Naman Gulati <namangulati@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/5271fcb94a4d9e697ed64a348e92ea9e74faab1c.1792608753.git.zhilinz@nebusec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ipmr.c  | 3 ++-
 net/ipv6/ip6mr.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 587fa6b1f9b92..edd2413edff99 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1990,7 +1990,8 @@ static void ip_mr_forward(struct net *net, struct mr_table *mrt,
 	}
 
 	/* Wrong interface: drop packet and (maybe) send PIM assert. */
-	if (rcu_access_pointer(mrt->vif_table[vif].dev) != dev) {
+	if (true_vifi < 0 ||
+	    rcu_access_pointer(mrt->vif_table[vif].dev) != dev) {
 		if (rt_is_output_route(skb_rtable(skb))) {
 			/* It is our own packet, looped back.
 			 * Very complicated situation...
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 1724d50c50fd8..38446928f1c45 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -2149,7 +2149,8 @@ static void ip6_mr_forward(struct net *net, struct mr_table *mrt,
 	/*
 	 * Wrong interface: drop packet and (maybe) send PIM assert.
 	 */
-	if (rcu_access_pointer(mrt->vif_table[vif].dev) != dev) {
+	if (true_vifi < 0 ||
+	    rcu_access_pointer(mrt->vif_table[vif].dev) != dev) {
 		atomic_long_inc(&c->_c.mfc_un.res.wrong_if);
 
 		if (true_vifi >= 0 && mrt->mroute_do_assert &&
-- 
2.53.0



