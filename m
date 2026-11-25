Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618553;
	b=1iGD9diHh47vVDIswfxysJnxNU2dwakS9H3OrkFQU27bQA8nG5eycftxKCqErd++SWW7
	 fpDnaoTj5HOaYjIi5BZlTATdI5BW6/DWN/8+HOj943/bt1onXbB2QhrvwiyGSTMG/pIs8
	 0hRvks40dPFK2g23wevgK5sEdWIkQvTYHPPh/ULDiT3hXzCCMzxaAJdJrehbKhHsTUvbl
	 V9TqrSds7HP8Qbcr/EohVmoGmX27HG8kB/2MPWlD1IllWFkycW/LdgZStFfMVcuo8LPva
	 YK8kTvFt7a9/mVecgc9ORuDg6pUpXDm/iIvjRcwOL5J/ukPLCJMr4lkd1paF2Z/ExpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618553;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ne5M5S1efGjW2C3yrm17XX/ZGwmA5s1h7Zh+NCLLkXI=;
	b=xHq47l3+SgViVTsiuNExRsIGbYipc6imeZuN/hAht0Q6LKEYn2g7Z/6HF6plll49h0me
	 LIJKVvXyXBWHegl3BkiT5TldLGWcUT1xVj9hzU7HW2Kqia6Y4gzAjDi1QVKNcFOg7q6Y1
	 1vjWTTBEb63gFvq2McRI5JZS0BNPzXNUdjqK1VFCDFJ3l0tb47fbQzak+ZXU4F4dHx6A/
	 Q8n4igXP4AXxqzbAPGP6xLlACDq7sHW6hU2aOp86Q2UTPmwl20eQmwlJ8YI4aSNNPqqvC
	 We/Bo28dK5RbcXbSZEoS86dU6MAvLK/bI/UNIYlLbUIe979t56UF/b0DI1l1aqI9+Nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BPyNDpgz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E00606A321;
	Wed, 25 Nov 2026 14:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BPyNDpgz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21EEB1F000CF;
	Wed, 25 Nov 2026 14:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618552;
	bh=ne5M5S1efGjW2C3yrm17XX/ZGwmA5s1h7Zh+NCLLkXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BPyNDpgz+WVxcsFJbI/RdHXb6k8jsh80ow/n5FSJiPYwziv0ktXMDD4/Fsb+pmwvT
	 WLXDLu5eFGDgCPCT02gxtKbkH9831emLW9V1SZ/0mk8V5qKDft4J/7Xw1YQw1h20VP
	 Nw9tO+idvIu5EpdfDgI2VnGGt7tiDurMJsJeOpHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0309/1005] ip6mr: Serialize multicast router socket ownership
Date: Wed, 25 Nov 2026 15:27:27 +0100
Message-ID: <20261125143828.974404880@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit c6b41de4dd9f2d6856d8d8d292348f7961034152 ]

MRT6_TABLE checks whether the socket owns its current table before
acquiring RTNL. MRT6_INIT also looks up its table before taking RTNL.
Consequently, concurrent TABLE and INIT calls can initialize the old
table and then change the socket's selected table. Another INIT can
register the same socket in the new table.

rawv6_close() calls ip6mr_sk_done(), which clears only the first table
owned by the socket. After the socket's RCU-delayed free, the other
table retains a dangling mroute_sk pointer. A subsequent multicast cache
report passes that pointer to sock_queue_rcv_skb_reason(). This produces
a KASAN slab-use-after-free in sk_filter_trim_cap().

Look up the selected table in ip6mr_sk_init() after acquiring RTNL.
Likewise, re-read the current table and check its owner under RTNL in
MRT6_TABLE before updating the selection. This preserves the single-table
ownership invariant shared with ip6mr_sk_done(), without changing the
locking of the other multicast socket options.

Fixes: d1db275dd3f6 ("ipv6: ip6mr: support multiple tables")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20261030042221.73996-1-kylebot@openai.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6mr.c | 36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 6465ed11a0b53..fff0a16ad11f6 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1621,12 +1621,20 @@ static void mroute_clean_tables(struct mr_table *mrt, int flags,
 	}
 }
 
-static int ip6mr_sk_init(struct mr_table *mrt, struct sock *sk)
+static int ip6mr_sk_init(struct sock *sk)
 {
-	int err = 0;
 	struct net *net = sock_net(sk);
+	struct mr_table *mrt;
+	int err = 0;
 
 	rtnl_lock();
+	mrt = __ip6mr_get_table(net,
+				raw6_sk(sk)->ip6mr_table ? : RT6_TABLE_DFLT);
+	if (!mrt) {
+		err = -ENOENT;
+		goto out_unlock;
+	}
+
 	spin_lock(&mrt_lock);
 	if (rtnl_dereference(mrt->mroute_sk)) {
 		err = -EADDRINUSE;
@@ -1642,6 +1650,7 @@ static int ip6mr_sk_init(struct mr_table *mrt, struct sock *sk)
 					     NETCONFA_MC_FORWARDING,
 					     NETCONFA_IFINDEX_ALL,
 					     net->ipv6.devconf_all);
+out_unlock:
 	rtnl_unlock();
 
 	return err;
@@ -1743,7 +1752,7 @@ int ip6_mroute_setsockopt(struct sock *sk, int optname, sockptr_t optval,
 		if (optlen < sizeof(int))
 			return -EINVAL;
 
-		return ip6mr_sk_init(mrt, sk);
+		return ip6mr_sk_init(sk);
 
 	case MRT6_DONE:
 		return ip6mr_sk_done(sk);
@@ -1870,16 +1879,21 @@ int ip6_mroute_setsockopt(struct sock *sk, int optname, sockptr_t optval,
 		/* "pim6reg%u" should not exceed 16 bytes (IFNAMSIZ) */
 		if (v != RT_TABLE_DEFAULT && v >= 100000000)
 			return -EINVAL;
-		if (sk == rcu_access_pointer(mrt->mroute_sk))
-			return -EBUSY;
-
 		rtnl_lock();
 		ret = 0;
-		mrt = ip6mr_new_table(net, v);
-		if (IS_ERR(mrt))
-			ret = PTR_ERR(mrt);
-		else
-			raw6_sk(sk)->ip6mr_table = v;
+		mrt = __ip6mr_get_table(net,
+					raw6_sk(sk)->ip6mr_table ? : RT6_TABLE_DFLT);
+		if (!mrt) {
+			ret = -ENOENT;
+		} else if (sk == rtnl_dereference(mrt->mroute_sk)) {
+			ret = -EBUSY;
+		} else {
+			mrt = ip6mr_new_table(net, v);
+			if (IS_ERR(mrt))
+				ret = PTR_ERR(mrt);
+			else
+				raw6_sk(sk)->ip6mr_table = v;
+		}
 		rtnl_unlock();
 		return ret;
 	}
-- 
2.53.0



