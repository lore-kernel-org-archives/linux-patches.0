Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036411;
	b=i3w9q15aU4xE0XkG2mWBb9M8oysJg2/91t/zBe4a5H0QS2yGB4XMJfpaYWEw9Swc3NH2
	 JMDCbVUaWPkFRDyXQtTgY5arpawzd4fxCQ1GH6I6iX9xGxD27C/1nHCIbfqx7AvvMifc6
	 mUJdrNCEE39SFFhHZCBWceOp87x7NgvQF1jwuVj6lwHCz8X+KV3DDbPcZvixKWwxg1bIS
	 Iv1hTnVvZ4HSfKvkB+ALUyWgqGSKgh3fssoCWsDcz/MNphKtEpdRrm/60s5V+hq4N9iLr
	 C4dThcTLnWyMpDXlVZTxWYAUloK7nUA8LG0TOVVtvVEjlVVz3V90LFx+bxMkq2T9OHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036411;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m8JeWqjLysBHXXTiKpWg+Gs9OoD4N02GNRjHjTULddE=;
	b=i8OkmKi4Nx7s9wUK2GoL668pxHMWP3ZoR1o3z8jxdah93mcKclliLZpCbQvOXp12W6aB
	 A2EjzGdtNM0z9qd9oPaEhLN7m/s9TH0tpLD/AoXKP/x1Gkrd4MKVz7p4qdG5xttt5c/+b
	 9s/X0asaCkxNH0G4AbLHhh0UHPTShVCJWzx9D/6HBg3DXTbAuKuRgytgk2MNQGlTR6Lml
	 b3Au/6jmLYj/P5rQKQhJA8Zo27jooMft1yTB5oZqVjmd5VltxHrZ25dJH2yNoWkwFYde9
	 qV0ACp3NYiBnZcq33Bad094gZ6FUHddadiH3+JlbXucoZGDe4bgTstuo3wc8Bx2XzFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HbjmV5is;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE529606A320;
	Wed, 18 Nov 2026 21:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HbjmV5is
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092C61F000C4;
	Wed, 18 Nov 2026 21:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036411;
	bh=m8JeWqjLysBHXXTiKpWg+Gs9OoD4N02GNRjHjTULddE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HbjmV5ispVGTOt4fdy1y+58w9h6538h4i6UsBQDOr3zQAKviRBrAPyyn6J9hqzq93
	 jrvyEytWEeRuKGs2pkG7HJamg0+PL0MWCd9/mY/TZfmlN/VhgKmQ0Pk/S7zYX1YI2w
	 FSeLPmA98ekGTw0T27hlrjOB2E30J76EebYj7B10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1049/3318] soc: fsl: dpio: Free the IRQ before releasing the I/O object
Date: Wed, 18 Nov 2026 15:27:51 +0100
Message-ID: <20261118150351.390065020@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit a7831c657c90e8f9165f6bbe0cc56262fee075e8 ]

The DPIO interrupt handler accesses priv->io, but dpaa2_dpio_remove()
releases that object before tearing down the interrupts. The IRQ was
requested with devm_request_irq(), and unregister_dpio_irq_handlers()
only clears its affinity hint. fsl_mc_free_irqs() returns IRQ resources
to the MC resource pool without freeing the handler. An interrupt can
therefore access the freed I/O object before devres releases the IRQ.

Explicitly free the managed IRQ in unregister_dpio_irq_handlers() before
returning its resource to the pool, and perform IRQ teardown before
releasing the I/O object. This also waits for an in-flight handler while
the object is still valid.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: 993fec7e11ca ("bus: fsl-mc: dpio: add the DPAA2 DPIO object driver")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://lore.kernel.org/r/20261002194802.375497-3-mhun512@gmail.com
Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/dpio/dpio-driver.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/fsl/dpio/dpio-driver.c b/drivers/soc/fsl/dpio/dpio-driver.c
index 7dc65f38d2fdb..2962e66e2e413 100644
--- a/drivers/soc/fsl/dpio/dpio-driver.c
+++ b/drivers/soc/fsl/dpio/dpio-driver.c
@@ -88,6 +88,7 @@ static void unregister_dpio_irq_handlers(struct fsl_mc_device *dpio_dev)
 
 	/* clear the affinity hint */
 	irq_set_affinity_hint(irq->virq, NULL);
+	devm_free_irq(&dpio_dev->dev, irq->virq, &dpio_dev->dev);
 }
 
 static int register_dpio_irq_handlers(struct fsl_mc_device *dpio_dev, int cpu)
@@ -280,10 +281,10 @@ static void dpaa2_dpio_remove(struct fsl_mc_device *dpio_dev)
 	priv = dev_get_drvdata(dev);
 	cpu = dpaa2_io_get_cpu(priv->io);
 
-	dpaa2_io_down(priv->io);
-
 	dpio_teardown_irqs(dpio_dev);
 
+	dpaa2_io_down(priv->io);
+
 	cpumask_set_cpu(cpu, cpus_unused_mask);
 
 	err = dpio_open(dpio_dev->mc_io, 0, dpio_dev->obj_desc.id,
-- 
2.53.0



