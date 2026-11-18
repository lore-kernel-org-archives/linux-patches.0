Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015465;
	b=3GoK+JeP10R4hjUJGoaT8nEKn8XbmOd1Gh1OokUpYmriQ2c2XysE5hmS5I8cKetfPgc4
	 g9CfY4xRg4pmAu6ec5RjEqE2XYWHq9TqlGIdgrTorSsbHs4YgWtWvoveOYNmb3ftX7qZ6
	 WN+hkYhpBQK/lKA9z5wAF6t4+pdIDn2RvGsITkp+3rSZCHzOwWTiq8Eed8WBv8NvXyAmt
	 l1hh48yomDiyTteiZeeq1zSK+p8suohA20Sbg0U7cYQxsscHwGl40eDEcCdJGOR72rRRk
	 KqHobNDwjEyxPisNrnOl0NrhbnRtolVyBqzWQw3sUWgFXDjgMGyPCynPXF1DRm2afgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015465;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9wdZiB0xfBgA66xfH20RUmiwiLvF8YGjgAM4NpgyKHc=;
	b=ml8lTy2R6DOO5Ps8b7HlHF9OLwmcaLmd/o4A2SPNS3oIT6TNsnNOzknY3bQL/p5Uj0d5
	 Epg4Vl1YcEW+/ldx2nMPBhbAIzzlwfa7RGMdk5DeUFDH1ijAbv3eoCIBaaajv9r8uBjXi
	 GQ4zq77fZjt+r3qZ/2XnT+aVJRC5kSb9AGVpZCLjWVVvWwZOIgcV0yoBf3FIRgzzJTb8C
	 BLE5D32Vnj1Vip1UosDI1E7FHb7oYMCJDM2XEcmVqGgN9RdQq0KZgTDnCvjPgfV9VumA4
	 XqYx+2mSlqukEYDjtScF3H+oaiP0mjw1vQ8tBLm3BdOJkFL1SRe72Jk/E8lAT1UAoFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="u/F7ibFL";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83873606A325;
	Wed, 18 Nov 2026 15:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u/F7ibFL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D945A1F000C4;
	Wed, 18 Nov 2026 15:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015465;
	bh=9wdZiB0xfBgA66xfH20RUmiwiLvF8YGjgAM4NpgyKHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u/F7ibFL+YV3eRXSXFJQNtwzjT0bkmmvrCjbynWzCAxn2hcBC5ADl62UjfXvbbZ/a
	 B6fdTt1hBIZ7EbwoZm4zuz2Wt2euz7E3ZQaLD9ByOyYbfguodkftywYq90f8SgCy+I
	 ekHAeakdm2FDazvh+1BIjVcU/8JpIudEU1RDCNDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0183/2651] dmaengine: fsl_raid: dont invoke client callback under desc_lock
Date: Wed, 18 Nov 2026 15:23:43 +0100
Message-ID: <20261118150254.451331280@linuxfoundation.org>
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
index 2d86f61105e52..bfaef6245695e 100644
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



