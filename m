Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025542;
	b=V6F29TNg7VD4r/1hVThL8DVV2GhWDynDLY3i3Iob/Jgsn70eeL+vzNuxsmMbOZ1dG7gm
	 i4fLOuEnhZ2RIoO0n3dfZ8IvtHzqy+PLLFocFwqoc2UiXgDpLDntyJZwij7HRFFJKIGvc
	 GekW52mDQWEi40wh0zXIsFbnKgcnaC6QU7d2orzA5CIGavb9jTcMoEKgSyqrptU3oH5lU
	 Mv+4uKdIgFQNUAaU/0K54NbCEdVQXLlo32aGwey6adkPa43CFT0yWWuekqsLfMw1h8RmS
	 UBiT+qLtfTiUTXJfHy+/g6oRVriioflcj3O2wsLof+TIrJt9n8sF/NNhimF3mcGvEaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025542;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5KmC+cIPeJiJ63DIHqEpAU6NuSyolYJ5iOdSy0UQp+s=;
	b=s+4vQXG4Dtvr414WaRRPtiqep8b+xiQ7Ot/oZTXShjiirWM5tzsne1ah08G6573CyeW4
	 XJq0jFLn4m+165MIfuQ6sKCsZWX3mfE2Dm70pHHlB+9wwDWwedwgw1EXfamB57YaCPPZL
	 XlW26GFywaid9aoA1Wtt2B17qf1hNRKCUQlG3FbQDg+O3vE+etlxTO+5Rlqf/GycuCQqo
	 uV9Bn1ajy0ORutjyu0e7j5MEdrUYlRicOtMGDmPMnp9d+cnYbRTNricYszkGqMmRyWkw6
	 /7sMK4STOlTbLYwsZlAn5ahlAJxasfayAzrSdlDOpytrlPF7mHGX66j/4obsfkfdnNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h+p5Uibg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E48F606A31C;
	Wed, 18 Nov 2026 18:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h+p5Uibg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC861F000C4;
	Wed, 18 Nov 2026 18:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025542;
	bh=5KmC+cIPeJiJ63DIHqEpAU6NuSyolYJ5iOdSy0UQp+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h+p5UibgWOHdDWylPEGwTos0p14Se+fVa60opIVNFo2ja5ovQyKIHjbzBZQV1S6Yy
	 OCiI2UktruwMyf4/giROQm8obIYqo0hNeDDwJxaA7n8PcJxYGMNivVHypBuHTPkKIF
	 zyZ64JyM3JkFgiMv8kramnaWX8vfk7frs48bv94I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1117/2151] dmaengine: ste_dma40: Remove redundant pm_runtime_mark_last_busy() calls
Date: Wed, 18 Nov 2026 15:47:32 +0100
Message-ID: <20261118150202.908947155@linuxfoundation.org>
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
index df373c5b6b9f2..f196bfe416001 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1452,7 +1452,6 @@ static int d40_pause(struct dma_chan *chan)
 
 	res = d40_channel_execute_command(d40c, D40_DMA_SUSPEND_REQ);
 
-	pm_runtime_mark_last_busy(d40c->base->dev);
 	pm_runtime_put_autosuspend(d40c->base->dev);
 	spin_unlock_irqrestore(&d40c->lock, flags);
 	return res;
@@ -1479,7 +1478,6 @@ static int d40_resume(struct dma_chan *chan)
 	if (d40_residue(d40c) || d40_tx_is_linked(d40c))
 		res = d40_channel_execute_command(d40c, D40_DMA_RUN);
 
-	pm_runtime_mark_last_busy(d40c->base->dev);
 	pm_runtime_put_autosuspend(d40c->base->dev);
 	spin_unlock_irqrestore(&d40c->lock, flags);
 	return res;
@@ -1591,7 +1589,6 @@ static void dma_tc_handle(struct d40_chan *d40c)
 		if (d40_queue_start(d40c) == NULL) {
 			d40c->busy = false;
 
-			pm_runtime_mark_last_busy(d40c->base->dev);
 			pm_runtime_put_autosuspend(d40c->base->dev);
 		}
 	}
@@ -2071,16 +2068,13 @@ static int d40_free_dma(struct d40_chan *d40c)
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
@@ -2483,7 +2477,6 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 	if (is_free_phy)
 		d40_config_write(d40c);
  mark_last_busy:
-	pm_runtime_mark_last_busy(d40c->base->dev);
 	pm_runtime_put_autosuspend(d40c->base->dev);
 	spin_unlock_irqrestore(&d40c->lock, flags);
 	return err;
@@ -2635,12 +2628,9 @@ static int d40_terminate_all(struct dma_chan *chan)
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



