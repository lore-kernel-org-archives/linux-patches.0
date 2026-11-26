Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705047;
	b=c5yh8y0ACSswFWdXRH85XSG6Sgz6I3TsQt3PIjZEwML61OmpS1HHU1sTlXCON6Z/m10c
	 r2gzwWpGTgAtCC83wzqR0QpQ4RXlIENR9X4lCwSle2H5j8aclvO+bU3vUpvyaaxL6LwRv
	 3VrW8+W7Mhgzm0/IpY4PdaBrY8ZIlBwovnVuRO2Pyry5BynUFE0zG5tJXbI+7Z2LabYBN
	 jzFlbgUPHU9scuwmQmfadCZfWv/GCCUZKHh++DqIzirse7WNJF2e25PZukTWEY1JEEzSa
	 Lh7Dnbna08D4lt5BCEyy5Ze6FaSbUozpYRogbW58MFAtlU81jVi8Foe+zeM3MNEPDNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705047;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9GgSlj1+2Cj7Kb3P1dUHwPZf0GrxwIb8CEgahJjnvkI=;
	b=wfaofufQkokdhS/Z7DTlBEha7ICbWrh36ASnu0KyLdMsVaWNEebOBZtErdnqaMo8kwN+
	 JzIQIIKmMhi8TIzjRiFSk7muuTt03YkuC9T/32Fuymhy8+v+Gq8Q+4Id26meZpaPNNd/V
	 vT+qY86jxo+xhg+pWB9+7gp4Dp5Sn3FcdeEfchAv9/uIvxC8yhp/s05o4m0ThCrja4sYL
	 tOSqgwLl/ZgvZeCvVcB8QoLh8/nBpoZ5avgKim+ICt2nBJBP+h81gat0kn+ocjzzlMVRN
	 mabDIoOqeB9NJY5HCa4Gnz2m8Be7iiANYaZ4h8uXsGzUeFdIhBsZwWEtk3vdEt9guyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T106dF+M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A0B606A31E;
	Thu, 26 Nov 2026 14:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T106dF+M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D725F1F000F4;
	Thu, 26 Nov 2026 14:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705047;
	bh=9GgSlj1+2Cj7Kb3P1dUHwPZf0GrxwIb8CEgahJjnvkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T106dF+MwfXjY1yUmA/eQXWJqrVUBPFTMHg/nznmxqQWM/NCDR4/Gmj1Genb+zB8V
	 MAwYw5bcE9IT/t69VoRjpBir7EoiYbD3T+Lt3r0d+plI6hhv8BjWmOkLtThslq4nq0
	 xOyW1UdMr9b+deGviBkClTLBpsk+XjqC8ToxOO1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 064/319] ASoC: meson: axg-fifo: request the irq with the clock enabled
Date: Thu, 26 Nov 2026 15:37:12 +0100
Message-ID: <20261126144008.183416536@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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
index 5218e40aeb1bb..4a81aa3f384f0 100644
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



