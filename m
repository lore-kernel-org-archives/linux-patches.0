Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040894;
	b=PVj+WNtDhGHmYEOHndq2EUagXzsPlmqcxjfarqIq7NMkNOMdLHRLygMSshFNRQQPn2dH
	 PamJcEJlUC4hnCEvFFhXTKW0qrk4tvZqScSnSo2SJ8DiulB/ZgZrMo9H9kLGJ9QnraHDJ
	 NbdKwYDQEA5djj1lSSD33LFCL8KH0iPhPHQw5hdmgRPdQW60mXHKPQjNJdsPYUomVo1Ih
	 LE1ifbA5P4F57N1N6hOKc5MTIfkgzY2tQMb2vxC6SCqMQuoPqmXfDrnsL8sFJfPNKQPML
	 DYNMKNVzGDGMutDp/3d1PjoWQ2yi400egABb/wQIGZ8fSwiu5w5rL2XIdW23/Mhv0ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040894;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=87q2ICozs2D6iEH4OLXjJrCGjeVhgaWR8ZZfIX7trL4=;
	b=Mpt7E2mVvnIjF6swPCqM9NAdOM/IuO/ztjmUWpyBi4DjhoaO1eokeJ/Ql/Muyu8SDPsR
	 rvBFh4kQZVvpeYYR3BWNnD7ukn6b09vFX74B87VPugmnaucVxUNcMfOiKJ1HnpY3PP0jN
	 BWrkr1TeMGHIaJpRt4wI+6qvKingbCuvPWH2iKOZt9aE/FXyTJcpsvzoMopM8aTqyC/fR
	 JJGiJQ3pAiMS8slWO/7bmasXMGUFVrv4mqODAAsx4kzKVcxwdPeSTrgCZysWPPBFAMwnD
	 07qxBPFcfqVoWfm8weBSE1+qLZRgUjny8LjSxo0Fbe6Wxu6R3Uj2Um215LkXJ50449A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MTH+OHKH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F25B606A320;
	Wed, 18 Nov 2026 22:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MTH+OHKH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AEAA1F000C4;
	Wed, 18 Nov 2026 22:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040894;
	bh=87q2ICozs2D6iEH4OLXjJrCGjeVhgaWR8ZZfIX7trL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MTH+OHKHxZLjFJwBcF0VDKiYXOp8f62aM1eSQr2y7QupvopeO3AEed5nefmObWafs
	 iukjSdLO6Mn0rqDjp9wcMHE2t4/tIbKDKVfJzGB7cJhgucqw+eZnFXjE0TmL8BpAT4
	 ruCY09dKljN7u4z20ccHVpBdfThytP3zqTg6lKbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2618/3318] dmaengine: ste_dma40: Fix V4B event group mapping
Date: Wed, 18 Nov 2026 15:54:00 +0100
Message-ID: <20261118150439.657965353@linuxfoundation.org>
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
index b95794262df3b..4000335cd4211 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -84,6 +84,7 @@ struct stedma40_platform_data {
 /* Number of event groups per hardware register layout */
 #define D40_EVENT_GROUPS_V4A 4
 #define D40_EVENT_GROUPS_V4B 5
+#define D40_PHYS_PER_EVENT_GROUP 2
 
 /* Max number of logical channels per physical channel */
 #define D40_MAX_LOG_CHAN_PER_PHY 32
@@ -1898,6 +1899,12 @@ static bool d40_alloc_mask_free(struct d40_phy_res *phy, bool is_src,
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
@@ -1908,11 +1915,14 @@ static int d40_allocate_channel(struct d40_chan *d40c, bool *first_phy_user)
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
@@ -1946,13 +1956,18 @@ static int d40_allocate_channel(struct d40_chan *d40c, bool *first_phy_user)
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
@@ -1971,9 +1986,10 @@ static int d40_allocate_channel(struct d40_chan *d40c, bool *first_phy_user)
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
@@ -2000,14 +2016,17 @@ static int d40_allocate_channel(struct d40_chan *d40c, bool *first_phy_user)
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
@@ -3118,9 +3137,9 @@ static int __init d40_phy_res_init(struct d40_base *base)
 			base->phy_res[i].allocated_src = D40_ALLOC_PHY;
 			base->phy_res[i].allocated_dst = D40_ALLOC_PHY;
 			base->phy_res[i].reserved = true;
-			gcc |= D40_DREG_GCC_EVTGRP_ENA(D40_PHYS_TO_GROUP(i),
+			gcc |= D40_DREG_GCC_EVTGRP_ENA(d40_phy_to_group(base, i),
 						       D40_DREG_GCC_SRC);
-			gcc |= D40_DREG_GCC_EVTGRP_ENA(D40_PHYS_TO_GROUP(i),
+			gcc |= D40_DREG_GCC_EVTGRP_ENA(d40_phy_to_group(base, i),
 						       D40_DREG_GCC_DST);
 
 
@@ -3140,9 +3159,9 @@ static int __init d40_phy_res_init(struct d40_base *base)
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
index c504e855eb02b..b04c4e92b4ed0 100644
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



