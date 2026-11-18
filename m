Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034954;
	b=cc7E/ZqQRQTGVeIlZvYPshn02sk9L0FsYVzlvPYZTdklT7eRnWqjNeuf+B8CXw0NzDPU
	 T/ja1g1knnjBrdtyzE9ILp/FsAttSaQjlAXARwY5dVE8E2n7BtBhYwJJIhibFqIbwrfxo
	 Iu+2IxTbmYEIbwgrInQSmwArlGVbUC5cO2rx/hRmjUvEVE+vFicuUgDv2mB920NBNVN5U
	 9aVr29Ta94YKT6v6Xxhe9UXM4nl8IaAnlw9CUiRCRf9PaGv5zDldWV1g3IsqaEFdZLR5M
	 pXlGPQ22cv7BytFYx2tZ7WmDWprVI2LyH7f7OiUnKjylYrgDL9Qdqf6uzlmC1NTpWcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034954;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zxlC7kNBid9vpOAoOn75HnkAz57qAbF5Xlf2Fg9wArQ=;
	b=dEQoYJoDc2mmpPTATPPdqrKFY1hz+Mqc0zEuapyrz+EirQABqIgfYdPwp7RqXIxXQWp8
	 J+cNTLO66nm2/xKMEO/SbAYmby3hw+cmMzL7AoAGywR9+tD+6y7YCVuTEHb77rns6XCza
	 TgWQ0pymMXTm0fIwa+Fl1R2xTeiiAeqLw4Ze2k890waURN5BgjEuF/Uq36cGiGiiwTtRW
	 JeXUyG993FT5Yk07pyQYZldWWrVI0rjp3nKaAs74sXVpQwwWDA/f+XI8OWJF1nQMmVrJ5
	 leYZrOgCm7mHN3zDXvpr3f558I3EvQV1/5M8n53kfJBpvjqyhaRMXG91fudOPdIx7+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="yUlG9bC/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF57606A320;
	Wed, 18 Nov 2026 20:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yUlG9bC/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B9F1F000C4;
	Wed, 18 Nov 2026 20:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034954;
	bh=zxlC7kNBid9vpOAoOn75HnkAz57qAbF5Xlf2Fg9wArQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yUlG9bC/lEhyjRE3bv2qecyd9Y0j6SNDA/pTRhRSitFfAkasX8+yTw+YJElb+/r5J
	 XIDdGqn35iifDbpXoRbALDjSHN544NJugD+Y+b8SItbvX/JEaDf46wBeDb9pjXIe/A
	 86MOSPv4sCeClKhkC6yOoISrAjVqgWwcewb72ufE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Liu <bird@lzu.edu.cn>,
	Yucheng Lu <kanolyc@gmail.com>,
	Yuhang Zheng <z1652074432@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0554/3318] net/sched: cls_flower: avoid stale mask references after delete
Date: Wed, 18 Nov 2026 15:19:36 +0100
Message-ID: <20261118150333.943207731@linuxfoundation.org>
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

From: Yuhang Zheng <z1652074432@gmail.com>

commit 58f7989da6e715ce834ac861b7ba6ae9f9bdb098 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/cls_flower.c |   50 +++++++++++++++++++++++++++----------------------
 1 file changed, 28 insertions(+), 22 deletions(-)

--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -511,15 +511,22 @@ static void fl_hw_update_stats(struct tc
 	tcf_exts_hw_stats_update(&f->exts, &cls_flower.stats, cls_flower.use_act_stats);
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
@@ -565,11 +572,10 @@ static int __fl_delete(struct tcf_proto
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
@@ -610,7 +616,7 @@ static void fl_put(struct tcf_proto *tp,
 {
 	struct cls_fl_filter *f = arg;
 
-	__fl_put(f);
+	__fl_put(tp, f);
 }
 
 static void *fl_get(struct tcf_proto *tp, u32 handle)
@@ -2363,12 +2369,14 @@ static int fl_change(struct net *net, st
 	}
 
 	err = fl_check_assign_mask(head, fnew, fold, mask);
-	if (err)
+	if (err) {
+		fnew->mask = NULL;
 		goto unbind_filter;
+	}
 
 	err = fl_ht_insert_unique(fnew, fold, &in_ht);
 	if (err)
-		goto errout_mask;
+		goto unbind_filter;
 
 	if (!tc_skip_hw(fnew->flags)) {
 		err = fl_hw_replace_filter(tp, fnew, rtnl_held, extack);
@@ -2422,7 +2430,6 @@ static int fl_change(struct net *net, st
 
 		spin_unlock(&tp->lock);
 
-		fl_mask_put(head, fold->mask);
 		if (!tc_skip_hw(fold->flags))
 			fl_hw_destroy_filter(tp, fold, rtnl_held, NULL);
 		tcf_unbind_filter(tp, &fold->res);
@@ -2430,7 +2437,7 @@ static int fl_change(struct net *net, st
 		 * after this.
 		 */
 		refcount_dec(&fold->refcnt);
-		__fl_put(fold);
+		__fl_put(tp, fold);
 	} else {
 		idr_replace(&head->handle_idr, fnew, fnew->handle);
 
@@ -2455,9 +2462,6 @@ errout_hw:
 	if (in_ht)
 		rhashtable_remove_fast(&fnew->mask->ht, &fnew->ht_node,
 				       fnew->mask->filter_ht_params);
-errout_mask:
-	fl_mask_put(head, fnew->mask);
-
 unbind_filter:
 	if (bound_to_filter) {
 		if (flags & TCA_ACT_FLAGS_NO_RTNL)
@@ -2473,14 +2477,14 @@ errout_idr:
 		idr_remove(&head->handle_idr, fnew->handle);
 		spin_unlock(&tp->lock);
 	}
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
 
@@ -2493,8 +2497,10 @@ static int fl_delete(struct tcf_proto *t
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
@@ -2516,12 +2522,12 @@ static void fl_walk(struct tcf_proto *tp
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
@@ -2572,7 +2578,7 @@ static int fl_reoffload(struct tcf_proto
 		cls_flower.rule =
 			flow_rule_alloc(tcf_exts_num_actions(&f->exts));
 		if (!cls_flower.rule) {
-			__fl_put(f);
+			__fl_put(tp, f);
 			return -ENOMEM;
 		}
 
@@ -2590,7 +2596,7 @@ static int fl_reoffload(struct tcf_proto
 		if (err) {
 			kfree(cls_flower.rule);
 			if (tc_skip_sw(f->flags)) {
-				__fl_put(f);
+				__fl_put(tp, f);
 				return err;
 			}
 			goto next_flow;
@@ -2606,11 +2612,11 @@ static int fl_reoffload(struct tcf_proto
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


