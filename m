Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040850;
	b=bltRbN71/5hEvAyKZwaiCFusLNIxr4+ZtHu1bl3UBSUXr/nPwIJqd+uzTPnCuRPjTD9Q
	 BtiwOopDxwrK403AnsCH4X+do9KCnxMwYxRdue4li9eZ+Jd2NRrw1hkXoNopKtytdEvRi
	 xScfDcgEsV6PKTQfyqx2amhK5wXKoK9cvHL5oolNLbfwxOEqoSGsXVNPpa+/WnYbzu3HI
	 4CUuUPNND1x9hEz5HCVtbUytN+zhdUaAFsmz94Xigq/tavG6H/rjIZC4hzZ/4JFk2Ma3f
	 D8bzmYLYArV/2RHNXUjmmK9vLyo80IflEbQS0sYn9EdbsyAHSgQQdyQOyvp4LyDm/sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040850;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mxMI5OcLccgVhR4C+AK6B6OgxvJyDssepApbmQn2emU=;
	b=TXFmrNIpH9ionZxrG1H9gFzoUIBgl3HFb0+JD0d8iIbvdtpQRQcufTmNhPzAQGZN0mzj
	 c/ua3dZUN3Pfoc92vX3l+0ic/ojP8nn/kRSAIEEUVo3PlKBMS9zESjeF9xYUQpf+KzpTV
	 JXkjwicwb9yus92ENc5RyQaNlkRyrzJ9CNEgSHA4cSdMRx7pK7lWyO7cKye1vIbmtHZ2R
	 Rz1YsIqb9vgAfJMhpYRE3t5Px9WadGNvNTGMFbSXb9kLVQm6WzW6lZ9x9JQWMv51fXWVR
	 WR6stbR6S7F0K6X90V4qYcKuRFZVU6NO6VCK4atLcyGZ+08FIlwmCYU8PYSYZQMIE2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GJnhCSvg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A309606A332;
	Wed, 18 Nov 2026 22:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GJnhCSvg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3511F000C4;
	Wed, 18 Nov 2026 22:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040850;
	bh=mxMI5OcLccgVhR4C+AK6B6OgxvJyDssepApbmQn2emU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GJnhCSvg2+TTa3Y/nJBwHlRHIxllSUmQ/Mq6DQZrsWWEq2pQ5EBOt8EY3I7TlwYvb
	 VE2M1wgH0CMUN2BDkxv3Ls0NVtotvvdu+kRxGLTVYRIx6gvFUW4ntGZhu2VMvwTuX2
	 +3/Us3bEKowyXmN933geDfJsbLx/DEV3aeCyGcyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2604/3318] dmaengine: ste_dma40: Remove redundant pm_runtime_mark_last_busy() calls
Date: Wed, 18 Nov 2026 15:53:46 +0100
Message-ID: <20261118150439.278738071@linuxfoundation.org>
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 01f2bcf06d7e0e3c4badd03c030cf634ca10a172 ]

pm_runtime_put_autosuspend(), pm_runtime_put_sync_autosuspend(),
pm_runtime_autosuspend() and pm_request_autosuspend() now include a call
to pm_runtime_mark_last_busy(). Remove the now-reduntant explicit call to
pm_runtime_mark_last_busy().

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patch.msgid.link/20251027133232.392898-4-sakari.ailus@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 55a35231b8ce ("dmaengine: ste_dma40: Handle runtime PM resume errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index ef441a91017f8..dc718cf5a5807 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1454,7 +1454,6 @@ static int d40_pause(struct dma_chan *chan)
 
 	res = d40_channel_execute_command(d40c, D40_DMA_SUSPEND_REQ);
 
-	pm_runtime_mark_last_busy(d40c->base->dev);
 	pm_runtime_put_autosuspend(d40c->base->dev);
 	spin_unlock_irqrestore(&d40c->lock, flags);
 	return res;
@@ -1481,7 +1480,6 @@ static int d40_resume(struct dma_chan *chan)
 	if (d40_residue(d40c) || d40_tx_is_linked(d40c))
 		res = d40_channel_execute_command(d40c, D40_DMA_RUN);
 
-	pm_runtime_mark_last_busy(d40c->base->dev);
 	pm_runtime_put_autosuspend(d40c->base->dev);
 	spin_unlock_irqrestore(&d40c->lock, flags);
 	return res;
@@ -1593,7 +1591,6 @@ static void dma_tc_handle(struct d40_chan *d40c)
 		if (d40_queue_start(d40c) == NULL) {
 			d40c->busy = false;
 
-			pm_runtime_mark_last_busy(d40c->base->dev);
 			pm_runtime_put_autosuspend(d40c->base->dev);
 		}
 	}
@@ -2073,16 +2070,13 @@ static int d40_free_dma(struct d40_chan *d40c)
 	else
 		d40c->base->lookup_phy_chans[phy->num] = NULL;
 
-	if (d40c->busy) {
-		pm_runtime_mark_last_busy(d40c->base->dev);
+	if (d40c->busy)
 		pm_runtime_put_autosuspend(d40c->base->dev);
-	}
 
 	d40c->busy = false;
 	d40c->phy_chan = NULL;
 	d40c->configured = false;
  mark_last_busy:
-	pm_runtime_mark_last_busy(d40c->base->dev);
 	pm_runtime_put_autosuspend(d40c->base->dev);
 	return res;
 }
@@ -2485,7 +2479,6 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 	if (is_free_phy)
 		d40_config_write(d40c);
  mark_last_busy:
-	pm_runtime_mark_last_busy(d40c->base->dev);
 	pm_runtime_put_autosuspend(d40c->base->dev);
 	spin_unlock_irqrestore(&d40c->lock, flags);
 	return err;
@@ -2637,12 +2630,9 @@ static int d40_terminate_all(struct dma_chan *chan)
 		chan_err(d40c, "Failed to stop channel\n");
 
 	d40_term_all(d40c);
-	pm_runtime_mark_last_busy(d40c->base->dev);
 	pm_runtime_put_autosuspend(d40c->base->dev);
-	if (d40c->busy) {
-		pm_runtime_mark_last_busy(d40c->base->dev);
+	if (d40c->busy)
 		pm_runtime_put_autosuspend(d40c->base->dev);
-	}
 	d40c->busy = false;
 
 	spin_unlock_irqrestore(&d40c->lock, flags);
-- 
2.53.0



