Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045401;
	b=w6EaSh/nsHWgAY/0UzoJ4vMB5NzJTNeW0B/CjHnCWC4K9eOOG3y5Br3NprhOv1sWUpjO
	 +rsCU7U93wPyYi6yKZAtEw+Z81i1d/LxwBiovAy9iWGbT77Ze1ggTpsqdyZtvkFPmzP8Q
	 chc5nnKapZ6DlhZ4ghKNpK1XoSd2JsasVnthUzyRR147ggvLHK+fo9bfZ9S6FhYSh1kwb
	 Ds8IqNehZVUhOLCM71kYgOoZ8WHh8Da96nU5MkrnbuM/71m2j7pO7zH4uh2+B//Q51uvr
	 BXdgA9b99KTj2AZOP09xTXprziTE33HMLSKiV6bt665DVnGkVC8VBfD94vqzEc8C5bQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045401;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eFzGSssjRKtt4uom2fSNlGDwrCMQlfCAmkWnOBU3ho4=;
	b=GxYN01hzAPFNpwOziUnomJsXVjWzZJFVkHO/UOPDPoUZhXH0fLM9b+CDLY7RzRypQ4eh
	 tg5Uq+TgTjwVfoBUrp1a33wvRkAJ+nMovA7FgPBx5S2UDsM4vxdbPq0O5xzbU7BfAmxG3
	 eP292GRA32jXWzA9cJOm1LuGIK0ClaxbKSppoQEu1/cc2pQFuNpfEa7wd7Gr807Xghvu4
	 bWgFjI9bNLECHVIjcteF60mzF5kKppeTQd2skloVYdzRegvyrOT2P7T9BOsGwUpy6qenw
	 iDEoMuiItEAZaf1I/4jXk9AuwxHADh26uwFhnrUtLhAKX+OhBtMmKHzEs3DmoWLrGYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ilxkJ3bz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AEF4606A320;
	Wed, 18 Nov 2026 23:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ilxkJ3bz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0F71F000C4;
	Wed, 18 Nov 2026 23:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045400;
	bh=eFzGSssjRKtt4uom2fSNlGDwrCMQlfCAmkWnOBU3ho4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ilxkJ3bzbJZAvWRP+i6bR80sY4CpxtbMeHuQCYVh0qNiFpAXCjIdtGH9rELl75Rdj
	 bUfRALM1KnxGbUvFZY6L7WVH0qIo98m530K5+4fUR/pQ+izS7c+Y0VUgaEBNeqhn53
	 UTUm/UXNuqlqq67jSVOu5+a5Qw03j3YOVP6BJuKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0910/2857] soc: fsl: dpio: Free the IRQ before releasing the I/O object
Date: Wed, 18 Nov 2026 15:32:24 +0100
Message-ID: <20261118150234.342850183@linuxfoundation.org>
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
index 310e241020481..f6c2ef799de74 100644
--- a/drivers/soc/fsl/dpio/dpio-driver.c
+++ b/drivers/soc/fsl/dpio/dpio-driver.c
@@ -89,6 +89,7 @@ static void unregister_dpio_irq_handlers(struct fsl_mc_device *dpio_dev)
 
 	/* clear the affinity hint */
 	irq_set_affinity_hint(irq->virq, NULL);
+	devm_free_irq(&dpio_dev->dev, irq->virq, &dpio_dev->dev);
 }
 
 static int register_dpio_irq_handlers(struct fsl_mc_device *dpio_dev, int cpu)
@@ -281,10 +282,10 @@ static int dpaa2_dpio_remove(struct fsl_mc_device *dpio_dev)
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



