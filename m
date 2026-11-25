Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618119;
	b=MhIfZ2YON1IE54gzmK+xzyO1htufX5/l5uvSavqtEb/ULo8ICorlopuKZW7VCbtyr2oT
	 EAXGNbcYT/qy7jhyxITjuqm3HKUTao2SRh5ss7/IKNr8jll1PC1oZ6AqJdiTHJRau+15y
	 et6CfjblXwHzzyacs5FDSPutvPWz9UQiDKQrKx05GoZRixFw9RRTPJK5i7RuQicBs+Fgl
	 b/F8jfJZs/mG5ItpSieNlKv9v5ceVDp62PSehVVKEhMpRiXIgfADTnqdsJkco75W6HP75
	 rOREj4ASB16sqSdYaExkr4jzHidBoWGnm7bT6+GoQdLeIMsb4AaYusbib5b/jzm09Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618119;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8UQhFrG+qHX2Wl4y2/9pKy5YjDGVzDTRzV/fnFibLT8=;
	b=b3zde1eLEtkDqXxaLxDVt3kvhNLPFv20jGC9yUOGQq2QV+S5SblidA3xa4bIifZ5NsxE
	 sqcZL0T3tF+ZQLTlvhEFTwNvHSmER+X8WqCzd9bYM3/Jt7sW/KsTzdVQevhUfZf81foJg
	 DVX8WebR4/p8DipGXKwhLnkqkdhX3qNmtR5o/ab8JRbeUlhzPRp/2FV2SlRBn/JbylWn4
	 vF9BCHIWPZm48EeSapvOrXMbgYH3c5UGtfvVjtu7fMcu6TXF6zTG+HHchVifFgm9qPPwm
	 M2wy8WbXIGN26fB5ValqupwdOOq1ujWwRSdyA1zD2PB1RTWf4AWlhhTLavGQ+S4ERMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zXYqqNOK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB95606A31E;
	Wed, 25 Nov 2026 14:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zXYqqNOK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4796A1F000C4;
	Wed, 25 Nov 2026 14:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618118;
	bh=8UQhFrG+qHX2Wl4y2/9pKy5YjDGVzDTRzV/fnFibLT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zXYqqNOKo+HhyV6QrmfLxvPLs2h9ojG9UNF/Ls2hfDgo559vJJ+W01iDTtAcJDjB3
	 LmPgi3UgP9EhMXesJFxxZOIik0z5QPBoHodIRMvnVZtAGfHCNE808NyCp/wvUtfKNG
	 cNMRhOyLbw9WzN0ga2M079MPB5Cb3muQgPujwykQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0179/1005] ASoC: meson: axg-fifo: request the irq with the clock enabled
Date: Wed, 25 Nov 2026 15:25:17 +0100
Message-ID: <20261125143825.935230916@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 82fa7bfab6b961a03d6575348334e0ec15fdc712 ]

The fifo irq handler accesses registers which need pclk, but the irq is
requested before pclk is enabled on open and freed after it is disabled
on close.

Request the irq after enabling pclk and masking the fifo irqs.
Free it before disabling pclk.

Fixes: 6dc4fa179fb8 ("ASoC: meson: add axg fifo base driver")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-30e88a8a-f33a-40f0-92aa-9ea62c5b7299
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://patch.msgid.link/20261030-asoc-axg-fifo-irq-clock-v1-1-f8c170ac8b0d@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/axg-fifo.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/sound/soc/meson/axg-fifo.c b/sound/soc/meson/axg-fifo.c
index 75909196b7698..edf43b7fb5cf5 100644
--- a/sound/soc/meson/axg-fifo.c
+++ b/sound/soc/meson/axg-fifo.c
@@ -244,17 +244,10 @@ int axg_fifo_pcm_open(struct snd_soc_component *component,
 	if (ret)
 		return ret;
 
-	/* Use the threaded irq handler only with non-atomic links */
-	ret = request_threaded_irq(fifo->irq, NULL,
-				   axg_fifo_pcm_irq_block,
-				   IRQF_ONESHOT, dev_name(dev), ss);
-	if (ret)
-		return ret;
-
 	/* Enable pclk to access registers and clock the fifo ip */
 	ret = clk_prepare_enable(fifo->pclk);
 	if (ret)
-		goto free_irq;
+		return ret;
 
 	/* Setup status2 so it reports the memory pointer */
 	regmap_update_bits(fifo->map, FIFO_CTRL1,
@@ -271,17 +264,24 @@ int axg_fifo_pcm_open(struct snd_soc_component *component,
 	/* Clear any pending interrupt */
 	axg_fifo_ack_irq(fifo, FIFO_INT_MASK);
 
+	/* Use the threaded irq handler only with non-atomic links */
+	ret = request_threaded_irq(fifo->irq, NULL,
+				   axg_fifo_pcm_irq_block,
+				   IRQF_ONESHOT, dev_name(dev), ss);
+	if (ret)
+		goto free_clk;
+
 	/* Take memory arbitror out of reset */
 	ret = reset_control_deassert(fifo->arb);
 	if (ret)
-		goto free_clk;
+		goto free_irq;
 
 	return 0;
 
-free_clk:
-	clk_disable_unprepare(fifo->pclk);
 free_irq:
 	free_irq(fifo->irq, ss);
+free_clk:
+	clk_disable_unprepare(fifo->pclk);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(axg_fifo_pcm_open);
@@ -295,12 +295,12 @@ int axg_fifo_pcm_close(struct snd_soc_component *component,
 	/* Put the memory arbitror back in reset */
 	ret = reset_control_assert(fifo->arb);
 
-	/* Disable fifo ip and register access */
-	clk_disable_unprepare(fifo->pclk);
-
 	/* remove IRQ */
 	free_irq(fifo->irq, ss);
 
+	/* Disable fifo ip and register access */
+	clk_disable_unprepare(fifo->pclk);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(axg_fifo_pcm_close);
-- 
2.53.0



