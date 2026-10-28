Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216697;
	b=ALdfo3JzJ1l5zQEtG+UHJSjfWR5r7eN6NJihA6yZB7E3OMUQPnUqC1xqRFSNRKCzTruY
	 5Avq4+/qCTQJiVVDdxXTXQAdwIMgIKsYJskzhYzO8FWwXNcsOQw4MpWGXvC7tI+bZp8D1
	 kmRHIHcgWQLILk3DaaJ3tOl+/VfF1oJOD1+gE6/06bq3Hu4TuCoF7u8sg8U9xHg4X1AHn
	 5luFQc3MlY7wfDpUIGCmrXZcFktX65nA2DQwPqs5aM55AL11pa0+34swpc5Iktw/bDTpv
	 usri9lO+TyO4l9+aY8sCMbW0DyTJNXft1rNqxkXalw4ntC0OAMK3qDp8o9uGS1vPLPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216697;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NdoJqXHCXlLK0KiXed4eDSM5u/GlDQuvmr8Houpije0=;
	b=tlCZ/mu5Vh7FzgJRN2IWFHATSAESE6kJrcPXARPgdBKReET7otxpTwrUK4RD869g5yWu
	 SR+fBxS5U5WhxKP9a92hpN1TemOR1ADPE8DqwOfwEwxaUeYAV7iYo9ZU+sa0TCWUhlU6D
	 ZaKvyQtCSY3CFvZyE1meMhS7goqi0TOzqDAq9HGVN9afLa6WaEmCnw2AAcRR8fLtgpTE+
	 7TFlBrF+f01769XbB5iy5hjUim91Yvo1wiJ70SsJHWr8TkGNXrUrcvTC5UHgG+8rBRHEk
	 JWKONclj/uG/dK7SenOrZOMEX+SI88DvvIGDZ0Q9lU24GLzpNMosIJuVWV46b6hfolw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g7JKhUBO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D091D606A31A;
	Wed, 28 Oct 2026 19:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g7JKhUBO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB751F01825;
	Wed, 28 Oct 2026 19:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216696;
	bh=NdoJqXHCXlLK0KiXed4eDSM5u/GlDQuvmr8Houpije0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g7JKhUBOGClEcCmeFdOrFqbcbDPrF04xKK5P7jEGIOq9DhaVRYIK+dpXTw/LHdbYB
	 UKMabJb+R9qvKKpmBC5u/bVN/NXK+iWdYfyAZCuhJHs7M5z7tJjR7uM8EzWmHvKgAV
	 euIajcMyeR6aeosfroyjgpP5hp/sD2q9FxR6m7Xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1604/1887] spi: davinci: switch to managed controller allocation
Date: Wed, 28 Oct 2026 18:01:40 +0100
Message-ID: <20261028170535.970163991@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit ea408a05dc8f18b4a184b88d6e19d2fd1acc1527 ]

The controller is allocated with the non-managed spi_alloc_host() while
the interrupt is registered with devm_request_threaded_irq().  During
removal, spi_bitbang_stop() only unregisters the controller; the
subsequent spi_controller_put() then frees the controller together with
its embedded davinci_spi devdata, which is the IRQ handler's dev_id.
The devm_request_threaded_irq() release action (free_irq()), which
drains the handler, does not run until after .remove() returns.  A late
or latched interrupt can therefore reach davinci_spi_irq() and
dereference already-freed memory.

Switch to devm_spi_alloc_host() so that the devres LIFO order releases
the controller only after free_irq() has drained the handler, and drop
the now-redundant spi_controller_put() from .remove().  The probe error
path is simplified to direct returns.

The clock is acquired with devm_clk_get_enabled(), which is registered
after the IRQ and thus released before it by the devres LIFO order.
Drain the interrupt explicitly with devm_free_irq() before disabling the
controller so that a late interrupt cannot access the registers of a
clock-gated controller.

This issue was found by an in-house static analysis tool.

Fixes: 5b3bb5963ff2 ("spi: davinci: Use devm_*() functions")
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260719010014.3163356-2-fanwu01@zju.edu.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-davinci.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-davinci.c b/drivers/spi/spi-davinci.c
index d112c2cac042b..ce4689e96bad6 100644
--- a/drivers/spi/spi-davinci.c
+++ b/drivers/spi/spi-davinci.c
@@ -863,7 +863,7 @@ static int davinci_spi_probe(struct platform_device *pdev)
 	int ret = 0;
 	u32 spipc0;
 
-	master = spi_alloc_master(&pdev->dev, sizeof(struct davinci_spi));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(struct davinci_spi));
 	if (master == NULL) {
 		ret = -ENOMEM;
 		goto err;
@@ -1004,7 +1004,6 @@ static int davinci_spi_probe(struct platform_device *pdev)
 free_clk:
 	clk_disable_unprepare(dspi->clk);
 free_master:
-	spi_master_put(master);
 err:
 	return ret;
 }
@@ -1028,6 +1027,8 @@ static int davinci_spi_remove(struct platform_device *pdev)
 
 	spi_bitbang_stop(&dspi->bitbang);
 
+	devm_free_irq(&pdev->dev, dspi->irq, dspi);
+
 	clk_disable_unprepare(dspi->clk);
 
 	if (dspi->dma_rx) {
-- 
2.53.0



