Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624296;
	b=j9kDw4XpRaE9MKbP4VWefdT0LFLj7lJZ6BGzVKWFfA6MHN0lRIJAVUWFQclHSOcfreQR
	 wl2PHfh6g4onFXtQseyBpdUpzyy5CiRwKc9hdgl51KvJKDi8QPaG5ysuNwyg697cRITjT
	 xKM3tNqYjMRVUpohgRTHMGGWydhMZq93RsCiVNBH41I4c3Y2SbfeNICw46dcnknPCE4Gi
	 7kwd/gRYkvg72/jYexVjxmTX9MioOLV4dZxW78bgSR1xpKUI0RuYw9XaKCBNuuG61XYC7
	 k750JN1B6JeXLMalDgPt/H0i4NCDrxeowwlNs5FyC9MuHTJ8EMaCJx1jU/DUbfts8yA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624296;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yK4/7E6gHV6gqnk1xzTuW71MYh5AMgMTsCT/J7n/UWw=;
	b=iuPjBNB+utKbVMVv6ajC+yYlkW4j2TfauGetgemvLrv7MWO17X921HUt2gdNnIr9Yg7R
	 gLdIOjOHpo8JNp9EIGzNmmbRoIksAbszEx5UpPXkFxTeLGHOjjhjxQWrmQZIM+9n7FEbD
	 47OtsbNNeAm/3zysgmvsll5PYH7o4dPzSRkQHg/UScHikWgS0sNIvAEclqn53kgfxpjsz
	 TNRn4y9CcAZ4k00B18FaEHzOLav9uoYUy2vWp1QsP9sJbf++bHrUjrPMMOe3/s2ZO7rQq
	 GRi9Dm4n6l3JxNrMNnU+NJW2wVuVZTirEcx+zcGZuOtSadb9TDK9WwyShpmA+85PPsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hjJuOSzX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8F3606A333;
	Wed, 25 Nov 2026 16:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hjJuOSzX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F9B1F000D0;
	Wed, 25 Nov 2026 16:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624296;
	bh=yK4/7E6gHV6gqnk1xzTuW71MYh5AMgMTsCT/J7n/UWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hjJuOSzXJQFdiAwqwrTxMomVo6gSUdIqE0VRinOAx04W1YLp2fDUSBxcH+eSv5J+Z
	 an1dkdeKjFL5rxR+p817WFEUcvweXF4zhh3bHkVCdVFQHGC38gkc+jDS0MN4/Cc/qE
	 l6pei4VuFvXvbMUghOm8jZgjBp+QNYbn6+4DIO/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 147/816] ASoC: meson: axg-fifo: request the irq with the clock enabled
Date: Wed, 25 Nov 2026 15:28:15 +0100
Message-ID: <20261125143852.600034020@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



