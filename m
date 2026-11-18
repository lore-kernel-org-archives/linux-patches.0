Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024251;
	b=aidbtgMQxbdPnBZpgZkgfEQx80tkn2RFdPrEbLul08y+qw+XrDacxNvKjlJ1OSx5ZF4n
	 qUMBH2x3IQ5e/fLBv1W2ell3fyblHLEFzmCbc+tWejEXzpQK7yisjo1GG+IxjJjGdOfVv
	 LsRNDUZzzhsZvQszesg9BY5lRhKQ7ZMKInzVSqQfgEwEMDD/NsZZvw9t5HteXD3ZFEcdH
	 +UQts7gmPf0FfiR15MU0FuciHoxOR95jAUJFk/wPhk3l3Fv8A7F7iVc3Z7fn+Pe5OcIqG
	 vRAQ22ZKWqb9uMQ2fQkGQLi+HVshjEEfEoRv1s+ozG8ha88Cdr2xq+f0Mu1aiHYv4GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024251;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PqjcvcMCEHhVVM+0t6cpehElQOSVR0dXcYyCf/94oOg=;
	b=WeqDlcBmJHNuOKjIeEeZAVf2NubFsO/LZhbRZHXuApAOQVr6aAbotTTz0MlGgY3Zg/GO
	 KQym4KSKV7UB/0PSD9U7uzkZGm1YS77qmwPGzwfEN7muEH+G5KuWQnyASxxlqwR+AXrqI
	 yNNMNlrwlaUhXaLDwo2O6JHfjEpdHCH370lA3JQaPhrlpb5f4RkQPYrV/0uytd0+ia1eO
	 88+yX7vEnkabuBmlTwJD6BflwHqjidFLZLs6UPBKcE2m9B99KXftdLx3rAO7jOQUZx1Bf
	 uk2nLLEHIaHbFjf6SYTUuB769YipBQg5ZCSUOHdIDE3WHEMdDkOIK5VuGd8spzwVajg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y6UFCvBk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC020606A334;
	Wed, 18 Nov 2026 17:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y6UFCvBk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2D31F000C6;
	Wed, 18 Nov 2026 17:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024251;
	bh=PqjcvcMCEHhVVM+0t6cpehElQOSVR0dXcYyCf/94oOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y6UFCvBk84cDA1jUADR+C6n2TizBtu5oNrNs6s1rLYGQQv8JlhnLSyn2XmvcHkn+F
	 gSMFa+Z2WOlz+BDrcVuEGidA86YgVcKWDYhXjxyUQzK+vcwWWwKqKAiJuxoR8RG0JS
	 1ql464LrGbb5QmPiqW/v5UctT30Se6nyCcNI/1QI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0660/2151] RDMA/mlx5: Use DEFINE_RAW_FLEX for leftovers flow attributes
Date: Wed, 18 Nov 2026 15:39:55 +0100
Message-ID: <20261118150145.884527011@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit e43913aabd35eef837edef29e93f15e15bdeeacd ]

Commit e91fb8b9d0ed ("RDMA/mlx5: Avoid flexible array warning") split
the leftovers_specs[] array into two separate structs to silence the
sparse "array of flexible structures" warning, but in doing so reversed
the member order: eth_flow was placed before flow_attr.

_create_flow_rule() locates the flow specs with:

    ib_flow = (void *)flow_attr + sizeof(*flow_attr);

which expects the spec data to immediately follow the ib_flow_attr.
With the reversed order, flow_attr is the last member, so ib_flow
points past the end of the struct and the num_of_specs = 1 loop reads
out-of-bounds memory (whatever static data follows in the .data
section), producing incorrect flow rules or a crash.

Rebuild the leftovers attributes with DEFINE_RAW_FLEX(), which declares
an on-stack struct ib_flow_attr with a properly sized trailing flows[]
array.  The ETH spec lives in flows[0].eth at exactly the offset
_create_flow_rule() expects, so no layout-dependent composite struct is
needed.  This also avoids embedding a structure that contains a flexible
array member as a non-last member, which would trigger
-Wflex-array-member-not-at-end once the warning is enabled.

Fixes: e91fb8b9d0ed ("RDMA/mlx5: Avoid flexible array warning")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://patch.msgid.link/20260918092337.2338-1-lirongqing@baidu.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/fs.c | 45 +++++++++++++++------------------
 1 file changed, 21 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
index 5739d763029bd..b67994df98f2c 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -17,6 +17,7 @@
 #include <linux/mlx5/fs.h>
 #include <linux/mlx5/fs_helpers.h>
 #include <linux/mlx5/eswitch.h>
+#include <linux/overflow.h>
 #include <net/inet_ecn.h>
 #include "mlx5_ib.h"
 #include "counters.h"
@@ -1645,36 +1646,32 @@ static struct mlx5_ib_flow_handler *create_leftovers_rule(struct mlx5_ib_dev *de
 							  struct ib_flow_attr *flow_attr,
 							  struct mlx5_flow_destination *dst)
 {
+	DEFINE_RAW_FLEX(struct ib_flow_attr, flow_attr_wc, flows, 1);
+	DEFINE_RAW_FLEX(struct ib_flow_attr, flow_attr_uc, flows, 1);
+
 	struct mlx5_ib_flow_handler *handler_ucast = NULL;
 	struct mlx5_ib_flow_handler *handler = NULL;
 
-	static struct {
-		struct ib_flow_spec_eth eth_flow;
-		struct ib_flow_attr	flow_attr;
-	} leftovers_wc = { .flow_attr = { .num_of_specs = 1,
-					  .size = sizeof(leftovers_wc) },
-			   .eth_flow = {
-				   .type = IB_FLOW_SPEC_ETH,
-				   .size = sizeof(struct ib_flow_spec_eth),
-				   .mask = { .dst_mac = { 0x1 } },
-				   .val = { .dst_mac = { 0x1 } } } };
-
-	static struct {
-		struct ib_flow_spec_eth eth_flow;
-		struct ib_flow_attr	flow_attr;
-	} leftovers_uc = { .flow_attr = { .num_of_specs = 1,
-					  .size = sizeof(leftovers_uc) },
-			   .eth_flow = {
-				   .type = IB_FLOW_SPEC_ETH,
-				   .size = sizeof(struct ib_flow_spec_eth),
-				   .mask = { .dst_mac = { 0x1 } },
-				   .val = { .dst_mac = {} } } };
-
-	handler = create_flow_rule(dev, ft_prio, &leftovers_wc.flow_attr, dst);
+	flow_attr_wc->num_of_specs = 1;
+	flow_attr_wc->size = sizeof(struct ib_flow_attr) +
+			      sizeof(struct ib_flow_spec_eth);
+	flow_attr_wc->flows[0].eth.type = IB_FLOW_SPEC_ETH;
+	flow_attr_wc->flows[0].eth.size = sizeof(struct ib_flow_spec_eth);
+	flow_attr_wc->flows[0].eth.mask.dst_mac[0] = 0x1;
+	flow_attr_wc->flows[0].eth.val.dst_mac[0] = 0x1;
+
+	flow_attr_uc->num_of_specs = 1;
+	flow_attr_uc->size = sizeof(struct ib_flow_attr) +
+			      sizeof(struct ib_flow_spec_eth);
+	flow_attr_uc->flows[0].eth.type = IB_FLOW_SPEC_ETH;
+	flow_attr_uc->flows[0].eth.size = sizeof(struct ib_flow_spec_eth);
+	flow_attr_uc->flows[0].eth.mask.dst_mac[0] = 0x1;
+
+	handler = create_flow_rule(dev, ft_prio, flow_attr_wc, dst);
 	if (!IS_ERR(handler) &&
 	    flow_attr->type == IB_FLOW_ATTR_ALL_DEFAULT) {
 		handler_ucast = create_flow_rule(dev, ft_prio,
-						 &leftovers_uc.flow_attr, dst);
+						 flow_attr_uc, dst);
 		if (IS_ERR(handler_ucast)) {
 			mlx5_del_flow_rules(handler->rule);
 			ft_prio->refcount--;
-- 
2.53.0



