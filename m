Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025545;
	b=fDPNikYxxRwMKA6npEdIE8oeRzoiB/El6QWsnkLLSt7buOofM8O/y+AoqIE/OntyS6Rx
	 NBKWpnpOjhM/iljNVNUmcz8lF/+a2h6AziPOqBuGdjCncJ2/oY2AbZ+S1tN42YM5f6kIs
	 wp1PTgn/su77/5lfels7VPWpeAYGdMiEBcJID2Lz+7VgYKmwyS+pF6c847s4W33ZWN5c7
	 wexuuvp+mUnFgROj7ZWoP9K0wLEYBAv/2UsXzFiJ4jztJgs2dDNTsdZ+2z3rPu5A7/cfe
	 ssy6Biv559FHaA3BtqQ7gbX0y4H7v3rIQq4+K2TMviFZ7jzHa10ksayomkOIelGuauQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025545;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nSfpGsUAmxJOfu1wqvwlccFmj9RYJgspNJSA3qhos1Y=;
	b=wocKsfuUPn2+o1+a9DHgvcumtKwHg0bUGt/zSKeQUvroiVVeJC6Kp2nk1xPiOsWNcOrf
	 YE7SreXQHyKv1wLR1j86VuqChcwZ9xTV3MKE2GRwmf+rZSxOXSQR/LcvMYr9LNRlgJXP/
	 h3o7kRP/pKoygNi58ykVXGD7NR0WUoYMdF5iQZ01UjLIkD/u/3NMTUvqDwuuuiyQQ997C
	 FpS2KkeMCSwf7VeInaXxxc0ZItYeqmipxHSH00upRt3u2F9osN5skc4wpnDKtLVUZlj0g
	 pbL1vDPyOx9DCgl+2j8GQsXyQBKngzfzigNcxETZyIi6w6E0RsPaq4bhJr0Gz046iug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nUTwVCAR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536A7606A31C;
	Wed, 18 Nov 2026 18:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nUTwVCAR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F22A1F000C4;
	Wed, 18 Nov 2026 18:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025545;
	bh=nSfpGsUAmxJOfu1wqvwlccFmj9RYJgspNJSA3qhos1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nUTwVCARQWQOSR7RhQ1s97Ly3Msf6nVj/88bHCT8OFEXxeXmuQ0hlbovGMIv95JW0
	 viT66tMmyOg8co5y5ctUIGeJ/1DashAJpWKHkgrBtoXMvfeQVF2dS69Ya7ruQr4WJv
	 VYCeE3yxG9Jz6gcXmCfy8HByGqbjrs9XC+Q1/2I0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1118/2151] dmaengine: ste_dma40: Handle runtime PM resume errors
Date: Wed, 18 Nov 2026 15:47:33 +0100
Message-ID: <20261118150202.945842562@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 55a35231b8ced2250a7743ec350a9566d553780e ]

Several channel operations use pm_runtime_get_sync() and access DMA40
registers without checking whether runtime resume succeeded. If resume
fails, the registers may be inaccessible. pm_runtime_get_sync() also
increments the usage counter on failure, making error unwinding easy to
unbalance.

Use pm_runtime_resume_and_get() and avoid register access when resume
fails. Acquire the runtime PM reference before allocating a channel so
failure needs no channel-allocation rollback.

If a queued transfer cannot be started because resume failed, retire all
issued descriptors through the normal tasklet path. Since
dma_async_issue_pending() cannot return an error, leaving them queued would
make clients wait indefinitely for callbacks.

Termination and channel release must also clean up software state when the
controller cannot resume. d40_term_all() only releases descriptor state and
does not access DMA40 registers, so it remains unconditional.

Balance each transient runtime PM reference in its successful acquisition
block, without bookkeeping flags. Release the outstanding busy reference
and channel allocation state when freeing a channel. Skip only the hardware
stop that requires register access.

Fixes: 7fb3e75e1833 ("dmaengine/ste_dma40: support pm in dma40")
Assisted-by: LLM
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-7-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 74 +++++++++++++++++++++++++++++------------
 1 file changed, 52 insertions(+), 22 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index f196bfe416001..a1c126a3a499b 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1448,11 +1448,14 @@ static int d40_pause(struct dma_chan *chan)
 		return 0;
 
 	spin_lock_irqsave(&d40c->lock, flags);
-	pm_runtime_get_sync(d40c->base->dev);
+	res = pm_runtime_resume_and_get(d40c->base->dev);
+	if (res < 0)
+		goto unlock;
 
 	res = d40_channel_execute_command(d40c, D40_DMA_SUSPEND_REQ);
 
 	pm_runtime_put_autosuspend(d40c->base->dev);
+ unlock:
 	spin_unlock_irqrestore(&d40c->lock, flags);
 	return res;
 }
@@ -1472,13 +1475,16 @@ static int d40_resume(struct dma_chan *chan)
 		return 0;
 
 	spin_lock_irqsave(&d40c->lock, flags);
-	pm_runtime_get_sync(d40c->base->dev);
+	res = pm_runtime_resume_and_get(d40c->base->dev);
+	if (res < 0)
+		goto unlock;
 
 	/* If bytes left to transfer or linked tx resume job */
 	if (d40_residue(d40c) || d40_tx_is_linked(d40c))
 		res = d40_channel_execute_command(d40c, D40_DMA_RUN);
 
 	pm_runtime_put_autosuspend(d40c->base->dev);
+ unlock:
 	spin_unlock_irqrestore(&d40c->lock, flags);
 	return res;
 }
@@ -1515,8 +1521,20 @@ static struct d40_desc *d40_queue_start(struct d40_chan *d40c)
 
 	if (d40d != NULL) {
 		if (!d40c->busy) {
+			err = pm_runtime_resume_and_get(d40c->base->dev);
+			if (err < 0) {
+				chan_err(d40c, "Failed to resume DMA: %d\n",
+					 err);
+				do {
+					d40_desc_remove(d40d);
+					d40_desc_done(d40c, d40d);
+					d40c->pending_tx++;
+					d40d = d40_first_queued(d40c);
+				} while (d40d);
+				tasklet_schedule(&d40c->tasklet);
+				return ERR_PTR(err);
+			}
 			d40c->busy = true;
-			pm_runtime_get_sync(d40c->base->dev);
 		}
 
 		/* Remove from queue */
@@ -2030,9 +2048,6 @@ static int d40_free_dma(struct d40_chan *d40c)
 	struct d40_phy_res *phy = d40c->phy_chan;
 	bool is_src;
 
-	/* Terminate all queued and active transfers */
-	d40_term_all(d40c);
-
 	if (phy == NULL) {
 		chan_err(d40c, "phy == null\n");
 		return -EINVAL;
@@ -2054,11 +2069,18 @@ static int d40_free_dma(struct d40_chan *d40c)
 		return -EINVAL;
 	}
 
-	pm_runtime_get_sync(d40c->base->dev);
-	res = d40_channel_execute_command(d40c, D40_DMA_STOP);
-	if (res) {
-		chan_err(d40c, "stop failed\n");
-		goto mark_last_busy;
+	/* Release descriptor state; this does not access DMA40 registers. */
+	d40_term_all(d40c);
+
+	res = pm_runtime_resume_and_get(d40c->base->dev);
+	if (res >= 0) {
+		res = d40_channel_execute_command(d40c, D40_DMA_STOP);
+		if (res)
+			chan_err(d40c, "stop failed\n");
+
+		pm_runtime_put_autosuspend(d40c->base->dev);
+		if (res)
+			return res;
 	}
 
 	d40_alloc_mask_free(phy, is_src, chan_is_logical(d40c) ? event : 0);
@@ -2074,8 +2096,6 @@ static int d40_free_dma(struct d40_chan *d40c)
 	d40c->busy = false;
 	d40c->phy_chan = NULL;
 	d40c->configured = false;
- mark_last_busy:
-	pm_runtime_put_autosuspend(d40c->base->dev);
 	return res;
 }
 
@@ -2434,10 +2454,14 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 		err = d40_config_memcpy(d40c);
 		if (err) {
 			chan_err(d40c, "Failed to configure memcpy channel\n");
-			goto mark_last_busy;
+			goto unlock;
 		}
 	}
 
+	err = pm_runtime_resume_and_get(d40c->base->dev);
+	if (err < 0)
+		goto unlock;
+
 	err = d40_allocate_channel(d40c, &is_free_phy);
 	if (err) {
 		chan_err(d40c, "Failed to allocate channel\n");
@@ -2445,8 +2469,6 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 		goto mark_last_busy;
 	}
 
-	pm_runtime_get_sync(d40c->base->dev);
-
 	d40_set_prio_realtime(d40c);
 
 	if (chan_is_logical(d40c)) {
@@ -2478,6 +2500,7 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 		d40_config_write(d40c);
  mark_last_busy:
 	pm_runtime_put_autosuspend(d40c->base->dev);
+ unlock:
 	spin_unlock_irqrestore(&d40c->lock, flags);
 	return err;
 }
@@ -2622,19 +2645,26 @@ static int d40_terminate_all(struct dma_chan *chan)
 
 	spin_lock_irqsave(&d40c->lock, flags);
 
-	pm_runtime_get_sync(d40c->base->dev);
-	ret = d40_channel_execute_command(d40c, D40_DMA_STOP);
-	if (ret)
-		chan_err(d40c, "Failed to stop channel\n");
+	ret = pm_runtime_resume_and_get(d40c->base->dev);
+	if (ret >= 0) {
+		ret = d40_channel_execute_command(d40c, D40_DMA_STOP);
+		if (ret)
+			chan_err(d40c, "Failed to stop channel\n");
+
+		pm_runtime_put_autosuspend(d40c->base->dev);
+	}
 
+	/*
+	 * Always release software state, even when the controller cannot
+	 * resume. d40_term_all() does not access DMA40 registers.
+	 */
 	d40_term_all(d40c);
-	pm_runtime_put_autosuspend(d40c->base->dev);
 	if (d40c->busy)
 		pm_runtime_put_autosuspend(d40c->base->dev);
 	d40c->busy = false;
 
 	spin_unlock_irqrestore(&d40c->lock, flags);
-	return 0;
+	return ret;
 }
 
 static int
-- 
2.53.0



