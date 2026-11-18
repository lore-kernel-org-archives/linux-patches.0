Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025658;
	b=wxelw8x2w2V6w51++ddigpWmJM16W62394pJA7dv3V1y2WF58GI9uHL/03ZgN6uwMHOI
	 FqZ0wJLQXDybXZFEwRvCnD4CxeXVHM50n3hY/EnZ6yMy3pXSaf1fAJLH96S3XDvOF6S74
	 aBZN6O68Enk+X8oZbcTx5vCYmDpF/3pxajlCqMTsArCVCYmrJccq/6gvQCRlXnsu+4F94
	 /7We7f10vmmrNMCpPBwv+W4W1l2ZmfZ11+00moSOztQ1ajhyI1ipxDCSafFhbNjcpHoKu
	 bnRBrnlc17vjIOWWKxgkFZYEzaUFR1ZY6jNC4j28BbM2TdBLq8Q9I7h0jo6WSxyWYSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025658;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EvT541z7W4iQ/AsP5EADI+VL+ZOY56YoNRFp23aseAM=;
	b=xA5+4KMKfXuuT5De2hYWjCsDNcsORjk9JIapEnHJ/79Ojqhp4d1+uZODfVzZ4gjgKfid
	 aibBFocHyWeDhM9O5t0mA6oK7PRAzq9PTZoITlp6reFFQap0fcn78XG0ibe0I9KOalBCr
	 2zk7xic7V1c/0gcfoMQG+C2yAGrlJkNGl8yHwC7avL2GmEAlw7KGiBMZ2Biiu0OGc4M/j
	 0bNdAV2WedMKgtpdfZAD9aG8HiiOzoQrG6vV8UIOtQryyHbGetEfsyD5syC3PUhPO07r9
	 TD78uW2L4WTRjZ2P/tu+hUPr+rgPtQJLW1V8XZH6SBuY0+kl0cms/INeLU4KyOmuNJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Cj/fiuOf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A0A606A325;
	Wed, 18 Nov 2026 18:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cj/fiuOf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859F61F000C4;
	Wed, 18 Nov 2026 18:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025658;
	bh=EvT541z7W4iQ/AsP5EADI+VL+ZOY56YoNRFp23aseAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cj/fiuOfSkKYjGJmCNX1qINMEyMwN/IZjxRSWulnu5ZUVSIuGPXmCc92hPUUfauEF
	 J6ht9HuuHG3iXSRVGJ3AmAu6IU3isFRUWC1AeoGvbeZMsyJ7SbspnXPEQxFgL+bRIY
	 wLG/Rno180ZtFemoK+R4l7jXRldz0hjqZT/A7Pp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1115/2151] dmaengine: ste_dma40: Fix probe runtime PM disable
Date: Wed, 18 Nov 2026 15:47:30 +0100
Message-ID: <20261118150202.841018095@linuxfoundation.org>
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
index 2f636c7333d24..08d1c2197ded5 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3602,12 +3602,6 @@ static int __init d40_probe(struct platform_device *pdev)
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
@@ -3632,10 +3626,20 @@ static int __init d40_probe(struct platform_device *pdev)
 
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
@@ -3671,7 +3675,6 @@ static int __init d40_probe(struct platform_device *pdev)
 		regulator_disable(base->lcpa_regulator);
 		regulator_put(base->lcpa_regulator);
 	}
-	pm_runtime_disable(base->dev);
 
  report_failure:
 	d40_err(dev, "probe failed\n");
-- 
2.53.0



