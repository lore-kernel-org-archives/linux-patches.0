Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049155;
	b=qLmaEuQAcV4TqdUia0nj4JcRhnTcHhhS5FGgvSMqbdKULd4QZn2Xf/3J7+e8rjX6oSd4
	 iGOjyzQxPljxenamLYI2v99F0ZqsA0o7M8LdOqR5m/pivkXXxpUsv1f8yoIWCQGjnRuZG
	 r3+dVI0+gYRo8sLDbsZW6he6hv90AhCXM+rzO5+GYTxp8FBEBSuB4UKTe0+3GKAMTS1S8
	 rGmrchE/OL67qBM8CIB2wHwOIQi27GCcusY/ezZRbXjqa8X/vdZ8grJYLMQWGoawFm2Lo
	 dYmQldfMuknd2nkVPlNRqwVkym0DHQEiIglICKiqKIzinXF5j1H+9uu0SEn8cDk0LaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049155;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bktHCkoNyZyhheJIDdlHA0drtmiI60by2qQU6K2wkJw=;
	b=QAOQ0DtXnBgV9f0gWGdNAH0ZEhkhrBEj9GFOSg05g6MBd7AnfyU1dwkwGEuppf9o86Yj
	 UJ5GEBzQWDEKqZa9fBJh19+bjQC2ufXn6vTCf1dElLXRCB7i1kPtFD+RnVbiVvkP6kHJ1
	 xPLmoXAREF0CGTf2pF1n9uZ6+4UrOyDJKf1wYKbwzJFTUgaX4n7jec/LUSleH+WA9dL0p
	 QZGDH6c+Mcpvc2xQ/41mSIo+BYCcsiGgxZ6TnlMfs1zovK13+SSk8FulyLJ+qDowsE1jG
	 tQQzFZbV2tn4stbWwQKV1LjdccxD7wLEPJbjYrc1B/sXsaEhxNdJze/wWsVP3rc4e5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fGf0OkZ9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A1D606A320;
	Thu, 19 Nov 2026 00:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fGf0OkZ9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BBC71F000C5;
	Thu, 19 Nov 2026 00:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049154;
	bh=bktHCkoNyZyhheJIDdlHA0drtmiI60by2qQU6K2wkJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fGf0OkZ9olWsSUg3NXjU3QEuzBePOvTTjEH9HVVFRarpNlnSQyM7IM2YvvS686dgN
	 lBiTBrfFyxQR5q4375zQikGcGg/jufEarJ96f7v6K5XWGhcCczmKAReyIzQbKKTyNV
	 DAvpxSaPTQp0bV9VEXYnakSRufLQABSvQ9lEWOII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2250/2857] dmaengine: ste_dma40: Fix probe runtime PM disable
Date: Wed, 18 Nov 2026 15:54:44 +0100
Message-ID: <20261118150322.453540997@linuxfoundation.org>
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
index c321aadf5680d..fda07f42ea62b 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3616,12 +3616,6 @@ static int __init d40_probe(struct platform_device *pdev)
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
@@ -3646,10 +3640,20 @@ static int __init d40_probe(struct platform_device *pdev)
 
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
@@ -3709,7 +3713,6 @@ static int __init d40_probe(struct platform_device *pdev)
 		regulator_disable(base->lcpa_regulator);
 		regulator_put(base->lcpa_regulator);
 	}
-	pm_runtime_disable(base->dev);
 
 	kfree(base->lcla_pool.alloc_map);
 	kfree(base->lookup_log_chans);
-- 
2.53.0



