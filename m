Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049160;
	b=18JFPBUGrsnZTGSSgVMv5fvv0C9m6HXCvK+BhUvPXub1foRAF7gmuJNTOOwkk/9lwrzo
	 cemZhtxdXhakOaQrzEaD8Rxdvezdx+wqP9Y0JKE53hxFAF5zV/JR7kXukhLsmU6RjHa/t
	 w0tzvkoO/wfa6dM43ng1AfTvMKU5PjDPrioEsAlZcY5e/N63tKILj46FtdniCSndABmrJ
	 GH8buRE2/asYQCx2/boklYeTPUARTvvxyNPE9aSc0aJPwk3CcZmH8kNcpBhyAbxox0Amb
	 FsotxY4+mqLZQmfNZSvAr/V9dSAHRzwajOxCY6yheXXtpbMVKu8Y4y3zU/ZFqhxt3Lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049160;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=secAwSfovrCsf275K5lQOUP6pjz53Qg7DvGuQx6CsLM=;
	b=Zr2ZZNs3zccfcQr0ouoYfyjgyC5yELaWiWBQrg9XK/5KW+tpzjfF2o23N/aHGCwlKSng
	 P5fJ8zyrgDBoG+w8MS4VLGIUaxIDfxa/h5tGnepqad8gVrt1XHjIwzu+6JNLyPVzu9nm2
	 sPWcII2/CkN6kNVP1xJpjJev6JiHU0/slTJdqcvqJ/XzEuOx5FFsM1+KbZSwoFBaLShb7
	 k9LTIEksyeFVLMt5K7xu7bpUXoW2B9r+6fbnCjBERx3/KzYS1eGYS0EbI9JQfB+wCT48A
	 ZXmI4nmV/74HMeafNCbMDLc8Zs1eX/7xdSyN4qfpQCqxReELUqauz5mv1NL/UD1ILkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WZ7on6X2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6699A606A32C;
	Thu, 19 Nov 2026 00:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WZ7on6X2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81691F000C4;
	Thu, 19 Nov 2026 00:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049160;
	bh=secAwSfovrCsf275K5lQOUP6pjz53Qg7DvGuQx6CsLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WZ7on6X2HS1vkt71WeLiGLrY0kd4KRkPqMtjh6LxbNBxY0PkdNxAsBaQyIrk/nXxQ
	 tCaWXvXpv+f9dUzegQbtoEFixpQ4PR1yafH40C9v+s1svnodYljG8e8K5L7RlcnwGP
	 1Z5dLHcu0DX5SQnDjBv9ZuwpTRRAaBULj9naHpYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2252/2857] dmaengine: ste_dma40: Remove redundant pm_runtime_mark_last_busy() calls
Date: Wed, 18 Nov 2026 15:54:46 +0100
Message-ID: <20261118150322.529541064@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 894aceac6cec5..6b572fe2973ba 100644
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
@@ -2049,16 +2046,13 @@ static int d40_free_dma(struct d40_chan *d40c)
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
@@ -2462,7 +2456,6 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 	if (is_free_phy)
 		d40_config_write(d40c);
  mark_last_busy:
-	pm_runtime_mark_last_busy(d40c->base->dev);
 	pm_runtime_put_autosuspend(d40c->base->dev);
 	spin_unlock_irqrestore(&d40c->lock, flags);
 	return err;
@@ -2614,12 +2607,9 @@ static int d40_terminate_all(struct dma_chan *chan)
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



