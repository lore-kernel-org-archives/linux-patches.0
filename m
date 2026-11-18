Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044732;
	b=XMo1CqPPvJ6sdnrwOG0/PRuTwTm3UkuFhWod9REBTzqhLgWhDoAFeJVlRJsRrnsbvbQa
	 5XG3WeOan50yorcP8GS08fVi2P7Pblp/SN27AQWW9HCHFi8cWV3uk61L8EdP9AO9EbCcu
	 5ZR3xIwI5t66hdIUGiCVRVx7xi3WWlJuTolsVAZ0Cz3Tx+oPnjMQ8KQTQMxFrNYjTG1Gc
	 cWiQkGZ6CT91u0p5dzCzi8cSSz2Xlc1Dp6oXqXbSz89Tsdm5xMB3QvQNRaaa9ZKQSbFJu
	 O7KD9RME5ETWdwzPR66ayUyOoUCKaRu2CWhfnI5Sm+6sMSlI422iLHXhg/q2y/kU4AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044732;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3HwcsjSpv/UBtTImZUIW6avudTMeIYHUt4hv6aAIidg=;
	b=wHGb33AusBMJMyzLvRPLlOjmwJQ9+mUcaQarSu/NcSgh91AKjxPMF7Vbwm00Ly0kpC6H
	 T0PB8wfTwpBQFsDwAElnpyTLDMCDC3laqgeOiOM2V8XeZBnk2gwlsqSffGPPKW5HVGlNc
	 G8SZAWELT0j8UAn8lr+Fdj4v2gRXqDiQLZCjzfoLuwna2g/zwcDKk1GKeIp2bQlo1QSwB
	 FfYvN2bK7tsFFoJTfJQX8qDl6GJXIdtCGlQeCGhO6k7PJNaxW05GCk08D+iHdyhrH43cM
	 z3yssFiuMA5zzFNkkmpjK3fWO4uIqkgUX3K0BY3pGPpwejkAFleBdjg129g2Rynw+YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dC+gwJC4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC5C606A332;
	Wed, 18 Nov 2026 23:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dC+gwJC4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531EA1F000C4;
	Wed, 18 Nov 2026 23:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044731;
	bh=3HwcsjSpv/UBtTImZUIW6avudTMeIYHUt4hv6aAIidg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dC+gwJC4cXWYYCcW7mZSuqJiRvAtdueaaEpD7t8w0B8LLoBpyQCnyZEEtepNU0Mnp
	 0EnDuCgBDPNr0I89YcInj5yQmi8xHAcnmtFnI+Jtx8fYC2JbQTG0QqYkqjgotXxCfj
	 3VuSS1xXcxawqeP9OWMPdGMH8zlJ+R+Wsnss5qjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Liu <bird@lzu.edu.cn>,
	Yucheng Lu <kanolyc@gmail.com>,
	Yuhang Zheng <z1652074432@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0670/2857] net/sched: cls_flower: avoid stale mask references after delete
Date: Wed, 18 Nov 2026 15:28:24 +0100
Message-ID: <20261118150225.684785052@linuxfoundation.org>
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

From: Yuhang Zheng <z1652074432@gmail.com>

[ Upstream commit 58f7989da6e715ce834ac861b7ba6ae9f9bdb098 ]

Flower releases a mask reference when a filter is removed from the
classifier. The filter object can remain alive while dump, walk, or
hardware reoffload paths hold a reference to it. Those paths can then
dereference f->mask after the mask has already been released.

Keep the mask reference until the filter reference count reaches zero.
Release the mask synchronously from the final __fl_put() while the caller
still holds the tcf_proto reference, and leave the existing RCU work to
free the mask. This keeps the mask available to every reader that still
holds the filter.

The filter is still removed from the classifier indexes immediately.
Therefore, a deleted filter can temporarily retain an otherwise empty
mask; fl_delete() uses the handle IDR, rather than the mask list, to
determine whether the classifier has become empty.

Failed mask assignment can leave fnew->mask as an error or borrowed
pointer without an owned mask reference. Clear it before the common
failure path so the final put cannot release an unowned reference.

This fix does not add fields, snapshots, or per-filter memory.

Fixes: 92149190067d ("net: sched: flower: set unlocked flag for flower proto ops")
Cc: stable@vger.kernel.org
Reported-by: Xin Liu <bird@lzu.edu.cn>
Tested-by: Yucheng Lu <kanolyc@gmail.com>
Signed-off-by: Yuhang Zheng <z1652074432@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Link: https://patch.msgid.link/20261012010720.2248662-2-n05ec@lzu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Adapted fl_change() error cleanup to use the existing errout path instead of unbind_filter and errout_idr. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_flower.c | 49 ++++++++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 21 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index c6eb857bce895..ea0592b0249c3 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -508,15 +508,22 @@ static void fl_hw_update_stats(struct tcf_proto *tp, struct cls_fl_filter *f,
 				 cls_flower.stats.used_hw_stats_valid);
 }
 
-static void __fl_put(struct cls_fl_filter *f)
+static bool __fl_put(struct tcf_proto *tp, struct cls_fl_filter *f)
 {
+	bool last = false;
+
 	if (!refcount_dec_and_test(&f->refcnt))
-		return;
+		return false;
+
+	if (f->mask)
+		last = fl_mask_put(fl_head_dereference(tp), f->mask);
 
 	if (tcf_exts_get_net(&f->exts))
 		tcf_queue_work(&f->rwork, fl_destroy_filter_work);
 	else
 		__fl_destroy_filter(f);
+
+	return last;
 }
 
 static struct cls_fl_filter *__fl_get(struct cls_fl_head *head, u32 handle)
@@ -553,11 +560,10 @@ static int __fl_delete(struct tcf_proto *tp, struct cls_fl_filter *f,
 	list_del_rcu(&f->list);
 	spin_unlock(&tp->lock);
 
-	*last = fl_mask_put(head, f->mask);
 	if (!tc_skip_hw(f->flags))
 		fl_hw_destroy_filter(tp, f, rtnl_held, extack);
 	tcf_unbind_filter(tp, &f->res);
-	__fl_put(f);
+	*last = __fl_put(tp, f);
 
 	return 0;
 }
@@ -598,7 +604,7 @@ static void fl_put(struct tcf_proto *tp, void *arg)
 {
 	struct cls_fl_filter *f = arg;
 
-	__fl_put(f);
+	__fl_put(tp, f);
 }
 
 static void *fl_get(struct tcf_proto *tp, u32 handle)
@@ -2229,12 +2235,14 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 		goto errout;
 
 	err = fl_check_assign_mask(head, fnew, fold, mask);
-	if (err)
+	if (err) {
+		fnew->mask = NULL;
 		goto errout;
+	}
 
 	err = fl_ht_insert_unique(fnew, fold, &in_ht);
 	if (err)
-		goto errout_mask;
+		goto errout;
 
 	if (!tc_skip_hw(fnew->flags)) {
 		err = fl_hw_replace_filter(tp, fnew, rtnl_held, extack);
@@ -2288,7 +2296,6 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 
 		spin_unlock(&tp->lock);
 
-		fl_mask_put(head, fold->mask);
 		if (!tc_skip_hw(fold->flags))
 			fl_hw_destroy_filter(tp, fold, rtnl_held, NULL);
 		tcf_unbind_filter(tp, &fold->res);
@@ -2296,7 +2303,7 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 		 * after this.
 		 */
 		refcount_dec(&fold->refcnt);
-		__fl_put(fold);
+		__fl_put(tp, fold);
 	} else {
 		if (handle) {
 			/* user specifies a handle and it doesn't exist */
@@ -2341,17 +2348,15 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 	if (in_ht)
 		rhashtable_remove_fast(&fnew->mask->ht, &fnew->ht_node,
 				       fnew->mask->filter_ht_params);
-errout_mask:
-	fl_mask_put(head, fnew->mask);
 errout:
-	__fl_put(fnew);
+	__fl_put(tp, fnew);
 errout_tb:
 	kfree(tb);
 errout_mask_alloc:
 	tcf_queue_work(&mask->rwork, fl_uninit_mask_free_work);
 errout_fold:
 	if (fold)
-		__fl_put(fold);
+		__fl_put(tp, fold);
 	return err;
 }
 
@@ -2364,8 +2369,10 @@ static int fl_delete(struct tcf_proto *tp, void *arg, bool *last,
 	int err = 0;
 
 	err = __fl_delete(tp, f, &last_on_mask, rtnl_held, extack);
-	*last = list_empty(&head->masks);
-	__fl_put(f);
+	spin_lock(&tp->lock);
+	*last = idr_is_empty(&head->handle_idr);
+	spin_unlock(&tp->lock);
+	__fl_put(tp, f);
 
 	return err;
 }
@@ -2387,12 +2394,12 @@ static void fl_walk(struct tcf_proto *tp, struct tcf_walker *arg,
 		rcu_read_unlock();
 
 		if (arg->fn(tp, f, arg) < 0) {
-			__fl_put(f);
+			__fl_put(tp, f);
 			arg->stop = 1;
 			rcu_read_lock();
 			break;
 		}
-		__fl_put(f);
+		__fl_put(tp, f);
 		arg->count++;
 		rcu_read_lock();
 	}
@@ -2443,7 +2450,7 @@ static int fl_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 		cls_flower.rule =
 			flow_rule_alloc(tcf_exts_num_actions(&f->exts));
 		if (!cls_flower.rule) {
-			__fl_put(f);
+			__fl_put(tp, f);
 			return -ENOMEM;
 		}
 
@@ -2461,7 +2468,7 @@ static int fl_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 		if (err) {
 			kfree(cls_flower.rule);
 			if (tc_skip_sw(f->flags)) {
-				__fl_put(f);
+				__fl_put(tp, f);
 				return err;
 			}
 			goto next_flow;
@@ -2477,11 +2484,11 @@ static int fl_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 		kfree(cls_flower.rule);
 
 		if (err) {
-			__fl_put(f);
+			__fl_put(tp, f);
 			return err;
 		}
 next_flow:
-		__fl_put(f);
+		__fl_put(tp, f);
 	}
 
 	return 0;
-- 
2.53.0



