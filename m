Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015468;
	b=zM81NY9oOAPMkyZAbrak9uHRpXtQB3bCaPnoRClnNbOLr1b5am73xrwZc8NJ50K6YrzT
	 v29DTBd9noYVP4+rSDu8j7chpi3Ily7CedlGCrfhQpGjQFXfk8+rV/FvkmZnr3jRBQQF8
	 Z3xa0Q35EYMpFBUVW5E0rVNSinDrcrLkAox1vv1CGEMKs9TrJ8gWtL7uAXlJhcRzv+xAD
	 ZxqpQY/DuvqFOk2chEj+xMTwbIQm358jLgcNahxfBXzlbtMAiCDrw+tS86TuQTgpAFMYb
	 /fT163QeYRivJWuZ6hWgyC69ZJGo+FKYXipPvR/XTVsoHWjGiwVEpaAVnIDAjDW589g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015468;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rqvwYxHc+OORfRwf5W4H0LMLKvo19ZBEDGodRNLHCNQ=;
	b=VeLGgzCJxuU1X6GYFG1iItNEacKOWiy0vwX/+cYo1xippymUvrPXfc6nJ1lily7i3lxE
	 WTCtdQ2c/nNYs0nwsgQh70AtmrXTZuiClAMPiu7E1vTuMm6dPm+0cJ0FC/azYLYWo7mvZ
	 Aq+x8+5Yzsi44EM3Ap3E6MKf9lX0GhZ+wPSnKr2VtBmiznKM1NYLgI9gGVzynuQVteomM
	 pWTBwbz5ZvkSLaaLDwM5luGaYz1UrS9a7XrxRsW76XU+U/aIqvtI/mRXTI0j4dlwOEdka
	 xDY+zFW2Guu5BxfGNPJjkJ7sFs+3/AjP7rS/uxOhBT6JENJVSWi1rp7r56QStqlep0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WV2RosbU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525A4606A325;
	Wed, 18 Nov 2026 15:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WV2RosbU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50911F000C5;
	Wed, 18 Nov 2026 15:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015468;
	bh=rqvwYxHc+OORfRwf5W4H0LMLKvo19ZBEDGodRNLHCNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WV2RosbUjRUyMJoTVO69u6dPy9BTJ5uz+ATuLe3M8SVvRwVBdi8F7E6Cwe4CIscJn
	 R+ctr/1KhwuPuV4Gu2R+cXPom3RKz40tD2ubNLujDVc4uYEe5uDSmeipZWk4Ito7Df
	 nrg3MQxlr82FwhJIiGhPR1iNEBa5/+BWuUy2aafw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0184/2651] dmaengine: fsl_raid: avoid free_q underflow in free_chan_resources
Date: Wed, 18 Nov 2026 15:23:44 +0100
Message-ID: <20261118150254.486641966@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit d805aa5b6088b193debabaa80cc0991bfa2bd057 ]

fsl_re_free_chan_resources() loops alloc_count times calling
list_first_entry() on free_q without checking whether the list still
has entries. If descriptors remain un-acked or pending in submit_q /
active_q / ack_q when the channel resources are freed, free_q becomes
smaller than alloc_count and list_first_entry() returns the list head,
causing list_del() to corrupt the list head and dereference a bogus
pointer.

Walk free_q with list_for_each_entry_safe() until it is empty,
decrementing alloc_count per freed descriptor, instead of relying on
the alloc_count count.

Fixes: ad80da658bbc ("dmaengine: Driver support for FSL RaidEngine device.")
Assisted-by: opencode:hy3-free
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260718235227.385108-1-rosenp@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsl_raid.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/fsl_raid.c b/drivers/dma/fsl_raid.c
index bfaef6245695e..e698c40b2ebca 100644
--- a/drivers/dma/fsl_raid.c
+++ b/drivers/dma/fsl_raid.c
@@ -614,18 +614,15 @@ static int fsl_re_alloc_chan_resources(struct dma_chan *chan)
 static void fsl_re_free_chan_resources(struct dma_chan *chan)
 {
 	struct fsl_re_chan *re_chan;
-	struct fsl_re_desc *desc;
+	struct fsl_re_desc *desc, *_desc;
 
 	re_chan = container_of(chan, struct fsl_re_chan, chan);
-	while (re_chan->alloc_count--) {
-		desc = list_first_entry(&re_chan->free_q,
-					struct fsl_re_desc,
-					node);
-
+	list_for_each_entry_safe(desc, _desc, &re_chan->free_q, node) {
 		list_del(&desc->node);
 		dma_pool_free(re_chan->re_dev->cf_desc_pool, desc->cf_addr,
 			      desc->cf_paddr);
 		kfree(desc);
+		re_chan->alloc_count--;
 	}
 
 	if (!list_empty(&re_chan->free_q))
-- 
2.53.0



