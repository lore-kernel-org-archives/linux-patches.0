Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061252;
	b=WMz79ye0swtLs6UrvgO07Wnq8hEwrn2QIkRjp8A8+4oUHELE3rvNa03PLQA4OJEk8oEk
	 3YLCd1p9VQNRuQx4tKs9RJpwZQIFWN0EsahwFQzZ3chhQahza7HT+UZE6lqlcAnjmKDPe
	 tNpaWS+rq+HKjL0qEMF/9Bgd1eg1UH8qZOSiZ6zc2lhifC1RV3QdQVq3HKQh1qRO3WfVO
	 nqFMeBUPSGYqLXGV+jOxys+/SVu2x5VZiluVyeEm6jtr7X317MuDCYDLgBn/XKYaOq7Ry
	 WZVEgIQngAcKZse946kIS1oxAi9is5bEDtOVUBwiLS/RngOOG5BEIp08fIshG99IMUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061252;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8yu7Us7lUqUjoXZYFlbNfA2787/uvQAh4fuyII6tBpA=;
	b=Hn1j2ODvU4arKzRn2q4qgAe4MYlCzw9fI1vTet6n41xVlrmu+jkCu7uSPdjXjBC7r2hc
	 a3vKoOR7lv7L6dE92t77B/buNHxbq2f+xhRUCK6cEHb76FiEugK8zkzC3WNsW8Sugm38A
	 vl+iiMQYmbZqwMLClOdF3/hsT0vzgL8p9/nZALjxQ2PHKCAZWJBi2/Z6r8Cv3LLg/dgQe
	 smTIKfIrznkiorrnz1pQpfEhVCWJKjQqZmOWeaKNW9jCJLF1qcAfs4AtGbcA4v+/COJsn
	 DZcCBxR2yILFhk8wQqFv2xTYoVhwTAjxCHV/kivbdmcK37mH+NuLxGWB1TF7IGgJ0IA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uosQZtcE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D8360A2628;
	Thu, 19 Nov 2026 04:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uosQZtcE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB1641F000C4;
	Thu, 19 Nov 2026 04:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061252;
	bh=8yu7Us7lUqUjoXZYFlbNfA2787/uvQAh4fuyII6tBpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uosQZtcEjO2LOLcIu6iU9g7YY9eDJJ94XUIqozve9rGlfks97xzm0eY+rin2cSEi7
	 cCebOpWs5eySZwqSd7wSB3SBIobBgw4IHRhVXQ5HpBfAZiSpXuxlJeIl6BmQ3V9/Dc
	 gnd/JC9w+o86/0omAD1GaQWzdaNtfr3Bp0UdPJ7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1486/1848] dmaengine: ste_dma40: Remove redundant pm_runtime_mark_last_busy() calls
Date: Wed, 18 Nov 2026 15:58:44 +0100
Message-ID: <20261118150021.461590814@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9e1cdcc1552da..b495ee678363c 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1430,7 +1430,6 @@ static int d40_pause(struct dma_chan *chan)
 
 	res = d40_channel_execute_command(d40c, D40_DMA_SUSPEND_REQ);
 
-	pm_runtime_mark_last_busy(d40c->base->dev);
 	pm_runtime_put_autosuspend(d40c->base->dev);
 	spin_unlock_irqrestore(&d40c->lock, flags);
 	return res;
@@ -1457,7 +1456,6 @@ static int d40_resume(struct dma_chan *chan)
 	if (d40_residue(d40c) || d40_tx_is_linked(d40c))
 		res = d40_channel_execute_command(d40c, D40_DMA_RUN);
 
-	pm_runtime_mark_last_busy(d40c->base->dev);
 	pm_runtime_put_autosuspend(d40c->base->dev);
 	spin_unlock_irqrestore(&d40c->lock, flags);
 	return res;
@@ -1569,7 +1567,6 @@ static void dma_tc_handle(struct d40_chan *d40c)
 		if (d40_queue_start(d40c) == NULL) {
 			d40c->busy = false;
 
-			pm_runtime_mark_last_busy(d40c->base->dev);
 			pm_runtime_put_autosuspend(d40c->base->dev);
 		}
 	}
@@ -2050,16 +2047,13 @@ static int d40_free_dma(struct d40_chan *d40c)
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
@@ -2463,7 +2457,6 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 	if (is_free_phy)
 		d40_config_write(d40c);
  mark_last_busy:
-	pm_runtime_mark_last_busy(d40c->base->dev);
 	pm_runtime_put_autosuspend(d40c->base->dev);
 	spin_unlock_irqrestore(&d40c->lock, flags);
 	return err;
@@ -2615,12 +2608,9 @@ static int d40_terminate_all(struct dma_chan *chan)
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



