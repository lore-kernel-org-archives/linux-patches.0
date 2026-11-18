Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055877;
	b=4T4jjv8V2cPn3c5dIotDXNoOBJ9Ke+yWv7hzlGNlX6XFFaTN2boM/ij9F+tBpnXV03Pl
	 ae1x6bppr440AxixPWsT259zu5WfMSqyaaUOgIvpydlGMTTnURQFVZ2QDaTxxuZfCLQzO
	 uBV6sqKnuQOJgAhVgshPkIT1xqjOY/sattIgX+17T0FBj7uxGntot0q65Vl8D4Ci9A0lL
	 8oPIkshR9PzWL+j9/jyXc9XKvXvzfpwFA4Q1NXGnc4lg4oKHzXeldZcuB/ArVBAhKLeGE
	 KQb3jgOby/CAsvofbRc7NbuU0WPIF+HxJLjvtw9Khl1x+QJoKznQE8RMpCbLWm3sgEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055877;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ovyi0jiMCaidJ3rYsdmnbjtjmS9PRW46XRo3pS4vLRw=;
	b=KlHNcTzOAyngcP3uy6N1JrzI9P9rf8utD6kNTRDLAroiMW5V+ho+0YhVzMhd79m4r6cj
	 N4AukQSVMXHSmp1rFI23iQnDu4Mqd2A3v7sV7QmAN0uDFQqSnnWPO489tSKYMoD95+3KA
	 MHbepElt4mkdsJk+vMCzCyJtcYoCb3TjyRNFo2Mq5mm27cuB0vZkMD+4bLiVbIWoOSA/i
	 WoL2ZuiL5fz4WZDkshX7yaMgxi8ippNfL0BVueVXJ1NMmsQ7suYVDRM2S/WE6CnRaQqJ3
	 K1qIoFLNxa2sAx0Ls9Ivv+1dCiW3SSvpLWxyqh5k6mxNwpLydn2S1DrMoWTC8iy0UpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hlK0jINm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAA3606A31C;
	Thu, 19 Nov 2026 02:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hlK0jINm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C28C1F000C4;
	Thu, 19 Nov 2026 02:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055876;
	bh=Ovyi0jiMCaidJ3rYsdmnbjtjmS9PRW46XRo3pS4vLRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hlK0jINmW1WEThVsItFU/9EIvi4pJiclomf8Hl0vKexmVkTKuzv8mMX0odN5CDsLG
	 nY5M0V7E5SkdOlAiBwvGqxyDfsgDNrC2G3yiuf/ZnNzBFfA7yyKa5vtpGCB9N6I1Dh
	 6+Ylx2mJ9J1cXsk/0tC6QWoJTGClSH+G9TftV718=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1771/2214] dmaengine: ste_dma40: Fix V4B event group mapping
Date: Wed, 18 Nov 2026 15:57:27 +0100
Message-ID: <20261118150122.361920082@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 92cff7b672c2b..86265890f10be 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -52,6 +52,7 @@
 /* Number of event groups per hardware register layout */
 #define D40_EVENT_GROUPS_V4A 4
 #define D40_EVENT_GROUPS_V4B 5
+#define D40_PHYS_PER_EVENT_GROUP 2
 
 /* Max number of logical channels per physical channel */
 #define D40_MAX_LOG_CHAN_PER_PHY 32
@@ -1885,6 +1886,12 @@ static bool d40_alloc_mask_free(struct d40_phy_res *phy, bool is_src,
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
@@ -1895,11 +1902,14 @@ static int d40_allocate_channel(struct d40_chan *d40c, bool *first_phy_user)
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
@@ -1933,13 +1943,18 @@ static int d40_allocate_channel(struct d40_chan *d40c, bool *first_phy_user)
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
@@ -1958,9 +1973,10 @@ static int d40_allocate_channel(struct d40_chan *d40c, bool *first_phy_user)
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
@@ -1987,14 +2003,17 @@ static int d40_allocate_channel(struct d40_chan *d40c, bool *first_phy_user)
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
@@ -3105,9 +3124,9 @@ static int __init d40_phy_res_init(struct d40_base *base)
 			base->phy_res[i].allocated_src = D40_ALLOC_PHY;
 			base->phy_res[i].allocated_dst = D40_ALLOC_PHY;
 			base->phy_res[i].reserved = true;
-			gcc |= D40_DREG_GCC_EVTGRP_ENA(D40_PHYS_TO_GROUP(i),
+			gcc |= D40_DREG_GCC_EVTGRP_ENA(d40_phy_to_group(base, i),
 						       D40_DREG_GCC_SRC);
-			gcc |= D40_DREG_GCC_EVTGRP_ENA(D40_PHYS_TO_GROUP(i),
+			gcc |= D40_DREG_GCC_EVTGRP_ENA(d40_phy_to_group(base, i),
 						       D40_DREG_GCC_DST);
 
 
@@ -3127,9 +3146,9 @@ static int __init d40_phy_res_init(struct d40_base *base)
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



