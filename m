Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051618;
	b=0eUgxb78a4EVP3duoQ4eUwYJC/otaX0lykRRclDXcB3ZwVQTUGZl7tmEAvAxGJd5vidP
	 bnHDw8lx9DqUzOqynQDs/S+CHaRjHdnB/G0j6T5xNvdpXUYYyz66gaKC7OslW48bq3FkW
	 Qs5oIAFRGjtHG3eag3GYhMLZJZtANE1hdXkX0qJzDjmEbLjm+M97INfSUljhMGOWitP2S
	 lVZSXa/CGb5sLO/L1WgsEVo7wr6jaToYgU0r/M8Gx4/rHQrqHkQHPJpyiXv76WDLXnZUq
	 TLLkyKZUeQVPSRdhOTW/yLlVebg2YYzjmmCUGLybRoX1y77W+6W8jv96TDLUBpO36SA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051618;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TAfbWDu8cu2ckE0lhMHBjwwcm6BBIik5JXFsmhXsDRY=;
	b=qD9AoXPpdAAkgjYdWDVCZAIddhFolLhzU3aHiwfmMV9eQtlIySwJGvHZrpwgqiqocIL8
	 P+1CS8JOjZ6pCmm9CuJMttNQVLieNMFPpGHsVfyWxBjJ+oFUMDnWL0VCGG01qjzvmodK+
	 kl8IfWBsckmSOvrSGJ3TKMqZpHIU258vrUQG/wvARR+vVxOKAJaxvSCEWCqU8tI4RSSgF
	 Zn4p7somwZkJHeZLlkIdtsbM8A8Sv02cSMZq7eRXHbiOaKom++MNDR3FgF14P5VQGWnk7
	 z0hatu8Q7iQ7t2h0H22miwXCkpRt5zFr9ojFok6cf0ZRuRzFa0WfcFzpksiOUZhEeSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JcVvjHFK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447ED606A31C;
	Thu, 19 Nov 2026 01:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JcVvjHFK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 984301F000C4;
	Thu, 19 Nov 2026 01:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051618;
	bh=TAfbWDu8cu2ckE0lhMHBjwwcm6BBIik5JXFsmhXsDRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JcVvjHFKRe638Y9gEav2R8NHHSHv0daMdvC/2wS9m+pJTsaD6HWO9Mf+NqYT2Ba2U
	 s4tmzspIadvi/63hwGTdyrLNETrYCH3NtiA0NKoGvZ8c4AxgkHEppdryyxL5Zg6riL
	 OHwg3ajfmEzqaukHtHPUiVWEAZV5PVDfBWSoQPGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Anand Khoje <anand.a.khoje@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0273/2214] net: dst: introduce dst->dev_rcu
Date: Wed, 18 Nov 2026 15:32:29 +0100
Message-ID: <20261118150020.993154933@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit caedcc5b6df1b2e2b5f39079e3369c1d4d5c5f50 ]

Followup of commit 88fe14253e18 ("net: dst: add four helpers
to annotate data-races around dst->dev").

We want to gradually add explicit RCU protection to dst->dev,
including lockdep support.

Add an union to alias dst->dev_rcu and dst->dev.

Add dst_dev_net_rcu() helper.

Fixes: 4a6ce2b6f2ec ("net: introduce a new function dst_dev_put()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250828195823.3958522-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

(cherry picked from commit caedcc5b6df1b2e2b5f39079e3369c1d4d5c5f50)

Conflicts:
 - Use 5.15 dev_hold/dev_put; retain the global IPv4 MSS limit

Signed-off-by: Anand Khoje <anand.a.khoje@oracle.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/dst.h | 16 +++++++++++-----
 net/core/dst.c    |  2 +-
 net/ipv4/route.c  |  2 +-
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/include/net/dst.h b/include/net/dst.h
index 9a23986f1071a..6b63c3435bb5a 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -23,7 +23,10 @@
 struct sk_buff;
 
 struct dst_entry {
-	struct net_device       *dev;
+	union {
+		struct net_device       *dev;
+		struct net_device __rcu *dev_rcu;
+	};
 	struct  dst_ops	        *ops;
 	unsigned long		_metrics;
 	unsigned long           expires;
@@ -556,9 +559,12 @@ static inline void skb_dst_update_pmtu_no_confirm(struct sk_buff *skb, u32 mtu)
 
 static inline struct net_device *dst_dev_rcu(const struct dst_entry *dst)
 {
-	/* In the future, use rcu_dereference(dst->dev) */
-	WARN_ON_ONCE(!rcu_read_lock_held());
-	return READ_ONCE(dst->dev);
+	return rcu_dereference(dst->dev_rcu);
+}
+
+static inline struct net *dst_dev_net_rcu(const struct dst_entry *dst)
+{
+	return dev_net_rcu(dst_dev_rcu(dst));
 }
 
 static inline struct net_device *skb_dst_dev_rcu(const struct sk_buff *skb)
@@ -583,7 +589,7 @@ static inline struct net *skb_dst_dev_net(const struct sk_buff *skb)
 
 static inline struct net *skb_dst_dev_net_rcu(const struct sk_buff *skb)
 {
-	return dev_net_rcu(skb_dst_dev(skb));
+	return dev_net_rcu(skb_dst_dev_rcu(skb));
 }
 
 struct dst_entry *dst_blackhole_check(struct dst_entry *dst, u32 cookie);
diff --git a/net/core/dst.c b/net/core/dst.c
index 8707b7ffe4210..4376f04ac5145 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -151,7 +151,7 @@ void dst_dev_put(struct dst_entry *dst)
 		dst->ops->ifdown(dst, dev, true);
 	WRITE_ONCE(dst->input, dst_discard);
 	WRITE_ONCE(dst->output, dst_discard_out);
-	WRITE_ONCE(dst->dev, blackhole_netdev);
+	rcu_assign_pointer(dst->dev_rcu, blackhole_netdev);
 	dev_hold(dst->dev);
 	dev_put(dev);
 }
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index b444a57498c2c..92c70648651b3 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1077,7 +1077,7 @@ static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
 		return;
 
 	rcu_read_lock();
-	net = dev_net_rcu(dst_dev(dst));
+	net = dst_dev_net_rcu(dst);
 	if (mtu < net->ipv4.ip_rt_min_pmtu) {
 		lock = true;
 		mtu = min(old_mtu, net->ipv4.ip_rt_min_pmtu);
-- 
2.53.0



