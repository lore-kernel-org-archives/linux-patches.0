Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030987;
	b=wzxqK7ZTd81tDycZFoAAZLE7BEORdaKumFi5DLNVvva8qSKT7U/VmDZ2ARxEwXgsQ+Ji
	 7NL+c6Fcvk6n8HYA6Wbj9Y0TZS1x7Ym+xmpJS81RJ6VOecOARUsRDSEAqSsO3RSrwicUg
	 Py0Zp9U5nERL65WafqnQh2C9w7HmZ/I3SEwlsDCYHQa1lc5RBBfBJrNENhGlI4X9TnsAS
	 uDivVzNEAuyFjHXwGoxxxsKrOPwwK7vLUp7bsS2gnaIaK5j1cBBlkiCbnyHQut1Vr7ChA
	 NaUEppp9GeTug1Eo8+GRpIU9qBCulFrb4J49iHLB3iR3R/aMx1NhFbs6tEjfIyXjyAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030987;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xLrUI1A67ASx9R4OGLAdaDYrBT9F+czOrc4W6xK1WZg=;
	b=p/sIli79wEQBhjs56yCybXUNzfT+Qhzd8+D7Otpg4heVH/VvmzIChB5vuBVhgMT5LfX1
	 FqI9kbO7kSRSmV+JmLUXrJQTJGGNX6V2EsmhOwJKVZ0Sj0BR0erSM0ntFORVGKx/7lDTe
	 2U6tnWsXV4aoqnG4+BJKZwFksabZcAH0Ns1oh/vQxnTvXNm/tfDBKr84Ha2S/7GvvqS5a
	 97yKMgVLFfm2LoCaIYsuYOHNWhWhEYzoBZ7r1zeCJFkAEORUmrsvgnj7HhnKjfgepH6f3
	 i/1BGC/Cz+sVzazWHBOP4/NqL08/uhQcYue09MH7oHGjNUjG/bGLoHc2X1cpchh4how==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CmVLPVt9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44D2606A31C;
	Wed, 18 Nov 2026 19:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CmVLPVt9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA9A1F000C4;
	Wed, 18 Nov 2026 19:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030986;
	bh=xLrUI1A67ASx9R4OGLAdaDYrBT9F+czOrc4W6xK1WZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CmVLPVt92M9y5MS1FrPAKY4il7pATPzUXbbDZzD/arClliAmaw6QlU/dagSJ769I9
	 MFoRbImbdfFBI5y7oQYd5ePAGdya8OyopnxPQwyFmGTMcWMdoDlin4K3hkV2nsGpDc
	 awuzKqLo2LK0rpVw6pc1YTwZpgKX8jJ1UVJTRaic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0898/1756] dmaengine: ste_dma40: Fix V4B event group mapping
Date: Wed, 18 Nov 2026 15:50:25 +0100
Message-ID: <20261118150045.770598892@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index aeb0e66dbfdbe..da0c85a9fabb5 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -82,6 +82,7 @@ struct stedma40_platform_data {
 /* Number of event groups per hardware register layout */
 #define D40_EVENT_GROUPS_V4A 4
 #define D40_EVENT_GROUPS_V4B 5
+#define D40_PHYS_PER_EVENT_GROUP 2
 
 /* Max number of logical channels per physical channel */
 #define D40_MAX_LOG_CHAN_PER_PHY 32
@@ -1896,6 +1897,12 @@ static bool d40_alloc_mask_free(struct d40_phy_res *phy, bool is_src,
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
@@ -1906,11 +1913,14 @@ static int d40_allocate_channel(struct d40_chan *d40c, bool *first_phy_user)
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
@@ -1944,13 +1954,18 @@ static int d40_allocate_channel(struct d40_chan *d40c, bool *first_phy_user)
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
@@ -1969,9 +1984,10 @@ static int d40_allocate_channel(struct d40_chan *d40c, bool *first_phy_user)
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
@@ -1998,14 +2014,17 @@ static int d40_allocate_channel(struct d40_chan *d40c, bool *first_phy_user)
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
@@ -3144,9 +3163,9 @@ static int __init d40_phy_res_init(struct d40_base *base)
 			base->phy_res[i].allocated_src = D40_ALLOC_PHY;
 			base->phy_res[i].allocated_dst = D40_ALLOC_PHY;
 			base->phy_res[i].reserved = true;
-			gcc |= D40_DREG_GCC_EVTGRP_ENA(D40_PHYS_TO_GROUP(i),
+			gcc |= D40_DREG_GCC_EVTGRP_ENA(d40_phy_to_group(base, i),
 						       D40_DREG_GCC_SRC);
-			gcc |= D40_DREG_GCC_EVTGRP_ENA(D40_PHYS_TO_GROUP(i),
+			gcc |= D40_DREG_GCC_EVTGRP_ENA(d40_phy_to_group(base, i),
 						       D40_DREG_GCC_DST);
 
 
@@ -3166,9 +3185,9 @@ static int __init d40_phy_res_init(struct d40_base *base)
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



