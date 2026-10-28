Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215720;
	b=j4nH9J5DNlMxU7oFZkXlPrsvKoXvs6e387FkS38wZKINIeaALt3rXspqYiByT9ZdaoWS
	 Nnxa3iBKvzBziFrNjbIdn2sTIpaJLDmXrcVk7WoFnRPP6J1aMRapVl0ZxN0PMqF3xUhqg
	 UOR4Bwi9OaM0YXSmFBXn4hbZ2/sJpfG4qElal5bCtN3vnXqbAukwikoT2Fdf3YFaGJr5D
	 rx6xhx/o2M0IU9jNI6b39Tu9cpldA7h5sZucVcASdHRi5WOzJeSmv5NjCSHWRjTBvpDrp
	 qLCcbg4Ki8Dwxv1SqfaWOaf2f/DB0nNFUfEmkoFlzC3LlSUJzZ+gqdjUjh8rBj8MHQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215720;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lByfa4JZ+m1Kybe9jlTR2NhuY/T5XhKBF7L8+AhzDRo=;
	b=frDW0TAmZWpwLBzhJ25nK36xAjP7j8QAdNYHrXXA30kxUHNpZ20Y+wZU0MUxnu5TcIa/
	 Cus3OavvFPvkGII5e4zUxRYbJAJQAf0f7xdBZhfmgo/x4AA3XPFtZQslWPLiSWLwQ6ucW
	 7DX0+yXVvsKa54e6EtKYq+ux66VWdKixY5e7njT/rbcCkegGt5ugIvgdHwcua+GeM424w
	 XAoQfk01aXjQJOhzzhWNp6MdwIZ/IqHwhA4esf6OSjl/xcoGGQPrin5Y1um5iGHBDMwUN
	 NDTgzhztPGMqNtiE4Vrzwhn5CwvkLdq5WtP8c/dVyEaI4WcVkSEaktMU4+u0SG4Wx8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TsDUIknI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE3F606A320;
	Wed, 28 Oct 2026 19:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TsDUIknI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7CE1F01825;
	Wed, 28 Oct 2026 19:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215720;
	bh=lByfa4JZ+m1Kybe9jlTR2NhuY/T5XhKBF7L8+AhzDRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TsDUIknIHmMByxc6yMErkw60vHpAjpCHRWq2t1MV6c3B7y3bc96ag6aqLCHVFzq6s
	 fOFgoRzRlEMeJgyDMbJl7xkWXWD4M7xxhv8qO0i2F6wwnXKc3ZqTInDBuJd8cr0v37
	 XaYkmBCF+NKuAiVpi3bYuu1Sg23ZdlK5dZRk2oy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Nogueira <victor@mojatatu.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1308/1887] net: sched: Move drop_reason to struct tc_skb_cb
Date: Wed, 28 Oct 2026 17:56:44 +0100
Message-ID: <20261028170529.197203098@linuxfoundation.org>
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

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit fb2780721ca5e9f78bbe4544b819b929a982df9c ]

Move drop_reason from struct tcf_result to skb cb - more specifically to
struct tc_skb_cb. With that, we'll be able to also set the drop reason for
the remaining qdiscs (aside from clsact) that do not have access to
tcf_result when time comes to set the skb drop reason.

Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>

[ Adapted to the tree: dev.c still uses the open-coded sch_handle_ingress/egress
  rather than tc_run(), so those call sites were converted instead; cls_api.c
  keeps only the removal of the res->drop_reason fallback. ]

Stable-dep-of: f60b396ee174 ("net/sched: act_api: fix TOCTOU NULL deref on a->goto_chain")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/pkt_cls.h     | 14 ++++++++++++--
 include/net/pkt_sched.h   |  3 ++-
 include/net/sch_generic.h |  1 -
 net/core/dev.c            |  8 ++++----
 net/sched/act_api.c       |  2 +-
 net/sched/cls_api.c       |  9 +--------
 6 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 5671a05b744b0..7ee8c92c41fa7 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -181,10 +181,20 @@ __cls_set_class(unsigned long *clp, unsigned long cl)
 	return xchg(clp, cl);
 }
 
-static inline void tcf_set_drop_reason(struct tcf_result *res,
+struct tc_skb_cb;
+
+static inline struct tc_skb_cb *tc_skb_cb(const struct sk_buff *skb);
+
+static inline enum skb_drop_reason
+tcf_get_drop_reason(const struct sk_buff *skb)
+{
+	return tc_skb_cb(skb)->drop_reason;
+}
+
+static inline void tcf_set_drop_reason(const struct sk_buff *skb,
 				       enum skb_drop_reason reason)
 {
-	res->drop_reason = reason;
+	tc_skb_cb(skb)->drop_reason = reason;
 }
 
 static inline void
diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 7795b2f68e36b..2ff91bfeb80d2 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -218,12 +218,13 @@ static inline void skb_txtime_consumed(struct sk_buff *skb)
 
 struct tc_skb_cb {
 	struct qdisc_skb_cb qdisc_cb;
+	u32 drop_reason;
 
+	u16 zone; /* Only valid if post_ct = true */
 	u16 mru;
 	u8 post_ct:1;
 	u8 post_ct_snat:1;
 	u8 post_ct_dnat:1;
-	u16 zone; /* Only valid if post_ct = true */
 };
 
 static inline struct tc_skb_cb *tc_skb_cb(const struct sk_buff *skb)
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index e16c97cd6ef91..2bc9b63cf9f22 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -335,7 +335,6 @@ struct tcf_result {
 		};
 		const struct tcf_proto *goto_tp;
 	};
-	enum skb_drop_reason		drop_reason;
 };
 
 struct tcf_chain;
diff --git a/net/core/dev.c b/net/core/dev.c
index 1bf404303565e..7eccf0fb1709e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4080,7 +4080,7 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 	/* qdisc_skb_cb(skb)->pkt_len was already set by the caller. */
 	tc_skb_cb(skb)->mru = 0;
 	tc_skb_cb(skb)->post_ct = false;
-	cl_res.drop_reason = SKB_DROP_REASON_TC_EGRESS;
+	tcf_set_drop_reason(skb, SKB_DROP_REASON_TC_EGRESS);
 	mini_qdisc_bstats_cpu_update(miniq, skb);
 
 	switch (tcf_classify(skb, miniq->block, miniq->filter_list, &cl_res, false)) {
@@ -4091,7 +4091,7 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 	case TC_ACT_SHOT:
 		mini_qdisc_qstats_cpu_drop(miniq);
 		*ret = NET_XMIT_DROP;
-		kfree_skb_reason(skb, cl_res.drop_reason ?: SKB_DROP_REASON_TC_EGRESS);
+		kfree_skb_reason(skb, tcf_get_drop_reason(skb) ?: SKB_DROP_REASON_TC_EGRESS);
 		return NULL;
 	case TC_ACT_STOLEN:
 	case TC_ACT_QUEUED:
@@ -5274,7 +5274,7 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
 	tc_skb_cb(skb)->mru = 0;
 	tc_skb_cb(skb)->post_ct = false;
 	skb->tc_at_ingress = 1;
-	cl_res.drop_reason = SKB_DROP_REASON_TC_INGRESS;
+	tcf_set_drop_reason(skb, SKB_DROP_REASON_TC_INGRESS);
 	mini_qdisc_bstats_cpu_update(miniq, skb);
 
 	switch (tcf_classify(skb, miniq->block, miniq->filter_list, &cl_res, false)) {
@@ -5284,7 +5284,7 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
 		break;
 	case TC_ACT_SHOT:
 		mini_qdisc_qstats_cpu_drop(miniq);
-		kfree_skb_reason(skb, cl_res.drop_reason ?: SKB_DROP_REASON_TC_INGRESS);
+		kfree_skb_reason(skb, tcf_get_drop_reason(skb) ?: SKB_DROP_REASON_TC_INGRESS);
 		*ret = NET_RX_DROP;
 		return NULL;
 	case TC_ACT_STOLEN:
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 5fd72b061801e..9cbd8446532aa 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1131,7 +1131,7 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
 			}
 		} else if (TC_ACT_EXT_CMP(ret, TC_ACT_GOTO_CHAIN)) {
 			if (unlikely(!rcu_access_pointer(a->goto_chain))) {
-				tcf_set_drop_reason(res, SKB_DROP_REASON_TC_ERROR);
+				tcf_set_drop_reason(skb, SKB_DROP_REASON_TC_ERROR);
 				return TC_ACT_SHOT;
 			}
 			tcf_action_goto_chain_exec(a, res);
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index b79d98711e757..603b7caebad2b 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1601,7 +1601,6 @@ static inline int __tcf_classify(struct sk_buff *skb,
 				 bool compat_mode,
 				 u32 *last_executed_chain)
 {
-	u32 orig_reason = res->drop_reason;
 #ifdef CONFIG_NET_CLS_ACT
 	const int max_reclassify_loop = 16;
 	const struct tcf_proto *first_tp;
@@ -1629,14 +1628,8 @@ static inline int __tcf_classify(struct sk_buff *skb,
 			goto reset;
 		}
 #endif
-		if (err >= 0) {
-			/* Policy drop or drop reason is over-written by
-			 * classifiers with a bogus value(0) */
-			if (err == TC_ACT_SHOT &&
-			    res->drop_reason == SKB_NOT_DROPPED_YET)
-				tcf_set_drop_reason(res, orig_reason);
+		if (err >= 0)
 			return err;
-		}
 	}
 
 	return TC_ACT_UNSPEC; /* signal: continue lookup */
-- 
2.53.0



