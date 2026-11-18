Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051394;
	b=IPXe+iHhMgTce4dBblEpVrhozsyyjvUSDsnq8pc3stX7G0FIdxZ1M6QtRzQo8/RtWA//
	 SR/dgvZgpHCGWSZVlXpzRPVn2Str+IpEHtUTS10ZMdDbD1VMD6PWSk8OAO2yXWpd6DLfH
	 o7T2yItU9OAftU3PYNomqsGo5KFnihA2IDs0EPk+lIgVAueIyYfF81BQVUytHCFCsgBuT
	 gLvktTJdYZxTRClxzezWAvqRbjrHyXhg9JNSVxasvnBHLWnR01ULfPhn8U8C85/eBeY+D
	 VwidZ/YwhFXlTKzR8lV4NDTGOfO+If98JLFdrVPvI0qWPbCBYkNd7gGBc8vMBmIZajQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051394;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DB51BmmjevonvHudXhUXFUaEIXn+5r0zbC5nwrLO5ZY=;
	b=DtlEdle0YpaqzrRag+O4qbHOFju2QwCMd8ZeOKVGdebgxKacE/w5OSt+3Es22x9cqtaI
	 HtXeaQQYBkV7/W1FgZv4DH11nKTmyzG4gbhpKKRBqWlWhy4xqRTTQYGUMAnw/DhAukHWL
	 jluGsn8mqtJm67NluIbAaVt1gO0UcdyGOPK7FlyGUx0lLqDadZb39HsX11N8wrlOBcNv1
	 ov6XnfIYSk+N27ySGKZoS3gK7X8pOgLhG+hbqVz0Z8rERR9/uOFONYLfUsB3WzVEa4boU
	 NQe1bu90gK4nVviOVzfA+dTKZHgfI6yWqHNIuEaz4BBifiI5AkX8dICFbr9x08PNVQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I6peCx3C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07173606A320;
	Thu, 19 Nov 2026 01:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I6peCx3C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A041F000C4;
	Thu, 19 Nov 2026 01:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051393;
	bh=DB51BmmjevonvHudXhUXFUaEIXn+5r0zbC5nwrLO5ZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I6peCx3CBwSsGgGS5qaSA+TioZ7Hdw9gxD7CeRdQ6RtQoHd15kH5r0lCw/mPJ7Evu
	 3hBsLOsn6NWMsXzLhHvM1SqlB4fwakNNxltWXs4b1yORJ8zSHwZFG7SMU1OBvySSz1
	 fFUhR5DJ5IUA+VTmh0E+dIIQcyelPHAzRu7gg0sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Andreas Kemnade <andreas@kemnade.info>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0192/2214] fbdev: omap2: dsi: do not copy isr table
Date: Wed, 18 Nov 2026 15:31:08 +0100
Message-ID: <20261118150017.882451306@linuxfoundation.org>
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

From: Andreas Kemnade <andreas@kemnade.info>

[ Upstream commit 31875c51c31edec57b3620f278680c23a823763b ]

To te able to unregister stuff from isrs, the corresponding table was
copied.  Nobody seems to unregister stuff that way, so it does not help.
But there are stack-allocated objects passed to these isrs giving chances
of UAF of these objects if irqs are unregistered while they are handled,
so better do not copy that table.

Suggested-by: sashiko-bot@kernel.org
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/omap2/omapfb/dss/dsi.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/video/fbdev/omap2/omapfb/dss/dsi.c b/drivers/video/fbdev/omap2/omapfb/dss/dsi.c
index db84a662e8de3..7fd7c1528f45e 100644
--- a/drivers/video/fbdev/omap2/omapfb/dss/dsi.c
+++ b/drivers/video/fbdev/omap2/omapfb/dss/dsi.c
@@ -325,8 +325,6 @@ struct dsi_data {
 
 	spinlock_t irq_lock;
 	struct dsi_isr_tables isr_tables;
-	/* space for a copy used by the interrupt handler */
-	struct dsi_isr_tables isr_tables_copy;
 
 	int update_channel;
 #ifdef DSI_PERF_MEASURE
@@ -837,15 +835,10 @@ static irqreturn_t omap_dsi_irq_handler(int irq, void *arg)
 		del_timer(&dsi->te_timer);
 #endif
 
-	/* make a copy and unlock, so that isrs can unregister
-	 * themselves */
-	memcpy(&dsi->isr_tables_copy, &dsi->isr_tables,
-		sizeof(dsi->isr_tables));
 
+	dsi_handle_isrs(&dsi->isr_tables, irqstatus, vcstatus, ciostatus);
 	spin_unlock(&dsi->irq_lock);
 
-	dsi_handle_isrs(&dsi->isr_tables_copy, irqstatus, vcstatus, ciostatus);
-
 	dsi_handle_irq_errors(dsidev, irqstatus, vcstatus, ciostatus);
 
 	dsi_collect_irq_stats(dsidev, irqstatus, vcstatus, ciostatus);
-- 
2.53.0



