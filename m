Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29E4435A9E;
	Thu, 30 Jul 2026 15:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426932; cv=none; b=huZ53x/jPT5zKbXb0vOf9I/n2V83BeHZt4oxbFoQs3/kXqxEsGFDkl36AE6BfN55lAkBmr7E5NmcPN4xSLi5EVZ+u7fsCztXZxOkoJGVpdNzVcveZHBFucaJ4R3CSU5VnOfmOgWXPEcrfotIiyPT0xJudnYJubnTsbJ6giH9d8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426932; c=relaxed/simple;
	bh=xaqw3/S2ZMwjYxcbzmp3eCv6ydD/DYGONCD7yOnML7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mTVL5Cc+LxnP76AzVEJqfPoYLKBqMK05wgrzdnwP6R/nRmod3ZGRLYm+tUknXWR5CE+2eUDT1+ySBLThUqLlZrEwHZMUK4eVVTHlZb4pS/yL5gPF1h8wiLc8fJdwp+FiqPox1F0LexuG0ThcPAmTLFJWyqWO0PUps6FQO94+Nm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WTYCo3lG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WTYCo3lG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2130D1F000E9;
	Thu, 30 Jul 2026 15:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426930;
	bh=epmxBTSBC/ADP+bL1zUAZQp41UW5fKrZLUcytETRRuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WTYCo3lGsIuo0qMW0r+MoCnpyy/WoQXBqSpohS8mjce2NZwgEubrMnLRi/xaelS/T
	 6Zw+Ko9TqiEzd9cdI88Ynk4QL17kyP3Lh8X5TMWiZy/XNAHOHiRTr36K/IAE02klyr
	 OraKawzmLq/5ZrDaVA4iU+ox6lLtOGTninOvXVrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 565/602] net/mlx5: HWS, Rearrange to prevent forward declaration
Date: Thu, 30 Jul 2026 16:15:57 +0200
Message-ID: <20260730141447.918435048@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

[ Upstream commit 29063103f864fb63f7f7c436e670c5804df1b55b ]

As a preparation for the following patch that will add support
for shrinking empty matchers, rearrange the code to prevent
forward declaration of functions.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250703185431.445571-9-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: bb09d0e64eca ("net/mlx5: HWS, fix matcher leak on resize target setup failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_bwc.c |  354 +++++-----
 1 file changed, 177 insertions(+), 177 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_bwc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_bwc.c
@@ -63,6 +63,183 @@ static void hws_bwc_matcher_init_attr(st
 	attr->max_num_of_at_attach = MLX5HWS_BWC_MATCHER_ATTACH_AT_NUM;
 }
 
+static int hws_bwc_queue_poll(struct mlx5hws_context *ctx,
+			      u16 queue_id,
+			      u32 *pending_rules,
+			      bool drain)
+{
+	struct mlx5hws_flow_op_result comp[MLX5HWS_BWC_MATCHER_REHASH_BURST_TH];
+	u16 burst_th = hws_bwc_get_burst_th(ctx, queue_id);
+	bool got_comp = *pending_rules >= burst_th;
+	bool queue_full;
+	int err = 0;
+	int ret;
+	int i;
+
+	/* Check if there are any completions at all */
+	if (!got_comp && !drain)
+		return 0;
+
+	queue_full = mlx5hws_send_engine_full(&ctx->send_queue[queue_id]);
+	while (queue_full || ((got_comp || drain) && *pending_rules)) {
+		ret = mlx5hws_send_queue_poll(ctx, queue_id, comp, burst_th);
+		if (unlikely(ret < 0)) {
+			mlx5hws_err(ctx, "BWC poll error: polling queue %d returned %d\n",
+				    queue_id, ret);
+			return -EINVAL;
+		}
+
+		if (ret) {
+			(*pending_rules) -= ret;
+			for (i = 0; i < ret; i++) {
+				if (unlikely(comp[i].status != MLX5HWS_FLOW_OP_SUCCESS)) {
+					mlx5hws_err(ctx,
+						    "BWC poll error: polling queue %d returned completion with error\n",
+						    queue_id);
+					err = -EINVAL;
+				}
+			}
+			queue_full = false;
+		}
+
+		got_comp = !!ret;
+	}
+
+	return err;
+}
+
+static int hws_bwc_matcher_move_all_simple(struct mlx5hws_bwc_matcher *bwc_matcher)
+{
+	struct mlx5hws_context *ctx = bwc_matcher->matcher->tbl->ctx;
+	u16 bwc_queues = mlx5hws_bwc_queues(ctx);
+	struct mlx5hws_bwc_rule **bwc_rules;
+	struct mlx5hws_rule_attr rule_attr;
+	u32 *pending_rules;
+	int i, j, ret = 0;
+	bool all_done;
+	u16 burst_th;
+
+	mlx5hws_bwc_rule_fill_attr(bwc_matcher, 0, 0, &rule_attr);
+
+	pending_rules = kcalloc(bwc_queues, sizeof(*pending_rules), GFP_KERNEL);
+	if (!pending_rules)
+		return -ENOMEM;
+
+	bwc_rules = kcalloc(bwc_queues, sizeof(*bwc_rules), GFP_KERNEL);
+	if (!bwc_rules) {
+		ret = -ENOMEM;
+		goto free_pending_rules;
+	}
+
+	for (i = 0; i < bwc_queues; i++) {
+		if (list_empty(&bwc_matcher->rules[i]))
+			bwc_rules[i] = NULL;
+		else
+			bwc_rules[i] = list_first_entry(&bwc_matcher->rules[i],
+							struct mlx5hws_bwc_rule,
+							list_node);
+	}
+
+	do {
+		all_done = true;
+
+		for (i = 0; i < bwc_queues; i++) {
+			rule_attr.queue_id = mlx5hws_bwc_get_queue_id(ctx, i);
+			burst_th = hws_bwc_get_burst_th(ctx, rule_attr.queue_id);
+
+			for (j = 0; j < burst_th && bwc_rules[i]; j++) {
+				rule_attr.burst = !!((j + 1) % burst_th);
+				ret = mlx5hws_matcher_resize_rule_move(bwc_matcher->matcher,
+								       bwc_rules[i]->rule,
+								       &rule_attr);
+				if (unlikely(ret)) {
+					mlx5hws_err(ctx,
+						    "Moving BWC rule failed during rehash (%d)\n",
+						    ret);
+					goto free_bwc_rules;
+				}
+
+				all_done = false;
+				pending_rules[i]++;
+				bwc_rules[i] = list_is_last(&bwc_rules[i]->list_node,
+							    &bwc_matcher->rules[i]) ?
+					       NULL : list_next_entry(bwc_rules[i], list_node);
+
+				ret = hws_bwc_queue_poll(ctx, rule_attr.queue_id,
+							 &pending_rules[i], false);
+				if (unlikely(ret))
+					goto free_bwc_rules;
+			}
+		}
+	} while (!all_done);
+
+	/* drain all the bwc queues */
+	for (i = 0; i < bwc_queues; i++) {
+		if (pending_rules[i]) {
+			u16 queue_id = mlx5hws_bwc_get_queue_id(ctx, i);
+
+			mlx5hws_send_engine_flush_queue(&ctx->send_queue[queue_id]);
+			ret = hws_bwc_queue_poll(ctx, queue_id,
+						 &pending_rules[i], true);
+			if (unlikely(ret))
+				goto free_bwc_rules;
+		}
+	}
+
+free_bwc_rules:
+	kfree(bwc_rules);
+free_pending_rules:
+	kfree(pending_rules);
+
+	return ret;
+}
+
+static int hws_bwc_matcher_move_all(struct mlx5hws_bwc_matcher *bwc_matcher)
+{
+	return hws_bwc_matcher_move_all_simple(bwc_matcher);
+}
+
+static int hws_bwc_matcher_move(struct mlx5hws_bwc_matcher *bwc_matcher)
+{
+	struct mlx5hws_context *ctx = bwc_matcher->matcher->tbl->ctx;
+	struct mlx5hws_matcher_attr matcher_attr = {0};
+	struct mlx5hws_matcher *old_matcher;
+	struct mlx5hws_matcher *new_matcher;
+	int ret;
+
+	hws_bwc_matcher_init_attr(&matcher_attr,
+				  bwc_matcher->priority,
+				  bwc_matcher->size_log);
+
+	old_matcher = bwc_matcher->matcher;
+	new_matcher = mlx5hws_matcher_create(old_matcher->tbl,
+					     &bwc_matcher->mt, 1,
+					     bwc_matcher->at,
+					     bwc_matcher->num_of_at,
+					     &matcher_attr);
+	if (!new_matcher) {
+		mlx5hws_err(ctx, "Rehash error: matcher creation failed\n");
+		return -ENOMEM;
+	}
+
+	ret = mlx5hws_matcher_resize_set_target(old_matcher, new_matcher);
+	if (ret) {
+		mlx5hws_err(ctx, "Rehash error: failed setting resize target\n");
+		return ret;
+	}
+
+	ret = hws_bwc_matcher_move_all(bwc_matcher);
+	if (ret) {
+		mlx5hws_err(ctx, "Rehash error: moving rules failed\n");
+		return -ENOMEM;
+	}
+
+	bwc_matcher->matcher = new_matcher;
+	mlx5hws_matcher_destroy(old_matcher);
+
+	return 0;
+}
+
 int mlx5hws_bwc_matcher_create_simple(struct mlx5hws_bwc_matcher *bwc_matcher,
 				      struct mlx5hws_table *table,
 				      u32 priority,
@@ -210,51 +387,6 @@ int mlx5hws_bwc_matcher_destroy(struct m
 	return 0;
 }
 
-static int hws_bwc_queue_poll(struct mlx5hws_context *ctx,
-			      u16 queue_id,
-			      u32 *pending_rules,
-			      bool drain)
-{
-	struct mlx5hws_flow_op_result comp[MLX5HWS_BWC_MATCHER_REHASH_BURST_TH];
-	u16 burst_th = hws_bwc_get_burst_th(ctx, queue_id);
-	bool got_comp = *pending_rules >= burst_th;
-	bool queue_full;
-	int err = 0;
-	int ret;
-	int i;
-
-	/* Check if there are any completions at all */
-	if (!got_comp && !drain)
-		return 0;
-
-	queue_full = mlx5hws_send_engine_full(&ctx->send_queue[queue_id]);
-	while (queue_full || ((got_comp || drain) && *pending_rules)) {
-		ret = mlx5hws_send_queue_poll(ctx, queue_id, comp, burst_th);
-		if (unlikely(ret < 0)) {
-			mlx5hws_err(ctx, "BWC poll error: polling queue %d returned %d\n",
-				    queue_id, ret);
-			return -EINVAL;
-		}
-
-		if (ret) {
-			(*pending_rules) -= ret;
-			for (i = 0; i < ret; i++) {
-				if (unlikely(comp[i].status != MLX5HWS_FLOW_OP_SUCCESS)) {
-					mlx5hws_err(ctx,
-						    "BWC poll error: polling queue %d returned completion with error\n",
-						    queue_id);
-					err = -EINVAL;
-				}
-			}
-			queue_full = false;
-		}
-
-		got_comp = !!ret;
-	}
-
-	return err;
-}
-
 void
 mlx5hws_bwc_rule_fill_attr(struct mlx5hws_bwc_matcher *bwc_matcher,
 			   u16 bwc_queue_idx,
@@ -556,138 +688,6 @@ hws_bwc_matcher_find_at(struct mlx5hws_b
 	return -1;
 }
 
-static int hws_bwc_matcher_move_all_simple(struct mlx5hws_bwc_matcher *bwc_matcher)
-{
-	struct mlx5hws_context *ctx = bwc_matcher->matcher->tbl->ctx;
-	u16 bwc_queues = mlx5hws_bwc_queues(ctx);
-	struct mlx5hws_bwc_rule **bwc_rules;
-	struct mlx5hws_rule_attr rule_attr;
-	u32 *pending_rules;
-	int i, j, ret = 0;
-	bool all_done;
-	u16 burst_th;
-
-	mlx5hws_bwc_rule_fill_attr(bwc_matcher, 0, 0, &rule_attr);
-
-	pending_rules = kcalloc(bwc_queues, sizeof(*pending_rules), GFP_KERNEL);
-	if (!pending_rules)
-		return -ENOMEM;
-
-	bwc_rules = kcalloc(bwc_queues, sizeof(*bwc_rules), GFP_KERNEL);
-	if (!bwc_rules) {
-		ret = -ENOMEM;
-		goto free_pending_rules;
-	}
-
-	for (i = 0; i < bwc_queues; i++) {
-		if (list_empty(&bwc_matcher->rules[i]))
-			bwc_rules[i] = NULL;
-		else
-			bwc_rules[i] = list_first_entry(&bwc_matcher->rules[i],
-							struct mlx5hws_bwc_rule,
-							list_node);
-	}
-
-	do {
-		all_done = true;
-
-		for (i = 0; i < bwc_queues; i++) {
-			rule_attr.queue_id = mlx5hws_bwc_get_queue_id(ctx, i);
-			burst_th = hws_bwc_get_burst_th(ctx, rule_attr.queue_id);
-
-			for (j = 0; j < burst_th && bwc_rules[i]; j++) {
-				rule_attr.burst = !!((j + 1) % burst_th);
-				ret = mlx5hws_matcher_resize_rule_move(bwc_matcher->matcher,
-								       bwc_rules[i]->rule,
-								       &rule_attr);
-				if (unlikely(ret)) {
-					mlx5hws_err(ctx,
-						    "Moving BWC rule failed during rehash (%d)\n",
-						    ret);
-					goto free_bwc_rules;
-				}
-
-				all_done = false;
-				pending_rules[i]++;
-				bwc_rules[i] = list_is_last(&bwc_rules[i]->list_node,
-							    &bwc_matcher->rules[i]) ?
-					       NULL : list_next_entry(bwc_rules[i], list_node);
-
-				ret = hws_bwc_queue_poll(ctx, rule_attr.queue_id,
-							 &pending_rules[i], false);
-				if (unlikely(ret))
-					goto free_bwc_rules;
-			}
-		}
-	} while (!all_done);
-
-	/* drain all the bwc queues */
-	for (i = 0; i < bwc_queues; i++) {
-		if (pending_rules[i]) {
-			u16 queue_id = mlx5hws_bwc_get_queue_id(ctx, i);
-
-			mlx5hws_send_engine_flush_queue(&ctx->send_queue[queue_id]);
-			ret = hws_bwc_queue_poll(ctx, queue_id,
-						 &pending_rules[i], true);
-			if (unlikely(ret))
-				goto free_bwc_rules;
-		}
-	}
-
-free_bwc_rules:
-	kfree(bwc_rules);
-free_pending_rules:
-	kfree(pending_rules);
-
-	return ret;
-}
-
-static int hws_bwc_matcher_move_all(struct mlx5hws_bwc_matcher *bwc_matcher)
-{
-	return hws_bwc_matcher_move_all_simple(bwc_matcher);
-}
-
-static int hws_bwc_matcher_move(struct mlx5hws_bwc_matcher *bwc_matcher)
-{
-	struct mlx5hws_context *ctx = bwc_matcher->matcher->tbl->ctx;
-	struct mlx5hws_matcher_attr matcher_attr = {0};
-	struct mlx5hws_matcher *old_matcher;
-	struct mlx5hws_matcher *new_matcher;
-	int ret;
-
-	hws_bwc_matcher_init_attr(&matcher_attr,
-				  bwc_matcher->priority,
-				  bwc_matcher->size_log);
-
-	old_matcher = bwc_matcher->matcher;
-	new_matcher = mlx5hws_matcher_create(old_matcher->tbl,
-					     &bwc_matcher->mt, 1,
-					     bwc_matcher->at,
-					     bwc_matcher->num_of_at,
-					     &matcher_attr);
-	if (!new_matcher) {
-		mlx5hws_err(ctx, "Rehash error: matcher creation failed\n");
-		return -ENOMEM;
-	}
-
-	ret = mlx5hws_matcher_resize_set_target(old_matcher, new_matcher);
-	if (ret) {
-		mlx5hws_err(ctx, "Rehash error: failed setting resize target\n");
-		return ret;
-	}
-
-	ret = hws_bwc_matcher_move_all(bwc_matcher);
-	if (ret) {
-		mlx5hws_err(ctx, "Rehash error: moving rules failed\n");
-		return -ENOMEM;
-	}
-
-	bwc_matcher->matcher = new_matcher;
-	mlx5hws_matcher_destroy(old_matcher);
-
-	return 0;
-}
-
 static int
 hws_bwc_matcher_rehash_size(struct mlx5hws_bwc_matcher *bwc_matcher)
 {


