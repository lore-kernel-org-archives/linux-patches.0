Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018857;
	b=Z9o/XUsZ8d0B7HwO0f77dDkZKa2TLTfx+ajqYcnGKoXMM3PIyISG4r/ti0UsADdMjthp
	 h6JOF/BfN3yB7K1rBxF6qYGthFuagNKI5OPaBniOA11ZSQmjLkc5BJ58C2r0IBO8QrFQv
	 jHbZ7kUL/DxYWb39EeCYIjuWgDM+QTb92I7Efxms9QtnG8nRczAnhFSWg+ilumJK+fSSg
	 ameGdG5vPR2gZkTvTqcB37qsT+8K1fRL73kFCuC9YbnzzvRE7X1xRn0vstw2LKxcupMX+
	 vaQcp6odtOb07kHQA6HY4iryUSZEJETh1tjPKvPDsQoNdi2jSJAF+SeLX+RUHEZfV/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018857;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DsaRjkJvSmx6m8wjvPU5KrmzE14bD2dcxUSvYQYyjh8=;
	b=ZYECZ5rnreH0fcIUf7k2RCusETnF6h+U6tVZvHVuyizpBVRDPBtM/M3wSoC5wwETvjKk
	 pp5v8kyqXQLqIlcPxtSLQ2Af9mwa5BzSVwDo1uhYCHfqBMGQYpxVmsE3A4QYMj+gYLAhU
	 utG1PSJPot5qFOX6W4v67aJ9XoszepYaOFGtstcwAxUmqm5Wer4hAA9RWnNy+pXYXjlTe
	 eR5hcVQO/BJexj7zuYo7BwlIVD3vXeOV/a90B21ixnUYJjsCmxyLPAsFXO3DB41nKd1c+
	 JOxR9kyPekFky7BCWsWkF9yVKhX1CMP5BRHnvuh+xnGRl+MDtcLFWt5zTJsQ5GtLOcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="J/N7/9Tt";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B39F606A320;
	Wed, 18 Nov 2026 16:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J/N7/9Tt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F4A1F000C4;
	Wed, 18 Nov 2026 16:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018856;
	bh=DsaRjkJvSmx6m8wjvPU5KrmzE14bD2dcxUSvYQYyjh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J/N7/9Tt68F4AgaU/mbYHZaQavFZuCar1wNjKhBnawcwBk8SIH4oVpjF8oB9qcMB6
	 ywhlqw2bQe00bcjI86W3xaBkR8M2BsMQ9A2uUQeLzUgN9I9s8rF2LOOPFDW/j+zp/t
	 HX/3zqGKSaQjt3CTs3rmBNyiwIfN3tbGsL+tT7oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1352/2651] dmaengine: ste_dma40: Fix V4B event group mapping
Date: Wed, 18 Nov 2026 15:43:12 +0100
Message-ID: <20261118150336.699698007@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit b36f8fce7314fed53563c60e683ff86deb8a51ae ]

DMA40 physical resources are connected in pairs to event groups. The
mapping repeats after each complete set of groups.

D40_GROUP_SIZE and D40_PHYS_TO_GROUP() encode the four-group V4A layout.
On V4B, which has five groups, resources 8 and 9 are consequently offered
both to event groups 0 and 4. The GCC clock bookkeeping also treats these
resources as group 0 instead of group 4.

Derive the physical-resource stride and reverse mapping from the
variant-specific number of event groups. This preserves the V4A mapping
and gives V4B a ten-resource stride: resources 8 and 9 belong only to
group 4, while resources 10 and 11 repeat group 0.

Fixes: 3cb645dc85a0 ("dmaengine: ste_dma40: support more than 128 event lines")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-21-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c    | 47 ++++++++++++++++++++++++++------------
 drivers/dma/ste_dma40_ll.h |  2 --
 2 files changed, 33 insertions(+), 16 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 91dc143f9a808..a5471a9157cd4 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -85,6 +85,7 @@ struct stedma40_platform_data {
 /* Number of event groups per hardware register layout */
 #define D40_EVENT_GROUPS_V4A 4
 #define D40_EVENT_GROUPS_V4B 5
+#define D40_PHYS_PER_EVENT_GROUP 2
 
 /* Max number of logical channels per physical channel */
 #define D40_MAX_LOG_CHAN_PER_PHY 32
@@ -2027,6 +2028,12 @@ static bool d40_alloc_mask_free(struct d40_phy_res *phy, bool is_src,
 	return is_free;
 }
 
+static int d40_phy_to_group(struct d40_base *base, int phy)
+{
+	return (phy / D40_PHYS_PER_EVENT_GROUP) %
+	       base->gen_dmac.num_event_groups;
+}
+
 static int d40_allocate_channel(struct d40_chan *d40c, bool *first_phy_user)
 {
 	int dev_type = d40c->dma_cfg.dev_type;
@@ -2037,11 +2044,14 @@ static int d40_allocate_channel(struct d40_chan *d40c, bool *first_phy_user)
 	int j;
 	int log_num;
 	int num_phy_chans;
+	int phy_group_stride;
 	bool is_src;
 	bool is_log = d40c->dma_cfg.mode == STEDMA40_MODE_LOGICAL;
 
 	phys = d40c->base->phy_res;
 	num_phy_chans = d40c->base->num_phy_chans;
+	phy_group_stride = D40_PHYS_PER_EVENT_GROUP *
+			   d40c->base->gen_dmac.num_event_groups;
 
 	if (d40c->dma_cfg.dir == DMA_DEV_TO_MEM) {
 		log_num = 2 * dev_type;
@@ -2075,13 +2085,18 @@ static int d40_allocate_channel(struct d40_chan *d40c, bool *first_phy_user)
 				}
 			}
 		} else
-			for (j = 0; j < d40c->base->num_phy_chans;
-			     j += D40_GROUP_SIZE) {
-				int phy_num = j  + event_group * 2;
-				if (phy_num + 1 >= num_phy_chans)
+			for (j = 0; j < num_phy_chans;
+			     j += phy_group_stride) {
+				int phy_num = j + event_group *
+					      D40_PHYS_PER_EVENT_GROUP;
+
+				if (phy_num + D40_PHYS_PER_EVENT_GROUP >
+				    num_phy_chans)
 					break;
 
-				for (i = phy_num; i < phy_num + 2; i++) {
+				for (i = phy_num;
+				     i < phy_num + D40_PHYS_PER_EVENT_GROUP;
+				     i++) {
 					if (d40_alloc_mask_set(&phys[i],
 							       is_src,
 							       0,
@@ -2100,9 +2115,10 @@ static int d40_allocate_channel(struct d40_chan *d40c, bool *first_phy_user)
 		return -EINVAL;
 
 	/* Find logical channel */
-	for (j = 0; j < d40c->base->num_phy_chans; j += D40_GROUP_SIZE) {
-		int phy_num = j + event_group * 2;
-		if (phy_num + 1 >= num_phy_chans)
+	for (j = 0; j < num_phy_chans; j += phy_group_stride) {
+		int phy_num = j + event_group * D40_PHYS_PER_EVENT_GROUP;
+
+		if (phy_num + D40_PHYS_PER_EVENT_GROUP > num_phy_chans)
 			break;
 
 		if (d40c->dma_cfg.use_fixed_channel) {
@@ -2129,14 +2145,17 @@ static int d40_allocate_channel(struct d40_chan *d40c, bool *first_phy_user)
 		 * channels.
 		 */
 		if (is_src) {
-			for (i = phy_num; i < phy_num + 2; i++) {
+			for (i = phy_num;
+			     i < phy_num + D40_PHYS_PER_EVENT_GROUP;
+			     i++) {
 				if (d40_alloc_mask_set(&phys[i], is_src,
 						       event_line, is_log,
 						       first_phy_user))
 					goto found_log;
 			}
 		} else {
-			for (i = phy_num + 1; i >= phy_num; i--) {
+			for (i = phy_num + D40_PHYS_PER_EVENT_GROUP - 1;
+			     i >= phy_num; i--) {
 				if (d40_alloc_mask_set(&phys[i], is_src,
 						       event_line, is_log,
 						       first_phy_user))
@@ -3307,9 +3326,9 @@ static int __init d40_phy_res_init(struct d40_base *base)
 			base->phy_res[i].allocated_src = D40_ALLOC_PHY;
 			base->phy_res[i].allocated_dst = D40_ALLOC_PHY;
 			base->phy_res[i].reserved = true;
-			gcc |= D40_DREG_GCC_EVTGRP_ENA(D40_PHYS_TO_GROUP(i),
+			gcc |= D40_DREG_GCC_EVTGRP_ENA(d40_phy_to_group(base, i),
 						       D40_DREG_GCC_SRC);
-			gcc |= D40_DREG_GCC_EVTGRP_ENA(D40_PHYS_TO_GROUP(i),
+			gcc |= D40_DREG_GCC_EVTGRP_ENA(d40_phy_to_group(base, i),
 						       D40_DREG_GCC_DST);
 
 
@@ -3329,9 +3348,9 @@ static int __init d40_phy_res_init(struct d40_base *base)
 		base->phy_res[chan].allocated_src = D40_ALLOC_PHY;
 		base->phy_res[chan].allocated_dst = D40_ALLOC_PHY;
 		base->phy_res[chan].reserved = true;
-		gcc |= D40_DREG_GCC_EVTGRP_ENA(D40_PHYS_TO_GROUP(chan),
+		gcc |= D40_DREG_GCC_EVTGRP_ENA(d40_phy_to_group(base, chan),
 					       D40_DREG_GCC_SRC);
-		gcc |= D40_DREG_GCC_EVTGRP_ENA(D40_PHYS_TO_GROUP(chan),
+		gcc |= D40_DREG_GCC_EVTGRP_ENA(d40_phy_to_group(base, chan),
 					       D40_DREG_GCC_DST);
 		num_phy_chans_avail--;
 	}
diff --git a/drivers/dma/ste_dma40_ll.h b/drivers/dma/ste_dma40_ll.h
index 2e30e9a94a1e3..55090cb310579 100644
--- a/drivers/dma/ste_dma40_ll.h
+++ b/drivers/dma/ste_dma40_ll.h
@@ -16,8 +16,6 @@
 
 #define D40_TYPE_TO_GROUP(type) (type / 16)
 #define D40_TYPE_TO_EVENT(type) (type % 16)
-#define D40_GROUP_SIZE 8
-#define D40_PHYS_TO_GROUP(phys) ((phys & (D40_GROUP_SIZE - 1)) / 2)
 
 /* Most bits of the CFG register are the same in log as in phy mode */
 #define D40_SREG_CFG_MST_POS		15
-- 
2.53.0



