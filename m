Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6843A7587;
	Sat, 12 Sep 2026 19:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239894; cv=none; b=HCp7ARWV3X8kLK91IuVKwukcQYqCSS9bje5h4yfygMsIWjGLFtyaVkG6q/068ymEtEy5KT06zuP4lFUwepeYAoeZtZer3/MJUxgyIU3IZnuKD84z/7gln7daakWW5Ehbif1y8O+fe73QvMk7VJpEWfq7dxzHct6M4xS+ZK21GXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239894; c=relaxed/simple;
	bh=RbL0qprbvZaAatVPB/1n+x3tzopwxi/abm+3kilrMfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GjQzk11PHxsScfSNwb1p52iJTbZcz6PMLXdy7evTsty5b5yLUzcpVn2aZth99lBUUafv9jre1/0wU7SFRHCyZujbPj2NtcMlQWlOuO91INc0URRtqEUanD5A8NVXFRT6s6cS/n3VgTO5rs4sDcbgydovnsvHMzSXKCPoYG8McEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L8auHYgp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L8auHYgp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D52341F000FF;
	Sat, 12 Sep 2026 19:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239893;
	bh=X3RRAHQluOijrLi9lLYGSvchGU6Su+aeAeZghS4o85Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L8auHYgpE2GVZLaO2R+yHyb0hbmEGj1FgfHpxTDhRoHEZNwU9uBGSpKYrv2wpdV/V
	 pu3OucGGrfA/618hlCBkIUwRVB1WcE6dvftI6ROzRTLCAf+U83iRk3LjpWPUeg4gC6
	 d01TnGnN8azvKi/Ou5po9M2WtUcSA71iShqIJsUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baowen Zheng <baowen.zheng@corigine.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 756/935] flow_offload: rename offload functions with offload instead of flow
Date: Sat, 12 Sep 2026 09:03:06 +0200
Message-ID: <20260912065544.171306531@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: d4e359b3608a ("net/sched: cls_api: fix teardown of an adopted proto on insert-race loss")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/pkt_cls.h    |  6 +++---
 net/sched/cls_api.c      | 12 ++++++------
 net/sched/cls_flower.c   |  8 ++++----
 net/sched/cls_matchall.c |  8 ++++----
 4 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 83a6d07921806..6e993e2d656a4 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -532,9 +532,9 @@ tcf_match_indev(struct sk_buff *skb, int ifindex)
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
index b085fdf78679f..a6002e067d0b4 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3480,7 +3480,7 @@ static void tcf_act_put_cookie(struct flow_action_entry *entry)
 	flow_action_cookie_destroy(entry->cookie);
 }
 
-void tc_cleanup_flow_action(struct flow_action *flow_action)
+void tc_cleanup_offload_action(struct flow_action *flow_action)
 {
 	struct flow_action_entry *entry;
 	int i;
@@ -3491,7 +3491,7 @@ void tc_cleanup_flow_action(struct flow_action *flow_action)
 			entry->destructor(entry->destructor_priv);
 	}
 }
-EXPORT_SYMBOL(tc_cleanup_flow_action);
+EXPORT_SYMBOL(tc_cleanup_offload_action);
 
 static void tcf_mirred_get_dev(struct flow_action_entry *entry,
 			       const struct tc_action *act)
@@ -3563,8 +3563,8 @@ static enum flow_action_hw_stats tc_act_hw_stats(u8 hw_stats)
 	return hw_stats;
 }
 
-int tc_setup_flow_action(struct flow_action *flow_action,
-			 const struct tcf_exts *exts)
+int tc_setup_offload_action(struct flow_action *flow_action,
+			    const struct tcf_exts *exts)
 {
 	struct tc_action *act;
 	int i, j, k, err = 0;
@@ -3738,14 +3738,14 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 
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
index af437be93e25a..b010778206650 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -456,7 +456,7 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 	cls_flower.rule->match.key = &f->mkey;
 	cls_flower.classid = f->res.classid;
 
-	err = tc_setup_flow_action(&cls_flower.rule->action, &f->exts);
+	err = tc_setup_offload_action(&cls_flower.rule->action, &f->exts);
 	if (err) {
 		kfree(cls_flower.rule);
 		if (skip_sw) {
@@ -468,7 +468,7 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 
 	err = tc_setup_cb_add(block, tp, TC_SETUP_CLSFLOWER, &cls_flower,
 			      skip_sw, &f->flags, &f->in_hw_count, rtnl_held);
-	tc_cleanup_flow_action(&cls_flower.rule->action);
+	tc_cleanup_offload_action(&cls_flower.rule->action);
 	kfree(cls_flower.rule);
 
 	if (err) {
@@ -2283,7 +2283,7 @@ static int fl_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 		cls_flower.rule->match.mask = &f->mask->key;
 		cls_flower.rule->match.key = &f->mkey;
 
-		err = tc_setup_flow_action(&cls_flower.rule->action, &f->exts);
+		err = tc_setup_offload_action(&cls_flower.rule->action, &f->exts);
 		if (err) {
 			kfree(cls_flower.rule);
 			if (tc_skip_sw(f->flags)) {
@@ -2300,7 +2300,7 @@ static int fl_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 					    TC_SETUP_CLSFLOWER, &cls_flower,
 					    cb_priv, &f->flags,
 					    &f->in_hw_count);
-		tc_cleanup_flow_action(&cls_flower.rule->action);
+		tc_cleanup_offload_action(&cls_flower.rule->action);
 		kfree(cls_flower.rule);
 
 		if (err) {
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index 24f0046ce0b33..2d2702915cfad 100644
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
@@ -301,7 +301,7 @@ static int mall_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 		TC_CLSMATCHALL_REPLACE : TC_CLSMATCHALL_DESTROY;
 	cls_mall.cookie = (unsigned long)head;
 
-	err = tc_setup_flow_action(&cls_mall.rule->action, &head->exts);
+	err = tc_setup_offload_action(&cls_mall.rule->action, &head->exts);
 	if (err) {
 		kfree(cls_mall.rule);
 		if (add && tc_skip_sw(head->flags)) {
@@ -314,7 +314,7 @@ static int mall_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 	err = tc_setup_cb_reoffload(block, tp, add, cb, TC_SETUP_CLSMATCHALL,
 				    &cls_mall, cb_priv, &head->flags,
 				    &head->in_hw_count);
-	tc_cleanup_flow_action(&cls_mall.rule->action);
+	tc_cleanup_offload_action(&cls_mall.rule->action);
 	kfree(cls_mall.rule);
 
 	if (err)
-- 
2.53.0



