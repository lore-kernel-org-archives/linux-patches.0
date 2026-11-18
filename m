Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022990;
	b=E8K74+uAgK/bTTZEUVVfdeLuC/a2mvB5GnH+PXo2k0Z84y7Lc2VJkaYaq3Nfz5VJQ0Lw
	 4fAKRq0cTGn5vdIApL6IAB7gKLTUfPNzcjsuXw3EJ8FcR9N8HDJH5apZSOdaQarHAs8VT
	 pH8nhvz6gOEbuerJs0r/fa3NI+6tJ0J0oErF1waerjQd2BIBPCHDHMtbJ+BJOSS5wtHNP
	 R5dVd21QiwhsgTM4VUre0OHbI87HzbLkAQ50EGZVfTHDxv69lNKAdLnglWbsqbvwyBs8m
	 gz48t8ozt19qrwp2ouRqu6dbmczEic+YwLQF+7pIBuQHN/bs5AuhdsLIqOJaHLmfwWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022990;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=czzWrGNj7S/aL4/pf6omUgw3WKXGXozPkSLaKFP1sTs=;
	b=DYxz/Rvn1GjB0h6tCsl6aZBnjl4FTJGRLCJWeQNqZ+Tt0R/9KzhPAyi5rWfFn4Fx/5Cl
	 pWiLxmBxFmBmqfAhGhcVRjkn4LqYJHbhj6Jzna0tKG2lqezewXIZwyMi2pT0JmCVZWCIV
	 ETQjiAw/2ur70TBvw3ByKdNBMyMv0W9WT+55Rvnh4UNJK3i4+LAg5cv+Ig6JAn/D+ANEC
	 uxeGL5vfAULeB8jFKzvDOk+Gw8SI3+L8qxAHoKye7iV4dOmhE+tJ7XAfgcFJU6mcHawQi
	 P6cVXZwfXOYfk1uds4ess0p9crmCUay2DNENJ0rWd3noz5oi7hp+wh8svEVRMWKkVDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZnpIyBqn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75CD606A31C;
	Wed, 18 Nov 2026 17:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZnpIyBqn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D721F000C4;
	Wed, 18 Nov 2026 17:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022989;
	bh=czzWrGNj7S/aL4/pf6omUgw3WKXGXozPkSLaKFP1sTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZnpIyBqno2hhTkhBLjZ9993pk5AjrSzugpaAVJkmiQYczCKQ8H9tufyXfbZMXiXnN
	 7zU+ycu01CBlVSCVr2nN/8+a8W/Vvo5O+k2sl3Xcj3eZC7coWNCNKlXgTX6cA5y9nM
	 YuDlcGzjG9MzPG0FXvtukH9qdJB1AgJ+GEw3XIqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0209/2151] dmaengine: fsl_raid: dont invoke client callback under desc_lock
Date: Wed, 18 Nov 2026 15:32:24 +0100
Message-ID: <20261118150129.395044004@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 62c267ce97444f8a381f2bb3cd5d534eb362c540 ]

fsl_re_dequeue() holds re_chan->desc_lock while calling
fsl_re_desc_done(), which synchronously invokes the DMA client completion
callback via dmaengine_desc_get_callback_invoke(). If that callback
submits new work (e.g. fsl_re_tx_submit()), it tries to reacquire the
same desc_lock and deadlocks on the spinlock.

Collect completed descriptors into a local list under the lock, then
release the lock and invoke the callbacks before moving the descriptors
to the ack queue.

Fixes: ad80da658bbc ("dmaengine: Driver support for FSL RaidEngine device.")
Assisted-by: opencode:hy3-free
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260718053010.3074329-1-rosenp@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsl_raid.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/fsl_raid.c b/drivers/dma/fsl_raid.c
index 6aa97e258a557..ad77694520e9e 100644
--- a/drivers/dma/fsl_raid.c
+++ b/drivers/dma/fsl_raid.c
@@ -162,6 +162,7 @@ static void fsl_re_dequeue(struct tasklet_struct *t)
 	struct fsl_re_hw_desc *hwdesc;
 	unsigned long flags;
 	unsigned int count, oub_count;
+	LIST_HEAD(completed);
 	int found;
 
 	fsl_re_cleanup_descs(re_chan);
@@ -182,8 +183,7 @@ static void fsl_re_dequeue(struct tasklet_struct *t)
 		}
 
 		if (found) {
-			fsl_re_desc_done(desc);
-			list_move_tail(&desc->node, &re_chan->ack_q);
+			list_move_tail(&desc->node, &completed);
 		} else {
 			dev_err(re_chan->dev,
 				"found hwdesc not in sw queue, discard it\n");
@@ -196,6 +196,17 @@ static void fsl_re_dequeue(struct tasklet_struct *t)
 			 FSL_RE_RMVD_JOB(1));
 	}
 	spin_unlock_irqrestore(&re_chan->desc_lock, flags);
+
+	/* Invoke the client callbacks outside the channel lock. The callback
+	 * may submit new work which re-acquires desc_lock, so holding it here
+	 * would deadlock.
+	 */
+	list_for_each_entry_safe(desc, _desc, &completed, node) {
+		fsl_re_desc_done(desc);
+		spin_lock_irqsave(&re_chan->desc_lock, flags);
+		list_move_tail(&desc->node, &re_chan->ack_q);
+		spin_unlock_irqrestore(&re_chan->desc_lock, flags);
+	}
 }
 
 /* Per Job Ring interrupt handler */
-- 
2.53.0



