Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215683;
	b=yjn41rPxHWt6VmP13j47DsciBZU6atcuh99tyUTXVWJfkezKKWzMHhWAeW80fcyQQck+
	 islDKPL8DeHymLP84IvB/t6JYamTcdOLbqhHMYPxmMNwKkL/6n+zBu3yzSsL4o+5OWP+k
	 x0MzGWtcAWZFN9LTkI3KhT0uIgXPRU2JwjubWZxhrZkpmEZg412qchxDhOOgRHY+h5P6p
	 GP03P7uyAgryZVfUJmxB+WHTOEDQVZZePtpKTlLRQFO5CRcMssgM6dycmUQokaEVx7q6I
	 M5C+a9J6VjerGP5uWiAoUVV+CxBnzyQnL9n7GgiXtvuw8I94UwdbFCRKunHdfCL0aTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215683;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=SdccJliOHz9ocDBBdCBL7YcGJenqaKQigERL57z8sWc=;
	b=lS2GKuY1p52hIlbMN0IhKrMfbUyv4cL03tKWS5SlQBZeYoaVmKjbhANGa5ICQ3XO9ik6
	 9SAPJORKf24mNz7d/YdjG7PUmqjtSN9Vg41e/hyggKVYgU+G5lvuK8SRNTvMaVE1GlIA6
	 V6z24e9XMPMspkd/b4Vr0yc8DBBteZZA6VZOskjlMKn8x0TnAgBeA1pMpUMuYu5uxMvs2
	 M7c08/kHgDxSYgznXuXSsc7pwIwmbqY2xqLsmY/XhWWZ1O9gSRfFcvDlSIx0+SOWlfH7b
	 zpF1BKPrarTLGS8w7IQ6JODlRlL9TLhV3CxSZOvXEmYPvMbm4pcoyux4XEgCds8wNYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iwO617TT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3150A606A31A;
	Wed, 28 Oct 2026 19:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iwO617TT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F28B1F01825;
	Wed, 28 Oct 2026 19:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215683;
	bh=SdccJliOHz9ocDBBdCBL7YcGJenqaKQigERL57z8sWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iwO617TTzeh/bGrQprmdKYCqXpAx5EW6Rb5An7ixba+rTAlYLmg7mC2bzY8nuyDMq
	 vAqms/ONwFYlzxet5BytoZG75iZYWiLjwIGlf6nWAJWI8Hiau+GjehEos6MHZ/MdYc
	 LYfGDt0+w6UwbxBq2UDV954Ux4utIn6ailozCRvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Simon Horman <horms@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1296/1887] net: sched: cls_api: add filter counter
Date: Wed, 28 Oct 2026 17:56:32 +0100
Message-ID: <20261028170528.916201851@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asbjørn Sloth Tønnesen <ast@fiberby.net>

[ Upstream commit 2081fd3445fec6b9813c20e8b910c2abd6de31cb ]

Maintain a count of filters per block.

Counter updates are protected by cb_lock, which is
also used to protect the offload counters.

Signed-off-by: Asbjørn Sloth Tønnesen <ast@fiberby.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: a347304b2ca1 ("net/sched: cls_api: Always acquire rtnl_lock when destroying locked classifiers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sch_generic.h |  2 ++
 net/sched/cls_api.c       | 19 +++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index b3c7325339eb7..58235cbd14084 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -429,6 +429,7 @@ struct tcf_proto {
 	 */
 	spinlock_t		lock;
 	bool			deleting;
+	bool			counted;
 	refcount_t		refcnt;
 	struct rcu_head		rcu;
 	struct hlist_node	destroy_ht_node;
@@ -477,6 +478,7 @@ struct tcf_block {
 	struct flow_block flow_block;
 	struct list_head owner_list;
 	bool keep_dst;
+	atomic_t filtercnt; /* Number of filters */
 	atomic_t skipswcnt; /* Number of skip_sw filters */
 	atomic_t offloadcnt; /* Number of oddloaded filters */
 	unsigned int nooffloaddevcnt; /* Number of devs unable to do offload */
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 44215aada059b..99eec1f27d878 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -305,12 +305,30 @@ static void tcf_proto_get(struct tcf_proto *tp)
 	refcount_inc(&tp->refcnt);
 }
 
+static void tcf_block_filter_cnt_update(struct tcf_block *block, bool *counted, bool add)
+{
+	lockdep_assert_not_held(&block->cb_lock);
+
+	down_write(&block->cb_lock);
+	if (*counted != add) {
+		if (add) {
+			atomic_inc(&block->filtercnt);
+			*counted = true;
+		} else {
+			atomic_dec(&block->filtercnt);
+			*counted = false;
+		}
+	}
+	up_write(&block->cb_lock);
+}
+
 static void tcf_chain_put(struct tcf_chain *chain);
 
 static void tcf_proto_destroy(struct tcf_proto *tp, bool rtnl_held,
 			      bool sig_destroy, struct netlink_ext_ack *extack)
 {
 	tp->ops->destroy(tp, rtnl_held, extack);
+	tcf_block_filter_cnt_update(tp->chain->block, &tp->counted, false);
 	if (sig_destroy)
 		tcf_proto_signal_destroyed(tp->chain, tp);
 	tcf_chain_put(tp->chain);
@@ -2208,6 +2226,7 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 	err = tp->ops->change(net, skb, tp, cl, t->tcm_handle, tca, &fh,
 			      flags, extack);
 	if (err == 0) {
+		tcf_block_filter_cnt_update(block, &tp->counted, true);
 		tfilter_notify(net, skb, n, tp, block, q, parent, fh,
 			       RTM_NEWTFILTER, false, rtnl_held, extack);
 		tfilter_put(tp, fh);
-- 
2.53.0



