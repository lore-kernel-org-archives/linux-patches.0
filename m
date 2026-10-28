Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214388;
	b=Z0ehza91YrVYJCOXGVYpsiDMcXp6mDMyr2vNf50oCoPtYPQjJI6H9GuDq2mvv+dPsjYM
	 0p2Pz9yKw6YGWhmku5oar62fHw4Iynzvl9lmYzoEOUZuSpuHJopoSSiRaEeP7YwAY//cX
	 89Z9b7DIJ0RRqTQqxtAu+zHKPjq75UVm7W24iPLssoQR0ZBkxjrSD+Nu5UyR+9Y7UljfU
	 PnR6BfZtPy4UMjVey+dEKVBwA5XGmr9SPz8KvOQh0iCwAWPIfEZNj1U8u9qUkhEeaesAn
	 GNKNSrwHcY1R0C18VauScaOUnCHgIq8R4Fy1UB3RethnHIwD5Ivn75m4lYCVqWNeoGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214388;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JtFZZ7BJ6IbfCY0guG/iTay/ZhVdeZ25dN5WrhA4eOY=;
	b=Y/e/boMoFijNwO4T03Su0ut018PubNuwwHETWluoNKASJe3SvBcmWlSXVjO54kheaQJP
	 mrod1PUNKFoyxo8aBZbYmOUGR+3hVpxeHEV4oYwL1kjaGPM9Mroam61ANKSZSBjOBh1VV
	 W681BVJ5pnA/LhohOvcLkEdw2oEGCXMnG6se51TWMZTVq6SQs9q3AqtNzNnmWT5FMEOKh
	 /jI0FcFrj3vRRx6qmLVJ9VorL4NkQzQ9kuzhokBmx2k9tVnLMt5RUaePUxfwUzYhqhs4L
	 LGXbhv5bMQTx+OiSsMzLOvMgN/8uUd2De4rgsJGrhNx7pEDTScyI91johFjJy51bVFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vdYvOGDI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757F860A2603;
	Wed, 28 Oct 2026 19:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vdYvOGDI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FC41F01825;
	Wed, 28 Oct 2026 19:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214388;
	bh=JtFZZ7BJ6IbfCY0guG/iTay/ZhVdeZ25dN5WrhA4eOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vdYvOGDIon7FxnVFG8/knByFZdUyO3H195qzsEEcIyIvJmd2rGktKtaUOu53aGOkL
	 vuZi8s8zYFxXsoHDRuv/35cpJfHZ1vKjDVGRESjQI2E+CbCCDrW+qMSwlUhHwTJbAG
	 LZ/Zh5ZWS7LblKcmw5uhllkkhNu0qEtMYUx2xoEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aakash Kumar S <saakashkumar@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0840/1887] xfrm: Duplicate SPI Handling
Date: Wed, 28 Oct 2026 17:48:56 +0100
Message-ID: <20261028170518.542755852@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Aakash Kumar S <saakashkumar@marvell.com>

[ Upstream commit 94f39804d891cffe4ce17737d295f3b195bc7299 ]

The issue originates when Strongswan initiates an XFRM_MSG_ALLOCSPI
Netlink message, which triggers the kernel function xfrm_alloc_spi().
This function is expected to ensure uniqueness of the Security Parameter
Index (SPI) for inbound Security Associations (SAs). However, it can
return success even when the requested SPI is already in use, leading
to duplicate SPIs assigned to multiple inbound SAs, differentiated
only by their destination addresses.

This behavior causes inconsistencies during SPI lookups for inbound packets.
Since the lookup may return an arbitrary SA among those with the same SPI,
packet processing can fail, resulting in packet drops.

According to RFC 4301 section 4.4.2 , for inbound processing a unicast SA
is uniquely identified by the SPI and optionally protocol.

Reproducing the Issue Reliably:
To consistently reproduce the problem, restrict the available SPI range in
charon.conf : spi_min = 0x10000000 spi_max = 0x10000002
This limits the system to only 2 usable SPI values.
Next, create more than 2 Child SA. each using unique pair of src/dst address.
As soon as the 3rd Child SA is initiated, it will be assigned a duplicate
SPI, since the SPI pool is already exhausted.
With a narrow SPI range, the issue is consistently reproducible.
With a broader/default range, it becomes rare and unpredictable.

Current implementation:
xfrm_spi_hash() lookup function computes hash using daddr, proto, and family.
So if two SAs have the same SPI but different destination addresses, then
they will:
a. Hash into different buckets
b. Be stored in different linked lists (byspi + h)
c. Not be seen in the same hlist_for_each_entry_rcu() iteration.
As a result, the lookup will result in NULL and kernel allows that Duplicate SPI

Proposed Change:
xfrm_state_lookup_spi_proto() does a truly global search - across all states,
regardless of hash bucket and matches SPI and proto.

Signed-off-by: Aakash Kumar S <saakashkumar@marvell.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 67 ++++++++++++++++++++++++++-----------------
 1 file changed, 41 insertions(+), 26 deletions(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index ecafa6950139f..6b4fa60de6d89 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1304,6 +1304,26 @@ struct xfrm_state *xfrm_state_lookup_byspi(struct net *net, __be32 spi,
 }
 EXPORT_SYMBOL(xfrm_state_lookup_byspi);
 
+static struct xfrm_state *xfrm_state_lookup_spi_proto(struct net *net, __be32 spi, u8 proto)
+{
+	struct xfrm_state *x;
+	unsigned int i;
+
+	rcu_read_lock();
+	for (i = 0; i <= net->xfrm.state_hmask; i++) {
+		hlist_for_each_entry_rcu(x, &net->xfrm.state_byspi[i], byspi) {
+			if (x->id.spi == spi && x->id.proto == proto) {
+				if (!xfrm_state_hold_rcu(x))
+					continue;
+				rcu_read_unlock();
+				return x;
+			}
+		}
+	}
+	rcu_read_unlock();
+	return NULL;
+}
+
 static void __xfrm_state_insert(struct xfrm_state *x)
 {
 	struct net *net = xs_net(x);
@@ -2091,10 +2111,8 @@ int xfrm_alloc_spi(struct xfrm_state *x, u32 low, u32 high)
 	unsigned int h;
 	struct xfrm_state *x0;
 	int err = -ENOENT;
-	__be32 minspi = htonl(low);
-	__be32 maxspi = htonl(high);
+	u32 range = high - low + 1;
 	__be32 newspi = 0;
-	u32 mark = x->mark.v & x->mark.m;
 
 	spin_lock_bh(&x->lock);
 	if (x->km.state == XFRM_STATE_DEAD)
@@ -2106,33 +2124,30 @@ int xfrm_alloc_spi(struct xfrm_state *x, u32 low, u32 high)
 
 	err = -ENOENT;
 
-	if (minspi == maxspi) {
-		x0 = xfrm_state_lookup(net, mark, &x->id.daddr, minspi, x->id.proto, x->props.family);
-		if (x0) {
-			xfrm_state_put(x0);
+	for (h = 0; h < range; h++) {
+		u32 spi = (low == high) ? low : low + prandom_u32_max(high - low + 1);
+		newspi = htonl(spi);
+
+		spin_lock_bh(&net->xfrm.xfrm_state_lock);
+		x0 = xfrm_state_lookup_spi_proto(net, newspi, x->id.proto);
+		if (!x0) {
+			x->id.spi = newspi;
+			h = xfrm_spi_hash(net, &x->id.daddr, newspi, x->id.proto, x->props.family);
+			hlist_add_head_rcu(&x->byspi, net->xfrm.state_byspi + h);
+			spin_unlock_bh(&net->xfrm.xfrm_state_lock);
+			err = 0;
 			goto unlock;
 		}
-		newspi = minspi;
-	} else {
-		u32 spi = 0;
-		for (h = 0; h < high-low+1; h++) {
-			spi = low + prandom_u32_max(high - low + 1);
-			x0 = xfrm_state_lookup(net, mark, &x->id.daddr, htonl(spi), x->id.proto, x->props.family);
-			if (x0 == NULL) {
-				newspi = htonl(spi);
-				break;
-			}
-			xfrm_state_put(x0);
-		}
-	}
-	if (newspi) {
-		spin_lock_bh(&net->xfrm.xfrm_state_lock);
-		x->id.spi = newspi;
-		h = xfrm_spi_hash(net, &x->id.daddr, x->id.spi, x->id.proto, x->props.family);
-		hlist_add_head_rcu(&x->byspi, net->xfrm.state_byspi + h);
+		xfrm_state_put(x0);
 		spin_unlock_bh(&net->xfrm.xfrm_state_lock);
 
-		err = 0;
+		if (signal_pending(current)) {
+			err = -ERESTARTSYS;
+			goto unlock;
+		}
+
+		if (low == high)
+			break;
 	}
 
 unlock:
-- 
2.53.0



