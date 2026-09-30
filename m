Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3AA18C332;
	Wed, 30 Sep 2026 15:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783823; cv=none; b=pckXe9GuL1Ynx7+C10NcgpGRfXHgrJ9s1/izGyATl79xrtEFgwKHNbQnKrO9kRygKNlnPx+f8MXfIXPKwHc1I1vKxRb82LCJVRGeL2+zvAVOM+mcYGcmdzSAIZ0gzIR5tDTWrRgCx/Vp4KX0U0SjeQ7ZNdq1ss/bqaQolXT5CAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783823; c=relaxed/simple;
	bh=1ygEjeR+kBV9+xTgXVYLp6PPdDyBTD4s1e2ycWSUxRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ii7B0LUMoi7miMJgbTsgWAAq0qf1ps66uSaked0ODZtlpPEVVWIaaU/zWdNx8WqGot0qx4G0YlZRSYewJCNeqSPQjLj7FaOGVkzXRUe3zqyWkyAXkZTL/u/9CggQaVSK0bkmG1T6MCrfl9z7Pgwe0GEKnexJFoICreWTD6ZWPkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUl9uJA+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUl9uJA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1321F00893;
	Wed, 30 Sep 2026 15:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783818;
	bh=ypNEm3OY2+D9Zj1hOg6CdfRNyJp1sTapDyDggfF1kA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BUl9uJA+uKMW223hpje8XAtwzHb41FZHItfNqhWUvJfbgVMH8E9y0I+ICRc9H4txt
	 FXMGEMEXdUm+AghQl0K/gwacr0pV11knpwzWL6lfiG1u0xlKt+L5ObidutcOMdcp1E
	 Dp7clghRYzrDoU0LsXeMlh3MnXZaBwAJg2AJC1NU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baowen Zheng <baowen.zheng@corigine.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 532/595] flow_offload: rename offload functions with offload instead of flow
Date: Wed, 30 Sep 2026 17:27:05 +0200
Message-ID: <20260930152359.147669189@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baowen Zheng <baowen.zheng@corigine.com>

[ Upstream commit 9c1c0e124ca25589e6cf040e105ab0857f9e9c3e ]

To improves readability, we rename offload functions with offload instead
of flow.

The term flow is related to exact matches, so we rename these functions
with offload.

We make this change to facilitate single action offload functions naming.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: cfa165cbfbed ("net/sched: act_gate: budget the per-entry list in get_fill_size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/pkt_cls.h    |  6 +++---
 net/sched/cls_api.c      | 12 ++++++------
 net/sched/cls_flower.c   |  8 ++++----
 net/sched/cls_matchall.c |  8 ++++----
 4 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index b608be532964f..65093966b7439 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -536,9 +536,9 @@ tcf_match_indev(struct sk_buff *skb, int ifindex)
 	return ifindex == skb->skb_iif;
 }
 
-int tc_setup_flow_action(struct flow_action *flow_action,
-			 const struct tcf_exts *exts);
-void tc_cleanup_flow_action(struct flow_action *flow_action);
+int tc_setup_offload_action(struct flow_action *flow_action,
+			    const struct tcf_exts *exts);
+void tc_cleanup_offload_action(struct flow_action *flow_action);
 
 int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
 		     void *type_data, bool err_stop, bool rtnl_held);
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 81ebfcdf00bd5..071ffe4d8bacc 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3487,7 +3487,7 @@ static void tcf_act_put_cookie(struct flow_action_entry *entry)
 	flow_action_cookie_destroy(entry->cookie);
 }
 
-void tc_cleanup_flow_action(struct flow_action *flow_action)
+void tc_cleanup_offload_action(struct flow_action *flow_action)
 {
 	struct flow_action_entry *entry;
 	int i;
@@ -3498,7 +3498,7 @@ void tc_cleanup_flow_action(struct flow_action *flow_action)
 			entry->destructor(entry->destructor_priv);
 	}
 }
-EXPORT_SYMBOL(tc_cleanup_flow_action);
+EXPORT_SYMBOL(tc_cleanup_offload_action);
 
 static void tcf_mirred_get_dev(struct flow_action_entry *entry,
 			       const struct tc_action *act)
@@ -3570,8 +3570,8 @@ static enum flow_action_hw_stats tc_act_hw_stats(u8 hw_stats)
 	return hw_stats;
 }
 
-int tc_setup_flow_action(struct flow_action *flow_action,
-			 const struct tcf_exts *exts)
+int tc_setup_offload_action(struct flow_action *flow_action,
+			    const struct tcf_exts *exts)
 {
 	struct tc_action *act;
 	int i, j, k, err = 0;
@@ -3742,14 +3742,14 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 
 err_out:
 	if (err)
-		tc_cleanup_flow_action(flow_action);
+		tc_cleanup_offload_action(flow_action);
 
 	return err;
 err_out_locked:
 	spin_unlock_bh(&act->tcfa_lock);
 	goto err_out;
 }
-EXPORT_SYMBOL(tc_setup_flow_action);
+EXPORT_SYMBOL(tc_setup_offload_action);
 
 unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
 {
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 9f6f8430d0378..43104f565a905 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -450,7 +450,7 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 	cls_flower.rule->match.key = &f->mkey;
 	cls_flower.classid = f->res.classid;
 
-	err = tc_setup_flow_action(&cls_flower.rule->action, &f->exts);
+	err = tc_setup_offload_action(&cls_flower.rule->action, &f->exts);
 	if (err) {
 		kfree(cls_flower.rule);
 		if (skip_sw) {
@@ -462,7 +462,7 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 
 	err = tc_setup_cb_add(block, tp, TC_SETUP_CLSFLOWER, &cls_flower,
 			      skip_sw, &f->flags, &f->in_hw_count, rtnl_held);
-	tc_cleanup_flow_action(&cls_flower.rule->action);
+	tc_cleanup_offload_action(&cls_flower.rule->action);
 	kfree(cls_flower.rule);
 
 	if (err) {
@@ -2262,7 +2262,7 @@ static int fl_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 		cls_flower.rule->match.mask = &f->mask->key;
 		cls_flower.rule->match.key = &f->mkey;
 
-		err = tc_setup_flow_action(&cls_flower.rule->action, &f->exts);
+		err = tc_setup_offload_action(&cls_flower.rule->action, &f->exts);
 		if (err) {
 			kfree(cls_flower.rule);
 			if (tc_skip_sw(f->flags)) {
@@ -2279,7 +2279,7 @@ static int fl_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 					    TC_SETUP_CLSFLOWER, &cls_flower,
 					    cb_priv, &f->flags,
 					    &f->in_hw_count);
-		tc_cleanup_flow_action(&cls_flower.rule->action);
+		tc_cleanup_offload_action(&cls_flower.rule->action);
 		kfree(cls_flower.rule);
 
 		if (err) {
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index cafb84480bab8..0a482ba7102d6 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -97,7 +97,7 @@ static int mall_replace_hw_filter(struct tcf_proto *tp,
 	cls_mall.command = TC_CLSMATCHALL_REPLACE;
 	cls_mall.cookie = cookie;
 
-	err = tc_setup_flow_action(&cls_mall.rule->action, &head->exts);
+	err = tc_setup_offload_action(&cls_mall.rule->action, &head->exts);
 	if (err) {
 		kfree(cls_mall.rule);
 		mall_destroy_hw_filter(tp, head, cookie, NULL);
@@ -111,7 +111,7 @@ static int mall_replace_hw_filter(struct tcf_proto *tp,
 
 	err = tc_setup_cb_add(block, tp, TC_SETUP_CLSMATCHALL, &cls_mall,
 			      skip_sw, &head->flags, &head->in_hw_count, true);
-	tc_cleanup_flow_action(&cls_mall.rule->action);
+	tc_cleanup_offload_action(&cls_mall.rule->action);
 	kfree(cls_mall.rule);
 
 	if (err) {
@@ -302,7 +302,7 @@ static int mall_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 		TC_CLSMATCHALL_REPLACE : TC_CLSMATCHALL_DESTROY;
 	cls_mall.cookie = (unsigned long)head;
 
-	err = tc_setup_flow_action(&cls_mall.rule->action, &head->exts);
+	err = tc_setup_offload_action(&cls_mall.rule->action, &head->exts);
 	if (err) {
 		kfree(cls_mall.rule);
 		if (add && tc_skip_sw(head->flags)) {
@@ -315,7 +315,7 @@ static int mall_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 	err = tc_setup_cb_reoffload(block, tp, add, cb, TC_SETUP_CLSMATCHALL,
 				    &cls_mall, cb_priv, &head->flags,
 				    &head->in_hw_count);
-	tc_cleanup_flow_action(&cls_mall.rule->action);
+	tc_cleanup_offload_action(&cls_mall.rule->action);
 	kfree(cls_mall.rule);
 
 	if (err)
-- 
2.53.0



