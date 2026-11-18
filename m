Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040844;
	b=M3qAPFad9age6dmqUpBvx1W0+kAyKoTnbzOppHid3NdH/AdaU9YNm04Hyff85dNRODoT
	 vOzKyN9okkd27Rv3NBWbeqQT+iSv67N8U009syz4MdKUUP9T0YZMCRuAxuLEElIRD83Jj
	 OaQoCBtA70NnC5g+N6h1GHvh2Z8BXJpauERV7eqSfyGC7w9bH4CbRFUspOhujWmNcvBVF
	 2X5iwNkYvoDmvpVvmBJD8wzxkVuAtBcC63zzGv2GnxQF8R6J5AcZwgWPu2DAM6mJCqIP+
	 9o0SNr8K+GW3SLIJAEvSCBVmxojImu+ybBbak8YnNXCMCaPqgZwFRmxMh1wcMvHf1rQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040844;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZITStjNDxQyCLHYUlz9tk9EAUkIZxYW4OV8qexREfOs=;
	b=HOjqv86/eyOU27o6DflbQuhxi1MuvDdw0vD1w9sV9yv4VnCIfYDuCXNsEwEMYmobNE2m
	 /DlsgH0tYed3wpDxYqFY1751aQbJUvkYOcRUNZAp/hv56sNho5K7Mta4jRqWz4h2glUCs
	 POoyDk83YAPPoCq4B2LU1QErLi35J8w4IQqy31AtZdQSTNKg4NiewdX0uUvS7uRdVUXSt
	 QDhhl71WD8ech4GWFMCAjk/tNIJ6NC8c1ezpXLhZrbyeRwkrcsdxCD/yaaOmHimoJwadD
	 4d3katfprDtGI6OKQGy145LxMjjE21iI1qbhR3hCFfKc4+Rgc9JAwE3eMM6jILQrEFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WPt4qQJj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF8F606A320;
	Wed, 18 Nov 2026 22:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WPt4qQJj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E1A1F000C4;
	Wed, 18 Nov 2026 22:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040844;
	bh=ZITStjNDxQyCLHYUlz9tk9EAUkIZxYW4OV8qexREfOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WPt4qQJjQwKzPTk64q/qBz2Y+9O/ZuwWOWKx94z3MvINMjvbtckPNwno8HRuC9uKg
	 dQLmq0SU6LnSZp43o79HGoQDxzCz+KYm8yKdQe9lhd8gMmMyb/j2KqJ0OqQEGYG0OH
	 fV71lfid5Pb4D1VKjJJhSDjKInlUNRwl1znZcCa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2602/3318] dmaengine: ste_dma40: Fix probe runtime PM disable
Date: Wed, 18 Nov 2026 15:53:44 +0100
Message-ID: <20261118150439.222947451@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit c6809b381e34f8966cc3d9e5d7d658775a408f83 ]

Some d40_probe() error paths jump to destroy_cache before runtime PM has
been enabled for the DMA controller device. The label unconditionally calls
pm_runtime_disable(), which increments disable_depth even though this probe
attempt never enabled runtime PM.

Use devm_pm_runtime_set_active_enabled() to mark the controller active,
enable runtime PM and register balanced cleanup for probe failure. This
avoids both the disable-depth imbalance and ad-hoc probe state tracking.

The interrupt handler uses pm_runtime_get_if_active() and cannot
acknowledge a pending interrupt while runtime PM is disabled. Request the
IRQ only after enabling runtime PM so the handler cannot enter an
unacknowledged interrupt loop during probe.

Fixes: 0618c077a8c2 ("dmaengine: ste_dma40: Fix PM disable depth imbalance in d40_probe")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/dmaengine/20260618051539.15E201F000E9@smtp.kernel.org/
Assisted-by: LLM
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-5-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index fe3f968cd2fb2..445ea0a56d3d1 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3604,12 +3604,6 @@ static int __init d40_probe(struct platform_device *pdev)
 		goto destroy_cache;
 	}
 
-	ret = request_irq(base->irq, d40_handle_interrupt, 0, D40_NAME, base);
-	if (ret) {
-		d40_err(dev, "No IRQ defined\n");
-		goto destroy_cache;
-	}
-
 	if (base->plat_data->use_esram_lcla) {
 
 		base->lcpa_regulator = regulator_get(base->dev, "lcla_esram");
@@ -3634,10 +3628,20 @@ static int __init d40_probe(struct platform_device *pdev)
 
 	pm_runtime_irq_safe(base->dev);
 	pm_runtime_set_autosuspend_delay(base->dev, DMA40_AUTOSUSPEND_DELAY);
-	pm_runtime_use_autosuspend(base->dev);
 	pm_runtime_mark_last_busy(base->dev);
-	pm_runtime_set_active(base->dev);
-	pm_runtime_enable(base->dev);
+
+	ret = devm_pm_runtime_set_active_enabled(base->dev);
+	if (ret) {
+		d40_err(dev, "Failed to enable runtime PM: %d\n", ret);
+		goto destroy_cache;
+	}
+	pm_runtime_use_autosuspend(base->dev);
+
+	ret = request_irq(base->irq, d40_handle_interrupt, 0, D40_NAME, base);
+	if (ret) {
+		d40_err(dev, "No IRQ defined\n");
+		goto destroy_cache;
+	}
 
 	ret = d40_dmaengine_init(base, num_reserved_chans);
 	if (ret)
@@ -3677,7 +3681,6 @@ static int __init d40_probe(struct platform_device *pdev)
 		regulator_disable(base->lcpa_regulator);
 		regulator_put(base->lcpa_regulator);
 	}
-	pm_runtime_disable(base->dev);
 
  report_failure:
 	d40_err(dev, "probe failed\n");
-- 
2.53.0



